import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/controllers/ThemeController.dart';
import 'package:password_book_flutter/helpers/DatabaseHelper.dart';
import 'package:password_book_flutter/helpers/EncryptionHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

import '../../entity/user.dart';
import '../../entity/PasswordEntry.dart';
import '../Home/HomeController.dart';

class SettingsController extends GetxController{
  TextEditingController usernameController = TextEditingController();
  final TextEditingController originPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  final RxBool _isPressCancel = false.obs;
  bool get isPressCancel => _isPressCancel.value;
  set isPressCancel(bool value) => _isPressCancel.value = value;

  final RxBool _isPressConfirm = false.obs;
  bool get isPressConfirm => _isPressConfirm.value;
  set isPressConfirm(bool value) => _isPressConfirm.value = value;

  @override
  void dispose() {
    super.dispose();
  }

  void onUpdateUsername() async {
    User? currentUser = AuthHelper().currentUser!;
    User updateUser = currentUser.copyWith(
      username: usernameController.text
    );
    Databasehelper().updateUser(updateUser);
    AuthHelper().updateCurrentUser();
  }

  @override
  void onClose() {
    originPasswordController.dispose();
    usernameController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();

    super.onClose();
  }

  Future<bool> onChangePassword() async {
    User? currentUser = AuthHelper().currentUser;
    if (currentUser == null) {
      SnackBarHelper.showSnackbar('修改失败', '用户未登录', false);
      return false;
    }

    String originPassword = originPasswordController.text;
    String newPassword = newPasswordController.text;

    try {
      // 验证原密码是否正确
      bool isPasswordValid = await EncryptionHelper.verifyPassword(
        originPassword,
        currentUser.salt,
        currentUser.passwordHash
      );

      if (!isPasswordValid) {
        SnackBarHelper.showSnackbar('修改失败', '原密码错误', false);
        return false;
      }

      // 获取所有密码条目
      List<PasswordEntry> allEntries = await Databasehelper().getAllPasswordEntries(currentUser.id!);

      // 用原密码解密所有密码条目，获取明文密码
      List<Map<String, String>> decryptedPasswords = [];
      for (final entry in allEntries) {
        String decryptedPassword = await EncryptionHelper().decryptPassword(
          entry.encryptedPassword,
          entry.nonce,
          entry.mac
        );
        if (decryptedPassword.isEmpty) {
          SnackBarHelper.showSnackbar('修改失败', '解密密码项失败', false);
          return false;
        }
        decryptedPasswords.add({
          'id': entry.id.toString(),
          'password': decryptedPassword
        });
      }

      // 生成新的盐值和密码哈希
      String newSalt = EncryptionHelper.generateSalt();
      String newPasswordHash = await EncryptionHelper.hashPassword(newPassword, newSalt);

      // 用新密码派生新的密钥
      String newSecretKey = await EncryptionHelper().deriveSecretKey(newPassword, newSalt);

      // 设置新的密钥到EncryptionHelper
      EncryptionHelper().setSerectKey(newSecretKey);

      // 用新密钥重新加密所有密码条目
      List<PasswordEntry> updatedEntries = [];
      for (int i = 0; i < allEntries.length; i++) {
        PasswordEntry entry = allEntries[i];
        String plainPassword = decryptedPasswords[i]['password']!;

        // 用新密钥加密密码
        var secretBox = await EncryptionHelper().encryptPassword(plainPassword);
        String newEncryptedPassword = base64Encode(secretBox.cipherText);
        String newNonce = base64Encode(secretBox.nonce);
        String newMac = base64Encode(secretBox.mac.bytes);

        // 创建更新后的密码条目
        PasswordEntry updatedEntry = entry.copyWith(
          encryptedPassword: newEncryptedPassword,
          nonce: newNonce,
          mac: newMac,
          updatedAt: DateTime.now()
        );
        updatedEntries.add(updatedEntry);
      }

      // 更新用户信息（新的盐值和密码哈希）
      User updateUser = currentUser.copyWith(
        salt: newSalt,
        passwordHash: newPasswordHash,
        updatedAt: DateTime.now()
      );
      await Databasehelper().updateUser(updateUser);

      // 批量更新所有密码条目
      if (updatedEntries.isNotEmpty) {
        await Databasehelper().batchUpdatePasswordEntries(updatedEntries);
      }

      // 更新当前用户信息
      AuthHelper().updateCurrentUser();

      // 清空输入框
      originPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      // 刷新 Home 页面的数据，确保使用最新的加密数据
      try {
        final homeController = Get.find<Homecontroller>();
        await homeController.getAllPasswordEntries();
      } catch (e) {
        // HomeController 可能不存在，忽略错误
        print('刷新 Home 页面数据失败: $e');
      }

      return true;
    } catch (e) {
      SnackBarHelper.showSnackbar('修改失败', '发生错误: $e', false);
      return false;
    }
  }

  void initializeForm(String username) {
      usernameController.text = username;
  }

  // 使用ThemeController的状态作为单一数据源
  bool get isDarkMode => ThemeController.to.themeMode == ThemeMode.dark;

  // 切换黑夜模式，同时更新应用主题并保存到数据库
  void toggleDarkMode() {
    ThemeController.to.toggleThemeMode();
  }

  // 登出方法，清除用户信息并跳转到登录页面
  void logout(){
    AuthHelper().logout();
    Get.offAllNamed('/Login');
  }




}
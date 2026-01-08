import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/controllers/ThemeController.dart';
import 'package:password_book_flutter/helpers/DatabaseHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

import '../entity/user.dart';
import 'HomeController.dart';

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
    String originPassword = originPasswordController.text;
    String newPassword = newPasswordController.text;

    final response = await AuthHelper().changeMasterPassword(originPassword, newPassword);

    if (response.success) {
      // 清空输入框
      originPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      // 刷新 Home 页面的数据
      try {
        final homeController = Get.find<HomeController>();
        await homeController.getAllPasswordEntries();
      } catch (e) {
        print('刷新 Home 页面数据失败: $e');
      }

      return true;
    } else {
      SnackBarHelper.showSnackbar('修改失败', response.message, false);
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
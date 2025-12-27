import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/DatabaseHelper.dart';
import 'package:password_book_flutter/helpers/EncryptionHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

import '../../entity/PasswordEntry.dart';
import '../../entity/user.dart';
import '../Home/HomeController.dart';

class BackupController extends GetxController {
  final TextEditingController backupPasswordController = TextEditingController();

  final RxString encryptedBackup = ''.obs;
  final RxInt exportedCount = 0.obs;
  final RxBool isBackupCreated = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool backupPasswordObscure = true.obs;

  final TextEditingController restorePasswordController = TextEditingController();
  final TextEditingController restoreDataController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final RxBool isRestoring = false.obs;
  final RxBool currentPasswordObscure = true.obs;
  final RxBool restorePasswordObscure = true.obs;

  final Homecontroller homeController = Get.find();
  

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    backupPasswordController.dispose();
    restorePasswordController.dispose();
    restoreDataController.dispose();
    currentPasswordController.dispose();
    super.onClose();
  }

  void resetBackupState() {
    backupPasswordController.clear();
    encryptedBackup.value = '';
    exportedCount.value = 0;
    isBackupCreated.value = false;
    isLoading.value = false;
    backupPasswordObscure.value = true;
  }

  void resetRestoreState() {
    restorePasswordController.clear();
    restoreDataController.clear();
    currentPasswordController.clear();
    isRestoring.value = false;
    currentPasswordObscure.value = true;
    restorePasswordObscure.value = true;
  }

  Future<bool> createBackup() async {
    try {
      isLoading.value = true;

      User? currentUser = AuthHelper().currentUser;
      if (currentUser == null) {
        SnackBarHelper.showSnackbar('错误', '用户未登录', false);
        return false;
      }

      String backupPassword = backupPasswordController.text;

      if (backupPassword.isEmpty) {
        SnackBarHelper.showSnackbar('错误', '请输入备份主密码', false);
        return false;
      }

      List<PasswordEntry> allEntries = await Databasehelper().getAllPasswordEntries(currentUser.id!);

      if (allEntries.isEmpty) {
        SnackBarHelper.showSnackbar('提示', '没有密码数据可以备份', false);
        return false;
      }

      List<Map<String, dynamic>> decryptedEntries = [];
      for (final entry in allEntries) {
        String decryptedPassword = await EncryptionHelper().decryptPassword(
          entry.encryptedPassword,
          entry.nonce,
          entry.mac,
        );
        decryptedEntries.add({
          'title': entry.title,
          'username': entry.username,
          'password': decryptedPassword,
          'website': entry.website,
          'note': entry.note,
        });
      }

      String backupSalt = EncryptionHelper.generateSalt();
      String backupSecretKey = await EncryptionHelper().deriveSecretKey(backupPassword, backupSalt);
      EncryptionHelper().setSerectKey(backupSecretKey);

      List<Map<String, dynamic>> encryptedEntries = [];
      for (final entry in decryptedEntries) {
        var secretBox = await EncryptionHelper().encryptPassword(entry['password']);
        encryptedEntries.add({
          'title': entry['title'],
          'username': entry['username'],
          'password': base64Encode(secretBox.cipherText),
          'nonce': base64Encode(secretBox.nonce),
          'mac': base64Encode(secretBox.mac.bytes),
          'website': entry['website'],
          'note': entry['note'],
        });
      }

      Map<String, dynamic> backupData = {
        'salt': backupSalt,
        'entries': encryptedEntries,
        'timestamp': DateTime.now().toIso8601String(),
      };

      String jsonString = jsonEncode(backupData);
      encryptedBackup.value = base64Encode(utf8.encode(jsonString));
      exportedCount.value = allEntries.length;
      isBackupCreated.value = true;

      return true;
    } catch (e) {
      SnackBarHelper.showSnackbar('错误', '创建备份失败: $e', false);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> copyToClipboard() async {
    try {
      await Clipboard.setData(ClipboardData(text: encryptedBackup.value));
      SnackBarHelper.showSnackbar('成功', '已复制到剪贴板', true);
    } catch (e) {
      SnackBarHelper.showSnackbar('错误', '复制失败: $e', false);
    }
  }

  Future<bool> restoreBackup() async {
    try {
      isRestoring.value = true;

      User? currentUser = AuthHelper().currentUser;
      if (currentUser == null) {
        SnackBarHelper.showSnackbar('错误', '用户未登录', false);
        return false;
      }

      String restorePassword = restorePasswordController.text;
      String restoreData = restoreDataController.text;
      String currentPassword = currentPasswordController.text;

      if (currentPassword.isEmpty) {
        SnackBarHelper.showSnackbar('错误', '请输入当前主密码', false);
        return false;
      }

      if (restorePassword.isEmpty) {
        SnackBarHelper.showSnackbar('错误', '请输入备份主密码', false);
        return false;
      }

      if (restoreData.isEmpty) {
        SnackBarHelper.showSnackbar('错误', '请输入备份数据', false);
        return false;
      }

      // 验证当前主密码是否正确
      bool isCurrentPasswordValid = await EncryptionHelper.verifyPassword(
        currentPassword,
        currentUser.salt,
        currentUser.passwordHash,
      );

      if (!isCurrentPasswordValid) {
        SnackBarHelper.showSnackbar('错误', '当前主密码错误，请重新输入', false);
        return false;
      }

      try {
        String jsonString = utf8.decode(base64Decode(restoreData));
        Map<String, dynamic> backupData = jsonDecode(jsonString);

        if (!backupData.containsKey('salt') || !backupData.containsKey('entries')) {
          SnackBarHelper.showSnackbar('错误', '备份数据格式错误', false);
          return false;
        }

        String backupSalt = backupData['salt'];
        List<dynamic> entries = backupData['entries'];

        String backupSecretKey = await EncryptionHelper().deriveSecretKey(restorePassword, backupSalt);
        EncryptionHelper().setSerectKey(backupSecretKey);

        List<Map<String, dynamic>> decryptedEntries = [];
        for (var entry in entries) {
          try {
            String encryptedPassword = entry['password'];
            String nonce = entry['nonce'];
            String mac = entry['mac'];

            String decryptedPassword = await EncryptionHelper().decryptPassword(
              encryptedPassword,
              nonce,
              mac,
            );

            decryptedEntries.add({
              'title': entry['title'],
              'username': entry['username'],
              'password': decryptedPassword,
              'website': entry['website'],
              'note': entry['note'],
            });
          } catch (e) {
            SnackBarHelper.showSnackbar('错误', '解密密码失败，请检查备份主密码是否正确以及备份数据是否完整', false);
            return false;
          }
        }

        String currentUserSecretKey = await EncryptionHelper().deriveSecretKey(
          currentPassword,
          currentUser.salt,
        );
        EncryptionHelper().setSerectKey(currentUserSecretKey);

        List<PasswordEntry> newEntries = [];
        for (var entry in decryptedEntries) {
          var secretBox = await EncryptionHelper().encryptPassword(entry['password']);
          PasswordEntry newEntry = PasswordEntry(
            userId: currentUser.id!,
            title: entry['title'],
            username: entry['username'],
            encryptedPassword: base64Encode(secretBox.cipherText),
            nonce: base64Encode(secretBox.nonce),
            mac: base64Encode(secretBox.mac.bytes),
            website: entry['website'],
            note: entry['note'],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          newEntries.add(newEntry);
        }

        final db = await Databasehelper().database;
        await db.delete('password_entries');

        for (var entry in newEntries) {
          await Databasehelper().insertPasswordEntry(entry);
        }

        SnackBarHelper.showSnackbar('成功', '成功恢复 ${newEntries.length} 项密码数据', true);
        
        homeController.getAllPasswordEntries();

        return true;
      } catch (e) {
        SnackBarHelper.showSnackbar('错误', '备份数据格式错误或解密失败: $e', false);
        return false;
      }
    } catch (e) {
      SnackBarHelper.showSnackbar('错误', '恢复备份失败: $e', false);
      return false;
    } finally {
      isRestoring.value = false;
    }
  }
}

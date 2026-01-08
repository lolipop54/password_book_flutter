import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

import 'HomeController.dart';

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

  final HomeController homeController = Get.find();
  

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

      String backupPassword = backupPasswordController.text;

      if (backupPassword.isEmpty) {
        SnackBarHelper.showSnackbar('错误', '请输入备份主密码', false);
        return false;
      }

      final response = await AuthHelper().createBackup(backupPassword);

      if (response.success) {
        encryptedBackup.value = response.message;
        exportedCount.value = response.data;
        isBackupCreated.value = true;
        return true;
      } else {
        SnackBarHelper.showSnackbar('错误', response.message, false);
        return false;
      }
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

      final response = await AuthHelper().restoreBackup(currentPassword, restorePassword, restoreData);

      if (response.success) {
        SnackBarHelper.showSnackbar('成功', '成功恢复 ${response.data} 项密码数据', true);
        homeController.getAllPasswordEntries();
        return true;
      } else {
        SnackBarHelper.showSnackbar('错误', response.message, false);
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

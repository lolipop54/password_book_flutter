import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/controllers/ThemeController.dart';

class SettingsController extends GetxController{
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
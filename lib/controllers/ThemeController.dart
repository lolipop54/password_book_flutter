import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/DatabaseHelper.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _themeMode = ThemeMode.light.obs;
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  // 从数据库加载主题模式设置
  Future<void> _loadThemeMode() async {
    final db = Databasehelper();
    bool isDarkMode = await db.getDarkMode();
    _themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // 切换主题模式
  void toggleThemeMode() async {
    bool isCurrentlyDark = _themeMode.value == ThemeMode.dark;
    bool newDarkMode = !isCurrentlyDark;
    _themeMode.value = newDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    // 保存到数据库
    final db = Databasehelper();
    await db.setDarkMode(newDarkMode);
  }
}

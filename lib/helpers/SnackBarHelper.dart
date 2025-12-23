import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../pages/ui/colors.dart';

class SnackBarHelper {
  static void showSnackbar(String title, String message, bool success) {
    Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        // 显示在底部
        backgroundColor: colorDark.withOpacity(0.8),
        // 黑色半透明背景
        colorText: colorWhite,
        // 白色文字
        margin: EdgeInsets.all(10),
        // 外边距
        borderRadius: 10,
        // 圆角
        duration: Duration(milliseconds: 1500),
        // 显示时长
        icon: success
            ? Image.asset("assets/images/success.png", width: 16,)
            : Image.asset("assets/images/fail.png", width: 16,)
    );
  }
}
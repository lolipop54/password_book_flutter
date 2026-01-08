import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';
import 'package:password_book_flutter/controllers/SettingsController.dart';

import '../ui/colors.dart';

class Passwordmodifier extends StatefulWidget {
  const Passwordmodifier({super.key});

  @override
  State<Passwordmodifier> createState() => _PasswordmodifierState();
}

class _PasswordmodifierState extends State<Passwordmodifier> {
  SettingsController controller = Get.put(SettingsController());
  final _formKey = GlobalKey<FormState>();
  double paddingSafeAreaBottom = 0;
  // 三个密码输入框的显示/隐藏状态
  bool _obscureOriginPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;


  @override
  void initState() {
    super.initState();
  }


  Widget getInput(
    BuildContext context,
    String title,
    String? hintText,
    bool required,
    TextEditingController? TextController,
    String? Function(String?) validator,
    bool obscureText,
    VoidCallback? onToggleObscure,

  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '${title}*' : title,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onBackground,
              height: 1.1,
            ),
          ),
          //Form 3. 使用 TextFormField 替代 TextField
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              // Form 4. 配置验证逻辑
              validator: validator,
              controller: TextController,
              obscureText: obscureText,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                helperText: " ",
                // 给一个空格作为占位符
                helperStyle: TextStyle(height: 1),
                // 设定占位符高度
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                // 1. 常规状态下的边框 (未获得焦点时)
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  // 可选：设置圆角
                  borderSide: BorderSide(
                    width: 2.0, // 宽 2
                    color: Theme.of(
                      context,
                    ).inputDecorationTheme.enabledBorder!.borderSide.color,
                  ),
                ),
                // 2. 获得焦点时的边框 (点击输入时)
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // 3. 错误状态下的边框
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // 4. 获得焦点时的错误边框
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                // 添加眼睛图标，用于切换密码显示/隐藏
                suffixIcon: onToggleObscure != null
                    ? IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: onToggleObscure,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).padding.bottom >= paddingSafeAreaBottom){
      paddingSafeAreaBottom = MediaQuery.of(context).padding.bottom;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-paddingSafeAreaBottom,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Text('修改主密码', style: TextStyle(fontSize: 48)),
                  ),
                  Image.asset('assets/images/lock.png', width: 64),
                  getInput(
                    context,
                    "当前主密码",
                    '请输入当前主密码',
                    true,
                    controller.originPasswordController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "密码不能为空";
                      }
                      if (value.length < 6) {
                        return "密码长度不能少于6位";
                      }
                      if (value.contains(" ")) {
                        return "密码不能包含空格";
                      }
                      return null;
                    },
                    _obscureOriginPassword,
                    () {
                      setState(() {
                        _obscureOriginPassword = !_obscureOriginPassword;
                      });
                    },
                  ),
                  getInput(
                    context,
                    "新主密码",
                    '请输入新主密码',
                    true,
                    controller.newPasswordController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "密码不能为空";
                      }
                      if (value.length < 6) {
                        return "密码长度不能少于6位";
                      }
                      if (value.contains(" ")) {
                        return "密码不能包含空格";
                      }
                      return null;
                    },
                    _obscureNewPassword,
                    () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  getInput(
                    context,
                    "确认新主密码",
                    '请确认新主密码',
                    true,
                    controller.confirmNewPasswordController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "密码不能为空";
                      }
                      if (value != controller.newPasswordController.text) {
                        return "两次输入的密码不一致";
                      }
                      return null;
                    },
                    _obscureConfirmPassword,
                    () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          onTapDown: (_) => controller.isPressCancel = true,
                          onTapUp: (_) => controller.isPressCancel = false,
                          onTapCancel: () => controller.isPressCancel = false,
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            alignment: Alignment.center,
                            width: 160,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: controller.isPressCancel
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 4,
                              ),
                            ),
                            child: Text(
                              "取   消",
                              style: TextStyle(
                                color: controller.isPressCancel
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).colorScheme.primary,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              bool success = await controller.onChangePassword();
                              if(!success){
                                return;
                              }
                                Get.back();
                              SnackBarHelper.showSnackbar('修改成功', '主密码已更新', true);
                            }
                          },
                          onTapDown: (_) => controller.isPressConfirm = true,
                          onTapUp: (_) => controller.isPressConfirm = false,
                          onTapCancel: () => controller.isPressConfirm = false,
                          child: Container(
                            alignment: Alignment.center,
                            width: 160,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: controller.isPressConfirm
                                  ? colorWhite
                                  : Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 4,
                              ),
                            ),
                            child: Text(
                              "更   新",
                              style: TextStyle(
                                color: controller.isPressConfirm
                                    ? Theme.of(context).colorScheme.primary
                                    : colorWhite,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

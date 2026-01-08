import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';
import 'package:password_book_flutter/controllers/SettingsController.dart';

import '../ui/colors.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  SettingsController controller = Get.put(SettingsController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double paddingSafeAreaBottom = 0;
  @override
  void initState() {
    super.initState();
    // 初始化表单数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeForm(AuthHelper().currentUser?.username ?? '');
    });
  }

  Widget getInput(
    BuildContext context,
    String title,
    TextEditingController TextController,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "${title}不能为空"; // 返回错误提示文字
                }
                return null; // 返回 null 代表验证通过
              },
              controller: TextController,
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
                hintText: "请输入${title}",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
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
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Text('编辑用户信息', style: TextStyle(fontSize: 48)),
                ),
                Image.asset('assets/images/lock.png', width: 64),
                Form(
                  key: _formKey,
                  child: getInput(
                    context,
                    "用户名",
                    controller.usernameController,
                  ),
                ),
                // 添加底部间距，确保按钮有足够的空间
                Spacer(),
                // 按钮区域
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
                          if(!_formKey.currentState!.validate()){
                            return ;
                          }
                          controller.onUpdateUsername();
                          Get.back();
                          SnackBarHelper.showSnackbar('更新成功', '用户名已更新', true);
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
                // 添加额外的底部间距，确保按钮下方也有空间
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

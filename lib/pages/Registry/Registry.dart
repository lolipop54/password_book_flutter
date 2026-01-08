import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/widgets/DoubleBackToExitWrapper.dart';
import 'package:password_book_flutter/controllers/UserController.dart';
import 'package:password_book_flutter/widgets/ActionButton.dart';

class Registry extends StatelessWidget {
  const Registry({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset("assets/images/lock.png", width: 64),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: "注册\n",
                          style: TextStyle(
                              fontSize: 64,
                              color: Theme.of(context).colorScheme.onBackground),
                          children: [
                            TextSpan(
                              text: "注册一个新账号",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(
                      key: controller.registryFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "用户名",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onBackground,
                              height: 1.1,
                            ),
                          ),
                          Container(
                            height: 75,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "用户名不能为空";
                                }
                                final RegExp nameExp =
                                    RegExp(r'^[0-9a-zA-Z_\u4e00-\u9fa5]+$');
                                if (!nameExp.hasMatch(value)) {
                                  return "用户名只能包含字母、数字、下划线和中文";
                                }
                                return null;
                              },
                              controller: controller.registryUsernameController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                helperText: " ",
                                helperStyle: TextStyle(height: 1),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder!
                                        .borderSide
                                        .color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                hintText: "请输入用户名",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6)),
                              ),
                            ),
                          ),
                          Text(
                            "主密码",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onBackground,
                              height: 1.1,
                            ),
                          ),
                          Container(
                            height: 75,
                            child: Obx(
                              () => TextFormField(
                                validator: (value) {
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
                                controller: controller.registryPasswordController,
                                obscureText: controller.registryObscureText,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  helperText: " ",
                                  helperStyle: TextStyle(height: 1),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .enabledBorder!
                                          .borderSide
                                          .color,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  hintText: "请输入主密码",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.registryObscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                                    onPressed: controller.toggleRegistryObscure,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "再次输入主密码",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onBackground,
                              height: 1.1,
                            ),
                          ),
                          Container(
                            height: 75,
                            child: Obx(
                              () => TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "密码不能为空";
                                  }
                                  if (value !=
                                      controller.registryPasswordController.text) {
                                    return "两次输入的密码不一致";
                                  }
                                  return null;
                                },
                                obscureText: controller.registryObscureText2,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  helperText: " ",
                                  helperStyle: TextStyle(height: 1),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .enabledBorder!
                                          .borderSide
                                          .color,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  hintText: "请再次输入主密码",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.registryObscureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                                    onPressed: controller.toggleRegistryObscure2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          ActionButton(
                            text: "注    册",
                            onTap: controller.onRegister,
                            width: MediaQuery.of(context).size.width * 0.9,
                            primaryColor: Theme.of(context).colorScheme.surface,
                            secondaryColor:
                                Theme.of(context).colorScheme.primary,
                            borderColor: Theme.of(context).colorScheme.primary,
                            textColorPressed:
                                Theme.of(context).colorScheme.primary,
                            textColorNormal:
                                Theme.of(context).colorScheme.onError,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("已有账号？",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Get.offNamed("/Login");
                                },
                                child: Text(
                                  "登录",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

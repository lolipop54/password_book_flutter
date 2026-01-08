import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/widgets/DoubleBackToExitWrapper.dart';
import 'package:password_book_flutter/controllers/UserController.dart';
import 'package:password_book_flutter/widgets/ActionButton.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
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
                          text: "登录\n",
                          style: TextStyle(
                              fontSize: 64,
                              color: Theme.of(context).colorScheme.onBackground),
                          children: [
                            TextSpan(
                              text: "登录已有账号",
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
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  return null;
                                },
                                controller: controller.loginPasswordController,
                                obscureText: controller.loginObscureText,
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
                                      controller.loginObscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                                    onPressed: controller.toggleLoginObscure,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          ActionButton(
                            text: "登    录",
                            onTap: controller.onLogin,
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
                              Text("未注册账号？",
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
                                  Get.offNamed("/Registry");
                                },
                                child: Text(
                                  "去注册",
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

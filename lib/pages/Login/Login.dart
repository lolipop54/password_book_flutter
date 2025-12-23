import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:password_book_flutter/entity/myResponse.dart';
import 'package:password_book_flutter/helpers/DatabaseHelper.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';

import '../../helpers/SnackBarHelper.dart';
import '../ui/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String username = _usernameController.text;
    String password = _passwordController.text;
    myResponse response = await AuthHelper().verifyUser(username, password);

    if (response.success) {
      SnackBarHelper.showSnackbar("登录成功", "欢迎使用罐头密码簿", response.success);
      Get.offNamed("/Main");
    } else {
      SnackBarHelper.showSnackbar("登录失败", response.message, response.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  // 设置了alignment，子组件的宽高设置才会生效
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Image.asset("assets/images/lock.png", width: 64),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text.rich(
                    TextSpan(
                      text: "登录\n",
                      style: TextStyle(fontSize: 64, color: colorDark),
                      children: [
                        TextSpan(
                          text: "登录已有账号",
                          style: TextStyle(fontSize: 15, color: colorGray),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Form(
                    key: _formKey,
                    // 绑定 Key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "用户名",
                          style: TextStyle(
                            fontSize: 15,
                            color: colorDark,
                            height: 1.1,
                          ),
                        ),
                        //Form 3. 使用 TextFormField 替代 TextField
                        Container(
                          height: 75,
                          child: TextFormField(
                            // Form 4. 配置验证逻辑
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "用户名不能为空"; // 返回错误提示文字
                              }
                              if (value.length < 4) {
                                return "用户名长度不能少于4位";
                              }
                              return null; // 返回 null 代表验证通过
                            },
                            controller: _usernameController,
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
                                  color: colorInputBorder,
                                ),
                              ),
                              // 2. 获得焦点时的边框 (点击输入时)
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: colorPrimary,
                                ),
                              ),
                              // 3. 错误状态下的边框
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: colorPrimary,
                                ),
                              ),
                              // 4. 获得焦点时的错误边框
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: colorPrimary,
                                ),
                              ),
                              hintText: "请输入用户名",
                              hintStyle: TextStyle(color: colorGray),
                            ),
                          ),
                        ),

                        Text(
                          "密码",
                          style: TextStyle(
                            fontSize: 15,
                            color: colorDark,
                            height: 1.1,
                          ),
                        ),
                        Container(
                          height: 75,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "密码不能为空";
                              }
                              if (value.length < 6) {
                                return "密码长度不能少于6位";
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: _obscureText,
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
                                  color: colorInputBorder,
                                ),
                              ),
                              // 2. 获得焦点时的边框 (点击输入时)
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: colorPrimary,
                                ),
                              ),
                              // 3. 错误状态下的边框
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: colorPrimary,
                                ),
                              ),
                              // 4. 获得焦点时的错误边框
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: colorPrimary,
                                ),
                              ),
                              hintText: "请输入密码",
                              hintStyle: TextStyle(color: colorGray),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colorGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: _onLogin,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorPrimary,
                            ),
                            child: Text(
                              "登    录",
                              style: TextStyle(color: colorWhite, fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("未注册账号？", style: TextStyle(color: colorDark)),
                            TextButton(
                              style: TextButton.styleFrom(
                                //1. 去除边距
                                padding: EdgeInsets.all(0),
                                // 2. 去除最小尺寸限制
                                minimumSize: Size.zero,
                                // 3. 收缩点击区域（改为紧贴内容，不再向外扩展）
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Get.offNamed("/Registry");
                              },
                              child: Text(
                                "去注册",
                                style: TextStyle(color: colorPrimary),
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
    );
  }
}

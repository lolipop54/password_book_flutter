import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:password_book_flutter/entity/myResponse.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/DatabaseHelper.dart';
import 'package:password_book_flutter/entity/user.dart';

import '../../helpers/SnackBarHelper.dart';
import '../ui/colors.dart';

class Registry extends StatefulWidget {
  const Registry({super.key});

  @override
  State<Registry> createState() => _RegistryState();
}

class _RegistryState extends State<Registry> {
  // Form 1. 创建全局 Key，用来控制 Form 的状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText2 = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    //Form 5. 点击按钮时触发验证
    if (_formKey.currentState!.validate()) {
      // 验证通过，执行注册逻辑
      print("验证通过！");
    } else {
      // 验证失败，Form 会自动把错误信息显示在输入框下方
      print("验证失败");
      return;
    }
    String username = _usernameController.text;
    String password = _passwordController.text;

    myResponse response = await AuthHelper().registerSingleUser(
      username,
      password,
    );
    if (response.success) {
      // 注册成功，跳转登录或主页
      SnackBarHelper.showSnackbar("注册成功", "请登录罐头密码簿", response.success);

      Get.offNamed("/Login");
    } else {
      SnackBarHelper.showSnackbar("注册失败", response.message, response.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // column没有宽度，需要父组件包一个container指定全屏宽度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      text: "注册\n",
                      style: TextStyle(fontSize: 64, color: colorDark),
                      children: [
                        TextSpan(
                          text: "注册一个新账号",
                          style: TextStyle(fontSize: 15, color: colorGray),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  //Form 2. 使用 Form 组件包裹你的输入区域
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
                              // 正则校验：只允许 0-9 a-z, A-Z, _
                              final RegExp nameExp = RegExp(r'^[0-9a-zA-Z_]+$');
                              // 必须是整个字符串完整匹配上才为true，因为nameExp有^$符号
                              if (!nameExp.hasMatch(value)) {
                                return "用户名只能包含字母和下划线";
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
                              // 通常密码不允许包含空格，但允许 !@#% 等特殊字符
                              if (value.contains(" ")) {
                                return "密码不能包含空格";
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

                        Text(
                          "再次输入密码",
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
                              if (value != _passwordController.text) {
                                return "两次输入的密码不一致";
                              }
                              return null;
                            },
                            obscureText: _obscureText2,
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
                              hintText: "请再次输入密码",
                              hintStyle: TextStyle(color: colorGray),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colorGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText2 = !_obscureText2;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: _onRegister,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorPrimary,
                            ),
                            child: Text(
                              "注    册",
                              style: TextStyle(color: colorWhite, fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("已有账号？", style: TextStyle(color: colorDark)),
                            TextButton(
                              style: TextButton.styleFrom(
                                //1. 去除边距
                                padding: EdgeInsets.all(0),
                                // 2. 去除最小尺寸限制（默认是 48x48 或 64x40）
                                minimumSize: Size.zero,
                                // 3. 收缩点击区域（改为紧贴内容，不再向外扩展）
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Get.offNamed("/Login");
                              },
                              child: Text(
                                "登录",
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

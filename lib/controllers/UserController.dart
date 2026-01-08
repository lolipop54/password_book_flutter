import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/myResponse.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

class UserController extends GetxController {
  // ========================== 登录 State ==========================
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late TextEditingController loginPasswordController;

  final RxBool _loginObscureText = true.obs;
  bool get loginObscureText => _loginObscureText.value;
  set loginObscureText(bool value) => _loginObscureText.value = value;

  // ========================== 注册 State ==========================
  final GlobalKey<FormState> registryFormKey = GlobalKey<FormState>();
  late TextEditingController registryUsernameController;
  late TextEditingController registryPasswordController;

  final RxBool _registryObscureText = true.obs;
  bool get registryObscureText => _registryObscureText.value;
  set registryObscureText(bool value) => _registryObscureText.value = value;

  final RxBool _registryObscureText2 = true.obs;
  bool get registryObscureText2 => _registryObscureText2.value;
  set registryObscureText2(bool value) => _registryObscureText2.value = value;

  // ========================== 生命周期 ==========================
  @override
  void onInit() {
    super.onInit();
    loginPasswordController = TextEditingController();
    registryUsernameController = TextEditingController();
    registryPasswordController = TextEditingController();
  }

  // ========================== 登录 Logic ==========================
  void toggleLoginObscure() {
    loginObscureText = !loginObscureText;
  }

  void onLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    String password = loginPasswordController.text;
    myResponse response = await AuthHelper().verifyUser(password);

    if (response.success) {
      SnackBarHelper.showSnackbar("登录成功", "欢迎使用罐头密码簿，${response.message}", response.success);
      Get.offNamed("/Main");
    } else {
      SnackBarHelper.showSnackbar("登录失败", response.message, response.success);
    }
  }

  // ========================== 注册 Logic ==========================
  void toggleRegistryObscure() {
    registryObscureText = !registryObscureText;
  }

  void toggleRegistryObscure2() {
    registryObscureText2 = !registryObscureText2;
  }

  void onRegister() async {
    if (!registryFormKey.currentState!.validate()) {
      return;
    }
    String username = registryUsernameController.text;
    String password = registryPasswordController.text;

    myResponse response = await AuthHelper().registerSingleUser(
      username,
      password,
    );
    if (response.success) {
      SnackBarHelper.showSnackbar("注册成功", "请登录罐头密码簿", response.success);
      Get.offNamed("/Login");
    } else {
      SnackBarHelper.showSnackbar("注册失败", response.message, response.success);
    }
  }
}

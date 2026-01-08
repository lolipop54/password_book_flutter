import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../entity/PasswordEntry.dart';
import '../helpers/AuthHelper.dart';
import '../helpers/DatabaseHelper.dart';
import '../helpers/EncryptionHelper.dart';
import '../helpers/SnackBarHelper.dart';

import 'HomeController.dart';

class PasswordInfocontroller extends GetxController{
  TextEditingController titleController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  //详情页是否显示明文密码
  final RxBool _isShowPassword = false.obs;
  bool get isShowPassword => _isShowPassword.value;
  set isShowPassword(bool value) => _isShowPassword.value = value;

  final RxBool _isPressDelete = false.obs;
  bool get isPressDelete => _isPressDelete.value;
  set isPressDelete(bool value) => _isPressDelete.value = value;

  final RxBool _isPressConfirm = false.obs;
  bool get isPressConfirm => _isPressConfirm.value;
  set isPressConfirm(bool value) => _isPressConfirm.value = value;

  final RxBool _isPressRamdom = false.obs;
  bool get isPressRamdom => _isPressRamdom.value;
  set isPressRamdom(bool value) => _isPressRamdom.value = value;

  final RxBool _isPressCopy = false.obs;
  bool get isPressCopy => _isPressCopy.value;
  set isPressCopy(bool value) => _isPressCopy.value = value;

  final _selectedLength = 4.obs;
  int get selectedLength => _selectedLength.value;
  set selectedLength(int value) => _selectedLength.value = value;

  final _selectedSymbols = '包含'.obs;
  String get selectedSymbols => _selectedSymbols.value;
  set selectedSymbols(String value) => _selectedSymbols.value = value;

  final _generatePassword = ''.obs;
  String get generatePassword => _generatePassword.value;
  set generatePassword(String value) => _generatePassword.value = value;

  // 是否是更新模式
  final RxBool _isUpdateMode = false.obs;
  bool get isUpdateMode => _isUpdateMode.value;
  set isUpdateMode(bool value) => _isUpdateMode.value = value;
  
  // 当前更新的密码条目ID
  final RxInt _updateEntryId = (-1).obs;
  int get updateEntryId => _updateEntryId.value;
  set updateEntryId(int value) => _updateEntryId.value = value;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  HomeController homeController = Get.find<HomeController>();



  void onSubmit() async{
    if (!keyForm.currentState!.validate()) {
      return;
    }

    final secretBox = await EncryptionHelper().encryptPassword(passwordController.text);
    final nonce = base64Encode(secretBox.nonce);
    final encryptedPassword = base64Encode(secretBox.cipherText);
    final mac = base64Encode(secretBox.mac.bytes);

    final entry = PasswordEntry(
      title: titleController.text,
      username: usernameController.text,
      encryptedPassword: encryptedPassword,
      website: websiteController.text,
      note: noteController.text,
      userId: AuthHelper().currentUser!.id!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      usedCount: 0,
      mac: mac,
      nonce: nonce
    );

    Databasehelper().insertPasswordEntry(entry);
    Get.back();
    homeController.getAllPasswordEntries();
  }
  
  // 更新密码条目
  void onUpdate(PasswordEntry entryArg) async {
    try{
      if (!keyForm.currentState!.validate()) {
      return;
    }
    // 如果密码被修改了，需要重新加密
    String encryptedPassword;
    String nonce;
    String mac;
    


    // 检查密码是否被修改
    if (passwordController.text == entryArg.encryptedPassword) {
      // 密码没有修改，使用原来的加密密码
      // 需要从数据库获取原始条目来获取加密信息
      PasswordEntry? originalEntry = await Databasehelper().getPasswordEntryById(updateEntryId);
      if (originalEntry != null) {
        encryptedPassword = originalEntry.encryptedPassword;
        nonce = originalEntry.nonce;
        mac = originalEntry.mac;
      } else {
        // 如果获取不到原始条目，则重新加密
        final secretBox = await EncryptionHelper().encryptPassword(passwordController.text);
        nonce = base64Encode(secretBox.nonce);
        encryptedPassword = base64Encode(secretBox.cipherText);
        mac = base64Encode(secretBox.mac.bytes);
      }
    } else {
      // 密码被修改了，重新加密
      final secretBox = await EncryptionHelper().encryptPassword(passwordController.text);
      nonce = base64Encode(secretBox.nonce);
      encryptedPassword = base64Encode(secretBox.cipherText);
      mac = base64Encode(secretBox.mac.bytes);
    }

    final entry = entryArg.copyWith(
      id: updateEntryId,
      title: titleController.text,
      username: usernameController.text,
      encryptedPassword: encryptedPassword,
      website: websiteController.text,
      note: noteController.text,
      userId: AuthHelper().currentUser!.id!,
      updatedAt: DateTime.now(),
      mac: mac,
      nonce: nonce
    );

    await Databasehelper().updatePasswordEntry(entry);
    
    // 返回用于显示的 entry (密码字段为明文)
    final displayEntry = entry.copyWith(encryptedPassword: passwordController.text);
    Get.back(result: displayEntry);
    
    homeController.getAllPasswordEntries();
    }catch(e,stack){
      print(e);
      print(stack);
      SnackBarHelper.showSnackbar('更新失败', "更新过程中发生错误: ${e.toString()}", false);
    }
  }

  void onToGeneratePage(){
    Get.toNamed('/generate');
  }

  void toggleShowPassword(){
    isShowPassword = !isShowPassword;
  }

  @override
  void onClose() {
    titleController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    noteController.dispose();
    
    // 重置初始化标志
    _isFormInitialized = false;

    super.onClose();
  }

  Future<dynamic> onTapUpdate(PasswordEntry entry) async {
    // 设置为更新模式
    isUpdateMode = true;
    updateEntryId = entry.id!;
    
    // 设置表单初始值
    titleController.text = entry.title;
    usernameController.text = entry.username;
    passwordController.text = entry.encryptedPassword;
    websiteController.text = entry.website ?? '';
    noteController.text = entry.note ?? '';
    
    return Get.toNamed('/Password', arguments: entry);
  }
  
  // 是否已经初始化过表单
  bool _isFormInitialized = false;
  
  // 初始化表单数据（用于更新模式）
  void initializeForm(PasswordEntry? entry) {
    // 如果已经初始化过，则不再重复初始化
    if (_isFormInitialized) return;
    
    if (entry != null) {
      isUpdateMode = true;
      updateEntryId = entry.id!;
      
      titleController.text = entry.title;
      usernameController.text = entry.username;
      passwordController.text = entry.encryptedPassword;
      websiteController.text = entry.website ?? '';
      noteController.text = entry.note ?? '';
    } else {
      // 新增模式，清空表单
      isUpdateMode = false;
      updateEntryId = -1;
      
      titleController.clear();
      usernameController.clear();
      passwordController.clear();
      websiteController.clear();
      noteController.clear();
    }
    
    // 标记表单已初始化
    _isFormInitialized = true;
  }

  void onCopy(String password){
    Clipboard.setData(ClipboardData(text: password));
    SnackBarHelper.showSnackbar('复制成功', '现在可以去粘贴你的密码啦', true);
  }

  void onGeneratePassword(){
    generatePassword = EncryptionHelper.generateRandomPassword(
      length: selectedLength,
      includeSymbols: selectedSymbols == '包含',
    );
  }

  Future<void> onDeletePassword(int id) async {
    try {
      await Databasehelper().deletePasswordEntry(id);
      Get.back(); // 返回上一页 (Home)
      homeController.getAllPasswordEntries(); // 刷新列表
      SnackBarHelper.showSnackbar('删除成功', '密码条目已删除', true);
    } catch (e) {
      print(e);
      SnackBarHelper.showSnackbar('删除失败', '删除过程中发生错误: ${e.toString()}', false);
    }
  }
}
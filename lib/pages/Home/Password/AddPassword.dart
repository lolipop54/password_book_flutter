import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/PasswordEntry.dart';
import 'package:password_book_flutter/pages/Home/Password/PasswordInfoController.dart';

import '../../ui/colors.dart';

class Addpassword extends StatefulWidget {
  Addpassword({super.key});

  @override
  State<Addpassword> createState() => _AddpasswordState();
}

class _AddpasswordState extends State<Addpassword> {
  late PasswordInfocontroller controller;
  PasswordEntry? entry; // 存储传入的参数
  bool isPressConfirm = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PasswordInfocontroller());
    
    // 获取传入的参数
    entry = Get.arguments;
    
    // 初始化表单数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeForm(entry);
    });
  }


  Widget getInput(BuildContext context, String title, bool required, TextEditingController TextController){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '${title}*': title,
            style: TextStyle(
              fontSize: 15,
              color: colorDark,
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
              if(!required){
                return null;
              }
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
                hintText: "请输入${title}",
                hintStyle: TextStyle(color: colorGray),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getNoteInput(BuildContext context, String title, bool required, TextEditingController TextController){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '${title}*': title,
            style: TextStyle(
              fontSize: 15,
              color: colorDark,
              height: 1.1,
            ),
          ),
          //Form 3. 使用 TextFormField 替代 TextField
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              minLines: 2,
              maxLines: 2,
              // Form 4. 配置验证逻辑
            validator: (value) {
              if(!required){
                return null;
              }
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
                hintText: "请输入${title}",
                hintStyle: TextStyle(color: colorGray),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: colorWhite,
          child: SingleChildScrollView(
            child: Form(
              key: controller.keyForm,
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Obx(() => Text(
                          controller.isUpdateMode ? "更新密码" : "添加密码",
                          style: TextStyle(fontSize: 64, color: colorDark),
                        )),
                      ),
                    getInput(context, "标题", true, controller.titleController),
                    getInput(context, "用户名", true, controller.usernameController),
                    getInput(context, "密码", true, controller.passwordController),
                    getInput(context, "网站/App名", false, controller.websiteController),
                    getNoteInput(context, '备注', false, controller.noteController),
                    GestureDetector(
                      onTap: (){
                        controller.onToGeneratePage();
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            alignment: Alignment.center,
                            width: 120,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorWhite,
                              border: Border.all(color: colorPrimary, width: 4),
                            ),
                            child: Text(
                              "生成密码",
                              style: TextStyle(color: colorPrimary, fontSize: 22),
                            ),
                          ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Obx(() => GestureDetector(
                      onTapDown: (_){
                        isPressConfirm = true;
                        setState(() {});
                      },
                      onTapUp: (_){
                        isPressConfirm = false;
                        setState(() {});
                      },
                      onTapCancel: (){
                        isPressConfirm = false;
                        setState(() {});
                      },
                      onTap: (){
                        if (controller.isUpdateMode) {
                          controller.onUpdate(entry!);
                        } else {
                          controller.onSubmit();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isPressConfirm ? colorWhite : colorPrimary,
                          border: Border.all(color: colorPrimary, width: 4)
                        ),
                        child: Text(
                          controller.isUpdateMode ? "更    新" : "确    定",
                          style: TextStyle(color: isPressConfirm? colorPrimary : colorWhite, fontSize: 25),
                        ),
                      ),
                    )),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );;
  }
}


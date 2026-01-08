import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/PasswordEntry.dart';
import 'package:password_book_flutter/controllers/PasswordInfoController.dart';
import 'package:password_book_flutter/widgets/ActionButton.dart';

class Addpassword extends StatefulWidget {
  Addpassword({super.key});

  @override
  State<Addpassword> createState() => _AddpasswordState();
}

class _AddpasswordState extends State<Addpassword> {
  late PasswordInfocontroller controller;
  PasswordEntry? entry; // 存储传入的参数

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

  Widget getInput(BuildContext context, String title, bool required,
      TextEditingController TextController) {
    return Container(
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
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              validator: (value) {
                if (!required) {
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                hintText: "请输入${title}",
                hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getNoteInput(BuildContext context, String title, bool required,
      TextEditingController TextController) {
    return Container(
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
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              minLines: 2,
              maxLines: 2,
              validator: (value) {
                if (!required) {
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                hintText: "请输入${title}",
                hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6)),
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
          color: Theme.of(context).colorScheme.surface,
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
                            style: TextStyle(
                                fontSize: 64,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          )),
                    ),
                    getInput(context, "标题", true, controller.titleController),
                    getInput(
                        context, "用户名", true, controller.usernameController),
                    getInput(
                        context, "密码", true, controller.passwordController),
                    getInput(
                        context, "网站/App名", false, controller.websiteController),
                    getNoteInput(
                        context, '备注', false, controller.noteController),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                        child: Container(
                          width: 120,
                          child: ActionButton(
                            text: "生成密码",
                            onTap: () {
                              controller.onToGeneratePage();
                            },
                            primaryColor: Theme.of(context).colorScheme.primary,
                            secondaryColor:
                                Theme.of(context).colorScheme.surface,
                            borderColor: Theme.of(context).colorScheme.primary,
                            textColorPressed:
                                Theme.of(context).colorScheme.onError,
                            textColorNormal:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(() => ActionButton(
                          text: controller.isUpdateMode ? "更    新" : "确    定",
                          onTap: () {
                            if (controller.isUpdateMode) {
                              controller.onUpdate(entry!);
                            } else {
                              controller.onSubmit();
                            }
                          },
                          width: MediaQuery.of(context).size.width * 0.9,
                          primaryColor: Theme.of(context).colorScheme.surface,
                          secondaryColor: Theme.of(context).colorScheme.primary,
                          borderColor: Theme.of(context).colorScheme.primary,
                          textColorPressed:
                              Theme.of(context).colorScheme.primary,
                          textColorNormal:
                              Theme.of(context).colorScheme.onError,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

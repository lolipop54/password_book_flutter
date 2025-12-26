import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/PasswordEntry.dart';
import 'package:password_book_flutter/helpers/EncryptionHelper.dart';

import '../../ui/colors.dart';
import 'PasswordInfoController.dart';

class PasswordDetails extends StatefulWidget {
  PasswordDetails({super.key});

  @override
  State<PasswordDetails> createState() => _PasswordDetailsState();
}

class _PasswordDetailsState extends State<PasswordDetails> {
  PasswordInfocontroller controller = Get.put(PasswordInfocontroller());
  late PasswordEntry entry;

  @override
  void initState() {
    super.initState();
    entry = Get.arguments;
  }

  String convertMonth(int month) {
    return switch (month) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      12 => 'Dec',
      _ => '',
    };
  }

  Widget _buildDateDetails(BuildContext context, DateTime datetime) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/date.png', width: 24, color: Theme.of(context).colorScheme.onSurface,),
          Text(
            "${datetime.day} ${convertMonth(datetime.month)} ${datetime.year}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteDetails(BuildContext context, String website) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/link.png', width: 24, color: Theme.of(context).colorScheme.onSurface,),
          Text(
            website,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameDetails(BuildContext context, String username) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/username.png', width: 24, color: Theme.of(context).colorScheme.onSurface,),
          Text(
            username,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordDetails(BuildContext context, String password) {
    return Obx(
          () =>
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 75,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/password.png', width: 24, color: Theme.of(context).colorScheme.onSurface,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.isShowPassword ? password : '********',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      iconSize: 26,
                      style: IconButton.styleFrom(
                        //1. 去除边距
                        padding: EdgeInsets.all(0),
                        // 3. 收缩点击区域（改为紧贴内容，不再向外扩展）
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        controller.toggleShowPassword();
                      },
                      icon: controller.isShowPassword
                          ? Icon(Icons.visibility_off, color: Theme.of(context).colorScheme.primary)
                          : Icon(Icons.visibility, color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      style: IconButton.styleFrom(
                        //1. 去除边距
                        padding: EdgeInsets.all(0),
                        // 3. 收缩点击区域（改为紧贴内容，不再向外扩展）
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        controller.onCopy(password);
                      },
                      icon: Image.asset('assets/images/copy.png', width: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildNoteDetails(BuildContext context, String note) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/edit.png', width: 24, color: Theme.of(context).colorScheme.onSurface,),
          Text(
            note,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() =>
                      GestureDetector(
                        onTap: () {
                          // 显示确认删除对话框
                          Get.defaultDialog(
                            title: "确认删除",
                            middleText: "确定要删除这条密码吗？删除后无法恢复。",
                            textConfirm: "删除",
                            textCancel: "取消",
                            confirmTextColor: colorWhite,
                            buttonColor: colorPrimary,
                            cancelTextColor: Theme.of(context).colorScheme.onSurface,
                            onConfirm: () {
                              Get.back(); // 关闭对话框
                              controller.onDeletePassword(entry.id!);
                            },
                          );
                        },
                        onTapDown: (_) => controller.isPressDelete = true,
                        onTapUp: (_) => controller.isPressDelete = false,
                        onTapCancel: () => controller.isPressDelete = false,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.center,
                          width: 160,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.isPressDelete ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
                          ),
                          child: Text(
                            "删   除",
                            style: TextStyle(color: controller.isPressDelete ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary, fontSize: 22),
                          ),
                        ),
                      )),
                  Obx(() =>
                      GestureDetector(
                        onTap: () async {
                          var result = await controller.onTapUpdate(entry);
                          if (result != null && result is PasswordEntry) {
                            setState(() {
                              entry = result;
                            });
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
                            color: controller.isPressConfirm ? colorWhite : colorPrimary,
                            border: Border.all(color: colorPrimary, width: 4),
                          ),
                          child: Text(
                            "更   新",
                            style: TextStyle(color: controller.isPressConfirm ? colorPrimary : colorWhite, fontSize: 25),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    entry.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 48, color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                SizedBox(height: 20),
                _buildDateDetails(context, entry.updatedAt ?? entry.createdAt!),
                if (entry.website != null && entry.website!.isNotEmpty)
                  _buildWebsiteDetails(context, entry.website!),
                _buildUsernameDetails(context, entry.username),
                _buildPasswordDetails(context, entry.encryptedPassword),
                //实际上跳转过来时已经解密了，在HomeController中可见
                if (entry.note != null && entry.note!.isNotEmpty)
                  _buildNoteDetails(context, entry.note!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/PasswordEntry.dart';
import 'package:password_book_flutter/widgets/ActionButton.dart';
import 'package:password_book_flutter/widgets/DetailRow.dart';

import '../ui/colors.dart';
import 'package:password_book_flutter/controllers/PasswordInfoController.dart';

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

  @override
  Widget build(BuildContext context) {
    DateTime datetime = entry.updatedAt ?? entry.createdAt!;
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
                  ActionButton(
                    text: "删   除",
                    onTap: () {
                      Get.defaultDialog(
                        title: "确认删除",
                        middleText: "确定要删除这条密码吗？删除后无法恢复。",
                        textConfirm: "删除",
                        textCancel: "取消",
                        confirmTextColor: colorWhite,
                        buttonColor: colorPrimary,
                        cancelTextColor:
                            Theme.of(context).colorScheme.onSurface,
                        onConfirm: () {
                          Get.back();
                          controller.onDeletePassword(entry.id!);
                        },
                      );
                    },
                    primaryColor: Theme.of(context).colorScheme.primary,
                    secondaryColor: Theme.of(context).colorScheme.surface,
                    borderColor: Theme.of(context).colorScheme.primary,
                    textColorPressed: Theme.of(context).colorScheme.onError,
                    textColorNormal: Theme.of(context).colorScheme.primary,
                  ),
                  ActionButton(
                    text: "更   新",
                    onTap: () async {
                      var result = await controller.onTapUpdate(entry);
                      if (result != null && result is PasswordEntry) {
                        setState(() {
                          entry = result;
                        });
                      }
                    },
                    primaryColor: Theme.of(context).colorScheme.surface,
                    secondaryColor: Theme.of(context).colorScheme.primary,
                    borderColor: Theme.of(context).colorScheme.primary,
                    textColorPressed: Theme.of(context).colorScheme.primary,
                    textColorNormal: Theme.of(context).colorScheme.onError,
                  ),
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
                    style: TextStyle(
                        fontSize: 48,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                SizedBox(height: 20),
                DetailRow(
                  iconPath: 'assets/images/date.png',
                  content: Text(
                    "${datetime.day} ${convertMonth(datetime.month)} ${datetime.year}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (entry.website != null && entry.website!.isNotEmpty)
                  DetailRow(
                    iconPath: 'assets/images/link.png',
                    content: Text(
                      entry.website!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                DetailRow(
                  iconPath: 'assets/images/username.png',
                  content: Text(
                    entry.username,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DetailRow(
                  iconPath: 'assets/images/password.png',
                  content: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.isShowPassword
                              ? entry.encryptedPassword
                              : '********',
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
                            padding: EdgeInsets.all(0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            controller.toggleShowPassword();
                          },
                          icon: controller.isShowPassword
                              ? Icon(Icons.visibility_off,
                                  color: Theme.of(context).colorScheme.primary)
                              : Icon(Icons.visibility,
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            controller.onCopy(entry.encryptedPassword);
                          },
                          icon: Image.asset('assets/images/copy.png', width: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                if (entry.note != null && entry.note!.isNotEmpty)
                  DetailRow(
                    iconPath: 'assets/images/edit.png',
                    content: Text(
                      entry.note!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

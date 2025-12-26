import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/Settings/SettingsController.dart';
import 'package:password_book_flutter/controllers/ThemeController.dart';

import '../ui/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Obx(
            () => Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Text(
                    '设置',
                    style: TextStyle(
                      fontSize: 64,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _buildListItems(
                  Image.asset(
                    'assets/images/username.png',
                    color: colorPrimary,
                    width: 36,
                  ),
                  '用户设置',
                ),
                ThemeController.to.themeMode == ThemeMode.dark
                    ? _buildListItems(
                        Image.asset(
                          'assets/images/Sun.png',
                          color: colorPrimary,
                          width: 36,
                        ),
                        '切换到白天模式',
                        onTap: () {
                          controller.toggleDarkMode();
                        },
                      )
                    : _buildListItems(
                        Image.asset(
                          'assets/images/Moon.png',
                          color: colorPrimary,
                          width: 36,
                        ),
                        '切换到黑夜模式',
                        onTap: () {
                          controller.toggleDarkMode();
                        },
                      ),
                SizedBox(height: 36),
                _buildListItems(
                  Image.asset(
                    'assets/images/Logout.png',
                    color: colorPrimary,
                    width: 36,
                  ),
                  '退出登录',
                  onTap: () {
                    // 显示确认对话框
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('确认登出'),
                          content: Text('确定要登出当前账户吗？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('取消',style: TextStyle(color: Theme.of(context).colorScheme.onBackground),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.logout();
                              },
                              child: Text('确定',style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItems(Widget icon, String text, {void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          icon,
          SizedBox(width: 10,),
          GestureDetector(
            onTap: onTap,
            child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 22)),
          ),
        ],
      ),
    );
  }
}

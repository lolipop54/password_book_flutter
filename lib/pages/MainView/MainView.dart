import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/ui/colors.dart';

import '../Home/Home.dart';
import '../Settings/Settings.dart';
import 'MainViewController.dart';

class Mainview extends StatelessWidget {
  Mainview({super.key});

  MainviewController controller = Get.put(MainviewController());

  final double buttonSize = 32;

  final List<Widget> pages = [Home(), Settings()];

  Widget getHomeIcon() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.currentTab = 0;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: colorDark, size: buttonSize),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: controller.currentTab == 0 ? true : false,
              child: Container(
                width: 10,
                height: 5,
                decoration: BoxDecoration(
                  color: colorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSettingsIcon() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.currentTab = 1;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, color: colorDark, size: buttonSize),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: controller.currentTab == 1 ? true : false,
              child: Container(
                width: 10,
                height: 5,
                decoration: BoxDecoration(
                  color: colorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => IndexedStack(index: controller.currentTab, children: pages),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorInputBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getHomeIcon(),
                        SizedBox(width: buttonSize),
                        getSettingsIcon(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: GestureDetector(
                    onTap: (){
                      Get.toNamed('/AddPassword');
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(
                        Icons.add,
                        color: colorWhite,
                        size: 32,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

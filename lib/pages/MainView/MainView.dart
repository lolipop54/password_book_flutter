import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/DoubleBackToExitWrapper.dart';
import 'package:password_book_flutter/pages/ui/colors.dart';

import '../Home/Home.dart';
import '../Settings/Settings.dart';
import 'MainViewController.dart';
class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {

  MainviewController controller = Get.put(MainviewController());

  final double buttonSize = 32;

  final List<Widget> pages = [Home(), Settings()];

  Widget getHomeIcon(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.currentTab = 0;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: Theme.of(context).colorScheme.secondary, size: buttonSize),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: controller.currentTab == 0 ? true : false,
              child: Container(
                width: 10,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSettingsIcon(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.currentTab = 1;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary, size: buttonSize),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: controller.currentTab == 1 ? true : false,
              child: Container(
                width: 10,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
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
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Obx(
                () => IndexedStack(index: controller.currentTab, children: pages),
              ),
              if(!isKeyboardVisible) Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getHomeIcon(context),
                          SizedBox(width: buttonSize),
                          getSettingsIcon(context),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    child: GestureDetector(
                      onTap: (){
                        Get.toNamed('/Password');
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
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
      ),
    );
  }
}

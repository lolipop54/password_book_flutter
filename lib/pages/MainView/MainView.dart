import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Generate/Generate.dart';
import '../Home/Home.dart';
import '../Settings/Settings.dart';
import 'MainViewController.dart';

class Mainview extends StatelessWidget {
  Mainview({super.key});

  MainviewController controller = Get.put(MainviewController());

  final List<Widget> pages = [Home(), Generate(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(child: IndexedStack(index: controller.currentTab, children: pages))),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentTab,
          onTap: (index) {
            controller.currentTab = index;
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.generating_tokens_outlined),
              label: 'Generate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

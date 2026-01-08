import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/widgets/CustomSearchBar.dart';
import 'package:password_book_flutter/widgets/PasswordCard.dart';
import 'package:password_book_flutter/widgets/TagSelector.dart';

import '../../entity/PasswordEntry.dart';
import 'package:password_book_flutter/controllers/HomeController.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(HomeController());

  Widget _buildCards(BuildContext context) {
    return Obx(
      () => Expanded(
        child: controller.displayList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/Search2.png'
                        : 'assets/images/Search.png',
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  Text('无密码项',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16)),
                  SizedBox(
                    height: 120,
                  ),
                ],
              )
            : ImplicitlyAnimatedList<PasswordEntry>(
                areItemsTheSame: (a, b) => a.id == b.id,
                items: controller.displayList.toList(),
                insertDuration: Duration(milliseconds: 500),
                removeDuration: Duration(milliseconds: 500),
                updateDuration: Duration(milliseconds: 500),
                itemBuilder: (context, animation, entry, index) {
                  return SizeFadeTransition(
                    curve: Curves.ease,
                    animation: animation,
                    child: PasswordCard(
                      entry: entry,
                      controller: controller,
                      lastMargin:
                          index == controller.displayList.toList().length - 1,
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("密码簿")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSearchBar(
              controller: controller.searchController,
              focusNode: controller.focusNode,
              onChanged: (text) => controller.onSearchTextChange(text),
              onClear: controller.onClearSearchText,
              isFocused: controller.isFocused,
            ),
            SizedBox(height: 20),
            Obx(
              () => TagSelector(
                selections: controller.selections,
                selectedId: controller.selectId,
                onSelect: (index) {
                  controller.selectId = index;
                  controller.changeSelection(index);
                },
              ),
            ),
            SizedBox(height: 20),
            _buildCards(context),
          ],
        ),
      ),
    );
  }
}

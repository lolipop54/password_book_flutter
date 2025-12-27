import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

import '../../entity/PasswordEntry.dart';
import '../ui/colors.dart';
import 'HomeController.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(Homecontroller());

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
                  Text('无密码项', style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 16)),
                  SizedBox(height: 120,),
                ],
              )
            : ImplicitlyAnimatedList<PasswordEntry>(
                areItemsTheSame: (a, b) => a.id == b.id,
                items: controller.displayList.toList(),
                // 3. 动画时长
                insertDuration: Duration(milliseconds: 500),
                removeDuration: Duration(milliseconds: 500),
                updateDuration: Duration(milliseconds: 500),
                itemBuilder: (context, animation, entry, index) {
                  return SizeFadeTransition(
                    curve: Curves.ease,
                    animation: animation,
                    child: _buildSingleCard(context,
                      entry,
                      index == controller.displayList.toList().length - 1,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSingleCard(BuildContext context, PasswordEntry entry, bool lastMargin) {
    return Obx(
      () => GestureDetector(
        // 长按开始
        onLongPressStart: (_) => controller.onLongPressStart(entry),
        // 长按结束（手指抬起）
        onLongPressEnd: (_) => controller.onLongPressEnd(),
        child: Container(
          key: ValueKey(entry.id),
          margin: lastMargin
              ? EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 110)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
              (controller.copiedId == entry.id) ||
                  (controller.longPressId == entry.id &&
                      controller.isLongPressBorderChanged)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
              width: 4,
            ),
            color:
                (controller.copiedId == entry.id) ||
                    (controller.longPressId == entry.id &&
                        controller.isLongPressBorderChanged)
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 64,
                height: 64,
                // 注意：这里用 ShapeDecoration
                decoration: ShapeDecoration(
                  color:
                      (controller.copiedId == entry.id) ||
                          (controller.longPressId == entry.id &&
                              controller.isLongPressBorderChanged)
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onBackground,
                  // 使用 ContinuousRectangleBorder
                  shape: ContinuousRectangleBorder(
                    // 注意：这里的数值需要比标准圆角大一些才能达到类似的视觉大小
                    // 比如标准圆角用 16，这里可能需要用 32 左右
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Center(
                  child: Text(
                    entry.title.substring(0, 1),
                    style: TextStyle(
                      fontSize: 24,
                      color:
                          (controller.copiedId == entry.id) ||
                              (controller.longPressId == entry.id &&
                                  controller.isLongPressBorderChanged)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  controller.copiedId == entry.id ? "已复制！" : entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color:
                        (controller.copiedId == entry.id) ||
                            (controller.longPressId == entry.id &&
                                controller.isLongPressBorderChanged)
                        ? Theme.of(context).colorScheme.onError
                        : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              if (controller.copiedId != entry.id)
                GestureDetector(
                  onLongPressStart: (_) {
                    //阻止复制按钮触发长按事件，长按事件不会冒泡到父组件
                  },
                  onTap: () {
                    controller.onCopy(entry);
                    SnackBarHelper.showSnackbar('密码已复制', '现在可以去粘贴你的密码啦', true);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/copy.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Obx(
                () => TextField(
                  onChanged: (text) => controller.onSearchTextChange(text),
                  focusNode: controller.focusNode,
                  controller: controller.searchController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
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
                        color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
                      ),
                    ),
                    // 2. 获得焦点时的边框 (点击输入时)
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    hintText: "搜索...",
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    suffixIcon: controller.isFocused.value
                        ? IconButton(
                            splashColor: Colors.transparent,
                            // 去除水波纹
                            highlightColor: Colors.transparent,
                            // 去除长按背景高亮
                            hoverColor: Colors.transparent,
                            // (可选) 去除鼠标悬停颜色
                            onPressed: controller.onClearSearchText,
                            icon: Image.asset(
                              "assets/images/back.png",
                              width: 24,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: List.generate(controller.selections.length, (index) {
                return Row(
                  children: [
                    SizedBox(width: 20),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.selectId = index;
                          controller.changeSelection(index);
                        },
                        child: controller.selectId == index
                            ? Container(
                                alignment: Alignment.center,
                                width: 64,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Text(
                                  controller.selections[index],
                                  style: TextStyle(color: Theme.of(context).colorScheme.onError),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: 64,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
                                ),
                                child: Text(controller.selections[index], style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 20),
            _buildCards(context),
          ],
        ),
      ),
    );
  }
}

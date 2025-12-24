import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

import '../ui/colors.dart';
import 'HomeController.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(Homecontroller());

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
                    hintText: "搜索...",
                    hintStyle: TextStyle(color: colorGray),
                    prefixIcon: Icon(Icons.search, color: colorGray),
                    suffixIcon: controller.isFocused.value
                        ? IconButton(
                            splashColor: Colors.transparent,
                            // 去除水波纹
                            highlightColor: Colors.transparent,
                            // 去除长按背景高亮
                            hoverColor: Colors.transparent,
                            // (可选) 去除鼠标悬停颜色
                            onPressed:
                              controller.onClearSearchText,
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
                                  color: colorPrimary,
                                ),
                                child: Text(
                                  controller.selections[index],
                                  style: TextStyle(color: colorWhite),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: 64,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colorInputBorder,
                                ),
                                child: Text(controller.selections[index]),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 20),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: controller.displayList.length,
                  itemBuilder: (context, index) {
                    final entry = controller.displayList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorInputBorder, width: 4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 64,
                            height: 64,
                            // 注意：这里用 ShapeDecoration
                            decoration: ShapeDecoration(
                              color: colorDark,
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
                                  color: colorWhite,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: colorDark,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: (){
                                  Clipboard.setData(ClipboardData(text: entry.encryptedPassword));
                                  controller.updateUsedCountAndLastUsedTime(entry);
                                  SnackBarHelper.showSnackbar('密码已复制', '现在可以去粘贴你的密码啦', true);
                                },
                              child: Padding(padding: EdgeInsets.all(10), child: Image.asset("assets/images/copy.png", width: 24,height: 24,))
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 110,)
          ],
        ),
      ),
    );
  }
}

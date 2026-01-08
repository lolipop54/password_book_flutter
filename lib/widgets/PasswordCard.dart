import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/PasswordEntry.dart';
import 'package:password_book_flutter/controllers/HomeController.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

class PasswordCard extends StatelessWidget {
  final PasswordEntry entry;
  final HomeController controller;
  final bool lastMargin;

  const PasswordCard({
    Key? key,
    required this.entry,
    required this.controller,
    this.lastMargin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onLongPressStart: (_) => controller.onLongPressStart(entry),
        onLongPressEnd: (_) => controller.onLongPressEnd(),
        child: Container(
          key: ValueKey(entry.id),
          margin: lastMargin
              ? EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 110)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (controller.copiedId == entry.id) ||
                      (controller.longPressId == entry.id &&
                          controller.isLongPressBorderChanged)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
              width: 4,
            ),
            color: (controller.copiedId == entry.id) ||
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
                decoration: ShapeDecoration(
                  color: (controller.copiedId == entry.id) ||
                          (controller.longPressId == entry.id &&
                              controller.isLongPressBorderChanged)
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Center(
                  child: Text(
                    entry.title.substring(0, 1),
                    style: TextStyle(
                      fontSize: 24,
                      color: (controller.copiedId == entry.id) ||
                              (controller.longPressId == entry.id &&
                                  controller.isLongPressBorderChanged)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
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
                    color: (controller.copiedId == entry.id) ||
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
                    // Prevent copy button from triggering long press on parent
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
}

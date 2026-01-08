import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final RxBool isFocused;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.isFocused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Obx(
        () => TextField(
          onChanged: onChanged,
          focusNode: focusNode,
          controller: controller,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.0,
                color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
              ),
            ),
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
            suffixIcon: isFocused.value
                ? IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onPressed: onClear,
                    icon: Image.asset(
                      "assets/images/back.png",
                      width: 24,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

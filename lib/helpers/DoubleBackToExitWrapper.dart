import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_book_flutter/helpers/SnackBarHelper.dart';

class DoubleBackToExitWrapper extends StatefulWidget {
  final Widget child;

  const DoubleBackToExitWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _DoubleBackToExitWrapperState createState() => _DoubleBackToExitWrapperState();
}

class _DoubleBackToExitWrapperState extends State<DoubleBackToExitWrapper> {
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        DateTime now = DateTime.now();
        if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = now;
          SnackBarHelper.showSnackbar("提示", "再按一次退出应用", true);
        } else {
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}

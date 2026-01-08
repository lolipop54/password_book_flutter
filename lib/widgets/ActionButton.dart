import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color secondaryColor;
  final Color borderColor;
  final Color textColorPressed;
  final Color textColorNormal;
  final double width;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
    required this.borderColor,
    required this.textColorPressed,
    required this.textColorNormal,
    this.width = 160,
  }) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: Container(
        alignment: Alignment.center,
        width: widget.width,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isPressed ? widget.primaryColor : widget.secondaryColor,
          border: Border.all(color: widget.borderColor, width: 4),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: isPressed ? widget.textColorPressed : widget.textColorNormal,
            fontSize: 22, // Adjusted font size slightly
          ),
        ),
      ),
    );
  }
}

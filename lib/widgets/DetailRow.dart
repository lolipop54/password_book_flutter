import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String iconPath;
  final Widget content;

  const DetailRow({
    Key? key,
    required this.iconPath,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          content,
        ],
      ),
    );
  }
}

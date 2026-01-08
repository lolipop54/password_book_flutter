import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagSelector extends StatelessWidget {
  final List<String> selections;
  final int selectedId;
  final Function(int) onSelect;

  const TagSelector({
    Key? key,
    required this.selections,
    required this.selectedId,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(selections.length, (index) {
        return Row(
          children: [
            SizedBox(width: 20),
            GestureDetector(
              onTap: () => onSelect(index),
              child: selectedId == index
                  ? Container(
                      alignment: Alignment.center,
                      width: 64,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        selections[index],
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
                      child: Text(selections[index],
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

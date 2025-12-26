import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/colors.dart';
import '../Password/PasswordInfoController.dart';

class Generate extends StatefulWidget {
  const Generate({super.key});

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  PasswordInfocontroller controller = Get.put(PasswordInfocontroller());



  @override
  void initState() {
    super.initState();
    controller.selectedLength = generateLength[4];
    controller.selectedSymbols = includeSymbols[1];
    controller.onGeneratePassword();
  }

  List<int> generateLength = [
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
  ];
  List<String> includeSymbols = ['包含', '不包含'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() =>
                      GestureDetector(
                        onTap: () {
                          controller.onGeneratePassword();
                        },
                        onTapDown: (_) => controller.isPressRamdom = true,
                        onTapUp: (_) => controller.isPressRamdom = false,
                        onTapCancel: () => controller.isPressRamdom = false,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.center,
                          width: 160,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.isPressRamdom ? colorPrimary : colorWhite,
                            border: Border.all(color: colorPrimary, width: 4),
                          ),
                          child: Text(
                            "随机生成",
                            style: TextStyle(color: controller.isPressRamdom ? colorWhite : colorPrimary, fontSize: 22),
                          ),
                        ),
                      )),
                  Obx(() =>
                      GestureDetector(
                        onTap: () {
                          controller.onCopy(controller.generatePassword);
                        },
                        onTapDown: (_) => controller.isPressCopy = true,
                        onTapUp: (_) => controller.isPressCopy = false,
                        onTapCancel: () => controller.isPressCopy = false,
                        child: Container(
                          alignment: Alignment.center,
                          width: 160,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.isPressCopy ? colorWhite : colorPrimary,
                            border: Border.all(color: colorPrimary, width: 4),
                          ),
                          child: Text(
                            "复   制",
                            style: TextStyle(color: controller.isPressCopy ? colorPrimary : colorWhite, fontSize: 25),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Text(
                    '生成密码',
                    style: TextStyle(fontSize: 64, color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                Obx(
                  () => Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 3, color: colorInputBorder),
                      color: Theme.of(context).colorScheme.surface
                    ),
                    child: Text(
                      controller.generatePassword,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 80,
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('密码长度'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            isExpanded: true,
                            items: generateLength
                                .map(
                                  (int item) => DropdownMenuItem<int>(
                                    value: item,
                                    child: Text(
                                      item.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                            value: controller.selectedLength,
                            onChanged: (int? value) {
                                controller.selectedLength = value!;
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color, width: 4),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down),
                              openMenuIcon: Icon(Icons.keyboard_arrow_up),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 160,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 80,
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('包含特殊符号'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: includeSymbols
                                .map(
                                  (String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                                .toList(),
                            value: controller.selectedSymbols,
                            onChanged: (String? value) {
                              setState(() {
                                controller.selectedSymbols = value!;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: colorInputBorder, width: 4),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down),
                              openMenuIcon: Icon(Icons.keyboard_arrow_up),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 160,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

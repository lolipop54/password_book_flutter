import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../helpers/DatabaseHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUsers();
  }

  void _checkUsers() async {
    // // 延迟一下显示启动画面
    await Future.delayed(const Duration(seconds: 1));

    bool hasUsers = await Databasehelper().hasUsers();
    if (hasUsers) {
      Get.offNamed("/Login");
    }else{
      Get.offNamed("/Registry");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/lock.png"),
                SizedBox(height: 5,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5),
                    color: Color(0xffff6464),
                  ),
                  height: 5,
                  width: 150,
                ),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "罐头",
                      style:TextStyle(
                        color: Color(0xffff6464),
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                      children: [
                        TextSpan(
                          text: "密码簿",
                          style: TextStyle(
                            color: Color(0xff545974),
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Text(
              "你的贴心密码管家",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );

  }
}

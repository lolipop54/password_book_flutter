import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/ui/colors.dart';

import '../pages/Home/Password/AddPassword.dart';
import '../pages/Home/Password/PasswordDetails.dart';
import '../pages/Login/Login.dart';
import '../pages/MainView/MainView.dart';
import '../pages/Registry/Registry.dart';
import '../pages/SplashScreen/SplashScreen.dart';

Widget getAppRoot(){
  return GetMaterialApp(
    getPages: getRoutes(),
    initialRoute: "/SplashScreen",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'myFont'
    ),
  );
}

List<GetPage> getRoutes(){
  return [
    GetPage(name: "/Main", page: () => Mainview()),
    GetPage(name: "/Login", page: () => Login()),
    GetPage(name: "/Registry", page: () => Registry()),
    GetPage(name: "/SplashScreen", page: () => SplashScreen()),
    GetPage(name: '/Password', page: () => Addpassword()),
    GetPage(name: '/details', page: () => PasswordDetails())
  ];
}
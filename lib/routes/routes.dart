import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/Settings/PasswordModifier.dart';
import 'package:password_book_flutter/pages/Settings/UserSettings.dart';
import 'package:password_book_flutter/pages/SplashScreen/XieJingXuan.dart';
import 'package:password_book_flutter/pages/ui/colors.dart';

import '../pages/Home/Generate.dart';
import '../pages/Home/AddPassword.dart';
import '../pages/Home/PasswordDetails.dart';
import '../pages/Login/Login.dart';
import '../pages/MainView/MainView.dart';
import '../pages/Registry/Registry.dart';
import '../pages/Settings/Backup.dart';
import '../pages/SplashScreen/SplashScreen.dart';



List<GetPage> getRoutes(){
  return [
    GetPage(name: "/Main", page: () => Mainview()),
    GetPage(name: "/Login", page: () => Login()),
    GetPage(name: "/Registry", page: () => Registry()),
    GetPage(name: "/SplashScreen", page: () => SplashScreen()),
    GetPage(name: '/Password', page: () => Addpassword()),
    GetPage(name: '/details', page: () => PasswordDetails()),
    GetPage(name: '/generate', page: () => Generate()),
    GetPage(name: '/userSettings', page: () => UserSettings()),
    GetPage(name: '/passwordModifier', page: () => Passwordmodifier()),
    GetPage(name: '/backup', page: () => Backup()),
  ];
}
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/MainView/MainView.dart';

class MainviewController extends GetxController {
  var _currentTab = 0.obs;
  get currentTab => _currentTab.value;
  set currentTab(int value) {
    _currentTab.value = value;
  }




}
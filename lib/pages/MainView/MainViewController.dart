import 'package:get/get.dart';
import 'package:password_book_flutter/pages/MainView/MainView.dart';

class MainviewController extends GetxController {
  var _currentTab = 0.obs;
  set currentTab(int value) {
    _currentTab.value = value;
    update();
  }
  get currentTab => _currentTab.value;



}
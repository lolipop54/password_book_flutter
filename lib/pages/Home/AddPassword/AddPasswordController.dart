import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/entity/PasswordEntry.dart';
import 'package:password_book_flutter/helpers/AuthHelper.dart';
import 'package:password_book_flutter/helpers/DatabaseHelper.dart';

import '../HomeController.dart';

class Addpasswordcontroller extends GetxController{
  TextEditingController titleController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  Homecontroller homecontroller = Get.find<Homecontroller>();

  void onSubmit(){
    if (!keyForm.currentState!.validate()) {
      return;
    }
    final entry = PasswordEntry(
      title: titleController.text,
      username: usernameController.text,
      encryptedPassword: passwordController.text,
      website: websiteController.text,
      note: noteController.text,
      userId: AuthHelper().currentUser!.id!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      usedCount: 0,
    );
    Databasehelper().insertPasswordEntry(entry);
    Get.back();
    homecontroller.getAllPasswordEntries();
  }

  void onToGeneratePage(){

  }
}
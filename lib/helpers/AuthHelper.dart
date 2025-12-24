import 'package:password_book_flutter/entity/myResponse.dart';
import './EncryptionHelper.dart';
import '../entity/user.dart';
import 'DatabaseHelper.dart';

class AuthHelper{
  AuthHelper._internal();
  static final instance = AuthHelper._internal();
  factory AuthHelper() => instance;

  User? currentUser = null;

  Future<myResponse> registerSingleUser(String username, String password) async{
    try{
      final dataBase = Databasehelper();
      bool existingUser = await dataBase.hasUsers();
      if(existingUser){
        return myResponse(success: false, message: "已存在用户，不允许多次注册");
      }

      //生成盐值
      String salt = EncryptionHelper.generateSalt();

      //密码用盐值+多次哈希加密
      String passwordHash = await EncryptionHelper.hashPassword(password, salt);

      User newUser = User(
        username: username,
        passwordHash: passwordHash,
        salt: salt,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      int id = await dataBase.insertUser(newUser.toMap());
      if(id > 0){
        return myResponse(success: true, message: "注册成功");
      }else{
        return myResponse(success: false, message: "注册失败");
      }
    }catch(e, stackTrace){
      print(e);
      print(stackTrace);
      return myResponse(success: false, message: e.toString());
    }
  }

  Future<myResponse> verifyUser(String password) async {
    try{
      User? user = await Databasehelper().getFirstUser();
      if (user == null) {
        return myResponse(success: false, message: "不存在帐户");
      }

      bool success = await EncryptionHelper.verifyPassword(
          password, user.salt, user.passwordHash);

      if (success) {
        currentUser = user;
        return myResponse(success: true, message: user.username);
      } else {
        return myResponse(success: false, message: "密码错误");
      }
    }catch(e, stackTrace) {
      print(e);
      print(stackTrace);
      return myResponse(success: false, message: e.toString());
    }
  }
}
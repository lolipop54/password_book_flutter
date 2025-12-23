import 'package:password_book_flutter/entity/myResponse.dart';
import './EncryptionHelper.dart';
import '../entity/user.dart';
import 'DatabaseHelper.dart';

class AuthHelper{
  AuthHelper._internal();
  static final instance = AuthHelper._internal();
  factory AuthHelper() => instance;

  Future<myResponse> registerSingleUser(String username, String password) async{
    try{
      final dataBase = Databasehelper();
      User? existingUser = await dataBase.getUser(username);
      if(existingUser != null){
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

  Future<myResponse> verifyUser(String username, String password) async {
    try{
      User? user = await Databasehelper().getUser(username);
      if (user == null) {
        return myResponse(success: false, message: "用户不存在");
      }

      bool success = await EncryptionHelper.verifyPassword(
          password, user.salt, user.passwordHash);

      if (success) {
        return myResponse(success: true, message: "登录成功");
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
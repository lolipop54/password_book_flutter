import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:password_book_flutter/entity/myResponse.dart';
import './EncryptionHelper.dart';
import '../entity/user.dart';
import '../entity/PasswordEntry.dart';
import 'DatabaseHelper.dart';
class AuthHelper{
  AuthHelper._internal();
  static final instance = AuthHelper._internal();
  factory AuthHelper() => instance;

  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;

  Future<myResponse> registerSingleUser(String username, String password) async{
    try{
      final dataBase = Databasehelper();
      bool existingUser = await dataBase.hasUsers();
      if(existingUser){
        return myResponse(success: false, message: "已存在用户，不允许多次注册");
      }

      //生成盐值
      String salt = EncryptionHelper.generateSalt();

      //密码用盐值+argon2id哈希加密
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

      if (!success) {
        return myResponse(success: false, message: "密码错误");
      }

      //生成加密密钥
      String secretKey = await EncryptionHelper().deriveSecretKey(password, user.salt);
      EncryptionHelper().setSerectKey(secretKey);

      _currentUser.value = user;
      return myResponse(success: true, message: user.username);

    }catch(e, stackTrace) {
      print(e);
      print(stackTrace);
      return myResponse(success: false, message: e.toString());
    }
  }

  void updateCurrentUser() async {
    User? user = await Databasehelper().getFirstUser();
    _currentUser.value = user;
  }

  // 登出方法，清除当前用户和加密密钥
  void logout(){
    _currentUser.value = null;
    EncryptionHelper().setSerectKey('');
  }

  // 修改主密码
  Future<myResponse> changeMasterPassword(String oldPassword, String newPassword) async {
    User? user = currentUser;
    if (user == null) return myResponse(success: false, message: "用户未登录");

    try {
      // 1. 验证旧密码
      bool isValid = await EncryptionHelper.verifyPassword(oldPassword, user.salt, user.passwordHash);
      if (!isValid) return myResponse(success: false, message: "原密码错误");

      // 2. 获取所有密码条目
      List<PasswordEntry> allEntries = await Databasehelper().getAllPasswordEntries(user.id!);

      // 3. 解密所有条目
      List<Map<String, String>> decryptedPasswords = [];
      for (final entry in allEntries) {
        String decrypted = await EncryptionHelper().decryptPassword(entry.encryptedPassword, entry.nonce, entry.mac);
        if (decrypted.isEmpty) return myResponse(success: false, message: "解密失败: 条目ID ${entry.id}");
        decryptedPasswords.add({'id': entry.id.toString(), 'password': decrypted});
      }

      // 4. 生成新 User 信息
      String newSalt = EncryptionHelper.generateSalt();
      String newHash = await EncryptionHelper.hashPassword(newPassword, newSalt);
      String newSecretKey = await EncryptionHelper().deriveSecretKey(newPassword, newSalt);

      // 5. 用新 Key 加密所有条目
      List<PasswordEntry> updatedEntries = [];
      for (int i = 0; i < allEntries.length; i++) {
        var plain = decryptedPasswords[i]['password']!;
        // 使用 customSecretKey 参数，避免修改全局 SecretKey
        var secretBox = await EncryptionHelper().encryptPassword(plain, customSecretKey: newSecretKey);
        
        updatedEntries.add(allEntries[i].copyWith(
          encryptedPassword: base64Encode(secretBox.cipherText),
          nonce: base64Encode(secretBox.nonce),
          mac: base64Encode(secretBox.mac.bytes),
          updatedAt: DateTime.now()
        ));
      }

      // 6. 更新数据库
      User newUser = user.copyWith(salt: newSalt, passwordHash: newHash, updatedAt: DateTime.now());
      await Databasehelper().updateUser(newUser);
      if (updatedEntries.isNotEmpty) {
        await Databasehelper().batchUpdatePasswordEntries(updatedEntries);
      }

      // 7. 更新当前 SerectKey 和 User
      EncryptionHelper().setSerectKey(newSecretKey);
      _currentUser.value = newUser;

      return myResponse(success: true, message: "修改成功");

    } catch (e) {
      return myResponse(success: false, message: "发生错误: $e");
    }
  }

  // 创建备份
  Future<myResponse> createBackup(String backupPassword) async {
    User? user = currentUser;
    if (user == null) return myResponse(success: false, message: "用户未登录");

    try {
      List<PasswordEntry> allEntries = await Databasehelper().getAllPasswordEntries(user.id!);
      if (allEntries.isEmpty) return myResponse(success: false, message: "没有数据可备份");

      // 1. 解密所有数据 (使用当前 SecretKey)
      List<Map<String, dynamic>> decryptedEntries = [];
      for (final entry in allEntries) {
        String decrypted = await EncryptionHelper().decryptPassword(entry.encryptedPassword, entry.nonce, entry.mac);
        decryptedEntries.add({
          'title': entry.title,
          'username': entry.username,
          'password': decrypted,
          'website': entry.website,
          'note': entry.note,
        });
      }

      // 2. 生成备份密钥
      String backupSalt = EncryptionHelper.generateSalt();
      String backupSecretKey = await EncryptionHelper().deriveSecretKey(backupPassword, backupSalt);

      // 3. 用备份密钥加密数据
      List<Map<String, dynamic>> encryptedEntries = [];
      for (final entry in decryptedEntries) {
        var secretBox = await EncryptionHelper().encryptPassword(entry['password'], customSecretKey: backupSecretKey);
        encryptedEntries.add({
          'title': entry['title'],
          'username': entry['username'],
          'password': base64Encode(secretBox.cipherText),
          'nonce': base64Encode(secretBox.nonce),
          'mac': base64Encode(secretBox.mac.bytes),
          'website': entry['website'],
          'note': entry['note'],
        });
      }

      // 4. 打包
      Map<String, dynamic> backupData = {
        'salt': backupSalt,
        'entries': encryptedEntries,
        'timestamp': DateTime.now().toIso8601String(),
      };

      String jsonString = jsonEncode(backupData);
      String result = base64Encode(utf8.encode(jsonString));
      
      return myResponse(success: true, message: result, data: allEntries.length); // data 用于返回数量

    } catch (e) {
      return myResponse(success: false, message: "创建备份失败: $e");
    }
  }

  // 恢复备份
  Future<myResponse> restoreBackup(String currentPassword, String backupPassword, String backupDataStr) async {
    User? user = currentUser;
    if (user == null) return myResponse(success: false, message: "用户未登录");

    try {
      // 1. 验证当前主密码
      bool isValid = await EncryptionHelper.verifyPassword(currentPassword, user.salt, user.passwordHash);
      if (!isValid) return myResponse(success: false, message: "当前主密码错误");

      // 2. 解析备份数据
      String jsonString = utf8.decode(base64Decode(backupDataStr));
      Map<String, dynamic> backupData = jsonDecode(jsonString);

      if (!backupData.containsKey('salt') || !backupData.containsKey('entries')) {
        return myResponse(success: false, message: "备份数据格式错误");
      }

      String backupSalt = backupData['salt'];
      List<dynamic> entries = backupData['entries'];

      // 3. 派生备份密钥
      String backupSecretKey = await EncryptionHelper().deriveSecretKey(backupPassword, backupSalt);

      // 4. 解密备份数据
      List<Map<String, dynamic>> decryptedEntries = [];
      for (var entry in entries) {
        try {
          String decrypted = await EncryptionHelper().decryptPassword(
            entry['password'], 
            entry['nonce'], 
            entry['mac'], 
            customSecretKey: backupSecretKey
          );
          
          decryptedEntries.add({
            'title': entry['title'],
            'username': entry['username'],
            'password': decrypted,
            'website': entry['website'],
            'note': entry['note'],
          });
        } catch (e) {
          return myResponse(success: false, message: "解密备份数据失败，请检查备份密码");
        }
      }

      // 5. 用当前用户密钥重新加密并存储
      // 重新派生密钥并更新，确保一致性
      String userSecretKey = await EncryptionHelper().deriveSecretKey(currentPassword, user.salt);
      EncryptionHelper().setSerectKey(userSecretKey);

      List<PasswordEntry> newEntries = [];
      for (var entry in decryptedEntries) {
        var secretBox = await EncryptionHelper().encryptPassword(entry['password']);
        newEntries.add(PasswordEntry(
          userId: user.id!,
          title: entry['title'],
          username: entry['username'],
          encryptedPassword: base64Encode(secretBox.cipherText),
          nonce: base64Encode(secretBox.nonce),
          mac: base64Encode(secretBox.mac.bytes),
          website: entry['website'],
          note: entry['note'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          usedCount: 0,
        ));
      }

      // 6. 覆盖数据库
      final db = await Databasehelper().database;
      await db.delete('password_entries'); // 清空旧数据!
      for (var entry in newEntries) {
        await Databasehelper().insertPasswordEntry(entry);
      }

      return myResponse(success: true, message: "恢复成功", data: newEntries.length);

    } catch (e) {
      return myResponse(success: false, message: "恢复失败: $e");
    }
  }
}
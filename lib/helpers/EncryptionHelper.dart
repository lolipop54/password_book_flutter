import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' hide Hmac;
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter/material.dart';
import 'package:password_book_flutter/entity/myResponse.dart';


class EncryptionHelper{
  static final EncryptionHelper _instance = EncryptionHelper._internal();
  factory EncryptionHelper() => _instance;
  EncryptionHelper._internal();

  Pbkdf2 pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 10000,     // 迭代次数，越高越安全但也越慢，推荐 10万+
    bits: 256,             // 生成 256 位密钥 (对应 AesGcm.with256bits)
  );
  AesGcm AES256 = AesGcm.with256bits();

  String _secretKey = '';

  void setSerectKey(String secretKey){
    _secretKey = secretKey;
  }

  Future<String> deriveSecretKey(String password, String salt) async{
    final saltBytes = base64Decode(salt);

    // 利用 主密码 + 盐 派生真正的 AES 密钥
    final SecretKey secretKey = await pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes, // PBKDF2 算法中，Salt 作为 nonce 参数传入
    );
    List<int> secretKeyBytes = await secretKey.extractBytes();

    return base64Encode(secretKeyBytes);
  }

  Future<SecretBox> encryptPassword(String password) async{
    // 每次加密都需要一个新的、随机的 Nonce
    final nonce = AES256.newNonce();

    final passwordBytes = utf8.encode(password);

    SecretBox secretBox = await AES256.encrypt(
      passwordBytes,
      secretKey: SecretKey(base64Decode(_secretKey)),
      nonce: nonce,
    );

    return secretBox;
  }

  Future<String> decryptPassword(String encryptedPassword, String nonce, String mac) async{
    // --- 解密过程 ---
    try {
      final secretBox = SecretBox(base64Decode(encryptedPassword),nonce: base64Decode(nonce), mac: Mac(base64Decode(mac)));

      final decryptedPassword = await AES256.decrypt(
        secretBox,
        secretKey: SecretKey(base64Decode(_secretKey)),
      );

      return utf8.decode(decryptedPassword);

    } catch (e) {
      print("解密失败: $e");
      throw Exception("解密失败: $e");
    }
  }

  // 生成随机盐
  static String generateSalt([int length = 32]) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  // 哈希主密码（用于登录验证）
  static Future<String> hashPassword(String password, String salt) async{
    final passwordBytes = utf8.encode(password);
    final saltBytes = base64Decode(salt);

    final _argon2 = Argon2id(
      parallelism: 2, // 并行线程数
      memory: 10 * 1024, // 内存消耗 (以 KB 为单位)，例如 19MB
      iterations: 2, // 迭代次数
      hashLength: 32, // 生成的哈希长度 (字节)
    );
    // 使用 deriveKey 进行哈希计算
    final secretKey = await _argon2.deriveKey(
      secretKey: SecretKey(passwordBytes),
      nonce: saltBytes, // Argon2 中将 salt 作为 nonce 传入
    );

    // 提取哈希后的字节
    final newSecretKeyBytes = await secretKey.extractBytes();

    return base64Encode(newSecretKeyBytes);
  }

  /// 验证密码
  /// [inputPassword]: 用户当前输入的明文密码
  /// [storedSalt]: 数据库中存储的盐值 (Base64 String)
  /// [storedHash]: 数据库中存储的哈希值 (Base64 String)
  static Future<bool> verifyPassword(
      String inputPassword, String storedSalt, String storedHash) async {
    try {
      // 1. 重新计算哈希
      // 直接复用 hashPassword 方法，确保使用完全相同的 Argon2 参数配置
      final calculatedHash = await hashPassword(inputPassword, storedSalt);

      // 2. 比较哈希值
      // 推荐使用常量时间比较 (Constant-time comparison) 以防止时序攻击
      return _constantTimeStringEquals(calculatedHash, storedHash);
    } catch (e) {
      // 如果 Salt 格式错误或计算出错，视为验证失败
      return false;
    }
  }

  /// 辅助函数：常量时间比较两个字符串 (防止时序攻击)
  /// 如果只使用普通 `==` 比较，在极高安全要求的场景下，黑客可能通过响应时间推测出哈希的前几位
  static bool _constantTimeStringEquals(String a, String b) {
    if (a.length != b.length) return false;

    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);

    int result = 0;
    for (int i = 0; i < aBytes.length; i++) {
      result |= aBytes[i] ^ bBytes[i];
    }
    return result == 0;
  }


}
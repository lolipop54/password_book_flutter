import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:flutter/material.dart';
import 'package:password_book_flutter/entity/myResponse.dart';


class EncryptionHelper{
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
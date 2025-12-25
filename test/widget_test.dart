// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:cryptography_plus/cryptography_plus.dart';
import 'dart:convert'; // 用于 utf8 编码
import 'dart:typed_data'; // 用于更方便的操作字节数据
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_book_flutter/helpers/EncryptionHelper.dart';

import 'package:password_book_flutter/main.dart';

void main() async{
    // --- 1. 模拟输入 ---
    final String userPassword = "my_master_password"; // 用户的主密码
    final String saltString = EncryptionHelper.generateSalt();    // 盐值(实际应用中应该是随机生成的16字节，并存储在数据库)
    final String textToEncrypt = "明文密码password";   // 要保存的网站密码

    print("--- 原始数据 ---");
    print("主密码: $userPassword");
    print("明文: $textToEncrypt");

    // --- 2. 密钥派生 (关键步骤) ---
    // 不能直接用 AES 加密主密码，需要用 PBKDF2 把主密码变成 AES 需要的 256位 密钥
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000,     // 迭代次数，越高越安全但也越慢，推荐 10万+
      bits: 256,             // 生成 256 位密钥 (对应 AesGcm.with256bits)
    );

    // 将 Salt 字符串转为字节 (实际项目中 Salt 应该是随机字节 List<int>)
    final List<int> saltBytes = utf8.encode(saltString);

    // 利用 主密码 + 盐 派生真正的 AES 密钥
    final SecretKey secretKey = await pbkdf2.deriveKeyFromPassword(
      password: userPassword,
      nonce: saltBytes, // PBKDF2 算法中，Salt 作为 nonce 参数传入
    );

    final secretKeyBytes = base64Encode(await secretKey.extractBytes());

    final secretKey2 = SecretKey(base64Decode(secretKeyBytes));
    // --- 3. 加密过程 ---
    final algorithm = AesGcm.with256bits(); // 建议升级到 256位

    // 每次加密都需要一个新的、随机的 Nonce
    final nonce = algorithm.newNonce();

    final messageBytes = utf8.encode(textToEncrypt);

    SecretBox secretBox = await algorithm.encrypt(
      messageBytes,
      secretKey: secretKey2,
      nonce: nonce,
    );

    // --- 4. 输出加密结果 ---
    print("\n--- 加密结果 ---");
    print("Salt (Hex): ${base64Encode(saltBytes)}");
    print("Nonce (Hex): ${base64Encode(secretBox.nonce)}"); // 必须保存这个
    print("Ciphertext (Hex): ${base64Encode(secretBox.cipherText)}");
    print("MAC (Hex): ${base64Encode(secretBox.mac.bytes)}");

    final Nonce = base64Encode(secretBox.nonce);
    final CipherText = base64Encode(secretBox.cipherText);
    final mac = base64Encode(secretBox.mac.bytes);

    // --- 5. 解密过程 ---
    try {
      secretBox = SecretBox(base64Decode(CipherText),nonce: base64Decode(Nonce), mac: Mac(base64Decode(mac)));
      // 注意：解密使用的是 decrypt 方法
      final decryptedData = await algorithm.decrypt(
        secretBox,
        secretKey: secretKey,
      );

      print("\n--- 解密结果 ---");
      print("解密成功: ${utf8.decode(decryptedData)}");
    } catch (e) {
      print("解密失败: $e");
    }
  }

// 辅助函数：将字节数组转为十六进制字符串方便打印查看
  String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }



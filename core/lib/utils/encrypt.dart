import 'package:encrypt/encrypt.dart';

String encrypt(String plainText) {
  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromUtf8('fixed16bytesiv12');

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}
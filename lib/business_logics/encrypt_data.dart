import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  //For AES Encryption/Decryption
  static final key = encrypt.Key.fromUtf8('1245714587458888');
  static final iv = encrypt.IV.fromUtf8('e16ce888a20dadb8');
  static final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  

}
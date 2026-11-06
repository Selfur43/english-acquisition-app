import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

final class PinHasher {
  const PinHasher({this.iterations = 120000});
  final int iterations;

  String createSalt() {
    final random = Random.secure();
    return base64UrlEncode(List<int>.generate(24, (_) => random.nextInt(256)));
  }

  String hash({required String pin, required String salt}) {
    var value = Uint8List.fromList(utf8.encode('$salt:$pin'));
    final key = utf8.encode(salt);
    for (var index = 0; index < iterations; index++) {
      value = Uint8List.fromList(Hmac(sha256, key).convert(value).bytes);
    }
    return base64UrlEncode(value);
  }

  bool verify({
    required String expectedHash,
    required String pin,
    required String salt,
  }) {
    final actual = hash(pin: pin, salt: salt);
    if (actual.length != expectedHash.length) return false;
    var difference = 0;
    for (var index = 0; index < actual.length; index++) {
      difference |= actual.codeUnitAt(index) ^ expectedHash.codeUnitAt(index);
    }
    return difference == 0;
  }
}

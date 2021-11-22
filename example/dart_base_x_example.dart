import 'dart:typed_data';

import 'package:dart_base_x/dart_base_x.dart';

void main() {
  String base58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  BaseXCodec bs58 = BaseXCodec(base58);

  Uint8List decoded =
      bs58.decode('5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr');

  print(decoded);
  // => [128, 237, 219, 220, 17, 104, 241, 218, 234, 219, 211, 228, 76, 30, 63, 143, 90, 40, 76, 32, 41, 247, 138, 210, 106, 249, 133, 131, 164, 153, 222, 91, 25, 19, 164, 248, 99]

  print(bs58.encode(decoded));
  // => 5Kd3NBUAdUnhyzenEwVLy9pBKxSwXvE9FMPyR4UKZvpe6E3AgLr
}

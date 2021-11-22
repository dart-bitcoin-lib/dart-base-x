import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_base_x/dart_base_x.dart';

/// Base Decoder
class BaseXDecoder extends Converter<String, Uint8List> {
  final BaseXCodec _codec;

  BaseXDecoder(this._codec);

  Uint8List? decodeUnsafe(String source) {
    if (source.isEmpty) {
      return Uint8List(0);
    }
    int psz = 0;
    // Skip and count leading '1's.
    int zeroes = 0;
    int length = 0;
    while (source.length > psz && source[psz] == _codec.leader) {
      zeroes++;
      psz++;
    }
    // Allocate enough space in big-endian base256 representation.
    int size = (((source.length - psz) * _codec.factor) + 1).toInt() >>>
        0; // log(58) / log(256), rounded up.
    Uint8List b256 = Uint8List(size);
    // Process the characters.
    while (source.length > psz) {
      // Decode character
      var carry = _codec.baseMap[source.codeUnitAt(psz)];
      // Invalid character
      if (carry == 255) {
        return null;
      }
      int i = 0;
      for (var it3 = size - 1;
          (carry != 0 || i < length) && (it3 != -1);
          it3--, i++) {
        carry += (_codec.base * b256[it3]) >>> 0;
        b256[it3] = (carry % 256) >>> 0;
        carry = carry ~/ 256 >>> 0;
      }
      if (carry != 0) {
        throw Exception('Non-zero carry');
      }
      length = i;
      psz++;
    }
    // Skip leading zeroes in b256.
    int it4 = size - length;
    while (it4 != size && b256[it4] == 0) {
      it4++;
    }
    var vch = Uint8List(zeroes + (size - it4));
    vch.fillRange(0, zeroes, 0x00);
    int j = zeroes;
    while (it4 != size) {
      vch[j++] = b256[it4++];
    }
    return vch;
  }

  @override
  Uint8List convert(String input) {
    var buffer = decodeUnsafe(input);
    if (buffer != null) {
      return buffer;
    }
    throw Exception('Non-base${_codec.base} character');
  }
}

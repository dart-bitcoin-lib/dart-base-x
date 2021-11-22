import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_base_x/dart_base_x.dart';

class BaseXEncoder extends Converter<Uint8List, String> {
  final BaseXCodec _codec;

  BaseXEncoder(this._codec);

  @override
  String convert(Uint8List input) {
    if (input.isEmpty) return '';

    // Skip & count leading zeroes.
    int zeroes = 0;
    int length = 0;
    int pBegin = 0;
    int pEnd = input.length;

    while (pBegin != pEnd && input[pBegin] == 0) {
      pBegin++;
      zeroes++;
    }

    // Allocate enough space in big-endian base58 representation.
    final size = (((pEnd - pBegin) * _codec.iFactor) + 1).toInt() >>> 0;
    final b58 = Uint8List(size);

    // Process the bytes.
    while (pBegin != pEnd) {
      int carry = input[pBegin];

      // Apply "b58 = b58 * 256 + ch".
      int i = 0;
      for (int it1 = size - 1;
          (carry != 0 || i < length) && (it1 != -1);
          it1--, i++) {
        carry += (256 * b58[it1]) >>> 0;
        b58[it1] = (carry % _codec.base) >>> 0;
        carry = carry ~/ _codec.base >>> 0;
      }

      if (carry != 0) {
        throw FormatException('Non-zero carry');
      }
      length = i;
      pBegin++;
    }

    // Skip leading zeroes in base58 result.
    int it2 = size - length;
    while (it2 != size && b58[it2] == 0) {
      it2++;
    }

    // Translate the result into a string.
    String str = List.filled(zeroes, _codec.leader).join('');
    for (; it2 < size; ++it2) {
      str += _codec.alphabet[b58[it2]];
    }

    return str;
  }
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dart_base_x/src/converters/base_x_decoder.dart';
import 'package:dart_base_x/src/converters/base_x_encoder.dart';

/// Fast base encoding / decoding of any given
/// alphabet using bitcoin style leading zero compression.
///
/// **WARNING:** This module is **NOT RFC3548** compliant, it cannot be used for base16 (hex), base32, or base64 encoding in a standards compliant manner.
class BaseXCodec extends Codec<Uint8List, String> {
  /// Alphabet
  String alphabet;

  /// BaseMap
  Uint8List baseMap = Uint8List.fromList(List.filled(255, 255));

  /// Base
  int get base {
    return alphabet.length;
  }

  /// First Char
  String get leader {
    return alphabet[0];
  }

  /// Factor
  ///
  /// log(BASE) / log(256), rounded up
  double get factor {
    return log(base) / log(256);
  }

  /// iFactor
  ///
  /// log(256) / log(BASE), rounded up
  double get iFactor {
    return log(256) / log(base);
  }

  BaseXCodec(this.alphabet) {
    for (var i = 0; i < alphabet.length; i++) {
      var xc = alphabet.codeUnitAt(i);
      if (baseMap[xc] != 255) {
        throw FormatException('${alphabet[i]} is ambiguous');
      }
      baseMap[xc] = i;
    }
  }

  @override
  BaseXDecoder get decoder => BaseXDecoder(this);

  @override
  BaseXEncoder get encoder => BaseXEncoder(this);

  /// Decode Unsafe Base X
  Uint8List? decodeUnsafe(String encoded) {
    return decoder.decodeUnsafe(encoded);
  }
}

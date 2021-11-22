# dart-base-x

Inspired by [base-x](https://github.com/cryptocoinjs/base-x).

Fast base encoding / decoding of any given alphabet using bitcoin style leading zero compression.

**WARNING:** This module is **NOT RFC3548** compliant, it cannot be used for base16 (hex), base32, or base64 encoding in
a standards compliant manner.

## Install

    dart pub add dart_base_x

## Example

Base58

``` dart
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

```

### Alphabets

See below for a list of commonly recognized alphabets, and their respective base.

Base | Alphabet
------------- | -------------
2 | `01`
8 | `01234567`
11 | `0123456789a`
16 | `0123456789abcdef`
32 | `0123456789ABCDEFGHJKMNPQRSTVWXYZ`
32 | `ybndrfg8ejkmcpqxot1uwisza345h769` (z-base-32)
36 | `0123456789abcdefghijklmnopqrstuvwxyz`
58 | `123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz`
62 | `0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`
64 | `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/`
67 | `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!~`

## How it works

It encodes octet arrays by doing long divisions on all significant digits in the array, creating a representation of
that number in the new base. Then for every leading zero in the input (not significant as a number) it will encode as a
single leader character. This is the first in the alphabet and will decode as 8 bits. The other characters depend upon
the base. For example, a base58 alphabet packs roughly 5.858 bits per character.

This means the encoded string 000f (using a base16, 0-f alphabet) will actually decode to 4 bytes unlike a canonical hex
encoding which uniformly packs 4 bits into each character.

While unusual, this does mean that no padding is required and it works for bases like 43.

## LICENSE [MIT](LICENSE)

A direct derivation of the base58 implementation
from [`bitcoin/bitcoin`](https://github.com/bitcoin/bitcoin/blob/f1e2f2a85962c1664e4e55471061af0eaa798d40/src/base58.cpp)
, generalized for variable length alphabets.

import 'dart:typed_data';

import 'package:dart_base_x/dart_base_x.dart';
import 'package:hex/hex.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  Map<String, BaseXCodec> bases = Map.fromEntries(fixtures.alphabets
      .getKeys()
      .map((alphabetName) => MapEntry(alphabetName,
          BaseXCodec(fixtures.alphabets.getByName(alphabetName)))));
  for (Valid f in fixtures.valid) {
    test('can encode ${f.alphabet}: ${f.hex}', () {
      final base = bases[f.alphabet]!;
      final actual = base.encode(HEX.decode(f.hex) as Uint8List);

      expect(actual, equals(f.string));
    });
  }

  for (Valid f in fixtures.valid) {
    test('can decode ${f.alphabet}: ${f.hex}', () {
      final base = bases[f.alphabet]!;
      final actual = HEX.encode(base.decode(f.string));

      expect(actual, equals(f.hex));
    });
  }

  for (Invalid f in fixtures.invalid) {
    test('decode throws on ${f.description}', () {
      final base = bases[f.alphabet]!;
      Uint8List? decoded;
      try {
        decoded = base.decode(f.string);
      } catch (e) {
        expect(e.toString(), matches(RegExp(f.exception, multiLine: true)));
      } finally {
        expect(decoded, isNull);
      }
    });
  }
}

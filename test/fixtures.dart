import 'dart:convert';
import 'dart:io';

class Fixtures {
  Alphabets alphabets;
  List<Valid> valid;
  List<Invalid> invalid;

  Fixtures(
      {required this.alphabets, required this.valid, required this.invalid});

  Fixtures.fromJson(Map<String, dynamic> json)
      : alphabets = Alphabets.fromJson(json['alphabets']),
        valid =
            json['valid'].map((x) => Valid.fromJson(x)).cast<Valid>().toList(),
        invalid = json['invalid']
            .map((x) => Invalid.fromJson(x))
            .cast<Invalid>()
            .toList();
}

class Alphabets {
  String base2;
  String base16;
  String base45;
  String base58;

  Alphabets(
      {required this.base2,
      required this.base16,
      required this.base45,
      required this.base58});

  Alphabets.fromJson(Map<String, dynamic> json)
      : base2 = json['base2'],
        base16 = json['base16'],
        base45 = json['base45'],
        base58 = json['base58'];

  List<String> getKeys() {
    return [
      'base2',
      'base16',
      'base45',
      'base58',
    ];
  }

  String getByName(String str) {
    switch (str) {
      case 'base2':
        return base2;
      case 'base16':
        return base16;
      case 'base45':
        return base45;
      default:
        return base58;
    }
  }
}

class Valid {
  String alphabet;
  String hex;
  String string;
  String? comment;

  Valid(
      {required this.alphabet,
      required this.hex,
      required this.string,
      this.comment});

  Valid.fromJson(Map<String, dynamic> json)
      : alphabet = json['alphabet'],
        hex = json['hex'],
        string = json['string'],
        comment = json['comment'];
}

class Invalid {
  String alphabet;
  String description;
  String exception;
  String string;

  Invalid(
      {required this.alphabet,
      required this.description,
      required this.exception,
      required this.string});

  Invalid.fromJson(Map<String, dynamic> json)
      : alphabet = json['alphabet'],
        description = json['description'],
        exception = json['exception'],
        string = json['string'];
}

String _jsonString = File('test/fixtures.json').readAsStringSync();
Map<String, dynamic> _json = jsonDecode(_jsonString);

Fixtures fixtures = Fixtures.fromJson(_json);

import 'dart:io';

void main() {
  new File('input.txt').readAsString().then((String contents) {
    List<Passport> passports = _parseInputs(contents);

    Set<String> requiredFields = <String>{...Passport.passportFields.toList()};
    requiredFields.remove('cid');
    String firstSolution = passports
        .map<bool>((p) => p.hasAllFields(requiredFields))
        .where((element) => element)
        .toList()
        .length
        .toString();
    print(firstSolution);

    String secondSolution = passports
        .map<bool>((p) => p.allFieldsValid(validators))
        .where((v) => v)
        .toList()
        .length
        .toString();
    print(secondSolution);
  });
}

List<Passport> _parseInputs(String inputs) => inputs
    .split("\n\n")
    .where((e) => e.isNotEmpty)
    .map<Passport>((e) => Passport.fromString(e))
    .toList();

Map<String, Function(String)> validators = {
  'byr': (v) {
    var iv = int.parse(v);
    return v.length == 4 && iv >= 1920 && iv <= 2002;
  },
  'iyr': (v) {
    var iv = int.parse(v);
    return v.length == 4 && iv >= 2010 && iv <= 2020;
  },
  'eyr': (v) {
    var iv = int.parse(v);
    return v.length == 4 && iv >= 2020 && iv <= 2030;
  },
  'hgt': (v) {
    if (v.contains('cm')) {
      var p = v.split('cm'), pv = p.length > 0 ? int.parse(p[0]) : 0;
      return pv >= 150 && pv <= 193;
    } else if (v.contains('in')) {
      var p = v.split('in'), pv = p.length > 0 ? int.parse(p[0]) : 0;
      return pv >= 59 && pv <= 76;
    } else {
      return false;
    }
  },
  'hcl': (v) {
    return RegExp(r'#[a-f|0-9]{6}').hasMatch(v);
  },
  'ecl': (v) {
    var valid = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'];
    return valid.contains(v);
  },
  'pid': (v) {
    return v.length == 9 && int.tryParse(v) != null;
  },
};

class Passport {
  Map<String, String> _data = {};
  static final passportFields = const <String>{
    'byr',
    'iyr',
    'eyr',
    'hgt',
    'hcl',
    'ecl',
    'pid',
    'cid',
  };
  Passport.fromString(String input) {
    input.replaceAll(RegExp(r'\n'), ' ').split(' ').forEach((e) {
      var p = e.split(':');
      if (passportFields.contains(p[0])) {
        this._data[p[0]] = p[1];
      }
    });
  }

  bool isSet(String key) => _data.containsKey(key) && _data[key].isNotEmpty;

  bool hasAllFields(Set<String> requiredFields) =>
      requiredFields.every((f) => isSet(f));

  bool allFieldsValid(Map<String, Function(String)> validations) =>
      validations.keys.every((k) {
        if (!isSet(k)) {
          return false;
        }
        var v = _data[k];
        var valid = validations[k](v);
        return valid;
      });
}

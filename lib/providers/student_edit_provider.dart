import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StudentEditProvider with ChangeNotifier {
  StudentEditProvider({
    @required String firstName,
    @required String lastName,
    @required String number,
  })  : _firstName = firstName,
        _lastName = lastName,
        _number = number {
    notifyListeners();
  }

  String _firstName = '';
  String _lastName = '';
  String _number = '';

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get number => _number;

  void handleChangeFirstName(String e) {
    _firstName = e;
    notifyListeners();
  }

  void handleChangeLastName(String e) {
    _lastName = e;
    notifyListeners();
  }

  void handleChangeNum(String e) {
    _number = e;
    notifyListeners();
  }
}

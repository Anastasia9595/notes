import 'dart:collection';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buisness_logic/model/note.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackbar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
      duration: const Duration(seconds: 2),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value != password) {
      return 'Confirmed password must be the same password';
    }
  }

  static convertDateTimeDisplay(DateTime dateTime) {
    var formatr = DateFormat('dd.MM.yyyy');
    return formatr.format(dateTime);
  }

  static bool listsAreEqual(List list1, List list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1.elementAt(i) != list2.elementAt(i)) {
        return false;
      }
    }

    return true;
  }

  static Map<String, String> headerHelperFunction(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // function to pick random items from list
  static List<Note> pickRandomItems(List<Note> list) {
    List<Note> newList = [];
    for (int i = 0; i < 5; i++) {
      var random = Random().nextInt(list.length);

      if (!newList.contains(list[random])) {
        newList.add(list[random]);
      }
    }
    return newList;
  }

  static selectMultipleItems(Note note, List<Note> list) {
    if (list.contains(note)) {
      list.remove(note);
    } else {
      list.add(note);
    }
  }
}

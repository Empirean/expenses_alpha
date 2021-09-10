import 'package:expenses_alpha/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ColorPreference {

  ColorPreference();

  Color getMainColor(SharedPreferences _prefs) {
    return Color.fromARGB(255,
      _prefs.getInt(Constants.KEY_MAIN_RED) ?? Constants.VALUE_MAIN_RED,
      _prefs.getInt(Constants.KEY_MAIN_GREEN) ?? Constants.VALUE_MAIN_GREEN,
      _prefs.getInt(Constants.KEY_MAIN_BLUE) ?? Constants.VALUE_MAIN_BLUE,
    );
  }

  Color getHighColor(SharedPreferences _prefs) {
    return  Color.fromARGB(255,
      _prefs.getInt(Constants.KEY_HIGH_RED) ?? Constants.VALUE_HIGH_RED,
      _prefs.getInt(Constants.KEY_HIGH_GREEN) ?? Constants.VALUE_HIGH_GREEN,
      _prefs.getInt(Constants.KEY_HIGH_BLUE) ?? Constants.VALUE_HIGH_BLUE,
    );
  }

}
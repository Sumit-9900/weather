import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefsProvider extends ChangeNotifier {
  late SharedPreferences prefs;

  void init(String cityName) {
    getPrefs(cityName);
  }

  Future<String> getPrefs(String cityName) async {
    prefs = await SharedPreferences.getInstance();
    String currentCity = prefs.getString('city') ?? cityName;
    return currentCity;
  }

  void setPrefs(String city) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', city);
  }
}

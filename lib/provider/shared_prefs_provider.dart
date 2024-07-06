import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefsProvider extends ChangeNotifier {
  late SharedPreferences prefs;

// Initialize SharedPreferences and get the stored city name
  void init(String cityName) {
    getPrefs(cityName);
  }

  // Get the stored city name from SharedPreferences
  // If no city is stored, return the provided default city name
  Future<String> getPrefs(String cityName) async {
    prefs = await SharedPreferences.getInstance();
    String currentCity = prefs.getString('city') ?? cityName;
    return currentCity;
  }

  // Set the city name in SharedPreferences
  void setPrefs(String city) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', city);
  }
}

import 'package:flutter/material.dart';
import 'package:weather_application/model/weather_model.dart';
import 'package:weather_application/utils/const.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/utils/messages.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  Future<WeatherModel> fetchData(String? city) async {
    try {
      isLoading = true;
      notifyListeners();
      final url = Uri.parse('$baseUrl?q=$city&appid=$appId&units=metric');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        return weatherModelFromJson(res.body);
      } else if (res.statusCode == 404) {
        errorMssg('Please enter correct city!!!');
        throw Exception('StatusCode 404 occurred!');
      } else {
        throw Exception('Error in statusCode :- ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error :- ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

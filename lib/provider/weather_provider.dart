import 'package:flutter/material.dart';
import 'package:weather_application/model/weather_model.dart';
import 'package:weather_application/utils/const.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/utils/messages.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;

  // Fetch weather data for the given city
  Future<WeatherModel> fetchData(String? city) async {
    try {
      isLoading = true;
      notifyListeners();
      final url = Uri.parse('$baseUrl?q=$city&appid=$appId&units=metric');
      final res = await http.get(url);
      // Check if the response is successful
      if (res.statusCode == 200) {
        // Parse the response body to WeatherModel and return
        return weatherModelFromJson(res.body);
      }
      // Handle case when city is not found
      else if (res.statusCode == 404) {
        errorMssg('Please enter correct city!!!');
        throw Exception('StatusCode 404 occurred!');
      }
      // Handle other error statuses
      else {
        throw Exception('Error in statusCode :- ${res.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error :- ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

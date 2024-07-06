import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/model/weather_model.dart';
import 'package:weather_application/provider/shared_prefs_provider.dart';
import 'package:weather_application/provider/weather_provider.dart';
import 'package:weather_application/screens/weather_details_screen.dart';
import 'package:weather_application/utils/messages.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  TextEditingController searchController =
      TextEditingController(); // Controller for the text field to capture user input
  late WeatherModel wm; // Variable to store weather data

  @override
  void dispose() {
    searchController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Enter your city',
              filled: true,
              fillColor: const Color.fromARGB(121, 255, 255, 255),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        // Consumer2 widget to listen to changes in WeatherProvider and SharedprefsProvider
        Consumer2<WeatherProvider, SharedprefsProvider>(
          builder: (context, value, value1, child) {
            return ElevatedButton(
              onPressed: () async {
                final city = searchController.text.trim();
                if (city.isNotEmpty) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  value1.setPrefs(city); // Save the city to SharedPreferences
                  final currentCity = await value1.getPrefs(city);
                  await prefs.setBool('isSuccessfullySearched',
                      true); // Set the flag for successful search
                  wm = await value.fetchData(
                      currentCity); // Fetch weather data for the city
                  final des =
                      wm.weather![0].description; // Get weather description
                  final des1 = des![0].toUpperCase() +
                      des.substring(
                          1); // Capitalize the first letter of description
                  final windSpeed = wm.wind!.speed! *
                      3.6; // Convert wind speed from m/s to km/h
                  if (!value.isLoading && context.mounted) {
                    // Navigate to WeatherDetailsScreen with fetched data
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => WeatherDetailsScreen(
                          icon:
                              'https://openweathermap.org/img/wn/${wm.weather![0].icon}@2x.png',
                          cityName: wm.name!,
                          temp: wm.main!.temp!,
                          des: des1,
                          humidity: wm.main!.humidity!,
                          windSpeed: windSpeed,
                        ),
                      ),
                    );
                  }
                } else {
                  errorMssg(
                      'Please Enter your city!!!'); // Show error message if city input is empty
                }
                searchController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(121, 255, 255, 255),
                foregroundColor: Colors.black,
              ),
              child: const Text('Search'),
            );
          },
        ),
      ],
    );
  }
}

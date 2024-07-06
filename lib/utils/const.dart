import 'package:flutter_dotenv/flutter_dotenv.dart';

// Load the appId from the environment variables
final appId = dotenv.env['appId'];

// Define the base URL for the OpenWeatherMap API
const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherViewModel extends ChangeNotifier {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  WeatherViewModel() {
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    String apiKey = 'your_api_key';
    String city = 'Beirut';

    final url = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        weatherData = json.decode(response.body);
        isLoading = false;
        notifyListeners();  // Notifies the View about data update
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

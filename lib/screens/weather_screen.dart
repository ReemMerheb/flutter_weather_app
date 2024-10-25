import 'package:flutter/material.dart';
import 'package:flutter_weather/screens/intro_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = '79acf67417dbf2c0d5023c3f3de52eaa'; // Replace with your OpenWeatherMap API key
  String city = 'Beirut'; // Default city
  Map<String, dynamic>? weatherData;
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(city); // Fetch weather for default city (Beirut)
  }

  Future<void> fetchWeatherData(String city) async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        setState(() {
          errorMessage = 'City not found or failed to fetch weather data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return 'assets/clear.png';
      case '02d':
      case '02n':
        return 'assets/cloudSun.png';
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return 'assets/clouds.png';
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return 'assets/rain.png';
      case '11d':
      case '11n':
        return 'assets/rainStorm.png';
      case '13d':
      case '13n':
        return 'assets/snow.png';
      default:
        return 'assets/clouds.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final currentWeather = weatherData != null ? weatherData!['list'][0] : null;
    final currentTemp = currentWeather != null ? currentWeather['main']['temp'].toStringAsFixed(1) : '';
    final currentIcon = currentWeather != null ? currentWeather['weather'][0]['icon'] : '';
    final weatherDescription = currentWeather != null ? currentWeather['weather'][0]['description'] : '';

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 23, 8, 77),
                  const Color.fromARGB(255, 56, 41, 112),
                  const Color.fromARGB(255, 128, 0, 128),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding:const EdgeInsets.only(top:  30.0,bottom:  10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [SizedBox(width: 30,),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Enter city or country name',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: GoogleFonts.poppins(color: Colors.white,fontSize: 15),
                        ),
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white, size: 42),
                      onPressed: () {
                        setState(() {
                          city = _searchController.text;
                          fetchWeatherData(city);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 130),

                if (currentWeather != null)
                  Column(
                    children: [
                      Text(
                        city,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 39,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$currentTemp°C',
                              style: GoogleFonts.poppins(
                                fontSize: 50,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height:  10),
                            Image.asset(
                              getWeatherIcon(currentIcon),
                              width: 90,
                              height: 90,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        weatherDescription,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 90),
                    ],
                  ),

                if (_isLoading)
                  Center(child: CircularProgressIndicator()),

                if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),

                if (weatherData != null && !_isLoading)
                  Expanded(child: _buildWeatherList(screenHeight)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 128, 0, 128),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.white,size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_outlined, color: Colors.white,size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, color: Colors.white,size: 30,),
            label: '',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) { if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>   GetStartedScreen()),
            );
          }if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>   WeatherScreen()),
            );
          }
          
          // Handle navigation actions here if needed
        },
      ),
    );
  }

  Widget _buildWeatherList(double screenHeight) {
    final List<dynamic> forecasts = weatherData?['list'] ?? [];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final forecast = forecasts[index];
          final date = DateTime.parse(forecast['dt_txt']);
          final temperature = forecast['main']['temp'];
          final iconCode = forecast['weather'][0]['icon'];
          final dayName = DateFormat('EEEE').format(date);
          final hour = DateFormat('HH').format(date);

          return Container(
            width: 110,
            height: screenHeight * 0.2,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${temperature.toStringAsFixed(1)}°C',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Image.asset(
                  getWeatherIcon(iconCode),
                  width: 50,
                  height: 50,
                ),
                SizedBox(height: 10),
                Text(
                  '$hour:00',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

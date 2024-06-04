import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = '05c1b992fa3266414857e79721428865'; // OpenWeatherMap API 키
  String cityName = 'Pohang';
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      print('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in $cityName'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: weatherData == null
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${weatherData!['main']['temp']}°C',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      weatherData!['weather'][0]['description'],
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    if (weatherData!['weather'][0]['main'] != 'Rain' &&
                        weatherData!['main']['temp'] >= 10)
                      Column(
                        children: [
                          Lottie.asset('assets/running_man.json', height: 200),
                          SizedBox(height: 20),
                          Text(
                            '오늘은 날씨가 좋아요! 담배는 잊고 밖에서 뛰어 놀아봅시다!',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Lottie.asset('assets/reading.json', height: 200),
                          SizedBox(height: 20),
                          Text(
                            '오늘은 집에서 독서를 하며 마음의 평화를 얻어보아요',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: fetchWeather,
                      child: Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}


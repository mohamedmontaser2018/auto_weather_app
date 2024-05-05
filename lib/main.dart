import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mohamed Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? _weatherData;

  Future<void> _fetchWeatherData(String cityName) async {
    final apiKey = 'f5af996123590649f817823f53b01898'; // Replace this with your OpenWeatherMap API key
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mohamed Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter city name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final cityName = _cityController.text;
                if (cityName.isNotEmpty) {
                  _fetchWeatherData(cityName);
                }
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            if (_weatherData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('City: ${_weatherData!['name']}'),
                  Text('Temperature: ${_weatherData!['main']['temp']}°C'),
                  Text('Description: ${_weatherData!['weather'][0]['description']}'),
                  // Add more weather data fields here as needed
                ],
              ),
          ],
        ),
      ),
    );
  }
}

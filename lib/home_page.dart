import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'constants/city_constants.dart';
import 'services/weather_service.dart';
import 'widgets/weather_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  String _selectedCity = "Dubai";
  String _backgroundImagePath = cityBackgroundImages["Dubai"]!;

  @override
  void initState() {
    super.initState();
    _loadWeather(_selectedCity);
  }

  void _loadWeather(String cityName) async {
    final weather = await _weatherService.fetchWeather(cityName);
    setState(() {
      _weather = weather;
      _backgroundImagePath = cityBackgroundImages[cityName]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null
          ? const Center(child: CircularProgressIndicator())
          : WeatherUI(
              backgroundImagePath: _backgroundImagePath,
              weather: _weather!,
              selectedCity: _selectedCity,
              onCityChanged: (city) {
                setState(() {
                  _selectedCity = city;
                  _loadWeather(city);
                });
              },
            ),
    );
  }
}

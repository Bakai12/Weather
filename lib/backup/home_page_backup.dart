import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _selectedCity = "Dubai"; // По умолчанию выбран город "Dubai"
  String _backgroundImagePath = "assets/background_dubai.jpg"; // Начальный фон

  List<String> cities = ["Dubai", "New York", "London", "Tokyo", "Bishkek", "Sydney", "Singapore", "Istanbul", "Bangkok"];
  Map<String, String> cityBackgroundImages = {
    "Dubai": "assets/dubai.jpg",
    "New York": "assets/new york.jpg",
    "London": "assets/london.jpg",
    "Tokyo": "assets/tokyo.jpg",
    "Bishkek": "assets/bishkek.jpg",
    "Sydney": "assets/sydney.jpg",
    "Singapore": "assets/singapore.jpg",
    "Istanbul": "assets/istanbul.jpg",
    "Bangkok": "assets/bangkok.jpg",
  };

  @override
  void initState() {
    super.initState();
    _loadWeather(_selectedCity);
  }

  void _loadWeather(String cityName) {
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
        _backgroundImagePath = cityBackgroundImages[cityName]!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          // Фоновая картинка
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_backgroundImagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Основное содержимое
          Column(
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    _locationHeader(),
    DropdownButton<String>(
      value: _selectedCity,
      onChanged: (value) {
        setState(() {
          _selectedCity = value!;
          _loadWeather(_selectedCity);
        });
      },
      items: cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(
            city,
            style: TextStyle(
              color: _selectedCity == city ? Colors.blueGrey : Colors.black, // Цвет текста
            ),
          ),
        );
      }).toList(),
    ),
    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.08,
    ),
    _dateTimeInfo(),
    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
    ),
    _weatherIcon(),
    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.02,
    ),
    _currentTemp(),
    SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.02,
    ),
    _extraInfo(),
  ],
),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
      child: Text(
        _weather?.areaName ?? "",
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat('HH:mm').format(now),
          style: const TextStyle(
            fontSize: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE ").format(now),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              DateFormat("d MMM yyyy").format(now),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.15,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: TextStyle(
        color: Colors.white,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
}
}

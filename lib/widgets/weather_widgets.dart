import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/constants/city_constants.dart';

class WeatherUI extends StatelessWidget {
  final String backgroundImagePath;
  final Weather weather;
  final String selectedCity;
  final Function(String) onCityChanged;

  const WeatherUI({
    super.key,
    required this.backgroundImagePath,
    required this.weather,
    required this.selectedCity,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Weather content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _locationHeader(weather),
            _cityDropdown(selectedCity, onCityChanged),
            _dateTimeInfo(weather),
            _weatherIcon(weather),
            _currentTemp(weather),
            _extraInfo(weather),
          ],
        ),
      ],
    );
  }

  Widget _locationHeader(Weather weather) {
    return Text(
      weather.areaName ?? "",
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget _cityDropdown(String selectedCity, Function(String) onCityChanged) {
    return DropdownButton<String>(
      value: selectedCity,
      onChanged: (value) => onCityChanged(value!),
      items: cityBackgroundImages.keys.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(
            city,
            style: TextStyle(
              color: selectedCity == city ? Colors.blueGrey : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _dateTimeInfo(Weather weather) {
    DateTime now = weather.date!;
    return Column(
      children: [
        Text(
          DateFormat('HH:mm').format(now),
          style: const TextStyle(fontSize: 50, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon(Weather weather) {
    return Column(
      children: [
        Image.network(
          "http://openweathermap.org/img/wn/${weather.weatherIcon}@4x.png",
          height: 100,
        ),
        Text(
          weather.weatherDescription ?? "",
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ],
    );
  }

  Widget _currentTemp(Weather weather) {
    return Text(
      "${weather.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(color: Colors.white, fontSize: 90),
    );
  }

Widget _extraInfo(Weather weather) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое
    children: [
      // Левая колонка (Max и Min температура)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max: ${weather.tempMax?.celsius?.toStringAsFixed(0)}° C",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10), // Разделение между Max и Min
          Text(
            "Min: ${weather.tempMin?.celsius?.toStringAsFixed(0)}° C",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(width: 60), // Расстояние между колонками
      // Правая колонка (Скорость ветра и влажность)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wind: ${weather.windSpeed?.toStringAsFixed(0)} m/s",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10), // Разделение между Wind и Humidity
          Text(
            "Humidity: ${weather.humidity?.toStringAsFixed(0)}%",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  );
}
}

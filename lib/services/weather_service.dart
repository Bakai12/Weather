import 'package:weather/weather.dart';
import '../consts.dart';

class WeatherService {
  final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);

  Future<Weather?> fetchWeather(String cityName) async {
    try {
      return await _weatherFactory.currentWeatherByCityName(cityName);
    } catch (e) {
      return null;
    }
  }
}

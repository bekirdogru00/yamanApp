import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  Future<void> _getWeatherData() async {
    try {
      // Adıyaman'ın koordinatları
      const double latitude = 37.7636;
      const double longitude = 38.2773;

      // OpenWeatherMap API'den hava durumu verilerini al
      const apiKey = 'cf5d9262794451bd3c287748b9f7ed1d';
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=tr');
      
      print('API çağrısı yapılıyor: $url');
      
      final response = await http.get(url);
      
      print('Durum kodu: ${response.statusCode}');
      print('Yanıt: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Hava durumu verileri alınamadı. Durum kodu: ${response.statusCode}, Yanıt: ${response.body}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hata: $error'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          error = null;
                        });
                        _getWeatherData();
                      },
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              )
            : weatherData != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Adıyaman',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://openweathermap.org/img/w/${weatherData!['weather'][0]['icon']}.png',
                              scale: 0.5,
                            ),
                            Text(
                              '${weatherData!['main']['temp'].round()}°C',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Text(
                          weatherData!['weather'][0]['description'].toString().toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        _buildWeatherDetail(
                          'Hissedilen Sıcaklık',
                          '${weatherData!['main']['feels_like'].round()}°C',
                        ),
                        _buildWeatherDetail(
                          'Nem',
                          '%${weatherData!['main']['humidity']}',
                        ),
                        _buildWeatherDetail(
                          'Rüzgar Hızı',
                          '${weatherData!['wind']['speed']} m/s',
                        ),
                      ],
                    ),
                  )
                : const Center(child: Text('Hava durumu bilgisi bulunamadı'));
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
} 
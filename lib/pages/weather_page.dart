import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? weatherData;
  String? errorMessage;
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _getWeatherData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getWeatherData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Adıyaman'ın koordinatları
      const double latitude = 37.7636;  // Adıyaman'ın enlemi
      const double longitude = 38.2773; // Adıyaman'ın boylamı

      final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=${ApiConfig.weatherApiKey}&units=metric&lang=tr',
      ));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
        _controller.forward();
      } else {
        throw Exception('API yanıt vermedi (Kod: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Hata oluştu: $e');
      setState(() {
        errorMessage = 'Hava durumu bilgisi alınamadı: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  String _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return '🌤️';
    
    switch (iconCode) {
      case '01d': return '☀️';
      case '01n': return '🌙';
      case '02d': return '⛅';
      case '02n': return '☁️';
      case '03d':
      case '03n': return '☁️';
      case '04d':
      case '04n': return '☁️';
      case '09d':
      case '09n': return '🌧️';
      case '10d':
      case '10n': return '🌦️';
      case '11d':
      case '11n': return '⛈️';
      case '13d':
      case '13n': return '❄️';
      case '50d':
      case '50n': return '🌫️';
      default: return '🌤️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getWeatherData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade900,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else if (errorMessage != null)
                      Column(
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _getWeatherData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                            ),
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      )
                    else if (weatherData != null)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Text(
                                weatherData!['name'] ?? 'Bilinmeyen Konum',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                weatherData!['weather'][0]['description'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                _getWeatherIcon(weatherData!['weather'][0]['icon']),
                                style: const TextStyle(fontSize: 72),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData!['main']['temp'].round()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    '°C',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildWeatherDetail(
                                      'Nem',
                                      '${weatherData!['main']['humidity']}%',
                                      Icons.water_drop_outlined,
                                    ),
                                    _buildWeatherDetail(
                                      'Rüzgar',
                                      '${weatherData!['wind']['speed']} m/s',
                                      Icons.air,
                                    ),
                                    _buildWeatherDetail(
                                      'Basınç',
                                      '${weatherData!['main']['pressure']} hPa',
                                      Icons.speed,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 
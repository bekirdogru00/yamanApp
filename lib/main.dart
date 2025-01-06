import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/weather_page.dart';
import 'pages/business_page.dart';
import 'pages/news_page.dart';
import 'pages/places_page.dart';
import 'pages/home_page.dart';
import 'pages/pharmacy_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isAdmin = prefs.getBool('isAdmin') ?? false;
  runApp(MyApp(isAdmin: isAdmin));
}

class MyApp extends StatelessWidget {
  final bool isAdmin;
  const MyApp({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YamanApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      locale: const Locale('tr', 'TR'),
      home: MainScreen(initialIsAdmin: isAdmin),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool initialIsAdmin;
  const MainScreen({Key? key, required this.initialIsAdmin}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late bool _isAdmin;

  @override
  void initState() {
    super.initState();
    _isAdmin = widget.initialIsAdmin;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openLoginPage() async {
    if (_isAdmin) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );

      if (result == false) {
        setState(() {
          _isAdmin = false;
        });
      }
    } else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      if (result == true) {
        setState(() {
          _isAdmin = true;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAdmin', true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin olarak giriş yapıldı')),
        );
      }
    }
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'YamanApp';
      case 1:
        return 'Gezilecek Yerler';
      case 2:
        return 'İşletmeler';
      case 3:
        return 'Hava Durumu';
      case 4:
        return 'Haberler';
      case 5:
        return 'Eczaneler';
      default:
        return 'YamanApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: Icon(
              _isAdmin ? Icons.account_circle : Icons.login,
              color: _isAdmin ? Colors.green : null,
            ),
            onPressed: _openLoginPage,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onNavigate: _onItemTapped),
          const PlacesPage(),
          const BusinessPage(),
          const WeatherPage(),
          const NewsPage(),
          const PharmacyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Gezilecek Yerler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'İşletmeler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Hava Durumu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Haberler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Eczaneler',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                // Admin işlemleri için menü açılacak
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Yeni İçerik Ekle'),
                          onTap: () {
                            Navigator.pop(context);
                            // Yeni içerik ekleme sayfasına yönlendirme
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('İçerikleri Düzenle'),
                          onTap: () {
                            Navigator.pop(context);
                            // İçerik düzenleme sayfasına yönlendirme
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Admin Çıkışı'),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isAdmin', false);
                            setState(() {
                              _isAdmin = false;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Admin oturumu kapatıldı')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.admin_panel_settings),
            )
          : null,
    );
  }
}

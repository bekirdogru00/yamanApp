import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/places_page.dart';
import 'pages/restaurants_page.dart';
import 'pages/jobs_page.dart';
import 'pages/news_page.dart';
import 'pages/admin/admin_page.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adıyaman Rehberi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2E7D32), // Koyu yeşil
          secondary: const Color(0xFFFFD700), // Altın sarısı
          tertiary: const Color(0xFF4CAF50), // Orta yeşil
          background: Colors.white,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onSurface: Colors.black,
          primaryContainer: const Color(0xFF81C784), // Açık yeşil
          secondaryContainer: const Color(0xFFFFF176), // Açık sarı
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          toolbarHeight: 64,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          shadowColor: Colors.green.withOpacity(0.2),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF81C784).withOpacity(0.2),
          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2E7D32), width: 1),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2E7D32),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFF2E7D32),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFFFFD700),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    PlacesPage(),
    RestaurantsPage(),
    JobsPage(),
    NewsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        },
        child: const Icon(Icons.admin_panel_settings),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
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
              icon: Icon(Icons.restaurant),
              label: 'Restoranlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'İş İlanları',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'Haberler',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

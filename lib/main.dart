import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  // Uygulama başlatılıyor
  runApp(MyAppLauncher(token: token));
}

// Bu widget başlangıç kararını verir
class MyAppLauncher extends StatelessWidget {
  final String token;

  const MyAppLauncher({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BorsaMeydaniApp(isLoggedIn: token.isNotEmpty);
  }
}

class BorsaMeydaniApp extends StatelessWidget {
  final bool isLoggedIn;

  const BorsaMeydaniApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Borsa Meydanı',
      debugShowCheckedModeBanner: false,
      // initialRoute yerine home kullanmak daha güvenlidir
      home: isLoggedIn ? MainNavigation() : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainNavigation(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    FavoritesScreen(),
    AboutScreen(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Hakkında',
          ),
        ],
      ),
    );
  }
}

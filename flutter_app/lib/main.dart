import 'package:flutter/material.dart';
import 'package:flutter_app/screens/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';  // 👈 Add your category screen here
import './services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _loggedIn;

  @override
  void initState() {
    super.initState();
    _loggedIn = _checkLoggedIn();
  }

  /// 🔍 Check token & verify with backend
  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) return false;

    // Optional but recommended: verify token with backend
    final res = await ApiService.getAuth('/api/auth/profile');

    if (res['status'] == 200) {
      return true;
    } else {
      await ApiService.logout();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TD Auth Demo',
      debugShowCheckedModeBanner: false,

      /// 🔗 REGISTER ROUTES HERE
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/category': (context) => CategoryScreen(), 
        '/product': (context) => ProductListScreen(),
      },

      home: FutureBuilder<bool>(
        future: _loggedIn,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return snapshot.data == true
              ? const HomeScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}

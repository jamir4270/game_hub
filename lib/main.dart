import 'package:flutter/material.dart';
import 'widgets/authentication_screen.dart';
import 'widgets/main_app_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _isLoggedIn = false;

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLoginFailed() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return const MyHomePage();
    }
    return AuthenticationScreen(
      onSignedIn: _onLoginSuccess,
      onLoginFailed: _onLoginFailed,
    );
  }
}

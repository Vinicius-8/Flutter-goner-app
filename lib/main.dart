import 'package:flutter/material.dart';
import 'package:goner/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goner App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        // accentColor: Colors.tealAccent[400],
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const Home(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/splash.dart';

void main() {
  initializeDateFormatting('id_ID');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bioskop Kita Sendiri',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

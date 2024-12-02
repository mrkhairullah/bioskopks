import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_navigation_bar.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay(context);
  }

  Future<void> _navigateAfterDelay(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final sharedPreferences = await SharedPreferences.getInstance();
    final isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const MainNavigationBar() : const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

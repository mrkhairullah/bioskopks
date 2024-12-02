import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/splash.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _nit();
  }

  _nit() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userId = sharedPreferences.getInt('userId');
    });
  }

  _logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLoggedIn', false);
  }

  _onPressed() {
    _logout();

    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(builder: (context) => const SplashPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Profil'),
          Text('User ID: $userId'),
          ElevatedButton(
            onPressed: _onPressed,
            child: const Text('Logout'),
          )
        ],
      )),
    );
  }
}

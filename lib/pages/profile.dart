import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/splash.dart';
import '../models/user.dart';
import '../services/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData =
        await UserService().getUserById(sharedPreferences.getInt('userId')!);

    setState(() {
      user = userData;
      isLoading = false;
    });
  }

  _deleteSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLoggedIn', false);
  }

  _onLogoutPressed() {
    _deleteSession();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.asset(
                              'assets/img/default-photo.png',
                              width: 200.0,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Text(
                            user!.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            user!.email,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Ubah Profil'),
                          ),
                          FilledButton(
                            onPressed: _onLogoutPressed,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

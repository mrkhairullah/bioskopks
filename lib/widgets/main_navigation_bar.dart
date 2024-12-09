import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/user.dart';
import '../pages/home.dart';
import '../pages/history.dart';
import '../pages/profile.dart';
import '../pages/save_film.dart';
import '../pages/save_studio.dart';
import '../pages/studio_list.dart';

class MainNavigationBar extends StatefulWidget {
  final int? index;

  const MainNavigationBar({super.key, this.index});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _currentIndex = 0;
  bool _isAdmin = false;

  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      setState(() {
        _currentIndex = widget.index!;
      });
    }
    _isAdminCheck();
  }

  Future<void> _isAdminCheck() async {
    final Session session = await UserService().getSession();

    setState(() {
      _isAdmin = session.isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      appBar: _isAdmin
          ? AppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            )
          : null,
      drawer: _isAdmin
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    child: Text(
                      'Menu Admin',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Tambah Film'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SaveFilmPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Tambah Studio'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SaveStudioPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Daftar Studio'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudioListPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Daftar Pesanan'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HistoryPage(allUsers: true),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

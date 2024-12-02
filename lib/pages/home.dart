import 'package:flutter/material.dart';
import '../services/film.dart';
import '../models/film.dart';
import '../widgets/film_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Film> films = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilms();
  }

  Future<void> _loadFilms() async {
    final filmsData = await FilmService().getFilms();
    setState(() {
      films = filmsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BioskopKS'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : films.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Film belum tersedia',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: films.length,
                  itemBuilder: (context, index) {
                    return FilmCard(film: films[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
    );
  }
}

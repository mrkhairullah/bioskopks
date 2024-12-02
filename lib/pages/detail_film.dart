import 'package:flutter/material.dart';
import '../models/film.dart';
import '../models/detail_schedule.dart';
import '../services/detail_schedule.dart';
import '../widgets/detail_schedule_card.dart';

class DetailFilmPage extends StatefulWidget {
  final Film film;

  const DetailFilmPage({super.key, required this.film});

  @override
  State<DetailFilmPage> createState() => _DetailFilmPageState();
}

class _DetailFilmPageState extends State<DetailFilmPage> {
  List<DetailSchedule> detailSchedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final filmDetailSchedules =
        await DetailScheduleService().getDetailSchedule(widget.film.id!);
    setState(() {
      detailSchedules = filmDetailSchedules;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Film'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.film.poster,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image,
                                size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  widget.film.rating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.film.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                '${widget.film.director} • ${widget.film.genre} • ${widget.film.duration} Menit',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Bahasa: ${widget.film.language}',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Subtitle: ${widget.film.subtitle}',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                widget.film.description,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Jadwal Tayang',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10.0),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : detailSchedules.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Jadwal belum tersedia',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: detailSchedules.length,
                          itemBuilder: (context, index) {
                            return DetailScheduleCard(
                                detailSchedule: detailSchedules[index]);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12.0);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

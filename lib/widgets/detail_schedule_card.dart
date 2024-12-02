import 'package:flutter/material.dart';
import '../models/detail_schedule.dart';
import '../helpers/format_price.dart';
import '../helpers/format_date.dart';
import '../pages/order.dart';

class DetailScheduleCard extends StatelessWidget {
  final DetailSchedule detailSchedule;

  const DetailScheduleCard({
    super.key,
    required this.detailSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailSchedule.studioName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatDate(detailSchedule.time),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatPrice(detailSchedule.price),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: detailSchedule.available == 'Tersedia'
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderPage(detailSchedule: detailSchedule),
                          ),
                        );
                      }
                    : null,
                child: const Text('Pesan Tiket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/order.dart';
import '../models/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<OrderHistory> orderHistories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistories();
  }

  Future<void> _loadOrderHistories() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final orderHistoriesData = await OrderService()
        .getOrderHistories(sharedPreferences.getInt('userId')!);
    setState(() {
      orderHistories = orderHistoriesData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemesanan'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orderHistories.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada riwayat pemesanan',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: orderHistories.length,
                  itemBuilder: (context, index) {
                    return HistoryCard(orderHistory: orderHistories[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
    );
  }
}

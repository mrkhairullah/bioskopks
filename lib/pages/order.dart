import 'package:flutter/material.dart';
import '../models/detail_schedule.dart';
import '../helpers/format_date.dart';
import '../helpers/format_price.dart';
import '../services/order.dart';
import '../models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_navigation_bar.dart';

class OrderPage extends StatefulWidget {
  final DetailSchedule detailSchedule;

  const OrderPage({super.key, required this.detailSchedule});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<String> reservedSeats = [];
  List<String> selectedSeats = [];
  String? selectedMethod;
  int ticketCount = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _fetchReservedSeats();
  }

  void _fetchReservedSeats() async {
    final seats = await OrderService().getReservedSeats(
        widget.detailSchedule.filmId, widget.detailSchedule.scheduleId);

    setState(() {
      reservedSeats = seats;
    });
  }

  void _createOrder(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final orderId = await OrderService().createOrder(Order(
      userId: sharedPreferences.getInt('userId')!,
      filmId: widget.detailSchedule.filmId,
      scheduleId: widget.detailSchedule.scheduleId,
      ticket: ticketCount,
      totalPrice: totalPrice,
      method: selectedMethod!,
      status: 'Pending',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    ));

    if (orderId != 0) {
      if (context.mounted) {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
              builder: (context) => const MainNavigationBar(index: 1)),
        );
      }
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Gagal'),
              content: const Text('Terjadi kesalahan saat membuat pesanan'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Ticket'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Film',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.detailSchedule.filmTitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Studio',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.detailSchedule.studioName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Waktu Tayang',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatDate(widget.detailSchedule.time),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Harga Per Ticket',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatPrice(widget.detailSchedule.price),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedMethod,
                    hint: const Text('Pilih metode pembayaran'),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Transfer Bank',
                        child: Text('Transfer Bank'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'E-Wallet',
                        child: Text('E-Wallet'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMethod = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Ticket',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Jumlah ticket yang akan dipesan',
                    ),
                    onChanged: (value) {
                      setState(() {
                        ticketCount = int.tryParse(value) ?? 0;
                        totalPrice = ticketCount * widget.detailSchedule.price;
                        selectedSeats = [];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Harga',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatPrice(totalPrice),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  widget.detailSchedule.studioCapacitySeat,
                  (index) {
                    String seatLabel =
                        '${String.fromCharCode(65 + (index ~/ 8))}${(index % 8) + 1}';
                    bool isReserved = reservedSeats.contains(seatLabel);
                    bool isAvailable = !isReserved &&
                        index < widget.detailSchedule.studioMaxSeat;

                    return GestureDetector(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                if (selectedSeats.contains(seatLabel)) {
                                  selectedSeats.remove(seatLabel);
                                } else if (selectedSeats.length < ticketCount) {
                                  selectedSeats.add(seatLabel);
                                }
                              });
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isReserved
                              ? Colors.grey
                              : selectedSeats.contains(seatLabel)
                                  ? Colors.green
                                  : isAvailable
                                      ? Colors.blue
                                      : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          seatLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: selectedSeats.isEmpty
                      ? null
                      : () {
                          _createOrder(context);
                        },
                  child: const Text('Pesan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

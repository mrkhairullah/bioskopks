import 'dart:async';
import 'package:bioskopks/models/order.dart';
import 'package:flutter/material.dart';
import '../models/detail_order.dart';
import '../models/session.dart';
import '../services/order.dart';
import '../services/user.dart';
import '../utils/format_date.dart';
import '../utils/format_price.dart';
import '../widgets/main_navigation_bar.dart';

class DetailOrderPage extends StatefulWidget {
  final int orderId;

  const DetailOrderPage({super.key, required this.orderId});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  late TextEditingController _noteController;
  Timer? _debounce;
  DetailOrder? _detailOrder;
  String? _note;
  bool _isAdmin = false;
  int? _adminId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
    _isAdminCheck();
  }

  void _loadOrder() async {
    final detailOrder = await OrderService().getDetailOrder(widget.orderId);

    setState(() {
      _detailOrder = detailOrder;
      _note = _detailOrder?.note;
      _isLoading = false;
    });

    _noteController = TextEditingController(text: _note);
    _noteController.addListener(_onNoteChanged);
  }

  Future<void> _isAdminCheck() async {
    final Session session = await UserService().getSession();

    setState(() {
      _isAdmin = session.isAdmin;

      if (session.isAdmin) {
        setState(() {
          _adminId = session.userId;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _note = _noteController.text;
      });
    });
  }

  Future<void> _onUpdate(BuildContext context, String status) async {
    Order order = Order(
      id: _detailOrder!.id,
      userId: _detailOrder!.userId,
      filmId: _detailOrder!.filmId,
      scheduleId: _detailOrder!.scheduleId,
      ticket: _detailOrder!.ticket,
      totalPrice: _detailOrder!.totalPrice,
      method: _detailOrder!.method,
      note: _note,
      paymentProof: null,
      status: status,
      confirmedBy: _isAdmin ? _adminId : null,
      createdAt: _detailOrder!.createdAt,
      updatedAt: DateTime.now().toString(),
    );
    int orderId = await OrderService().updateOrder(order);

    if (orderId > 0) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const MainNavigationBar(),
          ),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat memperbarui pesanan'),
          margin: EdgeInsets.all(16.0),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        _detailOrder!.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Judul Film',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _detailOrder!.filmTitle,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
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
                          formatDate(_detailOrder!.scheduleTime),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Pemesan',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _detailOrder!.bookerName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiket Yang Dipesan',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _detailOrder!.ticket.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatPrice(_detailOrder!.totalPrice),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Metode Pembayaran',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _detailOrder!.method,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Catatan',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText:
                                _isAdmin ? 'Masukkan catatan (opsional)' : '-',
                          ),
                          readOnly: _isAdmin ? false : true,
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Disetujui Oleh',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _detailOrder!.adminName ?? '-',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dipesan Pada',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatDate(_detailOrder!.createdAt!),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diperbarui Pada',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatDate(_detailOrder!.updatedAt!),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Bukti Pembayaran',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FilledButton(
                              onPressed: () {},
                              child: const Text('Unggah Bukti'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/img/empty-photo.png',
                              width: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    _isAdmin
                        ? Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    _onUpdate(context, 'Sukses');
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Konfirmasi'),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    _onUpdate(context, 'Ditolak');
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Tolak'),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}

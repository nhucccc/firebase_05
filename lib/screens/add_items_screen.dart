import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/auth_provider.dart';
import '../models/menu_item.dart';
import 'home_screen.dart';

class AddItemsScreen extends StatefulWidget {
  final String reservationId;

  const AddItemsScreen({super.key, required this.reservationId});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  @override
  void initState() {
    super.initState();
    _loadReservation();
  }

  Future<void> _loadReservation() async {
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
    try {
      await reservationProvider.loadReservationsByCustomer(
        Provider.of<AuthProvider>(context, listen: false).currentCustomer!.customerId
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _addItem(MenuItem menuItem) async {
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
    try {
      await reservationProvider.addItemToReservation(widget.reservationId, menuItem.itemId, 1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm ${menuItem.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final reservation = reservationProvider.currentReservation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn món'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Column(
        children: [
          // Order summary
          if (reservation != null && reservation.orderItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn hàng hiện tại',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...reservation.orderItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('${item.itemName} x${item.quantity}'),
                        ),
                        Text(
                          '${(item.price * item.quantity).toStringAsFixed(0)}đ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${reservation.total.toStringAsFixed(0)}đ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Menu items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuProvider.menuItems.length,
              itemBuilder: (context, index) {
                final item = menuProvider.menuItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.restaurant, color: Colors.grey.shade400),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.price.toStringAsFixed(0)}đ'),
                    trailing: item.isAvailable
                        ? IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.orange),
                            onPressed: () => _addItem(item),
                          )
                        : const Text('Hết món', style: TextStyle(color: Colors.red)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: reservation != null && reservation.orderItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đặt bàn thành công!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Hoàn tất đặt bàn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }
}

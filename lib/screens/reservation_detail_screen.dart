import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';
import '../providers/auth_provider.dart';
import '../providers/reservation_provider.dart';

class ReservationDetailScreen extends StatefulWidget {
  final Reservation reservation;

  const ReservationDetailScreen({super.key, required this.reservation});

  @override
  State<ReservationDetailScreen> createState() => _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  String _selectedPaymentMethod = 'cash';
  int _loyaltyPointsToUse = 0;

  Future<void> _pay() async {
    try {
      final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await reservationProvider.payReservation(
        widget.reservation.reservationId,
        _selectedPaymentMethod,
        loyaltyPointsToUse: _loyaltyPointsToUse,
      );

      await authProvider.refreshCustomer();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanh toán thành công!')),
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

  void _showPaymentDialog() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final customer = authProvider.currentCustomer!;
    final maxPoints = (widget.reservation.total * 0.5 / 1000).floor();
    final availablePoints = customer.loyaltyPoints > maxPoints ? maxPoints : customer.loyaltyPoints;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final discount = _loyaltyPointsToUse * 1000.0;
          final finalTotal = widget.reservation.total - discount;

          return AlertDialog(
            title: const Text('Thanh toán'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng tiền: ${widget.reservation.total.toStringAsFixed(0)}đ'),
                  const SizedBox(height: 16),
                  const Text('Phương thức thanh toán:'),
                  RadioListTile<String>(
                    title: const Text('Tiền mặt'),
                    value: 'cash',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Thẻ'),
                    value: 'card',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Online'),
                    value: 'online',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Điểm tích lũy hiện có: ${customer.loyaltyPoints}'),
                  Text('Có thể dùng tối đa: $availablePoints điểm'),
                  const SizedBox(height: 8),
                  Text('Sử dụng điểm: $_loyaltyPointsToUse'),
                  Slider(
                    value: _loyaltyPointsToUse.toDouble(),
                    min: 0,
                    max: availablePoints.toDouble(),
                    divisions: availablePoints > 0 ? availablePoints : 1,
                    label: '$_loyaltyPointsToUse điểm',
                    onChanged: (value) {
                      setState(() {
                        _loyaltyPointsToUse = value.toInt();
                      });
                    },
                  ),
                  if (_loyaltyPointsToUse > 0)
                    Text('Giảm giá: ${discount.toStringAsFixed(0)}đ'),
                  const Divider(),
                  Text(
                    'Thành tiền: ${finalTotal.toStringAsFixed(0)}đ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pay();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                ),
                child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đặt bàn'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin đặt bàn',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Ngày giờ', DateFormat('dd/MM/yyyy HH:mm').format(reservation.reservationDate.toDate())),
                    _buildInfoRow('Số khách', '${reservation.numberOfGuests} người'),
                    if (reservation.tableNumber != null)
                      _buildInfoRow('Số bàn', reservation.tableNumber!),
                    if (reservation.specialRequests != null)
                      _buildInfoRow('Yêu cầu đặc biệt', reservation.specialRequests!),
                    _buildInfoRow('Trạng thái', reservation.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Món đã đặt',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    if (reservation.orderItems.isEmpty)
                      const Text('Chưa có món nào')
                    else
                      ...reservation.orderItems.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thanh toán',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Tạm tính', '${reservation.subtotal.toStringAsFixed(0)}đ'),
                    _buildInfoRow('Phí phục vụ (10%)', '${reservation.serviceCharge.toStringAsFixed(0)}đ'),
                    if (reservation.discount > 0)
                      _buildInfoRow('Giảm giá', '-${reservation.discount.toStringAsFixed(0)}đ'),
                    const Divider(),
                    _buildInfoRow(
                      'Tổng cộng',
                      '${reservation.total.toStringAsFixed(0)}đ',
                      isTotal: true,
                    ),
                    if (reservation.paymentMethod != null)
                      _buildInfoRow('Phương thức', reservation.paymentMethod!),
                    _buildInfoRow('Trạng thái TT', reservation.paymentStatus),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: reservation.status == 'seated' && reservation.paymentStatus == 'pending'
          ? Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _showPaymentDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.orange.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }
}

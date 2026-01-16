import 'package:flutter/material.dart';
import '../utils/seed_data.dart';

class AdminSeedScreen extends StatefulWidget {
  const AdminSeedScreen({super.key});

  @override
  State<AdminSeedScreen> createState() => _AdminSeedScreenState();
}

class _AdminSeedScreenState extends State<AdminSeedScreen> {
  bool _isSeeding = false;
  String _message = '';

  Future<void> _seedData() async {
    setState(() {
      _isSeeding = true;
      _message = 'Đang seed dữ liệu...';
    });

    try {
      await SeedData.seedAll();
      setState(() {
        _isSeeding = false;
        _message = 'Seed dữ liệu thành công!';
      });
    } catch (e) {
      setState(() {
        _isSeeding = false;
        _message = 'Lỗi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Seed Data'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.admin_panel_settings, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                'Seed dữ liệu mẫu vào Firestore',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sẽ tạo:\n- 5 customers\n- 20+ menu items\n- 7+ reservations',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _message.contains('thành công')
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('thành công')
                          ? Colors.green.shade900
                          : Colors.orange.shade900,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSeeding ? null : _seedData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSeeding
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Seed Dữ Liệu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

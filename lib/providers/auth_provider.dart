import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';
import '../repositories/customer_repository.dart';

class AuthProvider with ChangeNotifier {
  final CustomerRepository _customerRepository = CustomerRepository();
  Customer? _currentCustomer;
  bool _isLoading = false;

  Customer? get currentCustomer => _currentCustomer;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentCustomer != null;

  // Đăng nhập
  Future<bool> login(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      Customer? customer = await _customerRepository.getCustomerByEmail(email);
      if (customer != null) {
        _currentCustomer = customer;
        // Lưu vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerId', customer.customerId);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  // Đăng ký
  Future<bool> register(Customer customer) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kiểm tra email đã tồn tại chưa
      Customer? existingCustomer = await _customerRepository.getCustomerByEmail(customer.email);
      if (existingCustomer != null) {
        _isLoading = false;
        notifyListeners();
        throw Exception('Email đã được sử dụng');
      }

      String customerId = await _customerRepository.addCustomer(customer);
      Customer? newCustomer = await _customerRepository.getCustomerById(customerId);
      if (newCustomer != null) {
        _currentCustomer = newCustomer;
        // Lưu vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerId', customerId);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _currentCustomer = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('customerId');
    notifyListeners();
  }

  // Kiểm tra đã đăng nhập chưa (từ SharedPreferences)
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? customerId = prefs.getString('customerId');
      if (customerId != null) {
        Customer? customer = await _customerRepository.getCustomerById(customerId);
        if (customer != null) {
          _currentCustomer = customer;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh thông tin customer
  Future<void> refreshCustomer() async {
    if (_currentCustomer != null) {
      try {
        Customer? customer = await _customerRepository.getCustomerById(_currentCustomer!.customerId);
        if (customer != null) {
          _currentCustomer = customer;
          notifyListeners();
        }
      } catch (e) {
        // Ignore error
      }
    }
  }
}

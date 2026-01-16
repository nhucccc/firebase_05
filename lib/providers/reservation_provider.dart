import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation.dart';
import '../models/order_item.dart';
import '../repositories/reservation_repository.dart';

class ReservationProvider with ChangeNotifier {
  final ReservationRepository _reservationRepository = ReservationRepository();
  
  List<Reservation> _reservations = [];
  Reservation? _currentReservation;
  bool _isLoading = false;

  List<Reservation> get reservations => _reservations;
  Reservation? get currentReservation => _currentReservation;
  bool get isLoading => _isLoading;

  // Tạo đặt bàn mới
  Future<String?> createReservation(
    String customerId,
    DateTime reservationDate,
    int numberOfGuests,
    String? specialRequests,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      String reservationId = await _reservationRepository.createReservation(
        customerId,
        Timestamp.fromDate(reservationDate),
        numberOfGuests,
        specialRequests,
      );
      
      // Load lại reservation vừa tạo
      _currentReservation = await _reservationRepository.getReservationById(reservationId);
      
      _isLoading = false;
      notifyListeners();
      return reservationId;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Lỗi khi tạo đặt bàn: $e');
    }
  }

  // Thêm món vào đơn
  Future<void> addItemToReservation(String reservationId, String itemId, int quantity) async {
    try {
      await _reservationRepository.addItemToReservation(reservationId, itemId, quantity);
      
      // Refresh current reservation
      if (_currentReservation?.reservationId == reservationId) {
        _currentReservation = await _reservationRepository.getReservationById(reservationId);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Xóa món khỏi đơn
  Future<void> removeItemFromReservation(String reservationId, String itemId) async {
    try {
      await _reservationRepository.removeItemFromReservation(reservationId, itemId);
      
      // Refresh current reservation
      if (_currentReservation?.reservationId == reservationId) {
        _currentReservation = await _reservationRepository.getReservationById(reservationId);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Xác nhận đặt bàn
  Future<void> confirmReservation(String reservationId, String tableNumber) async {
    try {
      await _reservationRepository.confirmReservation(reservationId, tableNumber);
      
      // Refresh
      if (_currentReservation?.reservationId == reservationId) {
        _currentReservation = await _reservationRepository.getReservationById(reservationId);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Thanh toán
  Future<void> payReservation(String reservationId, String paymentMethod, {int loyaltyPointsToUse = 0}) async {
    try {
      await _reservationRepository.payReservation(reservationId, paymentMethod, loyaltyPointsToUse: loyaltyPointsToUse);
      
      // Refresh
      await loadReservationsByCustomer(_currentReservation!.customerId);
    } catch (e) {
      rethrow;
    }
  }

  // Load reservations của customer
  Future<void> loadReservationsByCustomer(String customerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reservations = await _reservationRepository.getReservationsByCustomer(customerId);
      // Sort ở client side thay vì Firestore
      _reservations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Lỗi khi tải danh sách đặt bàn: $e');
    }
  }

  // Set current reservation
  void setCurrentReservation(Reservation? reservation) {
    _currentReservation = reservation;
    notifyListeners();
  }

  // Clear current reservation
  void clearCurrentReservation() {
    _currentReservation = null;
    notifyListeners();
  }

  // Update reservation status
  Future<void> updateReservationStatus(String reservationId, String status) async {
    try {
      await _reservationRepository.updateReservationStatus(reservationId, status);
      await loadReservationsByCustomer(_currentReservation!.customerId);
    } catch (e) {
      rethrow;
    }
  }
}

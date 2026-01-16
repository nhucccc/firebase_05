import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation.dart';
import '../models/order_item.dart';
import '../models/menu_item.dart';
import '../services/firebase_service.dart';
import 'menu_item_repository.dart';
import 'customer_repository.dart';

class ReservationRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final MenuItemRepository _menuItemRepository = MenuItemRepository();
  final CustomerRepository _customerRepository = CustomerRepository();

  // 1. Đặt Bàn (5 điểm)
  Future<String> createReservation(
    String customerId,
    Timestamp reservationDate,
    int numberOfGuests,
    String? specialRequests,
  ) async {
    try {
      // Kiểm tra không đặt trùng thời gian (optional - có thể bỏ qua)
      // Ở đây tôi sẽ cho phép đặt nhiều bàn cùng lúc

      Reservation reservation = Reservation(
        reservationId: '',
        customerId: customerId,
        reservationDate: reservationDate,
        numberOfGuests: numberOfGuests,
        status: 'pending',
        specialRequests: specialRequests,
        orderItems: [],
        subtotal: 0,
        serviceCharge: 0,
        discount: 0,
        total: 0,
        paymentStatus: 'pending',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      DocumentReference docRef = await _firebaseService.reservationsCollection.add(reservation.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi đặt bàn: $e');
    }
  }

  // 2. Thêm Món vào Đơn (3 điểm)
  Future<void> addItemToReservation(String reservationId, String itemId, int quantity) async {
    try {
      // Kiểm tra item isAvailable
      MenuItem? menuItem = await _menuItemRepository.getMenuItemById(itemId);
      if (menuItem == null) {
        throw Exception('Món ăn không tồn tại');
      }
      if (!menuItem.isAvailable) {
        throw Exception('Món ăn hiện không còn phục vụ');
      }

      // Lấy reservation hiện tại
      DocumentSnapshot doc = await _firebaseService.reservationsCollection.doc(reservationId).get();
      if (!doc.exists) {
        throw Exception('Đặt bàn không tồn tại');
      }

      Reservation reservation = Reservation.fromFirestore(doc);

      // Kiểm tra xem món đã có trong order chưa
      List<OrderItem> updatedOrderItems = List.from(reservation.orderItems);
      int existingIndex = updatedOrderItems.indexWhere((item) => item.itemId == itemId);

      if (existingIndex >= 0) {
        // Nếu đã có, tăng số lượng
        OrderItem existingItem = updatedOrderItems[existingIndex];
        updatedOrderItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        // Nếu chưa có, thêm mới
        updatedOrderItems.add(OrderItem(
          itemId: itemId,
          itemName: menuItem.name,
          quantity: quantity,
          price: menuItem.price,
        ));
      }

      // Tính lại subtotal, serviceCharge, total
      double subtotal = updatedOrderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
      double serviceCharge = subtotal * 0.1; // 10% phí phục vụ
      double total = subtotal + serviceCharge - reservation.discount;

      // Cập nhật vào Firestore
      await _firebaseService.reservationsCollection.doc(reservationId).update({
        'orderItems': updatedOrderItems.map((item) => item.toMap()).toList(),
        'subtotal': subtotal,
        'serviceCharge': serviceCharge,
        'total': total,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Lỗi khi thêm món vào đơn: $e');
    }
  }

  // 3. Xác nhận Đặt Bàn (2 điểm)
  Future<void> confirmReservation(String reservationId, String tableNumber) async {
    try {
      await _firebaseService.reservationsCollection.doc(reservationId).update({
        'status': 'confirmed',
        'tableNumber': tableNumber,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Lỗi khi xác nhận đặt bàn: $e');
    }
  }

  // 4. Thanh toán (3 điểm)
  Future<void> payReservation(String reservationId, String paymentMethod, {int loyaltyPointsToUse = 0}) async {
    try {
      // Lấy reservation
      DocumentSnapshot doc = await _firebaseService.reservationsCollection.doc(reservationId).get();
      if (!doc.exists) {
        throw Exception('Đặt bàn không tồn tại');
      }

      Reservation reservation = Reservation.fromFirestore(doc);

      // Tính discount từ loyaltyPoints (1 point = 1000đ, tối đa 50% total)
      double maxDiscount = reservation.total * 0.5;
      double discount = (loyaltyPointsToUse * 1000).toDouble();
      if (discount > maxDiscount) {
        discount = maxDiscount;
      }

      // Tính lại total sau discount
      double finalTotal = reservation.total - discount;

      // Tính loyaltyPoints được cộng (1% total)
      int earnedPoints = (finalTotal * 0.01).floor();

      // Cập nhật reservation
      await _firebaseService.reservationsCollection.doc(reservationId).update({
        'discount': discount,
        'total': finalTotal,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'paid',
        'status': 'completed',
        'updatedAt': Timestamp.now(),
      });

      // Cộng loyaltyPoints cho customer
      await _customerRepository.updateLoyaltyPoints(reservation.customerId, earnedPoints);

      // Trừ loyaltyPoints đã dùng
      if (loyaltyPointsToUse > 0) {
        await _customerRepository.updateLoyaltyPoints(reservation.customerId, -loyaltyPointsToUse);
      }
    } catch (e) {
      throw Exception('Lỗi khi thanh toán: $e');
    }
  }

  // 5. Lấy Đặt Bàn
  Future<List<Reservation>> getReservationsByCustomer(String customerId) async {
    try {
      // Bỏ orderBy để không cần composite index
      QuerySnapshot querySnapshot = await _firebaseService.reservationsCollection
          .where('customerId', isEqualTo: customerId)
          .get();
      return querySnapshot.docs.map((doc) => Reservation.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đặt bàn: $e');
    }
  }

  Stream<List<Reservation>> getReservationsByCustomerStream(String customerId) {
    return _firebaseService.reservationsCollection
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Reservation.fromFirestore(doc)).toList());
  }

  Future<List<Reservation>> getReservationsByDate(String date) async {
    try {
      // Parse date string to DateTime
      DateTime startDate = DateTime.parse(date);
      DateTime endDate = startDate.add(const Duration(days: 1));

      QuerySnapshot querySnapshot = await _firebaseService.reservationsCollection
          .where('reservationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('reservationDate', isLessThan: Timestamp.fromDate(endDate))
          .get();
      return querySnapshot.docs.map((doc) => Reservation.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy đặt bàn theo ngày: $e');
    }
  }

  // Lấy reservation theo ID
  Future<Reservation?> getReservationById(String reservationId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.reservationsCollection.doc(reservationId).get();
      if (doc.exists) {
        return Reservation.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin đặt bàn: $e');
    }
  }

  // Cập nhật trạng thái
  Future<void> updateReservationStatus(String reservationId, String status) async {
    try {
      await _firebaseService.reservationsCollection.doc(reservationId).update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái: $e');
    }
  }

  // Xóa món khỏi đơn
  Future<void> removeItemFromReservation(String reservationId, String itemId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.reservationsCollection.doc(reservationId).get();
      if (!doc.exists) {
        throw Exception('Đặt bàn không tồn tại');
      }

      Reservation reservation = Reservation.fromFirestore(doc);
      List<OrderItem> updatedOrderItems = reservation.orderItems.where((item) => item.itemId != itemId).toList();

      // Tính lại
      double subtotal = updatedOrderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
      double serviceCharge = subtotal * 0.1;
      double total = subtotal + serviceCharge - reservation.discount;

      await _firebaseService.reservationsCollection.doc(reservationId).update({
        'orderItems': updatedOrderItems.map((item) => item.toMap()).toList(),
        'subtotal': subtotal,
        'serviceCharge': serviceCharge,
        'total': total,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Lỗi khi xóa món: $e');
    }
  }
}

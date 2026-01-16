import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer.dart';
import '../services/firebase_service.dart';

class CustomerRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // 1. Thêm Customer (3 điểm)
  Future<String> addCustomer(Customer customer) async {
    try {
      DocumentReference docRef = await _firebaseService.customersCollection.add(customer.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi thêm khách hàng: $e');
    }
  }

  // 2. Lấy Customer theo ID (2 điểm)
  Future<Customer?> getCustomerById(String customerId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.customersCollection.doc(customerId).get();
      if (doc.exists) {
        return Customer.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin khách hàng: $e');
    }
  }

  // 3. Lấy tất cả Customers (2 điểm)
  Future<List<Customer>> getAllCustomers() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.customersCollection.get();
      return querySnapshot.docs.map((doc) => Customer.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách khách hàng: $e');
    }
  }

  // Stream để lắng nghe real-time
  Stream<List<Customer>> getAllCustomersStream() {
    return _firebaseService.customersCollection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Customer.fromFirestore(doc)).toList(),
    );
  }

  // 4. Cập nhật Customer (3 điểm)
  Future<void> updateCustomer(String customerId, Map<String, dynamic> data) async {
    try {
      await _firebaseService.customersCollection.doc(customerId).update(data);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật khách hàng: $e');
    }
  }

  // 5. Cập nhật Loyalty Points (2 điểm)
  Future<void> updateLoyaltyPoints(String customerId, int points) async {
    try {
      DocumentSnapshot doc = await _firebaseService.customersCollection.doc(customerId).get();
      if (doc.exists) {
        Customer customer = Customer.fromFirestore(doc);
        int newPoints = customer.loyaltyPoints + points;
        await _firebaseService.customersCollection.doc(customerId).update({
          'loyaltyPoints': newPoints,
        });
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật điểm tích lũy: $e');
    }
  }

  // Tìm customer theo email (để đăng nhập)
  Future<Customer?> getCustomerByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.customersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return Customer.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi tìm khách hàng theo email: $e');
    }
  }

  // Xóa customer (nếu cần)
  Future<void> deleteCustomer(String customerId) async {
    try {
      await _firebaseService.customersCollection.doc(customerId).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa khách hàng: $e');
    }
  }
}

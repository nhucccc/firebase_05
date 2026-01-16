import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections references
  CollectionReference get customersCollection => _firestore.collection('customers');
  CollectionReference get menuItemsCollection => _firestore.collection('menu_items');
  CollectionReference get reservationsCollection => _firestore.collection('reservations');

  // Getter cho Firestore instance (nếu cần truy cập trực tiếp)
  FirebaseFirestore get firestore => _firestore;
}

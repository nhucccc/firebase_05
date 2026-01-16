import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String customerId;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String address;
  final List<String> preferences;
  final int loyaltyPoints;
  final Timestamp createdAt;
  final bool isActive;

  Customer({
    required this.customerId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.preferences,
    required this.loyaltyPoints,
    required this.createdAt,
    required this.isActive,
  });

  // Convert từ Firestore Document sang Customer object
  factory Customer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Customer(
      customerId: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      preferences: List<String>.from(data['preferences'] ?? []),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  // Convert từ Customer object sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'preferences': preferences,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  // Copy with method để cập nhật một số field
  Customer copyWith({
    String? customerId,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? address,
    List<String>? preferences,
    int? loyaltyPoints,
    Timestamp? createdAt,
    bool? isActive,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      preferences: preferences ?? this.preferences,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

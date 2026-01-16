import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_item.dart';

class Reservation {
  final String reservationId;
  final String customerId;
  final Timestamp reservationDate;
  final int numberOfGuests;
  final String? tableNumber;
  final String status;
  final String? specialRequests;
  final List<OrderItem> orderItems;
  final double subtotal;
  final double serviceCharge;
  final double discount;
  final double total;
  final String? paymentMethod;
  final String paymentStatus;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Reservation({
    required this.reservationId,
    required this.customerId,
    required this.reservationDate,
    required this.numberOfGuests,
    this.tableNumber,
    required this.status,
    this.specialRequests,
    required this.orderItems,
    required this.subtotal,
    required this.serviceCharge,
    required this.discount,
    required this.total,
    this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert từ Firestore Document sang Reservation object
  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Parse orderItems array
    List<OrderItem> items = [];
    if (data['orderItems'] != null) {
      items = (data['orderItems'] as List)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return Reservation(
      reservationId: doc.id,
      customerId: data['customerId'] ?? '',
      reservationDate: data['reservationDate'] ?? Timestamp.now(),
      numberOfGuests: data['numberOfGuests'] ?? 0,
      tableNumber: data['tableNumber'],
      status: data['status'] ?? 'pending',
      specialRequests: data['specialRequests'],
      orderItems: items,
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      serviceCharge: (data['serviceCharge'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'],
      paymentStatus: data['paymentStatus'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  // Convert từ Reservation object sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'reservationDate': reservationDate,
      'numberOfGuests': numberOfGuests,
      'tableNumber': tableNumber,
      'status': status,
      'specialRequests': specialRequests,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Copy with method
  Reservation copyWith({
    String? reservationId,
    String? customerId,
    Timestamp? reservationDate,
    int? numberOfGuests,
    String? tableNumber,
    String? status,
    String? specialRequests,
    List<OrderItem>? orderItems,
    double? subtotal,
    double? serviceCharge,
    double? discount,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Reservation(
      reservationId: reservationId ?? this.reservationId,
      customerId: customerId ?? this.customerId,
      reservationDate: reservationDate ?? this.reservationDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      tableNumber: tableNumber ?? this.tableNumber,
      status: status ?? this.status,
      specialRequests: specialRequests ?? this.specialRequests,
      orderItems: orderItems ?? this.orderItems,
      subtotal: subtotal ?? this.subtotal,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

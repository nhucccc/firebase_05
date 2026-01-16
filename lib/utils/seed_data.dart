import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Seed 5 customers
  static Future<void> seedCustomers() async {
    final customers = [
      {
        'email': 'customer1@example.com',
        'fullName': 'Nguyễn Văn A',
        'phoneNumber': '0901234567',
        'address': '123 Đường ABC, Quận 1, TP.HCM',
        'preferences': ['spicy', 'seafood'],
        'loyaltyPoints': 100,
        'createdAt': Timestamp.now(),
        'isActive': true,
      },
      {
        'email': 'customer2@example.com',
        'fullName': 'Trần Thị B',
        'phoneNumber': '0902345678',
        'address': '456 Đường DEF, Quận 2, TP.HCM',
        'preferences': ['vegetarian', 'healthy'],
        'loyaltyPoints': 250,
        'createdAt': Timestamp.now(),
        'isActive': true,
      },
      {
        'email': 'customer3@example.com',
        'fullName': 'Lê Văn C',
        'phoneNumber': '0903456789',
        'address': '789 Đường GHI, Quận 3, TP.HCM',
        'preferences': ['meat', 'spicy'],
        'loyaltyPoints': 50,
        'createdAt': Timestamp.now(),
        'isActive': true,
      },
      {
        'email': 'customer4@example.com',
        'fullName': 'Phạm Thị D',
        'phoneNumber': '0904567890',
        'address': '321 Đường JKL, Quận 4, TP.HCM',
        'preferences': ['dessert', 'seafood'],
        'loyaltyPoints': 500,
        'createdAt': Timestamp.now(),
        'isActive': true,
      },
      {
        'email': 'customer5@example.com',
        'fullName': 'Hoàng Văn E',
        'phoneNumber': '0905678901',
        'address': '654 Đường MNO, Quận 5, TP.HCM',
        'preferences': ['spicy', 'meat', 'dessert'],
        'loyaltyPoints': 150,
        'createdAt': Timestamp.now(),
        'isActive': true,
      },
    ];

    for (var customer in customers) {
      await _firestore.collection('customers').add(customer);
    }
    print('✅ Đã seed 5 customers');
  }

  // Seed 20+ menu items
  static Future<void> seedMenuItems() async {
    final menuItems = [
      // Appetizers
      {
        'name': 'Gỏi cuốn tôm thịt',
        'description': 'Gỏi cuốn tươi ngon với tôm, thịt, rau sống',
        'category': 'Appetizer',
        'price': 35000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=500',
        'ingredients': ['Tôm', 'Thịt heo', 'Rau sống', 'Bún', 'Bánh tráng'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Nem rán',
        'description': 'Nem rán giòn rụm, nhân thịt heo và rau củ',
        'category': 'Appetizer',
        'price': 40000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500',
        'ingredients': ['Thịt heo', 'Mộc nhĩ', 'Cà rốt', 'Bánh đa nem'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.7,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Salad rau củ',
        'description': 'Salad tươi mát với rau củ hữu cơ',
        'category': 'Appetizer',
        'price': 30000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500',
        'ingredients': ['Xà lách', 'Cà chua', 'Dưa leo', 'Cà rốt', 'Sốt'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.2,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Chả giò chay',
        'description': 'Chả giò chay giòn tan, nhân nấm và rau củ',
        'category': 'Appetizer',
        'price': 35000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=500',
        'ingredients': ['Nấm', 'Cà rốt', 'Bắp cải', 'Bánh đa nem'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.4,
        'createdAt': Timestamp.now(),
      },

      // Main Course
      {
        'name': 'Phở bò',
        'description': 'Phở bò truyền thống Hà Nội, nước dùng đậm đà',
        'category': 'Main Course',
        'price': 55000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1591814468924-caf88d1232e1?w=500',
        'ingredients': ['Thịt bò', 'Bánh phở', 'Hành', 'Ngò', 'Nước dùng'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 20,
        'isAvailable': true,
        'rating': 4.8,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Cơm tấm sườn bì chả',
        'description': 'Cơm tấm Sài Gòn với sườn nướng, bì, chả',
        'category': 'Main Course',
        'price': 50000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1626804475297-41608ea09aeb?w=500',
        'ingredients': ['Cơm tấm', 'Sườn nướng', 'Bì', 'Chả', 'Nước mắm'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 25,
        'isAvailable': true,
        'rating': 4.6,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Bún chả Hà Nội',
        'description': 'Bún chả thơm ngon với chả nướng than hoa',
        'category': 'Main Course',
        'price': 45000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1569562211093-4ed0d0758f12?w=500',
        'ingredients': ['Bún', 'Chả nướng', 'Thịt nướng', 'Rau sống', 'Nước mắm'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 20,
        'isAvailable': true,
        'rating': 4.7,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Mì Quảng',
        'description': 'Mì Quảng đặc sản miền Trung',
        'category': 'Main Course',
        'price': 48000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=500',
        'ingredients': ['Mì Quảng', 'Tôm', 'Thịt', 'Trứng', 'Rau sống'],
        'isVegetarian': false,
        'isSpicy': true,
        'preparationTime': 25,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Cơm chiên dương châu',
        'description': 'Cơm chiên thập cẩm kiểu Hoa',
        'category': 'Main Course',
        'price': 42000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500',
        'ingredients': ['Cơm', 'Tôm', 'Xúc xích', 'Trứng', 'Rau củ'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.3,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Bún bò Huế',
        'description': 'Bún bò Huế cay nồng đặc trưng',
        'category': 'Main Course',
        'price': 52000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=500',
        'ingredients': ['Bún', 'Thịt bò', 'Chả', 'Sả', 'Ớt'],
        'isVegetarian': false,
        'isSpicy': true,
        'preparationTime': 25,
        'isAvailable': true,
        'rating': 4.6,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Cơm chay',
        'description': 'Cơm chay đầy đủ dinh dưỡng',
        'category': 'Main Course',
        'price': 38000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
        'ingredients': ['Cơm', 'Đậu hũ', 'Rau củ', 'Nấm'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 20,
        'isAvailable': true,
        'rating': 4.2,
        'createdAt': Timestamp.now(),
      },

      // Desserts
      {
        'name': 'Chè ba màu',
        'description': 'Chè ba màu mát lạnh, ngọt dịu',
        'category': 'Dessert',
        'price': 25000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500',
        'ingredients': ['Đậu xanh', 'Đậu đỏ', 'Thạch', 'Nước cốt dừa'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.4,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Bánh flan',
        'description': 'Bánh flan mềm mịn, thơm ngon',
        'category': 'Dessert',
        'price': 20000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500',
        'ingredients': ['Trứng', 'Sữa', 'Đường', 'Vani'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.3,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Trái cây tươi',
        'description': 'Đĩa trái cây tươi theo mùa',
        'category': 'Dessert',
        'price': 30000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=500',
        'ingredients': ['Dưa hấu', 'Dứa', 'Xoài', 'Nho'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Kem dừa',
        'description': 'Kem dừa mát lạnh, béo ngậy',
        'category': 'Dessert',
        'price': 28000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=500',
        'ingredients': ['Nước cốt dừa', 'Sữa', 'Đường'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': false,
        'rating': 4.6,
        'createdAt': Timestamp.now(),
      },

      // Beverages
      {
        'name': 'Trà đá',
        'description': 'Trà đá giải khát',
        'category': 'Beverage',
        'price': 5000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500',
        'ingredients': ['Trà', 'Đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 2,
        'isAvailable': true,
        'rating': 4.0,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Cà phê sữa đá',
        'description': 'Cà phê phin truyền thống',
        'category': 'Beverage',
        'price': 22000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=500',
        'ingredients': ['Cà phê', 'Sữa đặc', 'Đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.7,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Nước ép cam',
        'description': 'Nước ép cam tươi 100%',
        'category': 'Beverage',
        'price': 25000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500',
        'ingredients': ['Cam tươi'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Sinh tố bơ',
        'description': 'Sinh tố bơ béo ngậy',
        'category': 'Beverage',
        'price': 30000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=500',
        'ingredients': ['Bơ', 'Sữa', 'Đường', 'Đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.6,
        'createdAt': Timestamp.now(),
      },

      // Soups
      {
        'name': 'Canh chua cá',
        'description': 'Canh chua cá lóc miền Nam',
        'category': 'Soup',
        'price': 45000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
        'ingredients': ['Cá lóc', 'Me', 'Thơm', 'Rau muống', 'Cà chua'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 20,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Súp gà',
        'description': 'Súp gà nóng hổi, bổ dưỡng',
        'category': 'Soup',
        'price': 35000.0,
        'imageUrl': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500',
        'ingredients': ['Gà', 'Nấm', 'Cà rốt', 'Ngô'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.4,
        'createdAt': Timestamp.now(),
      },
    ];

    for (var item in menuItems) {
      await _firestore.collection('menu_items').add(item);
    }
    print('✅ Đã seed ${menuItems.length} menu items');
  }

  // Seed reservations (cần có customer IDs trước)
  static Future<void> seedReservations(List<String> customerIds) async {
    if (customerIds.length < 5) {
      print('❌ Cần ít nhất 5 customer IDs');
      return;
    }

    final now = DateTime.now();
    final reservations = [
      {
        'customerId': customerIds[0],
        'reservationDate': Timestamp.fromDate(now.add(const Duration(days: 1))),
        'numberOfGuests': 4,
        'tableNumber': 'A1',
        'status': 'confirmed',
        'specialRequests': 'Bàn gần cửa sổ',
        'orderItems': [],
        'subtotal': 0.0,
        'serviceCharge': 0.0,
        'discount': 0.0,
        'total': 0.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'customerId': customerIds[1],
        'reservationDate': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        'numberOfGuests': 2,
        'tableNumber': 'B2',
        'status': 'completed',
        'specialRequests': null,
        'orderItems': [
          {'itemId': 'item1', 'itemName': 'Phở bò', 'quantity': 2, 'price': 55000.0},
          {'itemId': 'item2', 'itemName': 'Cà phê sữa đá', 'quantity': 2, 'price': 22000.0},
        ],
        'subtotal': 154000.0,
        'serviceCharge': 15400.0,
        'discount': 0.0,
        'total': 169400.0,
        'paymentMethod': 'cash',
        'paymentStatus': 'paid',
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
      },
      {
        'customerId': customerIds[2],
        'reservationDate': Timestamp.fromDate(now.add(const Duration(hours: 3))),
        'numberOfGuests': 6,
        'tableNumber': null,
        'status': 'pending',
        'specialRequests': 'Không hành',
        'orderItems': [],
        'subtotal': 0.0,
        'serviceCharge': 0.0,
        'discount': 0.0,
        'total': 0.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'customerId': customerIds[3],
        'reservationDate': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
        'numberOfGuests': 3,
        'tableNumber': 'C3',
        'status': 'completed',
        'specialRequests': null,
        'orderItems': [
          {'itemId': 'item3', 'itemName': 'Cơm tấm', 'quantity': 3, 'price': 50000.0},
          {'itemId': 'item4', 'itemName': 'Trà đá', 'quantity': 3, 'price': 5000.0},
        ],
        'subtotal': 165000.0,
        'serviceCharge': 16500.0,
        'discount': 50000.0,
        'total': 131500.0,
        'paymentMethod': 'card',
        'paymentStatus': 'paid',
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
      },
      {
        'customerId': customerIds[4],
        'reservationDate': Timestamp.fromDate(now.add(const Duration(days: 2))),
        'numberOfGuests': 8,
        'tableNumber': 'D4',
        'status': 'confirmed',
        'specialRequests': 'Sinh nhật, cần bánh kem',
        'orderItems': [],
        'subtotal': 0.0,
        'serviceCharge': 0.0,
        'discount': 0.0,
        'total': 0.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'customerId': customerIds[0],
        'reservationDate': Timestamp.fromDate(now.subtract(const Duration(days: 10))),
        'numberOfGuests': 2,
        'tableNumber': null,
        'status': 'cancelled',
        'specialRequests': null,
        'orderItems': [],
        'subtotal': 0.0,
        'serviceCharge': 0.0,
        'discount': 0.0,
        'total': 0.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': Timestamp.fromDate(now.subtract(const Duration(days: 10))),
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(days: 10))),
      },
      {
        'customerId': customerIds[1],
        'reservationDate': Timestamp.fromDate(now),
        'numberOfGuests': 4,
        'tableNumber': 'E5',
        'status': 'seated',
        'specialRequests': null,
        'orderItems': [
          {'itemId': 'item5', 'itemName': 'Bún chả', 'quantity': 4, 'price': 45000.0},
          {'itemId': 'item6', 'itemName': 'Nước ép cam', 'quantity': 4, 'price': 25000.0},
        ],
        'subtotal': 280000.0,
        'serviceCharge': 28000.0,
        'discount': 0.0,
        'total': 308000.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    for (var reservation in reservations) {
      await _firestore.collection('reservations').add(reservation);
    }
    print('✅ Đã seed ${reservations.length} reservations');
  }

  // Seed tất cả dữ liệu
  static Future<void> seedAll() async {
    try {
      print('🌱 Bắt đầu seed dữ liệu...');
      
      await seedCustomers();
      await seedMenuItems();
      
      // Lấy customer IDs để seed reservations
      final customersSnapshot = await _firestore.collection('customers').get();
      final customerIds = customersSnapshot.docs.map((doc) => doc.id).toList();
      
      await seedReservations(customerIds);
      
      print('✅ Hoàn thành seed dữ liệu!');
    } catch (e) {
      print('❌ Lỗi khi seed dữ liệu: $e');
    }
  }
}

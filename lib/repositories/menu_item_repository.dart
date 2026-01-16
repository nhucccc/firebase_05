import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';
import '../services/firebase_service.dart';

class MenuItemRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // 1. Thêm MenuItem (3 điểm)
  Future<String> addMenuItem(MenuItem menuItem) async {
    try {
      DocumentReference docRef = await _firebaseService.menuItemsCollection.add(menuItem.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi thêm món ăn: $e');
    }
  }

  // 2. Lấy MenuItem theo ID (2 điểm)
  Future<MenuItem?> getMenuItemById(String itemId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.menuItemsCollection.doc(itemId).get();
      if (doc.exists) {
        return MenuItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin món ăn: $e');
    }
  }

  // 3. Lấy tất cả MenuItems (2 điểm)
  Future<List<MenuItem>> getAllMenuItems() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.menuItemsCollection.get();
      return querySnapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách món ăn: $e');
    }
  }

  // Stream để lắng nghe real-time
  Stream<List<MenuItem>> getAllMenuItemsStream() {
    return _firebaseService.menuItemsCollection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList(),
    );
  }

  // 4. Tìm kiếm MenuItems (4 điểm)
  // Tìm trong name, description, ingredients
  Future<List<MenuItem>> searchMenuItems(String keyword) async {
    try {
      if (keyword.isEmpty) {
        return await getAllMenuItems();
      }

      // Lấy tất cả items và filter ở client side
      // (Firestore không hỗ trợ full-text search nên phải filter ở client)
      List<MenuItem> allItems = await getAllMenuItems();
      String lowerKeyword = keyword.toLowerCase();

      return allItems.where((item) {
        bool nameMatch = item.name.toLowerCase().contains(lowerKeyword);
        bool descMatch = item.description.toLowerCase().contains(lowerKeyword);
        bool ingredientsMatch = item.ingredients.any(
          (ingredient) => ingredient.toLowerCase().contains(lowerKeyword),
        );
        return nameMatch || descMatch || ingredientsMatch;
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm món ăn: $e');
    }
  }

  // 5. Lọc MenuItems (3 điểm)
  // Theo category
  Future<List<MenuItem>> filterByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.menuItemsCollection
          .where('category', isEqualTo: category)
          .get();
      return querySnapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lọc món ăn theo danh mục: $e');
    }
  }

  // Theo isVegetarian
  Future<List<MenuItem>> filterByVegetarian(bool isVegetarian) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.menuItemsCollection
          .where('isVegetarian', isEqualTo: isVegetarian)
          .get();
      return querySnapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lọc món chay: $e');
    }
  }

  // Theo isSpicy
  Future<List<MenuItem>> filterBySpicy(bool isSpicy) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.menuItemsCollection
          .where('isSpicy', isEqualTo: isSpicy)
          .get();
      return querySnapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lọc món cay: $e');
    }
  }

  // Lọc kết hợp nhiều điều kiện
  Future<List<MenuItem>> filterMenuItems({
    String? category,
    bool? isVegetarian,
    bool? isSpicy,
  }) async {
    try {
      Query query = _firebaseService.menuItemsCollection;

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      if (isVegetarian != null) {
        query = query.where('isVegetarian', isEqualTo: isVegetarian);
      }
      if (isSpicy != null) {
        query = query.where('isSpicy', isEqualTo: isSpicy);
      }

      QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lọc món ăn: $e');
    }
  }

  // Cập nhật MenuItem
  Future<void> updateMenuItem(String itemId, Map<String, dynamic> data) async {
    try {
      await _firebaseService.menuItemsCollection.doc(itemId).update(data);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật món ăn: $e');
    }
  }

  // Xóa MenuItem
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _firebaseService.menuItemsCollection.doc(itemId).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa món ăn: $e');
    }
  }
}

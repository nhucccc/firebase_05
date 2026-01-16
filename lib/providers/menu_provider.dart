import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../repositories/menu_item_repository.dart';

class MenuProvider with ChangeNotifier {
  final MenuItemRepository _menuItemRepository = MenuItemRepository();
  
  List<MenuItem> _menuItems = [];
  List<MenuItem> _filteredMenuItems = [];
  bool _isLoading = false;
  String _searchKeyword = '';
  String? _selectedCategory;
  bool? _filterVegetarian;
  bool? _filterSpicy;

  List<MenuItem> get menuItems => _filteredMenuItems;
  bool get isLoading => _isLoading;
  String get searchKeyword => _searchKeyword;
  String? get selectedCategory => _selectedCategory;
  bool? get filterVegetarian => _filterVegetarian;
  bool? get filterSpicy => _filterSpicy;

  // Lấy danh sách menu items
  Future<void> loadMenuItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _menuItems = await _menuItemRepository.getAllMenuItems();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Lỗi khi tải menu: $e');
    }
  }

  // Tìm kiếm
  Future<void> search(String keyword) async {
    _searchKeyword = keyword;
    _applyFilters();
    notifyListeners();
  }

  // Lọc theo category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Lọc theo vegetarian
  void filterByVegetarian(bool? isVegetarian) {
    _filterVegetarian = isVegetarian;
    _applyFilters();
    notifyListeners();
  }

  // Lọc theo spicy
  void filterBySpicy(bool? isSpicy) {
    _filterSpicy = isSpicy;
    _applyFilters();
    notifyListeners();
  }

  // Reset filters
  void resetFilters() {
    _searchKeyword = '';
    _selectedCategory = null;
    _filterVegetarian = null;
    _filterSpicy = null;
    _applyFilters();
    notifyListeners();
  }

  // Apply all filters
  void _applyFilters() {
    _filteredMenuItems = _menuItems.where((item) {
      // Search filter
      if (_searchKeyword.isNotEmpty) {
        String lowerKeyword = _searchKeyword.toLowerCase();
        bool nameMatch = item.name.toLowerCase().contains(lowerKeyword);
        bool descMatch = item.description.toLowerCase().contains(lowerKeyword);
        bool ingredientsMatch = item.ingredients.any(
          (ingredient) => ingredient.toLowerCase().contains(lowerKeyword),
        );
        if (!nameMatch && !descMatch && !ingredientsMatch) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
        if (item.category != _selectedCategory) {
          return false;
        }
      }

      // Vegetarian filter
      if (_filterVegetarian != null) {
        if (item.isVegetarian != _filterVegetarian) {
          return false;
        }
      }

      // Spicy filter
      if (_filterSpicy != null) {
        if (item.isSpicy != _filterSpicy) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Get menu item by ID
  MenuItem? getMenuItemById(String itemId) {
    try {
      return _menuItems.firstWhere((item) => item.itemId == itemId);
    } catch (e) {
      return null;
    }
  }
}

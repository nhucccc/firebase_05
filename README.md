# Restaurant App - 1771020345

Ứng dụng quản lý nhà hàng với Flutter và Firebase Firestore

## Thông tin sinh viên
- **Mã sinh viên**: 1771020345
- **Package name**: com.example.s1771020345 (Firebase không cho phép bắt đầu bằng số)
- **Project name**: flutter_app_1771020345

## Tính năng

### 1. Quản lý khách hàng
- Đăng ký tài khoản mới
- Đăng nhập bằng email
- Quản lý thông tin cá nhân
- Hệ thống điểm tích lũy (Loyalty Points)

### 2. Thực đơn
- Hiển thị danh sách món ăn với hình ảnh
- Tìm kiếm món ăn theo tên, mô tả, nguyên liệu
- Lọc theo danh mục (Appetizer, Main Course, Dessert, Beverage, Soup)
- Lọc món chay, món cay
- Xem chi tiết món ăn
- Real-time updates

### 3. Đặt bàn
- Tạo đặt bàn mới
- Chọn ngày giờ, số lượng khách
- Thêm yêu cầu đặc biệt
- Thêm món vào đơn
- Xem danh sách đặt bàn của tôi
- Theo dõi trạng thái đặt bàn

### 4. Thanh toán
- Thanh toán bằng tiền mặt, thẻ, online
- Sử dụng điểm tích lũy để giảm giá (1 điểm = 1000đ, tối đa 50%)
- Tự động tính phí phục vụ 10%
- Tích điểm sau mỗi lần thanh toán (1% tổng bill)

## Cấu trúc dự án

```
lib/
├── models/              # Data models
│   ├── customer.dart
│   ├── menu_item.dart
│   ├── order_item.dart
│   └── reservation.dart
├── repositories/        # Firebase CRUD operations
│   ├── customer_repository.dart
│   ├── menu_item_repository.dart
│   └── reservation_repository.dart
├── providers/           # State management (Provider)
│   ├── auth_provider.dart
│   ├── menu_provider.dart
│   └── reservation_provider.dart
├── screens/             # UI screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── menu_screen.dart
│   ├── menu_item_detail_screen.dart
│   ├── create_reservation_screen.dart
│   ├── add_items_screen.dart
│   ├── my_reservations_screen.dart
│   └── reservation_detail_screen.dart
├── services/            # Firebase service
│   └── firebase_service.dart
└── main.dart
```

## Cơ sở dữ liệu Firestore

### Collections

#### 1. customers
- customerId (Document ID)
- email
- fullName
- phoneNumber
- address
- preferences (Array)
- loyaltyPoints
- createdAt
- isActive

#### 2. menu_items
- itemId (Document ID)
- name
- description
- category
- price
- imageUrl
- ingredients (Array)
- isVegetarian
- isSpicy
- preparationTime
- isAvailable
- rating
- createdAt

#### 3. reservations
- reservationId (Document ID)
- customerId
- reservationDate
- numberOfGuests
- tableNumber
- status
- specialRequests
- orderItems (Array of Maps)
- subtotal
- serviceCharge
- discount
- total
- paymentMethod
- paymentStatus
- createdAt
- updatedAt

## Cài đặt và chạy

### 1. Cài đặt dependencies
```bash
flutter pub get
```

### 2. Cấu hình Firebase
- Tạo Firebase project tại https://console.firebase.google.com
- Thêm Android app với package name: `com.example.s1771020345`
- Tải file `google-services.json` và đặt vào `android/app/`
- Bật Firestore Database

**Lưu ý**: Firebase không cho phép package name bắt đầu bằng số, nên đã thêm chữ "s" ở đầu.

### 3. Chạy ứng dụng
```bash
flutter run
```

## Dữ liệu mẫu

### Customers (5 mẫu)
1. customer1@example.com - Nguyễn Văn A
2. customer2@example.com - Trần Thị B
3. customer3@example.com - Lê Văn C
4. customer4@example.com - Phạm Thị D
5. customer5@example.com - Hoàng Văn E

### Menu Items (20+ mẫu)
- Appetizers: Gỏi cuốn, Nem rán, Salad
- Main Course: Phở bò, Cơm tấm, Bún chả
- Dessert: Chè, Bánh flan, Trái cây
- Beverage: Trà đá, Cà phê, Nước ép
- Soup: Canh chua, Súp gà

### Reservations (10+ mẫu)
- Các trạng thái: pending, confirmed, seated, completed, cancelled

## Công nghệ sử dụng

- **Flutter**: Framework UI
- **Firebase Core**: Firebase SDK
- **Cloud Firestore**: NoSQL database
- **Provider**: State management
- **Shared Preferences**: Local storage
- **Intl**: Date formatting

## Tính năng nổi bật

✅ Repository Pattern cho clean architecture
✅ Real-time updates với Firestore streams
✅ Error handling đầy đủ
✅ UI/UX đẹp, responsive
✅ State management với Provider
✅ Loyalty points system
✅ Search và filter nâng cao
✅ Payment với discount

## Lưu ý

- Cần kết nối Internet để sử dụng Firebase
- Đảm bảo đã cấu hình Firebase đúng
- Dữ liệu mẫu cần được thêm vào Firestore thủ công hoặc qua script

## Liên hệ

- MSSV: 1771020345
- huyq91334@gmail.com

---

**Chúc chấm điểm!** 🚀

# News Reader App - Flutter

Một ứng dụng đọc báo được xây dựng bằng Flutter với Clean Architecture, cho phép người dùng đọc tin tức từ NewsAPI.org theo danh mục và xem chi tiết các bài báo một cách tiện lợi.

### Screenshots

![](screenshots/1.png)
![](screenshots/2.png)

## Chức năng chính

- **Đọc tin tức** từ NewsAPI.org với 7 danh mục khác nhau
- **Xem chi tiết bài báo** với đầy đủ thông tin và hình ảnh
- **Phân loại tin tức** theo danh mục (Tổng hợp, Kinh doanh, Giải trí, Sức khỏe, Khoa học, Thể thao, Công nghệ)

## Công nghệ & Kỹ thuật

### **Framework & Language**
- **Flutter** - Cross-platform development framework
- **Dart** - Programming language

### **State Management**
- **StatefulWidget** - Local state management
- **setState()** - Simple state updates
- **FutureBuilder** - Async data handling

### **Data Storage**
- **HTTP Package** - REST API integration
- **NewsAPI.org** - Real-time news data source
- **JSON Serialization** - Data conversion

### **UI Components**
- **Material Design 3** - Modern design system
- **FilterChip** - Category selection
- **ListView.builder** - Efficient scrollable list with lazy loading
- **Card & InkWell** - Clean article display
- **AppBar** - Navigation and actions
- **RefreshIndicator** - Pull-to-refresh functionality
- **CircularProgressIndicator** - Loading states

## Cài đặt và Chạy

### **Yêu cầu hệ thống**
- Flutter SDK (3.9.2 hoặc mới hơn)
- Dart SDK

### **1. Clone repository**
```bash
cd news_app
```

### **2. Cài đặt dependencies**
```bash
flutter pub get
```

### **3. Chạy ứng dụng**

#### **Trên Android Emulator:**
```bash
# Khởi động emulator
flutter emulators --launch <emulator_id>

# Chạy app
flutter run
```

#### **Trên Web Browser:**
```bash
flutter run -d chrome
```

#### **Build cho production:**
```bash
# Android APK
flutter build apk

# Web
flutter build web

# iOS (trên macOS)
flutter build ios
```

### **4. Development workflow**
```bash
# Chạy với hot reload
flutter run

# Trong terminal flutter run:
# r - Hot reload
# R - Hot restart  
# q - Quit

# Kiểm tra lỗi
flutter analyze

# Chạy tests
flutter test
```
# Photo Gallery App - Flutter

Một ứng dụng thư viện ảnh hiện đại được xây dựng bằng Flutter với Provider State Management, tích hợp camera và gallery access, lưu trữ local với quản lý permissions, và thiết kế minimalist với Modern Material Design 3.

## Chức năng chính

- **Chụp ảnh trực tiếp** với camera tích hợp và xử lý permissions
- **Chọn ảnh từ gallery** với khả năng chọn đơn lẻ hoặc nhiều ảnh cùng lúc
- **Hiển thị grid layout** với 2x2 responsive design và rounded corners
- **Xem ảnh fullscreen** với Hero animation và smooth transitions
- **Xóa ảnh** với selection mode và batch operations
- **Lưu trữ local** trong app directory với metadata management
- **Date badges** hiển thị thời gian chụp (Today/Yesterday/Date)

## Công nghệ & Kỹ thuật

### **Framework & Language**
- **Flutter** - Cross-platform development framework
- **Dart** - Programming language
- **Material Design 3** - Modern Google design system

### **State Management**
- **Provider** - State management solution
- **ChangeNotifier** - Observable pattern implementation
- **Consumer** - Widget để listen state changes

### **Camera & Media Access**
- **image_picker** - Camera và gallery access
- **permission_handler** - Runtime permissions management
- **Camera permissions** - CAMERA access
- **Storage permissions** - READ_MEDIA_IMAGES cho Android 13+
- **Legacy storage** - READ_EXTERNAL_STORAGE cho Android 12-

### **File Management**
- **path_provider** - App directory access
- **shared_preferences** - Metadata persistence
- **File System** - Local image storage và caching
- **Storage utilities** - File operations và cleanup

### **UI Components**
- **GridView** - 2x2 photo display layout theo yêu cầu
- **Hero Animation** - Smooth transitions between screens
- **Stack** - Overlay elements và floating buttons
- **Container** - Modern rounded corners và borders
- **ClipRRect** - Image clipping với border radius
- **Material InkWell** - Touch feedback cho buttons

### **Permissions & Platform**
- **device_info_plus** - Android version detection cho permissions
- **Platform detection** - iOS và Android specific logic
- **Runtime permissions** - Camera và storage access
- **Permission status handling** - Granted, denied, limited states

### **Architecture**
- **Model-View-Provider (MVP)** pattern
- **Separation of Concerns** - Models, Providers, Screens, Utils, Theme
- **Component-based** - Reusable widgets và utilities
- **Clean Code** principles với permission utilities

## Cài đặt và Chạy

### **Yêu cầu hệ thống**
- Flutter SDK (3.9.2 hoặc mới hơn)
- Dart SDK (3.9.2 hoặc mới hơn)
- Android Studio / VS Code
- Android Emulator hoặc thiết bị Android với camera
- iOS Simulator / Device (cho iOS testing)

### **1. Clone repository**
```bash
cd gallery_app
```

### **2. Cài đặt dependencies**
```bash
flutter pub get
```

### **3. Kiểm tra permissions trong AndroidManifest.xml**
```xml
<!-- Camera permission -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- Storage permissions cho Android 12- -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />

<!-- Media permissions cho Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VISUAL_USER_SELECTED" />
```

### **4. Kiểm tra code quality**
```bash
# Analyze code (should show "No issues found!")
flutter analyze

# Run tests
flutter test
```

### **5. Chạy ứng dụng**

#### **Trên Android Emulator:**
```bash
# Khởi động emulator
flutter emulators --launch <emulator_id>

# Chạy app với debug mode
flutter run --debug
```

#### **Trên iOS Simulator:**
```bash
flutter run -d ios
```

#### **Build cho production:**
```bash
# Android APK
flutter build apk --release

# iOS (trên macOS)
flutter build ios --release
```

### **6. Development workflow**
```bash
# Chạy với hot reload
flutter run

# Trong terminal flutter run:
# r - Hot reload
# R - Hot restart
# q - Quit

# Performance monitoring
flutter run --debug --trace-skia
```
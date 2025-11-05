import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Utility class for handling runtime permissions
class PermissionUtil {
  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request photo library/gallery permission
  static Future<bool> requestGalleryPermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ use photos permission, for older versions use storage
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        // Android 13+ (API 33+)
        var status = await Permission.photos.request();
        if (status.isDenied) {
          // Try requesting with limited access
          status = await Permission.photos.request();
        }
        return status.isGranted || status.isLimited;
      } else {
        // Android 12 and below
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else {
      // iOS
      var status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.photos.request();
      }
      return status.isGranted || status.isLimited;
    }
  }

  /// Request storage permission (for Android)
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        final status = await Permission.photos.request();
        return status.isGranted || status.isLimited;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // iOS doesn't need explicit storage permission
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if gallery permission is granted
  static Future<bool> isGalleryPermissionGranted() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        final status = await Permission.photos.status;
        return status.isGranted || status.isLimited;
      } else {
        final status = await Permission.storage.status;
        return status.isGranted;
      }
    } else {
      final status = await Permission.photos.status;
      return status.isGranted || status.isLimited;
    }
  }

  /// Open app settings for permission configuration
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Get Android SDK version
  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt;
      } catch (e) {
        // Fallback to assume modern Android version
        return 33;
      }
    }
    return 0;
  }
}

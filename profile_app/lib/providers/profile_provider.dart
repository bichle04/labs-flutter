import 'package:flutter/foundation.dart';
import '../models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  Profile _profile = Profile.sample();
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastReloadTime;
  int _reloadCount = 0;

  // Getters
  Profile get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastReloadTime => _lastReloadTime;
  int get reloadCount => _reloadCount;
  bool get hasError => _errorMessage != null;

  // Enhanced reload with error handling and retry
  Future<void> reloadProfile({bool showError = true}) async {
    if (_isLoading) return; // Prevent multiple simultaneous reloads

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay (varying based on reload count)
      final delay = _reloadCount > 3
          ? const Duration(seconds: 2)
          : const Duration(milliseconds: 800);

      await Future.delayed(delay);

      // Simulate occasional network failure (10% chance after 2nd reload)
      if (_reloadCount > 1 && DateTime.now().millisecond % 10 == 0) {
        throw Exception('Network timeout - please try again');
      }

      // Trong thực tế, đây sẽ là nơi gọi API để lấy dữ liệu mới
      // Hiện tại chỉ refresh với dữ liệu sample
      _profile = Profile.sample();
      _lastReloadTime = DateTime.now();
      _reloadCount++;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      if (showError) {
        debugPrint('Profile reload failed: $_errorMessage');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retry failed reload
  Future<void> retryReload() async {
    await reloadProfile(showError: true);
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset reload stats
  void resetReloadStats() {
    _reloadCount = 0;
    _lastReloadTime = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Update profile info (có thể mở rộng sau này)
  void updateProfile(Profile newProfile) {
    _profile = newProfile;
    notifyListeners();
  }

  // Update specific fields
  void updateName(String name) {
    _profile = _profile.copyWith(name: name);
    notifyListeners();
  }

  void updateTitle(String title) {
    _profile = _profile.copyWith(title: title);
    notifyListeners();
  }

  void updateBio(String bio) {
    _profile = _profile.copyWith(bio: bio);
    notifyListeners();
  }
}

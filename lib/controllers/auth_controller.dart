import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // NIM mahasiswa sebagai password wajib
  static const _nim = '123230115';

  static const _keyLoggedIn = 'is_logged_in';
  static const _keyCurrentUser = 'current_user';

  final isLoggedIn = false.obs;
  final isLoading = true.obs;
  final currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  /// Cek status login dari SharedPreferences saat app dibuka
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    final username = prefs.getString(_keyCurrentUser) ?? '';
    isLoggedIn.value = loggedIn;
    currentUsername.value = username;
    isLoading.value = false;
  }

  /// Login: username bebas, password wajib NIM
  Future<bool> login(String username, String password) async {
    if (username.trim().isEmpty) return false;
    if (password.trim() != _nim) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyCurrentUser, username.trim());

    currentUsername.value = username.trim();
    isLoggedIn.value = true;
    return true;
  }

  /// Logout: hapus sesi dari SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
    await prefs.remove(_keyCurrentUser);
    isLoggedIn.value = false;
    currentUsername.value = '';
  }
}

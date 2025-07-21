import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/models.dart';

part 'user_pod.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserState build() {
    return const UserState();
  }

  Future<void> login(String token, User user) async {
    // 保存到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    
    // 更新状态
    state = UserState(
      isLoggedIn: true,
      token: token,
      user: user,
    );
  }

  Future<void> logout() async {
    // 清除本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    
    // 重置状态
    state = const UserState();
  }

  Future<void> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');
      
      if (token != null && userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        final user = User.fromJson(userJson);
        
        state = UserState(
          isLoggedIn: true,
          token: token,
          user: user,
        );
      }
    } catch (e) {
      // 如果加载失败，保持默认状态
      print('Failed to load user from storage: $e');
    }
  }

  void updateUser(User user) {
    if (state.isLoggedIn && state.token != null) {
      // 更新本地存储
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('user_data', jsonEncode(user.toJson()));
      });
      
      // 更新状态
      state = state.copyWith(user: user);
    }
  }
}

class UserState {
  final bool isLoggedIn;
  final String? token;
  final User? user;

  const UserState({
    this.isLoggedIn = false,
    this.token,
    this.user,
  });

  UserState copyWith({
    bool? isLoggedIn,
    String? token,
    User? user,
  }) {
    return UserState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/models.dart';
import 'package:frontend/repositories/repositories.dart';

part 'user_pod.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  AsyncValue<UserState> build() {
    // 保持provider活跃，防止状态丢失
    ref.keepAlive();
    return const AsyncValue.data(UserState());
  }

  Future<void> login(String token, User user) async {
    // 保存到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    // 更新状态
    state = AsyncValue.data(UserState(
      isLoggedIn: true,
      token: token,
      user: user,
    ));
  }

  Future<void> logout() async {
    // 清除本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    
    // 重置状态
    state = const AsyncValue.data(UserState());
  }

  Future<void> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');
      
      if (token != null && userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        final user = User.fromJson(userJson);
        
        state = AsyncValue.data(UserState(
          isLoggedIn: true,
          token: token,
          user: user,
        ));
      } else {
        // 没有存储的用户数据，设置默认未登录状态
        state = const AsyncValue.data(UserState());
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 请求api获取用户统计数据
  Future<void> loadUserStats() async {
    final currentState = state.value;
    
    // 检查用户是否已登录，如果没有登录则不加载统计数据
    if (currentState == null || !currentState.isLoggedIn) {
      return;
    }
    
    try {
      final repository = ref.read(userRepositoryProvider);
      final userStats = await repository.getUserStats();

      state = AsyncValue.data(currentState.copyWith(
        userStats: userStats,
      ));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

}

class UserState {
  final bool isLoggedIn;
  final String? token;
  final User? user;
  final UserStats? userStats;

  const UserState({
    this.isLoggedIn = false,
    this.token,
    this.user,
    this.userStats,
  });

  UserState copyWith({
    bool? isLoggedIn,
    String? token,
    User? user,
    UserStats? userStats,
  }) {
    return UserState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
      userStats: userStats ?? this.userStats,
    );
  }
}
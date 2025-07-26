import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../api_service.dart';

part 'user_api.g.dart';

@riverpod
UserApi userApi(Ref ref) {
  return UserApi(ref.read(apiServiceProvider));
}

class UserApi {
  final ApiService _apiService;

  UserApi(this._apiService);

  Future<User> getCurrentUser() async {
    final response = await _apiService.get('/users/profile');
    return User.fromJson(response);
  }

  Future<UserStats> getUserStats() async {
    final response = await _apiService.get('/user-stats');
    return UserStats.fromJson(response);
  }

}



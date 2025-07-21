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

  Future<User> updateProfile(UpdateProfileRequest request) async {
    final response = await _apiService.put('/users/profile', body: request.toJson());
    return User.fromJson(response);
  }

}

// 用户资料更新请求模型
class UpdateProfileRequest {
  final String? username;
  final String? email;

  UpdateProfileRequest({
    this.username,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    return data;
  }
}


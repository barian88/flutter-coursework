import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../apis/apis.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.read(userApiProvider));
}

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<User> updateProfile(UpdateProfileRequest request);
}

class UserRepositoryImpl implements UserRepository {
  final UserApi _userApi;

  UserRepositoryImpl(this._userApi);

  @override
  Future<User> getCurrentUser() async {
    return _userApi.getCurrentUser();
  }

  @override
  Future<User> updateProfile(UpdateProfileRequest request) async {
    return _userApi.updateProfile(request);
  }
}
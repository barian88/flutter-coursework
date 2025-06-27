import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_pod.g.dart';

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  final _registerNotifierModel = RegisterNotifierModel();

  @override
  RegisterNotifierModel build() {
    return _registerNotifierModel;
  }

  void update ({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    state = state.copyWith(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isPasswordVisible: isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible,
    );
  }
}

class RegisterNotifierModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  RegisterNotifierModel({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  RegisterNotifierModel copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return RegisterNotifierModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}
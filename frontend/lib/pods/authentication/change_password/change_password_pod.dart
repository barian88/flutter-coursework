import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_pod.g.dart';

@riverpod
class ChangePasswordNotifier extends _$ChangePasswordNotifier {
  final _changePasswordNotifierModel = ChangePasswordNotifierModel();

  @override
  ChangePasswordNotifierModel build() {
    return _changePasswordNotifierModel;
  }

  void update({
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      isPasswordVisible: isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible,
    );
  }

}

class ChangePasswordNotifierModel {
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  ChangePasswordNotifierModel({
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  ChangePasswordNotifierModel copyWith({
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return ChangePasswordNotifierModel(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}
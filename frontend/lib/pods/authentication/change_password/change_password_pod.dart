import 'package:frontend/apis/apis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/repositories/repositories.dart';
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
    String? temporaryToken,
    bool? isLoading,
    String? errorMessage,
  }) {
    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      isPasswordVisible: isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible,
      temporaryToken: temporaryToken,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
  }

  Future<ResetPasswordResult> resetPassword() async {
    // 检查是否是有效输入
    final validationError = _validateInput();
    if (validationError != null) {
      update(errorMessage: validationError);
      return ResetPasswordResult.error(validationError);
    }
    update(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final resetPasswordRequest = ResetPasswordRequest(
        temporaryToken: state.temporaryToken,
        newPassword: state.password,
      );

      await authRepository.resetPassword(resetPasswordRequest);
      update(isLoading: false);
      return ResetPasswordResult.success();
    } catch (e) {
      String errorMessage;
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      update(isLoading: false, errorMessage: errorMessage);
      return ResetPasswordResult.error(errorMessage);
    }
  }

  String? _validateInput() {
    if (state.password.isEmpty || state.confirmPassword.isEmpty) {
      return "Please fill in all fields";
    }

    if (state.password != state.confirmPassword) {
      return "Passwords do not match";
    }

    if (state.password.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }
}

class ChangePasswordNotifierModel {
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String temporaryToken;
  final bool isLoading;
  final String? errorMessage;

  ChangePasswordNotifierModel({
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.temporaryToken = '',
    this.isLoading = false,
    this.errorMessage,
  });

  ChangePasswordNotifierModel copyWith({
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? temporaryToken,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChangePasswordNotifierModel(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      temporaryToken: temporaryToken ?? this.temporaryToken,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ResetPasswordResult {
  final bool isSuccess;
  final String? errorMessage;

  const ResetPasswordResult._({required this.isSuccess, this.errorMessage});

  factory ResetPasswordResult.success() =>
      const ResetPasswordResult._(isSuccess: true);
  factory ResetPasswordResult.error(String message) =>
      ResetPasswordResult._(isSuccess: false, errorMessage: message);
}

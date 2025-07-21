import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../repositories/repositories.dart';
import '../../../apis/apis.dart';
import '../../../apis/app_exception.dart';
import '../../../utils/utils.dart';
import '../../../models/models.dart';

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
    bool? isLoading,
    String? errorMessage,
  }) {
    state = state.copyWith(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isPasswordVisible: isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
  }

  Future<RegisterResult> sendRegisterRequest() async {
    // 验证输入
    final validationError = _validateInput();
    if (validationError != null) {
      update(errorMessage: validationError);
      return RegisterResult.error(validationError);
    }

    update(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final registerRequest = RegisterRequest(
        email: state.email,
        password: state.password,
        username: state.username,
      );
      
      await authRepository.registerRequest(registerRequest);
      
      update(isLoading: false);
      return RegisterResult.success();
      
    } catch (e) {
      String errorMessage;
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      
      update(isLoading: false, errorMessage: errorMessage);
      return RegisterResult.error(errorMessage);
    }
  }

  String? _validateInput() {
    if (state.username.isEmpty || state.email.isEmpty || 
        state.password.isEmpty || state.confirmPassword.isEmpty) {
      return "Please fill in all fields";
    }

    if (!EmailUtil.isValidEmail(state.email)) {
      return "Please enter a valid email address";
    }

    if (state.password != state.confirmPassword) {
      return "Passwords do not match";
    }

    if (state.password.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  void clearError() {
    update(errorMessage: null);
  }
}

class RegisterNotifierModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  RegisterNotifierModel({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterNotifierModel copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterNotifierModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterResult {
  final bool isSuccess;
  final String? errorMessage;

  const RegisterResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory RegisterResult.success() => const RegisterResult._(isSuccess: true);
  factory RegisterResult.error(String message) => RegisterResult._(
    isSuccess: false,
    errorMessage: message,
  );
}
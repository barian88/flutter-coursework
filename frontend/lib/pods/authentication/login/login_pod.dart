import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../repositories/repositories.dart';
import '../../../apis/apis.dart';
import '../../../apis/app_exception.dart';
import '../../user/user_pod.dart';

part 'login_pod.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {

  final _loginNotifierModel = LoginNotifierModel();

  @override
  LoginNotifierModel build() {
    return _loginNotifierModel;
  }

  void update({
    String? email,
    String? password,
    bool? isLogin,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) {
    state = state.copyWith(
      email: email,
      password: password,
      isLogin: isLogin,
      isPasswordVisible: isPasswordVisible,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
  }

  Future<LoginResult> login() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      final error = "Please fill in all fields";
      update(errorMessage: error);
      return LoginResult.error(error);
    }

    update(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final userNotifier = ref.read(userNotifierProvider.notifier);
      
      final loginRequest = LoginRequest(email: state.email, password: state.password);
      final authResponse = await authRepository.login(loginRequest);
      
      // 保存用户信息和token到UserPod
      await userNotifier.login(authResponse.token, authResponse.user);
      
      update(isLoading: false);
      return LoginResult.success();
      
    } catch (e) {
      // 如果是我们的自定义异常，直接使用其message
      String errorMessage;
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      
      update(isLoading: false, errorMessage: errorMessage);
      return LoginResult.error(errorMessage);
    }
  }


}

class LoginNotifierModel{
  final String email;
  final String password;
  final bool isLogin;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  LoginNotifierModel({
    this.email = '',
    this.password = '',
    this.isLogin = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginNotifierModel copyWith({
    String? email,
    String? password,
    bool? isLogin,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginNotifierModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLogin: isLogin ?? this.isLogin,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginResult {
  final bool isSuccess;
  final String? errorMessage;

  const LoginResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory LoginResult.success() => const LoginResult._(isSuccess: true);
  factory LoginResult.error(String message) => LoginResult._(
    isSuccess: false,
    errorMessage: message,
  );
}
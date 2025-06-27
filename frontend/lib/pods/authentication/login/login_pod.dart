import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  }) {
    state = state.copyWith(
      email: email,
      password: password,
      isLogin: isLogin,
      isPasswordVisible: isPasswordVisible,
    );
  }

}

class LoginNotifierModel{
  final String email;
  final String password;
  final bool isLogin;
  final bool isPasswordVisible;

  LoginNotifierModel({ this.email = '',  this.password = '', this.isLogin = false, this.isPasswordVisible = false});

  LoginNotifierModel copyWith({
    String? email,
    String? password,
    bool? isLogin,
    bool? isPasswordVisible,
  }) {
    return LoginNotifierModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLogin: isLogin ?? this.isLogin,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
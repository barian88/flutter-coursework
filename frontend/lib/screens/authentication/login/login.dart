import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/themes/themes.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/pods/pods.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'input_area.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Logo(), centerTitle: false),
      body: BaseContainer(
        // This widget is scrollable to handle smaller screens， when the keyboard pops up
        isScrollable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(40),
            Text(
              "Hello there 👋",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              "Enter your email and password to sign in ",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const Gap(50),
            InputArea(),
            const Gap(20),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: (){
                    handleForgotPassword(context, loginState);
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(40),
            FilledButton(
              onPressed: () {
                handleLogin(context, loginState);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.medium),
              ),
              child: Text(
                "SIGN IN",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(5),
                InkWell(
                  onTap: () {
                    // Handle navigation to sign up
                    context.push("/register");
                  },
                  child: Text(
                    "Sign Up",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleLogin(BuildContext context, LoginNotifierModel loginState) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // 首先判断输入是否有效
    if (loginState.email.isEmpty || loginState.password.isEmpty) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    // todo 调用API进行验证
    // 如果验证失败， 显示错误信息
    // scaffoldMessenger.clearSnackBars();
    // scaffoldMessenger.showSnackBar(
    //   SnackBar(content: Text("Email or password is incorrect")),
    // );
    // 如果验证成功，跳转到主页
  }


  void handleForgotPassword(BuildContext context, LoginNotifierModel loginState) {

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // 首先必须输入了邮箱地址
    if (loginState.email.isEmpty) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Please enter your email address first")),
      );
      return;
    }
    // 邮箱地址格式必须正确
    if (!EmailUtil.isValidEmail(loginState.email)) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }
    // 跳转到验证码页面后续处理
    context.push('/verification/login/${loginState.email}');
  }
}

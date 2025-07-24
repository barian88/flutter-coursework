import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/themes/themes.dart';
import 'package:frontend/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/pods/pods.dart';
import 'input_area.dart';

class Register extends ConsumerWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Logo()),
      body: BaseContainer(
        // This widget is scrollable to handle smaller screens， when the keyboard pops up
        isScrollable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              "Create an account to continue",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const Gap(35),
            InputArea(),
            const Gap(40),
            FilledButton(
              onPressed: () {
                // Handle register action
                handleRegister(context, ref);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.medium),
              ),
              child: Text(
                "Continue",
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
                  "Already have an account?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(5),
                InkWell(
                  onTap: () {
                    // Handle navigation to sign up
                    context.go("/login");
                  },
                  child: Text(
                    "Sign In",
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

  void handleRegister(BuildContext context, WidgetRef ref) async {
    final registerNotifier = ref.read(registerNotifierProvider.notifier);
    final registerState = ref.read(registerNotifierProvider);
    
    final result = await registerNotifier.sendRegisterRequest();
    
    if (result.isSuccess) {
      // 注册成功，跳转到验证页面
      if (context.mounted) {
        context.push('/verification/register/${registerState.email}');
      }
    } else {
      // 显示错误信息
      await ToastHelper.showError(Theme.of(context), result.errorMessage ?? 'Registration failed');
    }
  }
}

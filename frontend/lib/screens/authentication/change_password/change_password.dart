import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:frontend/pods/pods.dart';
import 'package:go_router/go_router.dart';
import 'input_area.dart';

class ChangePassword extends ConsumerWidget {
  const ChangePassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final changePasswordState = ref.watch(changePasswordNotifierProvider);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
      ),
      body: BaseContainer(child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(30),
            Text(
              "Change Password 🔑",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Gap(40),
            InputArea(),
            const Gap(60),
            FilledButton(
              onPressed: () {
                handleChangePassword(context, changePasswordState);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.medium),
              ),
              child: Text(
                "Confirm",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  void handleChangePassword(BuildContext context, ChangePasswordNotifierModel changePasswordState) {

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    //首先检查两个密码是否为空
    if (changePasswordState.password.isEmpty || changePasswordState.confirmPassword.isEmpty) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Please fill in both password fields')),
      );
      return;
    }
    // 检查两个密码是否匹配
    if (changePasswordState.password != changePasswordState.confirmPassword) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    // 判断密码长度
    if (changePasswordState.password.length < 6 ||
        changePasswordState.password.length > 20) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Password must be between 6 and 20 characters')),
      );
      return;
    }
    // 如果所有检查都通过，执行密码更改逻辑
    // todo 调用API进行密码更改
    // 成功后提示用户密码更改成功
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Password changed successfully, please sign in again')),
    );
    context.go('/login');
  }
}

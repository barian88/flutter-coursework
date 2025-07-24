import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/themes/themes.dart';
import 'package:frontend/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:frontend/pods/pods.dart';
import 'package:go_router/go_router.dart';
import 'input_area.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key, required this.temporaryToken});

  final String temporaryToken;

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  @override
  void initState() {
    super.initState();
    // 推迟到build完成后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(changePasswordNotifierProvider.notifier).update(
        temporaryToken: widget.temporaryToken,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _handleChangePassword(context);
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

  void _handleChangePassword(BuildContext context) async {
    final changePasswordNotifier = ref.read(changePasswordNotifierProvider.notifier);

    final result = await changePasswordNotifier.resetPassword();
    // 成功后提示用户密码更改成功
    if(result.isSuccess){
      await ToastHelper.showSuccess(Theme.of(context), 'Password changed successfully, please sign in again');
      context.go('/login');
    }else {
      // 显示错误信息
      await ToastHelper.showError(Theme.of(context), result.errorMessage ?? 'Reset password failed');
    }
  }
}

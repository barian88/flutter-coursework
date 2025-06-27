import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/themes/themes.dart';
import 'package:frontend/pods/pods.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'otp_input_area.dart';

class Verification extends ConsumerStatefulWidget {
  const Verification({super.key, required this.email, required this.parentPage});

  final String email;
  final String parentPage;

  @override
  ConsumerState<Verification> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<Verification> {
  int remainingTime = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountDown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(verificationNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Logo()),
      body: BaseContainer(
        isScrollable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(40),
            Text(
              "You’ve got mail 📧",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              "We have sent the OTP verification code to your email address. Check your email and enter the code below.",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const Gap(50),
            OtpInputArea(),
            const Gap(40),
            Center(
              child: Text(
                "Didn’t receive the code?",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 24,
              child:
                  remainingTime == 0
                      ? Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            // 去掉内边距
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'resend',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You can resend code in',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            '$remainingTime',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            's',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
            ),
            const Gap(40),
            FilledButton(
              onPressed: () {
                handleVerification(context, verificationState);
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
        ),
      ),
    );
  }

  void handleVerification(
    BuildContext context,
    VerificationNotifierModel verificationState,
  ) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // 首先判断输入是否有效
    if (verificationState.verificationCode.isEmpty) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Please enter the OTP code.")),
      );
      return;
    }
    // todo 判断验证码是否正确
    // 失败提示错误信息
    // 成功后请求api，将信息存入数据库

    // 如果是注册页面，跳转到登录页面
    if (widget.parentPage == 'register') {
      context.go('/login');
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Registration successful! Please log in.")),
      );
      return;
    }
    // 如果是忘记密码 / 登陆页面，跳转到重置密码页面
    else if (widget.parentPage == 'login') {
      context.push('/change-password/${widget.email}');
      return;
    }
    // 如果是修改密码 / 用户页面，跳转到重置密码页面
    else if (widget.parentPage == 'user') {
      context.push('/change-password/${widget.email}');
      return;
    }
  }
}

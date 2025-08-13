import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';
import 'package:frontend/pods/pods.dart';

class User extends ConsumerStatefulWidget {
  const User({super.key});

  @override
  ConsumerState<User> createState() => _UserState();
}

class _UserState extends ConsumerState<User> {
@override
void initState() {
    super.initState();
    // 刷新用户数据
    Future.microtask(() {
      final userNotifier = ref.read(userNotifierProvider.notifier);
      userNotifier.loadUserStats();
    });
  }

@override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);

    return BaseContainer(
      child: userState.when(
        data: (userState) => Column(
          children: [
            Gap(25),
            UserInfoCard(),
            Gap(28),
            Performance(),
            Gap(28),
            ErrorDistribution(),
            Gap(28),
            AccuracyRate(),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

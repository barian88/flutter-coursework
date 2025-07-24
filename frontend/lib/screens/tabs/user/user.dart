import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';
import 'package:frontend/pods/pods.dart';

class User extends ConsumerWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userState = ref.watch(userNotifierProvider);

    return BaseContainer(child: Column(
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
    ));
  }
}

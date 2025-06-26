import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(child: Column(
      children: [
        Gap(30),
        UserInfoCard(),
        Gap(28),
        Performance(),
        Gap(28),
        AccuracyRate(),
        Gap(28),
        ErrorDistribution(),
      ],
    ));
  }
}

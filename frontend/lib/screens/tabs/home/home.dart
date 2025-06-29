import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      child: Column(
        children: [
          WelcomeCard(),
          Gap(26),
          QuizButtons(),
          Gap(26),
          Performance(),
        ],
      ),
    );
  }
}





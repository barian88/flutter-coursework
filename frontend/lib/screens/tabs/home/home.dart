import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BaseContainer(
          child: Column(
            children: [
              WelcomeCard(),
              Gap(30),
              QuizButtons(),
              Gap(30),   //因为QuizButtons有10的垂直Padding
              Performance(),
            ],
          ),
        );
      },
    );
  }
}





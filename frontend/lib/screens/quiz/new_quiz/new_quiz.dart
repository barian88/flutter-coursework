import 'package:flutter/material.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:gap/gap.dart';
import 'widgets/widgets.dart';

class NewQuiz extends StatelessWidget {
  const NewQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: QuizTimer(),
        centerTitle: true,
        actions: [ThemeModeSwitch(), const Gap(16)],
      ),
      body: BaseContainer(
        isScrollable: false,
        child: Column(
          children: [
            QuizProgress(),
            const Gap(30),
            Expanded(flex: 4, child: QuestionArea()),
            Divider(height: 50),
            Expanded(
              flex: 5,
              child: Column(
                children: [OptionArea(), Spacer(), OperationArea(), Gap(35)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

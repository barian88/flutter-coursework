import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:frontend/pods/pods.dart';


class QuestionArea extends ConsumerWidget {
  const QuestionArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final quizState = ref.watch(quizNotifierProvider);
    final currentQuestion = quizState.quiz.questions[quizState.currentQuestionIndex];

    final theme = Theme.of(context);


    // This should be replaced with the actual options data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Chip(
              label: Text(currentQuestion.type.name, style: theme.textTheme.bodySmall),
              padding: EdgeInsets.all(0),
            ),
            Gap(8),
            Chip(
              label: Text(currentQuestion.category.name, style: theme.textTheme.bodySmall),
              padding: EdgeInsets.all(0),
            ),
            Gap(8),
            Chip(
              label: Text(currentQuestion.difficulty.name, style: theme.textTheme.bodySmall),
              padding: EdgeInsets.all(0),
            ),
          ],
        ),
        Gap(8),
        Text(
          currentQuestion.questionText,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(16),
        ...getOptionWidgets(currentQuestion.options, theme),
      ],
    );
  }
}

List<Widget> getOptionWidgets(List<String> options, ThemeData theme) {
  final tags = ['A', 'B', 'C', 'D'];
  final optionWidgets = <Widget>[];
  for (int i = 0; i < options.length; i++) {
    final option = options[i];
    optionWidgets.add(
      Row(
        children: [
          Text(
            '${tags[i]}. ',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            option,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    if (i != options.length - 1) {
      optionWidgets.add(Gap(8)); // Add space between options
    }
  }
  return optionWidgets;
}

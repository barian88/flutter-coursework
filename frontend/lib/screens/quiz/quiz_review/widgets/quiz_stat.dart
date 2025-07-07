import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/pods/pods.dart';
import 'package:frontend/utils/utils.dart';
import 'package:gap/gap.dart';

class QuizStat extends ConsumerWidget {
  const QuizStat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);
    final String completionTime = TimeFormatterUtil.getFormattedTime(
      quizState.quiz.completionTime,
    );
    final int correctQuestionsNum = quizState.quiz.correctQuestionsNum;

    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$correctQuestionsNum/10 Correct', style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant
        ),),
        Text(completionTime, style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant
        ),),
      ],
    );
  }
}

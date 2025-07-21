import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuizProgress extends ConsumerWidget {
  const QuizProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);
    final theme = Theme.of(context);

    return quizState.when(
      data: (state) {
        final currentQuestionIndex = state.currentQuestionIndex;
        
        return LayoutBuilder(
          builder: (context, constraint) {
            final width = constraint.maxWidth;
            return LinearPercentIndicator(
              width: width,
              lineHeight: 20.0,
              percent: currentQuestionIndex / 10,
              barRadius: Radius.circular(12),
              center: Center(
                child: Text(
                  '$currentQuestionIndex/10',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        (currentQuestionIndex / 10 < 0.5 &&
                                theme.brightness == Brightness.light)
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
              animation: true,
              animateFromLastPercent: true,
              backgroundColor: Colors.grey.withAlpha(50),
              progressColor: theme.colorScheme.primary,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';
import 'package:frontend/themes/light_dark_theme.dart';
import 'package:gap/gap.dart';

class OperationArea extends ConsumerWidget {
  const OperationArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);
    final quizNotifier = ref.read(quizNotifierProvider.notifier);

    final theme = Theme.of(context);

    return quizState.when(
      data: (state) {
        final isFirst = state.currentQuestionIndex == 0;
        final isLast =
            state.currentQuestionIndex == state.quiz.questions.length - 1;
        final backStatus = isFirst ? null : quizNotifier.previousQuestion;
        final nextStatus =
            isLast
                ? null //todo 这里要改为submit
                : quizNotifier.nextQuestion;

        return _buildOperationArea(theme, isFirst, isLast, backStatus, nextStatus);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildOperationArea(
    ThemeData theme,
    bool isFirst,
    bool isLast,
    VoidCallback? backStatus,
    VoidCallback? nextStatus,
  ) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: backStatus,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.green, // Change the color to red
            minimumSize: Size(10, 50),
          ),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        Gap(30),
        Expanded(
          child: ElevatedButton(
            onPressed: nextStatus,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              // Change the color to red
              minimumSize: Size(10, 50),
            ),
            child: Text(
              isLast ? 'Submit' : 'Next',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white, // Ensure text is readable
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

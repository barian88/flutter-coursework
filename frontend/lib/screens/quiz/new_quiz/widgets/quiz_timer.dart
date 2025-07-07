import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';
import 'package:frontend/utils/utils.dart';


class QuizTimer extends ConsumerStatefulWidget {
  const QuizTimer ({super.key});
  @override
  ConsumerState<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends ConsumerState<QuizTimer> {

  late final QuizNotifier quizNotifier;

 @override
 void initState(){
   super.initState();

   Future.microtask(() {
     quizNotifier = ref.read(quizNotifierProvider.notifier);
     quizNotifier.startTimer();
   });
 }

@override
  Widget build(BuildContext context) {

    final quizState = ref.watch(quizNotifierProvider);

    final time = quizState.quiz.completionTime;

    final theme = Theme.of(context);

    return Text(TimeFormatterUtil.getFormattedTime(time), style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold
    ));
  }
}


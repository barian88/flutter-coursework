import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';

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

    return Text(getFormattedTime(time), style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold
    ));
  }
}

String getFormattedTime(int time) {
  if (time == 0) {
    return '00:00:00';
  }

  final hours = time ~/ 3600;
  final minutes = (time % 3600) ~/ 60;
  final seconds = time % 60;

  final hoursStr = hours.toString().padLeft(2, '0');
  final minutesStr = minutes.toString().padLeft(2, '0');
  final secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}


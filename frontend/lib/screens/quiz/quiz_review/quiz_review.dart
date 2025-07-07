import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/pods/pods.dart';
import 'package:gap/gap.dart';
import 'widgets/widgets.dart';

class QuizReview extends ConsumerStatefulWidget {
  const QuizReview({super.key});

  @override
  ConsumerState<QuizReview> createState() => _QuizReviewState();
}

class _QuizReviewState extends ConsumerState<QuizReview> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final quizNotifier = ref.read(quizNotifierProvider.notifier);
      quizNotifier.getReviewQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {

    final quizState = ref.watch(quizNotifierProvider);
    final currentQuestion = quizState.quiz.questions[quizState.currentQuestionIndex];
    final questionType = currentQuestion.type;
    final userAnswerIndex = currentQuestion.userAnswerIndex;
    final correctAnswerIndex = currentQuestion.correctAnswerIndex;

    return Scaffold(
      appBar: AppBar(
        title: Logo(),
        centerTitle: true,
        actions: [ThemeModeSwitch(), const Gap(16)],
      ),
      body: BaseContainer(
        isScrollable: false,
        child: Column(
          children: [
            QuizStat(),
            const Gap(12),
            QuizProgress(),
            const Gap(30),
            Expanded(flex: 4, child: QuestionArea()),
            Divider(height: 0),
            const Gap(10),
            AnswerReview(correctAnswerIndex: correctAnswerIndex, userAnswerIndex: userAnswerIndex, questionType: questionType),
            const Gap(10),
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

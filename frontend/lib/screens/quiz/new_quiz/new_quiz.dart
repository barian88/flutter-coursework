import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/pods/pods.dart';
import 'package:gap/gap.dart';
import 'widgets/widgets.dart';

class NewQuiz extends ConsumerStatefulWidget {
  const NewQuiz({super.key});

  @override
  ConsumerState<NewQuiz> createState() => _NewQuizState();
}

class _NewQuizState extends ConsumerState<NewQuiz> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final quizNotifier = ref.read(quizNotifierProvider.notifier);
      quizNotifier.loadNewQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizNotifierProvider);

    return quizState.when(
      data: (state) {
        if (state.quiz.questions.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No quiz data available'),
            ),
          );
        }
        
        return _buildQuizScreen(context);
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildQuizScreen(BuildContext context) {
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

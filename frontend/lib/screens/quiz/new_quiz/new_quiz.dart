import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/pods/pods.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'widgets/widgets.dart';
import 'package:frontend/models/models.dart';

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
      final (type, category, difficulty) = _parseQueryParameters();
      final quizNotifier = ref.read(quizNotifierProvider.notifier);
      quizNotifier.loadNewQuiz(
        type: type,
        category: category,
        difficulty: difficulty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizNotifierProvider);

    return quizState.when(
      data: (state) {
        if (state.quiz.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No quiz data available')),
          );
        }

        return _buildQuizScreen(context);
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stackTrace) =>
              Scaffold(body: Center(child: Text('Error: $error'))),
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

  (String, String?, String?) _parseQueryParameters() {
    // 获取查询参数
    final state = GoRouterState.of(context);
    // 传入的typeParam是name
    final typeParam = state.uri.queryParameters['type'];
    // 传入的categoryParam和difficultyParam是displayName
    final categoryParam = state.uri.queryParameters['category'];
    final difficultyParam = state.uri.queryParameters['difficulty'];

    // 得到对应的enum.name
    final String type = typeParam ?? QuizType.randomTasks.name;
    final String? category;
    final String? difficulty;

    category =
        (categoryParam != null)
            ? QuestionCategoryExtension.getNameFromDisplayName(categoryParam)
            : null;
    difficulty =
        (difficultyParam != null)
            ? QuestionDifficultyExtension.getNameFromDisplayName(
              difficultyParam,
            )
            : null;

    return (type, category, difficulty);
  }
}

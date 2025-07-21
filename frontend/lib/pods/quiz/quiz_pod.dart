import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/repositories/repositories.dart';
import 'package:frontend/apis/apis.dart';
import 'dart:async';

part 'quiz_pod.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  Timer? _timer;

  @override
  AsyncValue<QuizState> build() {
    // 在build方法中注册dispose回调
    ref.onDispose(() {
      _timer?.cancel();
    });
    
    return const AsyncValue.data(QuizState.initial());
  }

  // 获取新的测验
  Future<void> loadNewQuiz({
    String? category,
    String? difficulty,
    int? questionCount,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(quizRepositoryProvider);
      
      // 首先尝试从API获取
      try {
        final quiz = await repository.createNewQuiz(
          category: category,
          difficulty: difficulty,
          questionCount: questionCount ?? 10,
        );
        
        state = AsyncValue.data(QuizState.loaded(quiz));
      } catch (e) {
        // 如果API失败，使用本地模拟数据
        final quiz = repository.getMockQuiz();
        state = AsyncValue.data(QuizState.loaded(quiz));
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 获取测验回顾
  Future<void> loadQuizReview(String quizId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(quizRepositoryProvider);
      
      try {
        final quiz = await repository.getQuiz(quizId);
        state = AsyncValue.data(QuizState.review(quiz));
      } catch (e) {
        // 如果API失败，使用本地模拟数据
        final quiz = repository.getMockReviewQuiz();
        state = AsyncValue.data(QuizState.review(quiz));
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 下一题
  void nextQuestion() {
    state.whenData((quizState) {
      if (quizState.currentQuestionIndex < quizState.quiz.questions.length - 1) {
        state = AsyncValue.data(
          quizState.copyWith(
            currentQuestionIndex: quizState.currentQuestionIndex + 1,
          ),
        );
      }
    });
  }

  // 上一题
  void previousQuestion() {
    state.whenData((quizState) {
      if (quizState.currentQuestionIndex > 0) {
        state = AsyncValue.data(
          quizState.copyWith(
            currentQuestionIndex: quizState.currentQuestionIndex - 1,
          ),
        );
      }
    });
  }

  // 设置用户答案
  void setUserAnswerIndex(int optionIndex) {
    state.whenData((quizState) {
      final currentQuestion = quizState.quiz.questions[quizState.currentQuestionIndex];
      List<int> userAnswerIndex = List.from(currentQuestion.userAnswerIndex);
      
      if (currentQuestion.type == QuestionType.singleChoice ||
          currentQuestion.type == QuestionType.trueFalse) {
        userAnswerIndex = [optionIndex];
      } else if (currentQuestion.type == QuestionType.multipleChoice) {
        if (currentQuestion.userAnswerIndex.contains(optionIndex)) {
          userAnswerIndex.remove(optionIndex);
        } else {
          userAnswerIndex.add(optionIndex);
        }
      }

      final updatedQuestion = currentQuestion.copyWith(
        userAnswerIndex: userAnswerIndex,
      );

      final updatedQuestions = [...quizState.quiz.questions];
      updatedQuestions[quizState.currentQuestionIndex] = updatedQuestion;

      final updatedQuiz = quizState.quiz.copyWith(questions: updatedQuestions);
      
      state = AsyncValue.data(
        quizState.copyWith(quiz: updatedQuiz),
      );
    });
  }

  // 开始计时器
  void startTimer() {
    _timer?.cancel();
    
    state.whenData((quizState) {
      final updatedQuiz = quizState.quiz.copyWith(completionTime: 0);
      state = AsyncValue.data(quizState.copyWith(quiz: updatedQuiz));
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state.whenData((currentState) {
          final updatedQuiz = currentState.quiz.copyWith(
            completionTime: currentState.quiz.completionTime + 1,
          );
          state = AsyncValue.data(
            currentState.copyWith(quiz: updatedQuiz),
          );
        });
      });
    });
  }

  // 停止计时器
  void stopTimer() {
    _timer?.cancel();
  }

  // 提交测验
  Future<void> submitQuiz() async {
    await state.when(
      data: (quizState) async {
        try {
          stopTimer();
          
          final repository = ref.read(quizRepositoryProvider);
          final answers = quizState.quiz.questions.map((question) => 
            QuestionAnswer(
              questionId: question.id,
              selectedAnswers: question.userAnswerIndex,
            )
          ).toList();

          final request = SubmitQuizRequest(
            answers: answers,
            completionTime: quizState.quiz.completionTime,
          );

          try {
            await repository.submitQuiz(quizState.quiz.id, request);
            // 可以在这里处理提交结果
            // TODO: 添加成功提示或导航到结果页面
          } catch (e) {
            // 如果提交失败，至少保存本地状态
            // TODO: 添加错误处理或离线存储
          }
        } catch (error, stackTrace) {
          state = AsyncValue.error(error, stackTrace);
        }
      },
      loading: () async {},
      error: (error, stackTrace) async {},
    );
  }

  // 重置测验
  void resetQuiz() {
    _timer?.cancel();
    state = const AsyncValue.data(QuizState.initial());
  }
}

// 测验状态类
class QuizState {
  final Quiz quiz;
  final int currentQuestionIndex;
  final QuizStatus status;

  const QuizState({
    required this.quiz,
    this.currentQuestionIndex = 0,
    this.status = QuizStatus.initial,
  });

  const QuizState.initial() : this(
    quiz: const Quiz(
      id: '',
      type: QuizType.randomTasks,
      questions: [],
    ),
    status: QuizStatus.initial,
  );

  const QuizState.loaded(Quiz quiz) : this(
    quiz: quiz,
    status: QuizStatus.active,
  );

  const QuizState.review(Quiz quiz) : this(
    quiz: quiz,
    status: QuizStatus.review,
  );

  QuizState copyWith({
    Quiz? quiz,
    int? currentQuestionIndex,
    QuizStatus? status,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      status: status ?? this.status,
    );
  }
}

enum QuizStatus {
  initial,
  active,
  review,
  completed,
}

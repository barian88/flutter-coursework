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
  Future<void> loadNewQuiz({required String type, String? category, String? difficulty}) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(quizRepositoryProvider);
      final quiz = await repository.createNewQuiz(
        type: type,
        category: category,
        difficulty: difficulty,
      );
      state = AsyncValue.data(QuizState.loaded(quiz));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 获取测验回顾
  Future<void> loadQuizReview(String quizId) async {
    state = const AsyncValue.loading();

    try {

      final repository = ref.read(quizRepositoryProvider);
      final quiz = await repository.getQuiz(quizId);
      state = AsyncValue.data(QuizState.review(quiz));

    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 确认提交测验
  Future<SubmitQuizResult> submitQuiz() async {
    stopTimer();
    final quiz = state.value?.quiz;
    // 构建quizRequest
    final quizRequest;
    if (quiz == null) {
      return SubmitQuizResult.error('Quiz data is not available');
    } else {
      quizRequest = SubmitQuizRequest(type: quiz.type.name, questions: quiz.questions, completionTime: quiz.completionTime);
    }
    try{
      final quizRepository = ref.read(quizRepositoryProvider);
      final quiz = await quizRepository.submitQuiz(quizRequest);

      return SubmitQuizResult.success(quiz.id);
    }catch(e){
      return SubmitQuizResult.error('Failed to submit quiz: ${e.toString()}');
    }
  }

  // 下一题
  void nextQuestion() {
    state.whenData((quizState) {
      if (quizState.currentQuestionIndex <
          quizState.quiz.questions.length - 1) {
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
      final currentQuizQuestion =
          quizState.quiz.questions[quizState.currentQuestionIndex];
      List<int> userAnswerIndex = List.from(
        currentQuizQuestion.userAnswerIndex,
      );

      if (currentQuizQuestion.question.type == QuestionType.singleChoice ||
          currentQuizQuestion.question.type == QuestionType.trueFalse) {
        userAnswerIndex = [optionIndex];
      } else if (currentQuizQuestion.question.type ==
          QuestionType.multipleChoice) {
        if (currentQuizQuestion.userAnswerIndex.contains(optionIndex)) {
          userAnswerIndex.remove(optionIndex);
        } else {
          userAnswerIndex.add(optionIndex);
        }
      }

      final updatedQuizQuestion = currentQuizQuestion.copyWith(
        userAnswerIndex: userAnswerIndex,
      );

      final updatedQuestions = [...quizState.quiz.questions];
      updatedQuestions[quizState.currentQuestionIndex] = updatedQuizQuestion;

      final updatedQuiz = quizState.quiz.copyWith(questions: updatedQuestions);

      state = AsyncValue.data(quizState.copyWith(quiz: updatedQuiz));
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
          state = AsyncValue.data(currentState.copyWith(quiz: updatedQuiz));
        });
      });
    });
  }

  // 停止计时器
  void stopTimer() {
    _timer?.cancel();
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

  const QuizState.initial()
    : this(
        quiz: const Quiz(id: '', type: QuizType.randomTasks, questions: []),
        status: QuizStatus.initial,
      );

  const QuizState.loaded(Quiz quiz)
    : this(quiz: quiz, status: QuizStatus.active);

  const QuizState.review(Quiz quiz)
    : this(quiz: quiz, status: QuizStatus.review);

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

enum QuizStatus { initial, active, review }

// submit结果类
class SubmitQuizResult {
  final bool isSuccess;
  final String? quizId;
  final String? errorMessage;

  const SubmitQuizResult({required this.isSuccess, this.quizId, this.errorMessage});

  factory SubmitQuizResult.success(String quizId) {
    return SubmitQuizResult(isSuccess: true, quizId: quizId);
  }

  factory SubmitQuizResult.error(String message) {
    return SubmitQuizResult(isSuccess: false, errorMessage: message);
  }
}
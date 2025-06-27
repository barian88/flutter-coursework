import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/models.dart';
import 'dart:async';


part 'quiz_pod.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  final Quiz quiz = Quiz(
    type: QuizType.randomTasks,
    questions: [
      Question(
        questionText:
        "Which of the following formulas is logically equivalent to ¬(p ∨ q)?",
        options: ["¬p ∧ ¬q", "¬p ∨ ¬q", "p ∧ q", "p ∨ q"],
        correctAnswerIndex: [0],
        type: QuestionType.singleChoice,
        category: QuestionCategory.equivalence,
        difficulty: QuestionDifficulty.easy,
      ),
      Question(
        questionText: "What is the contrapositive of the implication p → q?",
        options: ["¬q → ¬p", "¬p → ¬q", "p ∨ q", "¬p ∨ q"],
        correctAnswerIndex: [0, 1],
        type: QuestionType.multipleChoice,
        category: QuestionCategory.equivalence,
        difficulty: QuestionDifficulty.medium,
      ),
      Question(
        questionText: "What is the contrapositive of the implication p → q?",
        options: ["True", "False"],
        correctAnswerIndex: [0],
        type: QuestionType.trueFalse,
        category: QuestionCategory.equivalence,
        difficulty: QuestionDifficulty.medium,
      ),
    ],
  );

  Timer? _timer;

  @override
  QuizNotifierModel build() {
    return QuizNotifierModel(quiz: quiz);
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.quiz.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  void setUserAnswerIndex(int i) {
    final currentQuestion = state.quiz.questions[state.currentQuestionIndex];
    List<int> userAnswerIndex = List.from(currentQuestion.userAnswerIndex);
    if (currentQuestion.type == QuestionType.singleChoice ||
        currentQuestion.type == QuestionType.trueFalse) {
      userAnswerIndex = [i];
    } else if (currentQuestion.type == QuestionType.multipleChoice) {
      if (currentQuestion.userAnswerIndex.contains(i)) {
        userAnswerIndex.remove(i);
      } else {
        userAnswerIndex.add(i);
      }
    }
    // 创建更新后的 Question 对象（确保有 copyWith 方法）
    final updatedQuestion = currentQuestion.copyWith(
        userAnswerIndex: userAnswerIndex);

    // 替换掉当前 question
    final updatedQuestions = [...state.quiz.questions];
    updatedQuestions[state.currentQuestionIndex] = updatedQuestion;

    // 更新整个 quiz 状态
    state =
        state.copyWith(quiz: state.quiz.copyWith(questions: updatedQuestions));
  }

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(
      quiz: state.quiz.copyWith(
        completionTime: 0,
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        quiz: state.quiz.copyWith(
          completionTime: state.quiz.completionTime + 1,
        ),
      );
    });
  }

  void resetQuiz() {
    _timer?.cancel();
    state = QuizNotifierModel(quiz: quiz);
  }
}

class QuizNotifierModel {
  final Quiz quiz;
  final int currentQuestionIndex;

  QuizNotifierModel({required this.quiz, this.currentQuestionIndex = 0});

  QuizNotifierModel copyWith({
    Quiz? quiz,
    int? currentQuestionIndex,
  }) {
    return QuizNotifierModel(
      quiz: quiz ?? this.quiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }
}

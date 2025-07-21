import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../apis/apis.dart';

part 'quiz_repository.g.dart';

@riverpod
QuizRepository quizRepository(Ref ref) {
  return QuizRepositoryImpl(ref.read(quizApiProvider));
}

abstract class QuizRepository {
  // 获取单个测验（用于回顾）
  Future<Quiz> getQuiz(String id);
  
  // 创建新的测验（用于开始新测验）
  Future<Quiz> createNewQuiz({
    String? category,
    String? difficulty,
    int? questionCount,
  });
  
  // 获取所有测验历史记录（用于history页面）
  Future<List<Quiz>> getAllQuizHistory();
  
  // 提交测验
  Future<QuizResult> submitQuiz(String quizId, SubmitQuizRequest request);
  
  // 本地数据方法（用于开发和测试）
  Quiz getMockQuiz();
  Quiz getMockReviewQuiz();
}

class QuizRepositoryImpl implements QuizRepository {
  final QuizApi _quizApi;

  QuizRepositoryImpl(this._quizApi);

  @override
  Future<Quiz> getQuiz(String id) async {
    return _quizApi.getQuiz(id);
  }
  
  @override
  Future<Quiz> createNewQuiz({
    String? category,
    String? difficulty,
    int? questionCount,
  }) async {
    return _quizApi.createNewQuiz(
      category: category,
      difficulty: difficulty,
      questionCount: questionCount,
    );
  }
  
  @override
  Future<List<Quiz>> getAllQuizHistory() async {
    return _quizApi.getAllQuizHistory();
  }

  @override
  Future<QuizResult> submitQuiz(String quizId, SubmitQuizRequest request) async {
    return _quizApi.submitQuiz(quizId, request);
  }

  // 本地模拟数据方法
  @override
  Quiz getMockQuiz() {
    return Quiz(
      id: 'mock_quiz_1',
      type: QuizType.randomTasks,
      questions: [
        Question(
          id: 'q1',
          questionText: "Which of the following formulas is logically equivalent to ¬(p ∨ q)?",
          options: ["¬p ∧ ¬q", "¬p ∨ ¬q", "p ∧ q", "p ∨ q"],
          correctAnswerIndex: [0],
          type: QuestionType.singleChoice,
          category: QuestionCategory.equivalence,
          difficulty: QuestionDifficulty.easy,
        ),
        Question(
          id: 'q2',
          questionText: "What is the contrapositive of the implication p → q?",
          options: ["¬q → ¬p", "¬p → ¬q", "p ∨ q", "¬p ∨ q"],
          correctAnswerIndex: [0],
          type: QuestionType.multipleChoice,
          category: QuestionCategory.equivalence,
          difficulty: QuestionDifficulty.medium,
        ),
        Question(
          id: 'q3',
          questionText: "Is the statement 'p → q' equivalent to '¬p ∨ q'?",
          options: ["True", "False"],
          correctAnswerIndex: [0],
          type: QuestionType.trueFalse,
          category: QuestionCategory.equivalence,
          difficulty: QuestionDifficulty.medium,
        ),
      ],
    );
  }

  @override
  Quiz getMockReviewQuiz() {
    return Quiz(
      id: 'mock_review_quiz_1',
      type: QuizType.randomTasks,
      correctQuestionsNum: 2,
      completionTime: 1200,
      questions: [
        Question(
          id: 'q1',
          questionText: "Which of the following formulas is logically equivalent to ¬(p ∨ q)?",
          options: ["¬p ∧ ¬q", "¬p ∨ ¬q", "p ∧ q", "p ∨ q"],
          correctAnswerIndex: [0],
          userAnswerIndex: [0],
          type: QuestionType.singleChoice,
          category: QuestionCategory.equivalence,
          difficulty: QuestionDifficulty.easy,
        ),
        Question(
          id: 'q2',
          questionText: "What is the contrapositive of the implication p → q?",
          options: ["¬q → ¬p", "¬p → ¬q", "p ∨ q", "¬p ∨ q"],
          correctAnswerIndex: [0],
          userAnswerIndex: [0, 1, 2],
          type: QuestionType.multipleChoice,
          category: QuestionCategory.equivalence,
          difficulty: QuestionDifficulty.medium,
        ),
        Question(
          id: 'q3',
          questionText: "Is the statement 'p → q' equivalent to '¬p ∨ q'?",
          options: ["True", "False"],
          correctAnswerIndex: [0],
          userAnswerIndex: [1],
          type: QuestionType.trueFalse,
          category: QuestionCategory.equivalence,
          difficulty: QuestionDifficulty.medium,
        ),
      ],
    );
  }
}
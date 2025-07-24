import 'question.dart';

class QuizQuestion {
  final Question question;
  final List<int> userAnswerIndex;

  const QuizQuestion({
    required this.question,
    this.userAnswerIndex = const [],
  });

  QuizQuestion copyWith({
    Question? question,
    List<int>? userAnswerIndex,
  }) {
    return QuizQuestion(
      question: question ?? this.question,
      userAnswerIndex: userAnswerIndex ?? this.userAnswerIndex,
    );
  }

  // JSON 序列化支持
  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    question: Question.fromJson(json['question'] ?? {}),
    userAnswerIndex: List<int>.from(json['user_answer_index'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'question': question.toJson(),
    'user_answer_index': userAnswerIndex,
  };

  // 便利方法
  bool get isAnswered => userAnswerIndex.isNotEmpty;
  
  bool get isCorrect {
    if (!isAnswered) return false;
    
    // 检查用户答案是否与正确答案完全匹配
    final userSet = Set<int>.from(userAnswerIndex);
    final correctSet = Set<int>.from(question.correctAnswerIndex);
    return userSet.length == correctSet.length && userSet.containsAll(correctSet);
  }

  // 获取问题ID的便利方法
  String get questionId => question.id;
  
  // 获取问题文本的便利方法
  String get questionText => question.questionText;
  
  // 获取选项的便利方法
  List<String> get options => question.options;
  
  // 获取正确答案的便利方法
  List<int> get correctAnswerIndex => question.correctAnswerIndex;
}
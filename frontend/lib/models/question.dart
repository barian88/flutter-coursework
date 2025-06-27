enum QuestionType {
  singleChoice,
  multipleChoice,
  trueFalse,
}
enum QuestionCategory {
  truthTable,
  equivalence,
  inference,
}
enum QuestionDifficulty {
  easy,
  medium,
  hard,
}

class Question {

  String questionText;
  List<String> options;
  List<int> correctAnswerIndex;
  List<int> userAnswerIndex;

  QuestionType type;
  QuestionCategory category;
  QuestionDifficulty difficulty;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.userAnswerIndex = const [],
    required this.type,
    required this.category,
    required this.difficulty,
  });

  Question copyWith({
    String? questionText,
    List<String>? options,
    List<int>? correctAnswerIndex,
    List<int>? userAnswerIndex,
    QuestionType? type,
    QuestionCategory? category,
    QuestionDifficulty? difficulty,
  }) {
    return Question(
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      userAnswerIndex: userAnswerIndex ?? this.userAnswerIndex,
      type: type ?? this.type,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
    );
  }

}
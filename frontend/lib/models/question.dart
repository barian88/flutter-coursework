
class Question {

  final String id;
  final String questionText;
  final List<String> options;
  final List<int> correctAnswerIndex;
  final List<int> userAnswerIndex;

  final QuestionType type;
  final QuestionCategory category;
  final QuestionDifficulty difficulty;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.userAnswerIndex = const [],
    required this.type,
    required this.category,
    required this.difficulty,
  });

  Question copyWith({
    String? id,
    String? questionText,
    List<String>? options,
    List<int>? correctAnswerIndex,
    List<int>? userAnswerIndex,
    QuestionType? type,
    QuestionCategory? category,
    QuestionDifficulty? difficulty,
  }) {
    return Question(
      id: id ?? this.id,
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

enum QuestionType {
  singleChoice,
  multipleChoice,
  trueFalse,
}

extension QuestionTypeExtension on QuestionType {
  String get displayName {
    switch (this) {
      case QuestionType.singleChoice:
        return 'Single Choice';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True / False';
    }
  }
}

enum QuestionCategory {
  truthTable,
  equivalence,
  inference,
}

extension QuestionCategoryExtension on QuestionCategory {
  String get displayName {
    switch (this) {
      case QuestionCategory.truthTable:
        return 'Truth Table';
      case QuestionCategory.equivalence:
        return 'Equivalence';
      case QuestionCategory.inference:
        return 'Inference';
    }
  }
}

enum QuestionDifficulty {
  easy,
  medium,
  hard,
}

extension QuestionDifficultyExtension on QuestionDifficulty {
  String get displayName {
    switch (this) {
      case QuestionDifficulty.easy:
        return 'Easy';
      case QuestionDifficulty.medium:
        return 'Medium';
      case QuestionDifficulty.hard:
        return 'Hard';
    }
  }
}

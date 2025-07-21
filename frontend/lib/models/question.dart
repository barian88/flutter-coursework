
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

  // JSON 序列化支持
  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] ?? '',
    questionText: json['questionText'] ?? '',
    options: List<String>.from(json['options'] ?? []),
    correctAnswerIndex: List<int>.from(json['correctAnswerIndex'] ?? []),
    userAnswerIndex: List<int>.from(json['userAnswerIndex'] ?? []),
    type: QuestionType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => QuestionType.singleChoice,
    ),
    category: QuestionCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => QuestionCategory.truthTable,
    ),
    difficulty: QuestionDifficulty.values.firstWhere(
      (e) => e.name == json['difficulty'],
      orElse: () => QuestionDifficulty.easy,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionText': questionText,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
    'userAnswerIndex': userAnswerIndex,
    'type': type.name,
    'category': category.name,
    'difficulty': difficulty.name,
  };

  // 便利方法
  bool get isAnswered => userAnswerIndex.isNotEmpty;
  
  bool get isCorrect {
    if (!isAnswered) return false;
    
    // 检查用户答案是否与正确答案完全匹配
    final userSet = Set<int>.from(userAnswerIndex);
    final correctSet = Set<int>.from(correctAnswerIndex);
    return userSet.length == correctSet.length && userSet.containsAll(correctSet);
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

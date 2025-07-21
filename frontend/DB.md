1. User 表

  {
    _id: ObjectId,
    email: String,
    password: String, // 加密存储
    username: String,
    profilePictureUrl: String,
    role： 'user' | 'admin',
    createdAt: time,
    updateAt" time
  }

  2. Question 表（题库）

  {
    _id: ObjectId,
    question_text: String,
    options: [String], // 选项数组
    correct_answer_index: [Number], // 正确答案索引数组
    type: "singleChoice" | "multipleChoice" | "trueFalse",
    category: "truthTable" | "equivalence" | "inference",
    difficulty: "easy" | "medium" | "hard",
    is_active: Boolean
  }

  3. Quiz 表（固定10题）

  {
    _id: ObjectId,
    user_id: ObjectId, // 用户ID
    quiz_type: "randomTasks" | "topicPractice" | "byDifficulty" | "customQuiz",
    questions: [
      {
        question_id: ObjectId, // 引用question表
        user_answer_index: [Number], // 用户答案索引，对应Question.userAnswerIndex
      }
      // 固定10个元素
    ],
    correct_questions_num: Number, // 正确题目数量
    completion_time: Number, // 完成时间（秒）
    completed_at: Date,
  }

4.   // user_stats 表
  {
    user_id: ObjectId,
    total_quizzes: Number,
    avg_score: Number,
    category_performance: {
      logic: { total: Number, avg_score: Number },
      reasoning: { total: Number, avg_score: Number }
    },
    last_updated: Date
  }
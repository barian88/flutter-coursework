package services

import (
	"backend/database"
	"backend/models"
	"context"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"time"
)

type QuizService struct {
	questionService   *QuestionService
	collection        *mongo.Collection
	pendingCollection *mongo.Collection
}

func NewQuizService(questionService *QuestionService) *QuizService {
	return &QuizService{
		questionService:   questionService,
		collection:        database.GetCollection(database.QuizzesCollection),
		pendingCollection: database.GetCollection(database.PendingQuizzesCollection),
	}
}

func (s *QuizService) CreateQuiz(userID primitive.ObjectID, req *models.CreateQuizRequest) (*models.PendingQuiz, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 获取随机题目列表
	questionList, err := s.questionService.GetRandomQuestions(req.Category, req.Difficulty, 10)
	if err != nil {
		return nil, err
	}
	// 将题目列表转换为QuizQuestion类型
	quizQuestions := make([]models.QuizQuestion, len(questionList))
	for i, question := range questionList {
		quizQuestions[i] = models.QuizQuestion{
			Question:        &question,
			UserAnswerIndex: []int{}, // 初始化用户答案为空
		}
	}
	// 创建PendingQuiz对象
	quiz := models.PendingQuiz{
		UserID:    userID,
		QuizType:  req.QuizType,
		Questions: quizQuestions,
	}

	// 插入Quiz到数据库
	result, err := s.pendingCollection.InsertOne(ctx, quiz)
	if err != nil {
		return nil, err
	}

	// 设置生成的ID
	quiz.ID = result.InsertedID.(primitive.ObjectID)

	return &quiz, nil
}

func (s *QuizService) GetQuizByID(quizID primitive.ObjectID) (*models.Quiz, error) {
	// TODO: 根据ID获取测验
	return nil, nil
}

func (s *QuizService) SubmitQuiz(userID primitive.ObjectID, req *models.SubmitQuizRequest) (*models.Quiz, error) {
	// TODO: 实现测验提交逻辑
	// 1. 验证quizID属于该用户
	// 2. 计算正确答案数量
	// 3. 更新Quiz记录
	// 4. 返回结果
	return nil, nil
}

func (s *QuizService) GetUserQuizHistory(userID primitive.ObjectID, limit int, offset int) ([]models.Quiz, error) {
	// TODO: 获取用户的测验历史
	return nil, nil
}

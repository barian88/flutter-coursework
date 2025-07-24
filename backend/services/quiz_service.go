package services

import (
	"backend/database"
	"backend/models"
	"backend/utils"
	"context"
	"errors"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"time"
)

type QuizService struct {
	questionService *QuestionService
	collection      *mongo.Collection
	//pendingCollection *mongo.Collection
}

func NewQuizService(questionService *QuestionService) *QuizService {
	return &QuizService{
		questionService: questionService,
		collection:      database.GetCollection(database.QuizzesCollection),
		//pendingCollection: database.GetCollection(database.PendingQuizzesCollection),
	}
}

func (s *QuizService) CreateQuiz(userID primitive.ObjectID, req *models.CreateQuizRequest) (*models.Quiz, error) {
	//ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	//defer cancel()

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
	// 创建Quiz对象
	quiz := models.Quiz{
		UserID:    userID,
		Type:     req.Type,
		Questions: quizQuestions,
	}
	//// 插入Quiz到数据库
	//result, err := s.pendingCollection.InsertOne(ctx, quiz)
	//if err != nil {
	//	return nil, err
	//}
	//
	//// 设置生成的ID
	//quiz.ID = result.InsertedID.(primitive.ObjectID)

	return &quiz, nil
}

func (s *QuizService) SubmitQuiz(userID primitive.ObjectID, req *models.SubmitQuizRequest) (*models.Quiz, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 1. 设置quiz完成时间
	completedAt := time.Now()
	// 2. 计算正确答案数量
	correctCount := 0
	for _, question := range req.Questions {
		if utils.AreSlicesEqual(question.UserAnswerIndex, question.Question.CorrectAnswerIndex) {
			correctCount++
		}
	}
	// 3. 创建Quiz记录
	quiz := models.Quiz{
		UserID:              userID,
		Type:                req.Type,
		Questions:           req.Questions,
		CorrectQuestionsNum: correctCount,
		CompletionTime:      req.CompletionTime,
		CompletedAt:         completedAt,
	}
	// 4. 保存到数据库
	result, err := s.collection.InsertOne(ctx, quiz)
	if err != nil {
		return nil, err
	}
	// 5. 设置生成的ID
	quiz.ID = result.InsertedID.(primitive.ObjectID)
	// 6. 返回结果
	return &quiz, nil
}

func (s *QuizService) GetUserQuizHistory(userID primitive.ObjectID) ([]models.Quiz, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	filter := bson.M{"user_id": userID}
	cursor, err := s.collection.Find(ctx, filter)
	if err != nil {
		return nil, err
	}
	var quizzes []models.Quiz
	if err := cursor.All(ctx, &quizzes); err != nil {
		return nil, err
	}

	return quizzes, nil
}

func (s *QuizService) GetQuizByID(quizID primitive.ObjectID) (*models.Quiz, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var quiz models.Quiz
	err := s.collection.FindOne(ctx, bson.M{"_id": quizID}).Decode(&quiz)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("quiz not found")
		}
		return nil, errors.New("Database query error")
	}

	return &quiz, nil
}

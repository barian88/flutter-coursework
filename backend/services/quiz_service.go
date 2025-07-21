package services

import (
	"backend/models"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type QuizService struct {
	questionService *QuestionService
	// TODO: 添加数据库连接
}

func NewQuizService(questionService *QuestionService) *QuizService {
	return &QuizService{
		questionService: questionService,
	}
}

func (s *QuizService) CreateQuiz(userID primitive.ObjectID, req *models.CreateQuizRequest) (*models.QuizResponse, error) {
	// TODO: 实现测验创建逻辑
	// 1. 根据quizType生成10道题目
	// 2. 创建Quiz记录
	// 3. 返回包含题目的Quiz
	return nil, nil
}

func (s *QuizService) GetQuizByID(quizID primitive.ObjectID) (*models.QuizResponse, error) {
	// TODO: 根据ID获取测验
	return nil, nil
}

func (s *QuizService) SubmitQuiz(userID primitive.ObjectID, req *models.SubmitQuizRequest) (*models.QuizResponse, error) {
	// TODO: 实现测验提交逻辑
	// 1. 验证quizID属于该用户
	// 2. 计算正确答案数量
	// 3. 更新Quiz记录
	// 4. 返回结果
	return nil, nil
}

func (s *QuizService) GetUserQuizHistory(userID primitive.ObjectID, limit int, offset int) ([]models.QuizResponse, error) {
	// TODO: 获取用户的测验历史
	return nil, nil
}

func (s *QuizService) generateQuestionsByType(quizType, category, difficulty string) ([]models.QuizQuestion, error) {
	// TODO: 根据类型生成10道题目
	// randomTasks: 随机选择
	// topicPractice: 按分类选择
	// byDifficulty: 按难度选择
	// customQuiz: 自定义逻辑
	return nil, nil
}

func (s *QuizService) calculateScore(questions []models.QuizQuestion) (int, error) {
	// TODO: 计算正确答案数量
	// 对比用户答案和正确答案
	return 0, nil
}
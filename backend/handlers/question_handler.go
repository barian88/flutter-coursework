package handlers

import (
	"backend/models"
	"backend/services"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"net/http"
)

type QuestionHandler struct {
	questionService *services.QuestionService
}

func NewQuestionHandler(questionService *services.QuestionService) *QuestionHandler {
	return &QuestionHandler{
		questionService: questionService,
	}
}

// CreateQuestion 向题库中增加题目
func (h *QuestionHandler) CreateQuestion(c *gin.Context) {
	var req models.CreateQuestionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	question, err := h.questionService.CreateQuestion(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, question)
}

// GetQuestionsByCategory 根据id获取题目
func (h *QuestionHandler) GetQuestion(c *gin.Context) {
	questionID, err := primitive.ObjectIDFromHex(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid question ID"})
		return
	}

	question, err := h.questionService.GetQuestionByID(questionID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Question not found"})
		return
	}

	c.JSON(http.StatusOK, question)
}

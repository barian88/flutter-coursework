package routes

import (
	"backend/handlers"
	"backend/middleware"
	"backend/services"

	"github.com/gin-gonic/gin"
)

// SetupRoutes configures all the routes for the application
func SetupRoutes() *gin.Engine {
	r := gin.Default()

	// 添加CORS中间件
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// Initialize services
	verificationService := services.NewVerificationService()
	userService := services.NewUserService(verificationService)
	questionService := services.NewQuestionService()
	quizService := services.NewQuizService(questionService)

	// Initialize handlers
	authHandler := handlers.NewAuthHandler(userService, verificationService)
	userHandler := handlers.NewUserHandler(userService)
	questionHandler := handlers.NewQuestionHandler(questionService)
	quizHandler := handlers.NewQuizHandler(quizService)

	// Authentication routes
	authRoutes := r.Group("/auth")
	{
		authRoutes.POST("/register-request", authHandler.RegisterRequest)
		authRoutes.POST("/complete-registration", authHandler.CompleteRegistration)
		authRoutes.POST("/login", authHandler.Login)
		authRoutes.POST("/logout", authHandler.Logout)
		authRoutes.POST("/send-verification", authHandler.SendVerificationCode)
		authRoutes.POST("/verify-code", authHandler.VerifyCode)
		authRoutes.POST("/update-password", authHandler.UpdatePassword)
	}

	// User profile routes
	userRoutes := r.Group("/users")
	{
		userRoutes.GET("/profile", middleware.AuthMiddleware(), userHandler.GetProfile)
		// TODO: 实现以下handlers
		// userRoutes.PUT("/profile", middleware.AuthMiddleware(), userHandler.UpdateProfile)
	}

	// Question routes
	questionRoutes := r.Group("/question")
	{
		questionRoutes.POST("", questionHandler.CreateQuestion)
		questionRoutes.GET("/:id", questionHandler.GetQuestion)
		questionRoutes.GET("/category/:category", questionHandler.GetQuestionsByCategory)
		questionRoutes.GET("/difficulty/:difficulty", questionHandler.GetQuestionsByDifficulty)
		questionRoutes.GET("/random", questionHandler.GetRandomQuestions)
	}

	// Quiz routes
	quizRoutes := r.Group("/quiz")
	{
		quizRoutes.POST("", quizHandler.CreateQuiz)
		quizRoutes.GET("/:id", quizHandler.GetQuiz)
		quizRoutes.POST("/submit", quizHandler.SubmitQuiz)
		quizRoutes.GET("/history", quizHandler.GetUserQuizHistory)
	}

	return r
}

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
		// 无需认证的接口
		authRoutes.POST("/register-request", authHandler.RegisterRequest)
		authRoutes.POST("/complete-registration", authHandler.CompleteRegistration)
		authRoutes.POST("/login", authHandler.Login)
		authRoutes.POST("/send-verification", authHandler.SendVerificationCode)
		authRoutes.POST("/verify-code", authHandler.VerifyCode)
		authRoutes.POST("/update-password", authHandler.UpdatePassword)

		// 需要认证的接口
		authRoutes.POST("/logout", middleware.AuthMiddleware(), authHandler.Logout)
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
		// 创建题目 - 需要认证（通常只有管理员可以创建题目）
		questionRoutes.POST("", middleware.AuthMiddleware(), questionHandler.CreateQuestion)

		// 获取单个题目 - 需要认证
		questionRoutes.GET("/:id", middleware.AuthMiddleware(), questionHandler.GetQuestion)
	}

	// Quiz routes
	quizRoutes := r.Group("/quiz")
	// 使用JWT认证中间件保护Quiz相关的路由
	quizRoutes.Use(middleware.AuthMiddleware())
	{
		quizRoutes.POST("/new", quizHandler.CreateQuiz)
		quizRoutes.GET("/:id", quizHandler.GetQuiz)
		quizRoutes.POST("/submit", quizHandler.SubmitQuiz)
		quizRoutes.GET("/history", quizHandler.GetUserQuizHistory)
	}

	return r
}

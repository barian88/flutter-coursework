package handlers

import (
	"backend/middleware"
	"backend/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

// UserHandler 用户处理器结构体 - 处理用户资料相关的HTTP请求
type UserHandler struct {
	userService *services.UserService // 用户服务实例，用于处理业务逻辑
}

// NewUserHandler 创建新的用户处理器实例
func NewUserHandler(userService *services.UserService) *UserHandler {
	return &UserHandler{
		userService: userService,
	}
}

// GetProfile 获取用户资料接口 - 处理GET /users/profile请求
// 这个接口需要JWT认证，只有登录用户才能访问
func (h *UserHandler) GetProfile(c *gin.Context) {
	// 第1步：从JWT中间件获取用户ID
	userID, exists := middleware.GetUserIDFromContext(c)
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"message": "User authentication information not found",
			"error":   "Failed to get user ID",
		})
		return
	}

	// 第2步：根据用户ID获取用户详细信息
	user, err := h.userService.GetUserByID(userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"message": "User not found",
			"error":   err.Error(),
		})
		return
	}

	// 第3步：返回用户资料 (简化格式以匹配前端期望)
	c.JSON(http.StatusOK, user)
}
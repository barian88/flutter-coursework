package main

import (
	"backend/database"
	"backend/routes"
	"log"
)

func main() {
	log.Println("🚀 启动Quiz应用后端服务...")

	database.ConnectMongoDB()
	r := routes.SetupRoutes()

	log.Println("🌐 服务器启动在端口 3000...")
	if err := r.Run(":3000"); err != nil {
		log.Fatal("服务器启动失败:", err)
	}
}

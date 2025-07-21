package models

// HelloWorldResponse represents the response for hello world endpoint
type HelloWorldResponse struct {
	Message string `json:"message"`
	Code    int    `json:"code"`
}
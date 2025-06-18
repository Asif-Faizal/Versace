package utils

import (
	"encoding/json"
	"net/http"
)

type ErrorResponse struct {
	Status      string `json:"status"`
	Message     string `json:"message"`
	Description string `json:"description,omitempty"`
}

func WriteError(w http.ResponseWriter, statusCode int, message string, description string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(ErrorResponse{
		Status:      "Fail",
		Message:     message,
		Description: description,
	})
}

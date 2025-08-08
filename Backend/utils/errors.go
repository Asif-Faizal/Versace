package utils

import (
	"encoding/json"
	"net/http"
)

type ErrorResponseWithDescription struct {
	Status      bool   `json:"status"`
	Message     string `json:"message"`
	Description string `json:"description,omitempty"`
}

func WriteErrorWithDescription(w http.ResponseWriter, statusCode int, message string, description string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(ErrorResponseWithDescription{
		Status:      false,
		Message:     message,
		Description: description,
	})
}

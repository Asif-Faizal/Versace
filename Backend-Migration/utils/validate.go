package utils

import (
	"regexp"
)

// IsValidEmail checks if the email provided is in a valid format.
func IsValidEmail(email string) bool {
	// A simple regex for email validation
	emailRegex := regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)
	return emailRegex.MatchString(email)
}

// IsValidPassword checks if the password meets the length requirement.
func IsValidPassword(password string) bool {
	return len(password) > 6
}

// IsValidName checks if the name meets the length requirement.
func IsValidName(name string) bool {
	return len(name) > 3
}

// IsValidOptionalName checks if the name is either empty or meets the length requirement.
func IsValidOptionalName(name string) bool {
	return name == "" || len(name) > 3
}

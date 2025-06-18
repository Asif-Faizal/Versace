package types

import "time"

// UserStore defines the interface for user data operations
// Any struct that implements these methods can be used as a user store
type UserStore interface {
	GetUserByEmail(email string) (*User, error)
	GetUserByID(id int) (*User, error)
	CreateUser(user *User) error
}

type User struct {
	ID        int       `json:"id"`        // Unique identifier for the user
	FirstName string    `json:"firstName"` // User's first name
	LastName  string    `json:"lastName"`  // User's last name
	Email     string    `json:"email"`     // User's email address (unique)
	Password  string    `json:"password"`  // Hashed password
	CreatedAt time.Time `json:"createdAt"` // Timestamp when the user was created
}

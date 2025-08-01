package types

import (
	"database/sql"
	"encoding/json"
	"time"
)

// NullString is a wrapper around sql.NullString that marshals to JSON as a string or null.
type NullString struct {
	sql.NullString
}

// MarshalJSON implements the json.Marshaler interface.
func (ns NullString) MarshalJSON() ([]byte, error) {
	if !ns.Valid {
		return []byte("null"), nil
	}
	return json.Marshal(ns.String)
}

type key int

const (
	UserKey key = iota
)

type AuthenticatedUser struct {
	ID    int
	Email string
	Role  string
}

// UserStore defines the interface for user data operations
// Any struct that implements these methods can be used as a user store
type UserStore interface {
	GetUserByEmail(email string) (*User, error)
	GetUserByID(id int) (*User, error)
	CreateUser(user *User) (*User, error)
	GetUsers() ([]User, error)
	UpdateUser(user *User) error
	DeleteUser(userID int) error
	UpdateEmail(userID int, email string) error
	ChangePassword(userID int, password string) error
	RevokeToken(userID int, deviceID string) error
	UpdateProfileURL(userID int, profileURL sql.NullString) error

	// OTP
	SaveOTP(otp *OTP) error
	GetOTPByEmail(email string) (*OTP, error)
	DeleteOTP(email string) error
}

// Authable is an interface for objects that can be used for authentication.
type Authable interface {
	GetID() int
	GetEmail() string
	GetRole() string
}

type User struct {
	ID         int        `json:"id"`        // Unique identifier for the user
	FirstName  string     `json:"firstName"` // User's first name
	LastName   string     `json:"lastName"`  // User's last name
	Email      string     `json:"email"`     // User's email address (unique)
	Password   string     `json:"-"`         // Hashed password
	ProfileURL NullString `json:"profileUrl"`
	Role       string     `json:"role"`      // User's role (admin, user, etc.)
	CreatedAt  time.Time  `json:"createdAt"` // Timestamp when the user was created
	UpdatedAt  time.Time  `json:"updatedAt"` // Timestamp when the user was updated
}

func (u *User) GetID() int {
	return u.ID
}

func (u *User) GetEmail() string {
	return u.Email
}

func (u *User) GetRole() string {
	return u.Role
}

type UserRegisterRequest struct {
	FirstName          string `json:"firstName"`
	LastName           string `json:"lastName"`
	Email              string `json:"email"`
	Password           string `json:"password"`
	Role               string `json:"role"`
	AdminCreationToken string `json:"adminCreationToken"`
}

type CheckEmailRequest struct {
	Email string `json:"email"`
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RefreshTokenRequest struct {
	RefreshToken string `json:"refreshToken"`
}

type OTP struct {
	ID        int       `json:"id"`
	Email     string    `json:"email"`
	Code      string    `json:"code"`
	ExpiresAt time.Time `json:"expiresAt"`
}

type SendOTPRequest struct {
	Email string `json:"email"`
}

type VerifyOTPRequest struct {
	Email string `json:"email"`
	OTP   string `json:"otp"`
}

type AuthResponse struct {
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
	User         User   `json:"user"`
}

type UsersResponse struct {
	Users []User `json:"users"`
}

type GetUserByIDRequest struct {
	UserID int `json:"userID"`
}

type UserResponse struct {
	User User `json:"user"`
}

type UpdateUserRequest struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
}

type UpdateEmailRequest struct {
	Email string `json:"email"`
}

type ChangePasswordRequest struct {
	CurrentPassword string `json:"currentPassword"`
	NewPassword     string `json:"newPassword"`
}

type DeleteAccountRequest struct {
	Password string `json:"password"`
}

type AdminDeleteAccountRequest struct {
	AdminCreationToken string `json:"adminCreationToken"`
	Password           string `json:"password"`
}

type ResetPasswordRequest struct {
	NewPassword string `json:"newPassword"`
}

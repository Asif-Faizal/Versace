package types

import (
	"time"
)

// Token represents a refresh/access token for a user session.
type Token struct {
	ID           int        `json:"id" db:"id"`
	UserID       int        `json:"user_id" db:"user_id"`
	AccessToken  string     `json:"access_token" db:"access_token"` // Optional: can be empty or omitted
	RefreshToken string     `json:"refresh_token" db:"refresh_token"`
	ExpiresAt    time.Time  `json:"expires_at" db:"expires_at"`
	Revoked      bool       `json:"revoked" db:"revoked"`
	CreatedAt    time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at" db:"updated_at"`
	DeviceInfo   DeviceInfo `json:"device_info" db:"device_info"`
}

// TokenStore defines the interface for token data operations
type TokenStore interface {
	CreateToken(token *Token) error
	GetTokenByRefreshToken(refreshToken string) (*Token, error)
	GetTokenByUserIDAndDeviceID(userID int, deviceID string) (*Token, error)
	UpdateToken(token *Token) error
	IsTokenRevoked(userID int, deviceID string) (bool, error)

	// Device Info
	GetDevicesByUserID(userID int) ([]DeviceInfo, error)
}

type DeviceInfo struct {
	ID          int    `json:"id" db:"id"`
	TokenID     int    `json:"token_id" db:"token_id"`
	DeviceID    string `json:"device_id" db:"device_id"`
	DeviceName  string `json:"device_name" db:"device_name"`
	DeviceType  string `json:"device_type" db:"device_type"`
	DeviceOS    string `json:"device_os" db:"device_os"`
	DeviceModel string `json:"device_model" db:"device_model"`
	DeviceIP    string `json:"device_ip" db:"device_ip"`
	IsCurrent   bool   `json:"is_current"`
}

type DeviceSessionsRequest struct {
	UserID   int    `json:"user_id" db:"user_id"`
	DeviceID string `json:"device_id" db:"device_id"`
}

type DeviceSessionsResponse struct {
	Devices []DeviceInfo `json:"devices"`
}

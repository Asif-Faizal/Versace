package user

import (
	"database/sql"

	"github.com/Asif-Faizal/Versace/types"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) GetUserByEmail(email string) (*types.User, error) {
	// ... implementation ...
	return nil, nil
}

func (s *Store) GetUserByID(id int) (*types.User, error) {
	// ... implementation ...
	return nil, nil
}

func (s *Store) CreateUser(user *types.User) (*types.User, error) {
	res, err := s.db.Exec("INSERT INTO users (first_name, last_name, email, password, role, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)", user.FirstName, user.LastName, user.Email, user.Password, user.Role, user.CreatedAt, user.UpdatedAt)
	if err != nil {
		return nil, err
	}

	id, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	user.ID = int(id)
	return user, nil
}

func (s *Store) CreateToken(token *types.Token) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	res, err := tx.Exec("INSERT INTO tokens (user_id, access_token, refresh_token, expires_at) VALUES (?, ?, ?, ?)", token.UserID, token.AccessToken, token.RefreshToken, token.ExpiresAt)
	if err != nil {
		return err
	}

	tokenID, err := res.LastInsertId()
	if err != nil {
		return err
	}

	_, err = tx.Exec("INSERT INTO device_info (token_id, device_id, device_name, device_type, device_os, device_model, device_ip) VALUES (?, ?, ?, ?, ?, ?, ?)", tokenID, token.DeviceInfo.DeviceID, token.DeviceInfo.DeviceName, token.DeviceInfo.DeviceType, token.DeviceInfo.DeviceOS, token.DeviceInfo.DeviceModel, token.DeviceInfo.DeviceIP)
	if err != nil {
		return err
	}

	return tx.Commit()
}

func (s *Store) GetTokenByRefreshToken(refreshToken string) (*types.Token, error) {
	// ... implementation ...
	return nil, nil
}

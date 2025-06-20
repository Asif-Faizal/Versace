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

func (s *Store) GetUsers() ([]types.User, error) {
	rows, err := s.db.Query("SELECT id, first_name, last_name, email, password, role, created_at, updated_at FROM users WHERE role != 'admin'")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []types.User
	for rows.Next() {
		var user types.User
		if err := rows.Scan(&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Password, &user.Role, &user.CreatedAt, &user.UpdatedAt); err != nil {
			return nil, err
		}
		users = append(users, user)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return users, nil
}

func (s *Store) GetUserByEmail(email string) (*types.User, error) {
	row := s.db.QueryRow("SELECT id, first_name, last_name, email, password, role, created_at, updated_at FROM users WHERE email = ?", email)

	user := new(types.User)
	if err := row.Scan(&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Password, &user.Role, &user.CreatedAt, &user.UpdatedAt); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No user found is not an error in this context
		}
		return nil, err
	}
	return user, nil
}

func (s *Store) GetUserByID(id int) (*types.User, error) {
	row := s.db.QueryRow("SELECT id, first_name, last_name, email, password, role, created_at, updated_at FROM users WHERE id = ?", id)

	user := new(types.User)
	if err := row.Scan(&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Password, &user.Role, &user.CreatedAt, &user.UpdatedAt); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No user found is not an error in this context
		}
		return nil, err
	}
	return user, nil
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
	row := s.db.QueryRow(`
		SELECT t.id, t.user_id, t.access_token, t.refresh_token, t.expires_at, t.revoked, t.created_at, t.updated_at,
		       di.id, di.token_id, di.device_id, di.device_name, di.device_type, di.device_os, di.device_model, di.device_ip
		FROM tokens t
		LEFT JOIN device_info di ON t.id = di.token_id
		WHERE t.refresh_token = ?
	`, refreshToken)

	token := new(types.Token)
	err := row.Scan(
		&token.ID, &token.UserID, &token.AccessToken, &token.RefreshToken, &token.ExpiresAt, &token.Revoked, &token.CreatedAt, &token.UpdatedAt,
		&token.DeviceInfo.ID, &token.DeviceInfo.TokenID, &token.DeviceInfo.DeviceID, &token.DeviceInfo.DeviceName, &token.DeviceInfo.DeviceType, &token.DeviceInfo.DeviceOS, &token.DeviceInfo.DeviceModel, &token.DeviceInfo.DeviceIP,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No token found is not an error
		}
		return nil, err
	}

	return token, nil
}

func (s *Store) UpdateToken(token *types.Token) error {
	_, err := s.db.Exec(`
		UPDATE tokens 
		SET access_token = ?, refresh_token = ?, expires_at = ?, revoked = ?, updated_at = ?
		WHERE id = ?
	`, token.AccessToken, token.RefreshToken, token.ExpiresAt, token.Revoked, token.UpdatedAt, token.ID)
	return err
}

func (s *Store) SaveOTP(otp *types.OTP) error {
	// Use an UPSERT-like behavior: delete any existing OTP for the email, then insert the new one.
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback() // Rollback on error

	_, err = tx.Exec("DELETE FROM otps WHERE email = ?", otp.Email)
	if err != nil {
		return err
	}

	_, err = tx.Exec("INSERT INTO otps (email, code, expires_at) VALUES (?, ?, ?)", otp.Email, otp.Code, otp.ExpiresAt)
	if err != nil {
		return err
	}

	return tx.Commit()
}

func (s *Store) GetOTPByEmail(email string) (*types.OTP, error) {
	row := s.db.QueryRow("SELECT id, email, code, expires_at FROM otps WHERE email = ?", email)

	otp := new(types.OTP)
	if err := row.Scan(&otp.ID, &otp.Email, &otp.Code, &otp.ExpiresAt); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No OTP found is not an error
		}
		return nil, err
	}
	return otp, nil
}

func (s *Store) DeleteOTP(email string) error {
	_, err := s.db.Exec("DELETE FROM otps WHERE email = ?", email)
	return err
}

func (s *Store) GetTokenByUserIDAndDeviceID(userID int, deviceID string) (*types.Token, error) {
	row := s.db.QueryRow(`
        SELECT t.id, t.user_id, t.access_token, t.refresh_token, t.expires_at, t.revoked, t.created_at, t.updated_at,
               di.id, di.token_id, di.device_id, di.device_name, di.device_type, di.device_os, di.device_model, di.device_ip
        FROM tokens t
        JOIN device_info di ON t.id = di.token_id
        WHERE t.user_id = ? AND di.device_id = ?
    `, userID, deviceID)

	token := new(types.Token)
	err := row.Scan(
		&token.ID, &token.UserID, &token.AccessToken, &token.RefreshToken, &token.ExpiresAt, &token.Revoked, &token.CreatedAt, &token.UpdatedAt,
		&token.DeviceInfo.ID, &token.DeviceInfo.TokenID, &token.DeviceInfo.DeviceID, &token.DeviceInfo.DeviceName, &token.DeviceInfo.DeviceType, &token.DeviceInfo.DeviceOS, &token.DeviceInfo.DeviceModel, &token.DeviceInfo.DeviceIP,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No token found is not an error
		}
		return nil, err
	}

	return token, nil
}

func (s *Store) GetDevicesByUserID(userID int) ([]types.DeviceInfo, error) {
	rows, err := s.db.Query(`
		SELECT di.id, di.token_id, di.device_id, di.device_name, di.device_type, di.device_os, di.device_model, di.device_ip
		FROM device_info di
		JOIN tokens t ON di.token_id = t.id
		WHERE t.user_id = ? AND t.revoked = false
	`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var devices []types.DeviceInfo
	for rows.Next() {
		var device types.DeviceInfo
		if err := rows.Scan(&device.ID, &device.TokenID, &device.DeviceID, &device.DeviceName, &device.DeviceType, &device.DeviceOS, &device.DeviceModel, &device.DeviceIP); err != nil {
			return nil, err
		}
		devices = append(devices, device)
	}
	return devices, nil
}

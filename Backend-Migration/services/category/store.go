package category

import (
	"database/sql"

	"github.com/Asif-Faizal/Versace/types/category"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) CreateCategory(c *category.Category) (*category.Category, error) {
	res, err := s.db.Exec("INSERT INTO categories (name, image_url, description) VALUES (?, ?, ?)", c.Name, c.ImageURL, c.Description)
	if err != nil {
		return nil, err
	}

	id, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	return s.GetCategoryByID(int(id))
}

func (s *Store) BulkCreateCategory(categories []*category.Category) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.Prepare("INSERT INTO categories (name, image_url, description) VALUES (?, ?, ?)")
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, c := range categories {
		_, err := stmt.Exec(c.Name, c.ImageURL, c.Description)
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (s *Store) GetCategories() ([]category.Category, error) {
	rows, err := s.db.Query("SELECT id, name, image_url, description, created_at, updated_at FROM categories")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var categories []category.Category
	for rows.Next() {
		var c category.Category
		if err := rows.Scan(&c.ID, &c.Name, &c.ImageURL, &c.Description, &c.CreatedAt, &c.UpdatedAt); err != nil {
			return nil, err
		}
		categories = append(categories, c)
	}

	return categories, nil
}

func (s *Store) GetCategoryByID(id int) (*category.Category, error) {
	var c category.Category
	err := s.db.QueryRow("SELECT id, name, image_url, description, created_at, updated_at FROM categories WHERE id = ?", id).Scan(&c.ID, &c.Name, &c.ImageURL, &c.Description, &c.CreatedAt, &c.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &c, nil
}

func (s *Store) UpdateCategory(c *category.Category) error {
	_, err := s.db.Exec("UPDATE categories SET name = ?, description = ?, image_url = ? WHERE id = ?", c.Name, c.Description, c.ImageURL, c.ID)
	return err
}

func (s *Store) UpdateCategoryImageURL(id int, imageURL string) error {
	_, err := s.db.Exec("UPDATE categories SET image_url = ? WHERE id = ?", imageURL, id)
	return err
}

func (s *Store) DeleteCategory(id int) error {
	_, err := s.db.Exec("DELETE FROM categories WHERE id = ?", id)
	return err
}

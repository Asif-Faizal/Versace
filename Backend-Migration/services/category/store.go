package category

import (
	"database/sql"

	types "github.com/Asif-Faizal/Versace/types/category"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) GetCategories() ([]types.Category, error) {
	// Get all categories from the database
	rows, err := s.db.Query("SELECT id, name, description, created_at, updated_at FROM categories")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	// Scan the results into a slice of Category structs
	var categories []types.Category
	for rows.Next() {
		var category types.Category
		if err := rows.Scan(&category.ID, &category.Name, &category.Description, &category.CreatedAt, &category.UpdatedAt); err != nil {
			return nil, err
		}
		categories = append(categories, category)
	}

	if err = rows.Err(); err != nil {
		// Return an error if there is a problem with the rows
		return nil, err
	}

	return categories, nil
}

func (s *Store) CreateCategory(category *types.Category) (*types.Category, error) {
	// Insert a new category into the database
	res, err := s.db.Exec("INSERT INTO categories (name, description) VALUES (?, ?)", category.Name, category.Description)
	if err != nil {
		return nil, err
	}

	id, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	return s.GetCategoryByID(int(id))
}

func (s *Store) GetCategoryByID(id int) (*types.Category, error) {
	// Get a category by ID from the database
	var category types.Category
	err := s.db.QueryRow("SELECT id, name, description, created_at, updated_at FROM categories WHERE id = ?", id).Scan(&category.ID, &category.Name, &category.Description, &category.CreatedAt, &category.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &category, nil
}

func (s *Store) UpdateCategory(category *types.Category) error {
	// Update a category in the database
	_, err := s.db.Exec("UPDATE categories SET name = ?, description = ?, updated_at = NOW() WHERE id = ?", category.Name, category.Description, category.ID)
	return err
}

func (s *Store) DeleteCategory(id int) error {
	// Delete a category from the database
	_, err := s.db.Exec("DELETE FROM categories WHERE id = ?", id)
	return err
}

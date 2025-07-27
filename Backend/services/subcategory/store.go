package subcategory

import (
	"database/sql"

	types "github.com/Asif-Faizal/Versace/types/subcategory"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) GetSubcategories() ([]types.Subcategory, error) {
	var subcategories []types.Subcategory
	rows, err := s.db.Query("SELECT id, name, description, image_url, category_id, created_at, updated_at FROM subcategories")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var subcategory types.Subcategory
		if err := rows.Scan(&subcategory.ID, &subcategory.Name, &subcategory.Description, &subcategory.ImageURL, &subcategory.CategoryID, &subcategory.CreatedAt, &subcategory.UpdatedAt); err != nil {
			return nil, err
		}
		subcategories = append(subcategories, subcategory)
	}
	return subcategories, nil
}

func (s *Store) GetSubcategoryByID(id int) (*types.Subcategory, error) {
	var subcategory types.Subcategory
	err := s.db.QueryRow("SELECT id, name, description, image_url, category_id, created_at, updated_at FROM subcategories WHERE id = ?", id).Scan(&subcategory.ID, &subcategory.Name, &subcategory.Description, &subcategory.ImageURL, &subcategory.CategoryID, &subcategory.CreatedAt, &subcategory.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &subcategory, nil
}

func (s *Store) GetSubcategoriesByCategoryID(categoryID int) ([]types.Subcategory, error) {
	rows, err := s.db.Query("SELECT id, name, description, image_url, category_id, created_at, updated_at FROM subcategories WHERE category_id = ?", categoryID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var subcategories []types.Subcategory
	for rows.Next() {
		var subcategory types.Subcategory
		if err := rows.Scan(&subcategory.ID, &subcategory.Name, &subcategory.Description, &subcategory.ImageURL, &subcategory.CategoryID, &subcategory.CreatedAt, &subcategory.UpdatedAt); err != nil {
			return nil, err
		}
		subcategories = append(subcategories, subcategory)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return subcategories, nil
}

func (s *Store) CreateSubcategory(subcategory *types.Subcategory) (*types.Subcategory, error) {
	res, err := s.db.Exec("INSERT INTO subcategories (name, description, image_url, category_id) VALUES (?, ?, ?, ?)", subcategory.Name, subcategory.Description, subcategory.ImageURL, subcategory.CategoryID)
	if err != nil {
		return nil, err
	}

	id, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	return s.GetSubcategoryByID(int(id))
}

func (s *Store) BulkCreateSubcategory(subcategories []*types.Subcategory) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.Prepare("INSERT INTO subcategories (name, description, image_url, category_id) VALUES (?, ?, ?, ?)")
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, sc := range subcategories {
		_, err := stmt.Exec(sc.Name, sc.Description, sc.ImageURL, sc.CategoryID)
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (s *Store) UpdateSubcategory(subcategory *types.Subcategory) error {
	_, err := s.db.Exec("UPDATE subcategories SET name = ?, description = ?, category_id = ?, updated_at = NOW() WHERE id = ?", subcategory.Name, subcategory.Description, subcategory.CategoryID, subcategory.ID)
	return err
}

func (s *Store) UpdateSubcategoryImageURL(id int, imageURL string) error {
	_, err := s.db.Exec("UPDATE subcategories SET image_url = ?, updated_at = NOW() WHERE id = ?", imageURL, id)
	return err
}

func (s *Store) DeleteSubcategory(id int) error {
	_, err := s.db.Exec("DELETE FROM subcategories WHERE id = ?", id)
	return err
}

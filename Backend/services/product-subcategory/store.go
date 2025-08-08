package product_subcategory

import (
	"database/sql"
	"fmt"

	types "github.com/Asif-Faizal/Versace/types/product-subcategory"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) GetProductSubcategories() ([]types.ProductSubcategory, error) {
	var productSubcategories []types.ProductSubcategory
	rows, err := s.db.Query("SELECT id, product_id, subcategory_id, created_at, updated_at FROM product_subcategories")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var productSubcategory types.ProductSubcategory
		if err := rows.Scan(&productSubcategory.ID, &productSubcategory.ProductID, &productSubcategory.SubcategoryID, &productSubcategory.CreatedAt, &productSubcategory.UpdatedAt); err != nil {
			return nil, err
		}
		productSubcategories = append(productSubcategories, productSubcategory)
	}
	return productSubcategories, nil
}

func (s *Store) GetProductSubcategoryByID(id int) (*types.ProductSubcategory, error) {
	var productSubcategory types.ProductSubcategory
	err := s.db.QueryRow("SELECT id, product_id, subcategory_id, created_at, updated_at FROM product_subcategories WHERE id = ?", id).Scan(&productSubcategory.ID, &productSubcategory.ProductID, &productSubcategory.SubcategoryID, &productSubcategory.CreatedAt, &productSubcategory.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &productSubcategory, nil
}

func (s *Store) GetProductSubcategoriesByProductID(productID int) ([]types.ProductSubcategory, error) {
	var productSubcategories []types.ProductSubcategory
	rows, err := s.db.Query("SELECT id, product_id, subcategory_id, created_at, updated_at FROM product_subcategories WHERE product_id = ?", productID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var productSubcategory types.ProductSubcategory
		if err := rows.Scan(&productSubcategory.ID, &productSubcategory.ProductID, &productSubcategory.SubcategoryID, &productSubcategory.CreatedAt, &productSubcategory.UpdatedAt); err != nil {
			return nil, err
		}
		productSubcategories = append(productSubcategories, productSubcategory)
	}
	return productSubcategories, nil
}

func (s *Store) GetProductSubcategoriesBySubcategoryID(subcategoryID int) ([]types.ProductSubcategory, error) {
	var productSubcategories []types.ProductSubcategory
	rows, err := s.db.Query("SELECT id, product_id, subcategory_id, created_at, updated_at FROM product_subcategories WHERE subcategory_id = ?", subcategoryID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var productSubcategory types.ProductSubcategory
		if err := rows.Scan(&productSubcategory.ID, &productSubcategory.ProductID, &productSubcategory.SubcategoryID, &productSubcategory.CreatedAt, &productSubcategory.UpdatedAt); err != nil {
			return nil, err
		}
		productSubcategories = append(productSubcategories, productSubcategory)
	}
	return productSubcategories, nil
}

func (s *Store) CreateProductSubcategory(productSubcategory *types.ProductSubcategory) (*types.ProductSubcategory, error) {
	result, err := s.db.Exec("INSERT INTO product_subcategories (product_id, subcategory_id) VALUES (?, ?)", productSubcategory.ProductID, productSubcategory.SubcategoryID)
	if err != nil {
		// Check for duplicate entry error
		if err.Error() == "Error 1062: Duplicate entry" {
			return nil, fmt.Errorf("product subcategory already exists")
		}
		return nil, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return nil, err
	}
	productSubcategory.ID = int(id)
	return productSubcategory, nil
}

func (s *Store) BulkCreateProductSubcategory(productSubcategories []*types.ProductSubcategory) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.Prepare("INSERT INTO product_subcategories (product_id, subcategory_id) VALUES (?, ?)")
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, productSubcategory := range productSubcategories {
		result, err := stmt.Exec(productSubcategory.ProductID, productSubcategory.SubcategoryID)
		if err != nil {
			// Check for duplicate entry error
			if err.Error() == "Error 1062: Duplicate entry" {
				return fmt.Errorf("product subcategory with product_id %d and subcategory_id %d already exists", productSubcategory.ProductID, productSubcategory.SubcategoryID)
			}
			return err
		}
		id, err := result.LastInsertId()
		if err != nil {
			return err
		}
		productSubcategory.ID = int(id)
	}

	return tx.Commit()
}

func (s *Store) UpdateProductSubcategory(productSubcategory *types.ProductSubcategory) error {
	_, err := s.db.Exec("UPDATE product_subcategories SET product_id = ?, subcategory_id = ? WHERE id = ?",
		productSubcategory.ProductID, productSubcategory.SubcategoryID, productSubcategory.ID)
	return err
}

func (s *Store) DeleteProductSubcategory(id int) error {
	_, err := s.db.Exec("DELETE FROM product_subcategories WHERE id = ?", id)
	return err
}

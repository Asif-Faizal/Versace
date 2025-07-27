package product

import (
	"database/sql"

	"github.com/Asif-Faizal/Versace/types/product"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) CreateProduct(p *product.Product) (*product.Product, error) {
	res, err := s.db.Exec("INSERT INTO products (name, description, base_price, main_image_url) VALUES (?, ?, ?, ?)", p.Name, p.Description, p.BasePrice, p.MainImageURL)
	if err != nil {
		return nil, err
	}

	id, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	return s.GetProductByID(int(id))
}

func (s *Store) GetProducts() ([]product.Product, error) {
	rows, err := s.db.Query("SELECT id, name, description, base_price, main_image_url, created_at, updated_at FROM products")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var products []product.Product
	for rows.Next() {
		var p product.Product
		if err := rows.Scan(&p.ID, &p.Name, &p.Description, &p.BasePrice, &p.MainImageURL, &p.CreatedAt, &p.UpdatedAt); err != nil {
			return nil, err
		}
		products = append(products, p)
	}

	return products, nil
}

func (s *Store) GetProductByID(id int) (*product.Product, error) {
	row := s.db.QueryRow("SELECT id, name, description, base_price, main_image_url, created_at, updated_at FROM products WHERE id = ?", id)
	var p product.Product
	if err := row.Scan(&p.ID, &p.Name, &p.Description, &p.BasePrice, &p.MainImageURL, &p.CreatedAt, &p.UpdatedAt); err != nil {
		return nil, err
	}
	return &p, nil
}

func (s *Store) UpdateProduct(p *product.Product) (*product.Product, error) {
	// First check if the product exists
	existingProduct, err := s.GetProductByID(p.ID)
	if err != nil {
		return nil, err
	}
	if existingProduct == nil {
		return nil, sql.ErrNoRows
	}

	// Execute the UPDATE statement
	result, err := s.db.Exec("UPDATE products SET name = ?, description = ?, base_price = ?, main_image_url = ? WHERE id = ?",
		p.Name, p.Description, p.BasePrice, p.MainImageURL, p.ID)
	if err != nil {
		return nil, err
	}

	// Check if any rows were affected
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return nil, err
	}
	if rowsAffected == 0 {
		return nil, sql.ErrNoRows
	}

	// Fetch the updated product
	return s.GetProductByID(p.ID)
}

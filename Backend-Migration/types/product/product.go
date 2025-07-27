package product

import "time"

type Product struct {
	ID           int       `json:"id"`
	Name         string    `json:"name"`
	Description  string    `json:"description"`
	BasePrice    float64   `json:"basePrice"`
	MainImageURL string    `json:"mainImageURL"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

type ProductStore interface {
	// core product
	GetProducts() ([]Product, error)
	GetProductByID(id int) (*Product, error)
	CreateProduct(product *Product) (*Product, error)
	// BulkCreateProduct(products []*Product) error
	// UpdateProduct(product *Product) error
	// DeleteProduct(id int) error
}

type ProductCreateRequest struct {
	Name        string  `json:"name"`
	Description string  `json:"description"`
	BasePrice   float64 `json:"basePrice"`
}

type ProductByIDRequest struct {
	ID int `json:"id"`
}

type ProductUpdateRequest struct {
	ID          int     `json:"id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	BasePrice   float64 `json:"basePrice"`
}

type ProductDeleteRequest struct {
	ID int `json:"id"`
}

type ProductCreateResponse struct {
	Product Product `json:"product"`
}

type ProductsResponse struct {
	Products []Product `json:"products"`
}

type ProductByIDResponse struct {
	Product Product `json:"product"`
}

type ProductUpdateResponse struct {
	Product Product `json:"product"`
}

type ProductDeleteResponse struct {
	Message string `json:"message"`
}

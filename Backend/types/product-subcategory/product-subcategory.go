package product_subcategory

import "time"

type ProductSubcategory struct {
	ID            int       `json:"id"`
	ProductID     int       `json:"product_id"`
	SubcategoryID int       `json:"subcategory_id"`
	CreatedAt     time.Time `json:"createdAt"`
	UpdatedAt     time.Time `json:"updatedAt"`
}

type ProductSubcategoryStore interface {
	GetProductSubcategories() ([]ProductSubcategory, error)
	GetProductSubcategoryByID(id int) (*ProductSubcategory, error)
	GetProductSubcategoriesByProductID(productID int) ([]ProductSubcategory, error)
	GetProductSubcategoriesBySubcategoryID(subcategoryID int) ([]ProductSubcategory, error)
	CreateProductSubcategory(productSubcategory *ProductSubcategory) (*ProductSubcategory, error)
	BulkCreateProductSubcategory(productSubcategories []*ProductSubcategory) error
	UpdateProductSubcategory(productSubcategory *ProductSubcategory) error
	DeleteProductSubcategory(id int) error
}

type ProductSubcategoryCreateRequest struct {
	ProductID     int `json:"product_id"`
	SubcategoryID int `json:"subcategory_id"`
}

type ProductSubcategoryByIDRequest struct {
	ID int `json:"id"`
}

type ProductSubcategoryByProductIDRequest struct {
	ProductID int `json:"product_id"`
}

type ProductSubcategoryBySubcategoryIDRequest struct {
	SubcategoryID int `json:"subcategory_id"`
}

type ProductSubcategoryCreateResponse struct {
	ProductSubcategory ProductSubcategory `json:"product_subcategory"`
}

type ProductSubcategoriesResponse struct {
	ProductSubcategories []ProductSubcategory `json:"product_subcategories"`
}

type ProductSubcategoryByIDResponse struct {
	ProductSubcategory ProductSubcategory `json:"product_subcategory"`
}

type ProductSubcategoryByProductIDResponse struct {
	ProductSubcategories []ProductSubcategory `json:"product_subcategories"`
}

type ProductSubcategoryBySubcategoryIDResponse struct {
	ProductSubcategories []ProductSubcategory `json:"product_subcategories"`
}

type ProductSubcategoryUpdateRequest struct {
	ProductID     int `json:"product_id"`
	SubcategoryID int `json:"subcategory_id"`
}

type ProductSubcategoryUpdateResponse struct {
	ProductSubcategory ProductSubcategory `json:"product_subcategory"`
}

type ProductSubcategoryDeleteRequest struct {
	ID int `json:"id"`
}

type ProductSubcategoryDeleteResponse struct {
	Message string `json:"message"`
}

package subcategory

import "time"

type Subcategory struct {
	ID          int       `json:"id"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	ImageURL    string    `json:"imageUrl"`
	CategoryID  int       `json:"categoryId"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

type SubcategoryStore interface {
	GetSubcategories() ([]Subcategory, error)
	GetSubcategoryByID(id int) (*Subcategory, error)
	GetSubcategoriesByCategoryID(categoryID int) ([]Subcategory, error)
	CreateSubcategory(subcategory *Subcategory) (*Subcategory, error)
	UpdateSubcategory(subcategory *Subcategory) error
	UpdateSubcategoryImageURL(id int, imageURL string) error
	DeleteSubcategory(id int) error
}

type SubcategoryCreateRequest struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	CategoryID  int    `json:"categoryId"`
}

type SubcategoryByIDRequest struct {
	ID int `json:"id"`
}

type SubcategoryByCategoryIDRequest struct {
	CategoryID int `json:"categoryId"`
}

type SubcategoryUpdateRequest struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	CategoryID  int    `json:"categoryId"`
}

type SubcategoryDeleteRequest struct {
	ID int `json:"id"`
}

type SubcategoryCreateResponse struct {
	Subcategory Subcategory `json:"subcategory"`
}

type SubcategoriesResponse struct {
	Subcategories []Subcategory `json:"subcategories"`
}

type SubcategoryByIDResponse struct {
	Subcategory Subcategory `json:"subcategory"`
}

type SubcategoryByCategoryIDResponse struct {
	Subcategories []Subcategory `json:"subcategories"`
}

type SubcategoryUpdateResponse struct {
	Subcategory Subcategory `json:"subcategory"`
}

type SubcategoryDeleteResponse struct {
	Message string `json:"message"`
}

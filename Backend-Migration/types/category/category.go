package category

import "time"

type Category struct {
	ID          int       `json:"id"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	ImageURL    string    `json:"imageUrl"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

type CategoryStore interface {
	GetCategories() ([]Category, error)
	GetCategoryByID(id int) (*Category, error)
	CreateCategory(category *Category) (*Category, error)
	UpdateCategory(category *Category) error
	UpdateCategoryImageURL(id int, imageURL string) error
	DeleteCategory(id int) error
}

type CategoryCreateRequest struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

type CategoryByIDRequest struct {
	ID int `json:"id"`
}

type CategoryUpdateRequest struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

type CategoryDeleteRequest struct {
	ID int `json:"id"`
}

type CategoryResponse struct {
	Category Category `json:"category"`
}

type CategoriesResponse struct {
	Categories []Category `json:"categories"`
}

type CategoryByIDResponse struct {
	Category Category `json:"category"`
}

type CategoryCreateResponse struct {
	Category Category `json:"category"`
}

type CategoryUpdateResponse struct {
	Category Category `json:"category"`
}

type CategoryDeleteResponse struct {
	Message string `json:"message"`
}

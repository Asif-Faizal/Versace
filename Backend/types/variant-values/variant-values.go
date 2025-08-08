package variant_values

import "time"

type VariantValues struct {
	ID              int       `json:"id"`
	MasterVariantID int       `json:"masterVariantId"`
	Value           string    `json:"value"`
	HexCode         string    `json:"hexCode"` // optional for color
	CreatedAt       time.Time `json:"createdAt"`
	UpdatedAt       time.Time `json:"updatedAt"`
}

type VariantValuesStore interface {
	GetVariantValues() ([]VariantValues, error)
	GetVariantValueByID(id int) (*VariantValues, error)
	CreateVariantValue(variantValue *VariantValues) (*VariantValues, error)
	UpdateVariantValue(variantValue *VariantValues) error
	DeleteVariantValue(id int) error
}

type GetVariantValuesResponse struct {
	VariantValues []VariantValues `json:"variantValues"`
}

type VariantValuesCreateRequest struct {
	MasterVariantID int    `json:"masterVariantId"`
	Value           string `json:"value"`
	HexCode         string `json:"hexCode"` // optional for color
}

type VariantValuesCreateResponse struct {
	VariantValue VariantValues `json:"variantValue"`
}

type VariantValuesUpdateRequest struct {
	VariantValue VariantValues `json:"variantValue"`
}

type VariantValuesUpdateResponse struct {
	VariantValue VariantValues `json:"variantValue"`
}

type VariantValuesDeleteRequest struct {
	ID int `json:"id"`
}

type VariantValuesDeleteResponse struct {
	VariantValue VariantValues `json:"variantValue"`
}

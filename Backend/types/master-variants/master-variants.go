package master_variants

import "time"

type MasterVariants struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Type      string    `json:"type"` // optional: string, hex, number
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

type MasterVariantsStore interface {
	GetMasterVariants() ([]MasterVariants, error)
	CreateMasterVariant(masterVariant *MasterVariants) (*MasterVariants, error)
	UpdateMasterVariant(masterVariant *MasterVariants) error
	DeleteMasterVariant(id int) error
}

type GetMasterVariantsResponse struct {
	MasterVariants []MasterVariants `json:"masterVariants"`
}

type MasterVariantsCreateRequest struct {
	Name string `json:"name"`
	Type string `json:"type"`
}

type MasterVariantsCreateResponse struct {
	MasterVariant MasterVariants `json:"masterVariant"`
}

type MasterVariantsUpdateRequest struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Type string `json:"type"`
}

type MasterVariantsUpdateResponse struct {
	MasterVariant MasterVariants `json:"masterVariant"`
}

type MasterVariantsDeleteRequest struct {
	ID int `json:"id"`
}

type MasterVariantsDeleteResponse struct {
	MasterVariant MasterVariants `json:"masterVariant"`
}

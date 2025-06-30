package supabase

import (
	"log"
	"mime/multipart"

	"github.com/Asif-Faizal/Versace/config"
	storage_go "github.com/supabase-community/storage-go"
)

type SupabaseService struct {
	client *storage_go.Client
}

func NewSupabaseService(cfg *config.Config) *SupabaseService {
	log.Printf("Initializing Supabase client with URL: %s", cfg.SupabaseURL)
	log.Printf("Initializing Supabase client with Key: %s", cfg.SupabaseKey)
	client := storage_go.NewClient(cfg.SupabaseURL, cfg.SupabaseKey, nil)
	return &SupabaseService{
		client: client,
	}
}

func (s *SupabaseService) UploadFile(bucketName string, fileName string, file multipart.File, options storage_go.FileOptions) (string, error) {
	_, err := s.client.UploadFile(bucketName, fileName, file, options)
	if err != nil {
		return "", err
	}

	res := s.client.GetPublicUrl(bucketName, fileName)
	return res.SignedURL, nil
}

package supabase

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"mime/multipart"
	"net/url"
	"path"
	"path/filepath"
	"time"

	"github.com/Asif-Faizal/Versace/config"
	supabasestorage "github.com/supabase-community/storage-go"
)

type SupabaseService struct {
	client *supabasestorage.Client
}

func NewSupabaseService(cfg *config.Config) *SupabaseService {
	log.Printf("Initializing Supabase client with URL: %s", cfg.SupabaseURL)
	log.Printf("Initializing Supabase client with Key: %s", cfg.SupabaseKey)
	storageClient := supabasestorage.NewClient(cfg.SupabaseURL, cfg.SupabaseKey, nil)
	return &SupabaseService{
		client: storageClient,
	}
}

func (s *SupabaseService) UploadFile(file *multipart.FileHeader, bucketName string) (string, error) {
	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()

	fileBytes, err := io.ReadAll(src)
	if err != nil {
		return "", err
	}
	ext := filepath.Ext(file.Filename)
	name := file.Filename[0 : len(file.Filename)-len(ext)]
	fileName := fmt.Sprintf("%s_%d%s", name, time.Now().Unix(), ext)

	contentType := "image/jpeg"
	_, err = s.client.UploadFile(bucketName, fileName, bytes.NewReader(fileBytes), supabasestorage.FileOptions{
		ContentType: &contentType,
	})
	if err != nil {
		return "", err
	}

	res := s.client.GetPublicUrl(bucketName, fileName, supabasestorage.UrlOptions{
		Download: false,
	})

	return res.SignedURL, nil
}

func (s *SupabaseService) DeleteFile(bucketName string, filePath string) error {
	_, err := s.client.RemoveFile(bucketName, []string{filePath})
	return err
}

func GetFileNameFromURL(fileURL string) (string, error) {
	u, err := url.Parse(fileURL)
	if err != nil {
		return "", err
	}
	return path.Base(u.Path), nil
}

package subcategory

import (
	"encoding/json"
	"fmt"
	"log"
	"mime/multipart"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/types/subcategory"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/xuri/excelize/v2"
)

func (h *Handler) handleBulkCreateSubcategory(w http.ResponseWriter, r *http.Request) {
	err := r.ParseMultipartForm(10 << 20) // 10 MB
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "failed to parse multipart form", err.Error())
		return
	}

	file, _, err := r.FormFile("sheet")
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "excel sheet is required", err.Error())
		return
	}
	defer file.Close()

	excelFile, err := excelize.OpenReader(file)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "failed to read excel file", err.Error())
		return
	}

	rows, err := excelFile.GetRows("Sheet1")
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "failed to get rows from excel sheet", err.Error())
		return
	}

	formFiles := r.MultipartForm.File["images"]
	if len(formFiles) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "at least one image is required", "")
		return
	}

	filesMap := make(map[string]*multipart.FileHeader)
	for _, fh := range formFiles {
		filesMap[fh.Filename] = fh
	}

	var subcategoriesToCreate []*subcategory.Subcategory
	imageURLMap := make(map[string]string) // To store uploaded image URLs

	for i, row := range rows {
		if i == 0 { // Skip header row
			continue
		}
		if len(row) < 4 {
			log.Printf("skipping row %d, not enough columns", i+1)
			continue
		}
		subcategoryName := row[0]
		subcategoryDesc := row[1]
		imageFileName := row[2]
		categoryIDStr := row[3]

		categoryID, err := strconv.Atoi(categoryIDStr)
		if err != nil {
			log.Printf("invalid category ID '%s' on row %d, skipping", categoryIDStr, i+1)
			continue
		}

		imageFileHeader, ok := filesMap[imageFileName]
		if !ok {
			log.Printf("image %s for subcategory %s not found in uploaded files, skipping", imageFileName, subcategoryName)
			continue
		}

		imageURL, uploaded := imageURLMap[imageFileName]
		if !uploaded {
			var err error
			imageURL, err = h.supabaseService.UploadFile(imageFileHeader, "images")
			if err != nil {
				log.Printf("failed to upload image %s for subcategory %s: %v, skipping", imageFileName, subcategoryName, err)
				continue
			}
			imageURLMap[imageFileName] = imageURL
		}

		subcategoriesToCreate = append(subcategoriesToCreate, &subcategory.Subcategory{
			Name:        subcategoryName,
			Description: subcategoryDesc,
			ImageURL:    imageURL,
			CategoryID:  categoryID,
		})
	}

	if len(subcategoriesToCreate) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "no subcategories to create", "please check excel file and images")
		return
	}

	err = h.store.BulkCreateSubcategory(subcategoriesToCreate)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "failed to create subcategories", err.Error())
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"message": fmt.Sprintf("%d subcategories created successfully", len(subcategoriesToCreate))})
}

package subcategory

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strconv"
	"strings"

	"github.com/Asif-Faizal/Versace/types/subcategory"
	"github.com/Asif-Faizal/Versace/utils"
)

// handleBulkCreateSubcategory expects multipart/form-data with repeated, indexed fields:
// name[i], description[i], categoryId[i], image[i]
// Also supports underscore style: name_i, description_i, categoryId_i, image_i
func (h *Handler) handleBulkCreateSubcategory(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseMultipartForm(100 << 20); err != nil { // 100MB
		utils.WriteError(w, http.StatusBadRequest, "failed to parse multipart form")
		return
	}

	// Discover row indexes from present keys
	indexSet := map[int]struct{}{}
	reBracket := regexp.MustCompile(`^(name|description|categoryId|image)\[(\d+)\]$`)
	reUnderscore := regexp.MustCompile(`^(name|description|categoryId|image)_(\d+)$`)
	for key := range r.MultipartForm.Value {
		if m := reBracket.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
			continue
		}
		if m := reUnderscore.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
		}
	}
	for key := range r.MultipartForm.File {
		if m := reBracket.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
			continue
		}
		if m := reUnderscore.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
		}
	}

	// helpers
	getVal := func(bracketKey, underscoreKey string) string {
		if v, ok := r.MultipartForm.Value[bracketKey]; ok && len(v) > 0 {
			return strings.TrimSpace(v[0])
		}
		if v, ok := r.MultipartForm.Value[underscoreKey]; ok && len(v) > 0 {
			return strings.TrimSpace(v[0])
		}
		return ""
	}

	var toCreate []*subcategory.Subcategory

	for idx := range indexSet {
		name := getVal(fmt.Sprintf("name[%d]", idx), fmt.Sprintf("name_%d", idx))
		desc := getVal(fmt.Sprintf("description[%d]", idx), fmt.Sprintf("description_%d", idx))
		catStr := getVal(fmt.Sprintf("categoryId[%d]", idx), fmt.Sprintf("categoryId_%d", idx))
		if name == "" || catStr == "" {
			continue
		}
		categoryID, err := strconv.Atoi(catStr)
		if err != nil {
			continue
		}

		// Validate that category exists
		_, err = h.categoryStore.GetCategoryByID(categoryID)
		if err != nil {
			log.Printf("bulk subcategory: category %d not found: %v", categoryID, err)
			continue
		}

		// Resolve image
		var fhKey string
		if _, ok := r.MultipartForm.File[fmt.Sprintf("image[%d]", idx)]; ok {
			fhKey = fmt.Sprintf("image[%d]", idx)
		} else if _, ok := r.MultipartForm.File[fmt.Sprintf("image_%d", idx)]; ok {
			fhKey = fmt.Sprintf("image_%d", idx)
		}

		var imageURL string
		if fhKey != "" {
			fhs := r.MultipartForm.File[fhKey]
			if len(fhs) > 0 {
				url, err := h.supabaseService.UploadFile(fhs[0], "images")
				if err == nil {
					imageURL = url
				} else {
					log.Printf("bulk subcategory: upload failed for index %d key %s: %v", idx, fhKey, err)
				}
			}
		}
		if imageURL == "" {
			if arr, ok := r.MultipartForm.File["images"]; ok && len(arr) > 0 {
				if idx >= 0 && idx < len(arr) {
					if url, err := h.supabaseService.UploadFile(arr[idx], "images"); err == nil {
						imageURL = url
					} else {
						log.Printf("bulk subcategory: upload failed from images[] for index %d: %v", idx, err)
					}
				}
			}
		}
		if imageURL == "" {
			log.Printf("bulk subcategory: missing image for index %d (no image[i] or images[] match)", idx)
			continue
		}

		toCreate = append(toCreate, &subcategory.Subcategory{
			Name:        name,
			Description: desc,
			ImageURL:    imageURL,
			CategoryID:  categoryID,
		})
	}

	if len(toCreate) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "no subcategories to create")
		return
	}

	if err := h.store.BulkCreateSubcategory(toCreate); err != nil {
		log.Printf("bulk subcategory creation error: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, fmt.Sprintf("failed to create subcategories: %v", err))
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]int{"created": len(toCreate)})
}

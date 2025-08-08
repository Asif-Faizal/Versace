package product

import (
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"
	"strconv"
	"strings"

	"github.com/Asif-Faizal/Versace/types/product"
	"github.com/Asif-Faizal/Versace/utils"
)

// handleBulkCreateProduct expects multipart/form-data with repeated, indexed fields:
// name[i], description[i], basePrice[i], image[i]
// Also supports underscore style: name_i, description_i, basePrice_i, image_i
func (h *Handler) handleBulkCreateProduct(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseMultipartForm(200 << 20); err != nil { // 200MB
		utils.WriteError(w, http.StatusBadRequest, "failed to parse multipart form")
		return
	}

	indexSet := map[int]struct{}{}
	reBracket := regexp.MustCompile(`^(name|description|basePrice|image)\[(\d+)\]$`)
	reUnderscore := regexp.MustCompile(`^(name|description|basePrice|image)_(\d+)$`)
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
		}
		if m := reUnderscore.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
		}
	}

	getVal := func(bracketKey, underscoreKey string) string {
		if v, ok := r.MultipartForm.Value[bracketKey]; ok && len(v) > 0 {
			return strings.TrimSpace(v[0])
		}
		if v, ok := r.MultipartForm.Value[underscoreKey]; ok && len(v) > 0 {
			return strings.TrimSpace(v[0])
		}
		return ""
	}

	var toCreate []*product.Product

	for idx := range indexSet {
		name := getVal(fmt.Sprintf("name[%d]", idx), fmt.Sprintf("name_%d", idx))
		desc := getVal(fmt.Sprintf("description[%d]", idx), fmt.Sprintf("description_%d", idx))
		priceStr := getVal(fmt.Sprintf("basePrice[%d]", idx), fmt.Sprintf("basePrice_%d", idx))
		if name == "" || priceStr == "" {
			continue
		}
		basePrice, err := strconv.ParseFloat(priceStr, 64)
		if err != nil {
			continue
		}

		// image
		var fhKey string
		if _, ok := r.MultipartForm.File[fmt.Sprintf("image[%d]", idx)]; ok {
			fhKey = fmt.Sprintf("image[%d]", idx)
		}
		if fhKey == "" {
			if _, ok := r.MultipartForm.File[fmt.Sprintf("image_%d", idx)]; ok {
				fhKey = fmt.Sprintf("image_%d", idx)
			}
		}

		var imageURL string
		if fhKey != "" {
			fhs := r.MultipartForm.File[fhKey]
			if len(fhs) > 0 {
				if url, err := h.supabaseService.UploadFile(fhs[0], "images"); err == nil {
					imageURL = url
				}
			}
		}
		if imageURL == "" {
			if arr, ok := r.MultipartForm.File["images"]; ok && len(arr) > 0 {
				if idx >= 0 && idx < len(arr) {
					if url, err := h.supabaseService.UploadFile(arr[idx], "images"); err == nil {
						imageURL = url
					}
				}
			}
		}
		if imageURL == "" {
			continue
		}

		toCreate = append(toCreate, &product.Product{
			Name:         name,
			Description:  desc,
			BasePrice:    basePrice,
			MainImageURL: imageURL,
		})
	}

	if len(toCreate) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "no products to create")
		return
	}

	if err := h.store.BulkCreateProduct(toCreate); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "failed to create products")
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]int{"created": len(toCreate)})
}

build:
	@go build -o bin/versace cmd/main.go

test:
	@go test -v ./...

run:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '^#' | xargs) && go run cmd/main.go; \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

# Migration commands
migration-create:
	@migrate create -ext sql -dir cmd/migration/sql -seq $(filter-out $@,$(MAKECMDGOALS))

migrate-up:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '^#' | xargs) && go run cmd/migration/main.go up; \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

migrate-down:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '^#' | xargs) && go run cmd/migration/main.go down; \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

migrate-drop:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '^#' | xargs) && go run cmd/migration/main.go drop; \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

migrate-reset:
	@if [ -f .env ]; then \
		echo "Resetting migrations..." && \
		export $$(cat .env | grep -v '^#' | xargs) && \
		go run cmd/migration/main.go drop && \
		go run cmd/migration/main.go up && \
		echo "Migrations reset successfully."; \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

# Force migration version (fix dirty state)
# Usage: make migrate-force version=1
migrate-force:
	@if [ -z "$(version)" ]; then \
		echo "Error: Please provide a version, e.g., make migrate-force version=1"; \
		exit 1; \
	fi
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '^#' | xargs) && go run cmd/migration/main.go force $(version); \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

# Allow passing arguments to migration-create
%:
	@:
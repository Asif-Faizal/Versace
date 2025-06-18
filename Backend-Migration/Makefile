build:
	@go build -o bin/gommerce cmd/main.go

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

# Allow passing arguments to migration-create
%:
	@:
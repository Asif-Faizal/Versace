package main

import (
	"log"
	"os"

	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/db"
	mysqldriver "github.com/go-sql-driver/mysql"
	migrate "github.com/golang-migrate/migrate/v4"
	mysqlmigrate "github.com/golang-migrate/migrate/v4/database/mysql"
	_ "github.com/golang-migrate/migrate/v4/source/file"
)

func main() {
	log.Println("Migrating database...")
	cfg, err := config.InitConfig()
	if err != nil {
		log.Fatal(err)
	}

	db, err := db.NewDB(mysqldriver.Config{
		User:                 cfg.DBUser,
		Passwd:               cfg.DBPassword,
		Net:                  "tcp",
		Addr:                 cfg.DBAddress,
		DBName:               cfg.DBName,
		AllowNativePasswords: true,
		ParseTime:            true,
	})
	if err != nil {
		log.Fatal(err)
	}

	driver, err := mysqlmigrate.WithInstance(db, &mysqlmigrate.Config{})
	if err != nil {
		log.Fatal(err)
	}

	// Create new migration instance
	m, err := migrate.NewWithDatabaseInstance("file://cmd/migration/sql", "mysql", driver)
	if err != nil {
		log.Fatal(err)
	}

	cdm := os.Args[(len(os.Args) - 1)]
	if cdm == "up" {
		if err := m.Up(); err != nil && err != migrate.ErrNoChange {
			log.Fatal(err)
		}
	} else if cdm == "down" {
		if err := m.Down(); err != nil && err != migrate.ErrNoChange {
			log.Fatal(err)
		}
	}
}

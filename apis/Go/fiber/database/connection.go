package database

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	// DBConn is a pointer to gorm.DB
	DBConn             *gorm.DB
	user               = os.Getenv("DB_USER")
	password           = os.Getenv("DB_PASSWORD")
	host               = os.Getenv("DB_HOST")
	db                 = os.Getenv("DB_NAME")
	port               = os.Getenv("DB_PORT")
	maxConnections     = os.Getenv("DB_MAX_CONNECTIONS")
	maxIdleConnections = os.Getenv("DB_MAX_IDLE_CONNECTIONS")
)

func Connect() (err error) {

	port, err := strconv.Atoi(port)
	if err != nil {
		return err
	}

	dsn := fmt.Sprintf("user=%s password=%s host=%s dbname=%s port=%d sslmode=disable", user, password, host, db, port)
	DBConn, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return err
	}

	sqlDB, err := DBConn.DB()
	maxIdle, err := strconv.Atoi(maxIdleConnections)
	maxDBCon, err := strconv.Atoi(maxConnections)
	sqlDB.SetMaxIdleConns(maxIdle)
	sqlDB.SetMaxOpenConns(maxDBCon)
	sqlDB.SetConnMaxLifetime(time.Minute * 5)

	return nil
}

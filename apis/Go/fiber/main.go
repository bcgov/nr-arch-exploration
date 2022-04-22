package main

import (
	"bytes"
	"fmt"
	"github.com/devfeel/mapper"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/csrf"
	"github.com/gofiber/fiber/v2/middleware/favicon"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/gofiber/helmet/v2"
	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/iit-arch/fiber-crud/database"
	"github.com/iit-arch/fiber-crud/v1/routes"
	"github.com/iit-arch/fiber-crud/v1/structs"
	"github.com/joho/godotenv"
	"log"
	"os"
	"strconv"
)

var (
	buf    bytes.Buffer
	sysLog = log.New(&buf, "log: ", log.Lshortfile)
)

func init() {
	_ = mapper.Register(&structs.Employee{})
	_ = mapper.Register(&structs.EmployeeModel{})
}
func main() {
	const dbVersion = 1 // please update this line when new version of db is created
	_ = godotenv.Load()
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	host := os.Getenv("DB_HOST")
	db := os.Getenv("DB_NAME")
	port, _ := strconv.Atoi(os.Getenv("DB_PORT"))
	dsn := fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable", user, password, host, port, db)
	m, err := migrate.New(
		"file://database/migrations",
		dsn)
	if err != nil {
		log.Fatalf("error is %v", err)
	}
	currentVer, _, _ := m.Version()
	if currentVer < dbVersion {
		if err := m.Up(); err != nil {
			log.Fatalf("error from migrate is %v", err)
		}
	}
	dbErr := database.Connect()
	if dbErr != nil {
		err := fmt.Errorf("error: %v", dbErr)
		fmt.Println(err.Error())
		sysLog.Fatalf("Error: %v", dbErr)
	}
	app := fiber.New(fiber.Config{})
	app.Use(favicon.New())
	app.Use(recover.New())
	app.Use(cors.New())
	app.Use(csrf.New())
	app.Use(helmet.New())
	app.Use(logger.New(logger.Config{
		TimeFormat: "2006-01-02T15:04:05",
		TimeZone:   "America/Vancouver",
	}))
	app.Get("/health", HealthCheck)
	routes.EmployeeRoutes(app)
	// 404 Handler, the last handler to be executed
	app.Use(func(c *fiber.Ctx) error {
		return c.SendStatus(404) // => 404 "Not Found"
	})
	err = app.Listen(":3000")
	if err != nil {
		sysLog.Fatalf("Error: %v", err)
		return
	}
}

// HealthCheck /**
// * @api {get} /health Health Check
func HealthCheck(c *fiber.Ctx) error {
	sqlDB, err := database.DBConn.DB()
	err = sqlDB.Ping()
	if err != nil {
		sysLog.Printf("Error: %v", err)
		return c.Status(500).SendString("Database connection error")
	}
	res := map[string]interface{}{
		"server": "Running",
		"db":     "Running",
	}
	if err := c.JSON(res); err != nil {
		return err
	}
	return nil
}

package main

import (
	"bytes"
	"fmt"
	"github.com/devfeel/mapper"
	fiber "github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/csrf"
	"github.com/gofiber/fiber/v2/middleware/favicon"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	helmet "github.com/gofiber/helmet/v2"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/joho/godotenv"
	"github.com/nr-arch-templates/fiber-crud/src/database"
	"github.com/nr-arch-templates/fiber-crud/src/v1/routes"
	"github.com/nr-arch-templates/fiber-crud/src/v1/structs"
	"log"
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
	_ = godotenv.Load()
	dbErr := database.Connect()
	if dbErr != nil {
		err := fmt.Errorf("error: %v", dbErr)
		fmt.Println(err.Error())
		sysLog.Fatalf("Error: %v", dbErr)
	}
	app := fiber.New(fiber.Config{})
	app.Use(helmet.New())
	app.Use(favicon.New())
	app.Use(recover.New())
	app.Use(cors.New())
	app.Use(csrf.New())

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
	err := app.Listen(":3000")
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

package routes

import "github.com/gofiber/fiber/v2"

func employeeRoutes(app fiber.Router) {
	r := app.Group("/api/v1")
	r.Get("/employees", GetEmployees)
	r.Get("/employees/:id", GetEmployee)
	r.Post("/employees", PostEmployee)
	r.Put("/employees/:id", PutEmployee)
	r.Delete("/employees/:id", DeleteEmployee)
}

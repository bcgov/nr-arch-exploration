package services

import (
	"errors"
	"github.com/devfeel/mapper"
	"github.com/gofiber/fiber/v2"
	"github.com/iit-arch/fiber-crud/database"
	"github.com/iit-arch/fiber-crud/v1/structs"
	"gorm.io/gorm"
)

func FindEmployee(dest interface{}, conditions ...interface{}) *gorm.DB {
	return database.DBConn.Model(&structs.EmployeeModel{}).Take(dest, conditions...)
}

func GetEmployees(c *fiber.Ctx) error {

	d := &[]structs.EmployeeModel{}

	err := database.DBConn.Find(&d).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return c.Status(200).JSON(make([]structs.Employee, 0))
	} else if err != nil {
		return c.Status(500).JSON(err)
	}
	var employees []structs.Employee
	for _, element := range *d {
		var emp = new(structs.Employee)
		_ = mapper.AutoMapper(&element, emp)
		employees = append(employees, *emp)
	}

	if err != nil {
		return c.SendStatus(500)
	}
	return c.JSON(employees)
}

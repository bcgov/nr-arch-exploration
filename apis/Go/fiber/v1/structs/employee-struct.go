package structs

import (
	"github.com/gofrs/uuid"
	"time"
)

type Employee struct {
	EmployeeID uuid.UUID `json:"employeeId"`
	FirstName  string    `json:"firstName"`
	LastName   string    `json:"lastName"`
	Email      string    `json:"email"`
	Phone      string    `json:"phone"`
	HireDate   time.Time `json:"hireDate"`
	Salary     float64   `json:"salary"`
}

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
type Tabler interface {
	TableName() string
}

// TableName overrides the table name used by User to `profiles`
func (EmployeeModel) TableName() string {
	return "employee"
}

type EmployeeModel struct {
	EmployeeID uuid.UUID `gorm:"not null" gorm:"PrimaryKey"`
	FirstName  string    `gorm:"not null"`
	LastName   string    `gorm:"not null"`
	Email      string    `gorm:"not null"`
	Phone      string    `gorm:"not null"`
	HireDate   time.Time `gorm:"not null"`
	Salary     float64   `gorm:"not null"`
}

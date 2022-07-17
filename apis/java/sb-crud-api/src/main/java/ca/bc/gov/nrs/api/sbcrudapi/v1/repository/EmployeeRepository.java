package ca.bc.gov.nrs.api.sbcrudapi.v1.repository;

import ca.bc.gov.nrs.api.sbcrudapi.v1.model.EmployeeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface EmployeeRepository extends JpaRepository<EmployeeEntity, UUID> {
}

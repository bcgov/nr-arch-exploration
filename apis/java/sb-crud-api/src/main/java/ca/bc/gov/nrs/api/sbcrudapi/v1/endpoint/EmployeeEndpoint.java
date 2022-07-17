package ca.bc.gov.nrs.api.sbcrudapi.v1.endpoint;

import ca.bc.gov.nrs.api.sbcrudapi.v1.model.EmployeeEntity;
import ca.bc.gov.nrs.api.sbcrudapi.v1.repository.EmployeeRepository;
import lombok.val;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.websocket.server.PathParam;
import java.net.URI;
import java.util.Optional;
import java.util.UUID;

@RequestMapping(value = "/api/v1/employee", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class EmployeeEndpoint {

  private final EmployeeRepository repository;

  public EmployeeEndpoint(EmployeeRepository repository) {
    this.repository = repository;
  }

  @GetMapping("/{id}")
  @Transactional
  public ResponseEntity<EmployeeEntity> getEmployeeByID(@PathVariable("id") UUID id) {
    val entityOptional = repository.findById(id);
    if (entityOptional.isEmpty()) {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    } else {
      return ResponseEntity.ok(entityOptional.get());
    }
  }

  @PostMapping
  @Transactional
  public ResponseEntity<String> createEmployee(@Validated @RequestBody EmployeeEntity employeeEntity) {
    if (employeeEntity == null) {
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"message\":\" employee cannot be null in POST.\"}");
    }
    if (employeeEntity.getEmployeeId() != null) {
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"message\":\" employee Id is not allowed in POST.\"}");
    }
    repository.save(employeeEntity);
    return ResponseEntity.created(URI.create("/api/v1/employee/" + employeeEntity.getEmployeeId())).build();
  }

  @PutMapping("/{id}")
  @Transactional
  public ResponseEntity<?> updateEmployee(@PathVariable("id") UUID id, @Validated @RequestBody EmployeeEntity employeeEntity) {
    if (id == null || employeeEntity.getEmployeeId() == null || !id.equals(employeeEntity.getEmployeeId())) {
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"message\":\" employee Id can not be null in PUT.\"}");
    }
    Optional<EmployeeEntity> entityOptional = repository.findById(id);
    if (entityOptional.isEmpty()) {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
    EmployeeEntity entity = entityOptional.get();
    entity.setFirstName(employeeEntity.getFirstName());
    entity.setLastName(employeeEntity.getLastName());
    entity.setEmail(employeeEntity.getEmail());
    entity.setPhone(employeeEntity.getPhone());
    entity.setHireDate(employeeEntity.getHireDate());
    entity.setSalary(employeeEntity.getSalary());
    repository.save(entity);
    return ResponseEntity.ok(entity);
  }

  @DeleteMapping("/{id}")
  @Transactional
  public ResponseEntity<?> deleteEmployee(@PathVariable("id") UUID id) {
    if (id == null) {
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"message\":\" employee Id can not be null in Delete.\"}");
    }
    Optional<EmployeeEntity> entityOptional = repository.findById(id);
    if (entityOptional.isEmpty()) {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
    repository.delete(entityOptional.get());
    return ResponseEntity.noContent().build();
  }
}

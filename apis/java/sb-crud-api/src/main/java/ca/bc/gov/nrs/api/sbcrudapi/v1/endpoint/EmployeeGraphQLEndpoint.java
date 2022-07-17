package ca.bc.gov.nrs.api.sbcrudapi.v1.endpoint;


import ca.bc.gov.nrs.api.sbcrudapi.v1.model.EmployeeEntity;
import ca.bc.gov.nrs.api.sbcrudapi.v1.repository.EmployeeRepository;
import graphql.GraphQLException;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import javax.annotation.security.RolesAllowed;
import javax.transaction.Transactional;
import java.util.Optional;
import java.util.UUID;



@Controller
public class EmployeeGraphQLEndpoint {

  private final EmployeeRepository repository;


  public EmployeeGraphQLEndpoint(EmployeeRepository repository) {
    this.repository = repository;
  }

  @QueryMapping(name = "getEmployeeByID")
  public EmployeeEntity getEmployeeByID(@Argument("id") UUID id) {
    return repository.findById(id).orElseThrow();
  }

  @MutationMapping
  @Transactional
  public EmployeeEntity createEmployee(@Argument("employee") EmployeeEntity employeeEntity) throws GraphQLException {
    if (employeeEntity == null) {
      throw new GraphQLException("{\"message\":\" employee cannot be null in Create.\"}");
    }
    if (employeeEntity.getEmployeeId() != null) {
      throw new GraphQLException("{\"message\":\" employee Id is not allowed in Create.\"}");
    }
    repository.save(employeeEntity);
    return employeeEntity;
  }

  @MutationMapping
  @Transactional
  public EmployeeEntity updateEmployee(@Argument("employee") EmployeeEntity employeeEntity) throws GraphQLException {
    Optional<EmployeeEntity> entityOptional = repository.findById(employeeEntity.getEmployeeId());
    if (entityOptional.isEmpty()) {
      throw new GraphQLException("""
        {"message":" employee can not be found with ID %s."}
        """.formatted(employeeEntity.getEmployeeId()));
    }
    EmployeeEntity entity = entityOptional.get();
    entity.setFirstName(employeeEntity.getFirstName());
    entity.setLastName(employeeEntity.getLastName());
    entity.setEmail(employeeEntity.getEmail());
    entity.setPhone(employeeEntity.getPhone());
    entity.setHireDate(employeeEntity.getHireDate());
    entity.setSalary(employeeEntity.getSalary());
    repository.save(entity);
    return entity;
  }

  @MutationMapping
  @Transactional
  public Boolean deleteEmployee(@Argument("id") UUID id) throws GraphQLException {
    if (id == null) {
      throw new GraphQLException("{\"message\":\" employee Id can not be null in Delete.\"}");
    }
    Optional<EmployeeEntity> entityOptional = repository.findById(id);
    if (entityOptional.isEmpty()) {
      throw new GraphQLException("""
        {"message":" employee can not be found with ID %s."}
        """.formatted(id));
    }
    repository.delete(entityOptional.get());
    return true;
  }
}

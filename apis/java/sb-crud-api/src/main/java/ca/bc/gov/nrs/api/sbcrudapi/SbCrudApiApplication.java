package ca.bc.gov.nrs.api.sbcrudapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.DefaultSecurityFilterChain;

@SpringBootApplication
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SbCrudApiApplication {

  public static void main(String[] args) {
    SpringApplication.run(SbCrudApiApplication.class, args);
  }

  @Bean
  DefaultSecurityFilterChain securityFilterChain(final HttpSecurity http) throws Exception {
    http
      .authorizeRequests(requests -> {
          try {
            requests.antMatchers("/v3/api-docs/**",
              "/actuator/health", "/actuator/prometheus", "/actuator/**",
              "/swagger-ui/**", "/webjars/**").permitAll().anyRequest().authenticated().and().oauth2ResourceServer().jwt();
          } catch (Exception e) {
            throw new RuntimeException(e);
          }
        }
      );
    return http.build();
  }
}

# quarkus-oracle-example Project
This project uses Quarkus, the Supersonic Subatomic Java Framework.
If you want to learn more about Quarkus, please visit its website: https://quarkus.io/ .

## This project is a simple example of how to create Java API using Quarkus framework to specifically connect to Oracle Database over encrypted connection.
    
_This API does not show how to create roles or scopes in keycloak_ but the endpoints are secured with jwt token which validated against keycloak realm.

Following environment variables are required to run this Docker container:
1. DB_HOST --> The oracle DB hostname.
2. DB_PORT --> The oracle DB secured port.
3. FILE_LOG_LEVEL --> The log level for file logger.
4. OIDC_AUTH_SERVER_URL --> The keycloak auth server url against which the jwt token is validated.
5. QUARKUS_DATASOURCE_JDBC_PASSWORD --> The password for the oracle DB.
6. QUARKUS_DATASOURCE_JDBC_USERNAME --> The username for the oracle DB.
7. SERVICE_NAME --> The service name for Oracle DB.

### Sample Openshift deployment yaml file is available in .pipline/openshift/ 

## To Run this on local,
1. Please run `mvn clean package` first.
2. then run `docker build -t quarkus-oracle-example .`
3. then run `docker run -p 8000:8000 quarkus-oracle-example -e DB_HOST=localhost -e DB_PORT=1521 -e FILE_LOG_LEVEL=INFO -e OIDC_AUTH_SERVER_URL=http://localhost:8080 -e QUARKUS_DATASOURCE_JDBC_PASSWORD=password -e QUARKUS_DATASOURCE_JDBC_USERNAME=username -e SERVICE_NAME=service_name` after replacing the values with your own.


## Deployment to openshift
1. follow this link for artifactory knowledge https://developer.gov.bc.ca/Artifact-Repositories-(Artifactory),  it helps in understanding build and push of image to openshift.
2. Create secrets in GitHub
   1. This example repo has 3 secrets which are available for all deployments and then environment specific secrets are for each deployment.
      - `DOCKER_HUB_ACCESS_TOKEN`
      - `DOCKER_HUB_USERNAME`
      - `OPENSHIFT_SERVER`
   2. The quarkus-dev environment has secrets specific to this deployment.
      - `OPENSHIFT_TOKEN` The token to access openshift namespace where this will be deployed ex: `aaaaaa-dev`
      - `OIDC_AUTH_SERVER_URL` The URL of the Keycloak server
      - `NAMESPACE_NO_ENV` The namespace of the deployment ex: `aaaaaa`
3. Please refer to this file for sample openshift deployment. `.github/workflows/openshift-java-quarkus.yaml`
4. The image size produced is around 50 MB.
5. The application starts up within 2 seconds, with 50-150mc cpu and consumes around 35 Megs of memory.
6. The app consumes around .2mc cpu during idle time.

## To Run this in on local,
1. Please  run `docker-compose -f docker-compose-local.yaml up` command.
2. It will spin up 4 containers
   1. Application DB
   2. Keycloak
   3. Keycloak DB
   4. Migration Container (flyway)
   5. The API
3. login to KC admin console http://localhost:8192/auth/
4. click on admin console
5. sign-in with admin/admin
6. go to clients menu in left side-bar
7. click on create new client and then import, select the kc-local-client.json file present in this folder.
8. The App starts on port 7998.


## Deployment to openshift
1. follow this link for artifactory knowledge https://developer.gov.bc.ca/Artifact-Repositories-(Artifactory),  it helps in understanding build and push of image to openshift.
2. Create secrets in GitHub
    1. This example repo has 3 secrets which are available for all deployments and then environment specific secrets are for each deployment.
        - `DOCKER_HUB_ACCESS_TOKEN`
        - `DOCKER_HUB_USERNAME`
        - `OPENSHIFT_SERVER`
    2. The fiber-dev environment has secrets specific to this deployment.
        - `KC_JWKS_URL` The certs endpoint of Keycloak
        - `OPENSHIFT_TOKEN` The token to access openshift namespace where this will be deployed ex: `aaaaaa-dev`
        - `NAMESPACE_NO_ENV` The namespace of the deployment ex: `aaaaaa`
3. Please refer to this file for sample openshift deployment. `.github/workflows/openshift-go-fiber.yaml`
4. The image size produced is around 8 MB.
5. The application starts up within 4 seconds, with 50-150mc cpu and consumes around 18 Megs of memory.
6. The app consumes around 0.5-1 mc cpu during idle time.

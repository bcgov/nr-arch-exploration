# Metabase Version Upgrade
1. Go to https://github.com/bcgov/nr-arch-templates/issues and create a new issue by clicking on `New Issue` Button.
2. you will land on this page https://github.com/bcgov/nr-arch-templates/issues/new/choose . please click on the `Get Started` button beside `Update Metabase Image build and push`.
3. provide the title and the exact version of metabase starting with v, for example if you want to upgrade to `0.43.1` then please enter `v0.43.1`.
4. it automatically triggers an action, please visit this url https://github.com/bcgov/nr-arch-templates/actions/workflows/build-metabase-on-issue.yml to see the title appear and the job being run.
5. when the job is completed it will email to your email linked to GitHub Account.


## please make sure you switch to the proper namespace after logging in through the CLI. Execute the following command.
Login to openshift and then copy the login command.
Switch namespace after logging in, by issuing the following command. Please replace namespace-env with yours. If you are already on the namespace-env, you can ignore this step.
`oc project namespace-env`

Please execute the below command in powershell after replacing $VERSION with the actual version you requested upgrade for. Ex: if the version upgrade request was `v0.43.1` please change the value to that.
```markdown
  oc tag -d metabase:latest
  oc tag ghcr.io/bcgov/nr-arch-templates/metabase:$VERSION metabase:latest
  oc logs -f dc/metabase
```



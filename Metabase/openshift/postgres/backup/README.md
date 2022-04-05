This folder contains backup specific files related to postgres backup which supports metabase deployment on openshift.
This folder contains some files copied from this repository which needs modification.
https://github.com/BCDevOps/backup-container

## Actions cheat sheet
Navigate to the terminal of the backup-container pod.
### One off back up
`backup.sh -1`
### One off verification
`backup.sh -v all`
### Restore
First stop all services connecting to the db then run the following.
`backup.sh -r <host>/<db-name>`

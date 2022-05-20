#!/bin/sh
# ============================================================
# Databases:
# ------------------------------------------------------------
# List the databases you want backed up here.
# Databases will be backed up in the order they are listed.
#
# The entries must be in one of the following forms:
# - <Hostname/>/<DatabaseName/>
# - <Hostname/>:<Port/>/<DatabaseName/>
# - <DatabaseType>=<Hostname/>/<DatabaseName/>
# - <DatabaseType>=<Hostname/>:<Port/>/<DatabaseName/>
# <DatabaseType> can be postgres, mongo or mssql
# <DatabaseType> MUST be specified when you are sharing a
# single backup.conf file between postgres, mongo and mssql
# backup containers.  If you do not specify <DatabaseType>
# the listed databases are assumed to be valid for the
# backup container in which the configuration is mounted.
#
# Examples:
# - postgres=postgresql/my_database
# - postgres=postgresql:5432/my_database
# - mongo=mongodb/my_database
# - mongo=mongodb:27017/my_database
# - mssql=mssql_server:1433/my_database
# -----------------------------------------------------------
# Cron Scheduling:
# -----------------------------------------------------------
# List your backup and verification schedule(s) here as well.
# The schedule(s) must be listed as cron tabs that
# execute the script in 'scheduled' mode:
#   - ./backup.sh -s
#
# Examples (assuming system's TZ is set to PST):
# - 0 1 * * * default ./backup.sh -s
#   - Run a backup at 1am Pacific every day.
#
# - 0 4 * * * default ./backup.sh -s -v all
#   - Verify the most recent backups for all datbases
#     at 4am Pacific every day.
# -----------------------------------------------------------
# Full Example:
# -----------------------------------------------------------
# postgres=postgresql:5432/TheOrgBook_Database
# mongo=mender-mongodb:27017/useradm
# postgres=wallet-db/tob_issuer
# mssql=pims-db-dev:1433/pims
# mariadb=matomo-db:3306/matomo
#
# 0 1 * * * default ./backup.sh -s
# 0 4 * * * default ./backup.sh -s -v all
# ============================================================
BACKUP_CONF="postgres=metabase-postgres:5432/metabase-postgres

0 1 * * * default ./backup.sh -s
0 4 * * * default ./backup.sh -s -v all
"

oc create configmap backup-conf --from-literal=backup.conf="$BACKUP_CONF" | oc apply -f -
oc label configmap backup-conf app=backup-container

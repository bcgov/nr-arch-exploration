# This image provides a postgres installation from which to run backups
FROM centos/postgresql-12-centos7:20200917-804ef01

# Change timezone to PST for convenience
ENV TZ=PST8PDT

# Set the workdir to be root
WORKDIR /

# Load the backup scripts into the container (must be executable).
COPY Metabase/openshift/backup-container/backup.* /

COPY Metabase/openshift/backup-container/webhook-template.json /

# ========================================================================================================
# Install go-crond (from https://github.com/BCDevOps/go-crond)
#  - Adds some additional logging enhancements on top of the upstream project;
#    https://github.com/webdevops/go-crond
#
# CRON Jobs in OpenShift:
#  - https://blog.danman.eu/cron-jobs-in-openshift/
# --------------------------------------------------------------------------------------------------------
ARG SOURCE_REPO=BCDevOps
ARG GOCROND_VERSION=0.6.3
ADD https://github.com/$SOURCE_REPO/go-crond/releases/download/$GOCROND_VERSION/go-crond-64-linux /usr/bin/go-crond

USER root
RUN chmod 777 backup.* && chmod 777 webhook-template.json
RUN chmod +x /usr/bin/go-crond
# ========================================================================================================

# ========================================================================================================
# Perform operations that require root privilages here ...
# --------------------------------------------------------------------------------------------------------
RUN echo $TZ > /etc/timezone
# ========================================================================================================

# Important - Reset to the base image's user account.
USER 26

# Set the default CMD.
CMD sh /backup.sh

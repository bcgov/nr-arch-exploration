FROM dbeaver/cloudbeaver:latest
COPY dbeaver/cloudbeaver.conf /opt/cloudbeaver/conf
COPY dbeaver/startup.sh .
COPY dbeaver/InstallCert.class .
COPY "dbeaver/InstallCert\$SavingTrustManager.class" .
RUN chmod -R 777 /opt
EXPOSE 8978
EXPOSE 8000
ENTRYPOINT ["./startup.sh"]


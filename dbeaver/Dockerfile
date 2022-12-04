FROM dbeaver/cloudbeaver:latest
RUN echo "$JAVA_HOME"
COPY cloudbeaver.conf /opt/cloudbeaver/conf
COPY startup.sh .
COPY InstallCert.java .
RUN chmod -R 777 /opt
EXPOSE 8978
EXPOSE 8000
ENTRYPOINT ["./startup.sh"]


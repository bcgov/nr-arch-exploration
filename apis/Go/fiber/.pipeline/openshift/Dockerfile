FROM alpine:latest
RUN apk add --no-cache bash
RUN addgroup -S appgroup && adduser -S 1001 -G appgroup
USER 1001
COPY --chown=1001 /apis/Go/fiber/application .
EXPOSE 3000
ENTRYPOINT  ["./application"]

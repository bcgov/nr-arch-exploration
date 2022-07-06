FROM golang:1.18 AS build
WORKDIR /workspace/app
COPY . .
RUN go get -d -v .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -a -o application main.go


FROM alpine:3.11.3
ARG DEPENDENCY=/workspace/app
RUN apk add --no-cache bash
RUN addgroup -S appgroup && adduser -S 1001 -G appgroup
USER 1001
COPY --chown=1001 --from=build ${DEPENDENCY}/application .
EXPOSE 3000
ENTRYPOINT  ["./application"]

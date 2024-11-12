# Build Stage
FROM golang:1.23.3-alpine3.20 AS builder

WORKDIR /app

COPY . .

RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.18.1/migrate.linux-amd64.tar.gz | tar xvz

# Run Stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY start.sh .

# depends_on seems to wait for the service to be ready in new version
# There no need for wait-for.sh, I keep it here for learning purpose
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080

CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]

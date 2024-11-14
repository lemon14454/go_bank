# Build Stage
FROM golang:1.23.3-alpine3.20 AS builder

WORKDIR /app

COPY . .

RUN go build -o main main.go

# Run Stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .
COPY start.sh .

# depends_on seems to wait for the service to be ready in new version
# There no need for wait-for.sh, I keep it here for learning purpose
COPY wait-for.sh .
COPY db/migration ./db/migration

EXPOSE 8080

CMD [ "/app/main" ]
# don't need this entrypoint either, just to know a way to do things
ENTRYPOINT [ "/app/start.sh" ]

FROM golang:1.16.5-alpine3.14 AS builder

ENV GO111MODULE="off"

RUN apk update && apk add --no-cache git
RUN adduser -D -g '' appuser

WORKDIR /go/src/print
COPY src/print .

RUN go get -d -v ./...
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/print

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd

COPY --from=builder /go/bin/print /go/bin/print

USER appuser

# Run the hello binary.
ENTRYPOINT ["/go/bin/print"]
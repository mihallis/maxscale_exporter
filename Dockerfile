FROM golang:1.24 AS builder
WORKDIR /go/src/app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM busybox:uclibc@sha256:cc57e0ff4b6d3138931ff5c7180d18078813300e2508a25fb767a4d36df30d4d AS busybox

FROM gcr.io/distroless/base
COPY --from=builder /go/bin/app /go/bin/app
COPY --from=busybox /bin/ls /bin/ls
COPY --from=busybox /bin/sh /bin/sh
COPY --from=busybox /bin/ping /bin/ping
COPY --from=busybox /bin/stat /bin/stat
CMD ["/go/bin/app"]

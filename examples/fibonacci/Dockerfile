FROM golang:alpine
RUN apk add git
RUN go get github.com/prometheus/client_golang/prometheus/promhttp
ADD main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine
COPY --from=0 /go/app /app
EXPOSE 8080
ENTRYPOINT ["/app"]

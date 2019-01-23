FROM golang:alpine
ADD counter.go .
RUN go build counter.go

FROM scratch
COPY --from=0 /go/counter /counter
CMD ["/counter"]

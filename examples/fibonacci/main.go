package main

import (
    "fmt"
    "log"
    "net/http"
    "time"
    "strconv"

    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var started time.Time
var totalHits = promauto.NewCounter(prometheus.CounterOpts{
            Name: "fib_hits_total",
            Help: "The total number of requests hit",
    })
var total200 = promauto.NewCounter(prometheus.CounterOpts{
            Name: "fib_hits_200",
            Help: "The total number of successful requests",
    })
var total422 = promauto.NewCounter(prometheus.CounterOpts{
            Name: "fib_hits_422",
            Help: "The total number of invalid requests",
    })

func fib(n int) int {
    if n == 1 {
        return 0
    }

    if n == 2 {
        return 1
    }

    return fib(n-2) + fib(n-1)
}

func handler(w http.ResponseWriter, r *http.Request) {
    totalHits.Inc()
    q := r.URL.Query()

    var num int
    var err error

    n := q.Get("n")
    if n == "" {
        total422.Inc()
        log.Println("query param n not specified")
        w.WriteHeader(http.StatusUnprocessableEntity)
        return
    } else {
        num, err = strconv.Atoi(n)
        if err != nil {
            total422.Inc()
            log.Println("Query param not an integer", err)
            w.WriteHeader(http.StatusUnprocessableEntity)
            return
        }

        if num < 1 {
            total422.Inc()
            log.Println("Query param not an integer", err)
            w.WriteHeader(http.StatusUnprocessableEntity)
            return
        }
    }

    fibn := fib(num)
    total200.Inc()
    log.Printf("num=%d, fibn=%d\n", num, fibn)

    fmt.Fprintf(w, "%d\n", fibn)
}

func health(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("I am alive! :)\n"))
}

func life(w http.ResponseWriter, r *http.Request) {
    duration := time.Since(started)
    if duration.Seconds() > 10 {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte("I am born! Yay! :)\n"))
        return
    }
    w.WriteHeader(http.StatusInternalServerError)
    w.Write([]byte("On the way!\n"))
}

func main() {
    http.HandleFunc("/fibonacci", handler)
    http.HandleFunc("/health", health)
    http.HandleFunc("/life", life)
    http.Handle("/metrics", promhttp.Handler())

    log.Println("Starting the server...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

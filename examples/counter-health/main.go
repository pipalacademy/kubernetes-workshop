// Simple counter over http
//
// This dies when the count reaches 13.
// Useful to demonstrate logs and auto-healing of k8s.
package main

import (
    "encoding/json"
    "fmt"
    "log"
    "os"
    "net/http"
    "time"
)

type CountInfo struct {
    Hostname    string
    Pid         int
    Count       int
}

var Count = 0
var Healthy = true

func handler(w http.ResponseWriter, r *http.Request) {
    Count += 1
    if (Count == 13) {
        Healthy = false
    }

    hostname, err := os.Hostname()
    if err != nil {
        panic(err)
    }

    pid := os.Getpid()

    info := CountInfo{
        hostname,
        pid,
        Count,
    }

    infoJson, err := json.Marshal(info)
    if err != nil {
        log.Fatal("Cannot encode to JSON ", err)
    }


    log.Printf("Host=%s Pid=%d Count=%d\n", hostname, pid, Count)
    fmt.Fprintf(w, "%s\n", infoJson)
}

func health(w http.ResponseWriter, r *http.Request) {
    if (Healthy == false) {
        w.WriteHeader(http.StatusInternalServerError)
        w.Write([]byte("I am unhealthy! :(\n"))
        return
    }
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("I am healthy! :)\n"))
}

func liveliness(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("I am alive! :)\n"))
}

func init() {
    time.Sleep(5*time.Second)
}

func main() {
    http.HandleFunc("/", handler)
    http.HandleFunc("/health", health)
    http.HandleFunc("/liveliness", liveliness)
    log.Println("Starting the server...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

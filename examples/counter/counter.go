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
)

type CountInfo struct {
    Hostname    string
    Pid         int
    Count       int
}

var Count = 0;

func handler(w http.ResponseWriter, r *http.Request) {
    Count += 1
    if (Count == 13) {
        log.Fatal("I don't like 13. Quitting!")
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
    //fmt.Fprintf(w, "%s[%d] %d\n", hostname, pid, Count)
    fmt.Fprintf(w, "%s\n", infoJson)
}

func main() {
    http.HandleFunc("/", handler)
    log.Println("Starting the server...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

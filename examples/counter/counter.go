// Simple counter over http
//
// This dies when the count reaches 13. 
// Useful to demonstrate logs and auto-healing of k8s.
package main

import (
    "fmt"
    "log"
    "net/http"
)

var Count = 0;

func handler(w http.ResponseWriter, r *http.Request) {
	Count += 1
	if (Count == 13) {
		log.Fatal("I don't like 13. Quitting!")
	}

    log.Printf("Count=%d\n", Count)
    fmt.Fprintf(w, "%d\n", Count)    
}

func main() {
    http.HandleFunc("/", handler)
    log.Println("Starting the server...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

// Simple counter over http
//
// This dies when the count reaches 13. 
// Useful to demonstrate logs and auto-healing of k8s.
package main

import (
    "fmt"
    "os"
    "log"
    "io/ioutil"
    "net/http"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
    b, err := ioutil.ReadFile("index.html")
    if err != nil {
        log.Fatal(err)
    }
    str := string(b)
    fmt.Fprintf(w, "%s", str)
}

// Generates the javascript for js/config.js 
// by using the value of the env var GRAPHVIZ_API_ENDPOINT
func configHandler(w http.ResponseWriter, r *http.Request) {
    var url = getEnv("GRAPHVIZ_API_ENDPOINT", "http://localhost:8000/dot")
    fmt.Fprintf(w, "var GRAPHVIZ_API_ENDPOINT = \"%s\";", url);
}

func getEnv(key, fallback string) string {
    if value, ok := os.LookupEnv(key); ok {
        return value
    }
    return fallback
}

func main() {
    http.HandleFunc("/", indexHandler)
    http.HandleFunc("/js/config.js", configHandler)
    log.Println("Starting the server...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

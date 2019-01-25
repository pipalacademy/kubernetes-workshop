# Graphviz-web: Web Interface to Graphviz

The graphviz-web is a web interface to [Graphviz][], the open source graph visualization software. 

[Graphviz]: https://graphviz.org/

# How it run

Compile the go binary:

    go build web.go

Run the go server:

    ./web

Visit the website at:
 <http://localhost:8080/>

This webpage talks to the graphviz-api service and the endpoint of that defaults to `http://localhost:8000/dot`. If you are running it an environment where it is available at a different URL, you need to specify it as environment variable `GRAPHVIZ_API_ENDPOINT`.

For example, when running docker container:

	-e GRAPHVIZ_API_ENDPOINT=http://1.2.3.4:8000/dot
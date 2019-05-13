# graphviz-api

Graphviz is a command-line tool to render graphs written in DOT
language. The graphviz-api provides an API to render the graphs using an
HTTP request.

See <http://graphviz.org/> for more details about graphviz.

## Setup

Install Python dependencies using:

    $ pip install -r requirements.txt

Install graphviz using:

	$ apt-get update
	$ apt-get install -y graphviz  

# How to run

To run the server on port 8000:
    
    $ gunicorn -w 4 api:app -b 0.0.0.0:8000

## How to Use

Sample Usage:

    $ curl -d '{"input": "graph { A -- {B, C, D} -- {F} }"}' http://localhost:8000/dot
    {"data": "...base64-encoded-png-image..."}


## How to benchmark

There are some scripts provided in benchmark/ directory.

To benchmark:

    ./bench.sh

Run benchmark with 200 requests with a concurrency of 4.

    ./bench.sh -n 200 -c 4

You many need to install apache-bench (ab) for using it.

Install `ab` using:

	$ apt-get install -y apache2-utils


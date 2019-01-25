# graphviz-api

Graphviz is a command-line tool to render graphs written in DOT
language. The graphviz-api provides an API to render the graphs using an
HTTP request.

See <http://graphviz.org/> for more details about graphviz.

## Setup

Install Python dependencies using:

	$ pip install -r requirements.txt

# How to run

To run server on port 8000:

	$ python api.py

## How to Use

Sample Usage:

    $ curl -d '{"input": "graph { A -- {B, C, D} -- {F} }"}' http://localhost:8000/dot
    {"data": "...base64-encoded-png-image..."}

#! /bin/sh
set -x

POSTFILE=${POSTFILE:-sample2.txt}
URL=http://0.0.0.0:8000/dot

ab -T application/json -p $POSTFILE "$@" $URL

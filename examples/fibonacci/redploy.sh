#! /bin/bash

docker build -t palnabarun/fibonacci .
docker push palnabarun/fibonacci
kubectl delete po -l run=fibonacci

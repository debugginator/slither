#!/bin/bash

source /usr/local/bin/virtualenvwrapper.sh
workon slither-dev
FILES=./export/*
for f in $FILES
do
  echo "Processing $f file..."
#  touch ./results/$f.json
  fileName=${f:9:42}
#  echo ./results/$fileName.json
  slither --solc /usr/local/bin/solc --detect front-running $f --json ./results/$fileName.json
#  cat $f
done
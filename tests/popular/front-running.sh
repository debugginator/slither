#!/bin/bash

source /usr/local/bin/virtualenvwrapper.sh
workon slither-dev
FILES=./export/*
for f in $FILES
do
  echo "Processing $f file..."
  slither --solc /usr/local/bin/solc --detect front-running $f --json -
#  cat $f
done
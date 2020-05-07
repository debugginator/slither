#!/bin/bash

while read p; do
  echo "$p"
  crytic-compile "$p" --etherscan-apikey YOURKEY --export-zip export/"$p".zip
done < eth-most-used-addresses.csv

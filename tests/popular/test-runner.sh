#!/bin/bash

while read p; do
  echo "$p"
  crytic-compile "$p" --etherscan-apikey "UG5YEYAHDY8JR5B7Z9WBUW4ZP33IN4C6ZX" --export-zip export/"$p".zip || echo "not successfull"
done < eth-most-used-addresses.csv

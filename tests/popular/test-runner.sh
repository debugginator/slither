#!/bin/bash

while read p; do
  echo "$p"
  if crytic-compile "$p" --etherscan-apikey "UG5YEYAHDY8JR5B7Z9WBUW4ZP33IN4C6ZX" --export-zip export/"$p".zip
  then
    echo "successfull" # loop breaks here for unknown reason
    continue
  else
    echo "not successfull"
  fi
done < eth-most-used-addresses.csv
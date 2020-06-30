SELECT address
  FROM `bigquery-public-data.ethereum_blockchain.transactions` tx
  inner join `bigquery-public-data.ethereum_blockchain.contracts` contracts
  on tx.receipt_contract_address = contracts.address
  WHERE receipt_contract_address is not null and input!= "0x" and
  address in (select to_address from `bigquery-public-data.ethereum_blockchain.transactions` group by to_address HAVING count(to_address) > 100000)
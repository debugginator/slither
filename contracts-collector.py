import csv
import requests
import json

MY_ETHERSCAN_API_KEY = "UG5YEYAHDY8JR5B7Z9WBUW4ZP33IN4C6ZX"
ETHERSCAN_DOWNLOAD_API = "https://api.etherscan.io/api?module=contract&action=getsourcecode" \
                         "&apikey=YourApiKeyToken" \
                         "&address="
ETHERSCAN_VERIFIED_CONTRACTS_CSV_FILE = "export-verified-contractaddress-opensource-license.csv"


def download_contract_source_from_address(address):
    source_url = ETHERSCAN_DOWNLOAD_API + address
    r = requests.get(source_url)
    if r.status_code == 200:
        contract_metadata = json.loads(r.text)["result"][0]
        contract_name = contract_metadata["ContractName"]
        contract_source = contract_metadata["SourceCode"]
        compiler_version = contract_metadata["CompilerVersion"]
        if compiler_version < "v0.5.14":
            print("Compiler version ({}) for {} is to old. Skipping".format(contract_name, compiler_version))
            return False
        else:
            print("Saving contract source code to file {}.sol".format(contract_name))
            save_file_location = "contracts/{}.sol".format(contract_name)
            save_file = open(save_file_location, "w")
            save_file.write(contract_source)
            save_file.close()
            return True


with open(ETHERSCAN_VERIFIED_CONTRACTS_CSV_FILE) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    downloaded_count = 0
    for row in csv_reader:
        if line_count > 2:
            contractAddress = row[1]
            status = download_contract_source_from_address(contractAddress)
            downloaded_count += 1
        line_count += 1
    print(f'Downloaded {downloaded_count} out of {line_count} files')

from sys import argv
import os
import json

import logging

from slither.slither import Slither
from slither.exceptions import SlitherError
from slither.detectors.functions.front_running import FrontRunning

# Init logger
logging.basicConfig()
logger = logging.getLogger("Slither")
logger.setLevel(logging.INFO)

# Validate program arguments
if len(argv) != 2:
    print('Usage: python front_running_test_runner.py contractsDir/')
    exit(-1)

# Successfully analyzed contracts counter
contract_processed = 0

# Dictionary which counts vulnerabilities found on contracts by type
statistics = {
    "front-running": 0
}

directory = argv[1]
for filename in os.listdir(directory):
    if filename.endswith(".sol"):  # only run procedure on Solidity files
        filePath = os.path.join(directory, filename)
        logger.info("Analyzing file: " + filePath)

        try:  # in case of compiling errors just skip the contract (and don't count it as processed)
            # Load contracts from file
            slither = Slither(filePath)

            # Register detector
            slither.register_detector(FrontRunning)

            # Start detecting
            detector_results = slither.run_detectors()
            detector_results = [x for x in detector_results if x]  # remove empty results

            # Update contract count (here I can safely assume the contract is successfully processed
            contract_processed += len(slither.contracts)
            # Update vulnerabilities found to statistics dict
            for sublist in detector_results:
                for item in sublist:
                    detector = item["check"]
                    logger.info("Found vulnerability to: {}".format(detector))
                    statistics.update({detector: statistics[detector] + 1})

            detector_results = [item for sublist in detector_results for item in sublist]  # flatten

            # Skip writing to file if there are no vulnerabilities detected
            if len(detector_results) == 0:
                continue

            # make output pretty-printed
            jsonResult = json.dumps(detector_results, indent=2, sort_keys=True)
            outputFilePath = os.path.join(directory + "/results/", filename[:-4] + ".json")
            # now write output to a file
            jsonResultFile = open(outputFilePath, "w")
            jsonResultFile.write(jsonResult)
            jsonResultFile.close()

        except SlitherError:
            logger.error("Error parsing file {}, skipping.".format(filename))
            continue

    else:
        continue

# Print out the statistics
logger.info("Results for {} contracts".format(contract_processed))
for vulnerability in statistics:
    logger.info("Found {} cases vulnerable to {}".format(statistics[vulnerability], vulnerability))

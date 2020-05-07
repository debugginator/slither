from slither.detectors.abstract_detector import AbstractDetector, DetectorClassification
from slither.core.declarations import Function
from slither.analyses.data_dependency.data_dependency import is_tainted, is_dependent
from slither.core.declarations.solidity_variables import (SolidityFunction,
                                                          SolidityVariableComposed)
from slither.detectors.abstract_detector import (AbstractDetector,
                                                 DetectorClassification)
from slither.slithir.operations import (HighLevelCall, Index, LowLevelCall,
                                        Send, SolidityCall, Transfer)


# TODO check if state variables accessed are relevant to the sending
# 1. require or if statement wrapping the sending
# White flag transactions which do smth like require(msg.sender === anything) because only one address can withdraw
# Still red flag tx which have a check like if (calculatedHash == hashPuzzle)

# TODO check if contract implements submarine sends
# https://github.com/lorenzb/libsubmarine/blob/master/contracts/examples/erc721_auction/ERC721AuctionSubmarine.sol


# TODO check if external function called that prevents front running (dydx case)
# TODO check if Transaction Order Affects Ether Amount ??
class FrontRunning(AbstractDetector):
    """
    Detect functions vulnerable to front-running
    """

    ARGUMENT = 'front-running'  # launch only this detector with slither /path/to/contract/folder --detect front-running
    HELP = 'Function which send ether to the sender without accessing contract state'
    IMPACT = DetectorClassification.HIGH
    CONFIDENCE = DetectorClassification.LOW

    WIKI = 'https://github.com/trailofbits/slither/wiki/TODO'
    WIKI_TITLE = 'TODO'
    WIKI_DESCRIPTION = 'TODO'
    WIKI_EXPLOIT_SCENARIO = 'TODO'
    WIKI_RECOMMENDATION = 'TODO'

    @staticmethod
    def front_running(func):
        """
            Detect front running
        Args:
            func (Function)
        Returns:
            list(Node)
        """
        if func.is_protected() or len(func.state_variables_read) > 0:
            return []

        ret = []
        for node in func.nodes:
            for ir in node.irs:
                if isinstance(ir, (Transfer, Send)):
                    if ir.destination == SolidityVariableComposed('msg.sender'):
                        ret.append(node)

        return ret

    def detect_front_running(self, contract):
        """
            Detect front running
        Args:
            contract (Contract)
        Returns:
            list((Function), (list (Node)))
        """
        ret = []
        for f in [f for f in contract.functions if f.contract_declarer == contract]:
            # only functions declared by contract
            nodes = self.front_running(f)
            if nodes:
                ret.append((f, nodes))
        return ret

    def _detect(self):
        """
        Detector's entry point function
        """
        results = []

        for c in self.contracts:
            front_running = self.detect_front_running(c)
            for (func, nodes) in front_running:

                info = [func, " sends eth to sender without checking state\n"]
                info += ['\tDangerous calls:\n']
                for node in nodes:
                    info += ['\t\t- ', node, '\n']

                res = self.generate_result(info)

                results.append(res)

        return results

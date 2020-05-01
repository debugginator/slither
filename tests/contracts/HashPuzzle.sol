pragma solidity >=0.4.22 <0.7.0;
/**
 * @title Puzzle
 * @dev Solver of the hash puzzle gets the reward value in wei
 * @dev Contract vulnerable to loss of ether reward due to the front running attack
 *
 * @author Blaz Bagic
 */
contract HashPuzzle {
    // Solution: "Awesome puzzle solution!"
    bytes32 constant hashPuzzle = 0x97097f7e52aaa3df4003a9b83d3cb0cd7164a16c6c7763191b988d18a8de5f95;
    uint256 public reward;
    address public solver;
    string public solution;
    // events for EVM logging
    event WrongSolutionGiven(address indexed sender, string attemptedSolution, bytes32 calculatedHash, bytes32 solutionHash);
    event PuzzleSolved(address indexed sender, string solution, bytes32 solutionHashed);
    event RewardAlreadyCollected(address indexed sender, address indexed firstSolver);
    /**
     * The reward is set during contract deployment
     */
    constructor() public payable {
        reward = msg.value;
    }
    /**
     * Helper to update reward after deployment
     */
    function increaseReward() public payable {
        reward += msg.value;
    }
    /**
     * Function to submit the solution to the puzzle and reap the reward
     */
    function solve(string memory _solution) public {
        if (reward == 0) {
            emit RewardAlreadyCollected(msg.sender, solver);
            revert();
        }
        bytes32 calculatedHash = keccak256(abi.encodePacked(_solution));
        if (calculatedHash == hashPuzzle) {
            msg.sender.transfer(reward);
            emit PuzzleSolved(msg.sender, _solution, calculatedHash);
            solution = _solution;
            reward = 0;
            solver = msg.sender;
        } else {
            emit WrongSolutionGiven(msg.sender, _solution, calculatedHash, hashPuzzle);
            revert();
        }
    }
    /**
     * Deposit function to restart the puzzle
     */
    function resetPuzzle() payable public {
        reward = msg.value;
        solver = address(0);
        solution = "";
    }
}

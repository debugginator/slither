pragma solidity ^0.5.14;

contract UnrelatedStateTest {

    address public owner;
    uint8 public MAX_WITHDRAW_AMOUNT = 10;
    mapping (address => uint256) public balanceOf;

    constructor(address _owner) public {
        owner = _owner;
    }

    function unsafeWithdraw(uint amount) public{
        require(amount < MAX_WITHDRAW_AMOUNT);
        msg.sender.transfer(amount);
    }

    function safeWithdraw(uint amount) public{
        require(balanceOf[msg.sender] > amount);

        balanceOf[msg.sender] = balanceOf[msg.sender] - amount;
        msg.sender.transfer(amount);
    }
}

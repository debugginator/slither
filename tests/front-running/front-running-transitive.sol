pragma solidity ^0.5.14;

contract Test {

    bytes32 hashedData;

    constructor() public {
    }

    function unsafeWithdraw(uint amount) public {
        _unsafeWithdraw(amount);
    }

    function _unsafeWithdraw(uint amount) private {
        msg.sender.transfer(amount);
    }

    function unsafeWithdraw2(uint amount) public{
        return _unsafeWithdraw2(amount);
    }

    function _unsafeWithdraw2(uint amount) private{
        __unsafeWithdraw2(amount);
    }

    function __unsafeWithdraw2(uint amount) internal{
        msg.sender.transfer(amount);
    }
}

pragma solidity ^0.5.14;

contract Test {

    bytes32 hashedData;

    constructor() public {
    }

    function unsafeWithdraw(uint amount) public returns(bool){
        return _unsafeWithdraw(amount);
    }

    function _unsafeWithdraw(uint amount) private returns(bool){
        if (msg.sender.send(amount)) {
            return true;
        } else {
            revert();
        }
    }

    function unsafeWithdraw2(uint amount) public{
        return _unsafeWithdraw2(amount);
    }

    function _unsafeWithdraw2(uint amount) private{
        msg.sender.transfer(amount);
    }

    // below are legitimate calls
    // and should not be detected
    function commit(bytes32 hash) payable public {
        hashedData = hash;
    }

    function reveal(uint data, uint amount) public returns(bool){
        return _reveal(data, amount);
    }

    function _reveal(uint data, uint amount) public returns(bool){
        require(keccak256(abi.encodePacked(data)) == hashedData);
        if (msg.sender.send(amount)) {
            return true;
        } else {
            revert();
        }
    }

    function sendToPredefinedAddress(uint value) public{
        address(0x9446980D667FE43Cc537c120Fb16718771f3d882).transfer(value);
    }

}

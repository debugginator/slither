pragma solidity ^0.5.14;

contract Test {

    bytes32 hashedData;

    constructor() public {
    }

    function unsafeWithdraw(uint amount) public returns(bool){
        if (msg.sender.send(amount)) {
            return true;
        } else {
            revert();
        }
    }

function unsafeCollect(uint data) public returns(bool){
    bytes32 hash = 0xcea2260e17a842c8ccc2d71453ced6ba2f0dafcd71427251fca35de9198706bc;
    require(keccak256(abi.encodePacked(data)) == hash);
    if (msg.sender.send(address(this).balance)) {
        return true;
    } else {
        revert();
    }
}


    function unsafeWithdraw2(uint amount) public{
        msg.sender.transfer(amount);
    }

    // below are legitimate calls
    // and should not be detected
    function commit(bytes32 hash) payable public {
        hashedData = hash;
    }

    function reveal(uint data, uint amount) public returns(bool){
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

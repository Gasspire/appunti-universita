// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyPersonalContract{
    address owner;

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    modifier costs(uint price){
        require(msg.value > (price * 1 ether));
        _;
    }

    constructor(){
        owner = msg.sender;
    }
    
    function getMessage() public payable  onlyOwner costs(1) returns(string memory) {
        return "You good boy";
    }

}
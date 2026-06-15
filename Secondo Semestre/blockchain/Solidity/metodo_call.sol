// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Bersaglio{
    uint public i = 0;
    constructor()payable {

    }
    
    function myFunc()public returns(string memory){
        i++;
        return "Good Boy Mr. Contract :D";
    }
}

contract Caller{
    constructor()payable  {

    }
    function callFunc(address payable bers_addr)public payable returns(string memory){
        ( , bytes memory data ) = bers_addr.call{value: 1 ether}(abi.encodeWithSignature("myFunc()")); 
        return (abi.decode(data, (string)));
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Bersaglio{
    uint public i = 0;
    constructor()payable {

    }
    
    function myFunc()public payable returns(string memory){
        i++;
        return "Good Boy Mr. Contract :D";
    }
}

contract Caller{
    constructor()payable  {

    }
    function callFunc(address payable bers_addr)public payable returns(string memory){
        (bool success, bytes memory data ) = bers_addr.call{value: 1 ether, gas: 100000}(abi.encodeWithSignature("myFunc()")); 
        require(success, "La chiamata remota ha finito il gas o e fallita!");
        return (abi.decode(data, (string)));
    }
}
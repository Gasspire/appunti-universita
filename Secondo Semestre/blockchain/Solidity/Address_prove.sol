
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AddrContract{

    address Owner =0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    address myAddr = address(this);

    //Funzione che permette  di pagare un contratto
    receive() external payable{ 
    }


    //Il bilancio viene restituito solo se è l'owner del contratto, altrimenti fatti gli affari tua
    function getBalance() public view returns(uint){
        if(Owner == msg.sender) return address(this).balance;
        return 0;
    }
}
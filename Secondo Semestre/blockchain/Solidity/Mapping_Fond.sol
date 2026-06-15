// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract My_map_Contract{
    mapping(address => uint) bilanci;


    //non serve inizializzarlo perché è già a zero!
    function changeBalance(uint newBalance) public{
        bilanci[msg.sender] = newBalance;
    } 
    function getBalance()public view returns(uint){
        return bilanci[msg.sender];
    }

}
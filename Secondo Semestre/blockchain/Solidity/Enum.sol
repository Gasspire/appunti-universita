// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Enum_Test{
    enum Rice_Bowl {SMALL, MEDIUM, LARGE}

    Rice_Bowl myrice = Rice_Bowl.MEDIUM;

    function SetRice(Rice_Bowl n)public{
        myrice = n; //in questo caso n dovrà essere un intero tra 0 e 2 e non tipo SMALL ecc. 
    }

    function GetRice()public view returns(Rice_Bowl){
        return myrice; //ritorna un valore tra 0 e 2
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//Banalmente, le funzioni pure sono quelle che non modificano o leggono il world state
contract Test {
    //uint arr = 5;
    function getResult() public pure returns(uint product, uint sum){
        //uint a = arr; 
        uint a = 5;
        uint b = 2;
        product = a * b;
        sum = a + b; 
    }
}
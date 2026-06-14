// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringIf{
    string MyString = "Provolone";

    //Il confronto tra stringhe và fatto mediante uso di hash
    function testIf(string memory _string)public view  returns(string memory){
        if(keccak256(abi.encodePacked(MyString)) == keccak256(abi.encodePacked(_string))){
            return "Vero";
        }
        else return "Falso";
    }

    
}
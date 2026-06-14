// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringIf{
    string MyString = "Provolone";


    function testIf(string memory _string)public view  returns(string memory){
        if(keccak256(abi.encodePacked(MyString)) == keccak256(abi.encodePacked(_string))){
            return "Vero";
        }
        else return "Falso";
    }

    
}
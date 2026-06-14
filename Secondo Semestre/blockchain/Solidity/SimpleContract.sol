// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract SimpleContract{
    int public a = 50;
    int public b = 50;

    function set_a(int x) public {
        a = x;
    }
    
    function set_b(int y) public {
        b = y;
    }

    function add_ab() public view returns(int){
        return a+b;
    }

}
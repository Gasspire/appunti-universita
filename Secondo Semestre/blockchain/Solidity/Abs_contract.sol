// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. OGGI devi dichiarare esplicitamente che il contratto è astratto
abstract contract Calculator {
    // 2. Devi dire che questa funzione POTRÀ essere sovrascritta usando 'virtual'
    function getResult() public view virtual returns(uint);
}

contract Test is Calculator {
    // 3. Devi dichiarare esplicitamente che stai sovrascrindendo la funzione usando 'override'
    function getResult() public pure override returns(uint) {
        uint a = 1;
        uint b = 2;
        return a + b;
    }
}
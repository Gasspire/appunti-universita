// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MyContract{
    uint public dato = 50; // Variabile pubblica per cui viene generato getter automatico accessibile da chiunque
    uint internal intDato = 30; //Variabile accessibile solo all'interno del contratto o derivati (protected)
    uint private privDato = 10; //Variabile che può essere vista solo all'interno del contratto

  

}
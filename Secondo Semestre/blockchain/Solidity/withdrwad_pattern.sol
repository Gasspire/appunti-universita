// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Test {
   address payable public richest;
   uint public mostSent;


    mapping(address => uint) public rimborsiDaFare;

   constructor() payable {
      richest = payable(msg.sender);
      mostSent = msg.value;
   }

   function becomeRichest() public payable returns (bool) {
      if (msg.value > mostSent) {
         // Questa cosa non funziona poiché: Un hacker potrebbe creare un contratto senza la funzione receive e potrebbe chiamare questa funzione.
         // Una volta chiamata, il suo contratto divneta il nuovo Richest. Quando un utente prova a superarlo, non potendo accettare pagamenti il contratto dell'hacker, farà andare in transazione la richiesta.
        // Questo pattern è definito come "PUSH PAYMENT" cioè forza l'invio dei soldi ed è considerato insicuro in questo caso.
         richest.transfer(msg.value);
         richest = payable(msg.sender);
         mostSent = msg.value;
         return true;
      } else {
         return false;
      }
   }

    function safeBecomeRichest()public payable returns(bool){
        require(msg.value > mostSent,"Non hai inviato abbastanza Ether");
        if(richest != address(0)) rimborsiDaFare[msg.sender] += msg.value;

        richest = payable(msg.sender);
        mostSent = msg.value;
        return true;
    }

    function withdraw() public  returns(bool){
        uint rimborso = rimborsiDaFare[msg.sender];
        require(rimborso > 0, "Nessun rimborso da fare");
        
        //PRIMA DI FARE TUTTO AZZERIAMO IL RIMBORSO DA FARE
        rimborsiDaFare[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: rimborso}("");
        require(success, "Trasferimento fallito, si fa il revert!");
        return true;
    }   
}
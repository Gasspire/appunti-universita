// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VarType{
    uint myData; //Questa è una variabile di STATO, sarà salvata all'interno della memoria del contratto


    uint public dato = 50; // Variabile pubblica per cui viene generato getter automatico accessibile da chiunque
    uint internal intDato = 30; //Variabile accessibile solo all'interno del contratto o derivati (protected)
    uint private privDato = 10; //Variabile che può essere vista solo all'interno del contratto
    //Questa visibilità indica solo chi può chiamare le variabili ma chiunque può, dall'esterno, vederne il contenuto!




    constructor(uint _data){
        myData = _data;
    }

    function testData() public view returns(uint, uint){
        uint test = 5; //Questa è una variabile locale, non sarà possibile accedervi al di fuori della funzione 
        return (myData,test);
    }


    function blockNumber() public payable returns(uint,address){
        return (msg.value, msg.sender); 
        //Queste sono delle variabili GLOBALI che dipendono dallo stato globale della Blockchain o da quanto riportato nella transazione
    }

    //Esistono 3 locazioni: 
    //Storage (memoria interna e permanente, qui vanno le variabili di STATO)
    //Memory (memoria temporanea, è come lo heap in C. Qui si inseriscono i dati complessi come array e stringhe)
    //Calldata (memoria speciale dove vanno le variabili di input)
    //Stack (memoria temporanea dove vanno le variabili locali delle funzioni e i puntatori a memory)


}
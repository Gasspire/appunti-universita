// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MyContract{
    //I loop possibili sono i soliti: For, While, Do_While ecc.
    int public data = 10;

    function forloop(int n) public returns(int){
        for (int i = 0; i < n; i++) 
        {
            data += i;
        }
        return data;
    }

    //Visto che il Gas finisce, avremo un out of gas e, dunque verrà fatto un rollback di data e colui che fa la transazione perde tutto
    function forloop_erase(int n) public returns(int) {
        for (int i = 0; i < n; i++) {
            data += i;
            // TRUCCO: Se mancano meno di 5.000 unità di gas, 
            // entriamo in un loop infinito per bruciare tutto il gas rimanente!
            if (gasleft() < 5000) {
                while(true) {
                    // Questo loop vuoto consumerà tutto il gas della transazione
                }
            }
        }
        return data;
    }

}
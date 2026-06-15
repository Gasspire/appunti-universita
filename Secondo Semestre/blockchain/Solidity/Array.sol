// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Array_Contract{
    int[7] my_arr  = [int(0), 1, 2, 3, 4, 5, 6]; //Array di 7 interi 
    uint8[2][2] my_matrix = [[0,0],[1,1]]; //Array multi dimensionale 2 x 2 
    uint8[5][3] strange_matrix; //Array 3 x 5. Ricordiamo che in solidity la notazione significa: sto dichiarando 3 volte un uint[5]

    constructor(){
        for (int i = 0; i < 3; i++) 
        {
            for (int j = 0; j < 5; j++) 
            {
                strag
            };
        };
    }

    /*function getVal(uint n) public returns(int){
        for (int i = 0; i < 1000; i++) 
        {
            my_arr[uint(i%7)] += i%7;
        }
        if(n > 6 || n < 0) revert("Indice problematico");
        else return my_arr[n];
    }
    COMPORTAMENTO: Grazie al revert la transazione fallisce ma il gas in eccesso viene ritornato al proprietario
    */



}
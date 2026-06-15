// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Array_Contract{
    int[7]  my_arr  = [int(0), 1, 2, 3, 4, 5, 6]; //Array di 7 interi 
    uint8[2][2] my_matrix = [[0,0],[1,1]]; //Array multi dimensionale 2 x 2 
    uint[5][3] strange_matrix; //Array 3 x 5. Ricordiamo che in solidity la notazione significa: sto dichiarando 3 volte un uint[5]
    //Per strange matrix esiste strange_matrix[2][4] e NON strange_matrix[4][2]
    int[] dynam_arr;



    constructor(){
        for (uint i = 0; i < 3; i++) 
        {
            for (uint j = 0; j < 5; j++) 
            {
                strange_matrix[i][j] = i+j;
            }
        }
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

    function getVal(uint n) public view returns(int){
        return dynam_arr[n];
    }

    function get_Val_Strange(uint x, uint y) public view returns (uint){
        //if(x >3 || x < 0) revert("Errore, gli indici sono al contrario!");
        //else if(y > 5 || y < 0) revert("Errore, gli indici sono al contrario!");
        return strange_matrix[x][y]; 
    }

    function get_length()public view returns(uint){
        //return my_arr.length;//ritorna 7
        //return my_matrix.length; 
        //return strange_matrix.length;  //ritorna 3 cioè lo stato più esterno
        return strange_matrix[0].length; //ritorna 5
    }


    function push_data(int n)public returns(uint){
        dynam_arr.push(n);
        return dynam_arr.length-1;
    }

}
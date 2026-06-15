// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
    
    
struct Book{
    string nome;
    string autore;
    int anno;
}



contract Struct_Contract{
    Book NewBook;

    constructor (string memory n, string memory aut, int ann){
        NewBook.nome = n;
        NewBook.autore = aut;
        NewBook.anno = ann;
    }


    function get_Book()public view returns(string memory,string memory,int){
        return (NewBook.nome,NewBook.autore, NewBook.anno);
    }
}
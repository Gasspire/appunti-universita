// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Negozio {
    address public owner;
    
    // Mappatura temporanea per i prezzi dei prodotti (ID Prodotto => Prezzo in wei)
    mapping(uint => uint) public listinoPrezzi;

    // 1. DICHIARAZIONE DEGLI EVENTI
    // Indicizziamo l'acquirente e l'id del prodotto per poterli filtrare sul sito web
    event ProdottoAcquistato(address indexed acquirente, uint indexed idProdotto, uint prezzoPagato);
    event PrezzoAggiornato(uint indexed idProdotto, uint vecchioPrezzo, uint nuovoPrezzo);

    constructor() {
        owner = msg.sender;
        listinoPrezzi[101] = 1 ether; // Prodotto ID 101 costa 1 ETH
    }

    // Funzione per aggiornare il prezzo (Scatena l'evento PrezzoAggiornato)
    function cambiaPrezzo(uint _idProdotto, uint _nuovoPrezzo) public {
        require(msg.sender == owner, "Solo il proprietario puo farlo");
        
        uint vecchio = listinoPrezzi[_idProdotto];
        listinoPrezzi[_idProdotto] = _nuovoPrezzo;

        // 2. EMISSIONE DELL'EVENTO
        emit PrezzoAggiornato(_idProdotto, vecchio, _nuovoPrezzo);
    }

    // Funzione di acquisto (Scatena l'evento ProdottoAcquistato)
    function compraProdotto(uint _idProdotto) public payable {
        uint prezzo = listinoPrezzi[_idProdotto];
        require(prezzo > 0, "Prodotto inesistente");
        require(msg.value >= prezzo, "Fondi insufficienti per l'acquisto");

        // 2. EMISSIONE DELL'EVENTO
        emit ProdottoAcquistato(msg.sender, _idProdotto, msg.value);
    }
}
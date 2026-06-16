/*
    Corso Blockchain e Cryptocurrencies - Compito di laboratorio del 22/06/2021

    Scrivere un contratto `TrustworthyRockPaperScissorsTournament` che implementi l'interfaccia
    `TrustworthyRockPaperScissorsTournamentSpecs` per la gestione di un torneo di Morra Cinese
    sulla piattaforma Ethereum usando il linguaggio Solidity. Il gioco assume un comportamento
    onesto da parte dei giocatori: questi rispetteranno la privacy della mossa altrui, se questa
    è stata fatta per prima, e completeranno tutti i match richiesti affinché il torneo si 
    possa finalizzare.

    In fase di setup del contratto è necessario indicare gli indirizzi dei due giocatori, il
    numero di partite che il vincitore dovrà raggiungere per primo per essere tale e la 
    commissione minima che ogni giocatore deve inviare per poter disputare ogni singola 
    partita/mossa : questa potrebbe anche essere nulla rendendo la commissione stessa opzionale.
    Ogni giocatore può usare i metodi di "tipo move*" per specificare la sequenza delle mosse per
    ogni partita necessaria; non si deve assumere alcun ordine di gioco (entrambi possono muovere 
    per primi). Se possibile, si deve poter permettere ad un giocatore di esprimere una ulteriore
    mossa nella sequenza ancora prima che si sia conclusa la partita precedente.

    Non appena la vincita di una singola partita porta per primo un giocatore al numero 
    specificato di partite da vincere, il contratto dovrà dichiarare chiuso il torneo e versare
    l'intero ammontare delle commissioni versate allo stesso. Il contratto in tal caso si dovrà
    anche auto-distruggere versando il rimborso al creatore originale del contratto.

    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.
    Gli eventi specificati nell'interfaccia dovranno essere opportunamente inviati durante lo
    svolgimento del torneo.

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface TrustworthyRockPaperScissorsTournamentSpecs {
    /* constructor(
        address payable firstPlayer,
        address payable secondPlayer,
        uint8 targetWins,
        uint256 singleMatchFee
    ); */
    function moveRock() external payable;
    function movePaper() external payable;
    function moveScissor() external payable;
    function disputedMatches() external returns (uint8);

    enum Player {First, Second}
    enum Move{Rock, Paper, Scissor} //aggiungiamo le mosse come enum: 0 = Rock, 1 = Paper, 2 = Scissor

    event MatchWonBy(Player winner, uint8 numMatch);
    event TournamentWonBy(Player winner);
}


contract Game is TrustworthyRockPaperScissorsTournamentSpecs{



    address payable public firstPlayer;
    address payable public secondPlayer;
    uint8 targetWins; //Numero di partite necessarie a vincere!
    uint256 singleMatchFee; // Quantità da pagare al contratto per ogni singola mossa

    constructor(address payable first, address payable second, uint8 target, uint256 fee) payable {
        firstPlayer = first;
        secondPlayer = 
    }



    function moveRock() external payable{}
    function movePaper() external payable{}
    function moveScissor() external payable{}
    function disputedMatches() external returns (uint8){}
}
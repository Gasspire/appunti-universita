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

    struct Pstruct{
        uint8 id;
        address payable Player;
        uint8 num_wins;
        Move[] mosse;
    }
    enum Move{Rock, Paper, Scissor}
    enum Player {First, Second}
    event MatchWonBy(Player winner, uint8 numMatch);
    event TournamentWonBy(Player winner);
}


contract TrustworthyRockPaperScissorsTournament is TrustworthyRockPaperScissorsTournamentSpecs{
    address payable firstPlayer;
    address payable secondPlayer;
    uint8 targetWins;
    uint256 singleMatchFee;
    mapping(Player => Pstruct ) giocatori;
    

    modifier OnlyPlayer(){
        require(msg.sender == firstPlayer || msg.sender == secondPlayer, "Solo i giocatori possono fare delle mosse");
        _;
    }

    modifier suffFee(){
        require(msg.value >= singleMatchFee,"Importo non valido, prova a dare una fee maggiore!");
        _;
    }

    constructor(address payable _first, address payable _second, uint8 n_target, uint256 fee){
        firstPlayer = payable(_first);
        secondPlayer = payable(_second);
        targetWins = n_target;
        singleMatchFee = fee;

        require(firstPlayer != address(0) && secondPlayer != address(0), "I giocatori devono entrambi essere validi");
        require(firstPlayer != secondPlayer, "I giocatori devono essere diversi");
        require(targetWins > 0, "Il numero di match da giocare deve essere maggiore di 0");

        Pstruct memory first;
        first.id = 1;
        first.Player = firstPlayer;
        first.num_wins = 0;

        Pstruct memory second;
        second.id = 2;
        second.Player = secondPlayer;
        second.num_wins = 0;
        

        giocatori[Player.First] = first;
        giocatori[Player.Second] = second;
    }

    function whoPlaying(address sender) internal view returns(Player){
        if(sender == firstPlayer) return Player.First;
        else return Player.Second;
    }

    function checkMatch() internal {
        //ottengo il numero di match da controllare, si considera sempre l'ultimo dato che tanto si controlla ad ogni mossa
        uint8 num_match = uint8(giocatori[Player.First].mosse.length < giocatori[Player.Second].mosse.length ? giocatori[Player.First].mosse.length: giocatori[Player.Second].mosse.length) -1;
        if(num_match <)
        if((giocatori[Player.First].mosse[num_match] == Move.Paper && giocatori[Player.Second].mosse[num_match] == Move.Rock) ||
            (giocatori[Player.First].mosse[num_match] == Move.Scissor && giocatori[Player.Second].mosse[num_match] == Move.Paper) || 
            (giocatori[Player.First].mosse[num_match] == Move.Rock && giocatori[Player.Second].mosse[num_match] == Move.Scissor)){
                emit MatchWonBy(Player.First, num_match);
                giocatori[Player.First].num_wins++;
                if(giocatori[Player.First].num_wins == targetWins) emit TournamentWonBy(Player.First);
            }
        else if((giocatori[Player.Second].mosse[num_match] == Move.Paper && giocatori[Player.First].mosse[num_match] == Move.Rock) ||
            (giocatori[Player.Second].mosse[num_match] == Move.Scissor && giocatori[Player.First].mosse[num_match] == Move.Paper) || 
            (giocatori[Player.Second].mosse[num_match] == Move.Rock && giocatori[Player.First].mosse[num_match] == Move.Scissor)){
                emit MatchWonBy(Player.First, num_match);
                giocatori[Player.First].num_wins++;
                if(giocatori[Player.First].num_wins == targetWins) emit TournamentWonBy(Player.First);
            }
    }


    function ret_pFirst()public view returns(address, uint8, uint8){
        return (giocatori[Player.Second].Player, giocatori[Player.Second].id, giocatori[Player.Second].num_wins); 
    }

    function moveRock() external OnlyPlayer suffFee payable{
        //individuo chi sta giocando
        Player currPlayer = whoPlaying(msg.sender);
        //faccio la mossa
        giocatori[currPlayer].mosse.push(Move.Rock);
        //controllo se è stato vinto un match

    }
    function movePaper() external payable{}
    function moveScissor() external payable{}
    function disputedMatches() external returns (uint8){}



    //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 3, 0

}
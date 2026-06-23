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
        address payable Player;
        uint8 num_wins;
        Move[] mosse;
    }
    enum Status{OnGoing, End}
    enum Move{Rock, Paper, Scissor}
    enum Player {First, Second}
    event MatchWonBy(Player winner, uint8 numMatch);
    event TournamentWonBy(Player winner);
}


contract TrustworthyRockPaperScissorsTournament is TrustworthyRockPaperScissorsTournamentSpecs{
    
    mapping(Player => Pstruct) giocatori; //Così conosco il giocatore 1 e il giocatore 2
    uint8 target;
    uint256 match_fee;
    Status stato;

    constructor(address payable firstPlayer,address payable secondPlayer,uint8 targetWins,uint256 singleMatchFee){
        if(firstPlayer == secondPlayer) revert("Errore, non puoi giocare contro te stesso");
        if(firstPlayer == address(0) || secondPlayer == address(0)) revert("Errore, uno dei due giocatori e' nullo");
        if(targetWins == 0) revert("Errore, deve essere fatta almeno una partita");
        if(singleMatchFee == 0)revert("Errore, deve esserci almeno una fee");
        Pstruct memory p_1 = giocatori[Player.First];
        p_1.Player = firstPlayer;

        Pstruct memory p_2 = giocatori[Player.Second];
        p_2.Player = secondPlayer;

        match_fee = singleMatchFee;
        stato = Status.OnGoing;
        target = targetWins;  
    }
    
    modifier OnlyPlayer(){
        if(msg.sender != giocatori[Player.First].Player && msg.sender != giocatori[Player.Second].Player) revert("Errore, azione permessa solo ai giocatori");
        _;
    }

    function checkWin(Player p)internal{
        uint8 last_match_to_check = uint8(giocatori[Player.First].mosse.length > giocatori[Player.Second].mosse.length ? giocatori[Player.First].mosse.length: giocatori[Player.Second].mosse.length);
        Player p_opp = (p == Player.First ? Player.Second:Player.First); //Così ho anche l'opponent

        if(giocatori[p_opp].mosse.length < last_match_to_check) return; // L'opponent non ha ancora giocato!
        else{
            //se ha già giocato dobbiamo verificare chi ha vinto tra i due quel match
            if((giocatori[Player.First].mosse[last_match_to_check-1] == Move.Rock && giocatori[Player.Second].mosse[last_match_to_check-1] == Move.Scissor)||
            (giocatori[Player.First].mosse[last_match_to_check-1] == Move.Paper && giocatori[Player.Second].mosse[last_match_to_check-1] == Move.Rock) ||
            (giocatori[Player.First].mosse[last_match_to_check-1] == Move.Scissor && giocatori[Player.Second].mosse[last_match_to_check-1] == Move.Paper)){
                //il player 1 ha vinto questo match
                giocatori[Player.First].num_wins += 1;
            }
            else if((giocatori[Player.Second].mosse[last_match_to_check-1] == Move.Rock && giocatori[Player.First].mosse[last_match_to_check-1] == Move.Scissor)||
                (giocatori[Player.Second].mosse[last_match_to_check-1] == Move.Paper && giocatori[Player.First].mosse[last_match_to_check-1] == Move.Rock) ||
                (giocatori[Player.Second].mosse[last_match_to_check-1] == Move.Scissor && giocatori[Player.First].mosse[last_match_to_check-1] == Move.Paper)){
                    giocatori[Player.Second].num_wins+=1;
                }



        }
    }


    function moveRock() external OnlyPlayer payable{
        Player p = (msg.sender == giocatori[Player.First].Player ? Player.First: Player.Second);

        giocatori[p].mosse.push(Move.Rock);
        checkWin(p);
    }
    function movePaper() external OnlyPlayer payable{}
    function moveScissor() external OnlyPlayer payable{}



    function disputedMatches() external view returns (uint8){
        return uint8(giocatori[Player.First].mosse.length > giocatori[Player.Second].mosse.length ? giocatori[Player.First].mosse.length: giocatori[Player.Second].mosse.length);
    }


}
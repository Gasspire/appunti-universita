/*
    Corso Blockchain e Cryptocurrencies - Esercitazione di laboratorio (Simulazione 4)

    Scrivere un contratto `DecentralizedTris` che implementi l'interfaccia `DecentralizedTrisSpecs`
    usando il linguaggio Solidity per la gestione di partite di Tris (Tic-Tac-Toe) con montepremi 
    sulla piattaforma Ethereum.

    Il sistema permette a chiunque di creare una nuova partita tramite il metodo `createGame`, 
    versando una quota di partecipazione in Ether (bet). Il creatore della partita sarà 
    automaticamente il giocatore "X" e la partita riceverà un `id` univoco sequenziale.

    Un altro utente può unirsi a una partita in attesa di avversario tramite il metodo `joinGame`, 
    versando l'esatta quota di partecipazione decisa dal creatore. Questo utente diventerà il 
    giocatore "O" e, da quel momento, la partita passa allo stato "Playing".
    
    Il giocatore "X" ha sempre il diritto di fare la prima mossa. I giocatori si alterneranno 
    usando il metodo `makeMove`, passando l'ID della partita e la posizione in cui vogliono 
    inserire il loro simbolo. La griglia è rappresentata da un array lineare di 9 posizioni 
    (indici da 0 a 8, dove 0 è in alto a sinistra e 8 in basso a destra).

    Ad ogni mossa, il contratto deve verificare se c'è un vincitore (3 simboli uguali in fila 
    orizzontale, verticale o diagonale) o se c'è un pareggio (griglia piena senza vincitori).
    
    Se un giocatore vince, la partita si conclude ("Finished") e il vincitore riceve 
    immediatamente l'intero montepremi (la somma delle due quote).
    Se la partita finisce in pareggio, la partita si conclude e il contratto rimborsa 
    esattamente la propria quota a ciascuno dei due giocatori.

    Gli eventi indicati dovranno essere emessi opportunamente durante le fasi del gioco.
    
    I vari errori previsti dall'interfaccia dovranno essere lanciati dai metodi interessati in
    caso di anomalie (es. partita inesistente, non è il proprio turno, posizione fuori dal 
    range 0-8, o cella già occupata).
    
    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.
*/

// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

interface DecentralizedTrisSpecs {
    
    enum Mark { Empty, X, O }
    enum GameState { WaitingForPlayer, Playing, Finished }

    // Sentiti libero di definire la struct Game come meglio credi per tracciare i turni, 
    // la griglia e i giocatori.
    
    // Crea una nuova partita versando la quota (ritorna l'id della partita)
    function createGame() external payable returns (uint gameId);

    // Unisciti a una partita in attesa versando l'esatta quota
    function joinGame(uint gameId) external payable;

    // Fai una mossa specificando la cella (da 0 a 8)
    function makeMove(uint gameId, uint8 position) external;

    // --- Metodi di sola lettura ---
    function getGameState(uint gameId) external view returns (GameState);
    function getBoard(uint gameId) external view returns (Mark[9] memory);
    function getCurrentTurn(uint gameId) external view returns (address);

    // --- Eventi ---
    event GameCreated(uint gameId, address creator, uint betAmount);
    event GameJoined(uint gameId, address playerO);
    event MoveMade(uint gameId, address player, Mark mark, uint8 position);
    event GameWon(uint gameId, address winner, uint prizeAmount);
    event GameDrawn(uint gameId);

    // --- Errori Custom ---
    error InvalidGame();
    error GameNotWaiting();
    error IncorrectBetAmount(uint required, uint provided);
    error GameNotPlaying();
    error NotYourTurn();
    error InvalidPosition();
    error CellAlreadyTaken();
}



contract DecentralizedTris is DecentralizedTrisSpecs{

    struct Partita{
        address p1;
        address p2;
        uint256 bet;
        Mark[9] mosse;
        GameState stato;
        address curr_turn;
        uint num_mosse;
    }
    

    uint num_partite;
    mapping(uint => Partita) partite;

    modifier OnlyExisting(uint id){
        if(id >= num_partite) revert InvalidGame();
        _;
    }

    modifier OnlyTurn(uint id){
        if(msg.sender != partite[id].curr_turn) revert NotYourTurn(); 
        _;
    }
    


    function createGame() external payable returns (uint gameId){
        partite[num_partite].p1 = msg.sender;
        partite[num_partite].bet = msg.value;

        partite[num_partite].bet = msg.value;

        num_partite++;
        
    }

    // Unisciti a una partita in attesa versando l'esatta quota
    function joinGame(uint gameId) external payable{
        if(msg.value != partite[gameId].bet) revert IncorrectBetAmount(partite[gameId].bet, msg.value);

    }
 
    function checkBoard(Mark curr_mark, uint gameId)internal view returns(bool){
        //Controlliamo prima le righe 
        uint8 counter_riga;
        uint8 counter_diag_dx;
        uint8 counter_diag_sx;

        bool winner;


        for (uint i = 0; i < 8; i++) 
        {
            if(partite[gameId].mosse[i] == curr_mark){
                counter_riga++;
                if((i%4) == 0) counter_diag_dx++;
                if(i==2 || i == 4 || i == 6) counter_diag_sx++;
                if(counter_riga != 3 && (i == 2 || i == 5)) counter_riga = 0;
                else if(counter_riga == 3){
                    winner = true;
                    break;
                }
            }
        }
        if(counter_diag_dx == 3 || counter_diag_sx == 3) winner = true;
        //manca il controllo della colonna...
        if(partite[gameId].mosse[0] == curr_mark && partite[gameId].mosse[3] == curr_mark && partite[gameId].mosse[6] == curr_mark) winner = true;
        if(partite[gameId].mosse[1] == curr_mark && partite[gameId].mosse[4] == curr_mark && partite[gameId].mosse[7] == curr_mark) winner = true;
        if(partite[gameId].mosse[2] == curr_mark && partite[gameId].mosse[5] == curr_mark && partite[gameId].mosse[8] == curr_mark) winner = true;

        if(winner) return true;
        else return false;
    }


    // Fai una mossa specificando la cella (da 0 a 8)
    function makeMove(uint gameId, uint8 position) OnlyTurn(gameId) external{  
        if(position > 8) revert InvalidPosition();
        if(partite[gameId].stato != GameState.Playing)revert GameNotPlaying();
        if(partite[gameId].mosse[position] != Mark.Empty) revert CellAlreadyTaken();

        Mark curr_mark = (msg.sender == partite[gameId].p1? Mark.X:Mark.O);
        
        partite[gameId].mosse[position] = curr_mark;
        partite[gameId].num_mosse++;

        if(checkBoard(curr_mark, gameId)){ //il player ha vinto!
            partite[gameId].stato = GameState.Finished;
            address winner = (curr_mark == Mark.X ? partite[gameId].p1: partite[gameId].p2);
            (bool success, ) = winner.call{value: partite[gameId].bet*2}("");    
            emit GameWon(gameId, winner, partite[gameId].bet*2);
            require(success,"Errore");
            return;
        }    
        if(partite[gameId].num_mosse == 9){
            partite[gameId].stato = GameState.Finished;
            (bool succ_p1, ) = partite[gameId].p1.call{value: partite[gameId].bet}("");
            (bool succ_p2, ) = partite[gameId].p2.call{value: partite[gameId].bet}("");
            require(succ_p1 && succ_p2,"Errore");
            emit GameDrawn(gameId);
            return;
        }
    }

    // --- Metodi di sola lettura ---
    function getGameState(uint gameId) external view returns (GameState){
        return partite[gameId].stato;
    }
    function getBoard(uint gameId) external view returns (Mark[9] memory){
        return partite[gameId].mosse;
    }
    function getCurrentTurn(uint gameId) external view returns (address){
        return partite[gameId].curr_turn;
    }


}
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

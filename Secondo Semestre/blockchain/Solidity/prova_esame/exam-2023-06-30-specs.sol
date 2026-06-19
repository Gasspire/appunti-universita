/*
  ## Blockchain & Cryptocurrencies -  Compito di laboratorio del 30/06/2023

  ##############################################################################

  Scrivere un contratto `BingoGame` che implementi l'interfaccia `BingoGameSpecs`
  utilizzando il linguaggio Solidity per una partita di Bingo sulla piattaforma 
  Ethereum.

  In una partita di Bingo c'è una fase preliminare di prenotazione durante la 
  quale chiunque può acquistare alcune schede pagando in crediti Ether. Nella 
  successiva "fase estrattiva", ad ogni estrazione di numeri, tutte le schede
  vengono verificate cercando i vincitori dei due unici premi previsti:
  - premio "fila di cinque" corrispondente al 30% del montepremi in Ether
    incassato attraverso la vendita delle schede;
  - premio finale "Bingo" corrispondente al 70%.
  Sulla stessa estrazione più di un giocatore potrebbe raggiungere lo stesso 
  obiettivo (ex-aequo): in tal caso il sistema suddividerà in parti uguali 
  l'importo del premio da assegnare. Una scheda è composta da 3 file di 5 numeri
  senza duplicati sull'intera scheda. I numeri estratti appartengono 
  all'intervallo 1-75 (standard Americano).

  Il proprietario del contratto determina la durata del periodo di prenotazione
  e il costo di una singola scheda (un importo strettamente positivo in Wei).

  Nella fase di `Booking` chiunque può utilizzare il metodo `buyCards` per
  ottenerne un certo numero di schede: il numero esatto è determinato,
  arrotondando per difetto, dalla quantità di crediti trasferiti (ad esempio,
  trasferendo 900 Wei si ottengono 4 schede se il costo per la scheda è di 200).
  Il metodo può essere utilizzato più volte dallo stesso giocatore purché
  la fase preliminare non sia già conclusa. Le schede assegnate sono generate
  casuale rispettando le specifiche (3x5 numeri senza duplicati).
  Il metodo `buyCards` attiva l'evento `PurchaseOfCards` o uno dei seguenti
  errori: `BookingPeriodAlreadyExpired`, `GameAlreadyEnded` o
  `InsufficientFundsToBuyEvenACard`.

  Nella successiva fase di `Extraction` chiunque può attivare l'estrazione di
  del numero successivo utilizzando il metodo pubblico `extractNextNumber`.
  Il numero, compreso tra 1 e 75 e diverso dai precedenti, viene estratto a caso
  e tutte le schede vengono controllate alla ricerca delle condizioni per 
  assegnare uno dei due premi (se ancora disponibile). L'evento 
  `NumberExtraction` viene sempre attivato riportando anche il numero di
  schede corrispondenti. Se uno dei due premi viene vinto (da un singolo o da un
  gruppo di giocatori) viene lanciato l'evento corrispondente
  (`FiveInARowHasBeenWon` o `BingoHasBeenWon`). In quest'ultimo caso il gioco è
  considerato `Ended`, l'importo del premio (o il suo frazionamento in caso
  di ex-aequo) viene corrisposto al vincitore con il trasferimento dei
  corrispondenti Ether sulla piattaforma Ethereum e l'evento `PrizePayed` viene
  attivato. Il metodo `extractNextNumber` potrebbe anche attivare uno dei
  seguenti errori: `ExtractionPhaseNotYetStarted` o `GameAlreadyEnded`.

  Il contratto deve implementare anche le seguenti funzioni ausiliaria in sola
  lettura:
  - `getCardCost`, `getGameState`, `getNumberOfPlayers` e `getNumberOfCards` con
     i loro ovvi significati;
  - `getMyCards` che riporta un elenco delle schede possedute dal chiamante o
    o attiva l'errore `EnquirerIsNotAGamer`;
  - `isItExtracted` che consente di verificare se un numero specifico è stato
    già estratto o che genera l'errore `ExtractionPhaseNotYetStarted`.

  Infine il contratto dovrà occuparsi di convalidare i pochi input ricevuti
  secondo ovvi criteri di sensatezza.

  Suggerimento: per generare un numero casuale (non del tutto imprevedibile) si
  può usare qualcosa come:
  `uint256(keccak256(abi.encode(block.timestamp, block.difficulty)))`
*/ 

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface BingoGameSpecs {
  /* constructor(uint bookingPeriodInHours, uint cardCost); */

  struct Card {
      uint8 [5][3] cells; /* 3 righe di 5 colonne */
  }
  enum GameState {Booking, Extraction, Ended}
  
  function buyCards() payable external;
  function extractNextNumber() external returns (uint8 number);

  function getCardCost() external view returns (uint cost);
  function getGameState() external view returns (GameState state);
  function getNumberOfPlayers() external view returns (uint players);
  function getNumberOfCards() external view returns (uint cards);
  function getMyCards() external view returns (Card[] memory cards);
  function isItExtracted(uint8 number) external view returns (bool);
 
  event PurchaseOfCards(address buyer, uint numberOfCards);
  event NumberExtraction(uint8 number, uint matchingCards);
  event FiveInARowHasBeenWon(uint prizeAmount, uint numberOfWinners);
  event BingoHasBeenWon(uint prizeAmount, uint numberOfWinners);
  event PrizePayed(uint prizeAmount, address winner);

  error BookingPeriodAlreadyExpired();
  error ExtractionPhaseNotYetStarted(uint secondsToGo);
  error GameAlreadyEnded();
  error InsufficientFundsToBuyEvenACard(uint providedFunds, uint cardCost);
  error EnquirerIsNotAGamer();
}



contract BingoGame is BingoGameSpecs{
  struct Player{
    address addr;
    uint256 id;
    uint256 num_card;
    Card[] card;
    Card[] card_uscito;
  }
  uint end_booking_phase;
  uint card_cost;
  GameState stato;



  uint total_amount; //per sapere quanto è il premio raccolto per poi dividerlo
  uint num_player;
  uint num_cards;

  mapping(address => Player) giocatori;
  address[] giocatori_lista;


  uint8[76] numeri_estratti;
  uint8 bingo_vinto;
  uint8 cinque_in_riga;
  uint256 premio_cinquina;
  uint256 premio_bingo;



  modifier onlyBookingPhase(){
    if(stato == GameState.Extraction) revert BookingPeriodAlreadyExpired();
    else if(stato == GameState.Ended) revert GameAlreadyEnded();
    _;
  }


  constructor(uint bookingPeriodInHours, uint cardCost){
    if( bookingPeriodInHours == 0 || cardCost == 0) revert(); // controlliamo che gli input abbiano senso
    end_booking_phase = block.timestamp + (bookingPeriodInHours * 1 minutes);
    card_cost = cardCost;
    stato = GameState.Booking;
  }


  function buyCards() payable onlyBookingPhase external{
    if(giocatori[msg.sender].num_card == 0){ //allora è un nuovo player
      giocatori[msg.sender].addr = msg.sender;
      giocatori[msg.sender].id = num_player;

      giocatori_lista.push(msg.sender);
      num_player++;
    } 



    uint number_of_cards = uint(msg.value/card_cost);
    if(number_of_cards == 0) revert InsufficientFundsToBuyEvenACard(msg.value, card_cost);


    total_amount += msg.value;

    for(uint i = 0; i < number_of_cards; i++){

      uint8[76] memory usciti;
      uint256 curr_number = giocatori[msg.sender].num_card;
      giocatori[msg.sender].card_uscito.push();
      giocatori[msg.sender].card.push();
      uint256 randomness = 0;

      for (uint x = 0; x < 3; x++) 
      {
        for (uint y = 0; y < 5; y++) 
        {
          uint8 number;
          //mi assicuro che il numero uscito sia sempre diverso
          do {
            number = uint8((uint256(keccak256(abi.encode(block.timestamp, block.prevrandao, (i+x+y+randomness))))%(76)) + 1);
            randomness++;
          } 
          while (usciti[number] != 0);
          usciti[number] = 1;
          
          giocatori[msg.sender].card[curr_number].cells[x][y] = number;
        }
      }
      giocatori[msg.sender].num_card++;
      num_cards++;
    }

    emit PurchaseOfCards(msg.sender, number_of_cards);
  }
  
  function extractNextNumber() external returns (uint8 number){
    if(stato == GameState.Booking && block.timestamp < end_booking_phase) revert ExtractionPhaseNotYetStarted(end_booking_phase - block.timestamp);
    if(stato == GameState.Booking && block.timestamp > end_booking_phase){
      stato = GameState.Extraction;
      premio_cinquina = (total_amount * 30)/100;
      premio_bingo = total_amount - premio_cinquina;

    } 
    if(stato == GameState.Ended) revert GameAlreadyEnded();

    uint8 numero_estratto;
    uint256 randomness = 0;
    do {
      numero_estratto = uint8((uint256(keccak256(abi.encode(block.timestamp, block.prevrandao,randomness)))%(75)) + 1);
      randomness++;
    } 
    while (numeri_estratti[numero_estratto] != 0); //così ho un numero unico



    //una volta estratto il numero, devo controllare tutte le cartelle e assegnare i premi.


    uint total_in_row = 0;
    uint total_in_card = 0;
    uint number_of_winner_row = 0;
    address[] memory row_winner;
    uint8 is_already_winner = 0;



    uint number_of_bingo_winner = 0;
    address[] memory bingo_winner;
    uint8 is_already_winner_bingo = 0;

    uint256 numero_incombenze;


    for (uint i = 0; i < num_player; i++) 
    {
      address curr_player = giocatori_lista[i];
      for(uint j = 0; j < giocatori[curr_player].num_card; j++){
        for(uint x = 0; x < 3; x++){
          for(uint y = 0; y < 5; y++){
            if(giocatori[curr_player].card[j].cells[x][y] == numero_estratto){
              giocatori[curr_player].card_uscito[j].cells[x][y] = 1;
              numero_incombenze++;
            }
            total_in_row+= giocatori[curr_player].card_uscito[j].cells[x][y]; //conto quanti numeri sono stati indovinati in una riga!
            total_in_card+= giocatori[curr_player].card_uscito[j].cells[x][y]; //conto quanti numeri sono stati indovinati nella cartella
          }

          if(total_in_row == 5 && is_already_winner == 0){
            row_winner[number_of_winner_row] = curr_player; //aggiungiamo il player che ha vinto la riga se non ha già vinto
            total_in_row = 0;
            is_already_winner = 1;
            number_of_winner_row++;
          }
          else total_in_row = 0;
        }
        if(total_in_card == 15 && is_already_winner_bingo == 0){
          bingo_winner[number_of_bingo_winner] = curr_player;
          total_in_card = 0;
          is_already_winner_bingo = 1;
          number_of_bingo_winner++;
        }
        else total_in_card = 0;
      }
      is_already_winner = 0;
      is_already_winner_bingo = 0;
    }

    //abbiamo fatto tutti i controlli ora assegnamo i premi
    if(cinque_in_riga == 0 && number_of_winner_row != 0){ //allora assegnamo i premi 
      cinque_in_riga = 1; //qualunque tentativo di chiamata fallback fallirà nel provare a rientrare qui evitando attacchi che svuotano il conto
      emit FiveInARowHasBeenWon(premio_cinquina, number_of_winner_row);
      uint256 importo = premio_cinquina/number_of_winner_row;
      for (uint i = 0; i < number_of_winner_row; i++) 
      {
        payable(row_winner[i]).transfer(importo);
        emit PrizePayed(importo, row_winner[i]);
      }
    }
    if(bingo_vinto == 0 && number_of_bingo_winner != 0){
      bingo_vinto = 1;
      emit BingoHasBeenWon(premio_bingo, number_of_bingo_winner);
      stato = GameState.Ended;
      uint256 importo = premio_bingo/number_of_bingo_winner;
      for (uint i = 0; i < number_of_bingo_winner; i++) 
      {
        payable(bingo_winner[i]).transfer(importo);
        emit PrizePayed(importo, bingo_winner[i]);

      }
    }
    emit NumberExtraction(numero_estratto, numero_incombenze);
    return numero_estratto;
  }

  function getCardCost() external view returns (uint cost){
    return card_cost;
  }
  function getGameState() external view returns (GameState state){
    return stato;
  }
  function getNumberOfPlayers() external view returns (uint players){
    return num_player;
  }
  function getNumberOfCards() external view returns (uint cards){
    return num_cards;
  }

  function getMyCards() external view returns (Card[] memory cards){
    if(giocatori[msg.sender].num_card == 0) revert EnquirerIsNotAGamer();
    else return giocatori[msg.sender].card;
  }
  function isItExtracted(uint8 number) external view returns (bool){
    if(number > 75) revert();
    if(stato == GameState.Booking) revert ExtractionPhaseNotYetStarted(end_booking_phase - block.timestamp);
    if(numeri_estratti[number] == 1) return true;
    else return false;
  }



}
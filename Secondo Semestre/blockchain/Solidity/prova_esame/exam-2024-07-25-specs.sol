/*
    Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 25/07/2024

  Scrivere un contratto `DMICards` che implementi l'interfaccia 
  `DMICardsSpecs` e l'interfaccia `SimplifiedERC721` (Non-Fungible Token) 
  utilizzando il linguaggio Solidity per gestire dei nuovi NFT sulla piattaforma
  Ethereum.

  Il contratto, creato da un `Manager`, permetterà di gestire la creazione e l'uso
  di carte da gioco virtuali che potranno essere scambiate come, una versione 
  semplificata, dei token ERC-721. Ogni carta, oltre ad un identificativo numerico
  (`uint256`) che le distingue, ha due score caratterizzanti: `attackScore` e
  `defenseScore`. Le carte potranno essere generate da chiunque pagando una relativa 
  commissione con dei limiti temporali. Due possessori di carte potranno sfidarsi
  in scrontri "uno a uno" che possono far crescere o decrescere gli score delle
  carte coinvolte oltre a far guadagnare ETH al vincitore.

  I metodi dell'interfaccia `DMICardsSpecs` sono:
  - un costruttore che permetta di specificare una `baseFee` in wei non nulla e
    un parametro intero `hoursBetweenOps` che indica il numero minimo di ore che
    devono passare tra alcune operazioni e la successiva; tali valori dovranno 
    essere considerati immutabili all'interno del contratto;
  - `createCard`: permette di creare una nuova card pagando una commissione pari a
    100 volte la `baseFee` con degli score generati a caso tra 10 e 50; le
    commissioni saranno incassate dal contratto; la proprietà della card generata
    sarà registrata a favore del richiedente e sarà generato un evento del tipo
    `CardGenerated`; ogni richiedente può fare una nuova richiesta se sono passate
    almeno `hoursBetweenOps`: eventualmente viene generato un errore del tipo
    `TooEarlyOperation`;
  - `launchChallenge`: un proprietario di carte può lanciare una sfida ad un altro
    proprietario indicando la carta che vuole usare; lo sfidante dovrà pagare
    un valore pari a `betValue + fee` dove `fee` è pari a 10 volte `baseFee` e
    viene trattenuto dal contratto; il valore `betValue`, non nullo, è invece
    scelto liberamente dallo sfidante e dovrà essere corrisposto dallo sfidato 
    per accettare la sfida; tale metodo può lanciare l'evento `ChallengeLaunched`
    o  l'errore `InsufficientFee` se il valore è minore o uguale a `fee` o 
    l'errore `ChallengeAlreadyExists` nel caso di una sfida già esistente tra le
    parti coinvolte o l'errore `CardNotOwned` se la card indicata non esiste o
    non è di proprietà dello sfidante; tra una sfida e la successiva lanciata
    dallo stesso sfidante devono passare almeno `hoursBetweenOps`: eventualmente
    viene generato un errore del tipo `TooEarlyOperation`;
  - `withdrawChallenge`: permette a chi ha lanciato una sfida di ritirare la stessa
    unicamente se questa non è ancora stata accettata; in tal caso il contratto
    restituisce la `betValue` allo sfidante trattenendo però la `fee`;
    questo metodo può lanciare l'evento `ChallengeWithdrawn` o l'errore
    `ChallengeDoesNotExist`;
  - `takeUpChallenge`: permette ad uno sfidato di accettare una sfida a lui 
    destinata indicando la carta da usare e corrispondendo un valore pari a
    `betValue + fee` (quanto pagato dallo sfidante) o superiore; il metodo 
    lancerà subito l'evento `ChallengeTakenUp` o gli errori `ChallengeDoesNotExist`,
    `InsufficientFee` o `CardNotOwned`; in seguito determinerà l'esito e gli
    effetti della sfida: se indichiamo con `A1` e `D1`, rispettivamente, gli
    score di attacco e difesa della carta sfidante e con `A2` e `D2` quelli della
    carta sfidata, verrà calcolato il valore `X` pari a `(A1 - D2) - (A2 - D1) + R`
    dove `R` è un valore casuale tra -30 e +30; se il valore finale di `X` è non
    negativo il vincitore sarà lo sfidante altrimenti sarà lo sfidato; gli score
    della carta vincente saranno aumentati del 10%; quelli della carta perdente 
    saranno diminuiti della stessa percentuale; sarà emesso un ulteriore evento 
    `ChallengeCompleted` e verrà trasferito al vincitore un valore in wei pari a
    due volte `betValue`;
  - `baseFee` e `hoursBetweenOps`: metodi pubblici che permettono di consultare
    gli omonimi parametri;
  - `withdrawFees`: un metodo riservato al Manager per richiedere il trasferimento
    di fondi raccolti dal contratto; i fondi relativi alla componente `betValue`
    di sfide pendenti non dovrebbero essere prelevabili dal Manager; il metodo
    può lanciare l'errore `InsufficientFee` se il valore richiesto non è
    prelevabile.

  I metodi dell'interfaccia `SimplifiedERC721` permettono di supportare alcune
  operazioni di trasferimento relative ai nuovi token NFT:
  - `totalSupply`, `balanceOf`: riportano, rispettivamente, il numero di token
    (leggi "carte") esistenti o posseduti da un dato indirizzo Ethereum;
  - `ownerOf`: riporta l'indirizzo del proprietario di un dato token;
  - `transfer`: trasferisce di proprietà un token su richiesta del relativo
    propritario emettendo l'evento standard `Transfer`;
  Tali metodi potranno generare alcuni degli errori visti sopra se pertinenti.

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface DMICardsSpecs {
  /* constructor(uint256 baseFee, uint256 hoursBetweenOps) */

  function createCard() external payable returns (uint256 id);
  function launchChallenge(address challenged, uint256 cardId) external payable;
  function withdrawChallenge(address challenged) external;
  function takeUpChallenge(address challenger, uint256 cardId) external payable;
  function baseFee() external view returns (uint256);
  function hoursBetweenOps() external view returns (uint256);
  function withdrawFees(uint256 amount) external;

  event CardGenerated(address owner, uint256 id, uint256 attackScore, uint256 defenseScore);
  event ChallengeLaunched(address challenger, uint256 challengerCardId, address challenged, uint256 betValue);
  event ChallengeWithDrawn(address challenger, address challenged);
  event ChallengeTakenUp(address challenger, address challenged, uint256 challengedCardId);
  event ChallengeCompleted(address winner);

  error TooEarlyOperation(uint256 remainingHours);
  error InsufficientFee(uint256 minimum);
  error CardNotOwned(uint256 id);
  error ChallengeAlreadyExists(address challenger, address challenged);
  error ChallengeDoesNotExist(address challenger, address challenged);
}

interface SimplifiedERC721 {
  function totalSupply() external view returns (uint256 total);
  function balanceOf(address _owner) external view returns (uint256 balance);
  function ownerOf(uint256 _tokenId) external view returns (address owner);
  function transfer(address _to, uint256 _tokenId) external;

  event Transfer(address from, address to, uint256 tokenId);
}

contract DMICards is DMICardsSpecs, SimplifiedERC721{
  struct Card{
    uint256 id;
    uint attackScore;
    uint defenseScore;
  }
  struct Challenge{
    uint256 id_card_1;
    uint256 id_card_2;
    bool is_accepted;
    bool is_ongoing;

    uint256 betValue;
  }
  mapping(address => uint) utenti_balance;
  mapping(uint => address) proprietari;
  mapping(uint => Card) carte;
  mapping(address => uint) cooldown_end_create;
  mapping(address => uint) cooldown_end_challenge;

  mapping(address => Challenge) sfide;
  
  uint numero_carte;
  uint base_fee;
  uint hoursBetweenOp;

  address manager;







  function createCard() external payable returns (uint256 id){
    if(msg.value < (100 * base_fee)) revert InsufficientFee(100 * base_fee);
    if(block.timestamp < cooldown_end_create[msg.sender]) revert TooEarlyOperation((hoursBetweenOp - block.timestamp)*1 hours); //l'errore deve essere in ore

    carte[numero_carte].id = numero_carte;
    carte[numero_carte].attackScore = uint(keccak256(abi.encode(block.timestamp,block.prevrandao, 1)));
    carte[numero_carte].defenseScore = uint(keccak256(abi.encode(block.timestamp,block.prevrandao, 2)));

    proprietari[numero_carte] = msg.sender;
    emit CardGenerated(msg.sender, carte[numero_carte].id, carte[numero_carte].attackScore, carte[numero_carte].defenseScore);
    numero_carte++;
    cooldown_end_create[msg.sender] = block.timestamp + (hoursBetweenOp * 1 hours);
    return numero_carte-1;
  }

  function launchChallenge(address challenged, uint256 cardId) external payable{}
  function withdrawChallenge(address challenged) external{
    if(sfide[msg.])
  }
  function takeUpChallenge(address challenger, uint256 cardId) external payable{}

  function baseFee() external view returns (uint256){
    return base_fee;
  }
  function hoursBetweenOps() external view returns (uint256){
    return hoursBetweenOp;
  }
  function withdrawFees(uint256 amount) external{
    if(msg.sender != manager) revert("Non sei il proprietario del contratto");
    if(amount > address(this).balance) revert("Non e possibile trasferire tale somma");

    (bool success, ) = manager.call{value: amount}("");
    if(!success) revert("Qualcosa non ha funzionato");
  }



  function totalSupply() external view returns (uint256 total){
    return numero_carte;
  }
  function balanceOf(address _owner) external view returns (uint256 balance){
    return utenti_balance[_owner];
  }
  function ownerOf(uint256 _tokenId) external view returns (address owner){
    return proprietari[_tokenId];
  }
  function transfer(address _to, uint256 _tokenId) external{
    if(proprietari[_tokenId] != msg.sender ) revert CardNotOwned(_tokenId);
    else{
      proprietari[_tokenId] = _to;
      utenti_balance[msg.sender]--;
      utenti_balance[_to]++;
      emit Transfer(msg.sender, _to, _tokenId);
    }
  }
}
/*
  ## Blockchain & Cryptocurrencies -  Compito di laboratorio del 14/07/2023

  ##############################################################################

  Scrivere un contratto `CryptoPigeon` che implementi l'interfaccia 
  `CryptoPigeonSpecs` e l'interfaccia `SimplifiedERC721` (Non-Fungible Token) 
  utilizzando il linguaggio Solidity per gestire dei nuovi NFT sulla piattaforma
  Ethereum.

  Il contratto, creato da un `Manager`, permetterà di gestire dei "piccioni 
  virtuali" che potranno essere scambiati come, una versione semplificata, dei 
  token ERC-721. Il contratto, all'atto della creazione, stabilirà dei 
  parametri chiave, alcuni dei quali, potranno poi essere cambiati dal Manager 
  stesso. Inoltre genererà un numero iniziale di piccioni posseduti direttamente
  dal Manager: questo poi li potrà trasferire ad altri (regalandoli o vendendoli).
  
  Un piccione:
  - ha un proprietario identificato dall'indirizzo sulla piattaforma Ethereum;
  - ha un proprio identificativo univoco (0, 1, 2, ...);
  - può avere un nome (opzionale);
  - ha una data (e orario) di nascita `birthTime`;
  - è "gender-free": non è né maschio né femmina;
  - può nascere a partire da una coppia di piccioni pre-esistenti su richiesta
    del proprietario della coppia;
  - ha un `geneticScore` che deriva, parzialmente, da quello dei suoi genitori;
    lo score dei piccioni creati insieme al contratto è prestabilito e per tutti
    uguale;
  - non può generare figli nel periodo di pubertà (identificato da
    `pubertyBlockPeriodInSecs`);
  - non potrà generare ulteriori figli prima di un periodo di "Cooldown" 
    dall'ultima nascita (identificato da `cooldownBlockPeriodInSecs`);
  - appartiene ad una "generazione" (intero): i piccioni creati insieme al 
    contratto saranno di "generazione 0"; un figlio apparterrà alla 
    "generazione n+1", dove `n` è la generazione più alta tra i due genitori.

  I metodi dell'interfaccia `CryptoPigeonSpecs` sono:
  - `pigeonBirth`: permette ad un proprietario di far accoppiare due piccioni di
    sua proprietà, assegnandogli eventualmente anche un nome; il nuovo nato 
    avrà un proprio identificativo univoco e uno score genetico gen dato dalla
    media deiitori con una variazione randomica che può andare dal -20% al
    +40%; tale metodo può essere azionato solo dietro pagamento (incassato dal 
    contratto) di `birthFee` wei; esso genererà l'evento `Birth` o uno dei
    seguenti errori: `ParentStillInPubertyPeriod`, `ParentsCannotBeEqual`,
    `ParentStillInCooldownPeriod`, `InsufficientSentAmount` o
    `PigeonOwnerReservedAction`;
  - `renamePigeon`: permette al proprietario di cambiare il nome ad un proprio
    piccione pagando la relativa fee; esso potrà generare i seguenti errori:
    `PigeonIdentifierUnknown`, `InsufficientSentAmount` o 
    `PigeonOwnerReservedAction`;
  - `getPigeonData`, `birthFee`, `renamingFee`: permettono a chiunque di
     consultare i dati interni indicati;
  - `changeBirthFee`, `changeRenamingFee`: permettono al Manager di cambiare i
    parametri economici del contratto; esso potrà generare l'errore
    `ManagerReservedAction`;
  - `withdrawProfits`: permette al Manager di prelevare una parte dei profitti
    in Ether accumulati sul contratto stesso.

  I metodi dell'interfaccia `SimplifiedERC721` permettono di supportare alcune
  operazioni di trasferimento relative ai nuovi token NFT:
  - `totalSupply`, `balanceOf`: riportano, rispettivamente, il numero di token
    (leggi "piccioni") esistenti o posseduti da un dato indirizzo Ethereum;
  - `ownerOf`: riporta l'indirizzo del proprietario di un dato token;
  - `transfer`: trasferisce di proprietà un token su richiesta del relativo
    propritario emettendo l'evento standard `Transfer`;
  Tali metodi potranno generare alcuni degli errori visti sopra se pertinenti.
  
  Suggerimento: per generare un numero casuale (non del tutto imprevedibile) si
  può usare qualcosa come:
  `uint256(keccak256(abi.encode(block.timestamp, block.difficulty)))`

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface CryptoPigeonSpecs {
    /*
      constructor(
        uint16 _initialPigeons,
        uint256 _initialPigeonsFixedScore,
        uint256 _birthFee,
        uint256 _renamingFee,
        uint256 _pubertyBlockPeriodInSecs,
        uint256 _cooldownBlockPeriodInSecs
      );
    */

    struct Pigeon {
        string name;
        uint256 geneticScore;
        uint16 generation;
        uint256 firstParent;
        uint256 secondParent;
        uint256 birthTime;
        uint256 cooldownEndBlockTime;
    }

    function pigeonBirth(
        uint256 firstParent,
        uint256 secondParent,
        string calldata name
    ) external payable returns (uint256 _id);

    function getPigeonData(uint256 _id) external view returns (Pigeon memory);

    function renamePigeon(
        uint256 _id,
        string calldata _newName
    ) external payable;

    function birthFee() external view returns (uint256);

    function changeBirthFee(uint256 _newFee) external;

    function renamingFee() external view returns (uint256);

    function changeRenamingFee(uint256 _newFee) external;

    function withdrawProfits(uint256 _amount) external;

    event Birth(
        uint256 id,
        string name,
        uint256 firstParent,
        uint256 secondParent,
        uint16 generation
    );

    error ParentStillInPubertyPeriod(uint256 id, uint256 remainingTimeInSecs);
    error ParentsCannotBeEqual();
    error ParentStillInCooldownPeriod(uint256 id, uint256 remainingTimeInSecs);
    error InsufficientSentAmount(uint256 feeToPay);
    error ManagerReservedAction();
    error PigeonOwnerReservedAction();
    error PigeonIdentifierUnknown();
}

interface SimplifiedERC721 {
    function totalSupply() external view returns (uint256 total);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function ownerOf(uint256 _tokenId) external view returns (address owner);

    function transfer(address _to, uint256 _tokenId) external;

    event Transfer(address from, address to, uint256 tokenId);
}


contract CryptoPigeon is CryptoPigeonSpecs, SimplifiedERC721{



  address manager;
  
  uint256 birth_Fee;
  uint256 renaiming_Fee;
  uint256 pubertyPeriod;
  uint256 cooldownPerid;
  uint num_piccioni;  //totale piccioni


  mapping(address => uint) utenti; //Quanti piccioni ha ognuno

  mapping(uint => Pigeon) piccioni; //piccioni al loro id

  mapping(uint => address) proprietari; //id to piccioniuint


  constructor(uint16 _initialPigeons, uint256 _initialPigeonsFixedScore, uint256 _birthFee, uint256 _renamingFee, uint256 _pubertyBlockPeriodInSecs, uint256 _cooldownBlockPeriodInSecs){
    if(_initialPigeons < 2) revert (); //se il numero di piccioni non è almeno due, non è possibile mandare avanti le generazioni
    manager = msg.sender;
    birth_Fee = _birthFee;
    renaiming_Fee = _renamingFee;
    pubertyPeriod = _pubertyBlockPeriodInSecs;
    cooldownPerid = _cooldownBlockPeriodInSecs;

    //adesso cominiciamo a creare i piccioni
    for(uint i = 0; i < _initialPigeons; i++){
      piccioni[num_piccioni].geneticScore = _initialPigeonsFixedScore;
      piccioni[num_piccioni].generation = 0;
      piccioni[num_piccioni].birthTime = block.timestamp;

      utenti[msg.sender]++;
      proprietari[num_piccioni] = msg.sender;
      emit Birth(num_piccioni, piccioni[num_piccioni].name, 0,0,0);
      num_piccioni++;
    }
  }


  modifier onlyManager(){
    if(msg.sender != manager) revert ManagerReservedAction();
    _;
  }




  function pigeonBirth(uint256 firstParent, uint256 secondParent, string calldata name) external payable returns (uint256 _id){
    if(firstParent == secondParent) revert ParentsCannotBeEqual();
    if(proprietari[firstParent] == address(0) || proprietari[secondParent] == address(0)) revert PigeonIdentifierUnknown();
    if(proprietari[firstParent] != msg.sender || proprietari[secondParent] != msg.sender) revert PigeonOwnerReservedAction();
    if(msg.value < birth_Fee) revert InsufficientSentAmount(birth_Fee);
    if(piccioni[firstParent].cooldownEndBlockTime > block.timestamp) revert ParentStillInCooldownPeriod(firstParent, (piccioni[firstParent].cooldownEndBlockTime - block.timestamp));
    if(piccioni[secondParent].cooldownEndBlockTime > block.timestamp) revert ParentStillInCooldownPeriod(secondParent, (piccioni[secondParent].cooldownEndBlockTime - block.timestamp));
    if(piccioni[firstParent].birthTime + pubertyPeriod > block.timestamp) revert ParentStillInPubertyPeriod(firstParent, (piccioni[firstParent].birthTime + pubertyPeriod )- block.timestamp);
    if(piccioni[secondParent].birthTime + pubertyPeriod > block.timestamp) revert ParentStillInPubertyPeriod(secondParent, (piccioni[secondParent].birthTime + pubertyPeriod) - block.timestamp);


    piccioni[num_piccioni].name = name;
    piccioni[num_piccioni].firstParent = firstParent;
    piccioni[num_piccioni].secondParent = secondParent;
    piccioni[num_piccioni].birthTime = block.timestamp;
    piccioni[num_piccioni].generation = (piccioni[firstParent].generation > piccioni[secondParent].generation ? piccioni[firstParent].generation:piccioni[secondParent].generation) + 1;
    
    uint media = (piccioni[firstParent].geneticScore + piccioni[secondParent].geneticScore)/2;
    uint varianza_n = uint256(keccak256(abi.encode(block.timestamp, block.prevrandao)))%(140 - 80 + 1) + 80;  // ho un valore tra 140 e 80 
    if(varianza_n <= 100){//allora è tra 100 e 80
      uint contributo = varianza_n - 80; //ottengo il valore in percentuale tra 0 e 20
      piccioni[num_piccioni].geneticScore = media - ((media * contributo)/100);
    }
    else{ //abbiamo la varianza tra 101 e 140
      uint contributo = varianza_n - 100; //ottengo il valore in percentuale tra 0 e 20
      piccioni[num_piccioni].geneticScore = media + ((media * contributo)/100);
    }
    emit Birth(num_piccioni, piccioni[num_piccioni].name, firstParent,secondParent, piccioni[num_piccioni].generation);
    proprietari[num_piccioni] = msg.sender;
    utenti[msg.sender]++;
    num_piccioni++;
    piccioni[firstParent].cooldownEndBlockTime = block.timestamp + (cooldownPerid * 1 seconds);
    piccioni[secondParent].cooldownEndBlockTime = block.timestamp + (cooldownPerid * 1 seconds);
    return num_piccioni-1;

  }

  function getPigeonData(uint256 _id) external view returns (Pigeon memory){
    if(_id >= num_piccioni) revert PigeonIdentifierUnknown();
    return piccioni[_id];
  }

  function renamePigeon(uint256 _id, string calldata _newName) external payable{
    if(_id >= num_piccioni) revert PigeonIdentifierUnknown();
    if(msg.value < renaiming_Fee) revert InsufficientSentAmount(renaiming_Fee);
    if(msg.sender != proprietari[_id]) revert PigeonOwnerReservedAction();
    piccioni[_id].name = _newName;
  }

  function birthFee() external view returns (uint256){
    return birth_Fee;
  }

  function changeBirthFee(uint256 _newFee) onlyManager external{
    birth_Fee = _newFee;
  }

  function renamingFee() external view returns (uint256){
    return renaiming_Fee;
  }

  function changeRenamingFee(uint256 _newFee) onlyManager external{
    renaiming_Fee = _newFee;
  }

  function withdrawProfits(uint256 _amount) onlyManager external{
    if(_amount > address(this).balance) revert ();
    else{
      payable(manager).transfer(_amount);
    } 
  }

  function totalSupply() external view returns (uint256 total){
    return num_piccioni;
  }

  function balanceOf(address _owner) external view returns (uint256 balance){
    return utenti[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address owner){
    if(_tokenId >= num_piccioni) revert PigeonIdentifierUnknown();
    return proprietari[_tokenId];
  }

  function transfer(address _to, uint256 _tokenId) external{
    if(_tokenId >= num_piccioni) revert PigeonIdentifierUnknown();
    if(proprietari[_tokenId] != msg.sender) revert();
    utenti[msg.sender]--;
    utenti[_to]++;  
    proprietari[_tokenId] = _to;
    emit Transfer(msg.sender, _to, _tokenId);
  }

}
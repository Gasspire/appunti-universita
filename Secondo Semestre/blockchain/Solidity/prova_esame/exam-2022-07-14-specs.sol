
/*
  ##  Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 14/07/2022

  Scrivere un contratto `AuctionManager` che implementi l'interfaccia 
  `AuctionManagerSpecs` usando il linguaggio Solidity per creare un sistema di
  gestione di aste multiple sulla piattaforma Ethereum.

  Il sistema di gestione permettera' a chiunque di creare una nuova asta con
  `createNewAuction` fornendo una descrizione testuale, una eventuale offerta 
  minima e una durata in ore. Ogni asta avra' un proprio `id` univoco e sara' 
  sempre possibile conoscere la lista delle aste attualmente in corso usando
  `idsOfOngoingAuctions`. Chiunque potra' proporre una propria offerta su un'asta
  in corso usando `bidOnAuction` trasferendo gli ETH corrispondenti: tali
  crediti saranno trattenuti dal contratto fino alla conclusione dell'asta. 
  Sara' possibile usare piu' volte `bidOnAuction` per aumentare in modo
  cumulativo la propria offerta attuale.

  Tramite i metodi `auctionDescription`, `auctionMinimumBid`, `auctionExpiration`,
  `auctionBeneficiary`, `auctionState`, `auctionHighestBid`, `auctionHighestBidder`
  sara' sempre possibile richiedere informazioni circa qualunque asta valida
  (conclusa o in corso).

  Una volta scaduta l'asta chiunque potra' finalizzare l'esito tramite 
  `finalizeAuction`: tale metodo trasferira' al beneficiario l'ammontare 
  corrispondente all'offerta piu' alta e restituira' ai rispettivi proprietari i
  crediti delle offerte minori. In caso di offerte massime con lo stesso ammontare
  vincera' sempre l'offerta pervenuta per prima.
  
  Il creatore del contratto manager avra' la facolta' di utilizzare 
  `cancelAuction` per annullare un'asta purche' questa sia ancora in corso e
  non ancora scaduta: in tal caso tutti i crediti relativi a tutte le offerte
  verranno restituite ai relativi offerenti.

  Gli eventi `NewAuction`, `NewHighestBid`, `AuctionEndedWithWinner` e 
  `AuctionExpiredWithoutWinner` dovranno essere opportunamente generati durante
  le varie fasi dell'asta.

  I vari errori previsti dall'interfaccia dovranno essere tutti oppotunamente 
  generati dai metodi interessati.
    
  Infine il contratto dovrà occuparsi di validare gli input ricevuti secondo 
  criteri ovvi di sensatezza.
*/ 

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface AuctionManagerSpecs {
  enum AuctionState {Ongoing, EndedWithWinner, Expired, Canceled}

  function createNewAuction(string memory description, uint minimumBid, uint expirationInHours) external returns (uint id);
  function bidOnAuction(uint id) external payable returns (bool isHighest);
  function idsOfOngoingAuctions() external returns (uint[] memory ids);
  function auctionDescription(uint id) external view returns (string memory);
  function auctionMinimumBid(uint id) external view returns (uint amount);
  function auctionExpiration(uint id) external view returns (uint timestamp);
  function auctionBeneficiary(uint id) external view returns (address beneficiary);
  function auctionState(uint id) external returns (AuctionState);
  function auctionHighestBid(uint id) external view returns (uint amount);
  function auctionHighestBidder(uint id) external view returns (address bidder);
  function finalizeAuction(uint id) external;
  function cancelAuction(uint id) external;
  
  event NewAuction(string description, uint minimumBid, uint expiration);
  event NewHighestBid(uint auctionId, address bidder, uint amount);
  event AuctionEndedWithWinner(uint auctionId, address winner, uint amount);
  event AuctionExpiredWithoutWinner(uint auctionId);

  error AuctionNotExisting();
  error BidNotAboveMinimum(uint minimumBid);
  error AuctionAlreadyEnded(AuctionState state);
  error AuctionToFinalizeNotYetEnded(uint expiration);
  error AuctionToFinalizeAlreadyFinalized();
}



contract AuctionManager is AuctionManagerSpecs{
  address owner;
  uint256 num_aste=0;
  mapping(uint256 => Auction) aste;
  uint[] aste_in_corso;

  constructor(){
    owner = msg.sender;
  }

  struct Auction{
    uint256 id;
    address payable beneficiario;
    string description;
    uint256 minBid;
    uint256 highestBid;
    address curr_highest;

    uint curr_date;
    uint scadenza;

    mapping(address => uint256) offerte;
    mapping(address => uint8) lista_offerte;
    address[] offerenti;
    AuctionState state;
  }










  //funzione che permette la creazione di una nuova asta
  function createNewAuction(string memory description, uint minimumBid, uint expirationInHours) external returns (uint id){
    
    Auction storage a = aste[num_aste];

    a.id = num_aste;
    a.beneficiario = payable(msg.sender);
    a.highestBid = 0;
    a.description = description;
    a.minBid = minimumBid;
    a.scadenza = expirationInHours;
    a.state = AuctionState.Ongoing;
    a.curr_date = block.timestamp;

    aste_in_corso.push(a.id);
    num_aste++;
    return a.id;
  }

  modifier onGoing(uint id){
    require(aste[id].state == AuctionState.Ongoing, "Mi dispiace, l'asta a cui vuoi partecipare non e piu in corso!");
    _;
  }

  function checkEnd(uint id) internal{
    uint actual_timestamp = block.timestamp;
    if((actual_timestamp-aste[id].curr_date) > 20 hours){ // se il tempo è scaduto, ci sono due esiti: o c'è un vincitore o è scaduta
      if(aste[id].)
    }

  }


  function bidOnAuction(uint id) external onGoing(id) payable returns (bool isHighest){
    uint actual_timestamp = block.timestamp;
    if((actual_timestamp-aste[id].curr_date) > 20 hours){
      //controllo per la vincita
    }


    require(msg.value >= aste[id].minBid,"La tua offerta non e' stata accettata perche troppo bassa");
    aste[id].offerte[msg.sender] += msg.value;
    if(aste[id].lista_offerte[msg.sender] == 0){
      aste[id].lista_offerte[msg.sender] = 1;
      aste[id].offerenti.push(msg.sender);
    } 
    if(aste[id].highestBid < aste[id].offerte[msg.sender]){
      aste[id].highestBid = aste[id].offerte[msg.sender];
      aste[id].curr_highest = msg.sender;
      return true;
    }
    else{
      return false;
    }
  }

  function idsOfOngoingAuctions() external view returns (uint[] memory ids){
    return aste_in_corso;
  }

  function auctionDescription(uint id) external view returns (string memory){
    return aste[id].description;
  }

  function auctionMinimumBid(uint id) external view returns (uint amount){
    return aste[id].minBid;
  }
  function auctionExpiration(uint id) external view returns (uint timestamp){
    return aste[id].scadenza;
  }
  function auctionBeneficiary(uint id) external view returns (address beneficiary){
    return aste[id].beneficiario;
  }
  function auctionState(uint id) external view returns (AuctionState){
    return aste[id].state;
  }
  function auctionHighestBid(uint id) external view returns (uint amount){
    return aste[id].highestBid;
  }
  function auctionHighestBidder(uint id) external view returns (address bidder){
    return aste[id].curr_highest;
  }
  function finalizeAuction(uint id) external{}
  function cancelAuction(uint id) external{}
  
}
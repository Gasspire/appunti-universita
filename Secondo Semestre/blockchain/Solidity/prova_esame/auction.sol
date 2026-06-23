
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
//PER QUESTIONI DI TESTING SARANNO FATTI IN MINUTI E NON ORE ALTRIMENTI NON NE ESCO PIU 
    struct Asta{
        uint id;
        string description;
        address beneficiario;
        uint offerta_minima;
        uint scadenza;


        uint offerta_alta;
        address vincitore_corrente;

        AuctionState stato_asta;

        bool finalized_yet;
        mapping(address => uint) offerta;
        mapping(address => bool) is_offerente;
        address[] offerenti;
    }   
    
    
    address manager;

    uint[] aste_attive;
    mapping(uint => uint) id_to_index;
    mapping(uint => Asta) aste;

    uint num_aste;
    
    constructor(){
        manager = msg.sender;
    }

    modifier checkAste(uint id){
        if(id >= num_aste) revert AuctionNotExisting();
        _;
    }

    function createNewAuction(string memory description, uint minimumBid, uint expirationInHours) external returns (uint id){
        if(expirationInHours == 0) revert("Serve che l'asta duri almeno 1 ora");
        
        aste_attive.push();
        aste_attive[num_aste] = num_aste;

        Asta storage a = aste[num_aste];
        a.id = num_aste;
        a.description = description;
        a.beneficiario = msg.sender;
        a.offerta_minima = minimumBid;
        a.scadenza = block.timestamp + (expirationInHours * 1 minutes);
        a.stato_asta = AuctionState.Ongoing;

        num_aste++;
        emit NewAuction(a.description, a.offerta_minima, (a.scadenza - block.timestamp)/1 minutes);
    }

    function bidOnAuction(uint id) external checkAste(id) payable returns (bool isHighest){//aggiungere funzione che faccia il finalize!
        aste[id].offerta[msg.sender] += msg.value;
        if(aste[id].offerta[msg.sender] < aste[id].offerta_minima) revert BidNotAboveMinimum(aste[id].offerta_minima);
        if(aste[id].is_offerente[msg.sender] == false){//questa è la sua prima offerta
            aste[id].is_offerente[msg.sender] = true;
            aste[id].offerenti.push(msg.sender);
        } 
        if(aste[id].offerta[msg.sender] > aste[id].offerta_alta){ // mettiamo solo il maggiore così anche in caso sia uguale prende quella arrivata prima!
            aste[id].vincitore_corrente = msg.sender;
            aste[id].offerta_alta = aste[id].offerta[msg.sender];
            emit NewHighestBid(id, msg.sender, aste[id].offerta_alta);
            return true;
        }
        else return false;
    }

    function idsOfOngoingAuctions() external view returns (uint[] memory ids){ //Capiamo dopo se fare l'eliminazione e togliere view
        return aste_attive;
    }

    function auctionDescription(uint id) external checkAste(id) view returns (string memory){
        return aste[id].description;
    }

    function auctionMinimumBid(uint id) external checkAste(id) view returns (uint amount){
        return aste[id].offerta_minima;
    }

    function auctionExpiration(uint id) external checkAste(id) view returns (uint timestamp){
        return (aste[id].scadenza);
    }

    function auctionBeneficiary(uint id) external checkAste(id) view returns (address beneficiary){
        return aste[id].beneficiario;
    }

    function auctionState(uint id) external view checkAste(id) returns (AuctionState){ //vediamo se fare il controllo e togliere view
        return aste[id].stato_asta;
    }

    function auctionHighestBid(uint id) external checkAste(id) view returns (uint amount){
        return aste[id].offerta_alta;
    }

    function auctionHighestBidder(uint id) external checkAste(id) view returns (address bidder){
        return aste[id].vincitore_corrente;
    }

    function finalizeAuction(uint id) checkAste(id) external{
        if(aste[id].scadenza > block.timestamp) revert AuctionToFinalizeNotYetEnded((aste[id].scadenza - block.timestamp)/1 minutes); //asta non ancora scaduta
        if(aste[id].finalized_yet == true) revert AuctionToFinalizeAlreadyFinalized(); //asta già finalizzata
        if(aste[id].offerenti.length == 0){
            aste[id].finalized_yet = true;
            aste[id].stato_asta = AuctionState.Expired;
            emit AuctionExpiredWithoutWinner(id);
            return;
        }
        else{
            

        }
    }

    function cancelAuction(uint id) checkAste(id) external{}
}

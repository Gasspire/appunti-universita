/*
    Corso Blockchain e Cryptocurrencies - Compito di laboratorio del 12/07/2021

    Scrivere un contratto `CorporateManagement` che implementi l'interfaccia `CorporateManagementSpecs`
    per la gestione delle decisioni di una società sulla piattaforma Ethereum usando il linguaggio Solidity.

    All'interno della società ci possono essere una serie di soci (associates): il primo è il fondatore che
    crea il contratto stesso con relativa quota (share). Gli altri soci si possono auto-candidare depositando
    una quota sufficiente: tale candidatura viene considerata accettata solo se accettata a maggioranza dai
    soci attuali. Ogni socio può depositare una generica proposta, consistente in una semplice descrizione
    testuale: essa sarà considerata accettata se votata a maggioranza dai soci. Il voto per maggioranza (50% + 1)
    tiene conto del peso della quota in ETH depositata da ogni socio.
    La società, su proposta di qualche socio, può essere anche sciolta purché la risoluzione venga votata 
    all'unanimità.

    Di seguito alcuni dettagli sui singoli elementi obbligatori dell'interfaccia:
    - tutti i casi illustrati sopra vengono considerti come proposte da accettare: le tipologie di proposte 
      corrispondono all'enumerazione `ProposalCategory`;
    - il primo socio (fondatore) crea il contratto specificando la quota minima e versando, contestualmente, la
      propria di quota sufficiente;
    - il metodo `depositFunds` può essere usato da chiunque per auto-candidarsi a socio, versando la relativa
      sufficiente quota; il metodo può essere usato sia dai soci che da candidati-soci per aumentare la propria 
      quota;
    - il metodo `voteProposal`, utilizzabile solo dai soci effettivi, può essere usato per aderire, con la propria
      quota, all'accettazione della proposta tramite l'apposito identificativo; ovviamente un socio può votare una
      sola volta per ogni singola proposta, tale metodo dovrà anche verificare se la proposta ha raggiunto i voti 
      necessari e far scaturire i relativi effetti;
    - i metodi `depositGenericProposal` e `depositDissolutionProposal` permettono, unicamente ai soci, di depositare,
      rispettivamente, una generica proposta con descrizione testuale o una proposta di scioglimento;
    - nel caso in cui una proposta di scioglimento venga accettata all'unanimità la società va in liquidazione e pertanto
      nessuna funzionalità avrà più effetti ad eccezione del metodo `requestShareRefunding` che permette al singolo
      socio di riscuotere la propria quota;
    - i predicati `isAssociated` e `isDissoluted` permettono, rispettivamente, di verificare se un indirizzo specificato
      corrisponde ad un socio effettivo o se la società è in scioglimento;
    - gli eventi di tipo `New...` dovranno essere generati quando una proposta viene creata a seguito di un'azione 
      esterna; depositare dei fondi sufficienti da parte di un non-socio rappresenta una proposta di candidatura;
    - gli eventi di tipo `Accepted....` dovranno essere generati ogniqualvolta una relativa proposta viene accettata;
      notare che all'atto della creazione della società il socio fondatore è implicitamente accettato.
    
    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface CorporateManagementSpecs {
    enum ProposalCategory {
        NewAssociationAcceptance,
        Generic,
        CorporateDissolution
    }

    /* constructor(uint minimumAssociatingShare) payable */

    function depositFunds() external payable;
    function voteProposal(uint proposalId) external;
    function depositGenericProposal(string calldata description) external;
    function depositDissolutionProposal() external;
    function requestShareRefunding() external;
    function isAssociated(address id) external returns (bool);
    function isDissoluted() external returns (bool);

    event NewAssociateCandidate(uint proposalId, address id);
    event NewGenericProposal(uint proposalId, string description);
    event NewDissolutionProposal(uint proposalId);
    event AcceptedAssociate(address id);
    event AcceptedGenericProposal(string description);
    event AcceptedCorporateDissolution();
}



contract CorporateManagement is CorporateManagementSpecs{
  enum Stato_proposta{Pending, Accepted}
  enum Stato_corp{OnGoing, Dissoluted}



  struct Proposta{
    address proposer;
    uint256 quota;
    ProposalCategory category; // tipo di proposta
    string description; // descrizione della proposta
    uint256 quota_voti;
    mapping(address => uint8) votanti; //mapping che tiene conto di chi ha votato. Quando si vota votanti[address] = 1 mentre di default è 0, cioè non votato.
    Stato_proposta status; //stato dopo il quale la proposta non accetterà più nuovi voti
  }


  uint256 minimumAssociatingShare; //Quota necessaria per diventare soci
  uint256 num_soci; //numero di soci
  uint256 num_proposte; //numero di proposte attuali
  uint256 totale_quote;
  mapping(address => uint256) candidati;
  mapping(address => uint256) soci; //Mappa che tiene conto del saldo che ogni socio ha e che, di conseguenza, ci dice se un indirizzo è o no un socio
  mapping(uint256 => Proposta) proposte; //mappa che tiene conto di tutte le proposte effettuate. Sarà del tipo proposte[id] dove l'id sarà un campo aggiornato di volta in volta e, essendo Ethereum di per sé sequenziale nell'eseguire transazioni, non ci sono rischi di race condition
  Stato_corp stato;

  constructor(uint256 _minshare) payable{
    minimumAssociatingShare = _minshare;
    require(minimumAssociatingShare <= msg.value, "Hai versato meno di quanto proposto!");
    num_soci = 1;
    num_proposte = 0; 
    soci[msg.sender] =  msg.value; // automaticamente promosso a socio
    stato = Stato_corp.OnGoing;
    totale_quote = msg.value;
    emit AcceptedAssociate(msg.sender);
  }



  modifier onlySoci(){
    require(soci[msg.sender] >= minimumAssociatingShare);
    _;
  }

  modifier onlyOnGoing(){
    require(stato == Stato_corp.OnGoing);
    _;
  }

  //funzione che fa scattare una nuova proposta di new candidate
  function depositFunds() external onlyOnGoing payable{  
    if(soci[msg.sender] >= minimumAssociatingShare){
      //gestiamo i soci
      totale_quote += msg.value;
      soci[msg.sender] += msg.value;
      return;
    }
    else{
      if(proposte[candidati[msg.sender]].proposer == msg.sender && proposte[candidati[msg.sender]].status == Stato_proposta.Pending){
        proposte[candidati[msg.sender]].quota +=msg.value;
        return;
      }
      require(msg.value >= minimumAssociatingShare, "Devi versare almeno la quota minima!");
      Proposta storage p = proposte[num_proposte];
      p.proposer = msg.sender;
      p.category = ProposalCategory.NewAssociationAcceptance;
      p.description = "";
      p.quota = msg.value;
      p.quota_voti = 0;

      p.status = Stato_proposta.Pending;
      candidati[msg.sender] = num_proposte;


      emit NewAssociateCandidate(num_proposte, p.proposer);
      num_proposte++;
    }
  }


  function isAccepted(uint proposalId)internal returns(bool){
    if(proposte[proposalId].category != ProposalCategory.CorporateDissolution){
      //calcoliamo quanto è il 50% più 1 in funzione della quote versate!
      uint256 necessaryQuorum = (totale_quote/2) +1;
      
      //se la quota è raggiunta, allora la proposta è stata accettata!
      if(proposte[proposalId].quota_voti >= necessaryQuorum){
        if(proposte[proposalId].category == ProposalCategory.NewAssociationAcceptance){
          address newAssociate = proposte[proposalId].proposer;
          num_soci++;
          totale_quote += proposte[proposalId].quota;
          emit AcceptedAssociate(newAssociate);
          proposte[proposalId].status = Stato_proposta.Accepted;
          soci[newAssociate] += proposte[proposalId].quota;
          return true;
        }
        else{
          proposte[proposalId].status = Stato_proposta.Accepted;
          emit AcceptedGenericProposal(proposte[proposalId].description);
          return true;
        }
      }
    }
    else if(proposte[proposalId].category == ProposalCategory.CorporateDissolution){
      if(proposte[proposalId].quota_voti == totale_quote){
        proposte[proposalId].status = Stato_proposta.Accepted;
        stato = Stato_corp.Dissoluted;
        emit AcceptedCorporateDissolution();
        return true;
      }
    }
    return false;
  }


  function voteProposal(uint proposalId) onlySoci onlyOnGoing external{
    require(proposte[proposalId].status == Stato_proposta.Pending, "La proposta e' gia' stata accettata");
    require(proposte[proposalId].votanti[msg.sender] != 1,"Non puoi votare due volte");
    proposte[proposalId].votanti[msg.sender] = 1;
    proposte[proposalId].quota_voti += soci[msg.sender];
    isAccepted(proposalId);
  }


  function depositGenericProposal(string calldata description) onlySoci onlyOnGoing external{
    Proposta storage p = proposte[num_proposte];
    p.proposer = msg.sender;
    p.category = ProposalCategory.Generic;
    p.description = description;
    p.quota_voti = 0;
    p.status = Stato_proposta.Pending;

    emit NewGenericProposal(num_proposte, description);
    num_proposte++;
  }
  function depositDissolutionProposal()onlySoci onlyOnGoing external{
    Proposta storage p = proposte[num_proposte];
    p.proposer = msg.sender;
    p.category = ProposalCategory.CorporateDissolution;
    p.status = Stato_proposta.Pending;
    p.quota_voti = 0;

    emit NewDissolutionProposal(num_proposte);
    num_proposte++;
  }


  function requestShareRefunding() external{
    require(stato == Stato_corp.Dissoluted,"La corporazione non si e' ancora sciolta");
    if(soci[msg.sender] >= minimumAssociatingShare){
      uint256 importo = soci[msg.sender];
      soci[msg.sender] = 0;
      payable(msg.sender).transfer(importo);
    }
    else if(proposte[candidati[msg.sender]].proposer == msg.sender && proposte[candidati[msg.sender]].status == Stato_proposta.Pending){
      uint256 importo = proposte[candidati[msg.sender]].quota;
      proposte[candidati[msg.sender]].quota = 0;
      payable(msg.sender).transfer(importo);
    } 

  }


  function isAssociated(address id) external view returns (bool){
    if(soci[id] >= minimumAssociatingShare) return true;
    else return false;
  }

  function isDissoluted() external view returns (bool){
    if(stato == Stato_corp.Dissoluted) return true;
    else return false;
  }

}
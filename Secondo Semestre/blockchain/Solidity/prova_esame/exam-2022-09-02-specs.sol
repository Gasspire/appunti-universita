
/*
  ## Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 02/09/2022

  ##############################################################################

  Scrivere un contratto `UnblindElection` che implementi l'interfaccia 
  `UnblindElectionSpecs` usando il linguaggio Solidity per creare un sistema 
  di elezioni con un singolo vincitore sulla piattaforma Ethereum.

  Una elezione prevede un insieme di elettori (`Voters`) che possono esprimere 
  il proprio voto; in una prima fase qualunque elettore può candidarsi e, 
  ricevuta l'accettazione, ricevere voti nella fase successiva di voto.

  Il creatore del contratto (`President`) deciderà quanti giorni dureranno,
  rispettivamente, le fasi di candidatura e di voto. Stabilirà anche un 
  quorum minimo percentuale (un intero tra 0 e 99) che una elezione valida 
  dovrà raggiungere.
  Solo il presidente potrà registrare gli elettori tramite i metodi `addVoter` e
  `addVoters`, riportando eventualmente l'errore `PresidentReservedAction`.

  Nella fase di candidatura chiunque può candidarsi o essere candidato tramite i 
  metodi `candidateMySelf` e `candidateSomeoneElse`. Questi potrebbero generare
  i seguenti errori: `CandidationPhaseAlreadyClosed` o `CandidateHasToBeAVoter`.

  Solo il presidente, in tutte le fasi, può accettare una candidatura tramite
  i metodi `acceptCandidation` e `acceptCandidations`; questi metodi genereranno
  l'evento `AcceptedCandidation` o un dei seguenti errori: `ItIsNotACandidate` o
  `PresidentReservedAction`.
  Chiunque può ottenere la lista dei candidati attualmente accettati tramite il
  metodo `getAcceptedCandidates`.

  Nella fase successiva di voto qualunque votante noto può usare il metodo
  `vote` per esercitare il proprio diritto di voto: solo un candidato accettato
  potrà essere votato e si potrà esprimere solo un voto per l'intera elezione.
  Il metodo potrebbe generare i seguenti errori: `VotingPhaseNotYetOpen`, 
  `VotingPhaseAlreadyClosed`, `OnlyKnownVotersCanVote`, 
  `OnlyAcceptedCandidatesCanBeVoted` o `OnlyOneVotePerVoter`.

  Quando la fase di voto sarà chiusa il presidente potrà usare metodo 
  `closeElection` per emanare il risultato: affinché una elezione sia ritenuta
  valida dovranno sussistere tutte le seguenti condizioni:
  - ci dovrà essere almeno un votante noto introdotto dal presidente;
  - ci dovrà essere stato almeno un candidato accettato dal presidente;
  - si dovrà essere registrato almeno un voto valido;
  - il vincitore dovrà avere almeno un voto di scarto rispetto all'eventuale
    secondo (non ci possono essere ex aequo).
  Il metodo generare l'evento `ElectionRegularlyClosed` o uno dei seguenti
  errori: `ElectionClosedWithoutQuorum` o `ElectionClosedWithAnInvalidResult`.

  Infine il contratto dovrà occuparsi di validare gli input ricevuti secondo
  criteri ovvi di sensatezza.
*/ 

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface UnblindElectionSpecs {
  /* constructor(uint candidationDays, uint votingDays, uint8 quorumPercent); */

  function addVoter(address voter) external;
  function addVoters(address[] calldata voters) external;

  function candidateMySelf() external;
  function candidateSomeoneElse(address candidate) external;

  function acceptCandidation(address candidate) external;
  function acceptCandidations(address[] calldata candidates) external;

  function getAcceptedCandidates() external view returns (address[] memory candidates);


  function vote(address candidate) external;


  function closeElection() external returns (bool valid);

  error PresidentReservedAction();
  error CandidationPhaseAlreadyClosed();
  error CandidateHasToBeAVoter();
  error ItIsNotACandidate();
  error VotingPhaseNotYetOpen();
  error VotingPhaseAlreadyClosed();
  error VotingPhaseNotYetClosed();
  error OnlyKnownVotersCanVote();
  error OnlyAcceptedCandidatesCanBeVoted();
  error OnlyOneVotePerVoter();
  error ElectionClosedWithoutQuorum();
  error ElectionClosedWithAnInvalidResult();

  event AcceptedCandidation(address candidate);
  event ElectionRegularlyClosed(address winner);
}

contract UnblindElection is UnblindElectionSpecs{
  address president;
  uint candidate_days_end;
  uint voting_days_end;
  uint8 quorum;

  address election_winner;

  mapping(address => uint8) votanti;
  address[] votanti_list;

  mapping(address => uint8) candidati;
  address[] candidati_list;

  mapping(address => uint8) accettati;
  address[] accettati_list;

  mapping(address => uint256) voti_per_candidato;
  mapping(address => uint8) votante_ha_votato;

  constructor(uint candidationDays, uint votingDays, uint8 quorumPercent){
    if(quorum >= 100 || quorum < 0) revert();
    if(candidationDays == 0 || votingDays == 0) revert();
    president = msg.sender;
    candidate_days_end = block.timestamp + (candidationDays * 1 days);
    voting_days_end = candidate_days_end + (votingDays * 1 days);
    quorum = quorumPercent;
  }


  modifier onlyPresident(){
    if(msg.sender != president) revert PresidentReservedAction();
    _;
  }

  
  modifier onlyCandidatePhase(){
    uint curr_date = block.timestamp;
    if(curr_date > candidate_days_end) revert CandidationPhaseAlreadyClosed();
     _;
  }

  modifier onlyVotePhase(){
    uint curr_date = block.timestamp;
    if(curr_date < candidate_days_end) revert VotingPhaseNotYetOpen(); //errori erano invertiti
    else if(curr_date >  voting_days_end) revert VotingPhaseAlreadyClosed();
     _;
  }



  function addVoter(address voter) onlyPresident external{
    if(voter == address(0))revert();
    if(votanti[voter] == 1) revert(); // il voters è già stato segnato

    votanti[voter] = 1;
    votanti_list.push(voter);
    return;
  }
  function addVoters(address[] calldata voters) onlyPresident external{
    uint n = voters.length;
    for(uint i = 0; i < n; i++){
      if(voters[i] == address(0)) revert();
      if(votanti[voters[i]] == 1) revert(); // il voters è già stato segnato

      votanti[voters[i]] = 1;
      votanti_list.push(voters[i]);
    }
  }


  function candidateMySelf() onlyCandidatePhase external{
    if(candidati[msg.sender] == 1) revert(); // è già stato candidato
    if(votanti[msg.sender] != 1) revert CandidateHasToBeAVoter(); // se il sender non è presente nella lista dei votanti, allora non può essere candidato
    candidati[msg.sender] = 1; //lo segnamo nella lista dei candidati
    candidati_list.push(msg.sender);
  }
  function candidateSomeoneElse(address candidate) onlyCandidatePhase external{ //stessa logica di prima
    if(candidati[candidate] == 1) revert(); // è già stato candidato
    if(votanti[candidate] != 1) revert CandidateHasToBeAVoter(); // se il sender non è presente nella lista dei votanti, allora non può essere candidato
    candidati[candidate] = 1; //lo segnamo nella lista dei candidati
    candidati_list.push(candidate);
  }


  function acceptCandidation(address candidate) onlyPresident external{
    if(accettati[candidate]== 1) revert(); //il candidate è già stato accettato
    if(candidati[candidate] != 1) revert ItIsNotACandidate();

    accettati[candidate] = 1;
    accettati_list.push(candidate);
    emit AcceptedCandidation(candidate);
  }
  function acceptCandidations(address[] calldata candidates) onlyPresident external{
    uint n = candidates.length;

    for (uint i = 0; i < n; i++) 
    {
      if(accettati[candidates[i]] == 1) revert(); 
      if(candidati[candidates[i]] != 1) revert ItIsNotACandidate();
      accettati[candidates[i]] = 1;
      accettati_list.push(candidates[i]);
      emit AcceptedCandidation(candidates[i]);
    }
  }



  function getAcceptedCandidates() external view returns (address[] memory candidates){
    return accettati_list;
  }

  function vote(address candidate) onlyVotePhase external{
    if(votanti[msg.sender] != 1) revert OnlyKnownVotersCanVote();
    if(votante_ha_votato[msg.sender] != 0) revert OnlyOneVotePerVoter();
    if(accettati[candidate] != 1) revert OnlyAcceptedCandidatesCanBeVoted();

    votante_ha_votato[msg.sender]++; //mancava il controllo
    voti_per_candidato[candidate]++;
  }


  function closeElection() onlyPresident external returns (bool valid){
    if(block.timestamp < voting_days_end) revert VotingPhaseNotYetClosed(); // non si è ancora conclusa la fase di voto

    address winner; 
    uint256 vote_of_winner;

    address second;
    uint256 vote_of_second;
    
    uint n_accettati = accettati_list.length;
    uint n_votanti = votanti_list.length;
    uint total_number_of_vote = 0;

    if(n_accettati == 0) revert ElectionClosedWithAnInvalidResult(); // non è stato accettato nessun candidato. L'errore di prima è che non è possibile che un uint sia < 0
    if(n_votanti == 0) revert ElectionClosedWithAnInvalidResult(); //non c'era alcun votante. 
    for(uint i=0; i < n_accettati;i++){
      address curr_accettato = accettati_list[i];
      total_number_of_vote += voti_per_candidato[curr_accettato]; //tengo il conto dei votanti
      if(voti_per_candidato[curr_accettato] > vote_of_winner){
        second = winner; //facciamo scalare alla seconda posizione
        vote_of_second = vote_of_winner;

        winner = curr_accettato;
        vote_of_winner = voti_per_candidato[winner];
      }
      else if(voti_per_candidato[curr_accettato] > vote_of_second){
        second = curr_accettato;
        vote_of_second = voti_per_candidato[second];
      }
    }
    if (total_number_of_vote == 0) revert ElectionClosedWithAnInvalidResult(); //nessuno ha votato
    uint percentuale_votanti = (100 * total_number_of_vote)/n_votanti;
    if(percentuale_votanti < quorum) revert ElectionClosedWithoutQuorum();
    if((vote_of_winner - vote_of_second) < 1) revert ElectionClosedWithAnInvalidResult(); // non c'è stata una differenza di almeno uno

    election_winner = winner;

    emit ElectionRegularlyClosed(election_winner);
    return true;
  }

}
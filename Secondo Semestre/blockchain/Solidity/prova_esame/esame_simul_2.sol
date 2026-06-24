/*
    Corso Blockchain e Cryptocurrencies - Esercitazione di laboratorio (Simulazione 2)

    Scrivere un contratto `CondominiumAssembly` che implementi l'interfaccia `CondominiumAssemblySpecs`
    usando il linguaggio Solidity per la gestione delle delibere condominiali sulla piattaforma Ethereum.

    Il creatore del contratto è l'Amministratore, il quale può registrare i vari condòmini 
    usando il metodo `addCondomino`, assegnando a ciascun indirizzo i propri millesimi di proprietà 
    (la somma totale dei millesimi assegnati nel contratto non deve mai superare 1000).

    Ogni condomino registrato può presentare una proposta di delibera (es. "Rifacimento facciata") 
    tramite il metodo `submitProposal`. Ogni proposta riceve un ID sequenziale.
    
    Una volta creata, una proposta entra immediatamente in fase di votazione. I condòmini possono 
    votare a favore o contro tramite `voteProposal(uint proposalId, bool support)`. Il peso 
    del voto di ogni condomino è pari ai suoi millesimi. Ovviamente, un condomino può votare 
    una sola volta per ogni singola proposta.

    L'amministratore (e solo lui) può chiudere la votazione su una proposta tramite il metodo `closeVoting`. 
    Una volta chiusa, la proposta è considerata "Approvata" se ha ricevuto voti favorevoli che rappresentano 
    la maggioranza assoluta dei millesimi totali registrati nel condominio fino a quel momento 
    (es. se l'amministratore ha registrato condomini per un totale di 800 millesimi, servono più 
    di 400 millesimi a favore). In caso contrario, è considerata "Respinta".

    Tramite i metodi di lettura (getter) sarà sempre possibile richiedere informazioni sullo stato 
    di una determinata proposta.

    Gli eventi indicati dovranno essere emessi opportunamente.
    Generare gli errori appropriati (es. azioni esclusive per l'amministratore, superamento limite 
    millesimi, doppio voto, ecc.).
    
    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.
*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface CondominiumAssemblySpecs {
    
    enum ProposalStatus { Voting, Approved, Rejected }

    struct Proposal {
        address proposer;
        string description;
        ProposalStatus status;
        uint positiveVotesMillesimals;
        uint negativeVotesMillesimals;
    }

    // Aggiunge un condomino e i suoi millesimi (Solo Amministratore)
    function addCondomino(address condomino, uint millesimi) external;

    // Crea una proposta (Solo condomini registrati)
    function submitProposal(string calldata description) external returns (uint proposalId);

    // Vota una proposta: support = true (favorevole), false (contrario)
    function voteProposal(uint proposalId, bool support) external;

    // Chiude la votazione e calcola l'esito (Solo Amministratore)
    function closeVoting(uint proposalId) external;

    // Metodi di sola lettura
    function getCondominoMillesimi(address condomino) external view returns (uint);
    function getTotalRegisteredMillesimals() external view returns (uint);
    function getProposalInfo(uint proposalId) external view returns (string memory description, ProposalStatus status);

    // Eventi
    event CondominoAdded(address condomino, uint millesimi);
    event NewProposal(uint proposalId, string description, address proposer);
    event VoteCast(uint proposalId, address voter, bool support, uint weight);
    event ProposalClosed(uint proposalId, ProposalStatus finalStatus);

    // Errori Custom
    error AdminReservedAction();
    error CondominoReservedAction();
    error MillesimiLimitExceeded(uint requested, uint available);
    error ProposalNotExisting();
    error ProposalNotOpen();
    error AlreadyVoted();
}
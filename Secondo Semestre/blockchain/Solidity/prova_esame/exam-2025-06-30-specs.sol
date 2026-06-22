/*
    Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 30/06/2025

  Scrivere un contratto `DecentralizedCreatorSubscriptionFund` che implementi l'interfaccia `DecentralizedCreatorSubscriptionFundSpecs` con lo scopo di realizzare un sistema decentralizzato per la gestione di sottoscrizioni periodiche (mensili) e la distribuzione automatizzata di fondi a creatori di contenuti. L'idea centrale è che gli utenti possano sostenere i creatori attraverso un fondo comune, e la ripartizione di tale fondo tra i creatori sia decisa e gestita da un'entità centrale, il "Manager" (il deployer del contratto), che assegna "punteggi di popolarità" (assimilabili a "voti") ai creatori.
  
  Lo smart-contract prevede delle sottoscrizioni periodiche in cui gli utenti possono sottoscrivere o rinnovare una sottoscrizione mensile versando un importo predefinito in ETH.
  Il Manager è l'unica entità autorizzata a:
  - aggiungere o rimuovere creatori dall'elenco dei beneficiari;
  - aggiornare i punteggi di popolarità dei creatori, che influenzeranno la quota di fondi ricevuta;
  - modificare l'importo della sottoscrizione mensile;
  - innescare la distribuzione dei fondi raccolti.
  
  Lo smart-contract si occuperà di distribuire i fondi accumulati dalle sottoscrizioni ai creatori in proporzione ai loro punteggi di popolarità. Esso dovrà garantire la validazione degli input secondo criteri di sensatezza, la corretta gestione degli stati e l'emissione di eventi per notificare le azioni significative e i cambiamenti di stato.

  Di seguito sono descritti i prototipi dei metodi, eventi ed errori che il contratto dovrà implementare:
  - costruttore: l'indirizzo che effettua il deployment diventerà il Manager del fondo e sarà una caratteristica "immutabile" dello stesso: dovrà essere specificato un importo iniziale (`_initialMonthlySubscriptionAmount`) che rappresenterà il costo della sottoscrizione mensile in Wei;
  - metodo `subscribe()`: permette a un utente di sottoscrivere o rinnovare la propria sottoscrizione; la funzione deve essere payable e accettare esattamente l'importo specificato in `monthlySubscriptionAmount`; se l'importo inviato non corrisponde esattamente a quello richiesto, l'operazione deve fallire; può lanciare un evento `Subscribed` o un errore `IncorrectSubscriptionAmount`;
  - metodo `cancelSubscription()`: consente a un sottoscrittore attivo di annullare la propria sottoscrizione; i fondi pagati per il periodo di sottoscrizione corrente non verranno rimborsati; può emettere un evento `SubscriptionCancelled` o un errore `NoActiveSubscription`.
  - metodo `addCreator(address _creator)`: permette al Manager di aggiungere un nuovo indirizzo alla lista dei creatori registrati che possono ricevere fondi; questo metodo deve essere richiamabile solo dal Manager; può generare un evento `CreatorAdded` o gli errori `ManagerReservedAction`, `CreatorAlreadyRegistered`;
  - metodo `removeCreator(address _creator)`: permette al Manager di rimuovere un creatore dalla lista: un creatore rimosso non sarà più idoneo a ricevere fondi; questo metodo deve essere richiamabile solo dal Manager; può emettere un evento `CreatorRemoved` o gli errori `ManagerReservedAction`, `CreatorNotRegistered`;
  - metodo `updateCreatorScore(address _creator, uint256 _newScore)`: permette al Manager di aggiornare il punteggio di popolarità (_newScore) di un creatore registrato; questo punteggio (un intero non-negativo) è fondamentale per determinare la quota di fondi che il creatore riceverà durante la distribuzione; questo metodo deve essere richiamabile solo dal Manager; può emettere un evento `CreatorScoreUpdated` o gli errori `ManagerReservedAction`, `CreatorNotRegistered`.
  - metodo `setMonthlySubscriptionAmount(uint256 _newAmount)`: permette al Manager di modificare l'importo (positivo) in Wei richiesto per la sottoscrizione mensile; questo influenzerà le future sottoscrizioni; questo metodo deve essere richiamabile solo dal Manager; può emettere l'evento `MonthlySubscriptionAmountChanged` o l'errore `ManagerReservedAction`.
  - metodo `distributeFunds()`: permette al Manager di innescare la distribuzione dei fondi ETH accumulati nel contratto ai creatori registrati; i fondi saranno distribuiti proporzionalmente in base ai loro punteggi di popolarità; questa operazione dovrebbe trasferire l'intero saldo disponibile per la distribuzione; questo metodo deve essere richiamabile solo dal Manager; può emettere l'evento `FundsDistributed` o gli errori `ManagerReservedAction`, `NoFundsToDistribute`, `NoCreatorsRegistered`.
  - metodo view `manager()`: restituisce l'indirizzo del Manager del contratto;
  - metodo view `monthlySubscriptionAmount()`: restituisce l'attuale importo (in Wei) richiesto per la sottoscrizione mensile;
  - metodo view `isCreator(address _creator)`: restituisce `true` se l'indirizzo `_creator` è attualmente registrato come creatore, `false` altrimenti;
  - metodo view `getCreatorScore(address _creator)`: restituisce il punteggio di popolarità (o "voti") associato a un creatore specifico; restituisce 0 se l'indirizzo non è un creatore registrato o non ha un punteggio;
  - metodo view `getSubscriptionStatus(address _subscriber)`: restituisce lo stato della sottoscrizione per un dato indirizzo: il valore riportato `isActive` indica se la sottoscrizione è correntemente valida, e `lastPaymentTime` il timestamp dell'ultimo pagamento di successo; questo metodo potrebbe essere usato off-chain dal sistema di visualizzazione dei contenuti gestiti dalla piattaforma per autorizzare la fruizione dei contenuti;
  - metodo view `getContractBalance()`: restituisce l'ammontare totale in Wei attualmente detenuto dal contratto, proveniente dalle sottoscrizioni;
  - metodo view `getHistoricalDistributedFunds()`: restituisce l'ammontare totale in Wei del fondi distribuiti effettivamente dal contratto ai vari creatori dal momento della sua creazione; i fondi accumulati ma ancora non distribuiti non vanno conteggiati;
  - metodo view `getTotalSubscribers()`: restituisce il numero attuale dei sottoscrittori attivi (non cancellati e in corso di validità);
  - metodo view `getSubscribers()`: restituisce una lista completa dei sottoscrittori attivi (non cancellati e in corso di validità).
  
  Gli eventi utilizzati dallo smart-contract per notificare applicazioni esterne riguardo a modifiche significative nello stato del contratto sono i seguenti:
  - evento `Subscribed(address indexed subscriber, uint256 amount)`: emesso quando un utente effettua un nuovo pagamento di sottoscrizione o ne rinnova una esistente, indicando l'indirizzo del sottoscrittore e l'importo pagato;
  - evento `SubscriptionCancelled(address indexed subscriber)`: emesso quando un sottoscrittore annulla la propria sottoscrizione;
  - evento `CreatorAdded(address indexed creator)`: emesso quando il Manager aggiunge un nuovo creatore;
  - evento `CreatorRemoved(address indexed creator)`: emesso quando il Manager rimuove un creatore;
  - evento `CreatorScoreUpdated(address indexed creator, uint256 newScore)`: emesso quando il Manager aggiorna il punteggio di popolarità di un creatore;
  - evento `MonthlySubscriptionAmountChanged(uint256 newAmount)`: emesso quando il Manager modifica l'importo richiesto per la sottoscrizione mensile;
  - evento `FundsDistributed(uint256 totalAmountDistributed)`: emesso quando i fondi vengono distribuiti ai creatori, indicando l'ammontare totale di Wei distribuito in quel round.
  
  Gli errori personalizzati emessi dallo smart-contract sono i seguenti:
  - errore `ManagerReservedAction()`: lanciato quando una funzione, che può essere invocata solo dal Manager, viene invocata da un indirizzo non autorizzato;
  - errore `CreatorNotRegistered(address creator)`: lanciato quando si tenta di eseguire un'operazione (ad esempio, rimuovere o aggiornare il punteggio) su un indirizzo che non è registrato come creatore;
  - errore `CreatorAlreadyRegistered(address creator)`: lanciato quando si tenta di aggiungere un indirizzo che è già presente nella lista dei creatori;
  - errore `IncorrectSubscriptionAmount(uint256 requiredAmount, uint256 providedAmount)`: lanciato quando un utente tenta di sottoscrivere inviando un importo inferiore o diverso da quello richiesto per la sottoscrizione mensile;
  - errore `NoActiveSubscription(address subscriber)`: lanciato quando un utente tenta di annullare una sottoscrizione che non è attiva o non esiste;
  - errore `NoFundsToDistribute()`: lanciato quando la funzione `distributeFunds` viene chiamata, ma il contratto non ha ETH accumulati dalle sottoscrizioni da distribuire;
  - errore `NoCreatorsRegistered()`: lanciato quando la funzione `distributeFunds` viene chiamata, ma non ci sono creatori registrati a cui distribuire i fondi.

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface DecentralizedCreatorSubscriptionFundSpecs {
    // constructor(uint256 _initialMonthlySubscriptionAmount);

    function subscribe() external payable;
    function cancelSubscription() external;

    function addCreator(address _creator) external;
    function removeCreator(address _creator) external;
    function updateCreatorScore(address _creator, uint256 _newScore) external;
    function setMonthlySubscriptionAmount(uint256 _newAmount) external;
    function distributeFunds() external;

    function manager() external view returns (address);
    function monthlySubscriptionAmount() external view returns (uint256);
    function isCreator(address _creator) external view returns (bool);
    function getCreatorScore(address _creator) external view returns (uint256);
    function getSubscriptionStatus(address _subscriber) external view returns (bool isActive, uint256 lastPaymentTime);
    function getContractBalance() external view returns (uint256);
    function getHistoricalDistributedFunds() external view returns (uint256);
    function getTotalSubscribers() external view returns (uint256);
    function getSubscribers() external view returns (address[] memory);

    event Subscribed(address indexed subscriber, uint256 amount);
    event SubscriptionCancelled(address indexed subscriber);
    event CreatorAdded(address indexed creator);
    event CreatorRemoved(address indexed creator);
    event CreatorScoreUpdated(address indexed creator, uint256 newScore);
    event MonthlySubscriptionAmountChanged(uint256 newAmount);
    event FundsDistributed(uint256 totalAmountDistributed);

    error ManagerReservedAction();
    error CreatorNotRegistered(address creator);
    error CreatorAlreadyRegistered(address creator);
    error IncorrectSubscriptionAmount(uint256 requiredAmount, uint256 providedAmount);
    error NoActiveSubscription(address subscriber);
    error NoFundsToDistribute();
    error NoCreatorsRegistered();
}


/*
  ### Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 14/07/2025

  Scrivere un contratto `MultiPrizeLotteryToken` che implementi sia l'interfaccia standard `ERC20` che una nuova interfaccia addizionale `MultiPrizeLotteryTokenSpecs`, realizzando un token che rappresenta i biglietti di una lotteria virtuale sulla piattaforma Ethereum.

  La lotteria prevede una scadenza iniziale e un costo fisso per biglietto in ETH. Chiunque ha la possibilità di acquistare biglietti fino alla scadenza. I biglietti, fino alla scadenza, avranno tutte le caratteristiche di un token ERC-20 e pertanto potranno essere, ad esempio, trasferiti da un utente all'altro.

  Una volta passata la scadenza, non ci sarà un unico vincitore, ma cinque vincitori distinti per cinque premi diversi, calcolati in percentuale sull'ammontare totale in ETH accumulato dalle vendite dei biglietti:
  *   1° premio: 60% del montepremi totale.
  *   2° premio: 20% del montepremi totale.
  *   3° premio: 10% del montepremi totale.
  *   4° premio: 8% del montepremi totale.
  *   5° premio: 2% del montepremi totale.
  
  Al momento della chiusura della lotteria verranno determinati i 5 vincitori ma non ci saranno pagamenti automatici. Sarà invece messo a disposizione un metodo che permetterà ai vincitori di prelevare il proprio premio in un momento successivo.

  Il contratto dovrà implementare le interfacce `ERC20` e `MultiPrizeLotteryTokenSpecs`.

  #### Interfaccia `ERC20`
  I metodi standard dell'interfaccia `ERC20` avranno i seguenti compiti:
  *   `totalSupply()`: fornisce il totale dei token in circolazione.
  *   `balanceOf(address account)`: fornisce l'ammontare di token associati ad uno specifico indirizzo.
  *   `transfer(address recipient, uint256 amount)`: trasferisce all'indirizzo `recipient` l'ammontare specificato attingendo dal conto del chiamante.
  *   `approve(address delegate, uint256 amount)`: autorizza l'indirizzo `delegate` a spendere al più l'ammontare specificato attingendo dal conto del chiamante.
  *   `transferFrom(address sender, address recipient, uint256 amount)`: trasferisce all'indirizzo `recipient` l'ammontare specificato (purché pre-autorizzato tramite `approve`) attingendo dal conto dell'indirizzo `spender`.
  *   `allowance(address owner, address delegate)`: riporta l'ammontare pre-autorizzato per delega (vedi `approve`) da `owner` a favore di `delegate`.
  *   Eventi `Transfer(address indexed from, address indexed to, uint256 value)` e `Approval(address indexed owner, address indexed delegate, uint256 value)` dovranno essere emessi opportunamente.

  #### Interfaccia `MultiPrizeLotteryTokenSpecs`
  Questa interfaccia specifica seguirà le seguenti indicazioni:

  *   **Costruttore:** `constructor(uint durationInSecs, uint costPerTicket)`: Deve stabilire una durata, non nulla, in secondi della lotteria e il costo in Wei, non nullo, del singolo ticket.

  *   `function buyTickets() external payable;` Permette a chiunque di acquistare un certo numero di biglietti dalla lotteria, se ancora attiva. Il numero di biglietti acquisiti viene determinato dall'ammontare trasferito, trattenendo comunque l'intero importo (se c'è resto, questo non viene restituito). Deve essere possibile acquistare biglietti multipli attraverso invocazioni ripetute del metodo stesso. Potrebbe lanciare gli errori `LotteryAlreadyExpired` o `NotEnoughFundsForATicket`.

  *   `function getCostPerTicket() external view returns (uint cost);` Riporta a chiunque il costo del singolo biglietto.

  *   `function getRemainingTimeInSecs() external view returns (uint);` Riporta a chiunque il tempo rimanente in secondi fino alla scadenza della lotteria.

  *   `function checkoutLottery() external;` Può essere invocato da chiunque per generare le azioni legate alla chiusura della lotteria. Se la scadenza non è ancora stata raggiunta, verrà generato l'errore `LotteryNotYetExpired`. Se invece la scadenza è passata e il metodo non è stato ancora invocato: verranno individuati i cinque vincitori distinti tra tutti i biglietti venduti; la scelta casuale dei ticket vincitori dovrà essere effettuata, con i limiti della piattaforma, sfruttando il valore `block.prevrandao`. I premi verranno calcolati e registrati internamente per ciascun vincitore, ma non saranno trasferiti immediatamente. Verrà emesso un evento `LotteryWinnersDetermined(address[5] winners, uint256[5] amounts)`, che indichi i 5 vincitori e l'ammontare del premio spettante a ciascuno. Nel caso limite in cui non sia stato venduto alcun biglietto, verrà generato l'evento `LotteryClosedWithoutTickets`.

  *   `function claimPrize() external;` Permette a un vincitore di prelevare il proprio premio. Il chiamante deve essere uno dei 5 vincitori determinati in precedenza. Se il premio è già stato prelevato, verrà generato un errore `PrizeAlreadyClaimed`. Se il chiamante non è un vincitore o la lotteria non è ancora stata chiusa (`checkoutLottery` non è stato invocato), verranno generati errori appropriati (`NotAWinner` o `LotteryNotYetClosed`). In caso di successo, il metodo trasferirà l'ammontare del premio al chiamante ed emetterà l'evento `PrizeClaimed(address winner, uint256 amount, uint8 rank)`.

  *   `function getWinnerInfo(uint8 rank) external view returns (address winner, uint256 amount, bool claimed);` Riporta, su una lotteria conclusa, l'identità del vincitore per uno specifico rango (da 1 a 5), l'ammontare della vincita e se il premio è già stato reclamato. In caso di lotteria ancora non chiusa, genererà l'errore `LotteryNotYetExpired`. Nel caso in cui il rango richiesto sia fuori dall'intervallo 1-5, verrà generato un errore `InvalidPrizeRank`.

  Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

/* https://eips.ethereum.org/EIPS/eip-20 */
interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address delegate) external view returns (uint256);
    function approve(address delegate, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed delegate, uint256 value);
}

interface MultiPrizeLotteryTokenSpecs {
    /* constructor(uint durationInSecs, uint costPerTicket) */

    function buyTickets() external payable;
    function checkoutLottery() external;
    function claimPrize() external;
    function getCostPerTicket() external view returns (uint cost);
    function getRemainingTimeInSecs() external view returns (uint);
    function getWinnerInfo(uint8 rank) external view returns (address winner, uint256 amount, bool claimed);

    // Events
    event LotteryWinnersDetermined(address[5] winners, uint256[5] amounts);
    event LotteryClosedWithoutTickets();
    event PrizeClaimed(address winner, uint256 amount, uint8 rank);

    // Custom Errors
    error LotteryNotYetExpired(uint remainingTimeInSecs);
    error LotteryAlreadyExpired();
    error NotEnoughFundsForATicket(uint minimum);
    error NotAWinner();
    error PrizeAlreadyClaimed(uint8 rank);
    error LotteryNotYetClosed();
    error InvalidPrizeRank(uint8 rank);
}

contract MultiPrizeLotteryToken is MultiPrizeLotteryTokenSpecs, ERC20{

  uint totale_biglietti;
  uint prezzo_biglietti;
  uint scadenza_lotteria;

  address[] partecipanti;
  uint num_partecipanti;
  mapping(address => uint) partecipante_to_index;
  mapping(address => bool) is_partecipante;
  mapping(address => uint) bilanci;
  mapping(address => mapping(address=> uint)) deleghe;
  
  uint[5] premi;
  address[5] vincitori;
  uint[5] pagamenti;
  
  
  constructor(uint durationInSecs, uint costPerTicket){
    if(durationInSecs == 0) revert("Errore, la durata non puo essere zero");
    if(costPerTicket == 0) revert("Serve che il ticket abbia un costo maggiore di 0");
    prezzo_biglietti = costPerTicket;
    scadenza_lotteria = block.timestamp + (durationInSecs * 1 seconds);
  }


  function vediPartecipanti()public view returns(address[] memory){
    return partecipanti;
  }


  function buyTickets() external payable{
    if(msg.value < prezzo_biglietti) revert NotEnoughFundsForATicket(prezzo_biglietti);
    if(block.timestamp > scadenza_lotteria) revert LotteryAlreadyExpired();
    else{
      uint num = msg.value/prezzo_biglietti;
      totale_biglietti += num;
      bilanci[msg.sender] += num;
      if(is_partecipante[msg.sender]==false){
        is_partecipante[msg.sender]= true;
        partecipanti.push();
        partecipanti[num_partecipanti] = msg.sender;
        partecipante_to_index[msg.sender] = num_partecipanti;

        num_partecipanti++;
      }
    }
  }

  function checkoutLottery() external{
    if(block.timestamp < scadenza_lotteria) revert LotteryNotYetExpired(scadenza_lotteria - block.timestamp);
    if(vincitori[0] != address(0)) revert("Lotteria gia conclusa!");
    if(totale_biglietti == 0){
      emit LotteryClosedWithoutTickets();
      return;
    }
    else{
      uint n = partecipanti.length;
      uint primo; uint secondo; uint terzo; uint quarto; uint quinto;

      primo = uint256(keccak256(abi.encode(block.timestamp,block.prevrandao,1)))%totale_biglietti;
      secondo = uint256(keccak256(abi.encode(block.timestamp,block.prevrandao,2)))%totale_biglietti;
      terzo = uint256(keccak256(abi.encode(block.timestamp,block.prevrandao,3)))%totale_biglietti;
      quarto = uint256(keccak256(abi.encode(block.timestamp,block.prevrandao,4)))%totale_biglietti;
      quinto = uint256(keccak256(abi.encode(block.timestamp,block.prevrandao,5)))%totale_biglietti;

      uint[] memory array_num = new uint[](n);
      array_num[0] = bilanci[partecipanti[0]];
      if(array_num[0] > primo) vincitori[0] = partecipanti[0];
      if(array_num[0] > secondo) vincitori[1] = partecipanti[0];
      if(array_num[0] > terzo) vincitori[2] = partecipanti[0];
      if(array_num[0] > quarto) vincitori[3] = partecipanti[0];
      if(array_num[0] > quinto) vincitori[4] = partecipanti[0];
      for (uint i = 1; i < n; i++) 
      {
        array_num[i] = array_num[i-1] + bilanci[partecipanti[i]];
        if(primo >= array_num[i-1] && primo < array_num[i]) vincitori[0] = partecipanti[i];
        if(secondo >= array_num[i-1] && secondo < array_num[i]) vincitori[1] = partecipanti[i];
        if(terzo >= array_num[i-1] && terzo < array_num[i]) vincitori[2] = partecipanti[i];
        if(quarto >= array_num[i-1] && quarto < array_num[i]) vincitori[3] = partecipanti[i];
        if(quinto >= array_num[i-1] && quinto < array_num[i]) vincitori[4] = partecipanti[i];
      }
      //uscito da questo ciclo ho la lista dei vincitori e devo calcolare i premi
      uint totale = address(this).balance;

      premi[0] = (totale * 60)/100;
      premi[1] = (totale * 20)/100;
      premi[2] = (totale * 10)/100;
      premi[3] = (totale * 8)/100;
      premi[4] = (totale * 2)/100;

      pagamenti[0] = premi[0];
      pagamenti[1] = premi[1];
      pagamenti[2] = premi[2];
      pagamenti[3] = premi[3];
      pagamenti[4] = premi[4];
    }
  }

  function claimPrize() external{
    bool is_winner;
    uint[] index;
    for (uint i = 0; i < 5 ; i++) 
    {
      if(vincitori[i] == msg.sender){ 
        is_winner = true;
        index = i;
      }
    }
    if(is_winner == false) revert NotAWinner();
    if(pagamenti[index] == 0) revert PrizeAlreadyClaimed(index+1);
    else{
      pagamenti[index] == 0
    }

  }
  function getCostPerTicket() external view returns (uint cost){
    return prezzo_biglietti;
  }

  function getRemainingTimeInSecs() external view returns (uint){
    if(block.timestamp < scadenza_lotteria) return scadenza_lotteria - block.timestamp;
    else return 0;
  }

  function getWinnerInfo(uint8 rank) external view returns (address winner, uint256 amount, bool claimed){
    if(winner == address(0)) revert LotteryNotYetClosed(); //o comunque non ancora assegnati i vincitori ma, dato che è dichiarato come view, non posso modificare lo stato da qui
    if(rank > 5 || rank < 1) revert("Inserisci un premio valido!");
    else{
      bool claim = (pagamenti[rank] == premi[rank] ? false:true);
      return (vincitori[rank],premi[rank],claim);
    }
  }

  function totalSupply() external view returns (uint256){
    return totale_biglietti;
  }
  function balanceOf(address account) external view returns (uint256){
    return bilanci[account];
  }
  function transfer(address recipient, uint256 amount) external returns (bool){ //CONTROLLO CHE SIA FINITA LA LOTTERIA
    if(block.timestamp > scadenza_lotteria) revert LotteryAlreadyExpired();
    if(bilanci[msg.sender] < amount) return false;
    else{
      if(is_partecipante[recipient] == false){
        is_partecipante[recipient] = true;
        partecipanti.push();
        partecipanti[num_partecipanti] = recipient;
        partecipante_to_index[recipient] = num_partecipanti;
        num_partecipanti++;
      }
      bilanci[msg.sender]-=amount;
      bilanci[recipient] += amount;
      if(bilanci[msg.sender] == 0){//vuol dire che non ha più ticket, cioè non è piu un partecipante
        is_partecipante[msg.sender] = false;

        //troviamo l'ultimo indice e quello da togliere
        uint last_index = partecipanti.length -1;
        uint index_to_change = partecipante_to_index[msg.sender];

        partecipanti[index_to_change] = partecipanti[last_index];
        partecipanti.pop();
        num_partecipanti--;
        partecipante_to_index[partecipanti[index_to_change]] = index_to_change;
      }
      return true;
    }
  }
  function allowance(address owner, address delegate) external view returns (uint256){
    return deleghe[owner][delegate];
  }
  function approve(address delegate, uint256 amount) external returns (bool){
    deleghe[msg.sender][delegate] = amount;
    return true;
  }
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){//AGGIUNGI CONTROLLO SULLA FINE DELLA LOTTERIA
    if(block.timestamp > scadenza_lotteria) revert LotteryAlreadyExpired();
    if(deleghe[sender][msg.sender] < amount) return false;
    if(bilanci[sender] < amount) return false;
    else{
      if(is_partecipante[recipient] == false){
        is_partecipante[recipient] = true;
        partecipanti.push();
        partecipanti[num_partecipanti] = recipient;
        partecipante_to_index[recipient] = num_partecipanti;
        num_partecipanti++;
      }
      bilanci[sender]-= amount;
      deleghe[sender][msg.sender] -= amount;
      bilanci[recipient] += amount;
      if(bilanci[sender] == 0){//vuol dire che non ha più ticket, cioè non è piu un partecipante
        is_partecipante[sender] = false;

        //troviamo l'ultimo indice e quello da togliere
        uint last_index = partecipanti.length -1;
        uint index_to_change = partecipante_to_index[sender];

        partecipanti[index_to_change] = partecipanti[last_index];
        partecipanti.pop();
        num_partecipanti--;
        partecipante_to_index[partecipanti[index_to_change]] = index_to_change;
      }
      return true;
    }
  }
}
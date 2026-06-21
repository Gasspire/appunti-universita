/*
    Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 01/07/2024

    Scrivere un contratto `LotteryToken` che implementi sia l'interfaccia standard `ERC20`, vista a lezione, che 
    quella addizionale `LotteryTokenSpecs` che realizzi, usando il linguaggio Solidity, un token che rappresenta i 
    biglietti di una lotteria virtuale sulla piattaforma Ethereum. La lotteria prevede una scadenza iniziale e un 
    costo fisso del biglietto in ETH; chiunque ha la possibilità di acquistare biglietti fino alla scadenza.
    Passata la scadenza viene scelto un biglietto a caso e il possessore vincerà l'intero ammontare in ETH accantonato
    attraverso le vendite. I biglietti, fino alla scadenza, avranno tutte le caratteristiche di un token ERC-20 
    e pertanto potranno essere, ad esempio, trasferiti da un utente all'altro.

    I metodi standard dell'interfaccia `ERC20` hanno i seguenti compiti:
    - `totalSupply`: fornisce il totale dei token in circolazione;
    - `balanceOf`: fornisce l'ammontare di token associati ad uno specifico indirizzo;
    - `transfer`: trasferisce all'indirizzo `recipient` l'ammontare specificato attingendo dal conto del 
      chiamante;
    - `approve`: autorizza l'indirizzo `delegate` a spendere al piu' l'ammontare specificato attingendo dal
      conto del chiamante;
    - `transferFrom`: trasferisce all'indirizzo `recipient` l'ammontare specificato (purche' pre-autorizzato
      tramite `approve`) attingendo dal conto dell'indirizzo `spender`;
    - `allowance`: riporta l'ammontare pre-autorizzato per delega (vedi `approve`) da `owner` a favore di 
      `delegate`.

    I metodi dell'interfaccia specifica `LotteryTokenSpecs` seguono le seguenti indicazioni:
    - il costruttore deve stabilire una durata in secondi della lotteria e il costo in Wei, non nullo, del singolo
      ticket;
    - il metodo `buyTickets` permette a chiunque di acquistare un certo numero di biglietti dalla lotteria, se 
      ancora attiva; il numero di biglietti acquisiti viene determinato dall'ammontare trasferito trattenendo 
      comunque l'intero importo (se c'è resto, questo non viene restituito); deve essere possibile acquistare 
      biglietti multipli attraverso invocazioni ripetute del metodo stesso; questo potrebbe lanciare gli errori 
      `LotteryAlreadyExpired` o `NotEnoughFundsForATicket`;
    - i metodi `getCostPerTicket` e `getRemainingTimeInSecs` riportano a chiunque le informazioni indicate;
      il metodo `getWinner` riporta, su una lotteria conclusa, l'identità del vincitore e l'ammontare della 
      vincita o, in caso di lotteria ancora non chiusa, l'errore `LotteryNotYetExpired`;
    - il metodo `checkoutLottery` può essere invocato da chiunque per generare le azioni legate alla chiusura
      della lotteria: se la scadenza non è ancora stata raggiunta verrà generato l'errore `LotteryNotYetExpired`; 
      se invece la scadenza è passata e il metodo non è stato ancora invocato, verrà individuato il vincitore e 
      il totale degli ETH accumulati sul contratto verranno trasferiti a questo con relativo evento 
      `LotteryClosedWithWinner`; nel caso limite in cui non sia stato venduto alcun biglietto verrà generato 
      l'evento `LotteryClosedWithoutTickets`; la scelta random del ticket vincitore dovrà essere effettuata, 
      con i limiti della piattaforma, sfruttando il valore `block.prevrandao`.

*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.18;

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

interface LotteryTokenSpecs {
  /* constructor(uint durationInSecs, uint costPerTicket) */

  function buyTickets() external payable;
  function checkoutLottery() external returns (address winner);
  function getCostPerTicket() external view returns (uint cost);
  function getWinner() external view returns (address winner, uint amount);
  function getRemainingTimeInSecs() external view returns (uint);

  event LotteryClosedWithWinner(address winner, uint amount);
  event LotteryClosedWithoutTickets();

  error LotteryNotYetExpired(uint remainingTimeInSecs);
  error LotteryAlreadyExpired();
  error NotEnoughFundsForATicket(uint minimum);
}


contract LotteryToken is LotteryTokenSpecs, ERC20{
  mapping(address => uint256) utenti_balance;
  address[] public lista_partecipanti;
  mapping(address => mapping(address => uint256)) deleghe;


  uint scadenza;
  uint costo_biglietto;
  uint numero_biglietti;
  uint vincita;
  address vincitore;

  constructor(uint durationInSecs, uint costPerTicket){
    if(costPerTicket == 0) revert ();
    if(durationInSecs == 0) revert ();

    scadenza = block.timestamp + (durationInSecs * 1 seconds);
    costo_biglietto = costPerTicket;
  }




  function buyTickets() external payable{
    if(msg.value < costo_biglietto) revert NotEnoughFundsForATicket(costo_biglietto);//non ha abbastanza soldi
    if(block.timestamp > scadenza) revert LotteryAlreadyExpired(); //la lotteria è già scaduta!    
  

    uint num = msg.value/costo_biglietto; //anche se ci fosse resto viene arrotondato per difetto dato che stiamo lavorando con un uint
    if(utenti_balance[msg.sender] == 0) lista_partecipanti.push(msg.sender); //aggiungiamo alla lista dei partecipanti;
    utenti_balance[msg.sender] += num;
    numero_biglietti+= num;

  }

  function checkoutLottery() external returns (address winner){
    if(block.timestamp < scadenza) revert LotteryNotYetExpired(scadenza - block.timestamp);
    if(vincitore != address(0)) revert ();// il vincitore della lotteria è gia stato dichiarato
    if(numero_biglietti == 0) emit LotteryClosedWithoutTickets();
    else{    //controlliamo il vincitore
      //generiamo un numero di biglietto tra 0 e num_biglietti
      uint num_vincente = uint(keccak256(abi.encode(block.timestamp, block.prevrandao))) % numero_biglietti;

      uint[] memory array_biglietti = new uint[](lista_partecipanti.length);
      array_biglietti[0] = utenti_balance[lista_partecipanti[0]];
      for (uint i = 1; i < lista_partecipanti.length; i++) 
      {
        array_biglietti[i] = array_biglietti[i-1] + utenti_balance[lista_partecipanti[i]];
      }

      int index_vincitore = -1;
      if(num_vincente < array_biglietti[0]) index_vincitore = 0;
      else{
        for (uint i = 1; i < lista_partecipanti.length; i++) 
        {
          if(num_vincente <= array_biglietti[i] && num_vincente > array_biglietti[i-1]){
            index_vincitore = int(i);
            break;
          }
        }
      }
      vincitore = lista_partecipanti[uint(index_vincitore)];
      vincita = address(this).balance;
      emit LotteryClosedWithWinner(vincitore, vincita);
      (bool success, ) = vincitore.call{value: vincita}("");
      if(!success) revert("Qualcosa e' andato storto!"); 
      return vincitore;


    }
  }
  function getCostPerTicket() external view returns (uint cost){
    return costo_biglietto;
  }
  function getWinner() external view returns (address winner, uint amount){
    if(block.timestamp < scadenza) revert LotteryNotYetExpired(scadenza - block.timestamp);
    if(vincitore == address(0)) revert ("Vincitore non ancora dichiarato, usa checkoutLottery");
    return (vincitore,vincita);
  }
  function getRemainingTimeInSecs() external view returns (uint){
    if (scadenza > block.timestamp) return scadenza - block.timestamp;
    else return 0;
    
  }




  function totalSupply() external view returns (uint256){
    return numero_biglietti;
  }
  function balanceOf(address account) external view returns (uint256){
    return utenti_balance[account];
  }
  function transfer(address recipient, uint256 amount) external returns (bool){
    if(amount > utenti_balance[msg.sender]) return false;
    else{
      if(utenti_balance[recipient] == 0) lista_partecipanti.push(recipient);
      utenti_balance[msg.sender] -= amount;
      utenti_balance[recipient] += amount;
      emit Transfer(msg.sender, recipient, amount);
      return true;
    }
  }
  function allowance(address owner, address delegate) external view returns (uint256){
    return deleghe[owner][delegate];
  }
  function approve(address delegate, uint256 amount) external returns (bool){
    if(delegate == address(0)) return false;
    if(amount == 0) return false;
    deleghe[msg.sender][delegate] = amount;
    emit Approval(msg.sender, delegate, amount);
    return true;
  }
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
    if(deleghe[sender][msg.sender] < amount) return false; //controllo che sia abilitato a spendere quei soldi
    if(utenti_balance[sender] < amount) return false; // controllo se ha abbastanza soldi
    if(utenti_balance[recipient] == 0) lista_partecipanti.push(recipient);
    deleghe[sender][msg.sender]-=amount;
    utenti_balance[sender]-= amount;
    utenti_balance[recipient] += amount;
    emit Transfer(sender, recipient, amount);
    return true;
  }


}
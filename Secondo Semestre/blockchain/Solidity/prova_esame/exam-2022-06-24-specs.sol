/*
    Corso Blockchain & Cryptocurrencies - Compito di laboratorio del 24/06/2022

    Scrivere un contratto `MafiaToken` che implementi sia l'interfaccia standard `ERC20`, vista a lezione, che 
    quella addizionale `MafiosoTokenSpecs` che realizzi, usando il linguaggio Solidity, un 
    "particolare token" sulla piattaforma Ethereum.

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

    Passando all'interfaccia `MafiosoTokensSpecs`: questa prevede di identificare come "padrino" (godfather)
    il proprietario/creatore del contratto e dal riservargli alcune azioni previste tra cui: `addPicciotto`, 
    `removePicciotto`, `setPizzoRate`, `setPicciottiPerChildSalary` e `forgeNewTokens`. 
    Viene anche gestito un gruppo di utenti speciali detti "picciotti" che unicamente il padrino puo' gestire.
    A tale gruppo sono permesse alcune azioni e ricevono uno "stipendio" mensile dal padrino. Lo stipendio
    mensile di un picciotto e' pari "(n + 1) x 'PerChildSalary'", dove 'PerChildSalary' e' il valore 
    impostato dal metodo `setPicciottiPerChildSalary`.

    In particolare:
    - `forgeNewTokens`, utilizzabile solo dal padrino, creano nuovi token e li accredita allo stesso;
    - `stealTokens`, utilizzabile dal padrino e dai picciotti, puo' essere usato per "rubare" token 
      all'indirizzo `robbed` specificato; non si puo' rubare al padrino stesso;
    - tramite `pizzoRate` e `setPizzoRate` e' possibile consultare e impostare, quest'ultimo solo da 
      parte del padrino, la percentuale che lo stesso trattiene ad ogni trasferimento effettuato tramite 
      i metodi standard `transfer` e `transferFrom`; la percentuale e' espressa come un intero tra 0 e 100;
    - tramite `picciottiSalary` e `setPicciottiPerChildSalary` e' possibile consultare e impostare, 
      quest'ultimo solo da parte del padrino, l'ammontare in token che lo stesso paghera' mensilmente agli 
      stessi; il metodo `triggerMonthlyPicciottiSalary`, invocabile da chiunque e in qualunque momento, 
      effettuera' il pagamento a tutti gli attuali picciotti, con periodicita' di 30 giorni, usando come 
      data di riferimento quella di creazione del contratto. 
      Il salario  mensile per figlio predefinito alla creazione del contratto e' di 100 token più una base di
      altri 100 token.

    L'evento standard `Approve` dovra' essere emesso in occasione di una pre-autorizzazione al transferimento e
    quello `Transfer` ogni qualvolta si configuri un trasferimento di proprieta' di token: anche per i metodi
    dell'interfaccia `MafiosoTokenSpecs`.
    
    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.

    Declaration: we don't like Mafia, we are just making fun of it!
    
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

interface MafiosoTokenSpecs {
  /* constructor(uint initialSupply) */

  function godfather() external view returns (address);
  function picciotti() external view returns (address[] memory);
  function addPicciotto(address id, uint8 children) external;
  function removePicciotto(address id) external;
  function forgeNewTokens(uint additionalSupply) external;
  function stealTokens(address robbed, uint amount) external;
  function pizzoRate() external view returns (uint8);
  function setPizzoRate(uint8 rate) external;
  function picciottiSalary() external view returns (uint);
  function setPicciottiPerChildSalary(uint amount) external;
  function triggerMonthlyPicciottiSalary() external;
}


contract MafiaToken is MafiosoTokenSpecs, ERC20{
  address payable padrino;
  uint8 pizzo_rate;
  uint256 lasy_payment;

  struct Picciotto{
    address id;
    uint8 children;
  }



  mapping(address => uint256) bilanci; //così posso ottenere tutti i bilanci
  Picciotto[] lista_picciotti; // così conosco i picciotti
  mapping(address => uint256) index_picciotti;  //così conosco gli indici associati a ogni indirizzo
  address[] lista_picciotti_addr;
  uint256 num_picciotti;
  uint256 totale_token;
  uint256 salario_mensile;  
  mapping(address => mapping(address => uint256)) deleghe;


  modifier onlyPadrino(){
    require(msg.sender == padrino,"Torna al tuo posto picciotto...");
    _;
  }

  modifier onlyMafia(){
    uint256 indice = index_picciotti[msg.sender];
    require(((indice < num_picciotti) && lista_picciotti[indice].id == msg.sender) || msg.sender == padrino, "Devi prima entrare nella famiglia...!");
    _;
  }
  


  function totalSupply() external view returns (uint256){
    return totale_token;
  }
  function balanceOf(address account) external view returns (uint256){
    return bilanci[account];
  }
  function transfer(address recipient, uint256 amount) external returns (bool){
    if(bilanci[msg.sender] < amount) return false;
    uint pizzo = (amount * pizzo_rate )/100;
    bilanci[msg.sender] -= amount;
    bilanci[recipient] += (amount-pizzo);
    bilanci[padrino] += pizzo;
    return true;
  }

  function allowance(address owner, address delegate) external view returns (uint256){
    return deleghe[owner][delegate];
  }

  function approve(address delegate, uint256 amount) external returns (bool){
    if(bilanci[msg.sender] < amount) return false;
    deleghe[msg.sender][delegate] = amount;
    emit Approval(msg.sender, delegate, amount);
    return true;
  }
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
    if(bilanci[sender] < amount || (deleghe[sender][msg.sender]) < amount ) return false;
    else{
      bilanci[sender] -= amount; 
      deleghe[sender][msg.sender] -= (amount);
      uint pizzo = (amount * pizzo_rate )/100;
      bilanci[recipient] += (amount-pizzo);
      bilanci[padrino] += pizzo;
      emit Transfer(sender, recipient, amount);
      return true;
    }
  }




  constructor(){
    padrino = payable(msg.sender);
    num_picciotti = 0;
    totale_token = 0;
    salario_mensile = 100;
    pizzo_rate = 20;
  }
  




  function godfather() external view returns (address){
    return padrino;
  }

  function picciotti() external view returns (address[] memory){
    return lista_picciotti_addr;
  }
  

  function addPicciotto(address id, uint8 children) onlyPadrino external{
    lista_picciotti.push();
    Picciotto storage p = lista_picciotti[num_picciotti];
    p.id = id;
    p.children = children;
    lista_picciotti_addr.push(p.id);
    index_picciotti[id] = num_picciotti;
    num_picciotti++;
  }

  function removePicciotto(address id) onlyPadrino external{
    uint256 indice = index_picciotti[id];
    require((indice < num_picciotti) && lista_picciotti[indice].id == id, "Stai cercando di togliere un picciotto che non esiste!");
    lista_picciotti[indice].id = address(0);
    lista_picciotti_addr[indice] = address(0);
  }

  function forgeNewTokens(uint additionalSupply) onlyPadrino external{
    require(additionalSupply > 0, "Devi creare almeno 1 token");
    totale_token += additionalSupply;
    bilanci[padrino] += additionalSupply;
  }

  function stealTokens(address robbed, uint amount) onlyMafia external{
    require(robbed!=padrino,"Come osi pensare di poter derubare il padrino!");
    uint256 importo = (bilanci[robbed] <= amount ? bilanci[robbed]:amount);
    bilanci[robbed] = bilanci[robbed] - importo;
    bilanci[msg.sender] += importo;
  }


  function pizzoRate() external view returns (uint8){
    return pizzo_rate;
  }
  function setPizzoRate(uint8 rate) onlyPadrino external{
    require(rate < 100,"Capo un po' di pieta'");
    pizzo_rate = rate;
  }
  function picciottiSalary() external view returns (uint){
    return salario_mensile;
  }
  function setPicciottiPerChildSalary(uint amount) onlyPadrino external{
    require(amount > 0, "Capo per favore tengo criatur");
    salario_mensile = amount;
  }
  function triggerMonthlyPicciottiSalary() external{
    uint mesi_passati = (block.timestamp - lasy_payment)/30;
    if(mesi_passati == 0) return;
    else{
      lasy_payment += (mesi_passati*30 days);
      for (uint i = 0; i < num_picciotti; i++){
        Picciotto memory p = lista_picciotti[i];
        if(p.id != address(0)){
          uint256 stipendio = (p.children + 1)* salario_mensile;
          uint256 da_pagare = stipendio * mesi_passati;
          require(bilanci[padrino] >= (da_pagare),"Il padrino non ha abbastanza soldi per pagare tutti i piciotti...");

          bilanci[padrino] -= da_pagare;
          bilanci[padrino] += da_pagare;
          emit Transfer(padrino, p.id, da_pagare);
        }
      }
    }
  }



}
/*
    Corso Blockchain e Cryptocurrencies - Esercitazione di laboratorio (Simulazione 3)

    Scrivere un contratto `UniversityCreds` che implementi sia l'interfaccia standard `ERC20` 
    che quella addizionale `UniversitySpecs` usando il linguaggio Solidity. 
    
    Il contratto rappresenta un sistema a gettoni (UCreds) di un'università. Il creatore del contratto 
    assume il ruolo di "Preside" (Dean).
    
    I metodi standard dell'interfaccia `ERC20` (totalSupply, balanceOf, transfer, allowance, 
    approve, transferFrom) dovranno comportarsi come visto a lezione, permettendo il normale trasferimento 
    dei token tra gli utenti.

    L'interfaccia `UniversitySpecs` introduce le seguenti regole e logiche aggiuntive:
    - Il Preside può iscrivere un nuovo studente tramite `enrollStudent`. All'atto dell'iscrizione, 
      il contratto "conia" (crea dal nulla) 50 nuovi token e li accredita allo studente come bonus 
      di benvenuto, aumentando di conseguenza il totale dei token in circolazione.
    - Il Preside può premiare uno studente iscritto tramite `rewardStudent`, coniando nuovi token 
      a suo favore.
    - Il Preside può penalizzare uno studente iscritto tramite `penalizeStudent`, bruciando (distruggendo) 
      una determinata quantità dei suoi token (riducendo così anche il totalSupply).
    - Qualsiasi studente iscritto può usare il metodo `buyMeal` per acquistare un pasto in mensa. 
      Questo metodo sottrae esattamente 15 token dal saldo dello studente e li trasferisce 
      all'indirizzo del Preside.
    
    Gli eventi e gli errori previsti dall'interfaccia dovranno essere opportunamente utilizzati.
    In particolare: 
    - L'evento `Transfer` deve essere emesso ogni volta che c'è uno spostamento di token, **incluso** quando vengono coniati (simulando un trasferimento dall'indirizzo `address(0)` allo studente) 
      o bruciati (simulando un trasferimento dallo studente all'indirizzo `address(0)`).
    - L'evento `Approval` deve essere emesso in occasione di una pre-autorizzazione (`approve`).

    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.
*/

// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

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

interface UniversitySpecs {
    // Ritorna l'indirizzo del Preside
    function dean() external view returns (address);
    
    // Verifica se un indirizzo appartiene a uno studente iscritto
    function isStudent(address account) external view returns (bool);
    
    // Iscrive uno studente erogando il bonus di 50 token (Solo Preside)
    function enrollStudent(address student) external;
    
    // Conia nuovi token a favore di uno studente (Solo Preside)
    function rewardStudent(address student, uint amount) external;
    
    // Brucia token dal saldo di uno studente (Solo Preside)
    function penalizeStudent(address student, uint amount) external;
    
    // Permette a uno studente di pagare 15 token al Preside per un pasto
    function buyMeal() external;

    // Eventi custom
    event StudentEnrolled(address student);
    event MealPurchased(address student);

    // Errori Custom
    error OnlyDeanReservedAction();
    error StudentAlreadyEnrolled();
    error NotAnEnrolledStudent(address account);
    error InsufficientTokenBalance(uint requested, uint available);
}


contract UniversityCreds is ERC20, UniversitySpecs{
    address immutable preside;
    mapping(address => uint)






    modifier OnlyPreside(){
        if(msg.sender != preside) revert OnlyDeanReservedAction();
        _;
    }



    function dean() external view returns (address){}
    
    function isStudent(address account) external view returns (bool){}
    
    function enrollStudent(address student) external{}
    
    function rewardStudent(address student, uint amount) external{}
    
    function penalizeStudent(address student, uint amount) external{}
    function buyMeal() external{}




    function totalSupply() external view returns (uint256){}
    function balanceOf(address account) external view returns (uint256){}
    function transfer(address recipient, uint256 amount) external returns (bool){}
    function allowance(address owner, address delegate) external view returns (uint256){}
    function approve(address delegate, uint256 amount) external returns (bool){}
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){}
}
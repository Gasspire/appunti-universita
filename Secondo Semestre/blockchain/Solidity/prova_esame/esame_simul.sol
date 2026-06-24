/*
    Corso Blockchain e Cryptocurrencies - Esercitazione di laboratorio (Simulazione)

    Scrivere un contratto `CryptoCarpooling` che implementi l'interfaccia `CryptoCarpoolingSpecs`
    usando il linguaggio Solidity per la gestione di un sistema di viaggi condivisi (carpooling) 
    sulla piattaforma Ethereum.

    Il sistema permette a chiunque (il conducente) di proporre un nuovo viaggio usando il metodo 
    `createTrip`, fornendo una descrizione della destinazione, il prezzo per singolo posto (in Wei)
    e il numero di posti disponibili nell'auto. Ogni viaggio riceverà un `id` univoco sequenziale.

    Chiunque, in veste di passeggero, può prenotare un posto per un viaggio ancora aperto usando 
    `bookSeat` e trasferendo gli ETH corrispondenti al prezzo del biglietto. Questi fondi 
    saranno trattenuti e custoditi dal contratto smart fino alla conclusione del viaggio.
    
    Il conducente ha la facoltà di annullare il viaggio in qualsiasi momento prima della partenza 
    tramite il metodo `cancelTrip`. In questo sfortunato caso, i fondi versati dai passeggeri 
    per quel viaggio dovranno diventare prelevabili dagli stessi. Per questioni di sicurezza
    (pattern pull-over-push), i passeggeri del viaggio annullato dovranno usare il metodo 
    `withdrawRefund` per ritirare individualmente i propri crediti.

    Una volta che il viaggio è stato effettuato con successo, solo il conducente potrà chiamare 
    `completeTrip`: tale metodo cambierà lo stato del viaggio e trasferirà all'indirizzo del 
    conducente l'intero ammontare delle quote versate dai passeggeri per quel viaggio.

    Tramite i metodi `getTripInfo` e `tripState` sarà sempre possibile richiedere informazioni 
    circa qualunque viaggio inserito a sistema.
    
    Gli eventi `NewTrip`, `SeatBooked`, `TripCompleted` e `TripCanceled` dovranno essere 
    opportunamente generati durante le varie fasi.
    
    I vari errori previsti dall'interfaccia dovranno essere lanciati dai metodi interessati in
    caso di anomalie (es. viaggio inesistente, fondi insufficienti per pagare il biglietto, 
    posti esauriti, o azioni riservate a chi non è il conducente).
    
    Il contratto dovrà occuparsi di validare gli input ricevuti secondo criteri ovvi di sensatezza.
*/

// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

interface CryptoCarpoolingSpecs {
    
    enum TripState { Open, Completed, Canceled }

    struct Trip {
        address driver;
        string destination;
        uint ticketPrice;
        uint8 totalSeats;
        uint8 availableSeats;
        TripState state;

        address[] partecipanti;
        mapping(address => uint) partecipanti_pagamento;
    }

    // Crea un nuovo viaggio e restituisce il suo id univoco (partendo da 0 o da 1)
    function createTrip(string calldata destination, uint ticketPrice, uint8 seats) external returns (uint tripId);

    // Prenota un posto per il viaggio indicato versando la quota esatta
    function bookSeat(uint tripId) external payable;

    // Annulla un viaggio rendendo i fondi disponibili per il rimborso (solo per il driver)
    function cancelTrip(uint tripId) external;

    // Conclude il viaggio e trasferisce i fondi cumulati al conducente (solo per il driver)
    function completeTrip(uint tripId) external;

    // Permette a un passeggero di ritirare tutti i rimborsi accumulati dai propri viaggi annullati
    function withdrawRefund() external;

    // Metodi di sola lettura
    function getTripInfo(uint tripId) external view returns (string memory description, address driver, uint total_seats, uint ticketprice, TripState state);
    function tripState(uint tripId) external view returns (TripState);
    function pendingRefunds(address passenger) external view returns (uint amount);

    // Eventi
    event NewTrip(uint tripId, address driver, string destination, uint ticketPrice, uint8 availableSeats);
    event SeatBooked(uint tripId, address passenger);
    event TripCompleted(uint tripId);
    event TripCanceled(uint tripId);

    // Errori Custom
    error TripNotExisting();
    error TripNotOpen(TripState state);
    error InsufficientFundsProvided(uint provided, uint required);
    error NoSeatsAvailable();
    error DriverReservedAction();
    error NoRefundAvailable();
}

contract CryptoCarpooling is CryptoCarpoolingSpecs{
    mapping(uint => Trip) viaggi;
    uint256 num_viaggi;

    


    modifier OnlyDriver(uint tripId){
        if(msg.sender != viaggi[tripId].driver)revert DriverReservedAction();
        _;
    }
    modifier existingId(uint tripId){
        if(tripId > num_viaggi) revert TripNotExisting();
        _;
    }


    function createTrip(string calldata destination, uint ticketPrice, uint8 seats) external returns (uint tripId){
        if(seats == 0) revert("Non puoi creare un viaggio senza passeggeri");
        if(ticketPrice == 0)revert("Non hai inserito alcun prezzo");
        if(bytes(destination).length == 0)revert("Non hai inserito la destinazione!");

        Trip storage v = viaggi[num_viaggi];
        v.driver = msg.sender;
        v.destination = destination;
        v.ticketPrice = ticketPrice;
        v.totalSeats = seats;
        v.state = TripState.Open;

        num_viaggi++;
        emit NewTrip(num_viaggi-1, v.driver, v.destination, v.ticketPrice, v.totalSeats);
        return num_viaggi-1;
    }

    function bookSeat(uint tripId) existingId(tripId) external payable{ //da modificare se si possono acquistare più biglietti!
        if(msg.value < viaggi[tripId].ticketPrice) revert InsufficientFundsProvided(msg.value, viaggi[tripId].ticketPrice);
        if(viaggi[tripId].partecipanti_pagamento[msg.sender] != 0) revert("Sei gia un partecipante");
        if(viaggi[tripId].partecipanti.length < viaggi[tripId].totalSeats) revert NoSeatsAvailable();

        viaggi[tripId].partecipanti.push(msg.sender);
        viaggi[tripId].partecipanti_pagamento[msg.sender] += msg.value;

        return;
    }

    function cancelTrip(uint tripId) OnlyDriver(tripId) external{}

    function completeTrip(uint tripId) existingId(tripId) OnlyDriver(tripId) external{}

    function withdrawRefund() external{}

    function getTripInfo(uint tripId) existingId(tripId) external view returns (string memory description, address driver, uint total_seats, uint ticketprice, TripState state){
        return (viaggi[tripId].destination, viaggi[tripId].driver, viaggi[tripId].totalSeats, viaggi[tripId].ticketPrice, viaggi[tripId].state);
    }
    function tripState(uint tripId) existingId(tripId) external view returns (TripState){
        return viaggi[tripId].state;
    }
    function pendingRefunds(address passenger) external view returns (uint amount){}
    
}
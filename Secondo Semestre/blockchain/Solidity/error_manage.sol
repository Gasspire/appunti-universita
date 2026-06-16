// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GestioneErrori {
    address public owner;
    uint public bilancioVirtuale;

    // DEFINIZIONE DI UN ERRORE PERSONALIZZATO (Custom Error)
    // Consuma pochissimo gas rispetto a una stringa di testo!
    error FondiInsufficienti(uint richiesto, uint disponibile);
    error NonSeiIlProprietario();

    constructor() {
        owner = msg.sender;
        bilancioVirtuale = 100; // Il contratto parte con 100 unità fittizie
    }

    // 1. IL PATTERN 'REQUIRE'
    // Ideale per: Verificare gli input dell'utente, i valori di ritorno o le pre-condizioni.
    // Comportamento: Se fallisce, interrompe la transazione, fa il rollback dello stato e RITORNA il gas avanzato.
    function prelevaConRequire(uint _importo) public {
        // Controlla la condizione. Se è falsa, si ferma e sputa la stringa di errore
        require(_importo <= bilancioVirtuale, "Errore: Non hai abbastanza fondi!");
        
        bilancioVirtuale -= _importo;
    }

    // 2. IL PATTERN 'REVERT' (Con Custom Error)
    // Ideale per: Logiche condizionali complesse (es. dentro un IF annidato).
    // Comportamento: Esattamente come il require, ma permette di passare variabili nell'errore per il frontend.
    function prelevaConRevert(uint _importo) public {
        if (_importo > bilancioVirtuale) {
            // Lanciamo l'errore personalizzato passando dati utili
            revert FondiInsufficienti({
                richiesto: _importo,
                disponibile: bilancioVirtuale
            });
        }

        bilancioVirtuale -= _importo;
    }

    // Altro esempio di revert classico (utile nei modificatori)
    function bloccaNonOwner() public view {
        if (msg.sender != owner) {
            revert NonSeiIlProprietario();
        }
    }

    // 3. IL PATTERN 'ASSERT'
    // Ideale per: Controllare invarianti di stato, bug interni del codice o condizioni che non dovrebbero MAI essere false.
    // Comportamento: Se fallisce, significa che c'è un bug grave nel tuo codice. Genera un errore di tipo "Panic" (0x01).
    function riduciBilancio(uint _quantita) public {
        // Eseguiamo l'operazione normalmente
        bilancioVirtuale -= _quantita;

        // ASSERT DI SICUREZZA: 
        // In una sottrazione matematica, il bilancio iniziale DEVE essere per forza maggiore o uguale al bilancio finale.
        // Se questa cosa fosse falsa, significherebbe che la EVM ha svalvolato o c'è un bug matematico assurdo.
        assert(bilancioVirtuale <= bilancioVirtuale + _quantita);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bersaglio {
    string public ultimoMetodoChiamato;
    uint public bilancioContratto;

    // 1. Si attiva quando riceve SOLO Ether (senza dati / transazione vuota)
    receive() external payable {
        ultimoMetodoChiamato = "RECEIVE (Solo Ether)";
        bilancioContratto = address(this).balance;
    }

    // 2. Si attiva quando la funzione chiamata NON esiste (con o senza Ether)
    fallback() external payable {
        ultimoMetodoChiamato = "FALLBACK (Funzione inesistente o dati casuali)";
        bilancioContratto = address(this).balance;
    }
}

contract Chiamante {
    // Rendiamo il contratto Chiamante in grado di ospitare fondi per fare i test
    constructor() payable {}

    // TEST 1: Chiamiamo una funzione che NON esiste sul contratto Bersaglio
    function chiamaFunzioneInesistente(address bersaglio) public returns (bool) {
        // Inviamo dei dati casuali che la EVM non riconoscerà
        (bool success, ) = bersaglio.call(abi.encodeWithSignature("funzioneCheNonEsiste()"));
        require(success, "La chiamata a vuoto e fallita");
        return success; // Controllerai su Bersaglio: sara scattato il FALLBACK
    }

    // TEST 2: Inviamo SOLO Ether al contratto Bersaglio (senza calldata)
    function inviaSoloEther(address payable bersaglio) public returns (bool) {
        // Usiamo .call per trasferire 1 Ether. Stringa vuota "" significa "niente dati"
        (bool success, ) = bersaglio.call{value: 1 ether}("");
        require(success, "Il trasferimento di Ether e fallito");
        return success; // Controllerai su Bersaglio: sara scattato il RECEIVE
    }

    // TEST 3: Inviamo SIA Ether CHE una funzione inesistente contemporaneamente
    function inviaEtherEFunzioneInesistente(address payable bersaglio) public returns (bool) {
        (bool success, ) = bersaglio.call{value: 1 ether}(abi.encodeWithSignature("pagaEChiamaInesistente()"));
        require(success, "La chiamata mista e fallita");
        return success; // Controllerai su Bersaglio: sara scattato il FALLBACK (perche ci sono dati)
    }
}
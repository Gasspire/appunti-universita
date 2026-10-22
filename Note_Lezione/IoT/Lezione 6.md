I 4 indirizzi della frame wi-fi serve per la questione di + access point per la stessa rete.

Wi-Fi Joining
![[Pasted image 20261022171928.png]]

Discovery: Il Wifi non fa altro che ogni tanto dire "a caso" chi è, ecc.
Auth + assoc: password che autentica l'access point.
Chiave di sessione: crittografia simmetrica
IP: l'access point poi comunica con la rete

Sicurezza Wifi
![[Pasted image 20261022172402.png]]


Figo il wifi perché compatibile con tcp/ip ecc. tutte le infrastrutture funzionano in quel modo, però il problema è che ha consumi energetici enormi.

Gli AP hanno un numero limitato di dispositivi che possono gestire (in base al numero di moduli wifi che hanno). Un altro problema sono SSID e password in chiaro (anche se si può fare qualcosa per questo). Puoi anche rendere il mcu stesso un AP e utilizzarlo per poi dare un web server e tramite il web server stesso inseriamo ssid e password. Stessa cosa con bluetooth, chiavetta RFID, WPS e QR.

Il MCU può andare in deep sleep e poi svegliarsi solo all'accadere di certi eventi o certo tempo (così risparmiamo batteria.)

Con Wi-Fi 6 è possibile attivare il Wake dal wifi.

![[Pasted image 20261022174324.png]]

![[Pasted image 20261022180922.png]]
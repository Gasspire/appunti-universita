**Cosa sono i sistemi embedded?**
Un computer designato per specifiche applicazioni.

All'interno di un microcontrollore c'è un mini computer. C'è una cpu, un oscillatore interno, una flash memory, una RAM e I/O.

Nel micrcontrollore c'è tutto, il microprocessore no. Il microprocessore ha i bus, nel microcontrollore il bus è interno non accessibile e i vari pin sono innestati su I/O (?)

Impariamo a utilizzare le periferiche I/O in C.

**Come funzionano Software?**
Sul "metallo" (?). Lo scarichiamo sul microcontrollore e parte il main. Siamo a diretto contatto con l'hardware e non c'è il SO che interagisce come intermediario.

Gestiamo noi gli interrupt ecc. 
Si può avere un minimo di multitasking.

Tipico *design pattern*:
![[Pasted image 20261002112708.png]]

**Come lo programmiamo?**
Ambiente di sviluppo + compilatore per l'architettura target del microcontrollore. C.

In circuit debugger programmer consente l'u


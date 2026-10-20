Alla init si parte con master o main. È la linea storica "canon" che deve sempre essere stabile.

Quando lavori a una feature, cambi branch (ramo) che poi, finita la serie di commit, si fa il merge dei branch.

La branch main deve essere stabile cioè la versione di produzione.

Prima di fare la merge si fanno tutta una serie di controlli e solo quando passa si fa il merge.

Non si pusha sul main, si fanno solo merge.

Con `git merge main` aggiorno il branch corrente unendovi le modifiche del `main` locale. 
Con `git checkout branch-x` (o il comando più moderno `git switch branch-x`) passo a un branch esistente, mentre per crearne uno nuovo e passarvi contemporaneamente uso `git checkout -b nuovo-branch` (oppure `git switch -c nuovo-branch`). 
Per fare il merge di `branch-x` sul `main`, mi posiziono prima sul `main` con `git switch main` e poi eseguo `git merge branch-x`. 
Durante questa operazione possono verificarsi dei conflitti di merge (_merge conflict_), che richiedono di essere risolti manualmente.

git kraken, estensione utile a capire chi lavora su cosa e mostra il tutto.

git restore per fare rollback di un file.

---
**Convenzioni per commit e branch**
![[Pasted image 20261016160454.png]]

---
Esistono delle impostazioni per dare regole di branch ecc.

.gitignore: file che non devono essere oggetto di commit etc. 
questo va' pushato.

---
GIT LFS

Su github non si pushano file pesanti (tra cui .exe, pdf, file 3D etc.)

---
## GitHub

GitLab posso hostarlo da me.

Codeberg è l'alternativa a tutto il resto.

Fork: creo una copia sul mio profilo di una certa repo ma io ho tutti i permessi.

---

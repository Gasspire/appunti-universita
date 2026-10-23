## Conflitti in Git

```
git stash
git resolve, add, commit
git merge or rebase
git reflog
git submodule
```

Alcune volte potremmo trovarci a voler pullare commit che hanno modificato lo stesso file a cui abbiamo fatto modifiche in locale finendo in conflitto.
In quel caso possiamo fare **git stash** per togliere le modifiche locali (prima del commit), fare il pull per prenderci le modifiche remote e poi effettuare **git stash pop** per riprenderci le modifiche già fatte (CASO SENZA CONFLITTO).

Con **git stash list** vediamo tutti i cambiamenti "messi da parte".

I conflitti possono essere risolti in vari modi:
- Accetta entrambi (mette uno dietro l'altro)
- Ne accetti solo uno.

O faccio il merge di tutti i commit e sul main aggiungerò tutti i commit sul main, altrimenti se metto **squash and merge** unifico tutti i commit in uno solo.
Nel caso di **git rebase** "effettua" tutti i commit della branch sul main.

Git cherry-pick puoi prendere certi commit e applicarli alla tua branch.

## Pipeline - Github Actions

Quando facciamo un commit, possiamo triggerare una pipeline che può far partire delle github actions o dei test. 

Quando le pipeline danno l'okay su tutto il nostro software è pronto per il deploy. Allo stesso modo può accadere quando si fa il deploy, cioè può partire un'altra pipeline.


---

## tennis 

---

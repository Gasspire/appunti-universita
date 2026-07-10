---
status: done
priority: normal
scheduled: 2026-07-06
dateCreated: 2026-07-06T12:21:51.705+02:00
dateModified: 2026-07-10T10:16:47.279+02:00
tags:
  - task
tasknotes_manual_order: tnqgmzzzzzzx
completedDate: 2026-07-10
---

Raccogliere metriche: 
**Speedup**: $S(P,T) = \frac{T_{seq}}{T_{par}(P,T)}$
**Efficiency**: $$\mathbf{E(P, T) = \frac{S(P, T)}{N_{core}} = \frac{T_{seq}}{N_{core} \times T_{par}(P, T)}}$$
**Strong Scaling**: Si mantiene la dimensione del problema **$N$ rigidamente fissa** (es. analizzi solo la matrice $1024 \times 1024$) e si aumenta gradualmente il numero di core totali. L'obiettivo è vedere quanto si riduce il tempo risolvendo _lo stesso identico problema_ con più forza bruta.

**Weak Scaling**: Si aumenta il numero di core e contemporaneamente si aumenta la dimensione della matrice, mantenendo fisso il carico di lavoro su ogni singolo core.

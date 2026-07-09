# Benchmark Equazione del Calore 2D (Solo Ibrido) - 09/07/2026 22:25

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 2472.9396 secondi

## 2. Test Paralleli (Strong Scaling Ibrido - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8P x 1T | **Ibrido** | `heat_hybrid` | 1963.7688 | 1.26x | 0.16 |

# Benchmark Equazione del Calore 2D - 06/07/2026 19:04

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 2537.8130 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8P x 1T | **MPI Puro** | `heat_mpi` | 1997.8275 | 1.27x | 0.16 |
| 8P x 1T | **Ibrido** | `heat_hybrid` | 1989.6354 | 1.28x | 0.16 |
| 4P x 2T | **Ibrido** | `heat_hybrid` | 1906.3965 | 1.33x | 0.17 |
| 2P x 4T | **Ibrido** | `heat_hybrid` | 2029.2082 | 1.25x | 0.16 |
| 1P x 8T | **OMP Puro** | `heat_omp` | 1875.7015 | 1.35x | 0.17 |
| 1P x 8T | **Ibrido** | `heat_hybrid` | 2223.8059 | 1.14x | 0.14 |

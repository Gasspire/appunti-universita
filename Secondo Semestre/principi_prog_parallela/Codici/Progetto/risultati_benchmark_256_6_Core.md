# Benchmark Equazione del Calore 2D - 11/07/2026 17:12

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 7.0592 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 1.8155 | 3.89x | 0.65 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 2.1290 | 3.32x | 0.55 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 2.2488 | 3.14x | 0.52 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 7.7030 | 0.92x | 0.15 |
| 1P x 6T | **OMP Puro** | `heat_omp` | 1.7785 | 3.97x | 0.66 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 14.0423 | 0.50x | 0.08 |

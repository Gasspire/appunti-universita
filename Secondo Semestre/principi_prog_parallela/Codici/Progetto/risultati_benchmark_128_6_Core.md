# Benchmark Equazione del Calore 2D - 12/07/2026 11:38

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 0.4522 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 0.2845 | 1.59x | 0.26 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 0.4051 | 1.12x | 0.19 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 0.3385 | 1.34x | 0.22 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 1.4044 | 0.32x | 0.05 |
| 1P x 6T | **OMP Puro** | `heat_omp` | 0.2415 | 1.87x | 0.31 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 2.4253 | 0.19x | 0.03 |

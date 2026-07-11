# Benchmark Equazione del Calore 2D - 11/07/2026 17:05

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 0.0294 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 0.0336 | 0.87x | 0.15 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 0.0473 | 0.62x | 0.10 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 0.0535 | 0.55x | 0.09 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 0.2955 | 0.10x | 0.02 |
| 1P x 6T | **OMP Puro** | `heat_omp` | 0.0231 | 1.27x | 0.21 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 0.5522 | 0.05x | 0.01 |

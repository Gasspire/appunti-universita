# Benchmark Equazione del Calore 2D - 07/07/2026 17:42

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 0.4715 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8P x 1T | **MPI Puro** | `heat_mpi` | 0.3052 | 1.54x | 0.19 |
| 8P x 1T | **Ibrido** | `heat_hybrid` | 0.3516 | 1.34x | 0.17 |
| 4P x 2T | **Ibrido** | `heat_hybrid` | 0.3726 | 1.27x | 0.16 |
| 2P x 4T | **Ibrido** | `heat_hybrid` | 1.7333 | 0.27x | 0.03 |
| 1P x 8T | **OMP Puro** | `heat_omp` | 0.2807 | 1.68x | 0.21 |
| 1P x 8T | **Ibrido** | `heat_hybrid` | 3.0666 | 0.15x | 0.02 |

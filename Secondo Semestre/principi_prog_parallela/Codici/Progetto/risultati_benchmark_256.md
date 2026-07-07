# Benchmark Equazione del Calore 2D - 07/07/2026 17:44

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 7.1670 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8P x 1T | **MPI Puro** | `heat_mpi` | 2.7850 | 2.57x | 0.32 |
| 8P x 1T | **Ibrido** | `heat_hybrid` | 2.9862 | 2.40x | 0.30 |
| 4P x 2T | **Ibrido** | `heat_hybrid` | 3.0860 | 2.32x | 0.29 |
| 2P x 4T | **Ibrido** | `heat_hybrid` | 9.1423 | 0.78x | 0.10 |
| 1P x 8T | **OMP Puro** | `heat_omp` | 4.0028 | 1.79x | 0.22 |
| 1P x 8T | **Ibrido** | `heat_hybrid` | 16.9584 | 0.42x | 0.05 |

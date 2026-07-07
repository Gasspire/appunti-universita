# Benchmark Equazione del Calore 2D - 07/07/2026 17:41

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 0.0292 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8P x 1T | **MPI Puro** | `heat_mpi` | 0.0597 | 0.49x | 0.06 |
| 8P x 1T | **Ibrido** | `heat_hybrid` | 0.0787 | 0.37x | 0.05 |
| 4P x 2T | **Ibrido** | `heat_hybrid` | 0.0725 | 0.40x | 0.05 |
| 2P x 4T | **Ibrido** | `heat_hybrid` | 0.4299 | 0.07x | 0.01 |
| 1P x 8T | **OMP Puro** | `heat_omp` | 0.0356 | 0.82x | 0.10 |
| 1P x 8T | **Ibrido** | `heat_hybrid` | 0.7429 | 0.04x | 0.00 |

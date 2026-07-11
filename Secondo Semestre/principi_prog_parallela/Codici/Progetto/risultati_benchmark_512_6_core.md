# Benchmark Equazione del Calore 2D - 11/07/2026 16:05

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 115.7082 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 30.3836 | 3.81x | 0.63 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 33.0548 | 3.50x | 0.58 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 32.0592 | 3.61x | 0.60 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 84.5014 | 1.37x | 0.23 |
| 1P x 6T | **OMP Puro** | `heat_omp` | 26.7299 | 4.33x | 0.72 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 135.0858 | 0.86x | 0.14 |

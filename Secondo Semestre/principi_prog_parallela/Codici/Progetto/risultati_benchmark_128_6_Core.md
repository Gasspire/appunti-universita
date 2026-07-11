# Benchmark Equazione del Calore 2D - 11/07/2026 17:10

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 0.4756 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 0.2441 | 1.95x | 0.32 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 0.0497 | 9.56x | 1.59 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 0.0583 | 8.16x | 1.36 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 0.2959 | 1.61x | 0.27 |
| 1P x 6T | **OMP Puro** | `heat_omp` | 0.1819 | 2.61x | 0.44 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 0.5589 | 0.85x | 0.14 |

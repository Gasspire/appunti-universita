# Benchmark Equazione del Calore 2D - 06/07/2026 18:36

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 118.1620 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8P x 1T | **MPI Puro** | `heat_mpi` | 42.9101 | 2.75x | 0.34 |
| 8P x 1T | **Ibrido** | `heat_hybrid` | 47.5536 | 2.48x | 0.31 |
| 4P x 2T | **Ibrido** | `heat_hybrid` | 44.9748 | 2.63x | 0.33 |
| 2P x 4T | **Ibrido** | `heat_hybrid` | 86.1391 | 1.37x | 0.17 |
| 1P x 8T | **OMP Puro** | `heat_omp` | 56.0069 | 2.11x | 0.26 |
| 1P x 8T | **Ibrido** | `heat_hybrid` | 146.8306 | 0.80x | 0.10 |

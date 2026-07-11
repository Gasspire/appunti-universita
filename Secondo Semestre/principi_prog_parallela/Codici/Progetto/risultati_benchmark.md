# Benchmark Equazione del Calore 2D - 11/07/2026 09:47

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 0.0295 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 1889.0450 | 0.00x | 0.00 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 1809.7681 | 0.00x | 0.00 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 1826.2143 | 0.00x | 0.00 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 2052.5263 | 0.00x | 0.00 |
| 1P x 6T | **OMP Puro** | `heat_omp` | 4.8620 | 0.01x | 0.00 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 2210.7054 | 0.00x | 0.00 |

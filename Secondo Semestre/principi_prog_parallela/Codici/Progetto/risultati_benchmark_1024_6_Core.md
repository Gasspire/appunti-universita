# Benchmark Equazione del Calore 2D - 11/07/2026 09:47

## 1. Versione Sequenziale (Baseline)
**Tempo Sequenziale:** 2537.8130 secondi

## 2. Test Paralleli (Strong Scaling - P x T = 8)
| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 6P x 1T | **MPI Puro** | `heat_mpi` | 1889.0450 | 1.34x | 0.22 |
| 6P x 1T | **Ibrido** | `heat_hybrid` | 1809.7681 | 1.40x | 0.23 |
| 3P x 2T | **Ibrido** | `heat_hybrid` | 1826.2143 | 1.39x | 0.23 |
| 2P x 3T | **Ibrido** | `heat_hybrid` | 2052.5263 | 1.23x | 0.20 |
| 1P x 6T | **Ibrido** | `heat_hybrid` | 2210.7054 | 1.14x | 0.19 |

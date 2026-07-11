# Analisi Strong Scaling Completa (N=512 Fisso) - 11/07/2026 09:34

## 1. Versione Sequenziale (Baseline $T_1$)
**Tempo Sequenziale (1 Core):** 0.0290 secondi

## 2. Test Paralleli a Risorse Crescenti
| Modello | Core Totali | Configurazione | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **MPI Puro** | 1 | 1P x 1T | 0.0324 | 0.90x | 0.90 |
| **MPI Puro** | 2 | 2P x 1T | 0.0230 | 1.26x | 0.63 |
| **MPI Puro** | 4 | 4P x 1T | 0.0274 | 1.06x | 0.26 |
| **MPI Puro** | 6 | 6P x 1T | 0.0367 | 0.79x | 0.13 |
| **MPI Puro** | 8 | 8P x 1T | 0.0435 | 0.67x | 0.08 |
| **OMP Puro** | 1 | 1P x 1T | 0.0484 | 0.60x | 0.60 |
| **OMP Puro** | 2 | 1P x 2T | 0.0430 | 0.67x | 0.34 |
| **OMP Puro** | 4 | 1P x 4T | 0.0337 | 0.86x | 0.22 |
| **OMP Puro** | 6 | 1P x 6T | 0.0299 | 0.97x | 0.16 |
| **OMP Puro** | 8 | 1P x 8T | 0.0328 | 0.88x | 0.11 |
| **Ibrido** | 2 | 1P x 2T | 0.0511 | 0.57x | 0.28 |
| **Ibrido** | 4 | 2P x 2T | 0.0348 | 0.83x | 0.21 |
| **Ibrido** | 6 | 2P x 3T | 0.2889 | 0.10x | 0.02 |
| **Ibrido** | 6 | 3P x 2T | 0.0469 | 0.62x | 0.10 |
| **Ibrido** | 8 | 4P x 2T | 0.0547 | 0.53x | 0.07 |

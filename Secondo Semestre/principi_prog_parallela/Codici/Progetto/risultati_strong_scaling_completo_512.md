# Analisi Strong Scaling Completa (N=512 Fisso) - 11/07/2026 07:55

## 1. Versione Sequenziale (Baseline $T_1$)
**Tempo Sequenziale (1 Core):** 118.6096 secondi

## 2. Test Paralleli a Risorse Crescenti
| Modello | Core Totali | Configurazione | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **MPI Puro** | 1 | 1P x 1T | 122.0479 | 0.97x | 0.97 |
| **MPI Puro** | 2 | 2P x 1T | 63.9861 | 1.85x | 0.93 |
| **MPI Puro** | 4 | 4P x 1T | 37.3430 | 3.18x | 0.79 |
| **MPI Puro** | 6 | 6P x 1T | 30.9432 | 3.83x | 0.64 |
| **MPI Puro** | 8 | 8P x 1T | 44.9398 | 2.64x | 0.33 |
| **OMP Puro** | 1 | 1P x 1T | 168.1564 | 0.71x | 0.71 |
| **OMP Puro** | 2 | 1P x 2T | 83.8870 | 1.41x | 0.71 |
| **OMP Puro** | 4 | 1P x 4T | 50.0495 | 2.37x | 0.59 |
| **OMP Puro** | 6 | 1P x 6T | 39.1823 | 3.03x | 0.50 |
| **OMP Puro** | 8 | 1P x 8T | 53.6589 | 2.21x | 0.28 |
| **Ibrido** | 2 | 1P x 2T | 106.9145 | 1.11x | 0.55 |
| **Ibrido** | 4 | 2P x 2T | 62.4448 | 1.90x | 0.47 |
| **Ibrido** | 6 | 2P x 3T | 85.7975 | 1.38x | 0.23 |
| **Ibrido** | 6 | 3P x 2T | 31.3487 | 3.78x | 0.63 |
| **Ibrido** | 8 | 4P x 2T | 42.3029 | 2.80x | 0.35 |

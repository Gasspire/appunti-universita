# Analisi Strong Scaling Completa (N=512 Fisso) - 11/07/2026 09:38

## 1. Versione Sequenziale (Baseline $T_1$)
**Tempo Sequenziale (1 Core):** 0.4885 secondi

## 2. Test Paralleli a Risorse Crescenti
| Modello | Core Totali | Configurazione | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **MPI Puro** | 1 | 1P x 1T | 0.4679 | 1.04x | 1.04 |
| **MPI Puro** | 2 | 2P x 1T | 0.2612 | 1.87x | 0.94 |
| **MPI Puro** | 4 | 4P x 1T | 0.2002 | 2.44x | 0.61 |
| **MPI Puro** | 6 | 6P x 1T | 0.1907 | 2.56x | 0.43 |
| **MPI Puro** | 8 | 8P x 1T | 0.2694 | 1.81x | 0.23 |
| **OMP Puro** | 1 | 1P x 1T | 0.7191 | 0.68x | 0.68 |
| **OMP Puro** | 2 | 1P x 2T | 0.4024 | 1.21x | 0.61 |
| **OMP Puro** | 4 | 1P x 4T | 0.2696 | 1.81x | 0.45 |
| **OMP Puro** | 6 | 1P x 6T | 0.2475 | 1.97x | 0.33 |
| **OMP Puro** | 8 | 1P x 8T | 0.3001 | 1.63x | 0.20 |
| **Ibrido** | 2 | 1P x 2T | 0.4815 | 1.01x | 0.51 |
| **Ibrido** | 4 | 2P x 2T | 0.2976 | 1.64x | 0.41 |
| **Ibrido** | 6 | 2P x 3T | 1.2470 | 0.39x | 0.07 |
| **Ibrido** | 6 | 3P x 2T | 0.2675 | 1.83x | 0.30 |
| **Ibrido** | 8 | 4P x 2T | 0.3662 | 1.33x | 0.17 |

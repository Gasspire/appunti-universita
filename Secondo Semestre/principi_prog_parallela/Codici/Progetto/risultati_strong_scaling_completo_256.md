# Analisi Strong Scaling Completa (N=512 Fisso) - 11/07/2026 09:39

## 1. Versione Sequenziale (Baseline $T_1$)
**Tempo Sequenziale (1 Core):** 7.0167 secondi

## 2. Test Paralleli a Risorse Crescenti
| Modello | Core Totali | Configurazione | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **MPI Puro** | 1 | 1P x 1T | 7.1218 | 0.99x | 0.99 |
| **MPI Puro** | 2 | 2P x 1T | 3.8228 | 1.84x | 0.92 |
| **MPI Puro** | 4 | 4P x 1T | 2.4795 | 2.83x | 0.71 |
| **MPI Puro** | 6 | 6P x 1T | 2.0786 | 3.38x | 0.56 |
| **MPI Puro** | 8 | 8P x 1T | 2.9130 | 2.41x | 0.30 |
| **OMP Puro** | 1 | 1P x 1T | 11.0949 | 0.63x | 0.63 |
| **OMP Puro** | 2 | 1P x 2T | 5.8006 | 1.21x | 0.60 |
| **OMP Puro** | 4 | 1P x 4T | 3.5347 | 1.99x | 0.50 |
| **OMP Puro** | 6 | 1P x 6T | 2.8469 | 2.46x | 0.41 |
| **OMP Puro** | 8 | 1P x 8T | 3.7553 | 1.87x | 0.23 |
| **Ibrido** | 2 | 1P x 2T | 6.9762 | 1.01x | 0.50 |
| **Ibrido** | 4 | 2P x 2T | 3.9447 | 1.78x | 0.44 |
| **Ibrido** | 6 | 2P x 3T | 7.8125 | 0.90x | 0.15 |
| **Ibrido** | 6 | 3P x 2T | 2.4386 | 2.88x | 0.48 |
| **Ibrido** | 8 | 4P x 2T | 3.1824 | 2.20x | 0.28 |

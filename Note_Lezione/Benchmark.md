# Benchmark Equazione del Calore 2D N: 64 - 07/07/2026 17:41

  

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

# Benchmark Equazione del Calore 2D N: 128 - 07/07/2026 17:42

  

## 1. Versione Sequenziale (Baseline)

**Tempo Sequenziale:** 0.4715 secondi

  

## 2. Test Paralleli (Strong Scaling - P x T = 8)

| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |

| :--- | :--- | :--- | :--- | :--- | :--- |

| 8P x 1T | **MPI Puro** | `heat_mpi` | 0.3052 | 1.54x | 0.19 |

| 8P x 1T | **Ibrido** | `heat_hybrid` | 0.3516 | 1.34x | 0.17 |

| 4P x 2T | **Ibrido** | `heat_hybrid` | 0.3726 | 1.27x | 0.16 |

| 2P x 4T | **Ibrido** | `heat_hybrid` | 1.7333 | 0.27x | 0.03 |

| 1P x 8T | **OMP Puro** | `heat_omp` | 0.2807 | 1.68x | 0.21 |

| 1P x 8T | **Ibrido** | `heat_hybrid` | 3.0666 | 0.15x | 0.02 |

# Benchmark Equazione del Calore 2D N: 256 - 07/07/2026 17:44

  

## 1. Versione Sequenziale (Baseline)

**Tempo Sequenziale:** 7.1670 secondi

  

## 2. Test Paralleli (Strong Scaling - P x T = 8)

| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |

| :--- | :--- | :--- | :--- | :--- | :--- |

| 8P x 1T | **MPI Puro** | `heat_mpi` | 2.7850 | 2.57x | 0.32 |

| 8P x 1T | **Ibrido** | `heat_hybrid` | 2.9862 | 2.40x | 0.30 |

| 4P x 2T | **Ibrido** | `heat_hybrid` | 3.0860 | 2.32x | 0.29 |

| 2P x 4T | **Ibrido** | `heat_hybrid` | 9.1423 | 0.78x | 0.10 |

| 1P x 8T | **OMP Puro** | `heat_omp` | 4.0028 | 1.79x | 0.22 |

| 1P x 8T | **Ibrido** | `heat_hybrid` | 16.9584 | 0.42x | 0.05 |

# Benchmark Equazione del Calore 2D N: 512 - 06/07/2026 18:36

  

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


# Benchmark Equazione del Calore 2D N: 1024 - 06/07/2026 19:04

  

## 1. Versione Sequenziale (Baseline)

**Tempo Sequenziale:** 2537.8130 secondi

  

## 2. Test Paralleli (Strong Scaling - P x T = 8)

| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |

| :--- | :--- | :--- | :--- | :--- | :--- |

| 8P x 1T | **MPI Puro** | `heat_mpi` | 1997.8275 | 1.27x | 0.16 |

| 8P x 1T | **Ibrido** | `heat_hybrid` | 1989.6354 | 1.28x | 0.16 |

| 4P x 2T | **Ibrido** | `heat_hybrid` | 1906.3965 | 1.33x | 0.17 |

| 2P x 4T | **Ibrido** | `heat_hybrid` | 2029.2082 | 1.25x | 0.16 |

| 1P x 8T | **OMP Puro** | `heat_omp` | 1875.7015 | 1.35x | 0.17 |

| 1P x 8T | **Ibrido** | `heat_hybrid` | 2223.8059 | 1.14x | 0.14 |


---
## Numero di Cache Miss

#### N: 64
```
Simulazione completata in 8334 iterazioni.
Tempo di esecuzione ibrido: 0.080435 secondi.

 Performance counter stats for 'mpirun -np 4 --oversubscribe ./heat_hybrid':

       111.901.236      cache-references                                                        (83,47%)
        17.297.764      cache-misses                     #   15,46% of all cache refs           (82,70%)
     3.253.691.330      cycles                                                                  (83,45%)
     2.450.032.746      instructions                     #    0,75  insn per cycle              (83,64%)
       443.860.023      branches                                                                (83,61%)
        14.056.749      branch-misses                    #    3,17% of all branches             (83,13%)
            11.348      page-faults                                                           

       0,441280401 seconds time elapsed

       0,694601000 seconds user
       0,191211000 seconds sys
```
#### N:128
```
Simulazione completata in 31585 iterazioni.
Tempo di esecuzione ibrido: 0.379968 secondi.

 Performance counter stats for 'mpirun -np 4 --oversubscribe ./heat_hybrid':

       477.266.571      cache-references                                                        (83,22%)
        50.825.034      cache-misses                     #   10,65% of all cache refs           (83,47%)
    12.080.346.583      cycles                                                                  (83,35%)
    11.406.929.134      instructions                     #    0,94  insn per cycle              (83,39%)
     1.552.762.439      branches                                                                (83,21%)
        27.019.267      branch-misses                    #    1,74% of all branches             (83,37%)
            11.374      page-faults                                                           

       0,748811711 seconds time elapsed

       3,037767000 seconds user
       0,279281000 seconds sys
```

#### N: 256
```
Simulazione completata in 118160 iterazioni.
Tempo di esecuzione ibrido: 3.243834 secondi.

 Performance counter stats for 'mpirun -np 4 --oversubscribe ./heat_hybrid':

     4.126.193.278      cache-references                                                        (83,33%)
       253.524.382      cache-misses                     #    6,14% of all cache refs           (83,33%)
    87.611.421.607      cycles                                                                  (83,34%)
   125.319.851.571      instructions                     #    1,43  insn per cycle              (83,34%)
    13.999.038.254      branches                                                                (83,32%)
       103.306.348      branch-misses                    #    0,74% of all branches             (83,34%)
            11.593      page-faults                                                           

       3,626227458 seconds time elapsed

      25,616134000 seconds user
       0,628633000 seconds sy
```
#### N: 512
```
Simulazione completata in 437720 iterazioni.
Tempo di esecuzione ibrido: 43.772035 secondi.

 Performance counter stats for 'mpirun -np 4 --oversubscribe ./heat_hybrid':

    75.128.188.322      cache-references                                                        (83,33%)
     4.625.242.796      cache-misses                     #    6,16% of all cache refs           (83,33%)
 1.040.699.668.913      cycles                                                                  (83,33%)
 1.538.582.779.108      instructions                     #    1,48  insn per cycle              (83,33%)
   148.238.893.995      branches                                                                (83,34%)
     1.009.665.776      branch-misses                    #    0,68% of all branches             (83,33%)
            12.366      page-faults                                                           

      44,134570638 seconds time elapsed

     336,697307000 seconds user
      13,321094000 seconds sys
```
#### N: 1024
```
Simulazione completata in 1607108 iterazioni.
Tempo di esecuzione ibrido: 1942.127437 secondi.

 Performance counter stats for 'mpirun -np 4 --oversubscribe ./heat_hybrid':

 1.175.883.003.967      cache-references                                                        (83,33%)
    48.616.082.903      cache-misses                     #    4,13% of all cache refs           (83,33%)
53.362.553.227.245      cycles                                                                  (83,33%)
24.435.674.630.849      instructions                     #    0,46  insn per cycle              (83,33%)
 2.528.987.844.238      branches                                                                (83,33%)
    10.097.991.867      branch-misses                    #    0,40% of all branches             (83,33%)
            16.866      page-faults                                                           

    1942,502456038 seconds time elapsed

   15349,030770000 seconds user
     183,860811000 seconds sys
```
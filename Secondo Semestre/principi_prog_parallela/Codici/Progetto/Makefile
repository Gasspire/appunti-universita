CC = gcc
MPICC = mpicc

CFLAGS = -O2 -Wall
OMPFLAGS = -fopenmp

EXEC_SEQ = heat_seq
EXEC_MPI = heat_mpi
EXEC_HYBRID = heat_hybrid
EXEC_OMP = heat_omp

all: $(EXEC_SEQ) $(EXEC_MPI) $(EXEC_HYBRID) $(EXEC_OMP)


$(EXEC_SEQ): heat_seq_3.c
	$(CC) $(CFLAGS) $< -o $@

$(EXEC_MPI): heat_mpi.c
	$(MPICC) $(CFLAGS) $< -o $@

$(EXEC_HYBRID): heat_hybrid_1.c
	$(MPICC) $(CFLAGS) $(OMPFLAGS) $< -o $@

$(EXEC_OMP): heat_omp.c
	$(CC) $(CFLAGS) $(OMPFLAGS) $< -o $@

clean:
	rm -f $(EXEC_SEQ) $(EXEC_MPI) $(EXEC_HYBRID) $(EXEC_OMP)
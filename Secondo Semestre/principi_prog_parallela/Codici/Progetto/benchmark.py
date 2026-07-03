import subprocess
import re
import os

# ==========================================
# CONFIGURAZIONE DEL BENCHMARK
# ==========================================
# Le configurazioni richieste dal prof a parità di core (PxT = 8)
configs = [
    {"P": 8, "T": 1},
    {"P": 4, "T": 2},
    {"P": 2, "T": 4},
    {"P": 1, "T": 8}
]

# Modifica questo flag a True se il tuo PC ha meno di 8 core fisici 
# e mpirun ti dà errore quando provi a lanciare 8 processi.
USE_OVERSUBSCRIBE = True 

def extract_time(output):
    """Estrae il tempo usando una Regex che copre le 3 stampe dei tuoi file C"""
    match = re.search(r"Tempo di esecuzione(?:.*): ([0-9.]+) secondi", output)
    if match:
        return float(match.group(1))
    return None

def run_cmd(cmd, env_vars=None):
    """Esegue un comando nel terminale e restituisce l'output"""
    try:
        result = subprocess.run(cmd, env=env_vars, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"ERRORE NELL'ESECUZIONE DI: {' '.join(cmd)}")
        print(e.stderr)
        return None

def main():
    print("Inizio Benchmark per l'Equazione del Calore 2D...\n")
    
    # 1. ESECUZIONE SEQUENZIALE (Baseline)
    print("1. Esecuzione Versione Sequenziale (Baseline)...")
    out_seq = run_cmd(["./heat_seq"])
    if not out_seq:
        print("Errore: assicurati di aver compilato ./heat_seq con 'make'")
        return
        
    t_seq = extract_time(out_seq)
    print(f"   Tempo Sequenziale: {t_seq:.4f} sec\n")

    # Preparazione tabella Markdown
    print("2. Esecuzione Test Paralleli (MPI puro e Ibrido)...\n")
    print("| Configurazione | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |")
    print("| :--- | :--- | :--- | :--- | :--- |")

    # 2. ESECUZIONE DELLE CONFIGURAZIONI PARALLELE
    for conf in configs:
        p = conf["P"]
        t = conf["T"]
        core_totali = p * t
        
        # --- TEST MPI PURO ---
        # L'MPI puro usa solo processi, i thread sono ignorati, ma lo lanciamo solo quando T=1
        # come termine di paragone per il PxT = 8 (es. 8P x 1T).
        if t == 1:
            cmd_mpi = ["mpirun", "-np", str(p)]
            if USE_OVERSUBSCRIBE:
                cmd_mpi.insert(1, "--oversubscribe")
            cmd_mpi.append("./heat_mpi")
            
            out_mpi = run_cmd(cmd_mpi)
            t_mpi = extract_time(out_mpi) if out_mpi else None
            
            if t_mpi:
                speedup = t_seq / t_mpi
                efficienza = speedup / core_totali
                print(f"| {p}P x {t}T | MPI Puro (`heat_mpi`) | {t_mpi:.4f} | {speedup:.2f}x | {efficienza:.2f} |")

        # --- TEST IBRIDO ---
        cmd_hybrid = ["mpirun", "-np", str(p)]
        if USE_OVERSUBSCRIBE:
            cmd_hybrid.insert(1, "--oversubscribe")
        cmd_hybrid.append("./heat_hybrid")

        # Impostiamo il numero di Thread OpenMP tramite variabile d'ambiente
        env = os.environ.copy()
        env["OMP_NUM_THREADS"] = str(t)

        out_hybrid = run_cmd(cmd_hybrid, env_vars=env)
        t_hybrid = extract_time(out_hybrid) if out_hybrid else None

        if t_hybrid:
            speedup = t_seq / t_hybrid
            efficienza = speedup / core_totali
            print(f"| {p}P x {t}T | Ibrido (`heat_hybrid`) | {t_hybrid:.4f} | {speedup:.2f}x | {efficienza:.2f} |")

if __name__ == "__main__":
    main()
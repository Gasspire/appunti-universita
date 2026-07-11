import subprocess
import re
import os
from datetime import datetime

# ==========================================
# CONFIGURAZIONE DELLO STRONG SCALING
# ==========================================
# Problema fisso (N=512), risorse crescenti (1, 2, 4, 8 core).
configs = [
    # --- MPI PURO (Scala i Processi) ---
    {"modello": "MPI Puro", "P": 1, "T": 1, "exe": "./heat_mpi"},
    {"modello": "MPI Puro", "P": 2, "T": 1, "exe": "./heat_mpi"},
    {"modello": "MPI Puro", "P": 4, "T": 1, "exe": "./heat_mpi"},
    {"modello": "MPI Puro", "P": 6, "T": 1, "exe": "./heat_mpi"},
    {"modello": "MPI Puro", "P": 8, "T": 1, "exe": "./heat_mpi"},

    # --- OMP PURO (Scala i Thread) ---
    {"modello": "OMP Puro", "P": 1, "T": 1, "exe": "./heat_omp"},
    {"modello": "OMP Puro", "P": 1, "T": 2, "exe": "./heat_omp"},
    {"modello": "OMP Puro", "P": 1, "T": 4, "exe": "./heat_omp"},
    {"modello": "OMP Puro", "P": 1, "T": 6, "exe": "./heat_omp"},
    {"modello": "OMP Puro", "P": 1, "T": 8, "exe": "./heat_omp"},

    # --- IBRIDO (Thread fissi a 2, Scala i Processi) ---
    # Nota: 1Px2T (2 core), 2Px2T (4 core), 4Px2T (8 core)
    {"modello": "Ibrido", "P": 1, "T": 2, "exe": "./heat_hybrid"},
    {"modello": "Ibrido", "P": 2, "T": 2, "exe": "./heat_hybrid"},
    {"modello": "Ibrido", "P": 2, "T": 3, "exe": "./heat_hybrid"},
    {"modello": "Ibrido", "P": 3, "T": 2, "exe": "./heat_hybrid"},
    {"modello": "Ibrido", "P": 4, "T": 2, "exe": "./heat_hybrid"}
]

USE_OVERSUBSCRIBE = True 

def extract_time(output):
    match = re.search(r"Tempo di esecuzione(?:.*): ([0-9.]+) secondi", output)
    if match:
        return float(match.group(1))
    return None

def run_cmd(cmd, env_vars=None):
    try:
        result = subprocess.run(cmd, env=env_vars, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"ERRORE NELL'ESECUZIONE DI: {' '.join(cmd)}")
        print(e.stderr)
        return None

def write_log(message, file_handle):
    print(message)
    file_handle.write(message + "\n")

def main():
    filename = "risultati_strong_scaling_completo.md"
    
    with open(filename, "w") as f:
        write_log(f"# Analisi Strong Scaling Completa (N=512 Fisso) - {datetime.now().strftime('%d/%m/%Y %H:%M')}\n", f)
        
        # 1. BASELINE SEQUENZIALE (Fondamentale per calcolare lo Speedup di tutti)
        write_log("## 1. Versione Sequenziale (Baseline $T_1$)", f)
        out_seq = run_cmd(["./heat_seq"])
        if not out_seq:
            write_log("Errore: assicurati di aver compilato ./heat_seq", f)
            return
            
        t_seq = extract_time(out_seq)
        write_log(f"**Tempo Sequenziale (1 Core):** {t_seq:.4f} secondi\n", f)

        # 2. ESECUZIONE DEI TEST
        write_log("## 2. Test Paralleli a Risorse Crescenti", f)
        write_log("| Modello | Core Totali | Configurazione | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |", f)
        write_log("| :--- | :---: | :---: | :---: | :---: | :---: |", f)

        for conf in configs:
            modello = conf["modello"]
            p = conf["P"]
            t = conf["T"]
            exe = conf["exe"]
            core_totali = p * t

            # Imposta le variabili d'ambiente per i thread
            env = os.environ.copy()
            env["OMP_NUM_THREADS"] = str(t)

            cmd = []
            
            # Se è MPI o Ibrido, usiamo mpirun
            if "MPI" in modello or "Ibrido" in modello:
                cmd = ["mpirun", "-np", str(p)]
                if USE_OVERSUBSCRIBE:
                    cmd.insert(1, "--oversubscribe")
                cmd.append(exe)
            else:
                # Se è OMP puro, eseguiamo direttamente
                cmd = [exe]

            out = run_cmd(cmd, env_vars=env)
            t_par = extract_time(out) if out else None

            if t_par:
                speedup = t_seq / t_par
                efficienza = speedup / core_totali
                write_log(f"| **{modello}** | {core_totali} | {p}P x {t}T | {t_par:.4f} | {speedup:.2f}x | {efficienza:.2f} |", f)

        print(f"\n✅ Benchmark Completo Terminato! Dati salvati in '{filename}'")

if __name__ == "__main__":
    main()
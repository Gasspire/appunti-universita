import subprocess
import re
import os
from datetime import datetime

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
    """Estrae il tempo usando una Regex che copre le stampe dei tuoi file C"""
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

def write_log(message, file_handle):
    """Stampa a schermo e scrive contemporaneamente sul file"""
    print(message)
    file_handle.write(message + "\n")

def main():
    # Ho cambiato il nome del file per non sovrascrivere i test precedenti
    filename = "risultati_benchmark_hybrid.md"
    
    with open(filename, "w") as f:
        write_log(f"# Benchmark Equazione del Calore 2D (Solo Ibrido) - {datetime.now().strftime('%d/%m/%Y %H:%M')}\n", f)
        
        # 1. ESECUZIONE SEQUENZIALE (Baseline necessaria per Speedup)
        write_log("## 1. Versione Sequenziale (Baseline)", f)
        out_seq = run_cmd(["./heat_seq"])
        if not out_seq:
            write_log("Errore: assicurati di aver compilato ./heat_seq con 'make'", f)
            return
            
        t_seq = extract_time(out_seq)
        write_log(f"**Tempo Sequenziale:** {t_seq:.4f} secondi\n", f)

        # Preparazione tabella Markdown
        write_log("## 2. Test Paralleli (Strong Scaling Ibrido - P x T = 8)", f)
        write_log("| Configurazione | Modello | Eseguibile | Tempo (s) | Speedup $S(p)$ | Efficienza $E(p)$ |", f)
        write_log("| :--- | :--- | :--- | :--- | :--- | :--- |", f)

        # 2. ESECUZIONE DELLE CONFIGURAZIONI IBRIDE
        for conf in configs:
            p = conf["P"]
            t = conf["T"]
            core_totali = p * t

            # --- TEST IBRIDO ---
            cmd_hybrid = ["mpirun", "-np", str(p)]
            if USE_OVERSUBSCRIBE:
                cmd_hybrid.insert(1, "--oversubscribe")
            cmd_hybrid.append("./heat_hybrid")

            # Impostiamo il numero di Thread OpenMP
            env = os.environ.copy()
            env["OMP_NUM_THREADS"] = str(t)

            out_hybrid = run_cmd(cmd_hybrid, env_vars=env)
            t_hybrid = extract_time(out_hybrid) if out_hybrid else None

            if t_hybrid:
                speedup = t_seq / t_hybrid
                efficienza = speedup / core_totali
                write_log(f"| {p}P x {t}T | **Ibrido** | `heat_hybrid` | {t_hybrid:.4f} | {speedup:.2f}x | {efficienza:.2f} |", f)

        print(f"\n✅ Benchmark Ibrido completato! Tutti i dati sono stati salvati in: '{filename}'")

if __name__ == "__main__":
    main()
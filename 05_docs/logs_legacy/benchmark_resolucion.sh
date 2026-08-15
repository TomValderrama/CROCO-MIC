#!/bin/bash
# =============================================
# Benchmark de resolución y precisión para ILLUMINA
# Autor: Tomás Valderrama
# =============================================

EXPERIMENTO="experimento_maui"
LOGDIR="$HOME/work/illumina/${EXPERIMENTO}/benchmarks"
mkdir -p "$LOGDIR"

# === Parámetros a probar ===
NB_BINS_LIST=(5 9 15)              # resolución espectral
STOP_LIMIT_LIST=(1000 5000 20000)  # precisión numérica / criterio de convergencia
NCORES_LIST=(1 2 4 8 12 16)        # núcleos de ejecución

# === Archivo CSV de resultados ===
CSV="$LOGDIR/resultados.csv"
echo "NB_BINS,STOP_LIMIT,NCORES,TIME_s,MAX_CPU%,MAX_MEM_MB,OUTPUT_SIZE" > "$CSV"

# === Total de combinaciones ===
TOTAL=$(( ${#NB_BINS_LIST[@]} * ${#STOP_LIMIT_LIST[@]} * ${#NCORES_LIST[@]} ))
COUNT=0

# === Función para editar el archivo de entrada ===
update_input() {
    sed -i "s/^nb_bins.*/nb_bins: $1/" illumina.in
    sed -i "s/^stop_limit.*/stop_limit: $2/" illumina.in
}

for NB in "${NB_BINS_LIST[@]}"; do
for STOP in "${STOP_LIMIT_LIST[@]}"; do
for N in "${NCORES_LIST[@]}"; do

    COUNT=$((COUNT + 1))
    echo ""
    echo "🚀 [${COUNT}/${TOTAL}] Ejecutando simulación:"
    echo "    NB_BINS=$NB | STOP_LIMIT=$STOP | NCORES=$N"
    echo "------------------------------------------------------------"

    # Directorio de salida para esta combinación
    OUTDIR="exec/NB${NB}_STOP${STOP}_N${N}"
    mkdir -p "$OUTDIR"

    TIME_LOG="$LOGDIR/time_NB${NB}_STOP${STOP}_N${N}.txt"
    PIDSTAT_LOG="$LOGDIR/pidstat_NB${NB}_STOP${STOP}_N${N}.csv"

    echo "Time,PID,%CPU,VMEM_MB,RMEM_MB" > $PIDSTAT_LOG

    # Actualiza parámetros del archivo de entrada
    update_input "$NB" "$STOP"

    start=$(date +%s)
    pidstat -r -u -p ALL 1 > $PIDSTAT_LOG &
    PIDSTAT_PID=$!

    # === Ejecuta el modelo ===
    find exec -type f -name execute | xargs -P $N -I {} bash {} "$OUTDIR" \
        > "$LOGDIR/run_NB${NB}_STOP${STOP}_N${N}.log" 2>&1

    kill $PIDSTAT_PID
    wait $PIDSTAT_PID 2>/dev/null
    end=$(date +%s)
    runtime=$((end-start))

    # === Extrae métricas ===
    max_cpu=$(awk 'NR>1{if($3>max) max=$3} END{print max}' $PIDSTAT_LOG)
    max_mem=$(awk 'NR>1{if($5>max) max=$5} END{print max}' $PIDSTAT_LOG)
    output_size=$(du -sh "$OUTDIR" | awk '{print $1}')

    echo "$NB,$STOP,$N,$runtime,$max_cpu,$max_mem,$output_size" >> "$CSV"

    echo "✅ Simulación completada en $runtime s | CPU: ${max_cpu}% | RAM: ${max_mem} MB | Output: $output_size"
done
done
done

echo ""
echo "🎯 Benchmark completado (${COUNT}/${TOTAL} simulaciones)."
echo "📄 Resultados guardados en: $CSV"


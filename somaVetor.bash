#!/bin/bash

SOURCE="somaVetor.f90"
OPTS=("-O0" "-O1" "-O2" "-O3")

echo "--- Compilação e Teste (O0 a O3) ---"
for OPT in "${OPTS[@]}"; do
    OUTPUT="somaVetor_${OPT//-}"; 
    echo -n "Compilando $OPT... "; gfortran $OPT $SOURCE -o $OUTPUT && echo " OK" || echo " FAIL"
    [ -x "$OUTPUT" ] && (echo "--- Tempo para $OPT ---"; time ./"$OUTPUT"; echo "----------------------")
done

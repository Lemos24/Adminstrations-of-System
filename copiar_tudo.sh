#!/bin/bash

echo "📋 COPIANDO MODELO PARA LABS 03 ATÉ 16"

for i in {03..16}; do
    if [ -d "labs/lab$i" ]; then
        mkdir -p labs/lab$i/presentation
        cp labs/lab02/presentation/slides.md labs/lab$i/presentation/
        cp labs/lab02/presentation/Makefile labs/lab$i/presentation/ 2>/dev/null
        echo "✅ lab$i copiado"
    else
        echo "⚠️ lab$i não existe"
    fi
done

echo "🎉 PRONTO! Verifique com: ls labs/lab*/presentation/"

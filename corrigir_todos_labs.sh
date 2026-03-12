#!/bin/bash
echo "🔧 CORRIGINDO IMAGENS DE TODOS OS LABORATÓRIOS (01 a 16)"
echo "========================================================"
for lab in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16; do
echo ""
  echo " Processando lab$lab..."
 # Verifica se a pasta do lab existe
if [ -d "labs/lab$lab" ]; then
# Verifica se a pasta image existe
if [ -d "labs/lab$lab/image" ]; then
 cd "labs/lab$lab/image"
# Conta quantas imagens têm
total=$(ls *.png 2>/dev/null | wc -l)
if [ "$total" -gt 0 ]; then
echo "   Encontradas $total imagens"
# PASSO 1: Renomear PNG.XX.png → XX.png (se existir)
 for arquivo in PNG.*.png; do
if [ -f "$arquivo" ]; then
numero=$(echo $arquivo | sed 's/PNG\.\([0-9]*\)\.png/\1/')
 numero_sem_zero=$(echo $numero | sed 's/^0*//')
mv "$arquivo" "$numero_sem_zero.png"
 echo "   ✅ PNG.$numero.png → $numero_sem_zero.png"
fi
 done
# PASSO 2: Renomear 01.png → 1.png, 02.png → 2.png (se existir)
for arquivo in [0-9][0-9].png; do
if [ -f "$arquivo" ]; then
novo_nome=$(echo $arquivo | sed 's/^0//')
 mv "$arquivo" "$novo_nome"
 echo "   ✅ $arquivo → $novo_nome"
 fi
done
 # PASSO 3: Renomear maiúsculas para minúsculas
for arquivo in *.PNG *.JPG *.JPEG; do
 if [ -f "$arquivo" ]; then
novo_nome=$(echo $arquivo | tr '[:upper:]' '[:lower:]')
 mv "$arquivo" "$novo_nome"
 echo "   ✅ $arquivo → $novo_nome"
fi
done
 echo "   📸 Imagens finais:"
 ls -1 *.png | head -5 | sed 's/^/      /'
if [ "$(ls *.png 2>/dev/null | wc -l)" -gt 5 ]; then
echo "      ..."
 fi
 else
 echo "   ⚠️ Nenhuma imagem PNG encontrada"
fi
cd - > /dev/null
else
 echo "   ⚠️ Pasta 'image' não encontrada"
fi
 else
 echo "   ⚠️ Pasta 'lab$lab' não encontrada"
fi
done
echo ""
echo "✅ CORREÇÃO CONCLUÍDA PARA TODOS OS LABORATÓRIOS!"
echo "Agora execute 'make all' para gerar todos os PDFs e Words"

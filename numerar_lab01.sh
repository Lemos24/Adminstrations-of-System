#!/bin/bash

# Script para numerar as 20 imagens do lab01 em sequência (1.png a 20.png)

echo "🖼️  NUMERANDO 20 IMAGENS DO LABORATÓRIO 01"
echo "==========================================="

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Entrar na pasta das imagens
cd ~/adminstrations\ system/Adminstrations-of-System/labs/lab01/image/

echo "${YELLOW}📁 Pasta atual: $(pwd)${NC}"
echo ""

# Listar arquivos antes
echo "📋 Arquivos encontrados:"
ls -1 | grep -v "^[0-9]*\.png$" | cat -n
echo ""

# Contador começa em 1
CONTADOR=1

# Primeiro, renomear o arquivo que já tem nome numérico (1.png e 2.png)
if [ -f "1.png" ]; then
    mv "1.png" "temp_1.png"
    echo "${GREEN}✅ Protegido: 1.png → temp_1.png${NC}"
fi

if [ -f "2.png" ]; then
    mv "2.png" "temp_2.png"
    echo "${GREEN}✅ Protegido: 2.png → temp_2.png${NC}"
fi

# Processar todos os arquivos com nomes de data
for arquivo in 2026-*.png; do
    if [ -f "$arquivo" ]; then
        # Pular se já for um arquivo temporário
        if [[ "$arquivo" == temp_* ]]; then
            continue
        fi
        
        # Renomear para temp_ com contador
        mv "$arquivo" "temp_$CONTADOR.png"
        echo "${GREEN}✅ $arquivo → temp_$CONTADOR.png${NC}"
        CONTADOR=$((CONTADOR + 1))
    fi
done

# Processar o arquivo com espaço no nome
if [ -f "'2026-01-28_04-50-53 (1).png'" ] || [ -f "2026-01-28_04-50-53 (1).png" ]; then
    # Tentar diferentes formas do nome
    if [ -f "'2026-01-28_04-50-53 (1).png'" ]; then
        mv "'2026-01-28_04-50-53 (1).png'" "temp_$CONTADOR.png"
    else
        mv "2026-01-28_04-50-53 (1).png" "temp_$CONTADOR.png" 2>/dev/null
    fi
    echo "${GREEN}✅ Arquivo com espaços → temp_$CONTADOR.png${NC}"
    CONTADOR=$((CONTADOR + 1))
fi

echo ""
echo "${YELLOW}📋 Renomeando temporários para numeração final...${NC}"

# Agora renomear todos os temporários para números finais
CONTADOR=1
for arquivo in temp_*.png; do
    if [ -f "$arquivo" ]; then
        mv "$arquivo" "$CONTADOR.png"
        echo "${GREEN}✅ $arquivo → $CONTADOR.png${NC}"
        CONTADOR=$((CONTADOR + 1))
    fi
done

echo ""
echo "${GREEN}🎉 NUMERAÇÃO CONCLUÍDA!${NC}"
echo "📊 Total de imagens: $((CONTADOR - 1))"
echo ""
echo "${YELLOW}📋 Resultado final:${NC}"
ls -la *.png

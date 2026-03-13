#!/bin/bash

# Script para aplicar a configuração de apresentações em TODOS os laboratórios (01-16)
# Autor: Para o projeto Administration System

echo "🚀 APLICANDO CONFIGURAÇÃO DE APRESENTAÇÕES EM TODOS OS LABORATÓRIOS (01-16)"
echo "========================================================================"

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Contadores
total=0
sucesso=0
erro=0

# Primeiro, vamos criar o Makefile inteligente no lab02 (modelo)
cat > labs/lab02/presentation/Makefile << 'EOF'
# Makefile inteligente - funciona com qualquer arquivo .md
# Pega o primeiro arquivo .md que encontrar na pasta

SLIDES = $(wildcard *.md)
THEME = CambridgeUS
FONTS = -V mainfont="DejaVu Serif" -V sansfont="DejaVu Sans" -V monofont="DejaVu Sans Mono"

all:
	@if [ -z "$(SLIDES)" ]; then \
		echo "❌ Nenhum arquivo .md encontrado!"; \
		exit 1; \
	fi
	@echo "📄 Usando arquivo: $(SLIDES)"
	pandoc $(SLIDES) -t beamer -o slides-$(THEME).pdf --pdf-engine=xelatex -V theme=$(THEME) $(FONTS)
	pandoc $(SLIDES) -o slides.pptx
	pandoc $(SLIDES) -t revealjs -o slides.html --standalone
	@echo "✅ PDF, PPTX e HTML gerados de $(SLIDES)!"

pdf:
	@if [ -z "$(SLIDES)" ]; then \
		echo "❌ Nenhum arquivo .md encontrado!"; \
		exit 1; \
	fi
	pandoc $(SLIDES) -t beamer -o slides-$(THEME).pdf --pdf-engine=xelatex -V theme=$(THEME) $(FONTS)
	@echo "✅ PDF gerado de $(SLIDES)!"

pptx:
	@if [ -z "$(SLIDES)" ]; then \
		echo "❌ Nenhum arquivo .md encontrado!"; \
		exit 1; \
	fi
	pandoc $(SLIDES) -o slides.pptx
	@echo "✅ PowerPoint gerado de $(SLIDES)!"

html:
	@if [ -z "$(SLIDES)" ]; then \
		echo "❌ Nenhum arquivo .md encontrado!"; \
		exit 1; \
	fi
	pandoc $(SLIDES) -t revealjs -o slides.html --standalone
	@echo "✅ HTML gerado de $(SLIDES)!"

clean:
	rm -f slides*.pdf slides.pptx slides.html
	@echo "🧹 Limpeza concluída"

help:
	@echo "📋 Comandos disponíveis:"
	@echo "  make all    - Gera PDF, PPTX e HTML"
	@echo "  make pdf    - Gera apenas PDF"
	@echo "  make pptx   - Gera apenas PowerPoint"
	@echo "  make html   - Gera apenas HTML"
	@echo "  make clean  - Remove arquivos gerados"
EOF

echo "${GREEN}✅ Makefile inteligente criado no lab02${NC}"

# Loop por todos os laboratórios 01-16
for i in {01..16}; do
    echo ""
    echo "${YELLOW}📁 Processando lab$i...${NC}"
    
    LAB_DIR="labs/lab$i"
    PRESENTATION_DIR="$LAB_DIR/presentation"
    
    # Verifica se a pasta do laboratório existe
    if [ -d "$LAB_DIR" ]; then
        # Cria a pasta presentation se não existir
        mkdir -p "$PRESENTATION_DIR"
        
        # PASSO 1: COPIAR O MAKEFILE INTELIGENTE
        cp labs/lab02/presentation/Makefile "$PRESENTATION_DIR/"
        if [ $? -eq 0 ]; then
            echo "   ${GREEN}✅ Makefile copiado${NC}"
        else
            echo "   ${RED}❌ Erro ao copiar Makefile${NC}"
            erro=$((erro + 1))
            continue
        fi
        
        # PASSO 2: RENOMEAR slides.md PARA presentation.md (SE EXISTIR)
        if [ -f "$PRESENTATION_DIR/slides.md" ]; then
            mv "$PRESENTATION_DIR/slides.md" "$PRESENTATION_DIR/presentation.md"
            echo "   ${GREEN}✅ slides.md → presentation.md${NC}"
        elif [ ! -f "$PRESENTATION_DIR/presentation.md" ]; then
            # Se não existir nenhum dos dois, cria um modelo básico
            cat > "$PRESENTATION_DIR/presentation.md" << EOF
---
title: "Laboratório $i"
subtitle: "Administração de Sistemas Linux"
author: "Лемуш Мариу Франсишку"
date: "2025"
theme: "CambridgeUS"
lang: ru-RU
mainfont: DejaVu Serif
sansfont: DejaVu Sans
monofont: DejaVu Sans Mono
---

## Laboratório $i

Conteúdo do laboratório $i a ser desenvolvido.

## Imagens

![Descrição da imagem](../image/1.png)
EOF
            echo "   ${GREEN}✅ presentation.md criado (modelo básico)${NC}"
        else
            echo "   ${BLUE}⚠️ presentation.md já existe${NC}"
        fi
        
        # PASSO 3: REMOVER ARQUIVOS .bak (limpeza)
        rm -f "$PRESENTATION_DIR"/*.bak*
        echo "   ${GREEN}✅ Arquivos .bak removidos${NC}"
        
        sucesso=$((sucesso + 1))
    else
        echo "   ${RED}❌ Pasta $LAB_DIR não encontrada${NC}"
        erro=$((erro + 1))
    fi
    total=$((total + 1))
done

echo ""
echo "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo "${GREEN}🎉 CONFIGURAÇÃO CONCLUÍDA!${NC}"
echo "   Laboratórios processados: $total"
echo "   ${GREEN}Sucessos: $sucesso${NC}"
echo "   ${RED}Erros: $erro${NC}"
echo "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "${YELLOW}📋 RESUMO POR LABORATÓRIO:${NC}"
for i in {01..16}; do
    if [ -d "labs/lab$i" ]; then
        if [ -f "labs/lab$i/presentation/Makefile" ] && [ -f "labs/lab$i/presentation/presentation.md" ]; then
            echo "   lab$i: ${GREEN}✅ Pronto${NC}"
        elif [ -f "labs/lab$i/presentation/Makefile" ]; then
            echo "   lab$i: ${YELLOW}⚠️ Só Makefile (falta presentation.md)${NC}"
        else
            echo "   lab$i: ${RED}❌ Incompleto${NC}"
        fi
    fi
done
echo ""
echo "${YELLOW}📋 PRÓXIMOS PASSOS:${NC}"
echo "   1. Entre em cada laboratório e edite o presentation.md"
echo "   2. Execute 'make all' para gerar os slides"
echo ""
echo "   Exemplo para lab03:"
echo "   cd labs/lab03/presentation/"
echo "   nano presentation.md    # editar conteúdo"
echo "   make all                # gerar apresentação"

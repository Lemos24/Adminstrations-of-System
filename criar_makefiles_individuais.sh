#!/bin/bash

# Script para criar Makefiles individuais em cada pasta presentation dos 16 laboratórios
# Autor: Gerado para o projeto Administration System

echo "🔧 CRIANDO MAKEFILES INDIVIDUAIS PARA TODOS OS LABORATÓRIOS (01-16)"
echo "=================================================================="

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Template do Makefile individual
MAKEFILE_TEMPLATE='# Makefile para gerar apresentações deste laboratório
# Uso: make          - gera PDF, PPTX e HTML
#      make pdf      - gera apenas PDF
#      make pptx     - gera apenas PowerPoint
#      make html     - gera apenas HTML interativo
#      make clean    - remove todos os arquivos gerados
#      make help     - mostra esta ajuda

# Configurações
PDF_ENGINE = xelatex
BEAMER_THEME = metropolis
SLIDES = slides.md

# Cores para output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m

# Tarefa padrão (gera tudo)
.DEFAULT_GOAL := all

# Verifica se o arquivo slides.md existe
check:
	@if [ ! -f "$(SLIDES)" ]; then \
		echo "${RED}❌ Erro: Arquivo $(SLIDES) não encontrado!${NC}"; \
		echo "   Crie o arquivo slides.md primeiro."; \
		exit 1; \
	fi

# Gera PDF com tema Beamer
pdf: check
	@echo "${YELLOW}📄 Gerando PDF (Beamer)...${NC}"
	@pandoc $(SLIDES) -t beamer -o slides.pdf --pdf-engine=$(PDF_ENGINE) -V theme=$(BEAMER_THEME)
	@echo "${GREEN}✅ PDF gerado: slides.pdf${NC}"

# Gera PowerPoint
pptx: check
	@echo "${YELLOW}📊 Gerando PowerPoint...${NC}"
	@pandoc $(SLIDES) -o slides.pptx
	@echo "${GREEN}✅ PowerPoint gerado: slides.pptx${NC}"

# Gera HTML interativo (reveal.js)
html: check
	@echo "${YELLOW}🌐 Gerando HTML interativo...${NC}"
	@pandoc $(SLIDES) -t revealjs -o slides.html --standalone
	@echo "${GREEN}✅ HTML gerado: slides.html${NC}"

# Gera PDF simples (sem tema beamer)
pdf-simple: check
	@echo "${YELLOW}📄 Gerando PDF simples...${NC}"
	@pandoc $(SLIDES) -o slides-simple.pdf
	@echo "${GREEN}✅ PDF simples gerado: slides-simple.pdf${NC}"

# Gera todos os formatos
all: pdf pdf-simple pptx html
	@echo ""
	@echo "${BLUE}══════════════════════════════════════════════════${NC}"
	@echo "${GREEN}🎉 TODOS OS FORMATOS GERADOS COM SUCESSO!${NC}"
	@echo "${BLUE}══════════════════════════════════════════════════${NC}"
	@ls -la slides.* 2>/dev/null | sed "s/^/   /"

# Remove todos os arquivos gerados
clean:
	@echo "${YELLOW}🧹 Removendo arquivos gerados...${NC}"
	@rm -f slides.pdf slides.pptx slides.html slides-simple.pdf
	@echo "${GREEN}✅ Limpeza concluída${NC}"

# Mostra ajuda
help:
	@echo "${BLUE}📚 MAKEFILE PARA APRESENTAÇÕES${NC}"
	@echo ""
	@echo "${GREEN}Comandos disponíveis:${NC}"
	@echo "  ${YELLOW}make${NC} ou ${YELLOW}make all${NC}   - Gera todos os formatos"
	@echo "  ${YELLOW}make pdf${NC}          - Gera apenas PDF (Beamer)"
	@echo "  ${YELLOW}make pdf-simple${NC}   - Gera PDF simples"
	@echo "  ${YELLOW}make pptx${NC}         - Gera PowerPoint"
	@echo "  ${YELLOW}make html${NC}         - Gera HTML interativo"
	@echo "  ${YELLOW}make clean${NC}        - Remove todos os arquivos"
	@echo "  ${YELLOW}make help${NC}         - Mostra esta ajuda"

.PHONY: all pdf pdf-simple pptx html clean help check
'

# Loop pelos laboratórios 01-16
for i in {01..16}; do
    LAB_DIR="labs/lab$i"
    PRESENTATION_DIR="$LAB_DIR/presentation"
    
    echo ""
    echo "${YELLOW}📁 Processando $LAB_DIR...${NC}"
    
    # Verifica se a pasta do laboratório existe
    if [ -d "$LAB_DIR" ]; then
        # Cria a pasta presentation se não existir
        mkdir -p "$PRESENTATION_DIR"
        
        # Cria o Makefile
        echo "$MAKEFILE_TEMPLATE" > "$PRESENTATION_DIR/Makefile"
        
        echo "${GREEN}   ✅ Makefile criado em: $PRESENTATION_DIR/Makefile${NC}"
        
        # Cria um arquivo slides.md de exemplo se não existir
        if [ ! -f "$PRESENTATION_DIR/slides.md" ]; then
            cat > "$PRESENTATION_DIR/slides.md" << EOF
---
title: "Laboratório $i"
subtitle: "Administração de Sistemas Linux"
author: "Лемуш Мариу Франсишку"
date: "$(date +%Y)"
theme: "metropolis"
---

# Laboratório $i

## Objetivos

- Ponto 1
- Ponto 2
- Ponto 3

---

## Metodologia

Descrição da metodologia utilizada...

---

## Resultados

![Resultado 1](../image/1.png)

---

## Conclusão

Principais aprendizados deste laboratório.
EOF
            echo "${GREEN}   ✅ slides.md de exemplo criado${NC}"
        else
            echo "${BLUE}   ⚠️ slides.md já existe, mantido${NC}"
        fi
    else
        echo "${RED}   ❌ Pasta $LAB_DIR não encontrada${NC}"
    fi
done

echo ""
echo "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo "${GREEN}✅ PROCESSO CONCLUÍDO! Makefiles criados para todos os laboratórios.${NC}"
echo "${GREEN}══════════════════════════════════════════════════════════${NC}"
echo ""
echo "${YELLOW}📋 COMO USAR:${NC}"
echo "   cd labs/lab05/presentation/"
echo "   make           # Gera todos os formatos"
echo "   make pdf       # Gera apenas PDF"
echo "   make pptx      # Gera PowerPoint"
echo "   make html      # Gera HTML interativo"
echo "   make clean     # Remove arquivos gerados"

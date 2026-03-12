# Makefile para o Projeto Administration System
# Gera PDFs e Words para todos os laboratórios (1-16)

# Configurações gerais
PDF_ENGINE = xelatex
FONTS = -V mainfont="DejaVu Serif" -V sansfont="DejaVu Sans" -V monofont="DejaVu Sans Mono"
LABS_DIR = labs

# Cores para output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m

# Tarefa padrão
.DEFAULT_GOAL := help

#-----------------------------------------------------------
# FUNÇÃO PARA CORRIGIR EXTENSÕES DE IMAGENS (VERSÃO SIMPLIFICADA)
#-----------------------------------------------------------
define fix_images
	@echo "${BLUE}🔧 Corrigindo extensões de imagens em $(1)...${NC}"
	@if [ -d "$(LABS_DIR)/$(1)/image" ]; then \
		cd "$(LABS_DIR)/$(1)/image" && \
		for img in *.PNG *.png *.JPG *.jpg *.JPEG *.jpeg *.GIF *.gif; do \
			if [ -f "$$img" ]; then \
				ext=$${img##*.}; \
				lower_ext=$$(echo $$ext | tr '[:upper:]' '[:lower:]'); \
				if [ "$$ext" != "$$lower_ext" ]; then \
					new_name=$$(basename "$$img" .$$ext).$$lower_ext; \
					mv "$$img" "$$new_name" 2>/dev/null && \
					echo "   ✅ $$img → $$new_name"; \
				fi \
			fi \
		done; \
		cd - > /dev/null; \
	else \
		echo "   ⚠️ Pasta image não encontrada em $(1)"; \
	fi
endef

#-----------------------------------------------------------
# REGRAS PRINCIPAIS
#-----------------------------------------------------------

# Gera PDF para um laboratório específico
pdf-%:
	$(call fix_images,lab$*)
	@if [ ! -f "$(LABS_DIR)/lab$*/lab$*.md" ]; then \
		echo "${RED}❌ Arquivo $(LABS_DIR)/lab$*/lab$*.md não encontrado!${NC}"; \
		exit 1; \
	fi
	@echo "${YELLOW}📄 Gerando PDF para lab$*...${NC}"
	@cd "$(LABS_DIR)/lab$*" && \
	pandoc lab$*.md -o lab$*.pdf --pdf-engine=$(PDF_ENGINE) $(FONTS)
	@echo "${GREEN}✅ PDF do lab$* gerado!${NC}"

# Gera Word para um laboratório específico
word-%:
	$(call fix_images,lab$*)
	@if [ ! -f "$(LABS_DIR)/lab$*/lab$*.md" ]; then \
		echo "${RED}❌ Arquivo $(LABS_DIR)/lab$*/lab$*.md não encontrado!${NC}"; \
		exit 1; \
	fi
	@echo "${YELLOW}📄 Gerando Word para lab$*...${NC}"
	@cd "$(LABS_DIR)/lab$*" && \
	pandoc lab$*.md -o lab$*.docx
	@echo "${GREEN}✅ Word do lab$* gerado!${NC}"

# Gera PDF e Word juntos (UM COMANDO FAZ TUDO!)
lab%:
	@$(MAKE) pdf-$*
	@$(MAKE) word-$*
	@echo "${GREEN}🎉 PDF e Word do lab$* gerados com sucesso!${NC}"
	@ls -la "$(LABS_DIR)/lab$*/lab$*".{pdf,docx} 2>/dev/null || true

# Gera PDFs para todos os laboratórios (1-16)
all:
	@for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16; do \
		$(MAKE) lab$$i; \
	done

# Gera apenas para laboratórios que existem
auto:
	@echo "${YELLOW}🔍 Procurando laboratórios com arquivos .md...${NC}"
	@for lab in $$(find $(LABS_DIR) -name "lab*.md" -type f | sort); do \
		lab_name=$$(basename $$(dirname $$lab)); \
		$(MAKE) $${lab_name#lab}; \
	done

#-----------------------------------------------------------
# VISUALIZAÇÃO
#-----------------------------------------------------------

# Abre PDF
view-pdf-%:
	@if [ -f "$(LABS_DIR)/lab$*/lab$*.pdf" ]; then \
		echo "${YELLOW}📂 Abrindo PDF do lab$*...${NC}"; \
		xdg-open "$(LABS_DIR)/lab$*/lab$*.pdf" 2>/dev/null || \
		echo "${RED}❌ Não foi possível abrir o PDF${NC}"; \
	else \
		echo "${RED}❌ PDF do lab$* não encontrado. Gere com 'make lab$*'${NC}"; \
	fi

# Abre Word
view-word-%:
	@if [ -f "$(LABS_DIR)/lab$*/lab$*.docx" ]; then \
		echo "${YELLOW}📂 Abrindo Word do lab$*...${NC}"; \
		xdg-open "$(LABS_DIR)/lab$*/lab$*.docx" 2>/dev/null || \
		echo "${RED}❌ Não foi possível abrir o Word${NC}"; \
	else \
		echo "${RED}❌ Word do lab$* não encontrado. Gere com 'make lab$*'${NC}"; \
	fi

# Gera e abre PDF
view-%: lab% view-pdf-%

#-----------------------------------------------------------
# LIMPEZA
#-----------------------------------------------------------

# Remove PDF e Word de um laboratório específico
clean-%:
	@rm -f "$(LABS_DIR)/lab$*/lab$*.pdf" "$(LABS_DIR)/lab$*/lab$*.docx"
	@echo "${GREEN}🧹 PDF e Word do lab$* removidos${NC}"

# Remove todos os PDFs e Words
clean:
	@echo "${YELLOW}🧹 Removendo todos os PDFs e Words...${NC}"
	@rm -f $(LABS_DIR)/*/lab*.pdf $(LABS_DIR)/*/lab*.docx
	@echo "${GREEN}✅ Todos os arquivos removidos${NC}"

#-----------------------------------------------------------
# UTILITÁRIOS
#-----------------------------------------------------------

# Lista laboratórios
list:
	@echo "${YELLOW}📋 Laboratórios encontrados:${NC}"
	@for lab in $$(find $(LABS_DIR) -name "lab*.md" -type f | sort); do \
		lab_name=$$(basename $$(dirname $$lab)); \
		echo "   • $$lab_name"; \
	done

# Corrige imagens de todos os laboratórios
fix-all-images:
	@echo "${YELLOW}🔧 Corrigindo imagens de todos os laboratórios...${NC}"
	@for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16; do \
		if [ -d "$(LABS_DIR)/lab$$i" ]; then \
			$(call fix_images,lab$$i); \
		fi \
	done

# Instala dependências
setup:
	@echo "${YELLOW}📦 Instalando dependências...${NC}"
	@sudo dnf install -y pandoc texlive-scheme-basic dejavu-sans-fonts dejavu-serif-fonts xdg-utils
	@echo "${GREEN}✅ Dependências instaladas${NC}"

# Ajuda
help:
	@echo "${YELLOW}📚 MAKEFILE DO ADMINISTRATION SYSTEM${NC}"
	@echo ""
	@echo "${GREEN}COMANDOS PRINCIPAIS (PDF + WORD JUNTOS):${NC}"
	@echo "  ${YELLOW}make lab02${NC}        - Gera PDF e Word para o lab02"
	@echo "  ${YELLOW}make lab13${NC}        - Gera PDF e Word para o lab13"
	@echo "  ${YELLOW}make all${NC}          - Gera PDF e Word para TODOS os labs"
	@echo "  ${YELLOW}make auto${NC}         - Gera apenas para labs que existem"
	@echo ""
	@echo "${GREEN}COMANDOS SEPARADOS:${NC}"
	@echo "  ${YELLOW}make pdf-02${NC}       - Gera apenas o PDF do lab02"
	@echo "  ${YELLOW}make word-02${NC}      - Gera apenas o Word do lab02"
	@echo ""
	@echo "${GREEN}VISUALIZAÇÃO:${NC}"
	@echo "  ${YELLOW}make view-02${NC}      - Gera e abre o PDF do lab02"
	@echo "  ${YELLOW}make view-pdf-02${NC}  - Abre PDF já existente"
	@echo "  ${YELLOW}make view-word-02${NC} - Abre Word já existente"
	@echo ""
	@echo "${GREEN}UTILITÁRIOS:${NC}"
	@echo "  ${YELLOW}make list${NC}         - Lista labs com arquivos .md"
	@echo "  ${YELLOW}make fix-all-images${NC} - Corrige extensões de imagens"
	@echo "  ${YELLOW}make clean${NC}        - Remove TODOS os PDFs e Words"
	@echo "  ${YELLOW}make help${NC}         - Mostra esta ajuda"

.PHONY: all clean list setup help auto fix-all-images

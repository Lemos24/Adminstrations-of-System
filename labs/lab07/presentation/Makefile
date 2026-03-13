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

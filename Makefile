# If you are new to Makefiles: https://makefiletutorial.com

PAPER := output/paper.pdf

PRESENTATION := output/presentation.pdf

TARGETS :=  $(PAPER) $(PRESENTATION)

EXTERNAL_DATA := data/external/wscp_panel.xlsx \
	data/external/wscp_static.txt

RESULTS := output/results.rda

RSCRIPT := Rscript --encoding=UTF-8

.phony: all clean

all: $(TARGETS)

clean:
	rm -f $(TARGETS) $(RESULTS)
	
$(RESULTS): code/R/do_analysis.R $(EXTERNAL_DATA)
	$(RSCRIPT) code/R/do_analysis.R

$(PAPER): doc/paper.qmd doc/references.bib $(RESULTS)
	quarto render $<
	mv doc/paper.pdf output
	rm -f doc/paper.ttt doc/paper.fff

$(PRESENTATION): doc/presentation.qmd doc/beamer_theme_trr266.sty $(RESULTS)
	quarto render $<
	mv doc/presentation.pdf output
	rm -rf doc/presentation_files
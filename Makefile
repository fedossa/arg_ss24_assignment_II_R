# If you are new to Makefiles: https://makefiletutorial.com

PAPER := output/paper.pdf

PRESENTATION := output/presentation.pdf

TARGETS :=  $(PAPER) $(PRESENTATION)

EXTERNAL_DATA := data/external/wscp_panel.xlsx \
	data/external/wscp_static.txt

RESULTS := output/results.rda

RSCRIPT := Rscript --encoding=UTF-8

.phony: all clean very-clean dist-clean

all: $(TARGETS)

clean:
	rm -f $(TARGETS)
	rm -f $(RESULTS)
	
config.csv:
	@echo "To start, you need to copy _config.csv to config.csv and edit it"
	@false
	
$(WRDS_DATA): code/R/pull_wrds_data.R code/R/read_config.R config.csv
	$(RSCRIPT) code/R/pull_wrds_data.R

$(GENERATED_DATA): $(WRDS_DATA) $(EXTERNAL_DATA) code/R/prepare_data.R
	$(RSCRIPT) code/R/prepare_data.R

$(RESULTS):	$(GENERATED_DATA) code/R/do_analysis.R
	$(RSCRIPT) code/R/do_analysis.R

$(PAPER): doc/paper.qmd doc/references.bib $(RESULTS)
	quarto render $< --quiet
	mv doc/paper.pdf output
	rm -f doc/paper.ttt doc/paper.fff

$(PRESENTATION): doc/presentation.qmd doc/beamer_theme_trr266.sty $(RESULTS)
	quarto render $< --quiet
	mv doc/presentation.pdf output
	rm -rf doc/presentation_files
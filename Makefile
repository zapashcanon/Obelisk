SRC=src
DOC=doc
TARGET=native
MAIN=main.$(TARGET)
EXE=obelisk
FLAGS=-use-menhir -use-ocamlfind -pkgs str -Is $(SRC),$(SRC)/helpers,roman
PARSER=$(SRC)/parser.mly
RECO=$(DOC)/reco.mly
IMAGES=tabular syntax backnaur

.PHONY: all latex html default reco doc clean

all:
	@ocamlbuild $(FLAGS) $(SRC)/$(MAIN)
	@mv $(MAIN) $(EXE)

%.tex:
	@./$(EXE) latex -$* $(PARSER) -o $@

%.pdf: %.tex
	@pdflatex -interaction batchmode $<

%.png: %.pdf
	@convert -density 150 $< -format png $(DOC)/$@
	@rm -f $*.tex $< $*.aux $*.log

latex: all $(IMAGES:%=%.png)

html: all
	@./$(EXE) html $(PARSER) -o test.html
	@wkhtmltoimage -f png --width 800 test.html $(DOC)/html.png
	@rm -f test.html

default:
	@echo -e "\nDefault output on $(PARSER):"
	@./$(EXE) $(PARSER)

reco:
	@echo -e "\nDefault output on $(RECO):"
	@./$(EXE) $(RECO)
	@echo -e "\nDefault output on $(RECO) with '-i' switch:"
	@./$(EXE) -i $(RECO)

doc: latex html default reco

clean:
	@ocamlbuild -clean

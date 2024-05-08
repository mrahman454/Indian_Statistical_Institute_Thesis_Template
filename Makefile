# Howto use this Makefile
# 1. Copy Makefile into directory with main file, e.g., foo.tex
# 2. set the variables to proper values, e.g., 'PAPER=foo' and 'MISC=../Misc'
# 3. Type 'make' to build your pdf
CC=latex
FASTCC=pdflatex
LD=dvipdf
DVIPS=dvips
PSPDF=ps2pdf
BIB=bibtex
GIT=git
PAPER=main
ORIGIN=master
LINK=
DIR=$(shell pwd)
VIEWER=$(shell which xdg-open open | head -n 1)
AUX=$(shell find . -name '*.aux')

all: symlinks pdf

archive:
	zip -r submission.zip images/ *.tex *.bib *.cls *.bst Makefile

copy-to-dropbox:
	cp -f $(DIR)/*.tex $(DIR)/*.bib $(DIR)/*.cls $(DIR)/*.pdf Makefile $(LINK)
	cp -rf $(DIR)/images/* $(LINK)/images

crop: 
	pdfcrop $(PAPER)

meld: 
	meld . $(LINK)

$(PAPER):
	$(CC) $@ && $(BIB) $@ && $(CC) $@ && $(CC) $@ && $(DVIPS) $@.dvi && $(PSPDF) $@.ps

pdf: build-pdf clean
build-pdf:
	$(FASTCC) $(PAPER) && $(BIB) $(PAPER) && $(FASTCC) $(PAPER) && $(FASTCC) $(PAPER)

nobib: nobibmake clean

nobibmake: 
	$(CC) $(PAPER) && $(CC) $(PAPER) && $(DVIPS) $(PAPER).dvi && $(PSPDF) $(PAPER).ps

symlinks:
	ln -sf ../../images . || exit 0
	
view:
	${VIEWER} $(PAPER) &

fast: fast-build clean
fast-build:
	$(FASTCC) $(PAPER) && $(FASTCC) $(PAPER)
	
clean:
	rm -f *~ *.aux *.bbl *.blg *.dvi *.idx *.ilg *.ind *.loa *.lof *.log *.lot *.mtc *.mtc{0,1,2,3} *.maf .DS_Store
	rm -f *.nlo *.out *.thm *.toc texput.log x.log *.bak *.ps *.fdb_latexmk *.fls
	rm -f $(AUX)

veryclean:
	rm -f *.pdf

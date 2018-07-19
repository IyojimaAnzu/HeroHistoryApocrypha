# source file - no spaces after the defintion
book=book
ebook=ebook
cover=images/cover

# dvi output uses .eps figure files
dvi:
	latex ${book}
	latex ${book}
	latex ${book}


# ps output uses .eps figure files
ps:     dvi
	dvips ${book}.dvi -o ${book}.ps


# pdf output uses .pdf figure files
# for make pdf, a make clean may be necessary after a make dvi
pdf:
	pdflatex ${book}
	pdflatex ${book}
	thumbpdf ${book}
	pdflatex ${book}

# .epub to be viewed with fbreader etc
epub:
	tex4ebook ${ebook}
	tex4ebook ${ebook}


cover:
	exit 1; # obsolete
	jpeg2ps ${cover}.jpg > ${cover}.eps
	epstopdf ${cover}.eps
	convert ${cover}.jpg -resize 50% ${cover}_small.jpg
	jpeg2ps ${cover}_small.jpg > ${cover}_small.eps
	epstopdf ${cover}_small.eps


help:
	@echo "targets:"
	@echo "- dvi"
	@echo "- ps"
	@echo "- pdf"
	@echo "- ebook"
	@echo "- words"
	@echo "- backup"
	@echo "- xdvi"
	@echo "- cover"
	@echo "- help"
	@echo "- clean"


count:  words
words:  ps
	ps2ascii ${book}.ps| wc


xdvi:
	xdvi -keep ${book} &


backup:
	zip -9ry versions/version-`date +"%Y%m%d"`.zip * -x versions/*


# target clean is not complete
clean:
	-rm -r *~  \
	tex4ht.env \
	${book}.dvi ${book}.ps ${book}.pdf ${book}.aux ${book}.log ${book}.out ${book}.toc ${book}.tpt  \
	${ebook}.epub ${ebook}*x.png ${ebook}.4ct ${ebook}.4tc ${ebook}.aux ${ebook}.css ${ebook}.dvi ${ebook}.html ${ebook}.idv ${ebook}.lg ${ebook}.log ${ebook}.ncx ${ebook}*.html ${ebook}.tmp ${ebook}.xref content.opf ${ebook}-epub*

# source file - no spaces after the defintion
BOOK_NAME=HeroHistoryApocrypha
CH=2
REV=0
BOOK_FILENAME=${BOOK_NAME}_v${CH}.${REV}

book=book
ebook=ebook

CHAPTERS := \
	uhimi_ch1 \
	uhimi_ch2 \

IMAGE_URLS := \
	https://i.postimg.cc/y1vBRYTM/uhimi-ch1-cover.jpg?dl=1 \
	https://i.postimg.cc/hg6CFBXh/uhimi-ch1-1.jpg?dl=1

FULL_IMG_DIR:=images
EPUB_IMG_DIR:=epub_images

define img_name
	$(subst ?dl=1,,$(notdir $1))
endef

define full_img_name
	$(addprefix $(FULL_IMG_DIR)/,$(call img_name,$1))
endef

define epub_img_name
	$(addprefix $(EPUB_IMG_DIR)/,$(call img_name,$1))
endef

FULL_IMAGES := $(call full_img_name,$(IMAGE_URLS))
EPUB_IMAGES := $(call epub_img_name,$(IMAGE_URLS))

define fetch_img
$$(call full_img_name,$1):
	mkdir -p $$(dir $$@)
	wget --output-document=$$@ $1

endef

default: epub pdf raw

$(eval $(foreach img, $(IMAGE_URLS), $(call fetch_img,$(img))))

$(EPUB_IMG_DIR)/%: $(FULL_IMG_DIR)/%
	mkdir -p $(dir $@)
	convert $< -resize "1000>" $@

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
pdf: $(FULL_IMAGES)
	pdflatex ${book} # generate ToC file
	pdflatex ${book}
	mv ${book}.pdf ${BOOK_FILENAME}.pdf
	for ch in ${CHAPTERS}; \
	do \
		pdflatex $${ch}; \
	done

# .epub to be viewed with fbreader etc
epub: $(EPUB_IMAGES)
	tex4ebook -c tex4ht.cfg ${ebook}
	tex4ebook -c tex4ht.cfg ${ebook}
	mv ${ebook}.epub ${BOOK_FILENAME}.epub

raw:
	for ch in ${CHAPTERS}; \
	do \
		detex $${ch}_text | sed -e 's/---/-/g' -e 's/--/-/g' -e 's/``/"/g' \
		    -e "s/''/\"/g" -e "s/\`/'/g" > $${ch}_raw.txt; \
	done

help:
	@echo "targets:"
	@echo "- dvi"
	@echo "- ps"
	@echo "- pdf"
	@echo "- ebook"
	@echo "- words"
	@echo "- backup"
	@echo "- xdvi"
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
	-rm -fr  \
	tex4ht.env \
	${book}.dvi ${book}.ps ${book}.pdf ${book}.aux ${book}.log ${book}.out ${book}.toc ${book}.tpt  \
	${ebook}.epub ${ebook}*x.png ${ebook}.4ct ${ebook}.4tc ${ebook}.aux ${ebook}.css ${ebook}.dvi ${ebook}.html ${ebook}.idv ${ebook}.lg ${ebook}.log ${ebook}.ncx ${ebook}*.html ${ebook}.tmp ${ebook}.xref content.opf ${ebook}-epub* ${BOOK_FILENAME}.pdf ${BOOK_FILENAME}.epub
	rm -f $(EPUB_IMAGES) $(FULL_IMAGES)
	rm -f $(addsuffix .aux, $(CHAPTERS)) $(addsuffix .log, $(CHAPTERS)) $(addsuffix .out, $(CHAPTERS)) \
	    $(addsuffix .pdf, $(CHAPTERS))

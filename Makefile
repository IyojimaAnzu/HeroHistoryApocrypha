# source file - no spaces after the defintion
BOOK_NAME=HeroHistoryApocrypha

PARTS := \
	uhimi \

UHIMI_CHAPTERS:=3

define part_chapters
$($(shell echo $(1) | tr [a-z] [A-Z])_CHAPTERS)
endef

# Sums up total number of chapters across all parts
CH:=$(shell expr 0 $(foreach part, $(PARTS), + $(call part_chapters,$(part))))

REV=0
BOOK_FILENAME=${BOOK_NAME}_v${CH}.${REV}

book=book
ebook=ebook

IMAGE_URLS := \
	https://i.postimg.cc/y1vBRYTM/uhimi-ch1-cover.jpg?dl=1 \
	https://i.postimg.cc/hg6CFBXh/uhimi-ch1-1.jpg?dl=1 \
	https://i.postimg.cc/Syb4J38J/uhimi-ch2-cover.jpg?dl=1 \
	https://i.postimg.cc/5JppTQx6/uhimi-ch2-1.jpg?dl=1 \
	https://i.postimg.cc/2mDWTCWq/uhimi-ch3-cover.jpg?dl=1 \
	https://i.postimg.cc/4ZW3tGQR/uhimi-ch3-1.jpg?dl=1 \

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

CHAPTER_LIST :=

define setup_chapter
CHAPTER := $1_ch$2
CHAPTER_TEXT := $$(CHAPTER)_text.tex
CHAPTER_LIST := $$(CHAPTER_LIST) $$(CHAPTER_TEXT)

$$(CHAPTER).tex: gen-chapter.sh $$(CHAPTER_TEXT)
	./$$< -p $1 -c $2 -o $$@

$$(CHAPTER).pdf: $$(CHAPTER).tex $(FULL_IMAGES)
	pdflatex $$<

pdf:: $$(CHAPTER).pdf

$$(CHAPTER)_raw.txt: $$(CHAPTER_TEXT)
	sed -E -e 's/\\newchapter\{([^}]+)\}.*$$$$/\1/' -e 's/\\thispagestyle\{.*$$$$//' \
	    -e 's/\\includegraphics[[{].*$$$$//' $$< \
	  | detex -t  > $$@;

raw:: $$(CHAPTER)_raw.txt

endef

define chapter_list
$(shell seq 1 $(call part_chapters,$1))
endef

$(eval $(foreach part, $(PARTS), $(foreach ch, $(call chapter_list,$(part)), $(call setup_chapter,$(part),$(ch)))))

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
$(BOOK_FILENAME).pdf: ${book}.tex $(CHAPTER_LIST) $(FULL_IMAGES)
	pdflatex ${book} # generate ToC file
	pdflatex ${book}
	mv ${book}.pdf $@

pdf:: $(BOOK_FILENAME).pdf

# .epub to be viewed with fbreader etc
epub: ${ebook}.tex $(CHAPTER_LIST) $(EPUB_IMAGES)
	tex4ebook -c tex4ht.cfg ${ebook}
	tex4ebook -c tex4ht.cfg ${ebook}
	mv ${ebook}.epub ${BOOK_FILENAME}.epub

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

# LaTeX Template for Ebooks

I was toying around with tex4ebook to automatically generate epub2 ebooks from
latex source files.

After bugging Michal from the tex4ebook project to fix a lot of issues,
tex4ebook can now be conveniently used to create simple layouts. I have created
a template that mimics a typical smashwords novel. It's quite easy to write a
novel from scratch when keeping the caveats at the bottom of the page in mind.
An already written novel requires perhaps some tweaking.

## Download

* template ebook.zip
* formatted versions in epub, pdf, ps and an HTML preview of the epub version 

## Organization of the Template

The template generates an epub version as well as conventional dvi, ps and pdf
book versions.

* Makefile governs the compilation. For all targets see make help.
* ebook.tex is the starting point for the epub version and book.tex is the
starting point for the conventional dvi, ps and pdf book versions. They tie
together:
 *   images/*: cover
 *      copyright.tex: front matter copyright
 *      section??.tex: the actual novel 
*    ebook.mk4 and tex4ht.cfg work around issues in tex4ht and tex4ebook. Further
issues are worked around in the preamble of ebook.tex. 

## Usage

book.tex is my preferred template for typesetting generic text and should be
adapted to your liking. As a minimum, you perhaps want to change the title and
add an author in the titlepage environment.

In ebook.tex change only

*    \title: title of the novel
*    \author: author of the novel
*    \DeclareLanguage: language code of the novel
*    \UniqueIdentifier: an URL supporting the ebook (my patch tex4ebook.4ht.diff
- committed)
*    \coverimage: cover image picture (jpeg, png) 

This information is used for the front matter as well as for the ebook meta
information.

A brief copyright statement can be put into copyright.tex and the actual novel
is in section??.tex. These files are included by ebook.tex and book.tex.

The Makefile targets epub, dvi, ps and pdf create the actual ebook ebook.epub as
well as conventional book.dvi, book.ps and book.pdf book versions. It is highly
recommended to call these targets together with clean, e.g. make clean epub,
make clean dvi, make clean ps or make clean pdf.

## Caveats

The template is for novels consisting of cover, front matter and text.

The cover integrates nicely into the ebook and conventional book.

In the ebook version, the author name on the titlepage is offset by 40pt on
FBreader as it formats the author name as a normal paragraph. FB Reader gives a
normal paragraph an indentation of 40 pt. This indentation be changed under
Options -> Format -> Regular Paragraph -> First Line Indent and set to 0 (as of
now, I believe it's FBreader's fault to format the author name as a normal
paragraph).

In the ebook version, no space is added for a whitespace after a closing
environment. It must be added manually such as in "I love {\tt bash\ } but not
{\tt csh}.". This enforced spacing looks good in the conventional book versions,
as well.

Since recently, horizontal rules (\hrule) as well as Umlaute and other non-7 bit
ASCII characters are supported in the ebook version. They are also supported in
the conventional version, of course. Ligatures are rewritten into their
individual characters in the ebook version (this is not a bug but a feature).
Ligatures are not rewritten in the conventional book version (this is a
feature).

##  Required Software

*    tex4ebook
*    make4ht
*    a modern latex version including tex4ht (under Debian 7, texlive and tex4ht
work fine for me)
*    optionally an ebook reader such as fbreader or azardi 

After installing the required software, but before making any modifications to
the template, try out if it works for you. 

1. Unzip the template, then run 
```
make clean epub; 
ls -la ebook.epub;
# for dvi
make clean dvi; 
ls -la book.dvi;
# for ps
make clean ps; 
ls -la book.ps;
# for pdf 
make clean pdf; 
ls -la book.pdf;
```
You should see now
these 4 newly generated files in the current working directory: ebook.epub,
book.dvi, book.ps and book.pdf. You also see a lot of temporary files. A make
clean deleted them.

## Contact

You are welcome to send me comments. Contact information is available on the
main page. 

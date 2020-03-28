#!/bin/sh

unset PART
unset CHAPTER
unset OUTPUT

while getopts "c:o:p:" o
do
	case "$o" in
	c)
		CHAPTER=$OPTARG
		;;
	o)
		OUTPUT=$OPTARG
		;;
	p)
		PART=$OPTARG
		;;
	esac
done

shift $((OPTIND - 1))
OPTIND=1

if [ -n "$1" ]
then
        echo "Unrecognized argument $1"
        exit 1
fi

if [ -z "$PART" ]
then
	echo "-p flag is mandatory"
	exit 1
fi

if [ -z "$CHAPTER" ]
then
	echo "-c flag is mandatory"
	exit 1
fi

if [ -z "$OUTPUT" ]
then
	echo "-o flag is mandatory"
	exit 1
fi

cat -<<EOF > $OUTPUT
\documentclass[12pt,a5paper,oneside]{book} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% preample %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% packages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage[T1]{fontenc}        % euro quality fonts [T1] (togeth. w/ textcomp)
\usepackage{textcomp, amssymb}  % additional symbols (there are more packages)
\usepackage[utf8]{inputenc}   % umlaute in input file
\usepackage[english]{babel}
\usepackage{anysize}            % margin package sets tighter margins

\usepackage[a4paper,top=2cm,bottom=2cm,left=2cm,right=2cm]{geometry}

\usepackage{ifpdf}              % if pdflatex then ... else ...

%newer versions of latex don't need pdftex and dvips argument respectively
\ifpdf
  \usepackage{aeguill}          % PS converted CM fonts for better acro preview
  \usepackage[pdftex]{graphicx} % graphics packages
  \usepackage[pdftex]{color}    % color packages
  \usepackage[pdftex]{hyperref}
\else
  \usepackage[dvips]{graphicx}  % graphics packages
  \usepackage[dvips]{hyperref}
\fi
\usepackage{float}

\graphicspath{ {./images/} }

\newcommand{\chapterimage}{nothing}

\newcommand{\newchapter}[2]{
    \renewcommand{\chapterimage}{#2}
    \chapter{#1}
}

\makeatletter
\renewcommand*{\@makechapterhead}[1]{
  \begin{figure}[H]
  \centering
  \thispagestyle{empty}
  \includegraphics[width=\textwidth,height=\textheight,keepaspectratio]{\chapterimage}
  \end{figure}
  \newpage
  {\Huge Chapter \thechapter: #1}
}
\makeatother


%%% style and finetuning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pagestyle
\pagestyle{plain}               % headings, empty, plain

\hypersetup{colorlinks=false}   % don't print colored links on paper

% no indentation for paragraphs and space inbetween paragraphs  (euro standard)
\setlength{\parindent}{0pt}
\setlength{\parskip}{5pt plus 2pt minus 1pt}

\renewcommand{\baselinestretch}{1.05}

%%% hacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hyperref must be (almost) last command of preample
% E.g. The \href{http://www.ctan.org}{CTAN} website.
% E.g. \author{First- Lastname $<$\href{mailto: email@domain}{email@domain}$>$}

\ifpdf
  \usepackage[pdftex]{hyperref}
\else
  \usepackage[dvips]{hyperref}
\fi
\hypersetup{colorlinks=false}   % don't print colors on paper

\begin{document}

\setcounter{chapter}{$(($CHAPTER - 1))}
\input{${PART}_ch${CHAPTER}_text.tex}


\end{document}

EOF

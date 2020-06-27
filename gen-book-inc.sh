#!/bin/sh

unset PARTS
unset OUTPUT
unset CUR_PART
unset TMP

error()
{
	echo "$@" >&2
	[ -n "$TMP" ] && rm -f $TMP
	exit 1
}

while getopts "c:n:o:p:" o
do
	case "$o" in
	c)
		[ -z "$CUR_PART" ] && error "-c before preceeding -p"
		eval ${CUR_PART}_CHAPTERS=$OPTARG
		;;
	n)
		[ -z "$CUR_PART" ] && error "-n before preceeding -p"
		eval ${CUR_PART}_NAME=\'$OPTARG\'
		;;
	o)
		OUTPUT=$OPTARG
		;;
	p)
		CUR_PART=$OPTARG
		PARTS="$PARTS $CUR_PART"
		;;
	esac
done

[ -z "$OUTPUT" ] && error "-o <outfile> is mandatory"

TMP=`mktemp gen-book-inc.XXXXXXX`
for CUR_PART in $PARTS
do
	eval name=\$${CUR_PART}_NAME
	[ -z "$name" ] && error "No -n option for '$CUR_PART' provided"
	echo "\part{$name}" >> $TMP
	eval chapters=\$${CUR_PART}_CHAPTERS
	[ -z "$chapters" ] && error "No -c option for '$CUR_PART' provided"
	i=1
	while [ "$i" -le "$chapters" ]
	do
		echo "\input{${CUR_PART}_ch${i}_text.tex}" >> $TMP
		i=$(($i + 1))
	done
done

mv $TMP $OUTPUT

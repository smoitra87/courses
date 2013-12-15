#!/bin/sh

# Bash script to compile latex file
# Input - name of main tex file

fn=$1
fbase=`basename ${1} .tex `

echo ".tex filename is $fn"
echo ".tex basename is $fbase"

pdflatex ${fn}
bibtex ${fbase}.aux
pdflatex ${fn}
pdflatex ${fn}

# Display the generated pdf file
test -e ${fbase}.pdf && ( evince ${fbase}.pdf & ) || ( echo \
  "File ${fbase}.pdf does not exist" >&2 )





#!/bin/bash

inputdir=auto-tests
outputdir=xml-tests


mkdir -p $outputdir

cd $inputdir
for input in *.og
do
  echo =======================================
  echo InputFile=$input
  raw=$(basename $input | cut -f 1 -d'.')
  expected=$raw.xml
  ../og/./og $input -o ../$outputdir/$expected

done
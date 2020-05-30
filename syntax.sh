#!/bin/sh

src_dir=og/
testfolder=auto-tests/
score=0

# simulate delivery state
#make clean -C $src_dir 2>&1 > /dev/null

echo "#################### PROJECT STRUCTURE ####################"
echo
echo
echo "====================     N O D E S     ===================="
echo

if [ -d $src_dir/ast ]
then
	echo "-- Directory 'ast' found."
	echo
	nodes=$(ls -l $src_dir/ast | grep .h | wc -l)
	echo "Number of nodes: $nodes"
	echo
	
else
	echo "-- Directory 'ast' not found."
	exit 1
fi

echo "====================     SEMANTICS     ===================="
echo

if [ -d $src_dir/targets ]
then
	echo "-- Directory 'targets' found."
	echo
else
	echo "-- Directory 'targets' not found."
	exit 1
fi

echo "====================     SCANNER       ===================="
echo

if [ -f $src_dir/og_scanner.l ]
then
	echo "-- Scanner specification found."
	echo
else
	echo "-- Scanner specification not found."
	exit 1
fi

echo "====================      PARSER       ===================="
echo

if [ -f $src_dir/og_parser.y ]
then
	echo "-- Parser specification found."
	
  	confs=$(byacc -dvt $src_dir/og_parser.y 2>&1)

	if [ -z "$confs" ]; then
		echo "-- grammar has no conflics"
	else
    	score=1
		echo "!! GRAMMAR HAS CONFLICTS"
	fi
	
	echo
else
	echo "-- Parser specification not found."
	exit 1
fi

echo "====================     COMPILING     ===================="
echo

if ! [ -r $src_dir/Makefile ]
then
  echo "$0: that dir has no Makefile!"
  exit 1
fi

# compiling: if you want to show the compilation shenanigans,
# remove everything from 2>&1 onwards onwards
make -C $src_dir  2>&1 > /dev/null
if [ "$?" -ne "0" ]
then
  echo
  printf '%b' "$0: ${red}build failed${reset}\n"
  printf '%b' "$0: ${red}aborting${reset}\n"
  exit 1
fi

if [ -f $src_dir/og ]
then
	echo "-- successfully generated 'og'."
	echo
else
	echo "!! Makefile could not produce 'og'."
	exit 1
fi

echo "##################      TEST RESULTS      ###################"

red="\033[31;1m"
green="\033[32;1m"
reset="\033[0m"

printf '%b' "     ${green}OK${reset} - compiler runs; ${red}KO${reset} - compiler (partially) fails  \n"
echo "   1 - compiler produces ASM file from og program             " 
echo "       (tab, space, and newline chars are ignored)            "
echo 

if ! [ -d $testfolder/results ]
then
  mkdir $testfolder/results
fi

total=0
succs=0
for file in $testfolder/*.og
do
  input=$file
  raw=$(basename $input | cut -f 1 -d'.')
  expected=$testfolder/expected/$raw.out
  out=$testfolder/results/$raw.outhyp
  if ! [ -r $input ]
  then
    printf '%b' "$0: cannot read file "$input"${red}aborting$reset\n"
    exit 1
  fi
  if ! [ -r $expected ]
  then
    printf '%b' "$0: cannot read file $expected${red}aborting$reset\n"
    exit 1
  fi
  
  #lenght=$( echo -n $raw | wc -c )
  #dots=$(( 30-$lenght ))
  printf "$raw"
  #for ((i=0; i<dots; i++)); do
  #	printf "."
  #done
  total=$(echo "$total + 1" | bc)

  out=$($src_dir/og $input 2>&1)

  if [ -z "$out" ]
  then
    printf '%b' "${green}OK${reset}\n"
	succs=$(echo "$succs + 1" | bc)
  else
    printf '%b' "${red}KO${reset}\n"
  fi
done

rm $testfolder/*.asm

echo
echo "#####################     SUMMARY     #####################"
echo
: '
echo "Group: Points (Point/Test)"
echo "A: 0. ()"
echo "B: 0. ()"
echo "C: 0. ()"
echo "D: 0. ()"
echo "E: 0. ()"
echo "F: 0. ()"
echo "J: 0. ()"
echo "K: 0. ()"
echo "L: 0. ()"
echo "M: 0. ()"
echo "O: 0. ()"
echo "P: 0. ()"
echo "Q: 0. ()"
echo "R: 0. ()"
echo "S: 0. ()"
echo "U: 0. ()"
echo "V: 0. ()"
echo "Total: 0" 
echo
'

if [ $succs -eq 138 ]
then
	printf '%b' "Number of at least \"OK\" tests:${green} 138/138\n"
else
	printf '%b' "Number of at least \"OK\" tests:${red} $succs/138\n"
fi
printf '%b' "${reset}"



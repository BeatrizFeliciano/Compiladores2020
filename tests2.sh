#!/bin/bash

src_dir=og
testfolder=auto-tests
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
	yacc --xml $src_dir/og_parser.y > yacc.out &> /dev/null
	states=$(cat y.xml | grep "<state " | wc -l )
	rules=$(cat y.xml | grep "<rule " | wc -l )
	terminals=$(cat y.xml | grep "<terminal " | wc -l )
	nonterminals=$(cat y.xml | grep "<nonterminal " | wc -l )
	
	echo "$terminals terminals, $nonterminals nonterminals"
	echo "$rules grammar rules, $states states"
	
	if [[ $(cat yacc.out) ]]; then
    	score=1
		echo "!! GRAMMAR HAS CONFLICTS"
	else
		echo "-- grammar has no conflics"
	fi
	
	rm yacc.out y.xml y.tab.c	
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
echo "   2 - yasm is able to produce object file (.o) from ASM file "
echo "   3 - linker is able to produce executable program           "
echo "   4 - program runs and returns 0 on sucessful exit           "
echo "   5 - program output matches expected output                 "
echo "       (tab, space, and newline chars are ignored)            "
echo 

if ! [ -d $testfolder/results ]
then
  mkdir $testfolder/results
fi

total=0
succs=0

for i in {0..16}
do
  groups[i]=0
done

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
  
  lenght=$( echo -n $raw | wc -c )
  dots=$(( 30-$lenght ))
  printf "$raw"
  for ((i=0; i<dots; i++)); do
  	printf "."
  done
  total=$(echo "$total + 1" | bc)

  $src_dir/og $input 2>&1
  yasm -felf32 $testfolder/$raw.asm -o $testfolder/$raw.o 2>&1
  ld -m elf_i386 -o $testfolder/$raw $testfolder/$raw.o -L$HOME/Compiladores/compiladores/root/usr/lib -lrts 2>&1
  $testfolder/$raw &> $out

  retVal=$?
  if [ $retVal -eq 139 ]; then
    printf '%b' "${red}KO${reset}\n"
    continue
  fi

  tr -d '\t \n' < $out > temp.outhyp && mv temp.outhyp $out
  tr -d '\t \n' < $testfolder/expected/$raw.out > temp.outhyp && mv temp.outhyp $testfolder/expected/$raw.out

  if [[ $(diff -b $expected $out) ]]; then
    printf '%b' "${red}KO${reset}\n"
  else
    # A
    if [ $total -le 8 ]; then
      (( groups[0]++ ))
    # B
    elif [ $total -le 31 ]; then
      (( groups[1]++ ))
    # C
    elif [ $total -le 51 ]; then
      (( groups[2]++ ))
    # D
    elif [ $total -le 54 ]; then
      (( groups[3]++ ))
    # E
    elif [ $total -le 69 ]; then
      (( groups[4]++ ))
    # F
    elif [ $total -le 75 ]; then
      (( groups[5]++ ))
    # J
    elif [ $total -le 84 ]; then
      (( groups[6]++ ))
    # K
    elif [ $total -le 93 ]; then
      (( groups[7]++ ))
    # L
    elif [ $total -le 96 ]; then
      (( groups[8]++ ))
    # M
    elif [ $total -le 106 ]; then
      (( groups[9]++ ))
    # O
    elif [ $total -le 109 ]; then
      (( groups[10]++ ))
    # P
    elif [ $total -le 116 ]; then
      (( groups[11]++ ))
    # Q
    elif [ $total -le 123 ]; then
      (( groups[12]++ ))
    # R
    elif [ $total -le 129 ]; then
      (( groups[13]++ ))
    # S
    elif [ $total -le 133 ]; then
      (( groups[14]++ ))
    # U
    elif [ $total -le 136 ]; then
      (( groups[15]++ ))
    # V
    else
      (( groups[16]++ ))
    fi

    printf '%b' "${green}OK${reset}\n"
	  succs=$(echo "$succs + 1" | bc)
  fi
done

for file in $testfolder/*.og
do
  input=$file
  raw=$(basename $input | cut -f 1 -d'.')
  
  if test -f "$testfolder/$raw"; then
    rm $testfolder/$raw
  fi
done

rm  $testfolder/*.asm
rm  $testfolder/*.o

echo
echo "#####################     SUMMARY     #####################"
echo

t[0]=8  #A
t[1]=23 #B
t[2]=20 #C
t[3]=3  #D
t[4]=15 #E
t[5]=6  #F
t[6]=9  #J
t[7]=9  #K
t[8]=3  #L
t[9]=10 #M
t[10]=3 #O
t[11]=7 #P
t[12]=7 #Q
t[13]=6 #R
t[14]=4 #S
t[15]=3 #U
t[16]=2 #V

echo "Group: Points (Point/Test)"
i=0
perc=0
for test in "A" "B" "C" "D" "E" "F" "J" "K" "L" "M" "O" "P" "Q" "R" "S" "U" "V"
do
  val=$( echo 1/${t[i]} | bc -l )
  s=$( echo ${groups[i]}/${t[i]} | bc -l )
  if [ $( echo $((${groups[i]}/${t[i]})) ) -eq 1 ]; then
    printf "$test: ${green}%f${reset} ($val)\n" $( echo ${groups[i]}/${t[i]} | bc -l )
  else
    printf "$test: ${red}%f${reset} ($val)\n" $( echo ${groups[i]}/${t[i]} | bc -l )
  fi
  perc=$( echo $perc+${groups[i]}*$val | bc -l )
i=$((i + 1))
done

printf "Total: %.15f (max. 100%%)\n" $( echo $perc*100/17 | bc -l )
echo

if [ $succs -eq 138 ]
then
	printf '%b' "Number of at least \"OK\" tests:${green} 138/138 (100%)\n"
else
	printf '%b' "Number of at least \"OK\" tests:${red} $succs/138 "
  echo '(~'$(( succs*100/138 ))'%)'
fi
printf '%b' "${reset}"

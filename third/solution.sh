#!/bin/bash

declare -A map

input="source.txt"
line_length=0
line_num=0
tobogganX=0
tobboganY=0
for line in $(cat $input); do
	line_length=${#line}
	((line_num=line_num+1))
	i=0
	while (( i++ < ${#line} ))
	do
		char=$(expr substr "$line" $i 1)
		echo "$i : $line_num"
	done
done

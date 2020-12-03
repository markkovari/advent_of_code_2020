#!/bin/bash
function encountered_trees_with_steps() {
	input="source.txt"
	line_length=0
	line_num=0
	toboggan_down_step=$1
	toboggan_right_step=$2
	tobboganX=1
	tobboganY=1
	encountered_tree_count=0
	line_count=0
	for line in $(cat $input); do
		line_length=${#line}
		i=1
		if [ $((line_count % toboggan_down_step)) -eq 0 ]; then
			while [ $i -le $line_length ]
			do
				if [ $i == $tobboganY ]; then
					char=$(expr substr "$line" $i 1)
					if [ "$char" == "#" ]; then
						((encountered_tree_count=encountered_tree_count+1))
					fi
				fi
				((i=i+1))
			done
			((tobboganX=tobboganX+toboggan_down_step))
			((tobboganY=tobboganY+toboggan_right_step))
			if [ $tobboganY -gt $line_length ]; then
				((tobboganY=tobboganY-line_length))
			fi
		fi
		((line_count=line_count+1))
	done
	echo "$encountered_tree_count"
}

simple=$(encountered_trees_with_steps 1 1)
tricky=$(encountered_trees_with_steps 1 3)
slider=$(encountered_trees_with_steps 1 5)
risky=$(encountered_trees_with_steps 1 7)
fast=$(encountered_trees_with_steps 2 1)
#echo $(($simple * $tricky * $slider * $risky * $fast))
echo $(($simple * $tricky * $slider * $risky * $fast))


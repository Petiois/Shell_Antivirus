#!/bin/bash

od -t -q x1 $2

length=$(awk 'END{print NR}' $1)

for ((i=1;i<=length;i++))
do 
		signature=$(awk -F":" -v ligne=$i 'NR==ligne{print $1}' $1)
		name=$(awk -F":" -v ligne=$i 'NR==ligne{print $3}' $1)
		if grep -q $signature $fichier
		then echo $fichier "IS INFECTED by --> " $name
		fi
done
exit 0

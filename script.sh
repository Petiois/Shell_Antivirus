#!/bin/bash

search(){
fichier=$( od -t x1 virus | sed -e 's/^[0-9][0-9][0-9][0-9][0-9][0-9][0-9]//' -e 's/ //g' | tr -d '\n' )
#echo $fichier

length=$(awk 'END{print NR}' $1)

for ((i=1;i<=length;i++))
do 
                signature=$(awk -F":" -v ligne=$i 'NR==ligne{print $1}' $1)
                #echo $signature
                name=$(awk -F":" -v ligne=$i 'NR==ligne{print $3}' $1)
                if grep -q -R -i $signature $2
                then echo $2 "IS INFECTED by --> " $name
                fi
done
}


while getopts "vsr" OPTION
do
        case $OPTION in
                v) echo "Ce script est une antivirus basic réalsisé uniquement à partir de commandes Shell";;
                s) search $2 $3;;
		r) echo "trois";;
                \?) exit 1;;
        esac
done

exit 0

#!/bin/bash
start_time=$(date +%s)
verbose=false
#files=$(find . -type f)

#DIR=$PWD$(readlink -f $2)


searchRecursive(){
fichier=$( od -t x1 $2 | sed -e 's/^[0-9][0-9][0-9][0-9][0-9][0-9][0-9]//' -e 's/ //g' | tr -d '\n' )
#echo $fichier

length=$(awk 'END{print NR}' $1)
DIR=$(dirname $2)
#echo $DIR
files=$(find $DIR -type f)
for f in $files
do
for ((i=1;i<=length;i++))
do 
                signature=$(awk -F":" -v ligne=$i 'NR==ligne{print $1}' $1)
                #echo $signature
                name=$(awk -F":" -v ligne=$i 'NR==ligne{print $3}' $1)
                if $verbose
                then
                  if (cat $f| grep -r $signature)
		            then echo $f "IS INFECTED by --> " $name
		            fi
		          else
		            if (cat $f| grep -qr $signature)
		            then echo $f "IS INFECTED by --> " $name
		            fi
                fi
done
done
}

while getopts "hvsr" OPTION
do
        case $OPTION in
                h) echo "Ce script est une antivirus basic réalsisé uniquement à partir de commandes Shell";;
                v) verbose=true
                   searchRecursive $2 $3;;
                s) searchSimple $2 $3;;
		          r) searchRecursive $2 $3;;
                \?) exit 1;;
        esac
done

calculateTime(){
finish_time=$(date +%s)
gap=$(($finish_time-$start_time))
base=60
if (("$gap">"$base"))
   then 
      min=$gap%60
      sec=$gap-$min
      if (("$min">"$base"))
         then 
            hour=$min%60
      else hour=0
      fi
else
   hour=0
   min=0
   sec=$gap
fi
echo "Time duration:"$hour"h:"$min"m:"$sec"s"
}

exit 0

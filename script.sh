#!/bin/bash

start_time=$(date +%s)
verbose=false
pathFolder=$2
pathDataBase=$1

######################################################################################################CHECK TYPE
checkType(){
   if [ -d $1 ]; then
	pathFolder=$(readlink -f $1)
	echo The path of the folder is $pathFolder
	else echo -e "The parameter for \e[1;31m-r\e[0m should be a directory"
   fi
}

##################################################################################################CHECK DATABASE
checkDataBase(){
   if [ -f $1 ]; then
	pathDataBase=$(readlink -f $1)
	echo The path of the DataBase is $pathDataBase
	else echo -e "The parameter for \e[1;31m-r\e[0m should be a directory"
   fi
}

##################################################################################################GET PARAMETERS
while getopts ":hvs:r:" OPTION
do
        case $OPTION in
                h) echo "Ce script est une antivirus basic réalsisé uniquement à partir de commandes Shell";;
                v) verbose=true;;
                s) checkDataBase $OPTARG;;
		          r) checkType $OPTARG;;
		          \?) exit 1;;
        esac
done

########################################################################################################DUMPHEXA
dumpHexa(){
   fichier=$( od -t x1 $f | sed -e 's/^[0-9][0-9][0-9][0-9][0-9][0-9][0-9]//' -e 's/ //g' | tr -d '\n' )
   #echo $fichier
}

##################################################################################################CALCULATE TIME
calculateTime(){
finish_time=$(date +%s)
gap=$(($finish_time-$start_time))
if (("$gap">"60"))
   then 
      min=$(expr $gap / 60)
      sec=$(($gap-($min * 2)))
      if (("$min">"60"))
         then 
            hour=$(expr $gap / 60)
      else hour=0
      fi
else
   hour=0
   min=0
   sec=$gap
fi
echo "Time duration:" $hour"h:"$min"m:"$sec"s"
}
####################################################################################################PARSING FILE

length=$(awk 'END{print NR}' $pathDataBase)
echo $lenght
DIR=$(readlink -f $pathFolder)
echo $DIR
files=$(find $DIR -type f)
#files=(`ls $DIR`)
for f in $files
#do
#echo $files
#done
   do
      toto=0
      dumpHexa $f
      for ((i=1;i<=length;i++))
         do
                toto=$(expr $toto + 1)
                signature=$(awk -F":" -v ligne=$i 'NR==ligne{print $1}' $pathDataBase)
                #echo $signature
                name=$(awk -F":" -v ligne=$i 'NR==ligne{print $3}' $pathDataBase)
                if $verbose 
                then
                  echo $(readlink -f $f)
                  echo $toto "--> Pattern : " $name
                  if (echo $fichier| grep -r $signature)
		            then echo -e '\e[1;31m'$f "IS INFECTED by --> " $name'\e[0m'
		            fi
		          else
		            if (echo $fichier| grep -qr $signature) 
		            then echo -e '\e[1;31m'$f "IS INFECTED by --> " $name'\e[0m'
		            fi
		          fi	
         done
   done         
calculateTime 

exit 0

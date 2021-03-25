#!/bin/bash
kemarin="$(date -d "yesterday" '+%d-%m-%Y')"
today="$(date '+%d-%m-%Y')"

if [[ -d ~/Sisop_Prak1/Soal_3/Kucing_$kemarin ]] || [[ ! -d ~/Sisop_Prak1/Soal_3/Kelinci_$kemarin ]];
then
  temp="Kelinci_$today"
  mkdir $temp
  string=""
  num=1
  no=1
  declare -A array
  while [[ $num -lt 24 ]]; do
    if [ $no -lt 10 ]
      then
        string="0$no"
      else
        string="$no"
    fi
    wget -cO Kelinci_$string.jpg - https://loremflickr.com/320/240/bunny
    
    exec &>> Foto.log
    md5str=($(md5sum Kelinci_$string.jpg))

    if [[ ${array[$md5str]} == 1 ]]
    then
      rm Kelinci_$string.jpg
    else
      array[$md5str]=1
      mv Kelinci_$string.jpg $temp/Kelinci_$string.jpg
      no=$((no+1))
    fi
    num=$((num+1))
    
  done
else
  temp="Kucing_$today"
  mkdir $temp
  string=""
  num=1
  no=1
  declare -A array
  while [[ $num -lt 24 ]]; do
    if [ $no -lt 10 ]
      then
        string="0$no"
      else
        string=$no
    fi
    wget -cO Kucing_$string.jpg - https://loremflickr.com/320/240/kitten
    exec &>> Foto.log
    md5str=($(md5sum Kucing_$string.jpg))

    if [[ ${array[$md5str]} == 1 ]]
    then
      rm Kucing_$string.jpg
    else
      array[$md5str]=1
      mv Kucing_$string.jpg $temp/Kucing_$string.jpg
      no=$((no+1))
    fi
    num=$((num+1))
    
  done
fi

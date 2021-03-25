#!/bin/bash
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
  wget -cO Koleksi_$string.jpg - https://loremflickr.com/320/240/kitten
  exec &>> Foto.log
  md5str=($(md5sum Koleksi_$string.jpg))

  if [[ ${array[$md5str]} == 1 ]]
  then
    rm Koleksi_$string.jpg
  else
    array[$md5str]=1
    no=$((no+1))
  fi
  num=$((num+1))
done

#!/bin/bash
today="$(date '+%d%m%Y')"
declare -A array
num=0
for i in *
do
    if [[ -d "$i" ]]
    then
        array[$num]=${i%/}
    fi
    num=$((num+1))
done

zip -P $today -r Koleksi.zip ${array[*]}
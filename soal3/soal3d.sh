#!/bin/bash

today=`date '+%d%m%Y' | awk '{print $0}'`
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

zip -P $today -rm Koleksi.zip ${array[*]}

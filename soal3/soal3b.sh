#!/bin/bash
tanggal="$(date '+%d-%m-%Y')"
mkdir $tanggal
string=""
for ((i=1; i<24; i=i+1))
do
    if [ $i -lt 10 ]
    then
        string="0$i"
    else
        string=$i
    fi
    
    if [ -f Koleksi_$string.jpg ]
    then
        mv Koleksi_$string.jpg $tanggal/Koleksi_$string.jpg
    else
        break
    fi
done
mv Foto.log $tanggal/Foto.log

#!/bin/bash

for ((num=0; num<23; num=num+1))
do
  wget https://loremflickr.com/320/240/kitten
  exec &>> Foto.log
done

fdupes -r ~/Sisop_Prak1/Soal_3 > my_duplicate_files.txt
fdupes -rdN ~/Sisop_Prak1/Soal_3 > my_duplicate_files.txt

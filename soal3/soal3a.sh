for ((num=0; num<23; num=num+1))
do
    wget https://loremflickr.com/320/240/kitten
    exec &> Foto$num.log
done

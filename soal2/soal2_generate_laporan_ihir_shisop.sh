#!/bin/bash

# 2 a
awk -F'\t' -v max=0 -v id="" '{if (NR != 1 && max<=(($21/($18-$21))*100)){max=(($21/($18-$21))*100); id=$2}} END{printf("Transaksi terakhir dengan profit percentage terbesar yaitu %s dengan persentase %f\%.\n", id, max)} ' "Laporan-TokoShiSop.tsv" > "hasil.txt"

# 2 b
awk -F'\t' 'BEGIN{printf("\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n")}{if($10 == "Albuquerque" && "2017" == substr($2, 4, 4)){arr[$7]++} }END{for (name in arr) {print name}}' "Laporan-TokoShiSop.tsv" >> "hasil.txt"

# 2 c
awk -F'\t' '{if (NR != 1 ){arr[$8]++}}END{transaction=99999; fewest=""; for (segment in arr){if(arr[segment]<transaction){transaction=arr[segment]; fewest=segment}} printf("\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n",fewest,transaction)}' "Laporan-TokoShiSop.tsv" >> "hasil.txt"

# 2 d
awk -F'\t' '{if (NR != 1){arr[$13]+=$21}}END{min=999999; fewest=""; for (region in arr){if(arr[region]<min){min=arr[region]; fewest=region;}} printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f.\n", fewest, min)}' "Laporan-TokoShiSop.tsv" >> "hasil.txt"

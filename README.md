# soal-shift-sisop-modul-1-A05-2021

## Soal 1

RegEX:
```
(\w*) (\d*) (\d*):(\d*):(\d*) ubuntu.local ticky: (\w*) (.*) \((.*)\)
```

## Soal 2
* ### 2a
  >Cari transaksi terakhir dengan profit margin terbesar yang diperoleh melalui: 
  >
  >**Profit Percentage = (Profit / Cost price) x 100**
  
  Proses pengerjaan soal 2a dapat dijabarkan menjadi beberapa tahapan seperti berikut:
  
  * Mengunakan `Field Separator` yang tepat untuk file **`.tsv`**
    ```bash
     -F'\t'
    ```
  * Mendeklarasikan **variabel** untuk menyimpan profit margin terbesar dan ID transaksi
    ```bash
    -v max=0 -v id=""
    ```
  * Melakukan pengecekan apabila baris yang yang dibaca bukanlah judul kolom dan cek apabila **profit percentage**-nya lebih besar dari `max` saat ini
    ```bash
    if (NR != 1 && max<=(($21/($18-$21))*100)){max=(($21/($18-$21))*100); id=$2}
    ```
  * Ganti nilai pada variable `max` jika ditemukan **profit percentage** yang lebih besar dan dapatkan **Transaction ID**-nya
  * Output-kan hasil ke file `hasil.txt`
  
  Hasil keluaran kode ke file `hasil.txt`
  ![image](https://user-images.githubusercontent.com/43901559/112330455-a4336680-8cea-11eb-84b0-6dd36bb96914.png)

  Kendala yang dihadapi saat mengerjakan **2a**:
  
  * **Menghadapi exception division by zero**
  ![image](https://user-images.githubusercontent.com/43901559/112330917-0e4c0b80-8ceb-11eb-90ec-9abb80f22409.png)
    
    Hal ini dikarenakan terjadinya upaya operasi matematika pada baris yang mengandung judul kolom, diselesaikan dengan menambahkan check pada `if` block agar tidak melakukan operasi matematika di baris tersebut.
  * **Jika menulis script AWK pada line baru, program meminta input dari user**
  ![image](https://user-images.githubusercontent.com/43901559/112332287-32f4b300-8cec-11eb-8e8c-c070d3cf8ab7.png)
    
    Alasan tidak diketahui, diselesaikan dengan menulis script dalam satu baris.
  * **mendeklarasikan variabel menghasilkan syntax error**
    ![image](https://user-images.githubusercontent.com/43901559/112332714-8ff06900-8cec-11eb-95bf-c52098f970c2.png)
    
    Disebabkan oleh deklarasi variabel yang tidak sesuai,
    ```bash
    -v max=0 -v id=""'{if (NR != 1 && max<=(($21/($18-$21))*100)){max=(($21/($18-$21))*100); id=$2}}
    ```
    Diselesaikan dengan menambahkan spasi diantara `id=""` dan sisa script
    ```bash
    -v max=0 -v id="" '{if (NR != 1 && max<=(($21/($18-$21))*100)){max=(($21/($18-$21))*100); id=$2}} 
    ```

* ### 2b
  >Tampilkan **nama customer** dari **Albuquerque** pada tahun **2017**

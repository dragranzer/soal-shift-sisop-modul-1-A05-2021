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
  
  Proses pengerjaan soal 2b dapat dijabarkan sebagai berikut
  * Gunakan `Field Separator` tab seperti pada 2a
  * Manfaatkan block `BEGIN` untuk melakukan print **Daftar nama customer di Albuquerque...**
    ```bash
    BEGIN{printf("\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n")}
    ```
  * Check apabila **customer** melakukan transaksi di **Albuquerque** pada **2017**
    ```bash
    if($10 == "Albuquerque" && "2017" == substr($2, 4, 4))
    ```
  * Simpan **nama customer** pada `array` dan manfaatkan block `END` untuk menampilkan **nama customer** tersebut
    ```bash
    END{for (name in arr) {print name}
    ```
  * Outputkan hasilnya ke file `hasil.txt`
    
  Hasil keluaran pada file `hasil.txt`
  ![image](https://user-images.githubusercontent.com/43901559/112335909-35a4d780-8cef-11eb-9d0b-636554f2e0fa.png)

* ### 2c
  >Tampilkan **segment** dengan **jumlah transaksi** paling sedikit:
  
  Proses pengerjaan soal 2c dapat dijabarkan sebagai berikut:
  * Gunakan `Field Separator` yang tepat seperti soal sebelumnya
  * Simpan jumlah kemunculan **segment** pada array dengan melakukan `increment`, lakukan cek agar tidak membaca baris judul kolom
    ```bash
    {if (NR != 1 ){arr[$8]++}}
    ```
  * Pada block `END`, lakukan pencarian **segment** mana yang memiliki **jumlah transaksi** dengan mengecek `value` pada array-nya
    ```bash
    END{transaction=99999; fewest=""; for (segment in arr){if(arr[segment]<transaction){transaction=arr[segment]; fewest=segment}}
    ```
  * Output-kan hasilnya ke file `hasil.txt`
  
  Hasil keluaran script awk pada file `hasil.txt`
  ![image](https://user-images.githubusercontent.com/43901559/112337213-4c97f980-8cf0-11eb-9cf3-ec3951d85a5e.png)

* ### 2d
  >Cari **region** dengan **profit** paling sedikit
 
  Proses pengerjaan soal 2d dapat dijabarkan sebagai berikut:
  * Gunakan `-F'\t'` agar dapat membaca file `.tsv` dengan benar
  * Simpan **profit** tiap **region** ke dalam array, dilakukan dengan menambahkan **profit** yang sesuai ke index array sesuai
    ```bash
    {if (NR != 1){arr[$13]+=$21}}
    ```
    Kolom **region** merupakan kolom ke-13 dan kolom **profit** kolom ke-21
  * Gunakan block `END` untuk mengecek **region** mana yang memiliki total **profit** paling sedikit
    ```bash
    END{min=999999; fewest=""; for (region in arr){if(arr[region]<min){min=arr[region]; fewest=region;}}
    ```
  * Outputkan hasilnya sesuai format yang diminta ke file `hasil.txt`

  Hasil keluaran pada file `hasil.txt`
  ![image](https://user-images.githubusercontent.com/43901559/112338572-7bfb3600-8cf1-11eb-9d66-a72c4870c4d1.png)

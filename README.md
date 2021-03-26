# soal-shift-sisop-modul-1-A05-2021

## Soal 1
![image](https://user-images.githubusercontent.com/8071604/112613476-b9c3a000-8e52-11eb-8912-674d9c93150c.png)

* ### Poin 1a
  RegEx untuk melakukan ekstraksi data jenis log (ERROR/INFO), pesan log, dan username adalah
  ```
    (ticky: )([A-Z]*)([^\(]*)\(([a-z]*)
  ```
  Penjelasan RegEx:
  * `(ticky: )` berarti memulai pencarian pada kata "ticky: " di dalam string
  * `([A-Z]*)` menunjukkan jenis log (ERROR/INFO)
    `A-Z` menunjukkan karakter yang diperbolehkan dalam jenis log.
  * `([^\(]*)` menunjukkan pesan log
    `^\(` berarti pesan log hanya sampai karakter `(`
* ### Poin 1b
![image](https://user-images.githubusercontent.com/8071604/112613628-e37cc700-8e52-11eb-97bd-7b040e38aed0.png)

  Penampilan semua pesan _error_ yang muncul beserta kemunculannya dapat dilakukan dengan cara:
  1. Membaca file `syslog.log` dari baris ke baris
  2. Melakukan ekstraksi data menggunakan RegEx yang telah dibuat pada poin (1a)
      Di dalam proses ekstrak data, data-data hasil prosesnya disimpan di variabel `BASH_REMATCH` yang merupakan _array_.
      Berikut ini detail isi dari `BASH_REMATCH`
      - BASH_REMATCH[2] menyimpan data jenis log
      - BASH_REMATCH[3] menyimpan data pesan log, dan
      - BASH_REMATCH[4] menyimpan data username
  4. Melakukan pemilahan antara jenis log ERROR dan jenis log INFO berdasarkan data dari `BASH_REMATCH[2]`. Hal ini dapat dilakukan dengan menggunakan kode percabangan IF, yaitu `if [[ ${BASH_REMATCH[2]} == 'ERROR' ]]`. Dalam proses iterasi baris per-baris dari file `syslog.log` (disimpan pada variabel `$line`), sebuah variable `total` digunakan sebagai _counter_ dari pesan error.
* ### Poin 1c
![image](https://user-images.githubusercontent.com/8071604/112613743-00b19580-8e53-11eb-8626-e5f5a9bdbef2.png)

  Penampilan jumlah kemunculan log ERROR dan INFO untuk setiap _user_ dapat dilakukan dengan cara:
  1. Membaca file `syslog.log` dari baris perbaris
  2. Melakukan ekstraksi data menggunakan RegEX yang telah dibuat pada poin (1a)
  3. Mendeklarasikan sebuah array :
    - `hashmaperror[x]` untuk menyimpan jumlah pesan error yang dimiliki oleh _user_ bernama x. 
    - `hashmapinfo[x]` untuk menyimpan jumlah pesan info yang dimiliki oleh _user_ bernama x.
    - `users[x]` untuk menyimpan nama-nama user yang ada di dalam file `syslog.log`.
    - `users_available[x]` untuk menyimpan data toggle/flag yang bernilai 0 atau 1. Variabel ini akan bernilai 1 ketika nama _user_ bernama x ada di isi array `users[index]`. Kebalikannya, variabel ini akan bernilai 0 ketika nama _user_ bernama x tidak ada di isi array `users[index]`. Tujuan dari pembuatan array ini adalah untuk mempermudah pengecekan nama _user_ dan membuat kompleksitas proses pengecekan _user_ menjadi O(1).
   4. Iterasi baris perbaris dari isi file `syslog.log` serta melakukan percabangan IF untuk mengecek jenis log dan memasukkanya sesuai dengan jenis log dan username.
* ### Poin 1d

![image](https://user-images.githubusercontent.com/8071604/112613812-1b840a00-8e53-11eb-9b4a-06d84fa3a727.png)

   Semua informasi yang didapatkan pada poin (1b) dituliskan ke dalam file `error_message.csv` dengan header `Error,Count` yang kemudian diikuti oleh daftar pesan _error_ danj jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.
   
   Hal ini bisa dilakukan dengan cara:
    
   1. Membaca file `syslog.log` dari baris perbaris
   2. Melakukan ekstraksi data menggunakan RegEx yang telah dibuat pada poin (1a)
   3. Dalam proses iterasi baris-perbaris yang disimpan di `$line`, terdapat percabangan IF yang memilah-milah `BASH_REMATCH[3]`. Sebelumnya, terdapat variabel `pd` yang menyimpan jumlah pesan error dengan status _Permission denied_, variabel `fnf` yang menyimpan jumlah pesan error dengan status _File not found_, variabel `ftc` untuk menyimpan jumlah pesan error dengan status _Failed to connect to DB_. Pemilahan berdasarkan `BASH_REMATCH[3]` dilakukan dengan memperhatikan isi dari pesan errornya.
      - Pesan error `The ticket was modified while updating` statusnya dianggap _Permission denied_ karena sebuah tiket tidak bisa dimodifikasi ketika sedang di _update_. Misalnya tiket adalah sebuah file yang sedang di modifikasi oleh user A. Ketika user B mencoba memodifikasi file tersebut, user B harus menunggu hingga proses modifikasi oleh user A selesai.
      - Pesan error `Permission denied while closing ticket` statusnya dianggap _Permission denied_ karena dari pesan error sudah jelas bahwa pesan error ini merupakan bagian dari _Permission denied_
      - Pesan error `Tried to add information to closed ticket` statusnya dianggap _Permission denied_. Misalnya sebuah file sedang di akses oleh user A. User lain tidak dapat memodifikasi / menambahkan sesuatu pada file tersebut.
      - Pesan error `Ticket doesn't exist` statusnya dianggap _File not found_
      - Pesan error `Connection to DB failed` statusnya dianggap _Failed to connect to DB_
      - Pesan error `Timeout while retrieving information` statusnya dianggap _Failed to connect to DB_ karena pada umumnya timeout terjadi ketika koneksi antar client dan server (yang menyimpan informasi) tidak berhasil dilakukan.
   4. Setelah iterasi baris-baris dilakukan, isi variabel `ftc`, `fnf`, dan `pd` dimasukkan ke dalam file `error_message.csv`. Sebelumnya header `Error,Count` ditulis terlebih dahulu, baru kemudian variabel-variabel tersebut.
   5. Lakukan sorting berdasarkan isi dari column `Count`.
* ### Poin 1e
![image](https://user-images.githubusercontent.com/8071604/112613858-2b9be980-8e53-11eb-8371-4d2550644fdd.png)

  Semua informasi yang didapatkan pada poin (1c) dituliskan dalam file `user_statistic.csv` dengan header `Username,INFO,ERROR` diurutkan berdasarkan username secara ascending.
  Langkah-langkahnya adalah
  1. Membaca file `syslog.log` baris-perbaris
  2. Melakukan ekstraksi data dengan menggunakan RegEx
  3. Di setiap iterasi baris `$line`, lakukan pengisian array `hashmaperror`, `hashmapinfo`, `users`, `users_available` seperti yang telah dijelaskan pada poin (1c)
  4. Setelah itu, tuliskan header file .csv
  5. Lalu masukkan data-data berdasarkan isi dari `hasmaperror`, `hashmapinfo`, dan `users`.
  6. Setelah file user_statistic.csv dibuat, lakukan sorting berdasarkan column pertama dari isi file .csv

* ### Kesulitan yang dialami
  Kesulitan yang dialami dalam mengerjakan soal 1 adalah:
  
  1. Membuat RegEX. Saya harus membaca banyak literatur untuk mendapatkan RegEx nya
  2. Melakukan sorting pada file .csv. Terdapat command `head` dan `tail` yang masih baru bagi saya.

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
## Soal 3
* ### 3a
  1. Dalam while untuk mengunduh gambar dari `https://loremflickr.com/320/240/kitten` dan memberinya nama dengan `Koleksi_$string` dimana `$string` disini              dimulai dari 01 sampai jumlah gambar yang diunduh saya menggunakan comand:
      ```
      wget -cO Koleksi_$string.jpg - https://loremflickr.com/320/240/kitten
      ```
  2. catat log kedalam `Foto.log` dengan command:
      ```
      exec &>> Foto.log
      ```
  3. catat file yang telah di download dengan command:
      ```
      md5str=($(md5sum Koleksi_$string.jpg))
      ```
      setelah itu didapatkan hash dari file dan disimpan pada variable `md5str`
  4. masukkan nilai hash sebagai key atau index dari array jika nilai dari array dengan key tersebut masih 0
      ```
      array[$md5str]=1
      ``` 
      namun jika nilai dari array dengan key tersebut adalah 1 yang artinya file yang sama sudah terdownload maka hapus file yang baru saja di download
      ```
      rm Koleksi_$string.jpg
      ```
      
* ### 3b
  1. Buat string yang berupa date saat ini dan folder yang akan dipakai untuk menyimpan gambar yang akan dipindah dengan nama folder sesuai dengan tanggal saat         ini dengan command:
      ```
      tanggal="$(date '+%d-%m-%Y')"
      mkdir $tanggal
      ```
  2. pindahkan tiap file foto kedalam folder tersebut menggunakan command 
      ```
      mv Koleksi_$string.jpg $tanggal/Koleksi_$string.jpg` yang di tulis didalam while
      ```
  3. pindahkan `Foto.log` kedalam folder
      ```
      mv Foto.log $tanggal/Foto.log
      ```
  4. buat `cron3b.tab` yang isinya 
      ```
      0 20 1,8,15,22,29 * * bash ~/Sisop_Prak1/Soal_3/Soal3a.sh;bash ~/Sisop_Prak1/Soal_3/Soal3b.sh
      ``` 
      untuk mulai tanggal 1 dengan langkah 7 hari tiap jam 8 malam
      ```
      0 20 2,6,10,14,18,22,26,30 * * bash ~/Sisop_Prak1/Soal_3/Soal3a.sh;bash ~/Sisop_Prak1/Soal_3/Soal3b.sh
      ```
      untuk mulai tanggal 2 dengan langkah 4 hari tiap jam 8 malam
  
* ### 3c
  1. catat date hari ini dan kemarin dalam sebuah string dengan command:
      ```
      kemarin="$(date -d "yesterday" '+%d-%m-%Y')"
      today="$(date '+%d-%m-%Y')"
      ```
  2. kami akan memulai dengan kelinci untuk langkah awal, maka bentuk if saya terdiri dari kondisi1:
      ```
      [ -d ~/Sisop_Prak1/Soal_3/Kucing_$kemarin ]
      ``` 
      untuk mengecek apakah terdapat directory dengan nama `Kucing_$kemarin` dimana `$kemarin` disini adalah variable yang menyimpan date kemarin pada current           directory dan kondisi2:
      ```
      [ ! -d ~/Sisop_Prak1/Soal_3/Kelinci_$kemarin ]
      ```
      untuk mengecek apakah tidak terdapat directory dengan nama “Kelinci_$kemarin” pada current directory. 
      Jika kondisi 1 terpenuhi artinya kemarin telah mendownload kucing maka sekarang saat nya mendownload kelinci, jika kondisi 2 terpenuhi artinya kemarin belum mendownload kelinci maka sekarang saat nya mendownload kelinci oleh karena itu kedua kondisi tersebut dihubungkan dengan or.

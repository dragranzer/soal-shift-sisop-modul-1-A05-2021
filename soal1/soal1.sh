#!/bin/bash
filename='syslog.log'
# (1a) RegEX yang digunakan adalah (ticky: )([A-Z]*)([^\(]*)\(([a-z]*)
# Hasilnya disimpan di BASH_REMATCH
echo "(1b)"
pd=0
fnf=0
ftc=0
while read line; do
[[ $line =~ (ticky: )([A-Z]*)([^\(]*)\(([a-z]*) ]] &&
    if [[ ${BASH_REMATCH[2]} == 'ERROR' ]]
    then
        if [[ ${BASH_REMATCH[3]} == " The ticket was modified while updating " ]] || [[ ${BASH_REMATCH[3]} == ' Permission denied while closing ticket ' ]] || [[ ${BASH_REMATCH[3]} == ' Tried to add information to closed ticket ' ]]
        then
            pd=$((pd+1))
        elif [[ ${BASH_REMATCH[3]} == " Ticket doesn't exist " ]]
        then
            fnf=$((fnf+1))
        elif [[ ${BASH_REMATCH[3]} == " Connection to DB failed " ]] || [[ ${BASH_REMATCH[3]} == " Timeout while retrieving information " ]]
        then
            ftc=$((ftc+1))
        fi
        echo ${BASH_REMATCH[3]}
        total_error=$((total_error+1))
    fi
done < $filename
echo "Total ERROR: $total_error"

declare -A data_ekstrak
data_ekstrak[0]=$pd
data_ekstrak[1]=$fnf
data_ekstrak[2]=$ftc

echo "Error,Count" > "error_message2.csv"

for key in ${!data_ekstrak[@]}; do
    str=''
    if [[ $key == 0 ]]
    then
        str+='Permission denied'
    elif [[ $key == 1 ]]
    then
        str+='File not found'
    elif [[ $key == 2 ]]
    then
        str+='Failed to connect to DB'
    fi
    echo "$str,${data_ekstrak[$key]}" >> "error_message2.csv"
done

tail -n +2 error_message2.csv | sort -t, -k2 -r -n | cat <(head -1 error_message2.csv) - > error_message.csv
rm error_message2.csv

# (1c) Menampilkan total ERROR dan INFO untuk setiap username
echo "(1c)"
#!/bin/bash
declare -A hashmaperror
declare -A hashmapinfo
declare -A users
user_index=0
declare -A users_available
while read line; do
[[ $line =~ (ticky: )([A-Z]*)([^\(]*)\(([a-z]*) ]] &&
    if [[ -z ${users_available[${BASH_REMATCH[4]}]} ]]
    then
        users[$((index))]=${BASH_REMATCH[4]}
        index=$((index+1))
        users_available["${BASH_REMATCH[4]}"]=1
    fi
    if [[ ${BASH_REMATCH[2]} == 'ERROR' ]]
    then
        hashmaperror[${BASH_REMATCH[4]}]=$(( hashmaperror[${BASH_REMATCH[4]}]+1 ))
    elif [[ ${BASH_REMATCH[2]} == 'INFO' ]]
    then
        hashmapinfo[${BASH_REMATCH[4]}]=$(( hashmapinfo[${BASH_REMATCH[4]}]+1 ))
    fi
done < $filename

output_file='user_statistic2.csv'
printf "Username,INFO,ERROR\r\n" > $output_file
for key in ${users[@]}; do
    if [[ -z ${hashmapinfo[$key]} ]]
    then
        jumlah_info=0
    else
        jumlah_info=${hashmapinfo[$key]}
    fi
    if [[ -z ${hashmaperror[$key]} ]]
    then
        jumlah_error=0
    else
        jumlah_error=${hashmaperror[$key]}
    fi
    echo "$key memiliki $jumlah_error pesan ERROR dan $jumlah_info pesan INFO"
    # (1e) Menuliskan username, total INFO, total ERROR di file user_statistic.csv
    printf "$key,$jumlah_error,$jumlah_info\r\n" >> $output_file
done | sort

# (1e) Mensortir data user_statistic.csv berdasarkan nama secara ascending
tail -n +2 user_statistic2.csv | sort -t, -k1 -n | cat <(head -1 user_statistic2.csv) - > user_statistic.csv
rm user_statistic2.csv

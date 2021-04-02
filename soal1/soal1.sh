#!/bin/bash
filename='syslog.log'
# (1a) RegEX yang digunakan adalah (ticky: )([A-Z]*)([^\(]*)\(([a-z]*)
# Hasilnya disimpan di BASH_REMATCH
echo "(1b)"
declare -A error_count_by_reason
declare -A error_string

error_string[0]="The ticket was modified while updating"
error_string[1]="Permission denied while closing ticket"
error_string[2]="Tried to add information to closed ticket"
error_string[3]="Ticket doesn't exist"
error_string[4]="Connection to DB failed"
error_string[5]="Timeout while retrieving information"

while read line; do
[[ $line =~ (ticky: )([A-Z]*)([^\(]*)\(([a-z]*) ]] &&
    if [[ ${BASH_REMATCH[2]} == 'ERROR' ]]
    then
        if [[ ${BASH_REMATCH[3]} == " The ticket was modified while updating " ]]
        then
          error_count_by_reason[0]=$((error_count_by_reason[0]+1))
        elif [[ ${BASH_REMATCH[3]} == " Permission denied while closing ticket " ]]
        then
          error_count_by_reason[1]=$((error_count_by_reason[1]+1))
        elif [[ ${BASH_REMATCH[3]} == " Tried to add information to closed ticket " ]]
        then
          error_count_by_reason[2]=$((error_count_by_reason[2]+1))
        elif [[ ${BASH_REMATCH[3]} == " Ticket doesn't exist " ]]
        then
          error_count_by_reason[3]=$((error_count_by_reason[3]+1))
        elif [[ ${BASH_REMATCH[3]} == " Connection to DB failed " ]]
        then
          error_count_by_reason[4]=$((error_count_by_reason[4]+1))
        elif [[ ${BASH_REMATCH[3]} == " Timeout while retrieving information " ]]
        then
          error_count_by_reason[5]=$((error_count_by_reason[5]+1))
        fi
    fi
done < $filename

error_total=0
for i in {0..5}
do
  echo "${error_string[$i]}: ${error_count_by_reason[$i]}"
  error_total=$((error_total+error_count_by_reason[$i]))
done
echo "Total Error: $error_total"

echo "Error,Count" > "error_message_temp.csv"
for i in {0..5}
do
  echo "${error_string[$i]},${error_count_by_reason[$i]}" >> "error_message_temp.csv"
done

tail -n +2 error_message_temp.csv | sort -t, -k2 -r -n | cat <(head -1 error_message_temp.csv) - > error_message.csv
rm error_message_temp.csv

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

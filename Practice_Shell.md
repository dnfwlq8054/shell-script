```shell script
#!/bin/bash

SENIOR=("mark" "iwan" "meta" "maru" "bakha")
JUNIOR=("hwani" "luke" "shu" "jayden" "mando")
LEN=${#SENIOR[@]}
DAY=$(date --date 0 +%d)
FIRST_WEEK_CHECK=$(cal | awk 'BEGIN {FS="\n"; RS=""} { print $3 }')

read -a WEEK_ARRAY <<< $(echo ${FIRST_WEEK_CHECK} | sed 's/./&/g')
PLUS=$([[ ${#WEEK_ARRAY[@]} -ge 6 ]] && echo 0 || echo 4)

for ((i=3; i < $(cal | wc -l); i++));
do
    if [[ "$(cal | head -${i} | grep $((DAY + 1)) || echo "FALSE")" != "FALSE" ]]; then
        PLUS=$((i + PLUS - 3))
        break
    fi
done

for ((i=0; i<${LEN}; i++));
do
    
done
```

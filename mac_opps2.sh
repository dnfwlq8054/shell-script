#!/bin/sh

########################
# 만년 달력 쉘 프로그램#
########################

#### 최경환 ###

BACKEND_WARRIOR1=("mark" "maru" "iwan" "meta")
BACKEND_WARRIOR2=("hwani" "jaden" "pio" "poter" "mandoo" "jally" "luke" "shu")
LEN1="${#BACKEND_WARRIOR1[@]}"
LEN2="${#BACKEND_WARRIOR2[@]}"
IDX=0
YEAR="${1}"                                 #년도를 저장하기 위한 변수
MONTH="${2}"                                #달을 저장하기 위한 변수
NUM=28                                  #2월달이 28일까지 인지 29일까지인지 저장하는 변수
DAY_LIST=( 31 "${NUM}" 31 30 31 30 31 31 30 31 30 31 ) #1월달 부터 12월달 까지의 일 수
DAY=1                                   #일수를 나타내기 위한 변수
COUNT=0                                 #이 변수는 그달의 공백을 정해주는 중요한 변수 입니다.
j=0                                     #공백을 반복시킬 변수
i=0                                     #그 해의 달만 출력할때 쓸 변수

if [[ "${#}" == 0 ]]         #입력값 없이 실행만 시켯을경우 다음과 같이 초기화를 해줍니다.
then
    YEAR="$(date +%Y)"
    MONTH=0
elif [[ "${#}" == 1 ]]
then
    if [[ ("${1}" -gt 12 && "${1}" -lt 1000) || "${1}" == 0 ]]
    then
        exec echo "잘못된 입력입니다."
    fi

    YEAR="$(date +%Y)"
    MONTH="${1}"
elif [[ "${#}" == 2 ]]    #입력값이 2개일때
then
    if [[ 12 -lt "${MONTH}" ]]   #만약 명령어를 10 2015 이렇게 입력했을 경우 년도와 달의 값을 서로 바꿔주기 위한 if문 입니다.
    then
        TEMP="${YEAR}"
        YEAR="${MONTH}"
        MONTH="${TEMP}"
    fi
fi

if [[ (`(expr ${YEAR} % 4)` == 0 && `(expr ${YEAR} % 100)` != 0) ||  `(expr ${YEAR} % 400)` == 0 ]] #윤년은 해당 년도를 4로 나눴을때 값이 0이면 윤년으로 취급
then
    NUM=29                                               # 해당 년도를 100으로 나누어 떨어지면 그것은 윤년이 아님
fi                                                       # 100으로 나누어 떨어졌어도 400으로도 나누어 떨어지면 이건 윤년, 2000년 달력이 그러함

DAY_LIST[1]="${NUM}"     #변수 NUM의 바뀐 값을 DAY_LIST[1]에 저장하고 있습니다.

#만년달력 공식#
#만년 달력은 1582년에 그 이전에 사용하던 율리우스력에서 그레고리력으로 방식을 변경.
#때문에 기준 시작년을 1583년으로 잡습니다.
#=======================================================================
#우선 평년과 윤년을 구해야 한다. (1583년~그 해당 년도)

YEAR=`expr ${YEAR} - 1`   #그 해당 년도에 -1을 해준다. 왜냐하면 1583년~해당 년도 전까지의 윤년과 평년을 구해야 함으로
YUN=`expr \( ${YEAR} / 4 \) - \( ${YEAR} / 100 \) + \( ${YEAR} / 400 \) - 383` #윤년의 갯수를 구하는 공식으로

#우선 그 년도에서 4로 나누면 해당 윤년의 갯수가 나오지만 100으로 나눴을때 값을 빼줘야하고 또 400으로 나눴을때 윤년을 더해줘야 함으로
#위같은 공식이 나오고 383은 위 같은 공식을 1538에 대입 시켯을때 고정으로 383값이 나옵니다.

PUNG=`expr \( ${YEAR} - 1583  \) - ${YUN}`  #이건 평년을 구하는 공식 입니다.

COUNT=`expr ${PUNG} + \( ${YUN} \* 2 \)`    #이부분이 핵심인대 그 해당 년도의 1월1일 기준 공백을 나타내기 위한 공식입니다.
COUNT=`expr ${COUNT} % 7`                 #우선 평년일경우 다음년 1월1일이 하루 뒤로 가고 윤년일경우는 다음년 1월1일이 이틀 넘어감으로
                                        #윤년에 2를 곱하고 평년의 겟수를 더한 값을 COUNT에 넣었습니다.
                                        #그 후 일월화수목금토을 0~6까지로 정했을때 7로 나누어서 나머지값으로 그 해당 년도의 1월1일을 결정합니다.
                                        #그리고 COUNT값에 따라서 공백을 채워주면 됩니다.
#========================================================================
YEAR=`expr ${YEAR} + 1` #년도 출력을 편하게 하기 위해서 다시 -1한걸 +1을 해줍니다.

if [[ ("${#}" == 1 && "${1}" -gt 12) || "${#}" == 0 ]] #입력값이 1개거나 아에 없으면 해당년도나 입력된 년도를 출력하기위한 if문
then
    MONTH=0         #이부분은 월값이 없음으로 MONTH값을 0으로 초기화 시켜 줍니다.
    N1=0
    N2=0
    echo -e "\t\t  ${YEAR}년 달력"
    while [[ "${MONTH}" -lt 12 ]]
    do
        echo "\n`expr ${MONTH} + 1`월"
        echo "일\t월\t\t화\t\t수\t\t목\t\t금\t\t토"
        
        while [ "${j}" -lt "$((COUNT - 1))" ] #해당 년도 1월1일의 값을 위에서 구한 COUNT값 만큼 반복해주면서
        do                      #시작 요일을 결정합니다.
            echo "\t\t\c"
            j=`expr ${j} + 1`
        done
        echo "\t\c"
        while [[ "${DAY}" -le "${DAY_LIST[${MONTH}]}" ]] #시작요일이 결정됫으면 그해당 년도의 달의 일수를 출력해 줍니다.
        do
            if [[ "${COUNT}" == 6 ]]
            then
                echo "\t\c"
            elif [[ "${COUNT}" == 7 ]]     #7개 출력하면 다음으로 넘어가게끔 만들었습니다.
            then                    #그리고 COUNT값 초기화를 7일때만 초기화 시킴으로써 다음달로 넘어갔을때
                echo                     #이어서 요일을 기억해 출력해주고 있습니다.
                echo "\t\c"
                COUNT=0
            else
                
                if (((IDX % 4) == 0)); then 
                    N1=$((N1 + 1))
                fi

                if (((IDX % 8) == 0)); then
                    N2=$((N2 + 1))
                fi

                echo "${BACKEND_WARRIOR1[(((IDX + N1) % LEN1))]}, ${BACKEND_WARRIOR2[(((IDX + LEN2 - 1 - N2) % LEN2))]}\t\c"
                IDX=`expr ${IDX} + 1`
            fi
            DAY=`expr ${DAY} + 1`
            COUNT=`expr ${COUNT} + 1`
        done
        echo                            #보기 편하게 하기위해서 echo 문을 썻습니다.
        DAY=1                           #일수를 초기화함으로써 다음달로 넘어갈때 1로 시작하게끔 합니다.
        MONTH=`expr ${MONTH} + 1`
        j=0                             #COUNT값을 반복시키기위한 변수 값 초기화
    done
elif [[ "${#}" == 2 || "${1}" -lt 13 ]]      #여기는 해당 년도의 달만 출력하는 if문입니다. 입력값이 2개일때만 동작합니다.
then
    if [[ "${1}" -lt 13 ]]
    then
        MONTH="${1}"
    fi

    echo "\n\t\t  ${YEAR}년 ${MONTH}월"
    echo "일\t월\t\t화\t\t수\t\t목\t\t금\t\t토"

    N=0
    N1=0
    N2=0
    while [[ "${N}"+1 -lt "${MONTH}" ]]
    do
        while [[ "${DAY}" -le "${DAY_LIST[${N}]}" ]]
        do
            if [[ "${COUNT}" == 6 ]]
            then
                COUNT=6
            elif [[ "${COUNT}" == 7 ]]
            then
                COUNT=0
            else
            
            if (((IDX % 4) == 0)); then 
                N1=$((N1 + 1))
            fi

            if (((IDX % 8) == 0)); then
                N2=$((N2 + 1))
            fi
                IDX=`expr ${IDX} + 1`
            fi
            
            DAY=`expr ${DAY} + 1`
            COUNT=`expr ${COUNT} + 1`
        done
        DAY=1
        N=`expr ${N} + 1`
    done

    while [[ "${j}" -lt "$((COUNT - 1))" ]] 
    do
        echo "\t\t\c"
        j=`expr ${j} + 1`
    done
    echo "\t\c"
    while [[ "${DAY}" -le "${DAY_LIST[${MONTH} - 1]}" ]]     #여기는 해당 달을 입력받기때문에 배열은 0번부터 시작함으로 -1을 해줍니다.
    do
        if [[ "${COUNT}" == 6 ]]
        then
            echo "\t\c"
        elif [[ "${COUNT}" == 7 ]]  
        then        
            echo
            echo "\t\c"
            COUNT=0
        else
            if (((IDX % 4) == 0)); then 
                N1=$((N1 + 1))
            fi

            if (((IDX % 8) == 0)); then
                N2=$((N2 + 1))
            fi

            echo "${BACKEND_WARRIOR1[(((IDX + N1) % LEN1))]}, ${BACKEND_WARRIOR2[(((IDX + LEN2 - 1 - N2) % LEN2))]}\t\c"
            IDX=`expr ${IDX} + 1`
        fi
        DAY=`expr ${DAY} + 1`
        COUNT=`expr ${COUNT} + 1`
    done                                   
    echo
else
    echo "명령어 사용 법 : ./cal1 [YEAR] [MONTH] or [MONTH] [YEAR]"     #인자값이 3개 이상일경우엔 다음과 같은 사용방법을 출려해주는 echo문 입니다.
fi

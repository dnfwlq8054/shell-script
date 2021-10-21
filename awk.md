
https://mug896.github.io/awk-script/builtin_variables.html


awk에는 여러가지 기능이 있다.

- sub	지정한 문자열 치환
- gsub	문자열 일괄 치환
- index	주어진 문자열과 일치하는 문자의 인덱스를 반환
- length	문자열의 길이를 반환
- substr	시작위치에서 주어진 길이 만큼의 문자열 반환
- split	문자열을 분리하여 배열로 반환
- printf	지정한 포맷에 따라 함수 출력

### split
```shell script
awk '{split($0, d, "lambda/"); print d[3]}' sync.list
```

### length
``` shell script
echo "a11 b c de" | awk '{print length($1)}'

# output:
3
```

### printf
``` shell script
echo "asiflzseilfz.zip" | awk '{printf "%.10s\n", $1}'

# output:
asiflzseil
```

### substr
``` shell script 
echo "download: s3 ziselfjzls.zip" | awk '{print substr($3, 0, length($3) -4)}'

# output:
ziselfjzls
```

### -F
``` shell script
echo "asd.eri:eir zzz" | awk -F'[.: ]' '{for(i=1; i < NF; i++) print $i}'

# output:
asd
eri
eir
````

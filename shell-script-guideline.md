https://google.github.io/styleguide/shellguide.html#s4.2-function-comments

# 구글의 쉘 스타일 가이드를 읽고 공부할겸 번역하고 있습니다.

## 배경 
### 사용할 쉘
Bash는 실행 파일에 허용되는 유일한 쉘 스크립팅 언어입니다.

실행 파일은 `#!/bin/bash` 로 시작해야 합니다 . 스크립트를 `bash script_name`으로 호출해도 기능이 손상되지 않도록 `set`을 사용하여 셸 옵션을 설정합니다.

모든 실행 가능한 셸 스크립트를 bash로 제한하면 모든 시스템에 설치된 일관된 셸 언어를 얻을 수 있습니다.

이에 대한 유일한 예외는 코딩하는 것에 의해 강제되는 경우입니다. 이 예는 스크립트에 플레인 Bourne 쉘을 필요로하는 SolarisSVR4 패키지입니다.(뭔말인지 모르겠음)

### 쉘을 사용하는 경우

셸은 작은 유틸리티나 간단한 래퍼 스크립트에만 사용해야 합니다.

쉘 스크립트는 개발 언어가 아니지만 Google 전체에서 다양한 유틸리티 스크립트를 작성하는 데 사용됩니다. 이 스타일 가이드는 광범위한 배포에 사용된다는 제안보다는 사용에 대한 인식입니다.

몇 가지 지침:
 - 주로 다른 유틸리티를 호출하고 비교적 적은 데이터 조작을 수행하는 경우 셸이 작업에 적합한 선택입니다.
 - 성능이 중요한 경우 쉘이 아닌 다른 것을 사용하십시오.
 - 100행이 넘는 스크립트를 작성하거나 간단하지 않은 제어 흐름 논리를 사용하는 경우 지금 보다 구조화된 언어로 다시 작성해야 합니다. 
   스크립트가 커집니다. 나중에 시간이 많이 걸리는 재작성을 피하기 위해 스크립트를 일찍 재작성하십시오.
 - 코드의 복잡성을 평가할 때(예: 언어 전환 여부를 결정하기 위해) 코드 작성자가 아닌 다른 사람이 코드를 쉽게 유지 관리할 수 있는지 여부를 고려하십시오.

## 쉘 파일 및 인터프리터 호출
### 파일 확장자
실행 파일에는 확장자 `.sh`나(강력 권장) 확장자가 없어야 합니다. 라이브러리는`.sh` 확장이 필요하며, 실행이되어서는 안됩니다.

프로그램을 실행할 때 어떤 언어로 작성되었는지 알 필요가 없으며 쉘은 확장을 필요로 하지 않으므로 실행 파일에는 사용하지 않는 것이 좋습니다.

그러나 라이브러리의 경우, 언어가 무엇인지 아는 것이 중요하며 때로는 다른 언어로 된 유사한 라이브러리가 필요합니다. 
이렇게 하면 언어별 접미사를 제외하고는 목적이 같지만 다른 언어를 사용하는 라이브러리 파일의 이름을 동일하게 지정할 수 있습니다.

### SUID/SGID
SUID 및 SGID는 쉘 스크립트에서 금지 됩니다.

쉘에는 SUID/SGID를 허용할 만큼 충분히 보안을 유지하는 것이 거의 불가능하게 만드는 보안 문제가 너무 많습니다. bash는 SUID를 실행하기 어렵게 만들지만 일부 플랫폼에서는 여전히 가능하므로 금지에 대해 명시적입니다. (아무래도 권한 상승으로 인한 관리자 권한 탈취가 가능하기 때문)

따라서 루트 권한이 필요 하다면 `sudo`를 이용합니다.

## 출력
### STDOUT vs STDERR
모든 오류 메시지는 STDERR(2)로 이동해야 합니다.

이렇게 하면 정상적인 상태를 실제 문제와 쉽게 구분할 수 있습니다.

다른 상태 정보와 함께 오류 메시지를 출력하는 기능을 권장합니다.

```shell script
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if ! do_something; then
  err "Unable to do_something"
  exit 1
fi
```

## 코멘트
### 파일 헤더
스크립트에 대한 설명을 파일 시작할때 작성합니다.

모든 파일에는 내용에 대한 간략한 개요가 포함된 최상위 주석이 있어야 합니다. 저작권 표시 및 저자 정보는 선택 사항입니다.

예시
```shell script
#!/bin/bash
#
# Perform hot backups of Oracle databases.
```

### 기능 설명
명확하지 않고 짧지 않은 기능은 주석 처리되어야 합니다. 라이브러리의 모든 기능은 길이나 복잡성에 관계없이 주석 처리되어야 합니다.

다른 사람이 코드를 읽지 않고 주석(제공되는 경우 자체 도움말)을 읽고 프로그램을 사용하거나 라이브러리의 기능을 사용하는 방법을 배울 수 있어야 합니다.

모든 함수 주석은 다음을 사용하여 의도한 API 동작을 설명해야 합니다.
 - 기능에 대한 설명입니다.
 - 전역: 사용 및 수정된 전역 변수 목록입니다.
 - 인수: 인수.
 - 출력: STDOUT 또는 STDERR로 출력합니다.
 - 반환값: 마지막 명령 실행의 기본 종료 상태 이외의 값을 반환합니다.

예시:
```shell script
#######################################
# Cleanup files from the backup directory.
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
#######################################
function cleanup() {
  …
}

#######################################
# Get configuration directory.
# Globals:
#   SOMEDIR
# Arguments:
#   None
# Outputs:
#   Writes location to stdout
#######################################
function get_dir() {
  echo "${SOMEDIR}"
}

#######################################
# Delete a file in a sophisticated manner.
# Arguments:
#   File to delete, a path.
# Returns:
#   0 if thing was deleted, non-zero on error.
#######################################
function del_thing() {
  rm "$1"
}
```

### 구현 코멘트
코드가 까다롭거나, 명확하지 않거나, 흥미롭거나, 중요한 부분에 주석을 답니다.

이는 일반적인 Google 코딩 주석 관행을 따릅니다. 모든 댓글을 달지 마십시오. 복잡한 알고리즘이 있거나 비정상적인 작업을 수행하는 경우 간단한 설명을 입력하세요.

### TODO 댓글
임시적이거나 단기적인 해결책이거나 충분하지만 완벽하지 않은 코드에는 TODO 주석을 사용하십시오.

이것은 [C++가이드](https://google.github.io/styleguide/cppguide.html#TODO_Comments) 의 규칙과 일치합니다 .

`TODO`는 모두 대문자로 된 문자열을 포함해야 하며, 그 뒤에 참조하는 문제에 대한 가장 적절한것은 컨텍스트를 가진 사람의 이름, 전자메일 주소 또는 기타 식별자가 와야 합니다 주요 목적은 `TODO`요청시 더 자세한 정보를 얻는 방법을 찾기 위해 검색할 수 있는 일관성을 갖는 것입니다 . `TODO`는 언급된 사람이 문제를 해결할 것이라는 약속이 아닙니다. 따라서 `TODO`를 만들 때 거의 항상 이름이 지정됩니다.

```shell script
# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)

```

## 서식
### 들여 쓰기

탭 없이 2칸 들여쓰기.

가독성을 높이려면 블록 사이에 빈 줄을 사용합니다.

### 줄 길이와 긴 문자열
최대 줄 글이는 80자 입니다.

80자보다 긴 문자열을 작성해야 하는 경우 가능하면 here 문서 또는 포함된 개행 문자를 사용하여 작성해야 합니다. 80자보다 길어야 하고 현명하게 분할할 수 없는 리터럴 문자열은 괜찮지만 더 짧게 만드는 방법을 찾는 것이 좋습니다.

```shell script
# DO use 'here document's
cat <<END
I am an exceptionally long
string.
END

# Embedded newlines are ok too
long_string="I am an exceptionally
long string."
```

### 파이프라인
파이프라인이 한 줄에 모두 맞지 않으면 한 줄에 하나씩 분할해야 합니다.

파이프라인이 한 줄에 모두 맞는 경우 한 줄에 있어야 합니다.


그렇지 않은 경우 줄 바꿈에 파이프가 있고 파이프의 다음 섹션에 대해 2개의 공백 들여쓰기가 있는 줄당 하나의 파이프 세그먼트로 분할되어야 합니다. 
```shell script
# All fits on one line
command1 | command2

# Long commands
command1 \
  | command2 \
  | command3 \
  | command4
```

### 루프
`for, while, if` 문에는 `;, do, then` 을 넣습니다.

Example:
```shell script
# If inside a function, consider declaring the loop variable as
# a local to avoid it leaking into the global environment:
# local dir
for dir in "${dirs_to_cleanup[@]}"; do
  if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if (( $? != 0 )); then
      error_message
    fi
  else
    mkdir -p "${dir}/${ORACLE_SID}"
    if (( $? != 0 )); then
      error_message
    fi
  fi
done
```
### switch문
 - 2칸 들여씁니다.
 - 다음 패턴으로 갈때는 `;;`로 개행.

Example1:
```shell script
case "${expression}" in
  a)
    variable="…"
    some_command "${variable}" "${other_expr}" …
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" …
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac
```


Example2:
```shell script
verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
  case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```

### 변수
변수를 사용할 때 `$var` 보단 `${var}`를 더 선호합니다.

이는 필수가 아니지만, 권장사항입니다.
 - 기존 코드에서 찾은 내용과 일관성을 유지해야한다.
 - 인용 변수를 아래 섹션을 참고.
 - 꼭 필요하거나 깊은 혼란을 피하는 경우가 아니라면 단일 문자, 쉘 특수 문자, 매개변수 등을 중괄호로 구분하지 마십시오.
 - 모든 변수는 중괄호로 구분하는 것을 선호합니다.

Example:
```shell script
# Section of *recommended* cases.

# Preferred style for 'special' variables:
echo "Positional: $1" "$5" "$3"
echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ …"

# Braces necessary:
echo "many parameters: ${10}"

# Braces avoiding confusion:
# Output is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# Preferred style for other variables:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
while read -r f; do
  echo "file=${f}"
done < <(find /tmp)
```
참고: `${}`를 사용하는 것은 인용형식이 아닙니다. 인용형식은 `" "`도 사용해야 합니다.

### 인용
따옴표 없는 확장이 필요하거나, 쉘 내부 정수가 아닌 경우 변수, 명령 대체, 공백 또는 쉘 메타 문자가 포함된 문자열을 항상 인용하세요.

```shell script
# 'Single' quotes indicate that no substitution is desired.
# "Double" quotes indicate that substitution is required/tolerated.

# Simple examples

# "quote command substitutions"
# Note that quotes nested inside "$()" don't need escaping.
flag="$(some_command and its args "$@" 'quoted separately')"

# "quote variables"
echo "${flag}"

# Use arrays with quoted expansion for lists.
declare -a FLAGS
FLAGS=( --foo --bar='baz' )
readonly FLAGS
mybinary "${FLAGS[@]}"

# It's ok to not quote internal integer variables.
if (( $# > 3 )); then
  echo "ppid=${PPID}"
fi

# "never quote literal integers"
value=32
# "quote command substitutions", even when you expect integers
number="$(generate_number)"

# "prefer quoting words", not compulsory
readonly USE_INTEGER='true'

# "quote shell meta characters"
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# "command options or path names"
# ($1 is assumed to contain a value here)
grep -li Hugo /dev/null "$1"

# Less simple examples
# "quote variables, unless proven false": ccs might be empty
git send-email --to "${reviewers}" ${ccs:+"--cc" "${ccs}"}

# Positional parameter precautions: $1 might be unset
# Single quotes leave regex as-is.
grep -cP '([Ss]pecial|\|?characters*)$' ${1:+"$1"}

# For passing on arguments,
# "$@" is right almost every time, and
# $* is wrong almost every time:
#
# * $* and $@ will split on spaces, clobbering up arguments
#   that contain spaces and dropping empty strings;
# * "$@" will retain arguments as-is, so no args
#   provided will result in no args being passed on;
#   This is in most cases what you want to use for passing
#   on arguments.
# * "$*" expands to one argument, with all args joined
#   by (usually) spaces,
#   so no args provided will result in one empty string
#   being passed on.
# (Consult `man bash` for the nit-grits ;-)

(set -- 1 "2 two" "3 three tres"; echo $#; set -- "$*"; echo "$#, $@")
(set -- 1 "2 two" "3 three tres"; echo $#; set -- "$@"; echo "$#, $@")
```

## 기능 및 버그

### 쉘체크
[ShellCheck](https://www.shellcheck.net/) 프로젝트는 쉘 스크립트에 대한 일반적인 버그 및 경고를 식별합니다. 크든 작든 모든 스크립트에 권장됩니다.

### 명령 대체
백틱<code>\`</code> 대신 `$(command)`을 사용하십시오 .

중첩된 백틱은 내부 백틱을 <code>(\`)</code>로 이스케이프해야 합니다. `$(command)`는 중첩이 되며 쉽게 읽히고 충돌나지 않습니다.

예시:
```shell script
# This is preferred:
var="$(command "$(command1)")"
# This is not:
var="`command \`command1\``"
```

### Test, [ … ], and [[ … ]]
`[[ … ]]`는 `[ … ]`, `test` 및 `/usr/bin/[`보다 선호됩니다.

`[[ … ]]`는 `[[  ]]` 사이에 경로 이름 확장 또는 단어 분할이 발생하지 않으므로 오류를 줄입니다. 또한 `[[ … ]]`는 정규식 일치를 허용하지만 `[ … ]`는 그렇지 않습니다.

```shell script
# This ensures the string on the left is made up of characters in
# the alnum character class followed by the string name.
# Note that the RHS should not be quoted here.
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi

# This matches the exact pattern "f*" (Does not match in this case)
if [[ "filename" == "f*" ]]; then
  echo "Match"
fi
```

``` shell script
# This gives a "too many arguments" error as f* is expanded to the
# contents of the current directory
if [ "filename" == f* ]; then
  echo "Match"
fi
```
자세한 내용은 E14 (http://tiswww.case.edu/php/chet/bash/FAQ) 를 참조하십시오.

### 문자열
가능하면 문자열을 표시할 때 `" "` 를 사용합니다.

Bash는 테스트에서 빈 문자열을 처리할 만큼 충분히 똑똑합니다. 따라서 코드가 훨씬 읽기 쉽다는 점을 감안할 때,
문자가 없을 때는 `-z` 같은 명령어나 `""` 를 사용하여 빈 문자열을 찾아 내면 좋습니다.

```shell script
# Do this:
if [[ "${my_var}" == "some_string" ]]; then
  do_something
fi

# -z (string length is zero) and -n (string length is not zero) are
# preferred over testing for an empty string
if [[ -z "${my_var}" ]]; then
  do_something
fi

# This is OK (ensure quotes on the empty side), but not preferred:
if [[ "${my_var}" == "" ]]; then
  do_something
fi
```

```shell script
# Not this:
if [[ "${my_var}X" == "some_stringX" ]]; then
  do_something
fi
```

테스트 대상에 대한 혼동을 방지하려면 `-z `또는 `-n`을 명시적으로 사용합니다.
```shell script
# Use this
if [[ -n "${my_var}" ]]; then
  do_something
fi

# Instead of this
if [[ "${my_var}" ]]; then
  do_something
fi
```

명확성을 위해 둘 다 작동하더라도 `=`가 아니라 `==`를 사용하십시오. 

`=` 는 대입으로 혼동할 수 있습니다.

수치 비교를 할 때 `<` 및 `>`를 사용하는데, 주의해야 합니다. 수치 비교를 위해 `(( … ))` 또는 `-lt` 및 `-gt`를 사용합니다.
```shell script
# Use this
if [[ "${my_var}" == "val" ]]; then
  do_something
fi

if (( my_var > 3 )); then
  do_something
fi

if [[ "${my_var}" -gt 3 ]]; then
  do_something
fi
```

```shell script
# Instead of this
if [[ "${my_var}" = "val" ]]; then
  do_something
fi

# Probably unintended lexicographical comparison.
if [[ "${my_var}" > 3 ]]; then
  # True for 4, false for 22.
  do_something
fi
```

### 파일 와일드 카드( * )
파일을 가져올 때 앞에 `./` 을 붙여줍니다.

그렇지 않으면 원치 않은 파일을 삭제, 수정할 수 있습니다.

```shell script
# Here's the contents of the directory:
# -f  -r  somedir  somefile

# Incorrectly deletes almost everything in the directory by force
psa@bilby$ rm -v *
removed directory: `somedir'
removed `somefile'
```

```shell script
# As opposed to:
psa@bilby$ rm -v ./*
removed `./-f'
removed `./-r'
rm: cannot remove `./somedir': Is a directory
removed `./somefile'
```

### 배열
Bash 배열은 인용 복잡성을 피하기 위해 요소 목록을 저장하는 데 사용해야 합니다. 

보다 복잡한 데이터 구조를 용이하게 하기 위해 배열을 사용해서는 안 됩니다.(heap 정렬 이런거?)

배열은 정렬된 문자열 모음을 저장하고 명령 또는 루프에 대한 개별 요소로 안전하게 확장할 수 있습니다.

```shell script
# An array is assigned using parentheses, and can be appended to
# with +=( … ).
declare -a flags
flags=(--foo --bar='baz')
flags+=(--greeting="Hello ${name}")
mybinary "${flags[@]}"
```

```shell script
# Don’t use strings for sequences.
flags='--foo --bar=baz'
flags+=' --greeting="Hello world"'  # This won’t work as intended.
mybinary ${flags}
```

#### 배열 장점
 - 배열을 사용하면 인용 의미 체계를 혼동하지 않고도 목록을 사용할 수 있습니다. 반대로 배열을 사용하지 않으면 문자열 내부에 따옴표를 중첩하려는 잘못된 시도가 발생합니다.
 - 배열을 사용하면 공백이 포함된 문자열을 포함하여 임의 문자열의 시퀀스/목록을 안전하게 저장할 수 있습니다.

#### 배열 단점
 - 배열을 사용하면 스크립트의 복잡성이 증가할 위험이 있습니다.

#### 배열 접근
목록을 안전하게 만들고 전달하려면 배열을 사용해야 합니다. 특히 명령 인수 집합을 작성할 때 배열을 사용하여 인용 문제를 혼동하지 않도록 합니다.

쌍따옴표가 붙은 확장을 사용합니다. `"${array[@]}"`

### Pipes to While
while로 파이프하는 대신 프로세스 대체 또는 내장 `readarray(bash4+)`를 사용합니다. 
파이프는 서브쉘을 생성하므로 파이프라인 내에서 수정된 모든 변수는 상위 쉘로 전파되지 않습니다.

```shell script
# bad...

last_line='NULL'
echo 'hi' | while read -r line; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done

# This will always output 'NULL'!
echo "${last_line}"
```

```shell script
# good!!
last_line='NULL'
temp='a b c d e f g'
while read line; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done < <(echo "${temp}")

# This will output the last non-empty line from ${temp}
echo "${last_line}"
```

내장 명령어 `readarray`를 사용하여, 파일을 배열로 읽은 다음 배열의 내용을 반복합니다. 

(위와 같은 이유로) 파이프가 아닌 `readarray`로 프로세스 대체를 사용해야 하지만 루프에 대한 입력 생성이 이후가 아니라 이전에 위치한다는 이점이 있습니다.

```shell script
# This will output the last non-empty line from your_command
echo "${last_line}"

last_line='NULL'
readarray -t lines < <(echo "a b c d e f g")
for line in "${lines[@]}"; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done
echo "${last_line}"
```

> 참고: for 루프를 사용하여 $(...)의 for var에서와 같이 출력을 반복하는 데 주의하십시오.
> 
> 출력이 줄이 아닌 공백으로 분할되기 때문입니다.
> 
> 출력에 예기치 않은 공백이 포함될 수 없기 때문에 이것이 안전하다는 것을 알 수 있지만, 이것이 명확하지 않거나 가독성을 향상시키지 않는 경우(예: $(...) 내부의 긴 명령),
> 
> while 읽기 루프 또는 readarray는 종종 더 안전하고 명확합니다.

### 계산
계산을 할 때 `let`, `$[]`, `expr` 보다 `((...))` or `$((...))` 를 사용하는게 좋습니다.

`[[...]]` 에서는 `<`, `>` 연산이 수행되지 않습니다.(대신 사전표전 편차로 비교를 합니다. 문자열 기준)

때문에 무언가를 비교할때는 `((...))` 안에서 사용하도록 합시다.

`(( … ))`를 독립형 명령문으로 사용하지 않는 것이 좋습니다. 그렇지 않으면 표현식이 0으로 평가되는 것을 주의하십시오.

```shell script
# Simple calculation used as text - note the use of $(( … )) within
# a string.
echo "$(( 2 + 2 )) is 4"

# When performing arithmetic comparisons for testing
if (( a < b )); then
  …
fi

# Some calculation assigned to a variable.
(( i = 10 * j + 400 ))
```

```shell script
# This form is non-portable and deprecated
i=$[2 * 10]

# Despite appearances, 'let' isn't one of the declarative keywords,
# so unquoted assignments are subject to globbing wordsplitting.
# For the sake of simplicity, avoid 'let' and use (( … ))
let i="2 + 2"

# The expr utility is an external program and not a shell builtin.
i=$( expr 4 + 4 )

# Quoting can be error prone when using expr too.
i=$( expr 4 '*' 4 )
```

스타일 고려 사항은 제쳐두고, 쉘의 내장 산술은 expr보다 몇 배나 빠릅니다.

변수를 사용할 때 `${var}`및 `$var` 형식은 `$(( … ))` 내에서 필요하지 않습니다. 

셸은 `var`를 찾는 것을 알고 `${…}`를 생략하면 코드가 더 깔끔해집니다. 

이것은 항상 중괄호를 사용한다는 이전 규칙과 약간 상반되므로 권장 사항일 뿐입니다.

## 명명 규칙

### 함수 이름

단어를 구분하기 위해 밑줄이 있는 소문자를 사용합니다. (카멜은 사용 안하나?)

`::`로 라이브러리를 구분합니다. 함수 이름 뒤에 괄호가 필요합니다. 키워드 기능은 선택 사항이지만 프로젝트 전체에서 일관되게 사용해야 합니다.

단일 기능을 작성하는 경우 소문자를 사용하고 밑줄로 단어를 구분하십시오. 패키지를 작성하는 경우 패키지 이름을 `::` 로 구분.

중괄호는 함수 이름과 같은 줄에 있어야 하며(Google의 다른 언어와 마찬가지로) 함수 이름과 괄호 사이에 공백이 없어야 합니다.

```shell script
# Single function
my_func() {
  …
}

# Part of a package
mypackage::my_func() {
  …
}
```

### 변수 이름
루프에 대한 변수 이름은 비슷하게 가져갑니다.
```shell script
for zone in "${zones[@]}"; do
  something_with "${zone}"
done
```

### 상수 및 환경 변수 이름
밑줄로 구분된 모든 대문자는 파일의 맨 위에 선언됩니다.

상수 및 환경으로 내보내는 모든 항목은 대문자로 표시해야 합니다.

```shell script
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'
```
일부 항목은 첫 번째 설정에서 일정해집니다(예: getopts를 통해). 

따라서 getopts에서 또는 조건에 따라 상수를 설정하는 것이 좋지만 직후에는 읽기 전용으로 설정해야 합니다. 명확성을 위해 readonly또는 export동등한 declare명령 대신 권장됩니다.


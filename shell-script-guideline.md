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

#!/usr/bin/env sh
# kb-consistency-check.sh — KB 자기 DRY 도그푸딩 (dev-only)
# ---------------------------------------------------------------------------
# WHY: 자기완결 전략은 같은 상수를 여러 파일에 복제하므로 시간이 지나면 갈라진다.
#      이 스크립트는 references/_contract.md 가 정의한 핵심 상수가
#      KB 전반에서 단일값인지 단언한다.
#      위반 1건이라도 있으면 비0 종료 — CI/사전 커밋 훅에서 게이트로 쓸 수 있다.
# WHAT: 토큰 "--name: value;" 형태의 *값 할당*만 추출해 비교한다(산문의 "예산 ≤250ms"
#       같은 언급은 제외). _audit.html(산출물 검사)과 별개의 KB-레벨 검사.
# 무빌드: POSIX sh + grep/sed/sort만. node 불요.
# 사용: sh tools/kb-consistency-check.sh   (성공=exit 0, 위반=exit 1)
# ---------------------------------------------------------------------------
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
# examples/ 를 스캔에 포함하는 것은 *의도된 설계*다:
#   여기서 단언하는 상수는 a11y 1급 토큰(motion-duration·focus-ring·target-size)으로,
#   이들은 personality(미적 시안)와 무관한 *품질 하한선*이다. 따라서 어떤 데모 시안도
#   이 값을 의도적으로 달리해선 안 된다(secure-by-default). 데모가 a11y 하한을 흔들면
#   FAIL이 맞다 — 그게 이 검사의 목적. 시안별로 달라도 되는 *미적* 값(색·radius·폰트)은
#   애초에 이 스크립트의 단언 대상이 아니다.
SCAN="$ROOT/references $ROOT/skills $ROOT/examples $ROOT/tools"
fail=0

# 토큰 "--name:" 의 모든 값 할당이 단일 기대값인지 단언.
# $1=토큰명  $2=기대값(정규화: 공백제거·소문자)
assert_single_value() {
  token=$1; want=$2
  # "--token: VALUE;" 에서 VALUE만 추출 → 공백 제거 → 소문자 → 정렬 유니크
  vals=$(grep -rhoE -- "${token}[[:space:]]*:[[:space:]]*[^;]+;" $SCAN 2>/dev/null \
          | sed -E "s/.*:[[:space:]]*//; s/;.*//; s/[[:space:]]//g" \
          | tr 'A-Z' 'a-z' \
          | sort -u)
  [ -z "$vals" ] && { echo "SKIP  $token (할당 없음)"; return; }
  n=$(printf '%s\n' "$vals" | grep -c . || true)
  if [ "$n" -ne 1 ]; then
    echo "DRIFT $token → 값 ${n}종: $(printf '%s ' $vals)"; fail=1; return
  fi
  if [ "$vals" != "$want" ]; then
    echo "WRONG $token = $vals (기대 $want)"; fail=1; return
  fi
  echo "OK    $token = $vals"
}

# 금지 패턴이 KB에 존재하면 위반. $1=패턴  $2=설명
# 계약/카드/스크립트 파일은 패턴을 '금지 예시'로 정당하게 언급하므로 제외.
assert_absent() {
  pat=$1; desc=$2
  hits=$(grep -rlE "$pat" $SCAN 2>/dev/null \
          | grep -vE '_contract\.(md|json)|tokens\.contract\.json|_block-card\.md|kb-consistency-check\.sh' \
          || true)
  if [ -n "$hits" ]; then
    echo "FORBID '$desc' ($pat) 발견:"; printf '  %s\n' $hits; fail=1
  else
    echo "OK    금지 패턴 없음: $desc"
  fi
}

echo "== KB 일관성 검사 (references/_contract.md 기준) =="

# 1) 모션·포커스·타깃 상수 단일값 (확정값은 _contract.md §1·§2)
assert_single_value "--motion-duration-base" "200ms"
assert_single_value "--motion-duration-fast" "120ms"
assert_single_value "--focus-ring-width"     "2px"
assert_single_value "--focus-ring-offset"    "2px"
assert_single_value "--target-size-min"      "24px"

# 2) 네이밍 컨벤션: 금지된 reference 변종이 KB에 남아 있지 않은지 (_contract.md §4)
assert_absent "[-][-]ref-[a-z]"           "--ref-* 변종(정규는 --color-*)"
assert_absent "[-][-]color-viz-accent\b"  "--color-viz-accent(정규는 --color-viz-categorical-N)"
assert_absent "[-][-]color-viz-neutral\b" "--color-viz-neutral(정규는 --color-viz-categorical-N)"
assert_absent "[-][-]color-accent-[0-9]"  "--color-accent-N(정규는 --color-brand-N)"

# 3) 본문 대비 임계: 정규 표기 'Lc ≥ 75'(AND 4.5:1) 가 KB에 존재하고,
#    'Lc ≥ 75' 가 본문 임계로 쓰이는지 확인. (75/60/45/30 4단계는 같은 표에 공존하므로
#    표 전체 스캔으로 드리프트를 잡으려 하면 오탐 — 정규 표기의 *존재*만 단언한다.)
lc75=$(grep -rhoE "Lc[[:space:]]*[≥>=]+[[:space:]]*75" $SCAN 2>/dev/null | head -n1 || true)
if [ -z "$lc75" ]; then
  echo "MISSING 본문 'Lc ≥ 75' 정규 표기를 찾지 못함"; fail=1
else
  echo "OK    본문 Lc ≥ 75 표기 존재"
fi

echo "================================================"
if [ "$fail" -ne 0 ]; then
  echo "RESULT: FAIL — 위 드리프트를 _contract.md 확정값으로 통일하세요."
  exit 1
fi
echo "RESULT: PASS — 핵심 상수·네이밍 단일값 일관."
exit 0

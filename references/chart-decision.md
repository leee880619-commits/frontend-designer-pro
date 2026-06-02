# chart-decision.md — 차트 선택·데이터 정직성·인라인 SVG 패턴 (자기완결)

> dataviz-report-specialist 렌즈의 단일 지식원. 이 파일은 **자기완결**이다.
> 외부 스킬(frontend-design / frontend-designer / color-expert)이 설치돼 있지 않아도,
> 런타임 에이전트가 이 파일만 읽고 차트 결정·코드 생성·정직성 검증을 끝낼 수 있도록
> 결정 규칙 + 표 + 코드 스니펫을 전부 담았다.
>
> 적용 범위: 02-skill-spec.md §4.2(공유용 분석 보고서) · §4.3(C레벨 보고서) · §4.4(발표 PPT 덱)의
> 모든 차트. 웹앱(§4.1)도 차트를 그리면 이 규율을 따른다.
>
> **핵심 약속**: 차트는 "예쁜 그림"이 아니라 **결론을 말하는 증거**다. 한 차트는 한 문장(takeaway)을
> 증명하고, 그 문장은 데이터를 과장하거나 왜곡하지 않는다. 색맹 동료·흑백 인쇄·화면 0건 상태에서도
> 무너지지 않는다.

---

## 0. 비개발자를 위한 한 줄 (이 문서가 보장하는 것)

> "차트가 무슨 말을 하려는지 제목만 봐도 알 수 있고, 그 말이 데이터를 부풀리지 않으며,
> 색을 구분 못 하는 동료나 흑백 출력에서도 똑같이 읽힙니다."

세부 규칙은 전부 백스테이지(산출 시점 내부)에서 돌고, 사용자에게는
**그림 + 결론형 제목 + 신호등(잘 읽힘/주의)**만 보인다.

---

## 1. 차트 선택 결정표 (Chart Decision Table)

**먼저 질문 하나**: "이 차트로 **무엇을 보여주려는가**?" (질문 = 의도(intent), 데이터 형태가 아님)
의도를 아래 6범주 중 하나로 분류하면 차트가 정해진다. 의도가 둘이면 차트를 **나누어라**(슬라이드당 1주장).

| # | 보여주려는 것 (의도) | 일상어 | 1순위 차트 | 대안 | 피할 것 | 한 줄 이유 |
|---|---------------------|--------|-----------|------|---------|-----------|
| 1 | **비교 (Comparison)** — 항목 간 크기 차이 | "누가 더 큰가" | **막대(bar)** | 가로막대(범주명 긴 경우·항목 多), 도트플롯(dot plot) | 파이(비교 부정확), 3D 막대 | 길이는 사람이 가장 정확히 비교하는 시각 채널 |
| 2 | **시간 추이 (Trend)** — 시간에 따른 변화 | "오르나 내리나" | **선(line)** | 면적(area, 누적 합 강조 시), 막대(이산·소수 시점) | 파이, 점만 찍기 | 선은 연속·방향성·기울기를 한눈에 |
| 3 | **상관 (Correlation)** — 두 변수의 관계 | "X 커지면 Y도?" | **산점(scatter)** | 버블(3번째 변수=크기), 회귀선 오버레이 | 두 선을 한 축에 겹치기(축 단위 다르면 거짓) | 점 구름의 기울기·뭉침이 관계를 드러냄 |
| 4 | **부분-전체 (Part-to-Whole)** — 구성 비율 | "무엇으로 이루어졌나" | **누적막대(stacked bar)** | treemap(항목 多·계층), 100%누적막대(비율 비교) | 파이(범주 ≥6), 도넛 다중, 3D 파이 | 누적막대는 항목 多·시계열에도 견딤 |
| 4b | **부분-전체 (항목 ≤5, 1시점)** | "딱 몇 조각" | **파이/도넛 (항목 ≤5일 때만)** | 누적막대(언제나 안전) | 파이 6조각+, "기타" 비대 파이 | 파이는 각도 비교가 부정확 → 조각 ≤5에서만 허용 |
| 5 | **분포 (Distribution)** — 값이 퍼진 모양 | "대부분 어디에 몰렸나" | **히스토그램(histogram)** | 박스플롯(box, 그룹 간 분포 비교), 바이올린 | 평균 1개로 분포 대체, 파이 | 분포는 평균만으론 거짓말 — 모양을 보여야 함 |
| 6 | **밀도 (Density)** — 2차원 격자의 강도 | "어디가 뜨거운가" | **히트맵(heatmap)** | 등고선, 격자 막대 | 너무 많은 점을 산점으로(겹침), 파이 | 격자 색강도가 패턴(요일×시간 등)을 드러냄 |

### 1.1 결정 규칙 (의사코드)

```
intent = ask("이 차트로 무엇을 보여주려는가?")   # 6범주 분류
if intent == 비교:            chart = bar          # 범주명 길거나 >8개 → 가로막대
elif intent == 추이:          chart = line         # 시점 ≤4개 이산이면 bar 허용
elif intent == 상관:          chart = scatter
elif intent == 부분전체:
     if 항목수 <= 5 and 시점 == 1: chart = pie      # ★ 파이는 여기서만
     else:                         chart = stacked_bar  # 계층/항목多 → treemap
elif intent == 분포:          chart = histogram     # 그룹 비교 → box
elif intent == 밀도:          chart = heatmap

# 의도가 2개 이상이면 → 차트를 분리 (한 차트 = 한 결론)
```

### 1.2 자주 틀리는 오용 → 교정 (BLOCK 사유)

| 오용 | 왜 틀렸나 | 교정 |
|------|-----------|------|
| 시계열을 파이로 | 시간 변화는 파이로 안 보임 | 선 차트 |
| 6개+ 항목 파이 | 조각 각도 비교 불가 | 누적막대 또는 상위5+"외 N건" |
| 단위 다른 두 선을 한 축에 | 기울기 비교가 거짓 인상 | 축 분리 or 지수화(=100 기준) or 작은배수(small multiples) |
| 막대 y축이 0이 아님 | 차이를 과장(데이터 왜곡) | **막대는 무조건 0 시작** (§2.2) |
| 평균값 막대 1개로 분포 주장 | 분산을 숨김 | 히스토그램/박스 |
| 3D·그림자·그라디언트 장식 차트 | 잉크가 데이터를 가림 | data zone 절제(§4) |

---

## 2. 데이터 ↔ 스케일 매핑 (Data-to-Encoding Contract)

### 2.1 색 스케일 3종 (어떤 데이터에 어떤 색)

> 토큰 네임스페이스는 token-system.md의 `color.viz.*`를 그대로 쓴다(차트 전용 독립 네임스페이스).
> raw hex 직접 사용 금지 — 무결성 게이트의 토큰 lint에서 BLOCK.

| 스케일 | 일상어 | 데이터 종류 | 쓰는 곳 | 토큰 |
|--------|--------|------------|---------|------|
| **순차 (sequential)** | "진하기로 크기 표현" | 0→큰값, 한 방향 (매출·인구·밀도) | 히트맵, 단색 단계지도 | `color.viz.sequential` (단색 명도 램프) |
| **발산 (diverging)** | "가운데 기준 양쪽으로 갈림" | 중간 기준 ±편차 (증감률, 목표대비) | 적자/흑자, 전월대비 | `color.viz.diverging` (두 색상이 중앙 0에서 갈림) |
| **범주 (categorical)** | "서로 다른 항목을 다른 색으로" | 순서 없는 분류 (부서·제품·지역) | 막대 그룹, 선 다중, 범례 | `color.viz.categorical.1` ~ `.8` |

규칙:
- **범주는 8색 이내** (CVD 안전 팔레트). 9개 이상이면 상위 7 + "기타" 묶기 또는 색 대신 직접 라벨.
- **순차/발산을 범주에 쓰지 말 것**(순서 없는 데이터에 명도 순서를 입히면 거짓 위계).
- **범주를 순차에 쓰지 말 것**(크기 차이를 색상 차이로 표현하면 크기 비교 불가).

### 2.2 축(axis) 정직성 — 명문화 (협상 불가)

> **이것은 데이터 정직성에 직접 영향**을 주므로, 02-skill-spec §2의
> "축 잘림 허용은 명시 동의 필수"에 해당한다. 임의로 잘리면 무결성 게이트 BLOCK.

| 차트 | y축 시작 | 근거 |
|------|---------|------|
| **막대 (bar)** | **반드시 0** | 막대의 "길이"가 값이다. 0이 아니면 길이비 = 값비가 깨져 차이를 과장 → 데이터 왜곡 |
| **선 (line)** | **0 아니어도 됨 (잘림 허용)** | 선은 "기울기·변화"가 핵심. 작은 변동을 보려면 잘림이 정당. 단 잘렸음을 표기 |
| 산점 | 0 아니어도 됨 | 관계(기울기·뭉침)가 핵심 |
| 누적막대 | 반드시 0 | 막대와 동일 — 길이가 값 |
| 히스토그램 | 빈도축 0 | 막대 규칙 동일 |

선 차트를 0 아닌 곳에서 시작하면(잘림, truncation) **반드시 둘 중 하나**:
1. 축 시작값을 축 라벨에 명시 (예: y축 최솟값 80 표기), 또는
2. 축 깨짐 표시(axis break ⌇) 마크.
사용자가 "변화를 더 크게 보이고 싶다"고 잘림을 요청해도, **사실(잘렸다는 점)을 차트에 표기**하는 조건으로만 허용. 표기 없이 잘면 거짓.

### 2.3 같은 변수 = 같은 색 (Color Consistency)

> 한 문서/덱 전체에서 **같은 의미는 같은 색**으로 고정한다.

- "매출"이 슬라이드1에서 파랑이면, 슬라이드7에서도 파랑. 범례를 다시 읽지 않아도 되게.
- 색-의미 매핑은 art brief(SSOT)에 1회 못박고 모든 차트가 상속.
- 강조 1개(예: 우리 회사 막대)는 accent, 나머지는 중립 회색 → 시선을 결론으로 유도(데이터잉크 §4).
- 의미색(빨강=위험/적자, 초록=양호/흑자)은 문화·CVD 영향 → **색만으로 의미 전달 금지**, 항상 라벨/부호 병기(§5 이중 인코딩).

---

## 3. takeaway title 강제 (결론형 제목)

> **규칙(BLOCK)**: 모든 차트 제목은 **명사구가 아니라 결론형 문장**이어야 한다.
> 명사구 제목은 anti-slop-checklist.md의 "명사구 차트 제목" 위반과 동일하게 적발·교체.

제목은 "독자가 이 차트에서 **얻어야 할 결론**"을 평서문으로 쓴다. 차트는 그 문장의 증거다.

| ❌ 명사구 (금지) | ✅ takeaway 결론형 (필수) |
|------------------|--------------------------|
| "월별 매출" | "매출은 3월 이후 4개월 연속 상승했다" |
| "지역별 점유율" | "수도권이 전체 점유율의 62%를 차지한다" |
| "고객 이탈률 추이" | "이탈률은 가격 인상 직후 2배로 뛰었다" |
| "제품군 비교" | "B제품이 매출의 절반을 책임진다" |
| "응답 시간 분포" | "응답의 90%는 200ms 안에 끝난다" |
| "부서별 예산" | "마케팅 예산이 작년 대비 40% 줄었다" |

작성 규칙:
- **수치를 1개 이상 포함**(검증 가능한 주장). 단 막대마다 라벨이 있으면 제목은 패턴을 말함.
- **방향/판정을 포함**(상승/하락/집중/예외/2배 등) — "어떻다"가 들어가야 결론.
- 한 문장. 두 결론이 필요하면 차트를 나눈다.
- 제목이 자명하지 않을 때만 부제목(작은 글씨)으로 맥락/단서 추가.
- **마크업 위치**: takeaway는 `<figure>`의 `<figcaption>` 또는 차트 상단 제목 영역에. 동시에 SVG `<title>`에도 동일 결론을 넣어 스크린리더가 먼저 읽게 한다(§6).

---

## 4. 정보 위계 · 데이터잉크 규율

### 4.1 정보 위계 3단 (Information Hierarchy)

> 02-skill-spec §4.2 "정보 위계 3단" / §4.3 BLUF / §4.4 "슬라이드당 1주장" 통합.

```
1단 핵심 결론 1개      ← 가장 크게, 맨 위 (BLUF: 결론 먼저)
2단 근거 차트/표 3~5개  ← 핵심을 떠받치는 증거
3단 부록·상세 데이터     ← 표·메타·원자료, 접어두거나 뒤로
```

- **문서/섹션당 결론 1개**, **슬라이드당 주장 1개**. 한 화면에 결론이 둘이면 분리.
- 차트 배치 순서 = 논증 순서. 위에서 아래로 읽으면 주장이 증명되게.

### 4.2 데이터잉크(data-ink) 규율 — "잉크는 데이터에만"

> 의미 없는 잉크(장식)는 데이터를 가린다. data zone(차트 내부)은 절제한다.
> (art brief의 expression zone=표지/간지는 자유, **data zone은 절제** — 경계는 art-brief-template.md)

**지워라 (chartjunk)**:
- 3D 효과, 그림자, 입체 막대 (값 비교를 망침)
- 무의미한 배경 그라디언트, 텍스처
- 모든 막대에 다른 색(범주 의미 없는데 무지개) — 강조 1개 외 중립색
- 과한 격자선(grid): 옅게(`color.viz.grid`), 또는 직접 라벨 있으면 제거
- 범례가 불필요한데 범례 붙이기 → **직접 라벨**로 대체(선 끝/막대 위에 이름)
- 축 눈금 과밀: 4~6개면 충분

**남겨라**:
- 데이터 자체(막대/선/점)
- 결론을 돕는 직접 라벨, 기준선(목표/평균), takeaway 제목
- 단위·축 라벨(최소한)

**판정**: "이 잉크를 지우면 데이터 이해가 나빠지나?" → 아니오면 지운다.

---

## 5. 정적 4상태 (Static-4 States) — 정적 차트의 필수 분기

> 02-skill-spec §4.2 "정적 4상태" / §1 6단계 "상태 매트릭스(웹앱 8 / 정적 4)".
> 정적 산출물(보고서·덱)에는 인터랙션이 없으므로, **데이터가 정상이 아닐 때를 산출 시점에 처리**해야 한다.
> 4상태 중 하나라도 누락되면 무결성 게이트에서 ASK/BLOCK.

| 상태 | 일상어 | 처리 규칙 | 마크업/표현 |
|------|--------|-----------|-------------|
| **1. empty (데이터 0건)** | "보여줄 게 없음" | 빈 차트 영역에 **"데이터 없음" 명시** + 이유(예: "해당 기간 거래 없음"). 빈 축만 그리고 끝내지 말 것 | `<figure>` 안에 `role="img"` + 텍스트 "데이터 없음 — {이유}". 0과 무데이터를 구분(0은 막대 길이 0, 무데이터는 명시) |
| **2. overflow (항목 과다)** | "너무 많아 다 못 보임" | **상위 N개 + "외 M건"** 1행으로 묶음. N은 보통 7~10. "외 M건"의 합계도 표기 | 막대: 상위7 + "외 35건 (합계 ₩1.2억)" 1막대. 표: 상위N행 + 합계행 |
| **3. NA (결측값)** | "값이 비어 있음" | **0으로 칠하지 말 것**(거짓). 끊긴 선(gap)·"NA" 라벨·점선 보간 명시 중 택1 | 선: 결측 구간은 선을 끊거나 점선+"추정". 막대: 막대 자리에 "NA" 텍스트. 0과 절대 혼동 금지 |
| **4. print 분할 (페이지 넘김)** | "인쇄하면 잘림" | `@media print`에서 차트가 페이지 경계에서 잘리지 않게. 표는 머리행 반복 | `break-inside: avoid;`를 `figure`에. 긴 표는 `thead { display: table-header-group; }` |

`@media print` 최소 패턴:

```css
@media print {
  figure { break-inside: avoid; }          /* 차트가 페이지 경계에서 안 잘림 */
  table { break-inside: auto; }
  thead { display: table-header-group; }    /* 페이지마다 머리행 반복 */
  tr    { break-inside: avoid; }
}
```

empty 상태 인라인 표현(예):

```html
<figure role="group" aria-label="월별 거래액">
  <figcaption>3월 거래는 발생하지 않았다</figcaption>
  <div class="chart-empty" role="img"
       aria-label="데이터 없음 — 해당 기간 거래 없음">
    데이터 없음 · 해당 기간 거래 없음
  </div>
</figure>
```

---

## 6. 인라인 SVG 차트 — 실제 코드 패턴 (런타임 0KB, 더블클릭)

> 보고서·덱의 차트는 **인라인 SVG**로 그린다(라이브러리 0KB, 빌드 0, 더블클릭 동작).
> 모든 SVG 차트는 아래 접근성 골격을 **반드시** 갖춘다. (a11y-checklist.md "차트 대체텍스트" 협상 불가)

### 6.0 모든 SVG 차트 공통 골격 (필수)

1. `<svg role="img">` + 첫 자식에 `<title>`(=takeaway 결론) + `<desc>`(=데이터 요약 한두 문장).
2. `aria-labelledby`로 title/desc 연결.
3. **색 외 직접 라벨**: 값·이름을 SVG 안에 텍스트로 직접 표기(색만으로 구분 금지 = 이중 인코딩).
4. 색은 `var(--color-viz-*)` 토큰만. raw hex 금지.
5. **스크린리더용 대체 표(table) 병행**(협상 불가): 시각장애 사용자는 SVG를 표로 읽는다.
6. `viewBox`로 반응형(고정 width/height 픽셀 대신 `viewBox` + CSS `max-width:100%`).

```
이중 인코딩(dual encoding) = 색 + 또 하나의 단서(직접 라벨/명도/부호/위치).
색맹(CVD) 동료·흑백 인쇄에서도 구분되게. 색만 쓰면 BLOCK.
```

### 6.1 막대 차트 (vertical bar) — 복붙 가능 패턴

> y축 0 시작(§2.2). 막대 위 직접 라벨(범례 대신). 강조 1개 accent, 나머지 중립.

```html
<figure class="chart">
  <figcaption id="bar-title">B제품이 매출의 절반을 책임진다</figcaption>
  <svg viewBox="0 0 320 200" role="img"
       aria-labelledby="bar-title bar-desc" class="chart-svg">
    <title>B제품이 매출의 절반을 책임진다</title>
    <desc id="bar-desc">제품별 매출. A 30, B 95, C 25, D 40 (단위: 억원). B가 최대.</desc>

    <!-- y축 0 기준선 -->
    <line x1="40" y1="170" x2="310" y2="170" stroke="var(--color-viz-axis)" stroke-width="1"/>

    <!-- 막대: 값에 비례한 높이. 0에서 시작하므로 y=170-h, height=h -->
    <!-- A: 값30 -> h=60 / 중립색 -->
    <rect x="55"  y="110" width="40" height="60"  fill="var(--color-viz-categorical-1)"/>
    <text x="75"  y="105" text-anchor="middle" class="bar-val">30</text>
    <text x="75"  y="185" text-anchor="middle" class="bar-lbl">A</text>

    <!-- B: 값95 -> h=140 / 강조 accent -->
    <rect x="120" y="30"  width="40" height="140" fill="var(--color-brand-500)"/>
    <text x="140" y="25"  text-anchor="middle" class="bar-val">95</text>
    <text x="140" y="185" text-anchor="middle" class="bar-lbl">B</text>

    <!-- C: 값25 -> h=50 -->
    <rect x="185" y="120" width="40" height="50"  fill="var(--color-viz-categorical-1)"/>
    <text x="205" y="115" text-anchor="middle" class="bar-val">25</text>
    <text x="205" y="185" text-anchor="middle" class="bar-lbl">C</text>

    <!-- D: 값40 -> h=80 -->
    <rect x="250" y="90"  width="40" height="80"  fill="var(--color-viz-categorical-1)"/>
    <text x="270" y="85"  text-anchor="middle" class="bar-val">40</text>
    <text x="270" y="185" text-anchor="middle" class="bar-lbl">D</text>

    <text x="40" y="15" class="axis-unit">억원</text>
  </svg>

  <!-- 스크린리더용 대체 표 (협상 불가): 시각적으로 숨기되 읽힘 -->
  <table class="visually-hidden">
    <caption>제품별 매출 (억원)</caption>
    <thead><tr><th scope="col">제품</th><th scope="col">매출</th></tr></thead>
    <tbody>
      <tr><th scope="row">A</th><td>30</td></tr>
      <tr><th scope="row">B</th><td>95</td></tr>
      <tr><th scope="row">C</th><td>25</td></tr>
      <tr><th scope="row">D</th><td>40</td></tr>
    </tbody>
  </table>
</figure>
```

값→픽셀 변환 규칙(막대): `chartH = 140`(0~최대값 영역 높이), `barH = (값/최대값) * chartH`,
`y = baselineY - barH`. **항상 0이 baseline**(§2.2).

### 6.2 선 차트 (line) — 복붙 가능 패턴

> 추이용. 0 아닌 시작 허용하되 축 최솟값 표기(§2.2). 선 끝에 직접 라벨(범례 대신).

```html
<figure class="chart">
  <figcaption id="line-title">매출은 3월 이후 4개월 연속 상승했다</figcaption>
  <svg viewBox="0 0 340 200" role="img"
       aria-labelledby="line-title line-desc" class="chart-svg">
    <title>매출은 3월 이후 4개월 연속 상승했다</title>
    <desc id="line-desc">월별 매출(억원). 1월 40, 2월 38, 3월 35, 4월 52, 5월 61, 6월 70. y축 시작 30.</desc>

    <!-- 축: y 최솟값 30 명시 (잘림을 정직하게 표기) -->
    <line x1="40" y1="20" x2="40" y2="170" stroke="var(--color-viz-axis)"/>
    <line x1="40" y1="170" x2="320" y2="170" stroke="var(--color-viz-axis)"/>
    <text x="10" y="173" class="axis-min">30</text>  <!-- ← 0 아님을 명시 -->
    <text x="10" y="25"  class="axis-max">80</text>

    <!-- 옅은 격자(데이터잉크 절제) -->
    <line x1="40" y1="95" x2="320" y2="95" stroke="var(--color-viz-grid)" stroke-width="0.5"/>

    <!-- 데이터 선: 좌표는 값을 매핑한 결과 -->
    <polyline fill="none" stroke="var(--color-brand-500)" stroke-width="2"
              points="50,140 100,146 150,155 200,104 250,77 300,50"/>

    <!-- 데이터 점 + 양끝 직접 라벨 -->
    <circle cx="50"  cy="140" r="3" fill="var(--color-brand-500)"/>
    <circle cx="300" cy="50"  r="3" fill="var(--color-brand-500)"/>
    <text x="50"  y="135" text-anchor="middle" class="pt-lbl">40</text>
    <text x="300" y="45"  text-anchor="middle" class="pt-lbl">70</text>

    <!-- x축 시점 라벨 -->
    <text x="50"  y="185" text-anchor="middle" class="x-lbl">1월</text>
    <text x="175" y="185" text-anchor="middle" class="x-lbl">3월</text>
    <text x="300" y="185" text-anchor="middle" class="x-lbl">6월</text>
  </svg>

  <table class="visually-hidden">
    <caption>월별 매출 (억원, y축 시작 30)</caption>
    <thead><tr><th scope="col">월</th><th scope="col">매출</th></tr></thead>
    <tbody>
      <tr><th scope="row">1월</th><td>40</td></tr>
      <tr><th scope="row">2월</th><td>38</td></tr>
      <tr><th scope="row">3월</th><td>35</td></tr>
      <tr><th scope="row">4월</th><td>52</td></tr>
      <tr><th scope="row">5월</th><td>61</td></tr>
      <tr><th scope="row">6월</th><td>70</td></tr>
    </tbody>
  </table>
</figure>
```

값→픽셀 변환 규칙(선): `x = padL + (i / (n-1)) * plotW`,
`y = baselineY - ((값 - yMin) / (yMax - yMin)) * plotH`. yMin이 0이 아니면 **축에 yMin 표기 필수**.

### 6.3 차트 SVG 공통 CSS (tokens.css 변수 사용)

```css
.chart-svg { width: 100%; max-width: 480px; height: auto; }          /* viewBox 반응형 */
.chart-svg .bar-val, .pt-lbl { font-size: 11px; fill: var(--color-text); font-weight: 600; }
.chart-svg .bar-lbl, .x-lbl  { font-size: 11px; fill: var(--color-text-muted); }
.chart-svg .axis-unit, .axis-min, .axis-max { font-size: 10px; fill: var(--color-text-muted); }
figure.chart { margin: 0 0 1.5rem; }
figure.chart figcaption { font-weight: 700; margin-bottom: .5rem; line-height: 1.4; }

/* 스크린리더 전용(시각적으로 숨김, 읽기는 가능) */
.visually-hidden {
  position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
  overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; border: 0;
}
@media print { .chart-svg { max-width: 100%; } figure.chart { break-inside: avoid; } }
```

### 6.4 검증 체크리스트 (SVG 차트 1개당 — 산출 직전 전수)

- [ ] `role="img"` + `<title>`(=takeaway) + `<desc>`(=데이터 요약) 있음
- [ ] `aria-labelledby`로 title/desc 연결됨
- [ ] 스크린리더용 `<table>` + `<caption>` + `th scope` 병행됨
- [ ] 색 외 직접 라벨(값/이름)이 SVG 안에 있음 (이중 인코딩)
- [ ] 막대면 y축 0 시작 / 선이면 yMin 표기됨
- [ ] 색이 전부 `var(--color-viz-*)` / `var(--color-brand-*)` (raw hex 0)
- [ ] 강조 1개 외 중립색(데이터잉크 절제), 3D·그림자 없음
- [ ] 제목이 결론형 문장(명사구 아님)
- [ ] `viewBox` 반응형 + `@media print break-inside:avoid`

---

## 7. 메타데이터 블록 (Provenance Footer) — 필수

> 02-skill-spec §4.2/§4.3 "출처·기준일·n=·가정 메타 푸터". 데이터를 보여주면 **반드시** 출처를 밝힌다.
> 메타가 없는 차트/표는 "믿어달라"는 빈말 — 무결성 게이트 ASK.

문서·섹션 하단(또는 각 차트 figcaption 아래)에 아래 4요소를 둔다:

| 요소 | 일상어 | 예시 |
|------|--------|------|
| **출처 (source)** | "어디서 가져온 숫자인가" | 출처: 사내 매출 DW (Finance) |
| **기준일 (as-of)** | "언제 기준인가" | 기준일: 2026-05-31 |
| **표본 (n=)** | "몇 건/몇 명 기준인가" | n = 1,284건 |
| **가정 (assumptions)** | "어떤 전제·제외가 있나" | 가정: 환불 제외, 환율 1,350원 고정 |

마크업 패턴:

```html
<footer class="data-meta">
  <p>출처: 사내 매출 DW (Finance) · 기준일: 2026-05-31 · n = 1,284건</p>
  <p>가정: 환불 제외, 환율 1,350원 고정. 추정치는 점선으로 표시.</p>
</footer>
```

```css
.data-meta { font-size: 11px; color: var(--color-text-muted); margin-top: 1rem;
             border-top: 1px solid var(--color-viz-grid); padding-top: .5rem; }
```

> **예시 데이터 워터마크 규칙(필수)**: 실제 수치가 아직 없어 **예시(임시) 데이터**로 차트·KPI를 채웠다면, 오발행(예시가 실제처럼 출고)을 막기 위해 **반드시** 표기한다 — (1) 메타 푸터에 `<p>본 화면의 모든 수치는 검증용 예시(임시) 데이터입니다.</p>` 추가, (2) `<title>`/`<meta name="description">` 인근에 "(예시 데이터)" 병기. 실데이터로 교체되면 이 표기를 제거한다. **누락 시 BLOCK**(redteam 영역 E). 실데이터 인입 단계는 SKILL 단계 6 참조.

---

## 8. 스토리 골격 — SCQA / BLUF

> 차트는 낱개로 떠다니지 않는다. **문서 전체가 하나의 논증**이 되도록 골격에 얹는다.
> 02-skill-spec §4.2(SCQA/Pyramid) · §4.3(BLUF).

### 8.1 BLUF (Bottom Line Up Front) = "결론 먼저"

> C레벨·임원 보고(§4.3) 기본. 의사결정자는 시간이 없다 → 첫 화면에 결론·요청.

```
[1] 결론·권고 (한 줄)        ← 맨 위. "X를 승인 바랍니다 / Y가 원인입니다"
[2] 핵심 근거 3개            ← 결론을 떠받치는 차트/숫자
[3] 상세·부록               ← 필요 시만, 뒤로
```

### 8.2 SCQA = "상황→문제→질문→답"

> 공유용 분석 보고서(§4.2) 기본. 독자를 논리로 데려간다.

| 단계 | 일상어 | 내용 | 차트 역할 |
|------|--------|------|-----------|
| **S**ituation 상황 | "지금까지는" | 합의된 배경(이견 없는 사실) | 추세선(여기까진 정상) |
| **C**omplication 문제 | "그런데" | 변화·이상·갈등 | 꺾이는 선·튀는 막대(이상 강조) |
| **Q**uestion 질문 | "그래서?" | 독자가 떠올릴 핵심 질문 | (질문 텍스트) |
| **A**nswer 답 | "이렇게" | 분석 결론·권고 | 결론을 증명하는 차트 |

매핑 규칙: 각 차트는 SCQA의 한 단계를 맡고, takeaway 제목이 그 단계의 문장이 된다.

---

## 9. 전문용어 → 쉬운말 매핑 (질문·보고 카피용)

> 비개발자 1급 제약(02-skill-spec §8.4). 차트 관련 용어를 사용자 화면에 노출할 땐 **반드시 일상어로 번역**하거나 괄호 병기. 아래 좌측 용어는 백스테이지에서만 쓰고, 사용자에겐 우측을 쓴다.

| 전문용어 | 사용자에게 쓰는 쉬운말 |
|----------|------------------------|
| sequential (순차 스케일) | "진하기로 크기를 표현" |
| diverging (발산 스케일) | "가운데를 기준으로 양쪽이 갈라지는 색" |
| categorical (범주 스케일) | "항목마다 다른 색" |
| BLUF | "결론 먼저" |
| SCQA | "상황→문제→그래서?→답 흐름" |
| takeaway title | "한 줄 결론 제목" |
| data-ink / chartjunk | "데이터에만 잉크를, 장식은 뺀다" |
| dual encoding (이중 인코딩) | "색 말고도 글자/모양으로 한 번 더 구분" |
| CVD (색각이상) | "색을 구분하기 어려운 분"(색맹/색약) |
| axis truncation (축 잘림) | "축을 0이 아닌 데서 시작해 변화를 크게 보이게 함" |
| heatmap | "격자에 색 진하기로 강약을 칠한 표" |
| histogram | "값이 어디에 많이 몰렸는지 보여주는 막대" |
| box plot | "데이터가 퍼진 범위를 상자로 요약" |
| stacked bar | "쌓아 올린 막대로 구성 비율" |
| treemap | "면적 크기로 비중을 나타낸 타일" |
| small multiples | "같은 차트를 작게 여러 개 나란히" |
| n= | "몇 건 기준" |
| as-of | "언제 기준" |
| provenance | "이 숫자가 어디서 왔는지" |

---

## 10. 인터랙션 2조건 (Static-First, 정적 우선)

> 보고서/덱은 **정적 인라인 SVG가 기본**(런타임 0KB·더블클릭). 인터랙션(호버 툴팁·줌·필터)은
> 예외로, **아래 2조건을 동시에** 충족할 때만 경량 라이브러리(예: uPlot ≈40KB)를 조건부 도입.
> (02-skill-spec §4.2 / §9-1)

**조건 1 — 정적으로 불가능한 밀도(density)인가?**
- 수백~수천 점/계열을 한 정적 화면에 그리면 겹쳐 읽을 수 없는 경우(예: 1년치 분 단위 시계열, 대량 산점).
- 정적으로 충분히 읽히면(범주 ≤8, 시점 ≤24 등) **인터랙션 불필요** → SVG로 끝낸다.

**조건 2 — 정적 폴백이 존재하는가? (필수)**
- 인터랙션을 켜더라도, **JS 꺼짐·인쇄·스크린리더에서 핵심 결론이 보이는 정적 대체본**(요약 차트 + 표)을 반드시 함께 둔다.
- 인터랙션은 "더 파보기"용 부가물일 뿐, 결론은 정적으로 전달돼야 한다(progressive enhancement).

**정당화 기록(필수)**: 인터랙션을 도입하면 art brief/검증 요약에
"정적 불가 사유(데이터 밀도 N점) + 정적 폴백 위치"를 1줄로 남긴다. 사유 없는 인터랙션은 슬롭.

```
도입 판정:
  if (정적으로 읽힘) -> SVG 정적, 끝
  elif (밀도 과다 AND 정적 폴백 마련됨) -> 경량 라이브러리 + 정적 폴백 + 정당화 기록
  else -> SVG로 단순화(상위N·집계·small multiples)해서라도 정적 유지
```

---

## 11. 무결성 게이트 연동 (산출 직전 BLOCK 항목 요약)

> 이 파일의 규칙 중 **위반 시 BLOCK/ASK**가 되는 항목 — design-redteam-pro 감사 대상.

| 항목 | 판정 |
|------|------|
| 막대 y축이 0이 아님 (표기 없이) | **BLOCK** (데이터 왜곡) |
| 선 축 잘림에 yMin 미표기 | **BLOCK** |
| 차트 제목이 명사구(결론형 아님) | **BLOCK** (anti-slop) |
| 색만으로 의미 구분(이중 인코딩 없음) | **BLOCK** (CVD) |
| SVG `<title>`/`<desc>`/대체 table 누락 | **BLOCK** (a11y, 협상 불가) |
| 범주 색 9개 이상 | **ASK→교체** (상위7+기타) |
| 파이 조각 ≥6 | **ASK→교체** (누적막대) |
| 정적 4상태(empty/overflow/NA/print) 미처리 | **ASK→BLOCK** |
| 메타데이터(출처·기준일·n=·가정) 누락 | **ASK** |
| 차트에 3D·그림자·무의미 그라디언트 | **BLOCK** (data-ink) |
| raw hex/px 하드코딩(토큰 미사용) | **BLOCK** (토큰 lint) |
| 인터랙션 도입에 2조건/정당화 없음 | **BLOCK** |
```

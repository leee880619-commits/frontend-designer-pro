# 토큰 시스템 (Token System) — 3계층 모델 · 런타임 SSOT

> **이 파일이 다루는 것**: 색·글꼴·간격·모션 같은 디자인 "값"을 어떻게 **한 곳에 모아 관리**할지의 구조다.
> 비개발자용 한 줄: **"색·글씨를 바꾸려면 딱 한 파일(`tokens.css`)의 한 줄만 고치면 화면 전체가 같이 바뀐다"** — 그걸 가능하게 하는 설계도.
>
> **자기완결 선언**: 이 문서는 외부 스킬(frontend-design / frontend-designer / color-expert) 미설치에도 동작하도록 필요한 지식·코드를 전부 담는다. 실행 에이전트(design-lead-pro)는 이 파일만 Read 해도 토큰 시스템을 끝까지 구축할 수 있다.
>
> **이웃 파일과의 역할 분담** (중복 금지):
> - **이 파일(token-system.md)** = 토큰의 **구조**(3계층·네이밍·a11y 승격·lint·tokens.css 골격). "값을 어디에 어떤 이름으로 둘 것인가."
> - `color-token-contract.md` = 색 **값의 생성 규칙**(OKLCH 앵커에서 램프 파생, APCA AND WCAG 대비 게이트, 60-30-10, CVD). "그 색 값을 무엇으로 채울 것인가."
> - `a11y-checklist.md` = focus·motion·target 토큰이 **화면에서 어떻게 검증/적용**되는가. 이 파일은 그 토큰의 **존재와 이름**을 강제하고, a11y-checklist는 그 **쓰임과 측정**을 강제한다.

---

## 0. 한눈 요약 (실행 에이전트용 결정 규칙)

| 질문 | 답 |
|------|----|
| 토큰 계층은 몇 개인가? | **3계층**: reference → semantic → component |
| 반드시 만들어야 하는 계층은? | **reference + semantic 2계층** (BLOCK·SSOT 최소 단위). 빠지면 lint 실패. |
| component 계층은? | **옵션**(경량 모드에서 생략 가능). 단, 만들면 semantic만 참조해야 함. |
| 경량 모드에서도 못 빼는 것은? | **a11y 1급 semantic 토큰** 4종 — focus.ring / motion.duration / motion.reduce / target.size. 누락 시 lint BLOCK. |
| 차트 색은 일반 색과 같이 두나? | **아니오.** `color.viz.*` 독립 네임스페이스로 분리. |
| 런타임 진실원천(SSOT)은 어느 파일? | **`tokens.css`** (순수 CSS 변수, 빌드 의존 0). 사용자 폴더에 들어가는 유일한 토큰 파일. |
| `tokens.json`은 뭐 하는 거? | **카탈로그 생성용 원본**(편집 가이드·문서·검증 입력). 사용자 산출 폴더엔 **안 넣음**. |
| 다크/고대비/인쇄 모드는 어떻게? | **reference 계층만 1회 스왑.** semantic/component는 손대지 않음. |
| 산출 직전 무엇을 확인? | §8 **토큰 lint** (dangling/순환/고아/하드코딩 hex·px) 전수 통과. 1건이라도 위반=BLOCK. |

---

## 1. 왜 3계층인가 — 백스테이지 원리 (비개발자용 비유)

토큰(token)이란 "색 #1A2B3C" 같은 **날값(raw value)에 사람이 읽을 이름표를 붙인 것**이다.

세 계층을 **회사 조직도**에 비유하면:

1. **reference(참조) 계층 = 창고의 원자재**
   - "네이비 500", "회색 100" 같은 **순수한 색·크기 값의 팔레트**. 의미는 없고 "무슨 색인지"만 있다.
   - 예: `--color-brand-500: oklch(0.45 0.12 250)` (네이비), `--space-4: 16px`.

2. **semantic(의미) 계층 = 부서별 역할 배정**
   - "본문 글자색", "위험 버튼색", "카드 배경" 같은 **쓰임(역할)에 이름을 붙이고**, 그 값은 reference를 **가리킨다(참조)**.
   - 예: `--text-body: var(--color-gray-900)`, `--bg-danger: var(--color-red-500)`.
   - 핵심: semantic은 직접 값을 쓰지 않고 **항상 reference를 가리킨다**. 그래야 reference 한 줄만 바꿔도 전체가 바뀐다.

3. **component(부품) 계층 = 특정 직원의 책상 세팅** (옵션)
   - "버튼의 글자색", "토스트의 배경" 같은 **특정 부품 전용 변수**. semantic을 가리킨다.
   - 예: `--button-primary-fg: var(--text-on-brand)`.
   - 부품마다 세밀하게 다르게 줘야 할 때만. 안 만들어도 됨(경량 모드).

**왜 이렇게 나누나?** 색을 바꾸고 싶을 때 화면 곳곳에 흩어진 `#1A2B3C`를 찾아다니는 게 아니라, **창고(reference) 한 줄만** 고치면 그걸 가리키던 모든 역할(semantic)과 부품(component)이 한꺼번에 따라 바뀐다. 이것이 "한 곳만 바꾸면 전체가 바뀐다"의 메커니즘이다.

**참조 방향은 단방향 강제**: `component → semantic → reference`. 거꾸로 가거나(예: reference가 semantic을 가리킴) 같은 층끼리 뱅글뱅글 도는 것(순환)은 **lint BLOCK**.

```
component (옵션) ──가리킴──▶ semantic (필수) ──가리킴──▶ reference (필수)
   부품 전용              역할·의미              원자재 팔레트
```

---

## 2. reference 계층 — 원자재 팔레트 (필수)

### 2.1 네이밍 규약

| 종류 | 패턴 | 예시 |
|------|------|------|
| 브랜드/주조색 | `color.{name}.{50..900}` | `color.brand.500`, `color.gray.100` |
| 차트색(분리) | `color.viz.{role}` | §6 참조 |
| 간격 | `space.{0..12}` (4px 스텝 권장) | `space.4` = 16px |
| 글꼴크기 | `font.size.{xs..3xl}` | `font.size.base` |
| 글꼴굵기 | `font.weight.{regular,medium,bold}` | — |
| 행간 | `line.height.{tight,base,loose}` | `line.height.base` = 1.6 |
| 모서리 | `radius.{none,sm,md,lg,full}` | — |
| 그림자 | `shadow.{sm,md,lg}` | — |
| 모션시간 | `duration.{instant,fast,base,slow}` | `duration.fast` = 120ms |

### 2.2 규칙

- **색 램프는 5~7단계만** 만든다. `color.{name}.{50,100,300,500,700,900}` 식으로 **실제로 참조되는 단계만** 둔다. 안 쓰는 단계를 미리 깔아두면 **고아(orphan) lint 경고** 대상.
- 색 값 생성(OKLCH 앵커 → L 등간격·C 감쇠 파생)의 **상세 규칙은 `color-token-contract.md`** 소관. 이 파일은 "그 결과 값이 reference 계층에 `color.*` 이름으로 들어간다"는 **위치**만 강제한다.
- reference 값은 **순수 날값**(oklch/hex/px/숫자)만. reference가 다른 토큰을 `var()`로 가리키면 안 됨 — reference는 사슬의 끝(말단)이다.
- **다크/고대비/인쇄 모드의 값 차이는 reference에서만** 표현한다(§7).

> **CSS 표기 주의**: CSS 변수 이름엔 점(`.`)을 못 쓴다. 카탈로그(`tokens.json`)에선 점 표기 `color.brand.500`, 실제 CSS 변수에선 하이픈 표기 `--color-brand-500`으로 **1:1 변환**한다. lint(§8)는 이 변환 규칙을 안다.

---

## 3. semantic 계층 — 역할·의미 (필수 · SSOT 최소 단위)

semantic은 **"이 값이 어디에 쓰이는가(역할)"** 에 이름을 붙이고, 값으로는 **반드시 reference를 `var()`로 가리킨다**. semantic이 reference 없이 날값(hex/px)을 직접 쓰면 **하드코딩 lint BLOCK**.

### 3.1 표준 semantic 역할 (도메인 공통 최소 세트)

| 토큰 | 역할 | 참조 예 |
|------|------|---------|
| `--text-body` | 본문 글자색 | `var(--color-gray-900)` |
| `--text-muted` | 보조/캡션 글자색 | `var(--color-gray-600)` |
| `--text-on-brand` | 브랜드색 위 글자색 | `var(--color-white)` |
| `--bg-surface` | 카드·패널 배경 | `var(--color-gray-50)` |
| `--bg-page` | 페이지 바탕 | `var(--color-white)` |
| `--border-default` | 기본 테두리 | `var(--color-gray-200)` |
| `--accent` | 강조(60-30-10의 10) | `var(--color-brand-500)` |
| `--bg-danger` / `--bg-success` / `--bg-warning` | 의미색 | 각 reference 의미색 |
| `--space-inline` / `--space-stack` | 가로/세로 기본 간격 | `var(--space-4)` 등 |
| `--font-body` / `--font-heading` | 본문/제목 글꼴 | reference 글꼴 스택 |

> 의미색의 **대비 합격 여부(APCA Lc≥75 AND WCAG 4.5:1 등)** 판정은 `color-token-contract.md`/`a11y-checklist.md` 소관. 이 파일은 semantic 토큰의 **존재와 단방향 참조**만 책임진다.

### 3.2 component 계층 (옵션 · 경량 모드 생략 가능)

만들 때 규칙:
- **component는 semantic만 가리킨다.** component가 reference를 직접 가리키면 **계층 건너뜀(layer-skip) lint 경고**(semantic을 경유하도록 권고).
- 부품마다 세밀 제어가 필요할 때만. 단순 산출(샘플/정적 보고서)은 semantic까지만으로 충분 → **경량 모드**.

```
예) --button-primary-bg: var(--accent);
    --button-primary-fg: var(--text-on-brand);
    --toast-success-bg:   var(--bg-success);
```

---

## 4. a11y 1급 semantic 토큰 — 경량 모드에서도 생략 불가 (BLOCK)

접근성(누구나 쓸 수 있게)은 **취향이 아니라 품질 하한선**이다. 따라서 아래 4종은 **semantic 계층의 1급 시민으로 승격**되어, component를 생략하는 경량 모드에서도 **반드시 존재**해야 한다. 하나라도 빠지면 **토큰 lint BLOCK**(§8 규칙 R5).

> **상수 단일 소스**: 아래 7키의 확정 기본값(`--motion-duration-base: 200ms` 등)은 `references/_contract.md` §1·§2·§5가 SSOT다. 이 표는 그 값을 비춘다 — 값이 어긋나면 `tools/kb-consistency-check.sh`가 잡는다.

| # | 토큰 | 의미(비개발자 한 줄) | 권장 기본값 |
|---|------|---------------------|-------------|
| 1 | `--focus-ring-color` | 키보드 Tab으로 짚은 곳을 감싸는 **테두리 색** | `var(--color-brand-500)` (배경과 대비 3:1 이상) |
| 2 | `--focus-ring-width` | 그 테두리 **굵기** | `2px` |
| 3 | `--focus-ring-offset` | 테두리와 요소 사이 **간격** | `2px` |
| 4 | `--motion-duration-fast` | 짧은 애니메이션 **길이** | `120ms` |
| 5 | `--motion-duration-base` | 보통 애니메이션 **길이** | `200ms` (모션 예산 ≤250ms 준수) |
| 6 | `--motion-reduce` | "움직임 줄이기" 켜졌을 때 **0으로 만드는 플래그** | `1` (기본) / reduced 시 `0` |
| 7 | `--target-size-min` | 손가락으로 누를 **최소 터치 크기** | `24px` (권장 44px) |

### 4.1 왜 토큰으로 올리나
- focus·motion·target을 **컴포넌트마다 따로 적으면** 어디선가 빠지거나 어긋나 접근성 구멍이 생긴다. semantic 토큰 1곳에 두면 **전 화면이 같은 기준**을 쓰고, lint가 "존재"를 강제할 수 있다.
- 이 4종의 **실제 적용/측정**(focus-visible 표시, reduced-motion 미디어쿼리, 터치 크기 실측)은 `a11y-checklist.md` 소관. 이 파일은 **토큰 정의의 존재**만 BLOCK으로 강제한다.

### 4.2 표준 CSS 골격 (tokens.css에 그대로 포함)

```css
:root {
  /* a11y 1급 — 경량 모드에서도 필수 */
  --focus-ring-color: var(--color-brand-500);
  --focus-ring-width: 2px;
  --focus-ring-offset: 2px;
  --motion-duration-fast: 120ms;
  --motion-duration-base: 200ms;   /* 모션 예산 ≤250ms */
  --motion-reduce: 1;              /* 1=모션 허용, 0=정지 */
  --target-size-min: 24px;        /* 권장 44px */
}

/* 사용자가 OS에서 "움직임 줄이기"를 켜면 자동 0 */
@media (prefers-reduced-motion: reduce) {
  :root { --motion-reduce: 0; }
}

/* 적용 예 — 키보드 포커스 표시(전 요소 공통) */
:where(a, button, input, select, textarea, [tabindex]):focus-visible {
  outline: var(--focus-ring-width) solid var(--focus-ring-color);
  outline-offset: var(--focus-ring-offset);
}

/* 적용 예 — 모션은 플래그로 길이 제어(reduced 시 0초) */
.animate {
  transition-duration: calc(var(--motion-duration-base) * var(--motion-reduce));
}
```

> `calc(... * var(--motion-reduce))` 패턴: 플래그가 `0`이 되면 모든 transition 시간이 `0ms`가 되어 **움직임이 즉시 정지**한다. JS 없이 CSS 변수 하나로 reduced-motion을 전 화면에 일괄 적용하는 핵심 트릭.

---

## 5. tokens.css vs tokens.json — 역할 분리 (중요)

두 파일은 **목적이 다르며 섞으면 안 된다.**

| | `tokens.css` | `tokens.json` |
|--|--------------|----------------|
| 역할 | **런타임 SSOT** — 화면이 실제로 읽는 진실원천 | **카탈로그/문서 생성용 원본** |
| 형식 | 순수 CSS 변수 (`:root { --x: ... }`) | 구조화 JSON (계층·메타·설명) |
| 빌드 의존 | **0** (브라우저가 그대로 읽음, 더블클릭 동작) | 빌드/문서 단계에서만 사용 |
| 사용자 산출 폴더 | **포함** (사용자가 여기 1줄만 고침) | **미포함** (개발/문서용, dev-only) |
| 누가 읽나 | 브라우저·사용자 | lint 스크립트·편집 가이드 생성기·검증 |

### 5.1 tokens.json 카탈로그 형식 (lint·문서 입력)

```json
{
  "color": {
    "brand": { "500": { "$value": "oklch(0.45 0.12 250)", "$desc": "주조색 네이비" } },
    "gray":  { "900": { "$value": "oklch(0.18 0.01 250)" }, "50": { "$value": "oklch(0.98 0 0)" } }
  },
  "text": {
    "body": { "$value": "{color.gray.900}", "$desc": "본문 글자색" }
  },
  "focus": {
    "ring": { "color": { "$value": "{color.brand.500}" }, "width": { "$value": "2px" }, "offset": { "$value": "2px" } }
  }
}
```

- `{color.gray.900}` 처럼 **중괄호 참조**가 semantic→reference 연결. lint는 이 참조가 실제 존재하는지(dangling), 뱅글뱅글 도는지(순환) 검사한다.
- `tokens.css`는 이 JSON에서 생성하거나, JSON 없이 직접 작성해도 된다(**tokens.css가 SSOT이므로**). JSON은 검증·문서용 보조.

> **원칙**: 둘이 어긋나면 **`tokens.css`가 항상 이긴다**(런타임 SSOT). JSON은 따라온다.

---

## 6. 차트 색 독립 네임스페이스 — `color.viz.*`

차트(그래프) 색을 본문 UI 색과 **같은 팔레트에서 꺼내 쓰면**, 브랜드색을 바꿀 때 차트 의미가 깨지거나(예: "증가=초록"이 갑자기 바뀜) 데이터 구분이 무너진다. 그래서 차트 색은 **완전히 분리된 네임스페이스**에 둔다.

| 토큰 | 용도 | 비개발자 설명 |
|------|------|---------------|
| `color.viz.sequential` (램프) | 순차 스케일(작음→큼) | "연함→진함으로 양을 표현" |
| `color.viz.diverging` (양끝+중앙) | 발산 스케일(음↔0↔양) | "마이너스↔플러스를 양쪽 색으로" |
| `color.viz.categorical.1`~`.8` | 범주(종류 구분) | "서로 다른 항목 8가지를 다른 색으로" |
| `color.viz.grid` | 격자선 | "차트 배경 눈금선(연한 회색)" |
| `color.viz.axis` | 축선·축라벨 | "가로·세로 축의 선과 글자" |
| `color.viz.annotation` | 강조 주석·기준선 | "여기를 보세요 표시" |

### 6.1 규칙
- `color.viz.categorical.1~8`은 **CVD(색각이상) 안전 8색 이내** — 실제 안전 색 값 선정과 이중인코딩(직접라벨+명도분리)은 `color-token-contract.md`/`chart-decision.md` 소관. 이 파일은 **네임스페이스·개수 상한(8)·분리 원칙**만 강제한다.
- 차트 토큰은 본문 semantic(`--accent` 등)을 **가리키지 않는다**. 독립이어야 의미가 안정적으로 유지된다.
- `color.viz.*`도 reference 계층에 둔다(차트용 reference). 차트 component 토큰은 보통 불필요(경량 모드 기본).

```css
:root {
  /* 차트 전용 — 본문 색과 독립 */
  --color-viz-categorical-1: oklch(0.55 0.15 250);
  --color-viz-categorical-2: oklch(0.65 0.13 50);
  /* ... 최대 8까지, CVD 안전 색은 color-token-contract.md 표에서 */
  --color-viz-grid:       oklch(0.92 0 0);
  --color-viz-axis:       oklch(0.45 0 0);
  --color-viz-annotation: oklch(0.55 0.18 25);
}
```

---

## 7. 다크 · 고대비 · 인쇄 모드 — reference 스왑 1회

모드 전환은 **reference 계층의 값만 바꾼다.** semantic/component는 reference를 가리키고만 있으므로 **자동으로 따라 바뀐다** — 화면 곳곳을 다시 칠할 필요가 없다(이것이 3계층의 가장 큰 실익).

```css
/* 기본(라이트) — reference */
:root {
  --color-gray-900: oklch(0.18 0.01 250);  /* 글자: 거의 검정 */
  --color-gray-50:  oklch(0.98 0 0);        /* 배경: 거의 흰색 */
}

/* 다크 — reference만 스왑(semantic은 그대로 var(--color-gray-900) 참조) */
@media (prefers-color-scheme: dark) {
  :root {
    --color-gray-900: oklch(0.96 0.01 250);  /* 다크에선 글자가 밝게 */
    --color-gray-50:  oklch(0.20 0.01 250);  /* 배경이 어둡게 */
  }
}

/* 고대비 — 대비 끌어올린 reference */
@media (prefers-contrast: more) {
  :root {
    --color-gray-900: oklch(0.08 0 0);
    --color-gray-50:  oklch(1 0 0);
    --border-default: var(--color-gray-900); /* 테두리 진하게 */
  }
}

/* 인쇄 — 잉크 절약·흑백 대비 안전 reference */
@media print {
  :root {
    --color-gray-50:  #fff;   /* 인쇄는 흰 배경 강제 */
    --bg-page:        #fff;
    --color-brand-500: #1a2b3c; /* 흑백 출력에서도 대비 확보 */
  }
}
```

> 다크 모드용 램프 파생(라이트의 단순 반전이 아닌 별도 L/C 조정)의 **상세 규칙은 `color-token-contract.md`**. 이 파일은 "**모드 차이는 reference 스왑 1회로 끝낸다**"는 구조 계약만 강제한다.

---

## 8. 토큰 lint 스크립트 (인라인 · 실제 코드)

산출 직전 무결성 게이트(SKILL.md §7 / spec §7)의 **토큰 검증 부분**. 4가지를 전수 검사한다:

- **dangling(끊긴 참조)**: `var(--x)`인데 `--x`가 정의 안 됨.
- **순환(circular)**: A→B→A 처럼 뱅글뱅글 도는 참조.
- **고아(orphan)**: 정의됐는데 아무도 안 쓰는 토큰(a11y 1급 토큰은 면제).
- **하드코딩(hardcoded)**: semantic/component 영역에서 `var()` 대신 날 hex/px를 직접 박음(a11y 1급 7키는 설계상 raw px/ms를 담으므로 면제 — `_contract.md` §6).
- **R5 — a11y 1급 토큰 누락**: 4종 7키가 하나라도 없으면 BLOCK.

검사 결과 등급: **BLOCK**(dangling·순환·a11y누락·하드코딩) → 출고 금지. **WARN**(고아·layer-skip) → 알림만.

`tokens.css` 1개를 입력으로 Node 없이도 동작하는 순수 JS(브라우저/Node 공용). dev-only로 검증 시점에만 사용, **사용자 폴더 미포함**.

```js
// token-lint.js — tokens.css 한 파일을 받아 무결성 전수 검사 (dev-only, ~50줄)
// 사용: node token-lint.js tokens.css   또는 브라우저에서 lintTokens(cssText)
function lintTokens(css) {
  const def = {};                                   // 토큰명 -> 원시 값(문자열)
  const re = /(--[\w-]+)\s*:\s*([^;]+);/g;           // CSS 변수 정의 추출
  let m; while ((m = re.exec(css))) def[m[1]] = m[2].trim();

  const A11Y = ['--focus-ring-color','--focus-ring-width','--focus-ring-offset',
                '--motion-duration-fast','--motion-duration-base','--motion-reduce','--target-size-min'];
  const refs = v => [...v.matchAll(/var\(\s*(--[\w-]+)/g)].map(x => x[1]); // 값이 가리키는 토큰들
  const isRef = n => /^--color-|^--space-|^--font-|^--line-|^--radius-|^--shadow-|^--duration-/.test(n); // reference 계층 판별
  const used = new Set(), block = [], warn = [];

  for (const [name, val] of Object.entries(def)) {
    const isHard = !val.includes('var(') &&
      (/#[0-9a-fA-F]{3,8}\b/.test(val) || /\b\d+(\.\d+)?px\b/.test(val)); // 날 hex/px
    // 하드코딩: reference 계층은 날값 허용, semantic/component(=비-reference)는 금지.
    // a11y 1급 7키(--focus-ring-width:2px 등)는 설계상 raw px/ms/플래그를 담으므로 면제(_contract.md §5·§6).
    if (isHard && !isRef(name) && !A11Y.includes(name)) block.push(`HARDCODE  ${name}: ${val}  (var()로 참조하세요)`);
    for (const r of refs(val)) {                    // dangling 검사 + 사용 기록
      used.add(r);
      if (!(r in def)) block.push(`DANGLING  ${name} -> ${r} (정의 없음)`);
    }
  }
  // 순환 검사: 각 토큰에서 참조를 따라가다 자기 자신을 다시 만나면 순환
  const seen = (start, n, path) => {
    for (const r of refs(def[n] || '')) {
      if (r === start) { block.push(`CIRCULAR  ${path.join(' -> ')} -> ${r}`); return; }
      if (def[r] && !path.includes(r)) seen(start, r, [...path, r]);
    }
  };
  for (const n of Object.keys(def)) seen(n, n, [n]);

  // 고아 검사: 정의됐으나 아무도 안 씀(a11y 1급·:root 직접소비 대상은 면제)
  for (const n of Object.keys(def)) if (!used.has(n) && !A11Y.includes(n)) warn.push(`ORPHAN    ${n} (아무도 참조 안 함)`);
  // R5: a11y 1급 토큰 누락
  for (const a of A11Y) if (!(a in def)) block.push(`A11Y-MISS ${a} (경량 모드도 필수)`);

  return { ok: block.length === 0, block, warn };
}
if (typeof module !== 'undefined') module.exports = { lintTokens };
if (typeof process !== 'undefined' && process.argv[2]) {
  const r = lintTokens(require('fs').readFileSync(process.argv[2], 'utf8'));
  r.block.forEach(x => console.error('BLOCK ' + x));
  r.warn.forEach(x => console.warn('WARN  ' + x));
  console.log(r.ok ? 'PASS (BLOCK 0건)' : `FAIL (BLOCK ${r.block.length}건)`);
  process.exit(r.ok ? 0 : 1);
}
```

> **무결성 게이트 연결**: 이 lint는 `design-redteam-pro`가 단일 "디자인 시스템 무결성 리포트"로 통합하는 3검증(토큰lint / APCA·WCAG / axe·CVD) 중 **토큰lint** 담당. BLOCK 1건이라도 있으면 **교체 후 재산출, skip 불가**(spec §7). 나머지 2검증은 이웃 reference 소관.

---

## 9. tokens.css 실제 예시 골격 (사용자 폴더에 들어가는 그대로)

> 이 골격을 시안 확정값으로 채우면 곧 런타임 SSOT가 된다. **순수 CSS 변수, 빌드 의존 0, 더블클릭 동작.** 색 값은 OKLCH 1차 + `@supports not` hex 폴백(구형 브라우저·Confluence 임베드 대비) — 폴백 패턴 상세는 `color-token-contract.md`.

```css
/* ============================================================
   tokens.css — 디자인 토큰 단일 진실원천 (런타임 SSOT)
   ▶ 색·글씨를 바꾸려면 아래 "1. reference" 값만 고치세요.
     2·3번(semantic/component)은 자동으로 따라 바뀝니다.
   ============================================================ */
:root {
  /* ── 1. reference (원자재 팔레트 — 여기만 고치면 전체가 바뀝니다) ── */
  --color-brand-500: oklch(0.45 0.12 250);  /* 주조색: 네이비 */
  --color-brand-700: oklch(0.35 0.13 250);
  --color-gray-900:  oklch(0.18 0.01 250);  /* 본문 글자 */
  --color-gray-600:  oklch(0.50 0.01 250);
  --color-gray-200:  oklch(0.90 0.005 250);
  --color-gray-50:   oklch(0.98 0 0);
  --color-white:     oklch(1 0 0);
  --color-red-500:   oklch(0.55 0.20 25);   /* 위험 */
  --color-green-500: oklch(0.60 0.14 150);  /* 성공 */
  --space-2: 8px;  --space-4: 16px;  --space-6: 24px;
  --font-body:    "Pretendard", system-ui, sans-serif; /* 한글 폴백: build-boilerplate.md */
  --font-heading: "Pretendard", system-ui, sans-serif;
  --line-height-base: 1.6;            /* 한국어 가독 하한선 */
  --radius-md: 8px;

  /* ── 2. semantic (역할 — reference를 가리킴, 직접 값 금지) ── */
  --bg-page:        var(--color-white);
  --bg-surface:     var(--color-gray-50);
  --text-body:      var(--color-gray-900);
  --text-muted:     var(--color-gray-600);
  --text-on-brand:  var(--color-white);
  --border-default: var(--color-gray-200);
  --accent:         var(--color-brand-500);     /* 60-30-10의 10 */
  --bg-danger:      var(--color-red-500);
  --bg-success:     var(--color-green-500);

  /* ── 2b. a11y 1급 semantic (경량 모드에서도 필수 — 빼면 lint BLOCK) ── */
  --focus-ring-color:     var(--color-brand-500);
  --focus-ring-width:     2px;
  --focus-ring-offset:    2px;
  --motion-duration-fast: 120ms;
  --motion-duration-base: 200ms;
  --motion-reduce:        1;
  --target-size-min:      24px;

  /* ── 2c. 차트 전용 (독립 네임스페이스 — 본문 색과 분리) ── */
  --color-viz-categorical-1: oklch(0.55 0.15 250);
  --color-viz-categorical-2: oklch(0.65 0.13 50);
  --color-viz-grid:          oklch(0.92 0 0);
  --color-viz-axis:          oklch(0.45 0 0);
  --color-viz-annotation:    oklch(0.55 0.18 25);

  /* ── 3. component (옵션 — semantic만 가리킴. 경량 모드는 생략) ── */
  --button-primary-bg: var(--accent);
  --button-primary-fg: var(--text-on-brand);
}

/* 모드 전환은 reference 스왑 1회 (semantic/component 불변) */
@media (prefers-color-scheme: dark) {
  :root {
    --color-gray-900: oklch(0.96 0.01 250);
    --color-gray-50:  oklch(0.20 0.01 250);
    --color-white:    oklch(0.16 0.01 250);
  }
}
@media (prefers-reduced-motion: reduce) { :root { --motion-reduce: 0; } }
@media (prefers-contrast: more) { :root { --color-gray-900: oklch(0.08 0 0); --border-default: var(--color-gray-900); } }
@media print { :root { --bg-page: #fff; --color-gray-50: #fff; } }
```

---

## 10. 실행 체크리스트 (design-lead-pro가 토큰 정규화 단계에서 그대로 적용)

- [ ] reference + semantic **2계층 모두 존재**(BLOCK). component는 필요할 때만.
- [ ] semantic·component는 **`var()`로만** reference/상위를 가리킴. 날 hex/px 직접값 0건.
- [ ] 참조 방향 **단방향**(component→semantic→reference). 역방향·순환 0건.
- [ ] **a11y 1급 4종 7키** 모두 존재(`--focus-ring-{color,width,offset}` / `--motion-duration-{fast,base}` / `--motion-reduce` / `--target-size-min`). 경량 모드여도 필수.
- [ ] 차트 색은 `color.viz.*` **독립 네임스페이스**, categorical **8색 이내**, 본문 semantic 미참조.
- [ ] **`tokens.css` = 런타임 SSOT**(사용자 폴더 포함). `tokens.json`은 카탈로그용(미포함).
- [ ] 다크/고대비/인쇄는 **reference 스왑 1회**로 처리, semantic/component 불변.
- [ ] 산출 직전 **`token-lint.js` 전수 통과**(BLOCK 0건). 위반 시 교체 후 재산출, skip 불가.
- [ ] 색 값 자체(OKLCH 파생·대비 합격)는 `color-token-contract.md` 규칙 준수했는지 교차 확인.

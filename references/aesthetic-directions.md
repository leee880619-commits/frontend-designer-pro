# aesthetic-directions.md — 미적 방향 갤러리 (자기완결 원천)

> **이 파일의 역할**: 질문 게이트 2단계(미적 방향 선택)에서 사용자에게 보여줄 "그림 갤러리"의 원천이다.
> 런타임 에이전트(design-lead-pro)는 이 파일만 읽고 ①사용자에게 보여줄 썸네일 SVG/스냅샷 마크업 ②art brief에 박을 무드·폰트·색·레이아웃 ③도메인 기본 추천을 그대로 꺼내 쓴다.
> **외부 스킬(frontend-design / frontend-designer / color-expert) 미설치에도 이 파일 한 장으로 완결**된다 — 폰트페어·OKLCH 색 앵커·레이아웃 규칙·SVG 코드가 전부 인라인으로 들어 있다.
>
> **비개발자 노출 규칙**(SSOT §2 non_dev_rules): 사용자에게는 **그림 + 느낌 단어 + '이럴 때 추천' 1문장**만 보인다.
> OKLCH·폰트페어·토큰명은 **질문 본문에 절대 노출 금지** — 백스테이지(art brief)에서만 쓴다.

---

## 0. 갤러리 사용법 (런타임 에이전트용)

### 0.1 질문 게이트에서 쓰는 법
SSOT §1-1, §2 예시질문 2번을 따른다. 미적 방향은 **3개로 좁혀** 객관식+★추천으로 제시한다.

1. **도메인 → 후보 3개 결정**: §9 매핑 표에서 도메인별 ★기본 + 인접 2개를 뽑는다. (예: 분석보고서 → ★editorial / soft-modern / technical)
2. **각 후보를 카드로 렌더**: 아래 각 방향의 `미리보기 마크업`을 그대로 써서 썸네일을 보여준다. 카드에 노출하는 텍스트는 **①한 줄 일상어 설명 ②무드 키워드 3개 ③'이럴 때 추천' 1문장**뿐.
3. **★추천 디폴트 1개 선택 상태**로 제시 + "나중에 바꿀 수 있어요" 명시.
4. **사용자에게 숨기는 것**(art brief로만 전달): 폰트페어 구체명, 핵심 색 OKLCH 앵커, 레이아웃 컨셉의 기술명.

### 0.2 art brief에 박는 법
사용자가 방향을 고르면, 그 방향의 **무드 키워드 3개 / 폰트페어 / 핵심 색 성격 / 레이아웃 컨셉**을 art-brief-template.md의 해당 슬롯에 그대로 옮긴다. 색은 `핵심 색 앵커(OKLCH)` 값을 color-token-contract.md의 reference 앵커 입력으로 넘긴다.

### 0.3 무결성 게이트와의 관계 (중요)
미적 방향이 아무리 대담해도 **텍스트·UI·의미색은 APCA AND WCAG 이중 게이트의 성역**이다(SSOT §0-2). 각 카드의 `핵심 색 앵커`는 **장식 면(no-text AND no-meaning)의 무드 채도**를 정의할 뿐, 본문 글자색이 아니다. 본문은 항상 색 게이트를 통과한 값으로 강등한다. 즉 **"brutalist라서 노랑 위 흰 글씨"는 게이트에서 BLOCK** → 자동 보정 대상. (대비 규칙은 color-token-contract.md / a11y-checklist.md가 최종 권한.)

### 0.4 폰트 자기완결 폴백
모든 폰트페어는 **한글 = Pretendard 계열**을 1순위로 둔다. Pretendard 서브셋 woff2 동봉이 원칙이나, 서브셋 도구 부재·CDN 차단 시 `system-ui` 폴백으로 자동 강등한다(SSOT §9-3). 폴백 시 폰트페어의 개성은 일부 손실되지만 **한글이 깨지지 않는 것이 우선**. `word-break: keep-all` + `line-height: 1.6+`는 모든 방향 공통 하한선.

---

## 1. editorial (에디토리얼 = 잡지 레이아웃 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 잘 만든 잡지·신문 기사처럼, 큰 제목과 단정한 본문이 또렷한 위계로 흐르는 느낌 (글이 읽기 좋게 정돈됨) |
| **무드 키워드 3개** | 정제된 · 신뢰감 · 읽기 좋은 |
| **대표 폰트페어** | 본문/한글: **Pretendard** · 제목 영문: **"Fraunces"**(세리프, 묵직한 잡지 헤드라인) — 한영 혼용 시 한글은 Pretendard Variable, 큰 제목 라틴 단어만 Fraunces. 폴백: 제목 `Pretendard, "Noto Serif KR", serif` / 본문 `Pretendard, system-ui, sans-serif` |
| **핵심 색 성격 1개** | 차분한 잉크(거의 검정에 가까운 짙은 남회색) 본문 + 따뜻한 종이 배경. 액센트는 절제된 1색. |
| **핵심 색 앵커(OKLCH, 장식면용)** | ink `oklch(0.22 0.02 250)` · paper `oklch(0.98 0.008 85)` · accent(절제) `oklch(0.50 0.13 25)`(벽돌/적포도) |
| **레이아웃 컨셉** | 비대칭 다단 그리드. 굵은 헤드라인 + 부제(데크) + 본문 칼럼. 넉넉한 행간, 명확한 3단 위계(제목→리드→본문). 좌우 여백 비대칭으로 "사람이 짠 지면" 느낌. |
| **이럴 때 추천** | 동료들이 받아 **차분히 읽는** 분석 보고서·긴 글·문서 — 결론과 근거가 위계로 또렷이 구분돼 신뢰감 있게 읽힌다. |
| **안 어울리는 경우** | 빔프로젝터 발표(뒷자리 가독 약함, editorial-bold가 적합) · 강한 임팩트가 필요한 마케팅 히어로 · 클릭/입력 중심 인터랙티브 앱. |

**미리보기 마크업** (인라인 SVG 썸네일 — 그대로 카드에 삽입):
```html
<svg viewBox="0 0 300 200" role="img" aria-label="에디토리얼 미리보기: 큰 잡지 제목과 정돈된 2단 본문"
     xmlns="http://www.w3.org/2000/svg" style="border:1px solid #e5e0d8;border-radius:6px;background:#faf7f0">
  <text x="20" y="44" font-family="Georgia, 'Noto Serif KR', serif" font-size="30" font-weight="700" fill="#262433">Headline</text>
  <rect x="20" y="58" width="180" height="6" rx="3" fill="#8a8478"/>
  <!-- 비대칭 2단 본문 -->
  <g fill="#4a4740">
    <rect x="20" y="84" width="120" height="5" rx="2.5"/><rect x="20" y="96" width="120" height="5" rx="2.5"/>
    <rect x="20" y="108" width="120" height="5" rx="2.5"/><rect x="20" y="120" width="98" height="5" rx="2.5"/>
    <rect x="160" y="84" width="120" height="5" rx="2.5"/><rect x="160" y="96" width="120" height="5" rx="2.5"/>
    <rect x="160" y="108" width="96" height="5" rx="2.5"/>
  </g>
  <rect x="20" y="150" width="44" height="14" rx="2" fill="#7a3322"/>
  <text x="42" y="160" font-family="system-ui" font-size="9" fill="#fff" text-anchor="middle">accent</text>
</svg>
```

---

## 2. luxury (럭셔리 = 여백 많고 절제된 고급 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 명품 브랜드 안내서처럼, 넓은 빈 공간과 가는 글씨로 "고급스럽고 믿을 만하다"는 인상을 주는 느낌 (절제된 우아함) |
| **무드 키워드 3개** | 절제된 · 신뢰감 · 품격 있는 |
| **대표 폰트페어** | 본문/한글: **Pretendard**(Light~Regular 위주) · 제목 영문: **"Cormorant Garamond"**(가늘고 우아한 세리프) 또는 **"Libre Caslon"** — 큰 여백 + 가는 굵기 대비. 폴백: 제목 `Pretendard, "Nanum Myeongjo", serif` / 본문 `Pretendard, system-ui, sans-serif` |
| **핵심 색 성격 1개** | 보수적 중성(짙은 남색·차콜) 베이스 + 절제된 메탈릭/딥 액센트 1색(딥네이비 or 와인 or 절제된 골드). 화면당 액센트 1~2개(60-30-10 엄수). |
| **핵심 색 앵커(OKLCH, 장식면용)** | base ink `oklch(0.25 0.03 265)`(차콜 네이비) · canvas `oklch(0.99 0.003 270)` · accent `oklch(0.45 0.07 265)`(딥 네이비) 또는 `oklch(0.55 0.09 75)`(절제된 골드, 장식 한정) |
| **레이아웃 컨셉** | 극단적 여백(여백이 콘텐츠를 "받쳐주는" 구조). 중앙 또는 좌측 정렬 단일 칼럼. 가는 구분선, 작은 캡션, 큰 여백 사이의 핵심 1문장. 스크롤 없는 1페이지 응축. |
| **이럴 때 추천** | 결정을 내리는 **윗분(C레벨·이사회)** 보고서 — 화려함 대신 "믿을 만하다"는 인상과 핵심만 또렷한 구조가 신뢰를 만든다. |
| **안 어울리는 경우** | 정보 밀도 높은 대시보드·데이터 표(여백이 정보를 밀어냄) · 발랄한 마케팅 · 색·밀도가 많이 필요한 차트 페이지. |

**미리보기 마크업**:
```html
<svg viewBox="0 0 300 200" role="img" aria-label="럭셔리 미리보기: 넓은 여백 가운데 가는 제목 한 줄"
     xmlns="http://www.w3.org/2000/svg" style="border:1px solid #e8e8ee;border-radius:6px;background:#fdfdff">
  <line x1="40" y1="48" x2="120" y2="48" stroke="#9aa0b4" stroke-width="1"/>
  <text x="40" y="90" font-family="Garamond, 'Nanum Myeongjo', serif" font-size="26" letter-spacing="2" fill="#26304a">Exclusive</text>
  <text x="40" y="112" font-family="system-ui" font-size="9" letter-spacing="3" fill="#6a7488">CONFIDENTIAL · 2026</text>
  <line x1="40" y1="150" x2="260" y2="150" stroke="#e2e4ec" stroke-width="1"/>
  <text x="40" y="170" font-family="system-ui" font-size="8" fill="#8a90a4">한 장에 핵심만 — 넓은 여백이 신뢰를 받칩니다</text>
</svg>
```

---

## 3. minimal (미니멀 = 깔끔하고 군더더기 없는 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 잘 정리된 노트 앱처럼, 색과 장식을 최소로 줄여 내용 자체가 또렷이 보이는 느낌 (군더더기 0) |
| **무드 키워드 3개** | 깔끔한 · 또렷한 · 집중되는 |
| **대표 폰트페어** | 전체: **Pretendard** 단일 패밀리(굵기 대비로 위계). 영문 동반 시 **"Inter"는 anti-slop 위반 위험**이라 지양 — 대신 **"Geist"** 또는 Pretendard 라틴 글리프 그대로. 폴백: `Pretendard, system-ui, sans-serif` |
| **핵심 색 성격 1개** | 거의 무채색(흰/연회색/짙은 회색) + 단일 액센트 1색(브랜드색 1개만 점처럼). |
| **핵심 색 앵커(OKLCH, 장식면용)** | ink `oklch(0.20 0.005 250)` · surface `oklch(0.99 0 0)` · line `oklch(0.92 0.004 250)` · accent `oklch(0.55 0.16 250)`(단일 포인트) |
| **레이아웃 컨셉** | 8px 그리드 정렬, 충분한 여백, 가는 구분선, 카드보다 "공간으로 나누기". 위계는 색이 아니라 크기·굵기·간격으로만. |
| **이럴 때 추천** | 정보가 또렷이 보여야 하는 **간단한 웹앱·설정 화면·문서** — 장식이 없어 내용에 바로 집중되고 어떤 화면에도 무난히 어울린다. |
| **안 어울리는 경우** | "특별한 인상"이 필요한 발표 표지·브랜드 히어로(밋밋하게 보임) · 강한 개성을 원하는 마케팅. minimal은 **개성보다 명료함**이 무기. |

**미리보기 마크업**:
```html
<svg viewBox="0 0 300 200" role="img" aria-label="미니멀 미리보기: 흰 배경에 단정한 제목과 가는 구분선"
     xmlns="http://www.w3.org/2000/svg" style="border:1px solid #ececec;border-radius:6px;background:#ffffff">
  <text x="24" y="46" font-family="system-ui" font-size="20" font-weight="600" fill="#1c1c1f">Settings</text>
  <line x1="24" y1="60" x2="276" y2="60" stroke="#ededed" stroke-width="1"/>
  <g font-family="system-ui" font-size="11" fill="#3a3a3f">
    <text x="24" y="86">알림</text><circle cx="262" cy="82" r="6" fill="#3a6ff0"/>
    <line x1="24" y1="100" x2="276" y2="100" stroke="#f2f2f2"/>
    <text x="24" y="124">언어</text><text x="276" y="124" text-anchor="end" fill="#9a9aa0">한국어</text>
    <line x1="24" y1="138" x2="276" y2="138" stroke="#f2f2f2"/>
    <text x="24" y="162">테마</text><text x="276" y="162" text-anchor="end" fill="#9a9aa0">자동</text>
  </g>
</svg>
```

---

## 4. brutalist (브루탈리즘 = 거칠고 강한 인쇄물 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 거친 포스터·언더그라운드 잡지처럼, 굵은 검정 테두리와 큰 글씨로 강하게 밀어붙이는 느낌 (개성·임팩트 강함) |
| **무드 키워드 3개** | 대담한 · 솔직한 · 강렬한 |
| **대표 폰트페어** | 제목: **"Archivo" / "Space Grotesk"**(굵은 그로테스크) · 본문/한글: **Pretendard**(Bold 활용). 폴백: 제목 `Pretendard, "Black Han Sans", sans-serif` / 본문 `Pretendard, system-ui` |
| **핵심 색 성격 1개** | 고채도 원색 1~2개(전자 노랑·빨강·파랑) on 흑/백, 굵은 검정 테두리. **단, 본문 글자는 게이트 통과색으로 강등 필수**(고채도 위 텍스트 금지). |
| **핵심 색 앵커(OKLCH, 장식면용)** | base `oklch(0 0 0)`/`oklch(1 0 0)` · accent1 `oklch(0.85 0.20 95)`(전자 노랑, **장식면 한정**) · accent2 `oklch(0.55 0.24 25)`(강한 빨강) — 텍스트는 항상 `oklch(0.15 0 0)` on 밝은 면으로 강등 |
| **레이아웃 컨셉** | 굵은 1~3px 검정 보더 블록, 격자 깨기, 큰 타이포 + 의도적 비정렬. 그림자 없음(플랫·하드 엣지). 의도된 "날것" 느낌. |
| **이럴 때 추천** | 시선을 강하게 끌어야 하는 **이벤트·캠페인 랜딩·개성 있는 브랜드 페이지** — 정형화된 깔끔함을 깨서 "AI가 찍어낸 티"의 반대 인상을 준다. |
| **안 어울리는 경우** | 임원 보고서(경박해 보임) · 데이터 정직성이 중요한 분석 보고서 · 장시간 읽는 긴 문서(피로). **격식·신뢰가 1순위인 곳엔 금지.** |

**미리보기 마크업**:
```html
<svg viewBox="0 0 300 200" role="img" aria-label="브루탈리즘 미리보기: 굵은 검정 테두리 블록과 강한 노랑 면"
     xmlns="http://www.w3.org/2000/svg" style="border:2px solid #000;border-radius:0;background:#fff">
  <rect x="14" y="16" width="180" height="44" fill="#000"/>
  <text x="24" y="48" font-family="'Arial Black', system-ui" font-size="26" font-weight="900" fill="#fff">BOLD!</text>
  <rect x="14" y="74" width="120" height="80" fill="#ffd400" stroke="#000" stroke-width="3"/>
  <text x="24" y="118" font-family="system-ui" font-size="13" font-weight="800" fill="#111">강하게</text>
  <rect x="146" y="74" width="140" height="38" fill="#fff" stroke="#000" stroke-width="3"/>
  <rect x="146" y="118" width="140" height="36" fill="#e8392a" stroke="#000" stroke-width="3"/>
  <text x="216" y="142" font-family="system-ui" font-size="12" font-weight="800" fill="#fff" text-anchor="middle">IMPACT</text>
</svg>
```

---

## 5. soft-modern (소프트 모던 = 부드럽고 친근한 요즘 앱 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 요즘 인기 있는 모바일 앱처럼, 둥근 모서리와 부드러운 색·은은한 그림자로 친근하고 다루기 편한 느낌 (편안·신뢰) |
| **무드 키워드 3개** | 친근한 · 부드러운 · 편안한 |
| **대표 폰트페어** | 전체: **Pretendard**(Regular~SemiBold). 영문 동반 시 **"Plus Jakarta Sans"** 또는 Pretendard 라틴. 폴백: `Pretendard, system-ui, -apple-system, sans-serif` |
| **핵심 색 성격 1개** | 채도 낮춘 파스텔/세미-뮤트 브랜드색 + 밝은 회백 배경 + 부드러운 1px 그림자. 60-30-10으로 액센트 절제. |
| **핵심 색 앵커(OKLCH, 장식면용)** | brand `oklch(0.62 0.13 250)`(부드러운 블루) · surface `oklch(0.985 0.004 250)` · raised `oklch(1 0 0)` · ink `oklch(0.28 0.02 250)` |
| **레이아웃 컨셉** | 둥근 카드(반경 10~16px), 은은한 그림자(blur 8~16, 불투명도 낮게), 넉넉한 패딩, 친근한 마이크로 인터랙션(≤250ms, reduced-motion 폴백). 카드 기반 정보 그룹. |
| **이럴 때 추천** | 사람들이 클릭·입력하며 **실제로 쓰는 웹앱**(대시보드·폼·설정) — 둥근 카드와 부드러운 색이 "다루기 쉽다"는 안심을 줘 사용성이 올라간다. |
| **안 어울리는 경우** | 극도의 격식이 필요한 이사회 보고(가벼워 보임) · 거친 임팩트가 목표인 캠페인 · 흑백 인쇄 전제 문서(그림자·파스텔이 인쇄에서 사라짐). |

**미리보기 마크업**:
```html
<svg viewBox="0 0 300 200" role="img" aria-label="소프트 모던 미리보기: 둥근 카드와 부드러운 그림자, 파란 버튼"
     xmlns="http://www.w3.org/2000/svg" style="border:1px solid #eef0f5;border-radius:8px;background:#f7f8fb">
  <defs><filter id="sm-shadow" x="-20%" y="-20%" width="140%" height="160%">
    <feDropShadow dx="0" dy="3" stdDeviation="4" flood-color="#1b2a5e" flood-opacity="0.12"/></filter></defs>
  <rect x="20" y="26" width="160" height="62" rx="14" fill="#fff" filter="url(#sm-shadow)"/>
  <text x="34" y="52" font-family="system-ui" font-size="11" fill="#8089a0">오늘의 작업</text>
  <text x="34" y="74" font-family="system-ui" font-size="22" font-weight="700" fill="#2a3350">12건</text>
  <rect x="196" y="26" width="84" height="62" rx="14" fill="#5b7cf0" filter="url(#sm-shadow)"/>
  <text x="238" y="62" font-family="system-ui" font-size="12" font-weight="600" fill="#fff" text-anchor="middle">+ 추가</text>
  <rect x="20" y="104" width="260" height="40" rx="12" fill="#fff" filter="url(#sm-shadow)"/>
  <circle cx="42" cy="124" r="9" fill="#e3e9fb"/><rect x="60" y="120" width="120" height="7" rx="3.5" fill="#cbd2e2"/>
  <rect x="244" y="118" width="22" height="12" rx="6" fill="#5b7cf0"/>
</svg>
```

---

## 6. technical (테크니컬 = 데이터 대시보드·개발 도구 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 개발자 도구·관제 대시보드처럼, 촘촘한 정보와 단위·숫자를 정확하게 보여주는 빈틈없는 느낌 (정밀·정보 밀도) |
| **무드 키워드 3개** | 정밀한 · 신뢰 가능한 · 정보 밀도 높은 |
| **대표 폰트페어** | 본문/한글: **Pretendard** · 숫자·코드·표: **"JetBrains Mono"**(고정폭, 숫자 정렬) · 라벨 영문: **"IBM Plex Sans"**. 폴백: 본문 `Pretendard, system-ui` / 숫자 `"D2Coding", ui-monospace, monospace` |
| **핵심 색 성격 1개** | 중성 회색 그리드 + 의미색 스케일(상태: 성공/경고/위험을 색으로 인코딩, **CVD 안전 + 색 외 라벨 이중인코딩 필수**). 다크모드 친화. |
| **핵심 색 앵커(OKLCH, 장식면용)** | surface `oklch(0.21 0.01 255)`(다크) / `oklch(0.985 0.003 255)`(라이트) · grid `oklch(0.40 0.01 255)` · ok `oklch(0.62 0.14 150)` · warn `oklch(0.72 0.15 75)` · danger `oklch(0.58 0.18 25)` |
| **레이아웃 컨셉** | 조밀한 그리드, 고정폭 숫자 정렬, 작은 라벨·범례, 표·차트·지표 카드. 데이터잉크 최대화(장식 최소). 좌측 네비 + 콘텐츠 영역. |
| **이럴 때 추천** | 지표·로그·상태를 **한눈에 모니터링**하는 대시보드형 웹앱이나 데이터 많은 분석 화면 — 고정폭 숫자와 의미색이 값을 정확·빠르게 읽게 한다. |
| **안 어울리는 경우** | 감성·설득이 필요한 마케팅·브랜드 페이지(차갑게 느껴짐) · 정보가 적은 단순 안내 페이지(과한 밀도) · 격식 있는 1페이지 임원 요약. |

**미리보기 마크업**:
```html
<svg viewBox="0 0 300 200" role="img" aria-label="테크니컬 미리보기: 다크 대시보드의 지표 카드와 미니 막대 차트"
     xmlns="http://www.w3.org/2000/svg" style="border:1px solid #2a2f3a;border-radius:6px;background:#161a22">
  <rect x="0" y="0" width="56" height="200" fill="#1d2230"/>
  <circle cx="28" cy="26" r="5" fill="#4ec9a0"/><rect x="16" y="46" width="24" height="5" rx="2" fill="#3a4150"/>
  <rect x="16" y="60" width="24" height="5" rx="2" fill="#3a4150"/>
  <!-- 지표 -->
  <text x="74" y="40" font-family="ui-monospace, monospace" font-size="22" font-weight="700" fill="#e6e9f0">98.6%</text>
  <text x="74" y="56" font-family="system-ui" font-size="9" fill="#8a93a6">가동률</text>
  <text x="180" y="40" font-family="ui-monospace, monospace" font-size="22" font-weight="700" fill="#f0b34e">214ms</text>
  <text x="180" y="56" font-family="system-ui" font-size="9" fill="#8a93a6">응답</text>
  <!-- 미니 막대 -->
  <g fill="#4e8cf0">
    <rect x="74" y="120" width="14" height="44"/><rect x="94" y="104" width="14" height="60"/>
    <rect x="114" y="132" width="14" height="32"/><rect x="134" y="92" width="14" height="72"/>
    <rect x="154" y="116" width="14" height="48"/><rect x="174" y="100" width="14" height="64"/>
  </g>
  <line x1="74" y1="164" x2="276" y2="164" stroke="#3a4150" stroke-width="1"/>
</svg>
```

---

## 7. editorial-bold (에디토리얼 볼드 = 큰 발표 화면 느낌)

| 항목 | 내용 |
|------|------|
| **한 줄 일상어 설명** | 회의실 빔에 띄우는 발표 슬라이드처럼, 한 화면에 큰 메시지 하나를 시원하게 담아 뒷자리에서도 읽히는 느낌 (발표용 임팩트) |
| **무드 키워드 3개** | 또렷한 · 자신감 있는 · 한눈에 들어오는 |
| **대표 폰트페어** | 제목: **"Fraunces" 또는 "Archivo Expanded"**(큰 디스플레이) · 본문/한글: **Pretendard**(SemiBold~Bold, 빔 가독). 폴백: 제목 `Pretendard, "Gmarket Sans", sans-serif` / 본문 `Pretendard, system-ui` |
| **핵심 색 성격 1개** | 진한 배경 + 고대비 큰 타이포 1색 + 액센트 1색. **빔프로젝터 저대비 보정**으로 대비를 상향(밝은 회의실 대비 손실 가정). |
| **핵심 색 앵커(OKLCH, 장식면용)** | bg-dark `oklch(0.22 0.04 265)` · ink-on-dark `oklch(0.97 0.01 265)` · accent `oklch(0.70 0.17 45)`(따뜻한 오렌지/코랄, 시인성) — 빔 가정으로 본문 대비 **APCA Lc 상향 권고** |
| **레이아웃 컨셉** | 16:9 슬라이드, 슬라이드당 1주장 + 결론형 제목. 큰 여백 + 거대 숫자/한 문장. 표지·간지는 expression zone 자유, 데이터 슬라이드는 절제. 키보드 화살표 네비 전제. |
| **이럴 때 추천** | 회의실 화면에 띄우고 **말로 설명하는 발표 자료(PPT 덱)** — 큰 글씨 한 메시지가 뒷자리에서도 읽히고 한 장=한 주장이라 흐름이 명확하다. |
| **안 어울리는 경우** | 손에 들고 읽는 긴 보고서(밀도 부족) · 정보 빽빽한 대시보드 · 작은 화면 단독 열람용 문서. **빔/큰 화면 전제**가 아니면 과해 보임. |

**미리보기 마크업**:
```html
<svg viewBox="0 0 320 180" role="img" aria-label="에디토리얼 볼드 미리보기: 16:9 슬라이드에 큰 한 문장과 강조 숫자"
     xmlns="http://www.w3.org/2000/svg" style="border:1px solid #2a3050;border-radius:6px;background:#1c2440">
  <text x="28" y="48" font-family="system-ui" font-size="11" letter-spacing="2" fill="#8fa0d4">2026 성과 요약</text>
  <text x="28" y="92" font-family="Georgia, serif" font-size="34" font-weight="800" fill="#f4f6ff">매출 2배</text>
  <text x="28" y="120" font-family="system-ui" font-size="13" fill="#c2cbe8">한 장에 메시지 하나 — 뒷자리도 읽힙니다</text>
  <rect x="28" y="138" width="70" height="6" rx="3" fill="#ff8a4c"/>
  <text x="292" y="98" font-family="Georgia, serif" font-size="40" font-weight="800" fill="#ff8a4c" text-anchor="end">×2</text>
</svg>
```

---

## 8. 미니 HTML 스냅샷 (선택 — 더 사실적인 카드가 필요할 때)

SVG 썸네일로 부족하면, 아래처럼 **실제 HTML 미니 스냅샷**을 카드 iframe/링크로 쓸 수 있다(SSOT §3 file:// 제약 대비 **정적 링크 폴백 항상 병행**). 무빌드·인라인 스타일이라 더블클릭으로 열린다. 예시는 `soft-modern` 1개만 — 나머지는 위 §1~7의 핵심 색 앵커·폰트페어로 동일 패턴 복제.

```html
<!doctype html><html lang="ko"><meta charset="utf-8">
<title>soft-modern 스냅샷</title>
<style>
  :root{ --brand:#5b7cf0; --surface:#f7f8fb; --raised:#fff; --ink:#2a3350; --muted:#8089a0; }
  *{box-sizing:border-box} body{margin:0;font-family:Pretendard,system-ui,sans-serif;
    word-break:keep-all;line-height:1.6;background:var(--surface);color:var(--ink);padding:24px}
  .card{background:var(--raised);border-radius:14px;padding:18px 20px;
    box-shadow:0 3px 10px rgba(27,42,94,.10);margin-bottom:14px}
  .kpi{font-size:28px;font-weight:700} .label{font-size:12px;color:var(--muted)}
  .btn{background:var(--brand);color:#fff;border:0;border-radius:12px;
    padding:10px 16px;font:inherit;font-weight:600;cursor:pointer}
  @media (prefers-reduced-motion:no-preference){.btn{transition:transform .18s}}
  .btn:hover{transform:translateY(-1px)} .btn:focus-visible{outline:2px solid var(--brand);outline-offset:2px}
</style>
<div class="card"><div class="label">오늘의 작업</div><div class="kpi">12건</div></div>
<button class="btn">+ 새 작업 추가</button>
```
> 이 스냅샷은 **예시(임시) 데이터**다. 색·폰트는 `tokens.css` 한 곳(`:root`)에서만 바꾸면 전체가 바뀐다 — 비개발자 편집 가이드에 그대로 안내한다.

---

## 9. 도메인별 기본 추천 매핑 (런타임 분기 표)

> SSOT §4 도메인 매트릭스 + §6 매핑 지시에 정합. **★ = 도메인 자동 추정 시 디폴트 선택 상태**. 인접 후보 2개를 함께 제시해 사용자가 그림으로 고른다. "기타"는 확정 질문 전 산출 금지(Intent Gate).

| 도메인 (SSOT §4) | ★ 기본 방향 | 인접 후보 2개 | 왜 그 도메인에 맞는지 (효과 1문장) |
|------------------|-------------|----------------|--------------------------------------|
| **웹앱(프론트엔드)** §4.1 | ★ **soft-modern** | technical · minimal | 둥근 카드·부드러운 색이 "다루기 쉽다"는 안심을 줘, 클릭·입력하는 사람이 화면을 덜 무서워하고 더 잘 쓰게 한다. (데이터 밀도 높은 관제형이면 technical로 전환) |
| **공유용 분석 보고서** §4.2 | ★ **editorial** | soft-modern · technical | 잡지식 3단 위계(제목→리드→근거)가 "무슨 일이 일어났는지"를 차분히 읽게 해, 여러 동료가 결론과 데이터를 헷갈림 없이 따라온다. |
| **C레벨·이그제큐티브 보고서** §4.3 | ★ **luxury** | editorial · minimal | 넓은 여백과 절제된 중성색이 "화려함이 아니라 믿을 만함"을 전해, 결정을 내리는 윗분이 핵심만 또렷이 보고 신뢰한다. |
| **발표 PPT 덱(HTML)** §4.4 | ★ **editorial-bold** | luxury · brutalist | 큰 한 문장과 고대비가 빔 뒷자리까지 읽히고 한 장=한 주장이라, 말로 설명하는 발표의 흐름이 끊기지 않는다. (강한 캠페인 톤이면 brutalist 검토) |
| **기타** §4.5 | (없음) → **확정 질문 먼저** | 추정된 가장 가까운 도메인의 ★를 임시 제안 | 도메인이 확정돼야 위 매핑이 작동한다 — "이거 맞죠?" 1문항으로 도메인을 먼저 고정하고, 마케팅·설득이면 가독성 하한선 위에서 editorial-bold/brutalist의 임팩트를 상향 허용. |

### 9.1 분기 규칙 (에이전트 결정 로직)
1. 도메인 자동 추정(첨부 심층 검토) → 위 표에서 **★ + 인접 2개**를 후보로 확정.
2. 질문 게이트 2번에서 3개를 그림 카드로 제시(★ 선택 상태). 사용자가 ★를 넘기면 그대로 채택.
3. **데이터 정직성·격식이 충돌하면 격식 우선**: 임원 보고에서 사용자가 brutalist를 골라도, 무결성 게이트(anti-slop + APCA·WCAG)는 본문 대비·절제를 강제한다 — 미적 대담함은 장식 면에만, 텍스트·의미색은 성역(SSOT §0-2).
4. **빔/인쇄 환경 신호**가 잡히면(질문 4번 응답) editorial-bold·인쇄안전 토큰으로 대비 상향.
5. 선택 결과를 art-brief-template.md에 박고, 핵심 색 앵커를 color-token-contract.md reference 입력으로 넘긴다.

### 9.2 방향 간 안전 강등 표 (게이트 충돌 시)
| 사용자가 고른 방향 | 게이트 위반 위험 | 자동 강등(보정) |
|--------------------|------------------|------------------|
| brutalist / editorial-bold | 고채도 면 위 텍스트 대비 미달 | 텍스트는 게이트 통과 ink로 강등, 고채도는 **장식 면(no-text)** 으로만 유지 |
| luxury | 가는 폰트 + 저대비 본문 | 본문 굵기·대비 상향(APCA Lc≥75), 가는 폰트는 큰 제목에만 |
| technical | 의미색만으로 상태 구분 | 색 외 직접 라벨·아이콘 이중인코딩 추가(CVD 안전) |
| soft-modern | 그림자·파스텔이 흑백 인쇄에서 소실 | @media print에서 보더·고대비로 reference 스왑 |

---

## 10. 빠른 참조 요약 (cheat sheet)

| 방향 | 한 줄 | 무드 | ★ 도메인 |
|------|-------|------|----------|
| editorial | 잡지 레이아웃 | 정제·신뢰·읽기좋은 | 분석 보고서 |
| luxury | 여백 많은 고급 | 절제·신뢰·품격 | C레벨 보고서 |
| minimal | 군더더기 없음 | 깔끔·또렷·집중 | (웹앱/문서 무난) |
| brutalist | 거친 강한 인쇄물 | 대담·솔직·강렬 | 캠페인 랜딩 |
| soft-modern | 친근한 요즘 앱 | 친근·부드러움·편안 | 웹앱 |
| technical | 데이터 대시보드 | 정밀·신뢰·밀도 | 대시보드/데이터 화면 |
| editorial-bold | 큰 발표 화면 | 또렷·자신감·한눈 | 발표 PPT 덱 |

> **공통 하한선(모든 방향 불변)**: 한글 Pretendard 1순위 + system-ui 폴백 / `word-break: keep-all` / `line-height ≥1.6` / 본문 APCA Lc≥75 AND WCAG 4.5:1 / 60-30-10 액센트 절제 / reduced-motion 폴백 / 무빌드 더블클릭. 미적 자유는 **이 하한선 위에서만** 작동한다.

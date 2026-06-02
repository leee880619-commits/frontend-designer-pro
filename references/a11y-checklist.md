# a11y-checklist.md — 접근성 자기완결 지식 (a11y-ux-lead 렌즈)

> **이 파일의 정체**: frontend-designer-pro가 산출하는 모든 결과물(웹앱·보고서·발표덱)이
> "시각장애·저시력·색맹·키보드 전용 동료까지 또렷이 쓸 수 있는가"를 보장하는 **런타임 체크리스트 + 그대로 복붙할 코드**다.
> 외부 스킬(frontend-design / a11y 라이브러리) 미설치에도 동작하도록 필요한 지식·코드를 **이 파일 안에 전부** 담았다.
>
> **두 독자**:
> - **런타임 에이전트(design-lead-pro / design-redteam-pro)** → 표·결정규칙·코드 스니펫을 그대로 적용/감사.
> - **비개발자 사용자** → 표면에는 신호등 배지(초록/노랑/빨강) + 실생활 1줄 효익만 노출. 아래의 숫자·토큰·코드는 절대 사용자에게 보이지 않는 **백스테이지**.
>
> SSOT: `docs/02-skill-spec.md` §6(a11y-checklist 행) · §4(도메인 매트릭스) · §7(무결성 게이트) · §1·§2(질문게이트) · `docs/00-context.md` §4(1급 제약).

---

## 0. 한눈에 — 이 파일이 강제하는 것 (BLOCK 7종)

산출 직전 무결성 게이트(spec §7)에서 아래 7개 중 **하나라도 위반이면 BLOCK** → 자동 보정 후 재측정. skip 불가.

| # | BLOCK 항목 | 한 줄 판정 기준 | 자동 보정 |
|---|-----------|----------------|-----------|
| B1 | **이중 대비 게이트** | 텍스트·UI·의미색이 APCA **AND** WCAG 둘 다 통과 | 명도 한 단계 올림(토큰 reference 스왑) |
| B2 | **시맨틱 위계** | landmark 존재 + `h1`→`h6` 단일 위계(레벨 건너뜀 0) | 제목 레벨 재정렬, landmark 래핑 |
| B3 | **완전 키보드** | 모든 상호작용 요소가 Tab 도달 + `:focus-visible` 2px(대비 3:1) + skip link | 네이티브 요소로 교체, focus 토큰 주입 |
| B4 | **포커스 관리** | 동적 DOM 교체(모달·탭·SPA)에만 트랩+복귀+`aria-live` | 트랩/복귀 스니펫 주입 |
| B5 | **스크림 오버레이** | 풀블리드 이미지/글래스 위 텍스트는 스크림 깔고 **스크림 위에서 APCA 재측정** | 스크림 불투명도 상향 후 재측정 |
| B6 | **도메인 필수 대체본** | 차트=`table+caption+th scope` / 폼=라벨·`aria-describedby` / 슬라이드=`region`+노트 | 누락분 생성 |
| B7 | **장식 자유 경계** | `no-text AND no-meaning` 면만 무드 채도 자유, 그 외는 성역 | 텍스트/의미색 면을 게이트로 회수 |

> **장식의 자유 정의 (성역 vs 무드)**: 어떤 면이 **(1) 텍스트를 담지 않고(no-text) AND (2) 의미를 전달하지 않으면(no-meaning, 예: 상태/카테고리/경고를 색으로 말하지 않음)** 그 면은 art brief 무드 채도를 그대로 산다(대비 게이트 면제). 둘 중 하나라도 해당하면 성역 → 이중 대비 게이트 적용. AND 조건임에 주의 — "장식처럼 보이지만 의미를 가진 색"(예: 빨강 배경 = 위험)은 면제 대상이 아니다.

---

## 1. 이중 대비 게이트 — APCA AND WCAG (B1·B5)

### 1.1 왜 둘 다인가 (백스테이지 한 줄)
- **WCAG 2.x 대비비(4.5:1 등)**는 법적·관행 기준이라 깔지만, 밝은 회색 텍스트를 과대평가하는 약점이 있다.
- **APCA(Lc)**는 사람 눈의 실제 가독 인지를 더 잘 반영하지만 아직 비공식이다.
- 두 기준을 **AND(둘 다 통과)** 로 걸면 약점이 상쇄된다 → "법적으로도 통과하고 실제로도 또렷".

### 1.2 임계값 표 (그대로 측정)

| 텍스트/요소 역할 | APCA Lc | WCAG 비율 | 판정 |
|------------------|---------|-----------|------|
| **본문**(14~18px 일반 굵기) | **Lc ≥ 75** | **≥ 4.5:1** | 둘 다 충족해야 PASS |
| **보조 텍스트**(캡션·메타, 큰 글씨 아님) | **Lc ≥ 60** | ≥ 4.5:1 | 둘 다 |
| **대형 텍스트**(≥24px 또는 ≥18.66px bold) / **UI 컴포넌트**(버튼 테두리·아이콘·focus ring·차트 축선) | **Lc ≥ 45** | **≥ 3:1** | 둘 다 |
| **비활성(disabled)** | **Lc ≥ 30** | (권장) | 의도적 약화, 단 식별은 가능 |

> 측정 대상: **전경색 vs 실제 깔리는 배경색**. 배경이 그라데이션/이미지/글래스면 **가장 불리한 지점**에서 측정(§1.3).

### 1.3 스크림 오버레이 의무 (B5 — 풀블리드·글래스모피즘 위 텍스트)
풀블리드 사진·동영상·`backdrop-filter` 위에 텍스트를 얹을 때:

1. 텍스트와 이미지 사이에 **스크림 레이어**(반투명 단색/그라데이션)를 **반드시** 깐다.
2. 대비는 이미지 픽셀이 아니라 **스크림이 깔린 뒤의 합성색**에서 측정한다.
3. **스크림 위에서 APCA를 재측정**해 본문 Lc≥75 / 대형 Lc≥45를 통과시킨다(통과 못하면 스크림 불투명도를 올린다).
4. 글래스모피즘(`backdrop-filter: blur`)은 배경이 바뀌면 대비도 바뀌므로 **블러 뒤로 들어올 수 있는 가장 밝은/어두운 배경 모두**에서 측정. `@supports`로 미지원 브라우저엔 불투명 폴백.

```css
/* 스크림: 하단 텍스트 가독 확보. 측정은 이 위에서 다시 한다 */
.hero { position: relative; }
.hero::after {                 /* 스크림 레이어 */
  content: ""; position: absolute; inset: 0;
  background: linear-gradient(to top, rgb(0 0 0 / .62), rgb(0 0 0 / 0) 55%);
}
.hero > .caption { position: relative; z-index: 1; color: #fff; } /* z-index로 스크림 위 */

/* 글래스: 미지원 시 불투명 폴백으로 대비 보장 */
.glass { background: rgba(20,24,33,.92); }            /* 폴백(불투명에 가깝게) */
@supports (backdrop-filter: blur(8px)) {
  .glass { background: rgba(20,24,33,.55); backdrop-filter: blur(8px); }
}
```

### 1.4 색만으로 의미 전달 금지 + CVD
- 상태/카테고리/경고를 **색만으로** 말하지 않는다(색맹 동료 가정). **색 + (아이콘/라벨/패턴/텍스트)** 이중 인코딩.
- 차트는 직접 라벨 + 명도 분리를 1순위(패턴은 인쇄/인접 한정). 자세한 색 규약은 `color-token-contract.md`·`chart-decision.md`.

---

## 2. 시맨틱 골격 — landmark + 제목 단일 위계 (B2)

### 2.1 landmark (페이지의 "방 이름표")
모든 산출물은 콘텐츠를 landmark로 감싼다 → 스크린리더가 "여기는 본문/탐색/푸터"를 안내.

```html
<body>
  <a class="skip-link" href="#main">본문 바로가기</a>   <!-- B3 skip link -->
  <header><!-- 로고·전역 헤더 (role=banner 자동) --></header>
  <nav aria-label="주요 메뉴"><!-- 같은 페이지에 nav 2개 이상이면 각각 aria-label 필수 --></nav>
  <main id="main"><!-- 페이지당 정확히 1개 --></main>
  <footer><!-- 출처·기준일 메타 (role=contentinfo 자동) --></footer>
</body>
```
- 같은 종류 landmark가 2개 이상이면 **`aria-label`로 구분**(예: `nav aria-label="주요 메뉴"` / `nav aria-label="페이지 내 목차"`).
- `main`은 페이지당 1개. 모든 의미 콘텐츠는 어떤 landmark 안에 들어가야 한다(orphan 금지).

### 2.2 제목 단일 위계 (`h1`→`h6`, 레벨 건너뜀 0)
- `h1`은 페이지당 **1개**(그 문서가 무엇인가). 이후 `h2`→`h3`… **건너뛰지 않는다**(h2 다음 h4 금지).
- 시각적 크기는 **CSS로** 만든다 — 큰 글씨가 필요해 `h4`를 쓰는 식의 "의미 없는 레벨 선택" 금지(spec §0: 위계는 대비가 아니라 크기·굵기·여백).

```
h1  문서 제목
├─ h2  섹션
│   ├─ h3  하위 섹션
│   └─ h3
└─ h2  섹션      ← h2에서 바로 h2로 돌아오는 건 OK. h2→h4 점프는 BLOCK
```

---

## 3. 완전 키보드 + 포커스 (B3·B4)

### 3.1 키보드 도달 (마우스 없이 전부)
- 모든 상호작용 요소는 **네이티브 요소**(`button`/`a[href]`/`input`/`select`)를 우선 사용 → 키보드·포커스·역할이 공짜로 따라온다.
- `div`/`span`에 클릭 핸들러만 붙이는 패턴 금지(키보드 도달 불가). 불가피하면 `role` + `tabindex="0"` + Enter/Space 핸들러.
- Tab 순서 = 시각적 순서. `tabindex` 양수(`tabindex="1"` 등) 금지(순서 꼬임). 허용은 `0`(끼워넣기)과 `-1`(프로그램 포커스 전용)뿐.
- **터치 타깃 ≥ 24px(권장 44px)** — `target.size.min` 토큰(§6)으로 강제.

### 3.2 `:focus-visible` 2px(대비 3:1) — 보이는 포커스 (B3)
포커스 링은 **키보드 사용자에게만** 보이게(`:focus-visible`) 하고, 두께 2px·배경 대비 3:1을 보장한다.

```css
:where(a, button, input, select, textarea, [tabindex]):focus-visible {
  outline: var(--focus-ring-width, 2px) solid var(--focus-ring-color, #2563eb);
  outline-offset: var(--focus-ring-offset, 2px);   /* 요소에 붙지 않게 띄움 */
}
/* 마우스 클릭 시 outline 제거는 :focus-visible가 자동 처리 — 절대 outline:none만 남기지 말 것 */
```
- `outline: none`만 두고 대체 표시가 없으면 **즉시 BLOCK**.
- focus 색은 배경 대비 3:1(UI 컴포넌트 게이트, §1.2). 어두운/밝은 배경 둘 다 쓰이면 두 배경 모두에서 3:1 만족하는 색 또는 이중 outline(흰+검) 사용.

### 3.3 포커스 관리 — 동적 DOM 교체에만 (B4)
> **핵심 결정 규칙**: 포커스 트랩/복귀/`aria-live`는 **DOM이 동적으로 교체될 때만** 적용한다.
> - **적용 O**: 모달/다이얼로그 열기, 탭 전환으로 패널 교체, SPA 라우트 전환, 무한스크롤 추가, 토스트/검증메시지 등장.
> - **적용 X(과잉 금지)**: 정적 페이지, 단순 링크 이동, 폼 입력 중 — 여기에 트랩을 걸면 오히려 사용성 파괴.

3가지 의무:
1. **열 때**: 포커스를 새 영역(모달 제목/첫 입력)으로 이동.
2. **갇혀 있는 동안**: Tab이 영역 밖으로 새지 않게 트랩, **Esc로 닫기**.
3. **닫을 때**: 포커스를 **열기 전 요소로 복귀**(어디 있었는지 잃지 않게).
4. **동적 콘텐츠 변경**: 화면 갱신을 `aria-live`로 스크린리더에 통보(§5.1).

코드는 §7(vanilla JS 스니펫).

---

## 4. 도메인별 a11y 체크리스트

> 공통(전 도메인): B1~B7 전부 + landmark + 제목 위계 + 완전 키보드 + reduced-motion + 한국어 `word-break:keep-all`.
> 아래는 **도메인 고유 추가 항목**.

### 4.1 웹앱 (프론트엔드) — spec §4.1
- [ ] **모든 입력에 라벨**: `<label for>` 또는 `aria-label`. placeholder는 라벨이 **아니다**(사라짐).
- [ ] **도움말·형식 안내·에러는 `aria-describedby`로 입력에 연결**(읽어주게).
- [ ] **에러 발생 시 `aria-invalid="true"` + `aria-describedby`로 에러문 연결 + 라이브영역 통보**.
- [ ] **라이브영역(`aria-live`)**: 비동기 결과·검증·토스트는 `aria-live="polite"`(긴급=`assertive`)로 통보(§5.1).
- [ ] **인터랙티브 8상태 전수**: default/hover/active/focus-visible/disabled/loading/error/empty 각각 시각 + 의미.
- [ ] **동적 DOM 교체**(모달·탭·SPA)에 포커스 트랩+복귀(§3.3·§7).
- [ ] 320px 모바일퍼스트·무가로스크롤·터치≥24px(권장44)·텍스트 200% reflow.

```html
<label for="email">이메일</label>
<input id="email" type="email"
       aria-describedby="email-help email-err" aria-invalid="false">
<p id="email-help">회사 이메일을 입력하세요</p>
<p id="email-err" hidden>올바른 형식이 아닙니다</p>     <!-- 에러 시 hidden 해제 + aria-invalid=true + 라이브영역 알림 -->
```

### 4.2 공유용 분석 보고서 — spec §4.2
- [ ] **모든 차트에 스크린리더용 대체본(협상 불가)**: `table` + `caption` + `th[scope]`. 차트는 시각, 표는 진실원천.
- [ ] **차트 자체**: `role="img"` + `<title>`(한 줄 요약) + `<desc>`(추세·수치). takeaway는 결론형 제목으로(`chart-decision.md`).
- [ ] **표 구조**: 헤더 셀은 `th`, `scope="col"`/`scope="row"`로 행·열 헤더 명시. 데이터 표에 `caption`으로 표 제목.
- [ ] 색 외 직접 라벨 + 명도 분리(CVD). 정적 4상태(empty·과다 상위N+'외M건'·결측NA·print분할).
- [ ] 출처·기준일·n=·가정 메타 푸터(`footer` landmark).

```html
<figure role="group" aria-labelledby="c1-cap">
  <svg role="img" aria-labelledby="c1-t c1-d" viewBox="0 0 400 240">
    <title id="c1-t">분기별 매출 추이</title>
    <desc id="c1-d">2025년 1분기 12억에서 4분기 19억으로 우상향, 3분기 정체 후 반등.</desc>
    <!-- 막대/선 + 직접 라벨 -->
  </svg>
  <figcaption id="c1-cap">분기별 매출(억원)</figcaption>
</figure>

<!-- 스크린리더·인쇄용 진실원천 표(시각적으로 숨겨도 SR엔 노출: .visually-hidden, display:none 금지) -->
<table class="visually-hidden">
  <caption>분기별 매출(억원), 출처: 내부 ERP, 기준일 2025-12-31, n=4</caption>
  <thead><tr><th scope="col">분기</th><th scope="col">매출(억원)</th></tr></thead>
  <tbody>
    <tr><th scope="row">1분기</th><td>12</td></tr>
    <tr><th scope="row">4분기</th><td>19</td></tr>
  </tbody>
</table>
```

### 4.3 C레벨·이그제큐티브 보고서 — spec §4.3
- [ ] 4.2의 **차트 대체본·표 scope·메타 푸터 전부 상속**.
- [ ] **본문 APCA Lc≥75 AND WCAG 4.5:1**(절제된 톤에서도 가독 하한선 사수).
- [ ] **인쇄·PDF 흑백 안전**: 색이 빠져도 명도·라벨로 구분되게(흑백 인쇄 대비 토큰). `@media print` 페이지 분할.
- [ ] 임원 휴대폰 320px 무손실. BLUF(결론 먼저) 골격 = 읽기 순서 = DOM 순서.

### 4.4 발표 PPT 덱(HTML) — spec §4.4
- [ ] **각 슬라이드 = `section[aria-label]`**(슬라이드 region, 스크린리더가 "3/12 슬라이드" 안내 가능).
- [ ] **키보드 네비**: ←/→(또는 PageUp/Down)로 슬라이드 이동, Home/End 처음·끝. 포커스는 새 슬라이드 region으로 이동(§3.3 동적 교체).
- [ ] **발표자 노트**: 화면(시각) + 스크린리더 동시 접근. 노트를 `aria-hidden`으로 숨기지 말 것 — 시각 숨김이 필요하면 별도 발표자 모드.
- [ ] **빔프로젝터 저대비 보정**: 대비 한 단계 상향(저대비 환경 가정). figure/figcaption.
- [ ] 16:9 + `@media print` 슬라이드 페이지 분할. expression zone(표지·간지) 자유, data zone 절제.

```html
<section aria-label="슬라이드 3: 핵심 결론" tabindex="-1">  <!-- tabindex=-1: JS로 포커스 이동 가능 -->
  <h2>3분기 반등의 원인</h2>
  <!-- 슬라이드당 1주장 -->
</section>
<!-- 발표자 노트: 시각·SR 동시 노출. visually-hidden(SR엔 들림) 또는 발표자 모드 패널 -->
<aside class="presenter-note" aria-label="슬라이드 3 발표자 노트">신제품 출시 효과 강조.</aside>
```

---

## 5. 라이브영역 · reduced-motion

### 5.1 라이브영역 (`aria-live`) — 화면 변화를 귀로 (B4)
동적으로 바뀌는 영역을 미리 비워서 마크업 → 내용이 바뀌면 스크린리더가 자동으로 읽는다.
- `polite`: 검색 결과·저장 완료·검증 메시지(흐름 안 끊고 다음 틈에 읽음) — **기본값**.
- `assertive`: 즉시 알려야 하는 오류·시간 임박(현재 읽기 끊고 즉시) — 남발 금지.
- 영역은 **빈 채로 먼저 존재**해야 한다(나중에 통째로 추가하면 안 읽힘).

```html
<div id="status" aria-live="polite" aria-atomic="true" class="visually-hidden"></div>
```

### 5.2 prefers-reduced-motion (모션 예산 = 1회·≤250ms·reduced 0)
- art brief 모션 예산(spec §2): 진입 1회·≤250ms·`prefers-reduced-motion`에서 **0**.
- 사용자가 OS에서 "움직임 줄이기"를 켜면 애니메이션·패럴랙스·자동재생을 끈다.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: .001ms !important; animation-iteration-count: 1 !important;
    transition-duration: .001ms !important; scroll-behavior: auto !important;
  }
}
```

---

## 6. a11y 1급 토큰 (semantic 승격 — 누락 시 lint BLOCK)

> spec §6 token-system: 아래 토큰은 **경량 모드에서도 생략 불가**. 누락 시 토큰 lint가 BLOCK.
> 이름·값은 `references/_contract.md`(§1·§2·§5 단일 소스) / `token-system.md` / `color-token-contract.md`와 **반드시 일치**해야 한다.

```css
:root {
  /* 포커스 — focus.ring.{color,width,offset} */
  --focus-ring-color: var(--color-brand-500);  /* 실제 tokens.css에선 reference 참조. 배경 대비 3:1 이상 (UI 게이트) */
  --focus-ring-width: 2px;
  --focus-ring-offset: 2px;

  /* 모션 — motion.duration.{fast,base} + motion.reduce 플래그 */
  --motion-duration-fast: 120ms;
  --motion-duration-base: 200ms;  /* 기본값 200ms · 모션 예산 상한 ≤250ms (_contract.md §1) */
  /* motion.reduce는 @media (prefers-reduced-motion)로 표현(§5.2) */

  /* 터치 타깃 — target.size.min */
  --target-size-min: 24px;        /* 권장 44px. min은 24px 하한 */
}
```

CVD/뷰포트 대응 토큰(`color.viz.*`, 다크/고대비 reference 스왑)은 `color-token-contract.md`·`token-system.md` 소관 — 여기서 이름만 참조한다.

---

## 7. vanilla JS 스니펫 (런타임 0KB·약 3KB, 산출물에 직접 동봉)

> 무빌드 더블클릭 보장: 빌드/번들 없이 `<script>`로 동봉. 의존성 0. 동적 DOM 교체(§3.3)에만 사용.

### 7.1 스킵 링크 (B3)
```html
<a class="skip-link" href="#main">본문 바로가기</a>
```
```css
.skip-link {
  position: absolute; left: 8px; top: -48px;   /* 평소엔 화면 밖 */
  z-index: 1000; padding: 8px 14px; border-radius: 8px;
  background: #111; color: #fff; text-decoration: none;
  transition: top var(--motion-duration-fast, 120ms);
}
.skip-link:focus-visible { top: 8px; }          /* Tab으로 포커스 시 등장 */

.visually-hidden {                               /* SR엔 들리되 시각 숨김. display:none 금지 */
  position: absolute !important; width: 1px; height: 1px;
  margin: -1px; padding: 0; border: 0; overflow: hidden;
  clip: rect(0 0 0 0); clip-path: inset(50%); white-space: nowrap;
}
```

### 7.2 포커스 트랩 + 복귀 (B4 — 모달/다이얼로그)
```html
<script>
/* 모달 등 동적 교체 영역의 포커스 트랩.
 * open(panel): 직전 포커스 저장 → 첫 포커서블로 이동 → Tab 가둠 → Esc 닫기.
 * 정적 페이지엔 절대 쓰지 말 것(§3.3). */
(function () {
  var FOCUSABLE = 'a[href],button:not([disabled]),input:not([disabled]),' +
    'select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex="-1"])';
  var lastFocused = null, activePanel = null, onKey = null;

  function focusables(panel){ return Array.prototype.slice.call(panel.querySelectorAll(FOCUSABLE)); }

  window.openTrap = function (panel) {
    lastFocused = document.activeElement;          // 1) 직전 위치 저장
    activePanel = panel;
    var items = focusables(panel);
    (items[0] || panel).focus();                   // 2) 첫 요소로 포커스
    onKey = function (e) {
      if (e.key === 'Escape') { window.closeTrap(); return; }   // Esc 닫기
      if (e.key !== 'Tab') return;
      var list = focusables(panel); if (!list.length) { e.preventDefault(); return; }
      var first = list[0], last = list[list.length - 1];
      if (e.shiftKey && document.activeElement === first) { last.focus(); e.preventDefault(); }
      else if (!e.shiftKey && document.activeElement === last) { first.focus(); e.preventDefault(); }
    };
    document.addEventListener('keydown', onKey);   // 3) Tab 가둠
  };

  window.closeTrap = function () {
    if (onKey) document.removeEventListener('keydown', onKey);
    if (activePanel) activePanel.hidden = true;
    if (lastFocused && lastFocused.focus) lastFocused.focus();  // 4) 직전 위치 복귀
    activePanel = null; onKey = null; lastFocused = null;
  };
})();
</script>
```
> 네이티브 `<dialog>` + `showModal()`을 쓸 수 있으면 트랩·Esc·`::backdrop`이 공짜다. 위 스니펫은 `<dialog>` 미사용/구형 폴백용.

### 7.3 라이브영역 통보 헬퍼 (B4 / §5.1)
```html
<div id="a11y-status" aria-live="polite" aria-atomic="true" class="visually-hidden"></div>
<script>
/* 화면 갱신을 스크린리더에 통보. 같은 문자열 반복도 읽히게 살짝 변형 */
function announce(msg, assertive){
  var el = document.getElementById('a11y-status');
  if (!el) return;
  el.setAttribute('aria-live', assertive ? 'assertive' : 'polite');
  el.textContent = '';                       // 먼저 비워 변화 감지 보장
  requestAnimationFrame(function(){ el.textContent = msg; });
}
/* 예: announce('검색 결과 12건'); / announce('저장에 실패했습니다', true); */
</script>
```

### 7.4 슬라이드 키보드 네비 (PPT 덱 §4.4)
```html
<script>
/* ←/→ PageUp/Down 슬라이드 이동, Home/End 처음·끝. 새 슬라이드로 포커스 이동(동적 교체). */
(function(){
  var slides = Array.prototype.slice.call(document.querySelectorAll('section[aria-label]'));
  if (!slides.length) return; var i = 0;
  function go(n){ i = Math.max(0, Math.min(slides.length - 1, n));
    slides.forEach(function(s,k){ s.hidden = k !== i; });
    slides[i].focus();                          // section[tabindex="-1"] 필요
  }
  document.addEventListener('keydown', function(e){
    if (e.key==='ArrowRight'||e.key==='PageDown') go(i+1);
    else if (e.key==='ArrowLeft'||e.key==='PageUp') go(i-1);
    else if (e.key==='Home') go(0); else if (e.key==='End') go(slides.length-1);
  });
  go(0);
})();
</script>
```

---

## 8. 검증 환경 — axe는 dev-only, 미설치 fallback (spec §7·§9)

> **철칙**: axe-core는 **검증 시점에만 주입**(dev-only), **사용자 산출물 폴더에는 절대 포함하지 않는다**(런타임 0KB).
> 코드 스니펫(§7)은 산출물에 동봉되지만, axe 같은 **검사 도구**는 동봉 금지.

### 8.1 환경별 검증 경로 (WSL2/Windows 고려)
| 환경 | 1순위 | 누락 시 fallback |
|------|-------|------------------|
| axe-core 주입 가능(headless 브라우저 OK) | **axe 실측** → 위반 0건까지 자동 보정 | — |
| axe 불가, Lighthouse 가능 | **Lighthouse a11y 카테고리** CLI | 점수<100 항목을 수동 체크리스트로 |
| 둘 다 불가(WSL2/Windows 미설치 흔함) | **본 파일 §0 BLOCK 7종 수동 전수 점검** | 아래 §8.2 수동 체크리스트 |

- **max_retries 패턴**: 자동 보정 → 재측정 루프는 **최대 3회**. 3회 후에도 잔존 위반이 있으면 BLOCK 사유를 무결성 리포트에 명시하고 사용자에게 신호등으로 보고(숨기지 않음).

### 8.2 도구 없을 때 수동 체크리스트 (그대로 따라가면 됨)
1. **Tab만으로** 처음부터 끝까지 — 모든 버튼·링크·입력에 도달하나? 포커스 링이 매번 보이나(2px)?
2. **Esc**로 모달이 닫히고 포커스가 **열기 전 위치로** 돌아오나?
3. 제목을 `h1→h6` 순서로 읽었을 때 **건너뛴 레벨**이 없나?
4. 모든 이미지/차트에 `alt`/`title+desc`/대체표가 있나? 차트는 `table+caption+th scope`가 있나?
5. 모든 입력에 보이는 라벨(placeholder 말고)이 있나? 에러가 라이브영역으로 알려지나?
6. 색을 흑백으로 봤다고 상상 — 상태/카테고리가 **여전히** 구분되나(색 외 라벨/패턴)?
7. 풀블리드/글래스 위 텍스트에 스크림이 있고 그 위 대비가 §1.2를 통과하나?
8. OS "움직임 줄이기" 켜면 애니메이션이 멈추나?

---

## 9. 비개발자 표면 — 신호등 카피 매핑 사전 (사용자에게 보이는 전부)

> 위 §1~§8의 숫자·토큰·코드는 **백스테이지**. 사용자에게는 아래 신호등 3색 + 실생활 1줄만 노출한다(spec §1·§8, non_dev_rules).
> APCA/WCAG/Lc/토큰/aria 같은 단어는 **사용자 대면 카피에 절대 단독 노출 금지**.

| 신호등 | 내부 의미(백스테이지) | 사용자 카피(라벨) | 실생활 효익 1줄 |
|--------|----------------------|-------------------|-----------------|
| 🟢 초록 | 이중 대비 게이트 통과 + 키보드·대체본 완비 | **"잘 읽힘"** | "밝은 회의실 빔에서도, 저시력 동료 휴대폰에서도 또렷합니다." |
| 🟡 노랑 | 본문은 통과하나 일부가 대형/확대 전제 | **"큰 글씨만 OK"** | "지금도 읽히지만, 작은 글씨 일부는 확대해서 보면 더 편합니다." |
| 🔴 빨강 | 게이트 미달 항목 발견 → **자동 보정 적용함** | **"자동 보정함"** | "읽기 어려운 색·작은 글씨를 발견해 자동으로 또렷하게 고쳐 넣었습니다." |

- 빨강은 "당신이 고치세요"가 아니라 **"우리가 이미 고쳤습니다"**(자동 수정 우선, spec §8-6). 사용자에게 숙제를 떠넘기지 않는다.
- 최종 보고 카피 예: **"색맹 동료도 구분 가능 ✓ · 키보드만으로 전체 사용 가능 ✓ · 접근성 자동 점검 통과 🟢 잘 읽힘"**.
- 배지는 샘플 갤러리 카드(spec §3)·검증 요약·a11y-report.md에 노출. 항목은 **대비·키보드·반응형** 3축으로 묶어 표시.

---

## 10. 런타임 에이전트 적용 순서 (요약 결정 트리)

1. 도메인 확정(spec §4) → §4의 해당 도메인 고유 체크리스트 로드.
2. 골격: landmark + `h1→h6`(§2) + skip link(§7.1) 주입.
3. 토큰: §6 a11y 1급 토큰 주입(누락 시 lint BLOCK).
4. 상호작용: 네이티브 요소 + `:focus-visible`(§3.2). 동적 교체 영역에만 §7.2·§7.3·§7.4.
5. 색/이미지: 이중 대비 게이트(§1) + 스크림(§1.3) + CVD 이중 인코딩.
6. 도메인 대체본(§4): 차트 표/폼 라벨·describedby/슬라이드 region.
7. 모션: §5.2 reduced-motion.
8. 검증: §8 경로(axe→Lighthouse→수동 §8.2), max 3회 보정 루프.
9. 보고: §9 신호등 + 실생활 1줄. 숫자·토큰·코드는 노출 안 함.

> 하나라도 §0 BLOCK 7종에 걸리면 자동 보정 후 재측정. skip 불가(spec §7).

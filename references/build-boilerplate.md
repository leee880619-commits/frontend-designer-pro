# build-boilerplate.md — 무빌드 보일러플레이트 (frontend-implementation-engineer)

> **이 파일의 역할**: 런타임 에이전트(design-lead-pro)가 결과물을 **빌드 도구 없이 더블클릭만으로 열리게** 만들기 위해 그대로 복사·수정해 쓰는 실전 골격. 단일 `index.html` 골격, reset.css, `tokens.css` 주입 패턴, importmap ESM 무빌드 경로, `@media print`, 한국어 폰트 스택, 비용 계층 표, 성능 예산 측정, progressive enhancement, 결과 폴더 구조를 모두 담는다.
>
> **자기완결 선언**: 이 문서 안의 코드만으로 동작한다. 외부 스킬·CDN·빌드 파이프라인이 전부 막혀도 한글이 깨지지 않고 화면이 읽힌다. "다른 스킬을 참조하라"는 지시는 없다 — 필요한 것은 전부 여기 있다.
>
> **근거**: 02-skill-spec.md §6(build-boilerplate 행)·§1(6단계 본 작업)·§2(질문 게이트)·§7(무결성 게이트)·§8(비개발자 1급 원칙)·§9(미해결 리스크 2·3·6). frontend-implementation-engineer 렌즈가 주도.

---

## 0. 비개발자 한 줄 (표면)

> "결과물 폴더의 `index.html`을 더블클릭하면 브라우저에서 바로 열립니다. 설치할 것도, 켜둘 서버도 없습니다. 인터넷이 끊겨도, 회사 보안이 외부 글꼴을 막아도 글자가 깨지지 않습니다."

이 한 줄을 보증하는 모든 기계 장치가 아래 본문(백스테이지)이다. 사용자에게는 이 한 줄과 신호등(초록 "바로 열림")만 노출한다.

---

## 1. 무빌드 절대 규칙 (협상 불가)

런타임 에이전트는 아래를 **하나라도 어기면 BLOCK**으로 간주하고 산출 전에 고친다. (근거: 01-debate-synthesis §76 "무빌드 더블클릭 동작은 협상 불가")

| 규칙 | 해도 되는 것 | 절대 금지 |
|------|-------------|-----------|
| 진입점 | `index.html` 하나를 더블클릭 → `file://`로 열림 | `npm run`, `vite`, `next dev`, dev 서버 전제 |
| 자바스크립트 | `<script type="module">`, importmap ESM | 번들러(webpack/rollup/esbuild), `.jsx`/`.tsx` 트랜스파일 필요 코드 |
| CSS | 순수 CSS, CSS custom property(변수), `@import` 1뎁스 | Sass/Less/PostCSS 빌드, Tailwind JIT |
| 폰트 | 로컬 woff2 동봉 또는 `system-ui` 폴백 | CDN 폰트 **단독** 의존(끊기면 깨짐) |
| 자산 | 인라인 SVG, 폴더 내 상대경로 자산 | 빌드해야 생기는 `dist/`·`.next/`·해시 파일명 |
| 데이터 | 인라인 `<script type="application/json">`, 동봉 `.json` | 외부 API 호출 전제(오프라인 불가) |

**자가 점검 1줄**: "지금 만든 폴더를 인터넷 끊고 USB로 옮겨 더블클릭하면 똑같이 보이는가?" → 예가 아니면 무빌드 위반.

### 1.1 `file://` 환경의 함정 (반드시 회피)

`file://`로 열면 브라우저 보안 정책상 아래가 **막힌다**. 회피책을 기본 적용한다.

| 막히는 것 | 증상 | 회피책(기본 적용) |
|-----------|------|-------------------|
| `fetch('./data.json')` | CORS 에러, 빈 화면 | 데이터를 `<script type="application/json" id="...">`로 **인라인** 동봉 |
| ES 모듈 상대 import 일부 | Firefox 등에서 모듈 차단 가능 | importmap + 단일 모듈 스크립트로 최소화, 핵심 로직은 인라인 |
| `iframe` 상호 접근 | 샘플 갤러리 미리보기 빈칸 | iframe + **정적 링크(`<a href>`) 폴백 항상 병행** (§9, spec §9-4) |
| 쿠키·localStorage 일부 | 상태 저장 실패 가능 | 핵심 동작이 저장에 의존하지 않게 설계 |

---

## 2. 단일 index.html 골격 (실제 코드 — 그대로 복사 시작점)

아래는 **모든 도메인 공통 출발 골격**이다. 도메인별로 `<main>` 내부만 갈아끼운다. 주석의 `<!-- 교체: -->`가 수정 지점.

```html
<!doctype html>
<html lang="ko">   <!-- 기본 ko. 비한국어 청중이면 {{LANG}}로 파라미터화(en/ja 등) — _contract.md §7.
                       lang은 스크린리더 발음·word-break:keep-all 동작의 전제라 청중 언어와 일치시킨다. -->
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <meta name="color-scheme" content="light dark">
  <title><!-- 교체: 결론형 제목, 예) 2026 1분기 실적 요약 --></title>
  <meta name="description" content="<!-- 교체: 한 줄 요약 -->">

  <!-- (A) 한국어 폰트: 로컬 동봉 우선, 없으면 system-ui 자동 폴백 (§4) -->
  <style>
    /* 동봉 폰트가 assets/fonts/ 에 있을 때만 활성. 파일 없으면 브라우저가 무시하고 폴백 */
    @font-face{
      font-family:"Pretendard";
      src:url("./assets/fonts/Pretendard-Regular.subset.woff2") format("woff2");
      font-weight:400; font-style:normal; font-display:swap;
    }
    @font-face{
      font-family:"Pretendard";
      src:url("./assets/fonts/Pretendard-SemiBold.subset.woff2") format("woff2");
      font-weight:600; font-style:normal; font-display:swap;
    }
  </style>

  <!-- (B) reset → tokens → app 순서 고정. tokens.css가 단일 SSOT (§3) -->
  <link rel="stylesheet" href="./assets/reset.css">
  <link rel="stylesheet" href="./tokens.css">
  <link rel="stylesheet" href="./assets/app.css">

  <!-- (C) ESM 무빌드 경로가 필요할 때만. 없으면 통째로 삭제 (§5) -->
  <script type="importmap">
  {
    "imports": {
      "preact": "./assets/vendor/preact.module.js",
      "htm": "./assets/vendor/htm.module.js"
    }
  }
  </script>
</head>
<body>
  <!-- (D) 스킵 링크: 키보드 사용자가 본문으로 바로 점프 (a11y 1급) -->
  <a class="skip-link" href="#main">본문 바로가기</a>

  <header class="site-header" role="banner">
    <!-- 교체: 로고/제목 -->
  </header>

  <!-- (E) 본문: 도메인별로 이 안만 교체. JS 없이도 읽혀야 함 (progressive enhancement §8) -->
  <main id="main" tabindex="-1">
    <!-- 교체: 도메인 콘텐츠 (정적 HTML로 완결 — JS는 향상만) -->
  </main>

  <footer class="site-footer" role="contentinfo">
    <!-- 교체: 메타데이터 푸터 — 출처·기준일·n=·생성일시 (보고서/차트 도메인 필수) -->
  </footer>

  <!-- (F) JS는 맨 끝, type=module, 향상 전용. 막혀도 위 정적 HTML로 읽힘 -->
  <script type="module" src="./assets/app.js" defer></script>
</body>
</html>
```

### 2.1 골격 규칙 메모

- `<html lang>` 필수 — 스크린리더 발음·`word-break` 동작 전제. **기본 `ko`**, 비한국어 청중이면 청중 언어(`en`·`ja` 등)로 파라미터화(`_contract.md` §7). lang과 본문 언어 불일치는 a11y BLOCK 소지(잘못된 발음).
- 로드 순서 `reset → tokens → app` 고정. tokens가 reset보다 먼저면 변수 미정의, app보다 늦으면 덮어쓰기 충돌.
- `<main tabindex="-1">` — 스킵 링크 점프 후 포커스를 받기 위함.
- `meta color-scheme: light dark` — 다크모드 파생을 OS 설정과 연동(secure-by-default, spec §8-3).
- JS 블록 `(C)`/`(F)`는 **정적 산출물(보고서·C레벨·PPT)에선 통째로 삭제**. 웹앱 도메인에서만 유지.

### 2.2 반응형 그리드 가드 (320px 무가로스크롤 — BLOCK)

`repeat(auto-fit, minmax(Nrem, 1fr))` 패턴은 뷰포트가 `Nrem`보다 좁아지면 칼럼이 안 줄어 **가로 스크롤이 생긴다**(특히 320px). 반드시 `min()`으로 최소 트랙을 컨테이너 폭까지 수축시킨다.

```css
/* ✗ 위험: 뷰포트 < 22rem(=352px)면 320px에서 가로 스크롤 */
grid-template-columns: repeat(auto-fit, minmax(22rem, 1fr));
/* ✓ 안전: 좁은 폭에서 칼럼이 100%까지 수축 */
grid-template-columns: repeat(auto-fit, minmax(min(22rem, 100%), 1fr));
```

- iframe·이미지·표 등 고정 성향 요소는 `max-width:100%`(이미지는 `height:auto`)로 항상 제한.
- 산출 직전 320px에서 `document.documentElement.scrollWidth <= innerWidth`를 확인(§11 체크리스트). 어기면 BLOCK.

---

## 3. reset.css + tokens.css 주입 패턴

### 3.1 assets/reset.css (그대로 동봉 — 약 40줄, 충분히 경량)

```css
/* reset.css — 무빌드 미니 리셋. 브라우저 기본 들쭉날쭉함 제거 */
*,*::before,*::after{box-sizing:border-box;}
*{margin:0;}
html{-webkit-text-size-adjust:100%;text-size-adjust:100%;}
body{
  min-height:100vh;
  line-height:1.6;            /* 한국어 가독 하한선 (§4) */
  -webkit-font-smoothing:antialiased;
  text-rendering:optimizeLegibility;
}
img,picture,svg,video,canvas{display:block;max-width:100%;height:auto;}
input,button,textarea,select{font:inherit;color:inherit;}
button{cursor:pointer;background:none;border:none;}
p,h1,h2,h3,h4,h5,h6{overflow-wrap:break-word;}
ul[role="list"],ol[role="list"]{list-style:none;padding:0;}
a{color:inherit;text-decoration-thickness:from-font;}
:where(h1,h2,h3,h4,h5,h6){text-wrap:balance;}      /* 제목 줄바꿈 균형 */
:where(p){text-wrap:pretty;}                        /* 본문 고아줄 방지 */
/* 모션 줄이기 요청 시 전역 차단 (a11y 1급, reduced-motion 0) */
@media (prefers-reduced-motion: reduce){
  *,*::before,*::after{
    animation-duration:.01ms !important;animation-iteration-count:1 !important;
    transition-duration:.01ms !important;scroll-behavior:auto !important;
  }
}
```

### 3.2 tokens.css 주입 패턴 (런타임 단일 SSOT)

`tokens.css`는 결과물의 **유일한 색·간격·타이포 원천**이다. raw hex/px를 컴포넌트 CSS에 직접 쓰지 않는다(토큰 lint BLOCK, spec §6 token-system). app.css는 변수만 참조한다.

```css
/* tokens.css — 이 한 파일만 바꾸면 전체 톤이 바뀐다 (비개발자 편집 지점) */
/* 토큰명·상수값의 정식 계약은 references/_contract.md (단일 소스). 아래는 그 컨벤션을 따른 예시. */
:root{
  /* ── reference 층: 실제 색값 (선택 시안에서 고정). 정규 접두 --color-* (--ref-* 금지, _contract.md §4) ── */
  --color-brand-500: oklch(0.55 0.13 255);   /* 예: 네이비 */
  --color-ink-900:   oklch(0.22 0.02 255);
  --color-paper-50:  oklch(0.98 0.005 255);

  /* ── semantic 층: "역할" 이름 (컴포넌트는 이것만 참조) ── */
  --bg-page:         var(--color-paper-50);
  --text-body:       var(--color-ink-900);
  --accent:          var(--color-brand-500);

  /* a11y 1급 토큰 — 경량 모드에서도 생략 금지 (누락 시 lint BLOCK, spec §6 / _contract.md §5) */
  --focus-ring-color: var(--color-brand-500);
  --focus-ring-width: 2px;
  --focus-ring-offset: 2px;
  --motion-duration-fast: 120ms;
  --motion-duration-base: 200ms;   /* 기본값 200ms · 모션 예산 상한 ≤250ms (_contract.md §1) */
  --motion-reduce: 1;              /* reduced 시 0 */
  --target-size-min: 24px;          /* 터치 최소(권장 44px) */

  /* 간격·타이포 (px 하드코딩 대신 토큰) */
  --space-1:.25rem; --space-2:.5rem; --space-3:1rem; --space-4:1.5rem; --space-6:3rem;
  --font-sans:"Pretendard", system-ui, -apple-system, "Segoe UI",
              "Apple SD Gothic Neo", "Malgun Gothic", "맑은 고딕", sans-serif;
  --leading-body:1.6;
}

/* OKLCH 미지원 구형/사내 임베드 폴백 — @supports로 hex 스왑 (spec §9-6) */
@supports not (color: oklch(0 0 0)){
  :root{
    --color-brand-500:#3a5ba0;
    --color-ink-900:#2a2f3a;
    --color-paper-50:#fafbfc;
  }
}

/* 다크모드: reference만 스왑 1회, semantic 이름은 불변 (spec §6 token-system) */
@media (prefers-color-scheme: dark){
  :root{
    --color-ink-900: oklch(0.95 0.01 255);
    --color-paper-50: oklch(0.18 0.02 255);
  }
}
```

```css
/* app.css 발췌 — 컴포넌트는 토큰만 참조 (raw hex/px 금지) */
body{ background:var(--bg-page); color:var(--text-body); font-family:var(--font-sans); }
.skip-link{
  position:absolute; left:var(--space-2); top:-3rem;
  background:var(--accent); color:var(--bg-page);
  padding:var(--space-2) var(--space-3); border-radius:.5rem;
  transition:top var(--motion-duration-fast) ease;
}
.skip-link:focus{ top:var(--space-2); }
/* 포커스 표시: 모든 인터랙티브 요소 (대비 3:1, 2px) */
:where(a,button,input,select,textarea,[tabindex]):focus-visible{
  outline:var(--focus-ring-width) solid var(--focus-ring-color);
  outline-offset:var(--focus-ring-offset);
}
button{ min-block-size:var(--target-size-min); min-inline-size:var(--target-size-min); }
```

> **연결**: reference/semantic 네이밍·OKLCH 앵커·APCA 게이트의 정식 규약은 `references/token-system.md`·`references/color-token-contract.md`에 있다. 이 파일은 그 토큰을 **무빌드 HTML에 주입하는 방법**만 다룬다.

---

## 4. 한국어 폰트 스택 (CDN 막혀도 한글 안 깨짐)

### 4.1 폴백 사다리 (3단계 — 어느 단계에서 멈춰도 읽힘)

1. **동봉 woff2 서브셋(이상적)**: `assets/fonts/Pretendard-*.subset.woff2`를 폴더에 함께 넣고 `@font-face`로 로드. 오프라인·CDN 차단에도 동작. `font-display:swap`으로 로드 전엔 폴백 글꼴로 즉시 표시(빈 화면 방지).
2. **서브셋 도구 부재 시(현실적·안전)**: woff2를 못 만들면 `@font-face`를 비우거나 두고, 스택 첫 자리를 `system-ui`로. Windows는 "맑은 고딕", macOS는 "Apple SD Gothic Neo"가 자동 적용 → **한글 정상 표시, 폰트 개성 일부만 손실**(spec §9-3 허용된 폴백).
3. **최후 폴백**: 모든 지정 글꼴 부재 시 OS 기본 sans-serif. 그래도 한글 깨짐 없음.

```css
/* 한국어 안전 폰트 스택 — 어느 환경에서도 한글 렌더 보장 */
--font-sans:"Pretendard", system-ui, -apple-system, "Segoe UI",
            "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", "맑은 고딕", sans-serif;
```

> **CDN 단독 의존 금지**: `https://...pretendard.css` 한 줄만 넣고 끝내면 사내망 차단·오프라인에서 깨진다. CDN을 쓰더라도 **반드시 위 system-ui 폴백 스택을 동반**한다. 가장 안전한 기본값은 "동봉 woff2 + system-ui 폴백"이며, 동봉이 불가하면 "system-ui 시작 스택"으로 자동 강등한다.

### 4.2 한국어 타이포 하한선 (모든 도메인 협상 불가, spec §4 공통·§6)

```css
:where(p,li,td,th,dd,dt,figcaption){
  word-break: keep-all;        /* 단어(어절) 중간에서 안 끊김 — 한국어 가독 핵심 */
  overflow-wrap: anywhere;     /* 아주 긴 토큰만 예외적으로 줄바꿈 (가로 넘침 방지) */
  line-height: var(--leading-body, 1.6);  /* 줄간격 1.6 이상 */
}
:where(h1,h2,h3){ word-break: keep-all; line-height:1.3; }
body{ letter-spacing:-0.01em; }  /* 한글은 미세 음수 자간이 또렷 */
```

- `word-break: keep-all` — 한국어 어절이 줄 끝에서 부자연스럽게 잘리는 것을 막는다(영문 기본값은 한국어에 부적합). **이것 하나가 "사람이 다듬은 느낌"의 핵심 신호**.
- `line-height: 1.6+` — 한글은 글자 높이가 균일해 영문보다 줄간격을 넉넉히 해야 답답하지 않다.
- 본문 최소 16px(1rem) 이상. 빔프로젝터/임원 폰 대상은 상향(PPT·C레벨 도메인).

---

## 5. importmap ESM 무빌드 경로

상태가 복잡한 **웹앱 도메인에서만** 사용. 정적 보고서/C레벨/PPT는 importmap 불필요(삭제). React/Vue/Svelte를 "빌드 없이" 쓰는 정식 경로다(spec §4.1 "importmap 무빌드 경로 우선").

```html
<script type="importmap">
{
  "imports": {
    "preact":             "./assets/vendor/preact.module.js",
    "preact/hooks":       "./assets/vendor/preact.hooks.module.js",
    "htm":                "./assets/vendor/htm.module.js",
    "htm/preact":         "./assets/vendor/htm.preact.module.js"
  }
}
</script>
```

```js
// assets/app.js — 빌드 없이 바로 동작하는 컴포넌트 (htm = JSX 대체, 트랜스파일 불필요)
import { render } from "preact";
import { useState } from "preact/hooks";
import { html } from "htm/preact";

function Counter(){
  const [n, setN] = useState(0);
  return html`
    <button type="button" onClick=${() => setN(n + 1)} aria-live="polite">
      눌린 횟수: ${n}
    </button>`;
}
// 진입점이 비어있어도(JS 막힘) 정적 HTML이 읽히도록, 향상만 수행
const mount = document.querySelector("#app-root");
if (mount) render(html`<${Counter} />`, mount);
```

### 5.1 importmap 원칙

- **vendor는 로컬 동봉**: `assets/vendor/*.module.js`로 라이브러리를 폴더에 함께 넣는다. CDN URL을 importmap에 박으면 오프라인에서 깨진다(무빌드 ≠ 온라인 전제). 사내 보안 환경에서도 안전.
- **htm 사용 이유**: `.jsx` 트랜스파일이 필요 없는 태그드 템플릿 방식이라 브라우저가 그대로 실행. 빌드 도구 0.
- **React를 꼭 써야 하면**: `esm.sh`/`esm.run` 형태 URL을 importmap에 넣을 수 있으나 **온라인 전제가 되므로 로컬 동봉본을 우선**하고, 불가 시 사용자에게 "인터넷 연결 시에만 동작"을 명시(질문 게이트 실행환경 확인과 연동, spec §2).
- **React 기본값 금지**(spec §4.1): 상태가 단순하면 vanilla + 약간의 인라인 JS로 끝낸다. importmap 자체를 안 쓰는 게 가장 가볍다.

---

## 6. @media print CSS (인쇄/PDF 안전)

보고서·C레벨·PPT 도메인 필수(spec §4.2/§4.3/§4.4). 흑백 인쇄·A4·페이지 분할을 보장한다.

```css
@media print{
  :root{
    /* 인쇄는 잉크 절약 + 흑백 대비 안전: 배경 흰색, 텍스트 진한 회색.
       reference 스왑 1회 — semantic(--bg-page/--text-body)은 불변 */
    --color-paper-50:#fff; --color-ink-900:#1a1a1a;
  }
  body{ background:#fff !important; color:#000; font-size:11pt; line-height:1.5; }
  .skip-link, .site-header nav, .no-print, [data-interactive]{ display:none !important; }

  /* 페이지 나눔 제어 */
  section, figure, table, .card{ break-inside:avoid; }     /* 요소 중간 잘림 방지 */
  h1,h2,h3{ break-after:avoid; }                            /* 제목 뒤 바로 페이지끝 방지 */
  .page-break{ break-before:page; }                         /* 강제 페이지 분할 지점 */

  /* 링크 URL을 본문에 노출(종이에선 클릭 불가하므로) */
  a[href^="http"]::after{ content:" (" attr(href) ")"; font-size:9pt; color:#555; }

  /* 차트는 색 외 정보 유지 — 직접 라벨/명도 분리가 흑백에서도 살아야 함 (dataviz 이중 인코딩) */
  svg{ -webkit-print-color-adjust:exact; print-color-adjust:exact; }
}

/* A4 페이지 여백 (PPT/보고서 PDF) */
@page{ size:A4; margin:18mm 16mm; }
/* 16:9 발표 덱은 가로 A4 + 슬라이드 1장=1페이지 */
@media print{
  .slide{ break-after:page; aspect-ratio:auto; }
}
```

- **흑백 대비 안전**: 색이 빠져도 의미가 살도록 차트는 색 외에 **직접 라벨·명도 분리**로 이중 인코딩(spec §4.2). `print-color-adjust:exact`는 의미색 SVG만 선택 적용.
- **페이지 분할**: `break-inside:avoid`로 표·카드·차트가 페이지 경계에서 잘리지 않게 한다.

---

## 7. 비용 계층 (Tier 0 / 1 / 2) — 어떤 효과를 언제 허용하는가

> personality(개성)는 **비용 0 수단부터** 짜낸다. 비싼 장식은 성능 예산을 통과하고 폴백이 있을 때만(spec §6 비용계층, 01-debate §22·§128).

| Tier | 비용 | 수단(예) | 허용 조건 | 폴백 의무 |
|------|------|----------|-----------|-----------|
| **Tier 0** | **0 (항상 권장)** | 타이포 위계(크기·굵기·자간), 넉넉한 여백, **CSS Grid 비대칭 레이아웃**, 대비·색 1포인트, `text-wrap:balance/pretty` | 무조건 1차로 사용. personality의 90%를 여기서 만든다 | 불필요(이미 정적) |
| **Tier 1** | **저비용** | `transform`/`opacity` 마이크로 인터랙션(호버 살짝 떠오름·페이드인), 진입 1회 애니메이션 | 모션 예산 준수(1회·≤250ms), `prefers-reduced-motion: reduce` 폴백 필수 | **reduced-motion 시 0** (CSS로 자동 차단, §3.1 reset에 내장) |
| **Tier 2** | **고비용** | 배경 비디오, 그레인(noise) 텍스처, 패럴랙스 스크롤, `backdrop-filter` 글래스 | 성능 예산(LCP/CLS/INP) **실측 통과** + 폴백 존재 + art brief가 명시 요구 시에만 | 미지원/저사양 폴백 필수(아래 §7.1·§7.2) |

**판단 규칙**: Tier 0로 충분하면 Tier 1·2를 추가하지 않는다. "대담함=무거움"은 게으른 변명(01-debate §93). 비대칭=CSS Grid(비용 0), 그레인=SVG/소형 타일(아래)로 구현 기법으로 예산을 맞추고, 장식부터 버리지 않되 **예산을 깨면 장식을 버린다**.

### 7.1 그레인(noise) = SVG 또는 소형 타일 (Tier 2를 저비용으로)

무거운 PNG noise 대신 인라인 SVG 필터 또는 작은 반복 타일로 구현 → 런타임 0KB에 가깝다.

```css
/* SVG feTurbulence를 data URI로 — 외부 파일 0, 용량 ~1KB */
.grain::before{
  content:""; position:absolute; inset:0; pointer-events:none; opacity:.06;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  background-size:120px 120px; mix-blend-mode:overlay;
}
@media (prefers-reduced-motion: reduce){ .grain::before{ display:none; } }  /* 폴백 */
```

### 7.2 backdrop-filter(글래스) = @supports 폴백 (구형·사내 임베드 대비)

```css
.glass{
  background: color-mix(in oklch, var(--bg-page) 80%, transparent);  /* 폴백: 불투명에 가깝게 */
}
@supports ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))){
  .glass{
    background: color-mix(in oklch, var(--bg-page) 55%, transparent);
    -webkit-backdrop-filter: blur(10px); backdrop-filter: blur(10px);
  }
}
/* 글래스 위 텍스트는 스크림(반투명 어두운 막) 깔고 APCA 재측정 (a11y, spec §6 a11y-checklist) */
.glass .on-glass{ text-shadow:0 1px 2px rgba(0,0,0,.35); }
```

> 글래스/풀블리드 위 텍스트는 스크림을 깐 **그 위에서** 대비를 다시 측정해야 통과로 친다(a11y-checklist 연결).

---

## 8. Progressive Enhancement (JS 막혀도 정적 HTML로 읽힘)

핵심 원칙: **콘텐츠는 정적 HTML로 완결, JS는 "향상"만**(spec §8-7, 01-debate §130 "정적 다중페이지는 landmark+스킵링크+focus-visible로 충분").

| 계층 | 보장 | 구현 |
|------|------|------|
| 1. HTML만 | 모든 텍스트·표·차트(SVG)·링크가 읽힌다 | 콘텐츠를 `<main>`에 직접 작성. SVG 차트는 인라인(JS 생성 금지) |
| 2. + CSS | 레이아웃·색·타이포·인쇄·반응형 | tokens.css + app.css. JS 없이 완성 |
| 3. + JS | 인터랙션 향상(폼 검증 즉시 피드백, 탭, 카운터) | `app.js`가 있으면 좋고, 없어도 1·2가 동작 |

**금지 패턴**: `<div id="root"></div>` 하나만 두고 JS가 전체 DOM을 그리는 SPA — JS 막히면 빈 화면(무빌드·progressive enhancement 위반). 웹앱이라도 **핵심 화면은 정적 HTML로 먼저 그리고** JS로 인터랙티브화한다.

```html
<!-- 좋음: 정적으로 읽히고, JS는 검증만 향상 -->
<form action="#" method="post" novalidate>
  <label for="email">이메일</label>
  <input id="email" name="email" type="email" required
         aria-describedby="email-help">
  <p id="email-help">회사 이메일을 입력하세요</p>
  <button type="submit">보내기</button>
  <!-- noscript: JS 막혀도 안내 -->
  <noscript><p>실시간 검증은 비활성입니다. 형식을 직접 확인해 주세요.</p></noscript>
</form>
```

---

## 9. 결과 폴더 구조 (사람이 알아볼 이름 — dist/.next 금지)

런타임 에이전트가 사용자 폴더에 남기는 **최종 산출물 구조**(spec §1-8단계, §8-9). 빌드 잔재 노출 금지.

```
결과물/                         ← 사용자가 답한 위치
├─ index.html                  ← "여기를 여세요" (더블클릭 진입점)
├─ tokens.css                  ← "이 숫자를 바꾸면 전체 톤이 바뀝니다" (편집 지점, SSOT)
├─ assets/
│  ├─ reset.css
│  ├─ app.css                  ← 컴포넌트 스타일(토큰만 참조)
│  ├─ app.js                   ← (웹앱 도메인만) 향상 전용 JS
│  ├─ fonts/                   ← (있을 때만) Pretendard-*.subset.woff2
│  ├─ vendor/                  ← (importmap 쓸 때만) *.module.js 로컬 동봉
│  └─ img/                     ← 인라인 못 하는 이미지(가능하면 SVG 인라인)
├─ samples/                    ← (샘플 갤러리 동의 시) 시안별 페이지 + 메인 갤러리
│  ├─ index.html               ← side-by-side 비교 갤러리(iframe + 정적 링크 폴백)
│  ├─ sample-editorial.html
│  ├─ sample-luxury.html
│  └─ sample-minimal.html
├─ 편집가이드.md                ← 비개발자용: "색 바꾸기=tokens.css 3번째 줄" 1장
├─ 검증요약.md                  ← 신호등 + A(실측 항목)/B(구조적 보장) 2칸 (non-dev-copy §7)
└─ a11y-report.md              ← 접근성 실측 결과(자동 보정 내역 포함)
```

**규칙**:
- `index.html`은 **루트 최상단**(더블클릭 발견성). 한글 안내 파일명 허용(`편집가이드.md`).
- `dist/`, `.next/`, `node_modules/`, `package.json`, 해시 파일명(`app.a3f9.js`) **노출 금지** — 빌드 흔적은 비개발자를 혼란시키고 무빌드 약속을 깬다.
- `tokens.css`만 루트에 따로 둬 "한 곳만 바꾸면 전체가 바뀐다"를 물리적으로 보여준다(spec §8-8).
- `samples/`는 갤러리 동의 시에만 생성. iframe 미리보기 + 정적 링크 폴백 병행(file:// 제약, spec §9-4).

---

## 10. 성능 예산 측정 (LCP<2.5s / CLS<0.1 / INP<200ms)

완료 조건(spec §1-6단계, 01-debate §78 "실측 없는 '동작할 것'은 미완성"). 무빌드·dev-only 환경 제약(spec §9-2)을 고려한 **사다리식 측정 fallback**.

### 10.1 측정 사다리 (위에서부터 시도, 막히면 아래로)

1. **Chrome DevTools Lighthouse(권장)**: 브라우저에서 `index.html`을 열고 F12 → Lighthouse 탭 → Analyze. LCP/CLS/INP(또는 TBT) 수치 확인. 설치 0.
2. **Lighthouse CLI**(node 있을 때): `npx lighthouse <파일경로> --only-categories=performance --view`.
3. **PageSpeed Insights**(배포 URL 있을 때만): file://은 측정 불가 — Confluence/사내 호스팅된 경우만.
4. **수동 체크리스트(최후 fallback, 항상 가능)**: 아래 §10.3. axe/Playwright 미설치(WSL2/Windows) 시 이 경로로 보고서를 채운다.

### 10.2 지표가 뜻하는 것(비개발자 번역)

| 지표 | 한 줄 뜻 | 목표 | 깨질 때 흔한 원인 |
|------|---------|------|------------------|
| **LCP** | 가장 큰 내용이 화면에 뜨는 시간 | < 2.5초 | 큰 이미지/비디오(Tier 2), 폰트 로드 지연 |
| **CLS** | 로딩 중 화면이 덜컥 밀리는 정도 | < 0.1 | 이미지 `width/height` 미지정, 폰트 swap 시 폭 변동 |
| **INP** | 클릭에 반응하는 빠르기 | < 200ms | 무거운 JS, 메인 스레드 블로킹 |

### 10.3 무빌드 성능 자가 체크리스트 (실측 안 될 때 BLOCK 판정 기준)

```
[ ] 이미지에 width/height 또는 aspect-ratio 지정 (CLS 방지)
[ ] 폰트 font-display:swap + 폴백 스택 폭 유사 (CLS 방지)
[ ] Tier 2(비디오/그레인/패럴랙스) 미사용 또는 폴백+예산 확인 완료
[ ] JS 총량 경량(importmap vendor 합계 ≤ ~60KB 권장), 메인 스레드 장기 작업 없음
[ ] 외부 네트워크 요청 0건(전부 로컬 동봉) → file://에서 0 latency
[ ] 콘솔 에러·404 0건 (DevTools Console·Network 탭으로 육안 확인)
[ ] 첫 화면이 JS 없이도 즉시 보임(progressive enhancement) → 사실상 LCP 즉시
```

> 무빌드 + 전부 로컬 동봉이면 네트워크 지연이 없어 LCP/INP는 대개 자동 통과한다. **실질 위험은 CLS(레이아웃 밀림)와 Tier 2 장식**이므로 거기에 점검을 집중한다. 결과는 `검증요약.md`에 적되 **실측 여부에 따라 칸을 가른다**(`non-dev-copy.md` §7 A/B): 실제 LCP를 쟀으면 A에 "○초 안에 뜸", 안 쟀으면 B에 "외부 요청이 없어 열면 곧바로 보이도록 설계"로. CLS(화면 밀림)는 육안 확인했으면 A.

---

## 11. 산출 직전 무빌드 자가 점검 (이 파일 책임 범위의 BLOCK 항목)

무결성 게이트(spec §7)에서 이 파일이 담당하는 항목. 하나라도 위반이면 고친 뒤 재산출.

```
[ ] index.html 더블클릭(file://)으로 빈 화면 없이 열림
[ ] 인터넷 차단 상태에서도 한글·레이아웃·차트 정상 (오프라인 동봉 확인)
[ ] tokens.css 한 파일 수정만으로 색/타이포 전체가 바뀜 (raw hex/px 컴포넌트 직박기 0)
[ ] reset → tokens → app 로드 순서 유지
[ ] word-break:keep-all + line-height≥1.6 한국어 본문 적용
[ ] 320px 폭에서 가로 스크롤 0 (scrollWidth ≤ innerWidth) — auto-fit 그리드는 minmax(min(Nrem,100%),1fr), 고정폭 요소는 max-width:100% (§2.2)
[ ] @media print 존재(보고서/C레벨/PPT 도메인) — 흑백·A4·페이지분할 확인
[ ] prefers-reduced-motion: reduce 시 모든 모션 0
[ ] JS 막아도 정적 HTML로 콘텐츠 읽힘 (SPA 빈 root div 금지)
[ ] 결과 폴더에 dist/.next/node_modules/package.json 잔재 0건
[ ] 성능: 콘솔 에러·404 0건, CLS 유발 요소(이미지 치수 미지정) 0건
```

이 점검을 통과하면 비개발자에게 "초록 — 더블클릭하면 바로 열립니다, 인터넷 없어도 글자 안 깨집니다"로 보고한다(spec §8-5 신호등 카피).

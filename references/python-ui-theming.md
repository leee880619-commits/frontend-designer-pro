# python-ui-theming — Python 웹앱(Streamlit/Gradio/Dash/FastAPI) 테마 주입 (도메인 4.6)

> **언제 Read하나**: 도메인 4.6(Python 웹앱) 분기의 단계 6 산출 시. 신규 제작·기존 앱 개선 둘 다.
> **왜 별도 분기인가**: Streamlit/Gradio/Dash는 파이썬 서버가 런타임에 **자체 DOM**을 생성한다. 단일 `index.html`을 더블클릭으로 건네는 무빌드 모델이 성립하지 않으므로, 산출물은 "HTML 파일"이 아니라 **프레임워크 테마 슬롯에 1회 주입하는 토큰·CSS·테마 객체**다. 이 문서는 그 전달 벡터를 프레임워크별로 정의한다.
> **불변 원칙(다른 도메인과 공유)**: 토큰은 OKLCH 앵커에서 파생한 **CSS 변수**가 SSOT(`token-system.md`·`color-token-contract.md`), 대비는 **APCA AND WCAG 이중 게이트**(`color-token-contract.md` §3), a11y 1급 토큰(focus.ring·motion.duration·motion.reduce·target.size.min)은 살아 있어야 한다(`a11y-checklist.md`). 프레임워크가 달라도 이 하한선은 면제되지 않는다.

---

## 0. 공통 모델 — "토큰 1벌 → 프레임워크 슬롯에 매핑"

산출의 중심은 **프레임워크 비종속 토큰 1벌**이다. 이걸 만들고(단계 5 정규화와 동일), 프레임워크별 "테마 슬롯"에 **1회** 흘려넣는다. 흩뿌린 인라인 스타일·위젯별 개별 CSS는 금지(유지보수 불가 = AI slop).

```css
/* design-tokens.css — 프레임워크 비종속 SSOT (모든 Python 분기 공통) */
:root{
  /* reference (OKLCH 앵커에서 파생 — color-token-contract.md) */
  --brand-h: 255; --brand-c: 0.11;
  --bg:        oklch(0.99 0.005 var(--brand-h));
  --surface:   oklch(0.97 0.008 var(--brand-h));
  --text:      oklch(0.25 0.02  var(--brand-h));   /* 본문: 배경과 APCA Lc≥75 AND WCAG 4.5:1 */
  --text-muted:oklch(0.45 0.02  var(--brand-h));   /* 보조: Lc≥60 */
  --primary:   oklch(0.55 var(--brand-c) var(--brand-h));
  --primary-ink: oklch(0.99 0.01 var(--brand-h));  /* primary 위 텍스트 */
  --danger:    oklch(0.55 0.16 25);
  --ok:        oklch(0.60 0.13 150);
  /* a11y 1급 (누락 시 토큰 lint BLOCK) */
  --focus-ring-color: oklch(0.55 0.18 255);
  --focus-ring-width: 2px; --focus-ring-offset: 2px;
  --motion-duration-fast: 120ms; --motion-duration-base: 200ms;
  --motion-reduce: 1;            /* reduced-motion 시 0 — duration을 직접 0으로 바꾸지 말 것(_contract.md 정석) */
  --target-size-min: 24px;       /* 권장 44px */
  /* hex 폴백(@supports 없는 구형 대비는 색채과학 렌즈가 동반 생성) */
}
/* reduced-motion은 duration 토큰 재정의가 아니라 --motion-reduce 곱셈으로 끈다(token-system.md 패턴):
   transition-duration: calc(var(--motion-duration-base) * var(--motion-reduce)); */
@media (prefers-reduced-motion: reduce){ :root{ --motion-reduce: 0; } }
```

> 라이트/다크는 reference 스왑 1회(`token-system.md`). `prefers-color-scheme` 또는 프레임워크 테마 토글에 매핑한다.

---

## 1. Streamlit

두 슬롯을 **함께** 쓴다: ⓐ 위젯 기본색은 `config.toml [theme]`, ⓑ 세밀한 부분은 `st.markdown`으로 CSS 변수 1회 주입.

### ⓐ `.streamlit/config.toml` — 위젯 기본 테마
```toml
[theme]
base = "light"
primaryColor          = "#5b5fd6"   # --primary (oklch→hex 변환값; 색채과학 렌즈가 산출)
backgroundColor       = "#fcfcff"   # --bg
secondaryBackgroundColor = "#f3f3fb" # --surface
textColor             = "#2e2e3a"   # --text  (backgroundColor와 APCA Lc≥75 AND 4.5:1 확인)
font = "sans serif"                  # 한국어는 ⓑ에서 Pretendard 스택 주입
```
> config.toml 색은 **hex만** 받는다. OKLCH 앵커에서 파생한 최종값을 hex로 굳혀 넣되, 그 hex가 대비 게이트를 통과하는지 `_audit.html`로 렌더 화면에서 재측정한다.

### ⓑ `assets/custom.css` + 1회 주입 — CSS 변수·폰트·포커스·상태
```python
# app.py 최상단에서 단 한 번 호출 (페이지마다 반복 호출 금지)
from pathlib import Path
import streamlit as st

def inject_theme():
    css = Path(__file__).parent.joinpath("assets/custom.css").read_text(encoding="utf-8")
    st.markdown(f"<style>{css}</style>", unsafe_allow_html=True)

st.set_page_config(page_title="…", layout="wide")
inject_theme()
```
```css
/* assets/custom.css — design-tokens.css 내용 + Streamlit 셀렉터 매핑 */
/* (위 :root 토큰 블록을 여기 맨 위에 붙여넣는다) */
html, body, [class*="css"]{ font-family:"Pretendard", system-ui, sans-serif; word-break:keep-all; line-height:1.6; }
.stApp{ background:var(--bg); color:var(--text); }
.stButton>button{ background:var(--primary); color:var(--primary-ink); border-radius:8px; min-height:var(--target-size-min); transition:filter calc(var(--motion-duration-fast) * var(--motion-reduce)); }
.stButton>button:hover{ filter:brightness(1.05); }
:focus-visible{ outline:var(--focus-ring-width) solid var(--focus-ring-color); outline-offset:var(--focus-ring-offset); }  /* Streamlit 기본 포커스는 약하다 — 반드시 보강 */
.stAlert{ border-radius:8px; }  /* st.error/st.warning/st.success 컨테이너 */
```

### 위젯 상태 디자인 매핑 (8상태를 Streamlit 어휘로)
| 의미 상태 | Streamlit 구현 | 디자인 주의 |
|-----------|----------------|-------------|
| loading | `st.spinner("불러오는 중…")` / `st.progress` | 스피너 색=`--primary`, 텍스트 대비 확인 |
| error | `st.error(msg)` | `--danger`만으로 구분 금지 — 아이콘·라벨 병행(CVD) |
| empty | 빈 결과 시 `st.info("아직 데이터가 없어요")` 플레이스홀더 | 회색 박스 방치 금지(anti-slop) |
| success | `st.success` / `st.toast` | `--ok` + 체크 아이콘 |
| disabled | `st.button(..., disabled=True)` | 대비 Lc≥30 유지(완전 회색 금지) |

---

## 2. Gradio

`gr.themes.Base(...)`로 토큰을 잡고, 못 닿는 부분만 `css=`로 보강.

```python
import gradio as gr
theme = gr.themes.Base(
    primary_hue=gr.themes.colors.indigo,     # 또는 set()로 직접 지정
    neutral_hue=gr.themes.colors.slate,
    font=[gr.themes.GoogleFont("Noto Sans KR"), "system-ui", "sans-serif"],
).set(
    body_background_fill="#fcfcff",          # --bg
    body_text_color="#2e2e3a",               # --text (대비 게이트 통과 hex)
    button_primary_background_fill="#5b5fd6",# --primary
    button_primary_text_color="#fcfcff",     # --primary-ink
    block_radius="10px",
)
custom_css = """
:root{ /* design-tokens.css 의 :root 블록을 그대로 */ }
*{ word-break:keep-all; }
:focus-visible{ outline:2px solid var(--focus-ring-color); outline-offset:2px; }
.error{ } /* gr.Error 토스트는 --danger + 아이콘 */
@media (prefers-reduced-motion: reduce){ *{ animation:none!important; transition:none!important; } }
"""
with gr.Blocks(theme=theme, css=custom_css) as demo:
    ...
```
| 상태 | Gradio | 주의 |
|------|--------|------|
| loading | `gr.Progress()` / `queue()` 진행 표시 | 진행바 대비 |
| error | `raise gr.Error("…")` | 빨강 단독 금지 |
| empty | 컴포넌트 `value=` 플레이스홀더 | |

---

## 3. Dash

`assets/` 폴더의 CSS는 Dash가 **자동 로드**한다(주입 코드 불필요). dash-bootstrap-components(dbc)와 함께 토큰을 CSS 변수로.

```
your_dash_app/
├─ app.py
└─ assets/
   ├─ 00-tokens.css   ← design-tokens.css 의 :root 블록 (파일명 알파벳순 로드)
   └─ 10-theme.css    ← 컴포넌트 매핑
```
```css
/* assets/10-theme.css */
body{ background:var(--bg); color:var(--text); font-family:"Pretendard",system-ui,sans-serif; line-height:1.6; }
.btn-primary{ background:var(--primary); border-color:var(--primary); color:var(--primary-ink); }
:focus-visible{ outline:2px solid var(--focus-ring-color); outline-offset:2px; }
```
```python
import dash, dash_bootstrap_components as dbc
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP])  # assets/*.css 는 자동 로드
```
> 차트(plotly)는 `chart-decision.md` 원칙 적용 — 결론형 takeaway title, 같은 변수=같은 색, CVD 안전 팔레트, 축 정직성. plotly `template`에 토큰 색을 매핑한다.

---

## 4. FastAPI (+ Jinja / HTMX)

이 분기는 **무빌드 HTML 모델에 가장 가깝다**. 서버는 라우팅만 하고, 템플릿이 정적 HTML을 렌더하므로 `tokens.css`를 그대로 `<link>`로 건다.

```
app/
├─ main.py
├─ static/
│  ├─ tokens.css        ← design-tokens.css 그대로 (다른 도메인과 동일)
│  └─ app.css
└─ templates/
   ├─ base.html
   └─ page.html
```
```html
<!-- templates/base.html -->
<!doctype html><html lang="ko"><head>
  <meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/static/tokens.css">
  <link rel="stylesheet" href="/static/app.css">
</head><body>
  <a class="skip-link" href="#main">본문으로 건너뛰기</a>
  <main id="main">{% block content %}{% endblock %}</main>
</body></html>
```
> FastAPI 분기는 `build-boilerplate.md`(무빌드 골격)·`a11y-checklist.md`(skip link·landmark·focus)·`chart-decision.md`(인라인 SVG 차트)를 **그대로** 쓴다. HTMX 부분 교체(`hx-swap`)가 있으면 교체 영역에 `aria-live` + 포커스 이동을 둔다(동적 DOM 교체 a11y, `a11y-checklist.md`).

---

## 5. 기존 앱 개선 절차 (improve — 전신 `improve-ui`가 하던 일)

사용자가 **이미 동작하는** Streamlit/Gradio/Dash/FastAPI 앱의 룩을 올려달라고 하면:

1. **읽기**: `Glob`/`Read`로 진입점(`app.py`·`main.py`)·기존 `.streamlit/config.toml`·`assets/`·`templates/`를 파악. 프레임워크·현재 색/폰트·위젯 사용 목록·문제(저대비·기본폰트 방치·상태 미설계)를 식별.
2. **합의**: art brief 1페이지(단계 1~2)로 목표 룩을 그림으로 합의. 기존 스크린샷이 있으면 before로 둔다.
3. **패치(로직 불변)**: 위 §1~§4 중 해당 프레임워크의 **테마 슬롯에만** 토큰을 주입. **파이썬 로직·데이터 흐름·컴포넌트 구조는 건드리지 않는다.** 변경은 (테마 파일 + 단일 주입 1줄)로 끝낸다.
4. **원본 보존**: 기존 테마/CSS는 `_legacy/`로 사본 보존(SKILL §9-10). 되돌릴 수 있게.
5. **검증**: 앱을 실제로 띄워(`streamlit run`/`python main.py`) **렌더된 화면 기준**으로 §7 무결성 게이트 적용 — 위젯 기본 대비까지 `_audit.html`/DevTools APCA로 측정, 키보드 주행, CVD 3종. 무빌드 더블클릭 항목만 면제, 나머지 BLOCK은 동일.
6. **인계**: "바꾼 파일 + 적용·실행법(예: `streamlit run app.py`) + 신호등"으로 보고. before/after 한 장이 있으면 첨부.

---

## 6. 프레임워크별 a11y·대비 주의 (게이트는 동일 적용)

- **프레임워크 기본 테마는 대비 미달이 잦다** — 특히 muted 텍스트·placeholder·disabled. 기본값을 신뢰하지 말고 렌더 화면에서 재측정.
- **포커스 표시가 약하거나 제거돼 있다** — Streamlit/Gradio는 `:focus-visible`을 명시 보강(2px·대비 3:1). 절대 `outline:none` 단독 금지.
- **위젯 상태 색이 색 단독 신호**(빨강 에러/초록 성공)인 경우가 많다 — 아이콘·라벨로 이중 인코딩(CVD, `color-token-contract.md` §7).
- **모션**: 프레임워크 기본 트랜지션이 `prefers-reduced-motion`을 무시할 수 있다 — CSS로 `animation/transition:none` 강제 폴백.
- **한국어**: 프레임워크 기본 폰트 스택에 한글이 없으면 깨진다 — Pretendard/Noto Sans KR + `word-break:keep-all`·`line-height ≥1.6` 주입.

---

## 7. 4.6 BLOCK 요약 (이 분기에서 추가로 보는 것)
- [ ] 토큰이 **프레임워크 비종속 CSS 변수 1벌**로 존재하고, 테마 슬롯에 **1회** 주입됐나(흩뿌린 인라인 스타일 0).
- [ ] config.toml/`gr.themes`/dash assets의 **최종 색이 렌더 화면에서 APCA AND WCAG 통과**(기본 테마 미달 보정 포함).
- [ ] `:focus-visible` 보강, 위젯 상태 색 이중 인코딩, reduced-motion 폴백, 한국어 폰트 — 4종 모두 적용.
- [ ] 기존 앱 개선이면 **파이썬 로직 불변** + `_legacy/` 원본 보존 + 실행법 명시.
- [ ] 산출물은 테마 파일 + 편집가이드 + 검증요약(렌더 기준). `index.html` 더블클릭 핸드오프를 강요하지 않았나.

# 04 — 레드팀 실사 최종 지적사항 (v1.0.1 대상)

> 작성: 2026-06-02 · 방법: 6+α 병렬 레드팀 에이전트 실사 + `frontend-forge` 세션 기록 포렌식 대조
> 원칙: 억지 지적 폐기, 합리적·근거 기반 지적만. 1차 지적은 세션 기록으로 재검증 후 정정.

## 0. 요약

| ID | 지적 | 심각도 | 상태 | 비고 |
|----|------|--------|------|------|
| **F1** | references 경로 런타임 미해결 | 🔴 HIGH | 확정·수정대상 | 설치본에서 재현 |
| **F2** | Python 웹앱 UI(Streamlit/Gradio/Dash/FastAPI) 도메인 부재 | 🔴 HIGH | 확정·수정대상 | 전신 `improve-ui` 능력 미승계 = 회귀 |
| **F3** | 산출물 저장위치 전용 질문 부재 | 🟡 LOW~MED | 확정·수정대상 | 요구사항 4 불완전 |
| **F4** | 첨부파일 "왜/어떻게" 의도 파악 암묵적 | 🟡 LOW | 확정·수정대상 | 요구사항 1 보강 |
| **F5** | dogfood 리포트가 최종 레포에 유실 | 🟡 LOW | 확정·수정대상 | 문서 위생 |

### 정정으로 철회된 1차 지적 (결함 아님)
- **dogfood 미이행** → 철회. 실제로 agent-browser 0.27.1(Chrome 149)로 PASS, 이슈 1건 발견·수정·재검증, `03-dogfood-report.md` 작성됨(다만 최종 레포 유실 → F5).
- **6인 vs 5인** → 철회. 토론 중 "5인 상시 에이전트 → 6 전문가 렌즈 인라인화 + lead/redteam 2 에이전트"로 의도적·문서화된 전환.
- **외부 자산 오케스트레이션 미배선** → 철회. 라이브 호출 순서까지 설계됐으나 최종본은 강건성 위해 자기완결 번들로 의도적 단순화.

---

## F1 — references 경로 런타임 미해결 🔴 HIGH

**증상.** SKILL.md가 `references/X.md`(순수 상대경로)로 ~20회 인용(항상 읽어야 할 `_block-card.md`·`_contract.md` 포함). 그러나 설치본에서:
- SKILL.md: `.../1.0.0/skills/frontend-designer-pro/SKILL.md`
- references: `.../1.0.0/references/` (플러그인 루트, 스킬 디렉토리 밖)
- `${CLAUDE_PLUGIN_ROOT}`·`../`·절대경로 **0건**

**근거.** 캐시본·마켓플레이스본 양쪽에서 references가 스킬 디렉토리 밖에 위치. 바 상대경로는 런타임에 **사용자 cwd 기준**으로 해석되어(claude-code-guide 확인) 설치 후 거의 항상 실패.

**영향.** 자기완결성 전체와 BLOCK 게이트 무력화 가능. 세션 dogfood는 *생성 산출물*만 검증했고 *설치 스킬의 참조 로딩*은 미검증이라 못 잡음.

**수정(확정).** SKILL.md·agents의 모든 `references/...`·`tools/...` 상대경로를 `${CLAUDE_PLUGIN_ROOT}/references/...`로 치환. 디렉토리 구조는 유지(모듈성). 공식 문서 정석.

---

## F2 — Python 웹앱 UI 도메인 부재 🔴 HIGH

**증상.** 사용자 최초 니즈는 FastAPI(+Jinja/HTMX)·Streamlit·Gradio 등 **Python 웹앱 UI 개발 및 개선**을 포함. 그러나:
- "웹앱"(§4.1) 분기는 Streamlit/Gradio를 **탐지 신호로만** 언급하고, 실제 추천 스택은 Vanilla/importmap-React 무빌드 정적 HTML → Streamlit/Gradio 산출물을 **만들 수 없음** = 라우팅 트랩(카테고리 오류).
- 레포 전체에 `fastapi/jinja/htmx/flask/django` **0건**, `streamlit/gradio/dash`는 탐지신호 언급 3건뿐. 프레임워크 테마(`​.streamlit/config.toml`, `gr.themes`, Dash assets, Jinja 템플릿) 가이드 전무.
- "기존 앱 개선" 경로 부재 — 두 에이전트 모두 신규 산출물 생성 지향. 기존 실행 중인 Python UI를 읽고 테마/CSS 제안·적용하는 흐름 없음.

**근본 충돌.** 플러그인 핵심 공리 "무빌드·file:// 더블클릭·서버 없음·package.json 금지"는 Streamlit/Gradio/Dash/FastAPI(런타임에 자체 DOM 생성, 테마객체·CSS주입·서버템플릿으로 커스터마이즈)와 **정의상 반대**. 단일 HTML 핸드오프 모델로는 프레임워크 소유 페이지에 전달 벡터 없음.

**회귀 증거.** 전신 로컬 스킬 `improve-ui`가 정확히 이 일을 했음 — 타깃 "기존 Python 웹앱: Streamlit/Gradio/Dash", 토큰 구현 `.streamlit/config.toml [theme]`·`gr.Theme`·`dbc+CSS변수`, 로딩 `st.spinner`/`gr.Progress`, 상태 `st.error`/`gr.Error` 위젯 매핑, 단일 `styles.css` 1회 주입. 신규 플러그인이 이를 미승계.

**수정 방향(범위는 사용자 결정).** §4에 Python 프레임워크 분기 추가 + 프레임워크 테마/CSS주입 reference 1종 + "기존 앱 개선" 경로. FastAPI+Jinja는 HTML 저작 모델과 가까워 비교적 용이, Streamlit/Gradio는 테마/CSS주입 모델 필요.

---

## F3 — 산출물 저장위치 전용 질문 부재 🟡 LOW~MED

SKILL.md(:81,:278)는 "{사용자가 답한 위치}"에 저장한다 하나, 7문항 게이트 중 산출물 폴더를 묻는 항목이 없음(Q3=전달 매체, Q7=메모 경로). 저장위치가 추론될 뿐 사용자 답변 기반이 아님 → 명시 질문 추가 또는 기본 도출 규칙(예: `docs/{요청명}/`) 단계 8 배선.

## F4 — 첨부 의도(왜/어떻게) 암묵적 🟡 LOW

단계 0이 첨부 md/html에서 콘텐츠 속성(무드·청중 등)은 추출하나, "왜 제공했고 어떻게 활용할지"를 명시 단계/브리프 항목으로 두지 않음 → art-brief에 "첨부 활용 의도" 필드 1줄 추가.

## F5 — dogfood 리포트 유실 🟡 LOW

세션에서 작성된 `docs/03-dogfood-report.md`가 최종 레포에 없음(현 `docs/03`은 `03-landing-art-brief.md`, 03 번호 충돌). dogfood 검증 증거 복원/재커밋 권장.

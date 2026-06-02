# _block-card.md — 하드 게이트 1페이지 카드 (항상 로드 · checklist-first)

> **이 파일의 정체**: 출고를 막는 **하드 BLOCK 게이트만** 한 장에 압축한 카드. SKILL은 **항상** 이 카드를 참조하고, 깊은 references(9종, ≈3,500줄)는 **해당 렌즈/단계에 진입할 때만 Read**한다(progressive disclosure). 각 줄은 [판정 기준 · 근거 파일 · **안 지키면 어떤 사용자 손해**]. 손해가 명시돼 누락 비용이 보이므로 적용률이 오른다.
>
> 사용법: 산출 직전 이 카드를 **위에서 아래로 전수 체크**. 하나라도 미충족(BLOCK)이면 교체 후 재산출 — **skip 불가**(mandatory_review). 측정은 `tools/_audit.html`(대비·lint·CVD) + 실행 가능 시 axe/Lighthouse. redteam은 이 카드 + `_audit.html` 표를 입력 증거로 판정한다.

---

## A. anti-slop (미적 하한선) — `anti-slop-checklist.md`
하나라도 걸리면 교체 후 9항목 **전부** 재점검.

| # | BLOCK 판정 | 안 지키면 사용자 손해 |
|---|-----------|----------------------|
| A1 | 보라→파랑 그라데이션 on 화이트(제네릭 SaaS 룩) | "AI가 5초 만에 찍은 티" — 신뢰·전문성 즉시 하락 |
| A2 | Inter·Roboto·system 기본폰트 방치(의도 0) | 흔한 화면과 구분 안 됨, 브랜드 인상 0 |
| A3 | 균등 3카드 그리드(위계 없는 나열) | 무엇이 중요한지 안 보임, 읽는 순서 상실 |
| A4 | 의미 없는 이모지 아이콘 장식 | 유치함, 임원·격식 맥락 신뢰 훼손 |
| A5 | 가운데정렬 hero + 제네릭 일러스트 | "템플릿 그대로" 인상, 내용보다 장식이 큼 |
| A6 | 톤 없는 순회색(#888) 박스 남발 | 죽은 화면, 색온도·계위 부재 |
| A7 | accent 3색+ 남발(60-30-10 위반) | 시선 분산, 강조가 강조 아니게 됨 |
| A8 | 명사구 차트 제목("월별 매출 추이") | 독자가 결론을 스스로 찾아야 함(takeaway 부재) |
| A9 | 무의미 통통 모션·무한 애니메이션 | 산만·피로, reduced-motion 사용자 배제 |
| A-meta | 위 교체에 **의도성 증거 1문장**(왜 이 선택인지) 부재 | 다시 슬롭으로 회귀할 위험 |

## B. 토큰 lint — `token-system.md` §8 / `tools/_audit.html` B
| BLOCK 판정 | 안 지키면 사용자 손해 |
|-----------|----------------------|
| **DANGLING**: `var(--x)`인데 `--x` 미정의 | 색·간격이 깨져 화면 일부가 무색·붕괴 |
| **CIRCULAR**: A→B→A 순환 참조 | 값이 안 풀려 렌더 실패 |
| **HARDCODE**: semantic/component에 날 hex/px(reference·a11y 7키 면제) | "한 곳만 고치면 전체가 바뀐다" 약속 깨짐 — 비개발자 편집 불가 |
| **A11Y-MISS**: a11y 1급 7키 중 누락(`--focus-ring-*`·`--motion-duration-*`·`--motion-reduce`·`--target-size-min`) | 키보드 포커스 안 보임/모션 못 끔/터치 너무 작음 |
| (WARN) ORPHAN·layer-skip | 출고는 가능하나 정리 권고(알림만) |

## C. 대비 — APCA AND WCAG (성역) — `_contract.md` §3 / `color-token-contract.md` §3 / `tools/_audit.html` A
측정 = 전경색 vs **실제 깔린 배경색**(그라데이션/이미지/글래스는 가장 불리한 지점, 스크림 위에서 재측정).

| 역할 | BLOCK 하한(둘 다) | 안 지키면 사용자 손해 |
|------|-------------------|----------------------|
| 본문 | Lc≥75 **AND** 4.5:1 | 작은 글씨가 밝은 회의실·저시력자에게 안 읽힘 |
| 보조 | Lc≥60 AND 4.5:1 | 캡션·메타 정보 유실 |
| 대형/UI(버튼테두리·아이콘·focus·축선) | Lc≥45 **AND** 3:1 | 버튼·포커스·차트 축 식별 불가 |
| 비활성 | Lc≥30 | 비활성인지조차 구분 불가 |

## D. 접근성 골격 + axe·CVD — `a11y-checklist.md` §0 / `tools/_audit.html` C
| BLOCK 판정 | 안 지키면 사용자 손해 |
|-----------|----------------------|
| 검증 실행 증거 부재(`_audit.html`표/axe/Lighthouse/§8.2 수동 8항 중 0개) | "통과"가 거짓일 수 있음(측정 없는 통과 금지) |
| CVD 3종 미시뮬 또는 색만으로 의미 전달(이중인코딩 없음) | 색맹·색약 동료가 그래프·상태 구분 불가 |
| 시맨틱 위계: `<main>` 1개·landmark 없음, h1→h6 레벨 건너뜀 | 스크린리더 사용자 길 잃음 |
| 완전 키보드: 비네이티브 상호작용·`:focus-visible` 부재·`outline:none` 잔존·skip link 없음 | 마우스 못 쓰는 사용자 일부 기능 차단 |
| 포커스 관리: 동적 DOM 교체(모달·탭·토스트)에 트랩+복귀+`aria-live` 없음 | 모달 열어도 포커스 길 잃음, 변화가 안 들림 |
| reduced-motion: `@media (prefers-reduced-motion: reduce)` 모션 0 차단 없음 | 전정장애 사용자 어지럼·메스꺼움 |
| 한국어: 본문 `word-break: keep-all` + `line-height≥1.6` 없음 | 단어 중간 줄바꿈으로 가독 저하 |

## E. 상태 매트릭스 + 메타데이터 — `a11y-checklist.md` §4 / `chart-decision.md`
| BLOCK 판정(도메인별) | 안 지키면 사용자 손해 |
|----------------------|----------------------|
| 웹앱: 8상태(default/hover/focus/active/disabled/loading/error/empty) 누락 | 빈 화면·로딩·에러 때 사용자 멘붕("고장났나?") |
| 정적(보고서·덱): 4상태(기본/강조/비활성/인쇄) 누락 | 인쇄·강조 깨짐 |
| 차트 takeaway title 부재(명사구 제목) | 독자가 결론 못 읽음(A8과 연동) |
| 데이터 정직성: y축 잘림·왜곡인데 미고지 | 의사결정 오도 — 가장 큰 신뢰 손해 |
| 메타데이터 푸터(출처·기준일·n=·가정) 부재 | 수치 신뢰 불가, 재현 불가 |

## F. 무빌드 더블클릭 — `build-boilerplate.md` §1·§9·§11
| BLOCK 판정 | 안 지키면 사용자 손해 |
|-----------|----------------------|
| 빌드 잔재(`dist/`·`.next/`·`node_modules/`·`package.json`·해시 파일명) 결과 폴더 노출 | 비개발자 혼란, 무빌드 약속 위반 |
| dev-only 도구(`tools/_audit.html`·`token-lint.js`·axe·CVD 토글) 사용자 폴더 동봉 | 런타임 비대·혼란 |
| 번들러/트랜스파일 전제(`.jsx`/`.tsx`·webpack/vite·`npm run`) | 더블클릭으로 안 열림 |
| CDN 폰트/라이브러리 단독 의존(폴백·로컬 vendor 없음) | 오프라인·사내망에서 깨짐 |
| `fetch('./data.json')` 등 file:// CORS 깨짐(인라인 JSON 아님) | 더블클릭 시 데이터 0 |
| SPA 빈 root(JS 막히면 빈 화면) | JS 차단 환경서 백지 |
| 도메인 필수 `@media print`(보고서·C레벨·PPT) 부재 | 인쇄·PDF 깨짐 |

## G. 비개발자 카피 — `non-dev-copy.md`
| BLOCK 판정 | 안 지키면 사용자 손해 |
|-----------|----------------------|
| 금지어 노출(OKLCH·APCA·WCAG·Lc·토큰·reference·semantic·CVD·LCP·importmap 등) | 비개발자가 이해 못 함, 소외감 |
| 숫자·도구명 노출("Lc 78"·"4.5:1"·"92점"·"axe") | 전문가 전용처럼 느껴짐 |
| 접근성·대비 결과가 신호등(🟢🟡🔴)+실생활 1줄 없이 표기 | 통과 의미 전달 실패 |
| 최종 보고에 🔴 "자동 보정함"이 **미수정** 잔존 | "고치라는 숙제"로 오해(실은 이미 고침) |
| **미실측 단정**(교차브라우저·LCP를 실측 없이 결과로 단정) | 거짓 안심 — 자기 원칙(측정 없는 통과 금지) 위반 |
| 질문 강요(★추천·"모름→안전"·"나중에 바꿀 수 있어요" 없음) | 비개발자가 답 못 해 막힘 |

---

## 진입 시에만 깊이 Read (progressive disclosure 맵)
> 위 카드로 **무엇이 BLOCK인지**는 항상 안다. **어떻게 고치는지/왜 그런지**가 필요할 때만 아래를 Read.

| 렌즈/단계 진입 | 그때 Read |
|----------------|-----------|
| 미적 방향·anti-slop 교체안 | `aesthetic-directions.md` · `anti-slop-checklist.md` |
| 색 파생·대비 보정 | `color-token-contract.md` · `_contract.md` §3 |
| 토큰 정규화·lint 상세 | `token-system.md` · `_contract.md` §1·§4·§5 |
| a11y 구현(스니펫·fallback) | `a11y-checklist.md` |
| 차트·데이터 정직성 | `chart-decision.md` |
| 산출 골격·무빌드·print | `build-boilerplate.md` |
| 사용자 카피 작성 | `non-dev-copy.md` |
| art brief(상류 SSOT) | `art-brief-template.md` |

> 상수·임계·토큰명의 **확정값**은 언제나 `_contract.md`(단일 소스)가 진실. 카드와 깊은 references가 어긋나면 `tools/kb-consistency-check.sh`가 잡는다.

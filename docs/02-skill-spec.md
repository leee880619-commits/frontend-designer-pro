# 02 — 빌드 청사진 (Skill Spec / SSOT)

> 6인 전문가 토론(라운드1 입장 → 라운드2 교차비판 → 수석 아키텍트 종합)의 **합의 산출물**.
> 이 문서가 모든 빌더 에이전트의 단일 진실원천(SSOT)이다. 모든 파일은 이 스펙에 정합해야 한다.

---

## 0. 설계 철학 (Design Thesis)

frontend-designer-pro는 "비개발자도 전문가급 프론트엔드 산출물을 받는다"는 한 가지 약속을 6인 전문가의 합의된 규율로 보증하는 단일 적응형 플러그인이다. 이 스킬을 전문가급으로 만드는 핵심은 **세 가지 분리**다.

1. **깊이와 단순함의 분리**: OKLCH·APCA·3계층 토큰·8상태 매트릭스 같은 모든 전문 기계는 산출 시점의 백스테이지에서만 돌고, 사용자에게는 그림 갤러리·느낌 단어·신호등 배지·'왜 추천하는지 효과 1문장'만 노출된다. **사용자가 토큰의 존재를 몰라도 결과가 일관되면 성공이다.**
2. **미적 대담함과 접근성의 면적 기반 분리**: 텍스트·UI·의미색은 color-scientist+a11y-lead가 **APCA AND WCAG 이중 게이트의 거부권**을 갖는 성역이고, 텍스트 없는 장식 면(no-text AND no-meaning)은 art brief의 무드 채도를 그대로 산다. 위계는 대비를 깎아서가 아니라 **크기·굵기·여백**으로 만든다.
3. **자기완결과 경량의 위치 분리**: references/에는 텍스트 지식(KB 단위)을 전부 번들해 외부 자산 미설치에도 동작하고, 사용자 산출물에는 **tokens.css 1장 + 인라인 SVG + 서브셋 폰트**만 남겨 무빌드 더블클릭과 런타임 0KB를 지킨다.

**art brief 1페이지가 단일 상류 SSOT**가 되어 color·token·a11y·dataviz가 모두 같은 입력을 받고, 산출 직전 **anti-slop + 토큰lint + APCA + axe를 단일 무결성 게이트**로 통과해야만 출고되는 구조가 "AI가 바로 만든 티"를 제거하고 사람이 의도적으로 다듬은 수준을 강제한다.

---

## 1. 명령 흐름 (Command Flow) — `/frontend-designer-pro` 호출 시 9단계

| # | 단계 | 무엇을 | 비개발자 카피 노트 |
|---|------|--------|---------------------|
| 0 | 진입 & 첨부물 심층 검토 | 메인 세션 진입. 첨부 md/html이 있으면 Read로 깊게 검토해 무드·업종·청중·격식·데이터형태·실행환경 선추출, 도메인 자동 추정. 코드 이해 필요 시 code-researcher 1회 선호출(단독 허용). | "첨부 파일을 먼저 꼼꼼히 읽고 시작합니다 — 그림이 그려지면 질문 수를 줄여드립니다." |
| 1 | **질문 게이트(무조건·1회 묶음)** | AskUserQuestion 한 번에 핵심 4~5개만 객관식+★추천 디폴트: ①도메인 확인 ②미적 방향(썸네일 갤러리) ③실행환경(더블클릭/사내공유/개발팀인계) ④받는사람·열람환경 ⑤시각장애 동료도 보나요. 색·접근성·토큰은 안 묻고 자동 파생. 마지막에 'Q&A·맥락을 결과 폴더에 md로 남길까요? 경로는?' 질문. | "딱 한 번, 꼭 필요한 것만 그림과 객관식으로. '알아서 해주세요'를 골라도 전문가 기본값으로 최고 품질. 안 골라도 안전합니다." |
| 2 | 의도 판단 & **art brief(SSOT) 작성** | 도메인 확정 + 미적 방향 2~3개로 좁힘. Design Concept 1페이지: 무드 키워드 3개·연상 레퍼런스·하지 말 것 3개 + 대비 거부권 표면 지도(텍스트/의미색=성역, 장식=무드 자유) + 모션 예산(1회·≤250ms·reduced-motion 0) + expression/data zone 경계. | "'어떤 느낌으로 갈지'를 한 장으로 정리. 이 한 장이 색·글꼴·레이아웃 전부의 기준이라 톤이 들쭉날쭉해지지 않습니다." |
| 3 | 샘플 N개 제안 여부 질문 | '서로 다른 성격의 시안 N개를 나란히 비교해 보시겠어요?'(기본 추천 3개). 동의 시에만 4단계, 생략 시 art brief로 본 작업 직행. | "여러 분위기를 나란히 놓고 그림으로 고르실 수 있게 해드릴까요? 시간이 더 걸리지만 후회가 적습니다. 건너뛰어도 됩니다." |
| 4 | (선택) **샘플 갤러리 생성** | N개 시안을 '진짜 다른 personality'(색만 바꾼 변주 금지)로 각각 경량 대표화면 1장씩 무빌드 생성. 임시/예시 데이터. 메인 갤러리 index.html이 iframe/링크로 나란히 비교(헤드리스 캡처 불필요). 각 시안에 성격 한 줄+추천 용도+주의점+A11y 신호등 배지+토큰 요약. 탐색 단계라 시안별 독립 토큰셋 허용. | "예시 데이터로 채운 시안들을 한 화면에서 비교. '빠르게 훑기 좋음/설득에 강함' 같은 쉬운 설명과 '잘 읽힘 ✓' 배지." |
| 5 | 시안 확정 & 토큰 정규화 | 1개 선택(또는 샘플 생략 시 art brief 추천안). 이때만 design-system-architect의 reference→semantic 2계층 SSOT 정규화: reference만 선택 시안 값으로 고정, semantic/component 불변. color-scientist가 OKLCH 앵커에서 램프 파생, a11y 1급 토큰(focus.ring, motion.duration, target.size.min)을 semantic에 배치. | "고르신 시안의 색·글꼴을 '한 곳만 바꾸면 전체가 바뀌는' 구조로 정리. 나중에 색 바꾸려면 딱 한 줄만." |
| 6 | **도메인 분기 본 작업 산출** | 도메인별 주도 전문가 조합으로 풀 산출: 무빌드 골격→tokens.css 주입(raw hex 금지)→상태 매트릭스(웹앱 8/정적 4)→차트는 인라인 SVG→takeaway title·메타데이터 푸터→성능 예산(LCP<2.5s/CLS<0.1/INP<200ms)→크로스브라우저·인쇄·반응형·한국어 keep-all. | "고르신 방향대로 실제로 열리는 결과물을. 웹앱·보고서·발표자료 종류에 딱 맞는 방식으로." |
| 7 | **산출 직전 단일 무결성 게이트(BLOCK)** | anti-slop 체크리스트 + 토큰 lint(dangling/순환/고아/하드코딩 hex·px) + APCA AND WCAG 대비표 + axe-core 실측 + CVD 3종 시뮬레이션을 단일 '디자인 시스템 무결성 리포트'로 통합. 하나라도 위반이면 교체 후 재산출, **skip 불가**. dev-only 도구는 검증 시점에만 주입, 사용자 폴더 미포함. | "내보내기 전 '잘 읽히는지, AI 티 안 나는지, 색맹 동료도 구분되는지' 자동 전수 점검하고, 문제 있으면 알아서 고친 뒤 완성. 사용자가 숙제를 떠안지 않습니다." |
| 8 | 저장 & 비개발자 인계 보고 | 사용자가 답한 위치에 index.html(여기를 여세요)·tokens.css·assets/·samples/·편집가이드1장·검증요약1장·a11y-report.md. 빌드 잔재(dist/.next) 노출 금지. 최종 보고는 신호등+실생활 1줄 효익+'더블클릭하면 열립니다'. | "원하시는 폴더에 사람이 알아볼 이름으로 저장. '여기를 여세요' 파일과 '이 숫자를 바꾸세요' 가이드를 함께. '브라우저 4종 깨짐 없음, 2초 내 로딩, 오류 0건' 식 보고." |

---

## 2. 질문 게이트 (Question Gate)

### 원칙
- **질문 먼저는 무조건** — 아무리 간단한 요청도 건너뛰지 않는다. 단 '무조건 질문'을 '무조건 답 강요'로 해석하지 않는다: 질문은 하되 **★추천 디폴트가 미리 선택**돼 있어 넘겨도 전문가 기본값으로 흐른다.
- **1회·묶음·그림·안전한 디폴트**. AskUserQuestion 한 번에 핵심 4~5개만(피로도 통제).
- 취향이 결과를 가르는 지점(도메인·미적 방향·실행환경·청중)에만 능동 질문. **품질 하한선(대비·키보드·반응형·reduced-motion·60-30-10·CVD안전·다크모드 파생)은 절대 질문하지 않고 secure-by-default 상시 적용** — 끄려면 명시적 거부 필요.
- 도메인 자동 추정 후 '이거 맞죠?' 1문항으로 시작 → 백지 질문 0개.
- 첨부 md/html은 깊게 검토해 답을 선추출 — 이미 아는 것은 다시 묻지 않는다.
- **데이터 정직성에 영향을 주는 결정(문화적 색 의미, 축 잘림 허용)만은** 피로도보다 신뢰성 우선이라 명시 동의 필수 — 건너뛸 수 없는 유일한 예외.
- Q&A·맥락 결과를 결과 폴더에 md로 남길지(경로·생성 여부 포함)를 질문 후 결정.

### 비개발자 규칙 (non_dev_rules)
- 전문용어는 괄호 일상어 병기 필수: '에디토리얼(잡지 레이아웃 느낌)', '럭셔리(여백 많고 절제된 고급 느낌)', '브루탈리즘(거칠고 강한 인쇄물 느낌)'. **APCA/OKLCH/토큰/reference/semantic은 질문 본문에 절대 단독 노출 금지.**
- 모든 선택지에 '왜 추천하는지'를 기법이 아니라 **결과·효과로 1문장**: '임원이 신뢰감을 느끼도록 여백과 차분한 색을 씁니다'.
- 항상 ★추천 디폴트 하나 + '나중에 바꿀 수 있어요' 명시.
- 선택은 '값 입력'이 아니라 '추천안 중 고르기'. 색 hex·토큰명·좌표를 묻지 않고 느낌 단어+스와치 썸네일.
- '모름/알아서'가 항상 안전한 길로 흐르게.
- 질문 본문은 기법이 아니라 결과로: 'React가 좋을까요?'(X) → '클릭하면 바로 열리는 단일 파일이 편하세요, 아니면 개발팀이 이어받나요?'(O)

### 예시 질문 (카피 톤 레퍼런스)
1. **[도메인 확인]** "첨부 내용을 보니 임원 보고용 자료 같습니다. 맞을까요? (예 ★ / 아니요-웹앱 / 아니요-발표 슬라이드) — 임원 보고서는 화려함보다 신뢰감·가독·절제를 우선해 만듭니다."
2. **[미적 방향]** "아래 그림 중 마음에 드는 느낌을 골라주세요. (★에디토리얼=잡지 레이아웃 / 럭셔리=여백 많고 절제된 고급 / 미니멀=깔끔하고 군더더기 없는) — 임원이 신뢰감을 느끼도록 ★를 추천. 나중에 바꿀 수 있어요."
3. **[실행환경]** "결과물을 어떻게 쓰실 건가요? (★클릭하면 바로 열리는 단일 파일 / 사내 공유드라이브·Confluence / 개발팀이 코드로 발전) — 대부분 ★ 추천. 터미널 없이 더블클릭."
4. **[열람 환경]** "주로 어디서 보게 되나요? (임원 휴대폰 / 발표장 빔프로젝터 / 종이 인쇄 / 모름→다 대응) — 보는 곳에 맞춰 글씨 크기·대비 조정."
5. **[접근성 대상]** "이 자료를 시각장애가 있는 동료도 보게 되나요? (예 / 아니요 / 모름→안전하게 예) — 예로 두면 밝은 회의실 빔·저시력 동료에게도 또렷. 추가 비용 없음."
6. **[샘플 여부]** "서로 다른 분위기 시안 3개를 나란히 비교해 보시겠어요? (★예 / 아니요-추천안 바로) — 시간이 조금 더 걸리지만 후회가 적습니다."
7. **[기록 저장]** "Q&A와 방향을 결과 폴더에 메모(.md)로 남겨둘까요? (예-결과폴더 / 예-경로지정 / 아니요) — 나중에 왜 이렇게 만들었는지 되짚기 좋습니다."

---

## 3. 샘플 갤러리 (Sample Gallery)

- **언제**: 질문 게이트(3단계)에서 사용자가 '시안 비교'에 동의했을 때만. 생략 시 art brief 추천안으로 직행. 단순 요청이라도 **제안은 항상 하되 강제 금지**.
- **기본 개수**: 3개(★). 2~4개 조정 가능. 5개 이상은 비교 피로로 비권장.
- **구조**: 각 시안 = 서로 진짜 다른 미적 방향(에디토리얼/럭셔리/브루탈리즘 등, 색만 바꾼 변주 금지) 대표 화면 1장씩 경량 무빌드 HTML. 임시/예시 데이터. 탐색 단계라 시안별 독립 토큰셋 허용(다양성 우선). 선택된 1안만 본 작업에서 풀 산출+SSOT 정규화 → **'탐색은 자유, 양산은 표준' 2단 비용 구조**.
- **제시**: 메인 갤러리 index.html이 각 경량 시안을 iframe/정적 링크로 나란히(side-by-side) — 스냅샷 안 굽고 헤드리스 캡처 불필요. 각 시안 카드에 ①성격 한 줄 ②추천 용도 ③주의점 ④A11y 신호등 배지(대비·키보드·반응형) ⑤토큰 요약('brand=네이비, 본문=Pretendard'). 클릭→해당 샘플 페이지. **file:// 제약 대비 정적 링크 폴백 항상 병행.**

---

## 4. 도메인 매트릭스 (5)

> 공통: art brief 종속, anti-slop + 무결성 게이트 모든 도메인 적용, 한국어 keep-all/줄간격 하한선, 무빌드 더블클릭.

### 4.1 웹앱(프론트엔드)
- **탐지**: 로그인/대시보드/폼/CRUD/실시간, 상태 변화·입력·라우팅, Streamlit/Gradio/React/Vue 언급, '화면·페이지·앱·서비스'.
- **추천 스택**: 정적·상태 적음=Vanilla+inline JS(Web Components/Alpine류). 복잡 상태·실시간=React/Vue/Svelte를 **importmap 무빌드 경로 우선**. 토큰은 순수 CSS custom property. **React 기본값 고정 금지** — 의도·복잡도 판단 후 컨펌.
- **비개발자 설명**: "사람들이 클릭하고 입력하며 실제로 '쓰는' 화면입니다 — 버튼을 누르면 반응하고, 폼을 채우면 처리됩니다."
- **주도**: frontend-implementation-engineer · design-system-architect · a11y-ux-lead · art-director
- **품질 기준**: 인터랙티브 8상태 전수 / 완전 키보드+2px focus-visible(대비3:1)+skip link / LCP<2.5s·CLS<0.1·INP<200ms 실측 / 320px 모바일퍼스트 무가로스크롤·터치≥24px(권장44)·텍스트200% reflow / 동적 DOM 교체에만 포커스트랩+복귀+aria-live / axe 위반 BLOCK 0건.

### 4.2 공유용 분석 보고서
- **탐지**: 데이터·지표·분석·추이, 여러 사람이 읽는 문서·차트/표 다수, '리포트·분석·현황', 출처·기간·표본 메타.
- **추천 스택**: Vanilla HTML + 인라인 SVG 차트(런타임 0KB). @media print A4. 인터랙션은 2조건(정적 불가 밀도 + 정적 폴백 존재) 충족 시만 경량 라이브러리(uPlot~40KB) 조건부. SCQA/Pyramid 골격.
- **비개발자 설명**: "여러 동료가 받아 읽으며 '무슨 일이 일어났는지' 데이터로 이해하는 문서입니다 — 차트와 표가 결론을 또렷이 말해줍니다."
- **주도**: dataviz-report-specialist · art-director · a11y-ux-lead · color-scientist
- **품질 기준**: 모든 차트 결론형 takeaway title / 정보 위계 3단(핵심1→근거3~5→부록)·섹션당 1결론 / 차트 색=의미 스케일(순차·발산·범주, CVD안전 8색 이내)+직접라벨+명도분리 이중인코딩 / 모든 차트 스크린리더용 table+caption+th scope 대체본(협상 불가) / 정적 4상태(empty·과다 상위N+'외M건'·결측NA·print분할) / 출처·기준일·n=·가정 메타 푸터 / data zone 절제(3D/그림자/무의미 그라디언트 금지).

### 4.3 C레벨·이그제큐티브 보고서
- **탐지**: 임원·경영진·의사결정·승인·투자, '보고·C레벨·이사회·1페이지 요약', 격식·신뢰감·간결, 결론 먼저(BLUF).
- **추천 스택**: Vanilla HTML + 인라인 SVG. **luxury/restrained 기본**. @media print + PDF 안전(흑백 인쇄 대비 토큰). 보수적 중성 + 절제된 1 accent. 임원 폰 열람 전제 모바일 퍼스트.
- **비개발자 설명**: "결정을 내리는 윗분들이 짧게 보고 판단하는 자료입니다 — 화려함보다 '믿을 만하다'는 인상과 핵심만 또렷한 구조가 생명입니다."
- **주도**: art-director · dataviz-report-specialist · color-scientist · a11y-ux-lead
- **품질 기준**: 신뢰·가독·절제 > 화려함 우선순위를 art brief에 못박음 / BLUF 골격·1페이지 요약 / 보수적 중성+accent 화면당 1~2(60-30-10) / 인쇄·PDF 색역·흑백 대비 안전 / 출처·기준일·n=·가정 메타 / 임원 휴대폰 320px 무손실 / 본문 APCA Lc≥75 AND WCAG 4.5:1.

### 4.4 발표 PPT 덱(HTML)
- **탐지**: 발표·프레젠테이션·슬라이드·덱, 'PPT·슬라이드·발표자료·키노트', 16:9·빔·발표자노트, 슬라이드당 1주장.
- **추천 스택**: Vanilla HTML 16:9 슬라이드(각 슬라이드=section[aria-label]) + 키보드 화살표 네비 + @media print 페이지분할 + 발표자 모드. **editorial-bold 기본**. 빔프로젝터 저대비 대응 대비 상향.
- **비개발자 설명**: "회의실 화면에 띄워놓고 말로 설명하는 발표 자료입니다 — 뒷자리에서도 읽히고, 한 장에 하나의 메시지만 담아 흐름이 명확합니다."
- **주도**: art-director · dataviz-report-specialist · frontend-implementation-engineer · a11y-ux-lead
- **품질 기준**: 슬라이드당 1주장+결론형 제목 / section[aria-label]·figure/figcaption·키보드 화살표 / 빔 저대비 보정 대비 상향 / 스킵링크+슬라이드 키보드 핸들러+발표자노트 시각·스크린리더 동시 / 16:9+@media print 분할 / expression zone(표지·간지) 자유, data zone 절제.

### 4.5 기타
- **탐지**: 위 4개에 명확히 안 맞음, 랜딩·마케팅·이메일·문서 혼합, 도메인 모름/새 유형, 복수 도메인 혼재.
- **추천 스택**: 도메인 자동 추정 후 '이거 맞죠?' 확인 질문으로 분기. **확정 전 코드 한 줄도 안 씀**. 추정 실패 시 가장 가까운 도메인 스택을 ★추천+컨펌. 마케팅 랜딩/설득이면 가독성 하한선 위에서 미적 임팩트 상향 허용.
- **비개발자 설명**: "위 네 가지에 딱 안 들어맞는 경우입니다 — 무엇을 만들고 싶으신지 한 번 더 여쭤 가장 잘 맞는 방식을 찾아드립니다."
- **주도**: art-director · frontend-implementation-engineer · design-system-architect · a11y-ux-lead
- **품질 기준**: 도메인 확정 질문 통과 전 산출 금지(Intent Gate) / 확정 도메인 quality_bar 상속 / 마케팅·설득은 가독성 하한선 위에서만 임팩트 상향 / anti-slop+무결성 게이트 공통.

---

## 5. 런타임 오케스트레이션

> **(v1.4.0 갱신 — `skills/frontend-designer-pro/SKILL.md §5`가 런타임 정본)** mandatory_review는 **경량(light)/본격(full) 2모드로 분기**한다: 경량(단일~소수 화면·정적·예시데이터)은 redteam 왕복 없이 §7 게이트 1회 자가 측정(신호등 🟡 cap + 정직 라벨), 본격(실데이터·동적DOM·웹앱8상태·데이터정직성·C레벨·큰 표면 또는 분류 애매)은 lead↔redteam 독립 ≥2턴 왕복(🟢 가능). 아래 서술은 본격 경로 기준의 설계 청사진이며, 충돌 시 SKILL §5가 우선한다.

- **접근**: 메인 세션은 의도 해석·라우팅·질문·검수·보고만. 대규모 산출은 design-lead-pro에 위임(메인 직접 수행 3파일·500줄 이하). **6인 전문가는 상시 에이전트가 아니라 SKILL.md 내부 '6 전문가 렌즈(lens)' 인라인 체크리스트**로, 단일 design-lead-pro가 순차 적용(컨텍스트 절약). 영구 산출(mandatory_review)이면 TeamCreate로 **design-lead-pro ↔ design-redteam-pro 감사 루프** 강제(BLOCK 왕복 ≥2턴). 샘플 갤러리는 경량이라 메인/lead 단독 가능.
- **병렬화**: 샘플 N개 시안은 독립이라 병렬 생성(완전 병렬 독립). 무결성 게이트 3검증(토큰lint / APCA·WCAG / axe·CVD)은 독립이라 병렬 후 단일 리포트 통합. code-researcher 선호출은 단독 1회 병렬. 복합 도메인은 도메인별 병렬 분기 후 통합.
- **컨텍스트 절약**: 6 렌즈를 6 에이전트로 상시 소환 안 함(인라인화). 대형 위임 run_in_background:true 기본. references/는 에이전트가 필요 시점에만 Read. 산출물 파일이 SSOT라 Team 완료 후 TeamDelete, 대화에 전문 안 실음. 첨부·중간 요약만 메인에, 전문은 파일로 고정.

---

## 6. 자기완결 지식 번들 (references/) — 빌더 제작 지침

| 파일 | 내용 | 추출 출처 |
|------|------|-----------|
| `references/aesthetic-directions.md` | 6~8개 고정 미적 방향(editorial/luxury/minimal/brutalist/soft-modern/technical/editorial-bold) 각각: 한 줄 일상어 설명(괄호 병기)+무드 키워드 3개+대표 폰트페어+핵심 색 성격 1개+레이아웃 컨셉+'이럴 때 추천'+'안 어울리는 경우'+미리보기 인라인 SVG/미니 스냅샷 마크업+도메인별 기본 추천 매핑(웹앱→soft-modern/technical, 분석보고서→editorial, C레벨→luxury, PPT→editorial-bold). 사용자가 코드 안 읽고 그림으로 고르는 갤러리 원천. | art-director |
| `references/anti-slop-checklist.md` | 산출 직전 필수 BLOCK 게이트(skip 불가): 보라 그라데이션 on 화이트 / Inter·Roboto·system 기본폰트 방치 / 균등 3카드 그리드 / 의미없는 이모지 아이콘 / 가운데정렬 hero+제네릭 일러스트 / 톤 없는 회색 박스 / accent 3개+ 남발(60-30-10 위반) / 명사구 차트 제목 / 무의미 통통 모션. 각 항목에 적발 시 구체 교체안. | art-director(6인 통합) |
| `references/art-brief-template.md` | Design Concept 1페이지(SSOT) 템플릿: 무드 키워드 3개·연상 레퍼런스·하지 말 것 3개 + 대비 거부권 표면 지도(텍스트/의미색=성역, 장식 면=무드 자유, no-text AND no-meaning 정의) + 모션 예산(1회·≤250ms·reduced-motion 0) + expression zone vs data zone 경계 + 차트 표현층/인코딩층 분리 계약 + 의도성 증거 슬롯. | art-director(충돌 해소 조항 내장) |
| `references/color-token-contract.md` | OKLCH 앵커(L/C/H)+파생 규칙(L 등간격·C 감쇠·다크모드 별도 램프, HSL lightness 금지). reference 네이밍 규약(color.brand.500 등, 참조되는 5~7단계만·고아 금지). 대비 게이트 **APCA AND WCAG**(본문 Lc≥75 & 4.5:1, 보조 Lc≥60, 대형/UI Lc≥45 & 3:1, 비활성 Lc≥30). oklch() 1차 + @supports not hex 폴백 무빌드 패턴. 60-30-10 맵. CVD 3종+이중인코딩(직접라벨+명도분리 1순위, 패턴은 인쇄/인접 한정). 인라인 SVG feColorMatrix CVD 토글. | color-scientist + color-expert 지식 |
| `references/token-system.md` | 3계층(reference→semantic→component). reference→semantic 2계층 BLOCK(SSOT 최소), component 옵션(경량 모드). a11y 1급 semantic 토큰 승격(focus.ring.{color,width,offset}, motion.duration.{fast,base}, motion.reduce 플래그, target.size.min — 경량서도 생략 불가, 누락 시 lint BLOCK). 차트 독립 네임스페이스 color.viz.{sequential,diverging,categorical.1~8,grid,axis,annotation}. tokens.css=런타임 SSOT(순수 CSS 변수, 빌드0), tokens.json=카탈로그 원본. 다크/고대비/print는 reference 스왑 1회. 50줄 인라인 토큰 lint(dangling/순환/고아/하드코딩 hex·px). | design-system-architect |
| `references/a11y-checklist.md` | 도메인별 a11y(웹앱=폼라벨·aria-describedby·라이브영역 / 보고서=table+caption+th scope·차트 대체텍스트 / PPT=슬라이드 region·키보드네비·발표자노트). APCA AND WCAG 이중 게이트. 시맨틱 landmark+h1→h6 단일위계. 완전 키보드+focus-visible 2px(대비3:1)+skip link. 포커스 관리(동적 DOM 교체에만). 스크림 오버레이 의무(풀블리드·글래스모피즘 위 텍스트, 스크림 위 APCA 재측정). 'no-text AND no-meaning' 장식 자유 정의. 신호등 카피 매핑(초록'잘 읽힘'/노랑'큰글씨만OK'/빨강'자동보정함')+실생활 1줄. 스킵링크·포커스트랩·라이브영역 vanilla JS(~3KB)+focus-visible/reduced-motion CSS 토큰. axe dev-only. | a11y-ux-lead |
| `references/chart-decision.md` | 차트 선택(비교=막대 / 추이=선 / 상관=산점 / 부분-전체=누적막대·treemap, 파이≤5 / 분포=히스토그램·박스 / 밀도=heatmap). 데이터↔스케일 매핑(순차/발산/범주, 축 0시작 막대 vs 잘림허용 선 명문화, 같은변수=같은색). takeaway title 강제. 정보위계 3단·슬라이드당1주장. 데이터잉크 규율·정적4상태(empty/overflow/NA/print). 메타데이터 블록(출처·기준일·n=·가정). SCQA/BLUF 골격. 전문용어 쉬운말 매핑. 인라인 SVG 차트 패턴(role=img+title+desc, 색 외 직접라벨). 인터랙션 2조건 정당화. | dataviz-report-specialist |
| `references/build-boilerplate.md` | 무빌드 보일러플레이트: 단일 index.html 골격+reset.css+tokens.css 주입 패턴+importmap ESM 무빌드 경로+@media print+한국어 폰트 스택(Pretendard 서브셋 woff2 동봉 또는 system-ui 폴백, word-break:keep-all, line-height 1.6+, CDN 막혀도 한글 안 깨짐). 비용계층(Tier0 비용0=타이포·여백·CSS grid 비대칭·대비 / Tier1 저비용=transform/opacity 마이크로 인터랙션 reduced-motion 폴백 / Tier2 고비용=비디오·그레인·패럴랙스, 성능예산 통과+폴백 시만). 그레인=SVG/소형타일, backdrop-filter=@supports 폴백. 성능예산(LCP<2.5s/CLS<0.1/INP<200ms). progressive enhancement. 결과 폴더 구조. | frontend-implementation-engineer |
| `references/non-dev-copy.md` | 비개발자 1급 제약 카피 가이드: 전문용어 괄호 병기 사전 + 효과 중심 1문장 추천 근거 + 신호등 배지 카피 + '한 곳만 바꾸면 전체가 바뀐다' README 한 단락 템플릿 + 편집 가이드 1장 템플릿 + '더블클릭하면 열립니다' + 검증 결과 사람 말 번역('브라우저 4종 깨짐 없음, 2초 내 로딩, 오류 0건, AA 통과'). 질문 UI 카피 톤(★추천·결과로 설명·모름→안전). | 6인 통합 |

---

## 7. 전체 파일 목록 (File Manifest)

| 경로 | 목적 |
|------|------|
| `.claude-plugin/plugin.json` | 매니페스트(완료) |
| `.claude-plugin/marketplace.json` | 마켓플레이스 등록(완료) |
| `skills/frontend-designer-pro/SKILL.md` | **단일 적응형 워크플로우 본체.** 8단계 흐름 + 6 전문가 렌즈 인라인 체크리스트 + 도메인 분기표 + references 참조 맵 + Session Recovery. user-invocable. |
| `agents/design-lead-pro.md` | 본 작업 산출 위임 에이전트(WHO·규칙). 6 렌즈 순차 적용, SKILL.md 방법론 참조, mandatory_review 시 redteam과 Team 편성. AskUserQuestion 금지·Escalations 반환. |
| `agents/design-redteam-pro.md` | 무결성 게이트 감사 에이전트. anti-slop+토큰lint+APCA·WCAG+axe·CVD 단일 무결성 리포트 감사, BLOCK/ASK/NIT 분류. lead와 왕복 루프. |
| `references/*.md` (9종) | 위 §6 자기완결 지식 |
| `README.md` | 설치·사용법(한국어). 호출법·자기완결 보장·비개발자 안내. |
| `LICENSE` | MIT(완료) |

---

## 8. 비개발자 UX 1급 원칙 (전 과정 적용)

1. **깊이는 백스테이지, 표면은 그림**: 모든 전문 기계는 산출 시점 내부에서만, 사용자에겐 썸네일·느낌단어·신호등·효과 1문장만.
2. **질문은 1회·묶음·그림·★추천 디폴트**: 능동 질문은 취향 갈리는 4~5개만. 안 골라도 전문가 기본값.
3. **secure-by-default**: 대비·키보드·반응형·reduced-motion·60-30-10·CVD안전·다크모드 파생은 묻지 않고 항상 켠다.
4. **효과로 설명, 기법으로 설명 금지**. 전문용어는 괄호 일상어 병기.
5. **신호등 결과**: 접근성·대비는 숫자가 아니라 초록'잘 읽힘'/노랑'큰글씨만OK'/빨강'자동보정함'+실생활 1줄.
6. **자동 수정 우선**: 대비 미달·alt 누락은 숙제 떠넘기지 않고 '이렇게 고치면 통과합니다'로 자동 보정.
7. **무빌드 더블클릭 보장**: '클릭하면 바로 열립니다' 명시. 터미널·node·서버 모른다고 가정.
8. **한 곳만 바꾸면 전체가 바뀐다**: 색·텍스트는 tokens.css 한 파일에, 위치를 한국어로 안내. 편집 가이드 1장.
9. **사람이 알아볼 폴더 구조**: index.html(여기를 여세요)·samples/·assets/. dist/·.next 금지.
10. **의도성 증거를 다리로**: 모든 미적 선택에 '왜 이 폰트/색/레이아웃인가' 1문장 — 근거 없는 미적 선택은 그 자체가 AI slop.

---

## 9. 미해결 리스크 (Open Risks) — SKILL.md에 완화책 반영

1. **인라인 SVG 차트 고밀도 한계** — 인터랙션 2조건 충족 시 경량 라이브러리 조건부. '정적 불가' 판정은 런타임 케이스별.
2. **axe/Playwright dev-only 환경 의존** — WSL2/Windows 미설치 시 Lighthouse CLI→수동 체크리스트 fallback. improve-ui max_retries 패턴 명시.
3. **Pretendard 서브셋 woff2 라이선스·용량** — 서브셋 도구 부재 시 system-ui 자동 폴백(안전, 폰트페어 일부 손실).
4. **샘플 갤러리 iframe file:// 제약** — 정적 링크 폴백 항상 병행.
5. **6 렌즈 인라인화 vs 에이전트화** — 복잡 충돌 시 단일 lead 자기검증 한계, redteam 루프가 안전망. 샘플 단계는 redteam 없이 진행되므로 슬롭 여지 주의.
6. **OKLCH 브라우저 네이티브 가정** — 사내 구형·Confluence 임베드에서 @supports hex 폴백 정밀도 의존.
7. **질문 4~5개 인지 부하** — 도메인 자동 추정 정확도가 낮으면 첫 질문부터 어긋날 위험. 첨부물 심층 검토 품질에 크게 의존.

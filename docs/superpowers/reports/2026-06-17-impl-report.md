# frontend-designer-pro 화려함 전환 -- 구현 보고서 (2026-06-17)

> 대상: SOURCE 위치만 (`C:\Users\lee880619\.claude\plugins\marketplaces\frontend-designer-pro\`).
> 캐시(`...\plugins\cache\...`)는 **건드리지 않았다**. 커밋/푸시 없음. 본문 punctuation은 ASCII만 사용.

이 보고서는 Plan(`docs/superpowers/plans/2026-06-17-fdp-flashy-conversion.md`)의 Global Constraints + Task 1~7을 각 파일에 surgical하게 적용한 결과다. Task 8(검증)은 controller 담당이라 실행하지 않았다.

공통 loosened 값(7파일에 동일 적용):
- 모션: 장식 모션(scroll-reveal/count-up/parallax/ambient loop)은 길이 제한 없음 + 루프 허용. `<=250ms` 상한과 "진입 1회/무한 금지" 제거. 기능 UI 피드백 기본값으로 `--motion-duration-fast`(120ms)/`--motion-duration-base`(200ms) 유지. **reduced-motion 폴백은 성역(BLOCK) 유지**.
- accent: 개수/면적 하드 캡 제거. 60-30-10은 비차단 제안. 다색/대담 팔레트 허용.
- 채도: 도메인별 OKLCH C 캡 제거. 모든 도메인(C레벨/보고서/덱 포함) 고채도(장식면 C ~0.30) 허용.
- Tier2(글래스모피즘/3D틸트/마그네틱/카운트업/패럴랙스/스크롤리빌): 기본 허용. 성능예산(LCP/CLS/INP)은 advisory(BLOCK 아님).

---

## 파일별 변경 내역

### 1. `references/anti-slop-checklist.md` (Task 1)
- **A1 (보라 그라데이션)**: BLOCK -> 비권장 메모. "그라데이션 일반 허용(다색/비비드 포함)", 보라-온-화이트 SaaS 클리셰만 advisory. 텍스트 대비 성역 명시.
- **A7 (accent 남발)**: BLOCK -> 비차단 제안. "accent 개수(<=2)/면적(<=10%)/3개+ = BLOCK" 캡 모두 제거. 다색/대담 허용. 의미색 역할분리/CVD는 권장(BLOCK 아님)으로 강등, 텍스트·의미색 대비는 성역 유지.
- **A9 (통통 모션)**: 캡 제거. 장식 모션 길이/루프 자유. **reduced-motion 폴백 누락만 BLOCK으로 유지**. 기능 UI 기본값(120/200ms) 명시.
- grep 스캔 섹션(§1): A7/A9 grep을 "적발"에서 "참고/폴백 존재 확인"으로 수정.
- §3 도메인 가중 표 + expression zone note + §5 빠른 요약 체크리스트: A1/A7/A9를 묻지 않도록 갱신.
- **확인(보존)**: A2/A3/A4/A8 BLOCK 항목 본문 완전 무수정. reduced-motion 폴백 BLOCK 유지. A5/A6 유지.

### 2. `references/_contract.md` (Task 2)
- §1 모션 표: "예산 상한 <=250ms" 열 -> "적용" 열로 재구성. base/fast를 "기능 UI 피드백 기본값"으로 라벨. `--motion-reduce`를 "성역(BLOCK)"으로 명시.
- 모션 규율 문구: "1회/<=250ms/reduced 0" -> "장식 모션 길이/루프 자유 + 기능 UI 기본값 유지 + reduced-motion 폴백 필수(BLOCK)".
- **확인(보존)**: §3 대비 임계(APCA Lc + WCAG AND 게이트), §2 포커스(2px/3:1/24px), §5 a11y 1급 7키, §6 lint 규칙 전부 무수정. `--motion-reduce` 0 유지.

### 3. `references/_block-card.md` (Task 3)
- §A anti-slop BLOCK 표: A1/A7 행을 "(완화됨 · BLOCK 아님)"으로, A9 행을 "장식 모션 자유 · reduced-motion 폴백 누락만 BLOCK"으로 교체. 헤더 문구 갱신.
- **확인(보존)**: A2/A3/A4/A8 행 무수정. 섹션 B(토큰 lint)·C(대비 AND 게이트)·D(접근성 골격: landmark/키보드/focus-visible/포커스관리/reduced-motion/keep-all)·E(상태매트릭스/메타/차트대체본)·F(무빌드)·G(카피) 전부 무수정. D의 reduced-motion BLOCK 행 유지.

### 4. `skills/frontend-designer-pro/SKILL.md` (Task 4)
- 렌즈6 비용 계층(L167): Tier2를 "기본 허용 + 화려 기법 권장"으로. 성능 예산을 advisory로(실제 깨짐만 BLOCK). reduced-motion 모든 Tier 필수.
- 단계2 모션 예산 문구(L55): "진입 1회/<=250ms" -> 장식 모션 자유 + 기능 UI 기본값 + reduced-motion 필수.
- 렌즈1 anti-slop 나열(L137): A1/A7/A9 장식 모션을 자유로, 품질항목(A2/A3/A4/A5/A6/A8)만 회피 대상으로.
- 렌즈3 색(L149): "60-30-10, accent <=2개" -> 비차단 제안(캡 없음).
- §0-3 secure-by-default(L27): 60-30-10을 강제 ON 목록에서 제거(비차단 제안으로 이동). 대비/키보드/반응형/reduced-motion/CVD/다크모드는 유지.
- §4.3 C레벨 도메인 행: "신뢰·절제 > 화려함 못박음" 제거. 대담/고채도/다색 허용을 1급 옵션으로. 본문 대비 성역 유지.
- §4.2 보고서 행: "data zone 절제" -> 대담한 색 허용(데이터 정직성/CVD/대비 유지).
- 도메인-미적 매핑 note(L187): "게이트가 절제 강제" -> "대비 + reduced-motion만 성역, 색/그라데이션/모션 대담함 비제약".
- §2.3 예시질문1(L118): "임원=화려함보다 절제 우선" 카피 -> "차분/임팩트 모두 가능(글씨 가독 유지)".
- §7.1 anti-slop 나열 + Guardrail 6: 모션 캡 -> 장식 모션 자유 + reduced-motion BLOCK.
- **확인(보존)**: 렌즈4 a11y BLOCK 7종(이중대비/landmark/키보드/focus-visible 2px/포커스관리/스크림/대체본), reduced-motion 폴백, 터치 24px, CVD 3종, Guardrail 1~5/7~10, 무결성 게이트 골격(skip 불가)·질문 게이트·light/full 모드·메타데이터 푸터 전부 무수정.

### 5. `references/aesthetic-directions.md` (Task 5)
- luxury §2 / editorial §1 / soft-modern §5: 색 성격을 "절제 1색도, 대담 고채도/다색도 가능(캡 없음)"으로. OKLCH 앵커에 대담형(C up to ~0.30) 범위 추가. soft-modern 레이아웃에 글래스/스크롤리빌/카운트업 장식 모션 자유 추가(reduced-motion 폴백 명시).
- luxury "이럴 때 추천" + §9 C레벨 매핑 행: "화려함이 아니라 믿을 만함" 강제 제거, 대담함을 1급 옵션으로.
- §9.1 분기규칙 rule 3: "격식 충돌 시 격식 우선/절제 강제" -> "대담함 모든 도메인 허용, 텍스트 대비만 성역(텍스트색만 강등, 고채도 면 유지)".
- §10 cheat sheet 공통 하한선: "60-30-10 액센트 절제" 제거. 미적 자유(대담색/고채도/다색/그라데이션/장식모션/글래스/틸트)를 모든 도메인 허용으로.
- **확인(보존)**: §0.3 무결성 게이트 관계(텍스트/의미색 성역, brutalist 노랑 위 흰글씨 = BLOCK), §0.4 폰트 폴백(Pretendard/keep-all/line-height 1.6), 본문 APCA Lc>=75 AND WCAG 4.5:1, §9.2 안전 강등 표(텍스트 대비/CVD/print 보존) 전부 무수정.

### 6. `references/color-token-contract.md` (Task 6)
- §1.3 무드->C 매핑 표: 도메인별 C 캡 -> "권장 출발점 + 모든 도메인 ~0.30 자유" 열 추가. 앵커 수 항목 "accent <=2/남발 금지" -> 다색 허용/비차단 제안.
- §5 60-30-10 맵: "규율/3개+ BLOCK"이라는 헤더와 검사 규칙을 "선택적 균형 가이드(BLOCK 아님)"로. 검사 규칙을 "accent 개수/면적은 BLOCK 대상 아님, 대비+CVD만 검사"로.
- §10 자가점검 + 부록A: "60-30-10, accent <=2" 항목을 비차단/캡 없음으로.
- **확인(보존·미수정)**: §1.2 HSL lightness 금지, §2 OKLCH 파생, §2.3 다크 별도 램프, **§3 대비 게이트 전체(APCA AND WCAG 임계표/측정 스니펫/위계는 대비 깎기 금지)**, §4 oklch+hex 폴백, §7 CVD 3종+이중인코딩, §8 문화색 동의, §9 권한 계약 전부 무수정.

### 7. `agents/design-redteam-pro.md` (Task 7)
- §2.1 anti-slop 표: A1/A7 행 "(완화됨 · 검사 안 함)", A9 행 "장식 모션 자유 · reduced-motion 폴백 누락만 BLOCK"으로. 헤더 문구를 "A1/A7/A9 장식 비검사"로.
- 도메인 가중 note: A1/A7/A9 가중 제외. "채도/Tier2 비-BLOCK" note 추가(고채도 ~0.30, Tier2 효과 비검사, 성능 advisory). expression zone note에서 A1 모든 면 자유 반영.
- frontmatter description: "anti-slop 9항목" -> 품질 항목 열거 + A1/A7/A9 비검사 명시.
- §4 회귀규칙 예시 + §5 왕복 예시 + §6 리포트 템플릿 예시 행: A1(보라 그라데이션) 예시 -> A6(회색 박스) 예시로 교체(완화 항목을 BLOCK 예시로 쓰지 않도록).
- **확인(보존)**: §2.2 토큰 lint(dangling/순환/하드코딩/HSL/oklch-hex/a11y 1급), §2.3 영역 C 대비 AND 게이트, §2.4 영역 D(검증증거/CVD 3종/시맨틱 위계/완전키보드/포커스관리/**reduced-motion**/keep-all), §2.5 영역 E(상태매트릭스/메타/차트대체본/takeaway), §2.6 F, §2.7 G, mode 분류표, read-only 정체성 전부 무수정. A2/A3/A4/A5/A6/A8 BLOCK 행 유지.

---

## 일관성 확인 (4 SSOT 파일 정합)
모션/accent/채도/Tier2 규칙이 `_contract.md` / `_block-card.md` / `SKILL.md` / `design-redteam-pro.md`에서 동일하게 진술됨:
- 어느 파일도 `<=250ms` 상한, "진입 1회", accent `<=2`/`<=10%`/`3개+ = BLOCK`, 도메인 채도 캡을 더 이상 BLOCK으로 주장하지 않음(grep 재확인 완료).
- 네 파일 모두 reduced-motion 폴백을 유일한 모션 BLOCK으로, 대비 이중 게이트를 성역으로 일관 진술.

## 검증 결과 요약 (self-review grep)
- 제거 캡: 7파일 내 stale `<=250ms`-as-ceiling / accent-cap-as-BLOCK 0건.
- 보존 언어: 5개 references 파일에 reduced-motion/APCA AND WCAG/focus-visible/skip link/CVD/이중인코딩 마커 57건 잔존. redteam에 동 마커 16건. A2/A3/A4/A8 본문 양 파일 무수정 확인.

## 우려 (concerns)
1. **범위 밖 4개 파일에 stale "<=250ms / 진입 1회" 문구 잔존** (수정하지 않음 -- 7파일 scope 밖):
   - `references/a11y-checklist.md` L234-235, L263
   - `references/art-brief-template.md` L196
   - `references/build-boilerplate.md` L194, L369
   - `references/token-system.md` L136, L153
   분석: 이들은 **독립 BLOCK이 아니다**. a11y-checklist의 실제 BLOCK 7종(B1-B7)에는 모션 길이/루프 BLOCK이 없고(모션 enforcement는 §5.2 reduced-motion reset 뿐, 이는 보존 대상), 나머지는 `_contract.md §1`을 가리키는 서술/주석이다. `_contract.md`(SSOT)를 완화했으므로 의미상 무력화됐고, 감사관(redteam §2.4)도 모션은 reduced-motion 폴백 존재만 BLOCK으로 검사한다. 따라서 화려한 산출물 재-BLOCK은 발생하지 않는다. 다만 producer가 이 문구를 문자 그대로 읽으면 혼선 가능 -> controller가 후속으로 정합화하길 권고(또는 추가 task로 4파일 주석/서술 동기화).
2. **`references/tokens.contract.json` 미러**: `_contract.md`가 머신 미러로 `tokens.contract.json`을 언급. scope 밖이라 미수정. 만약 거기 250ms ceiling 값이 박혀 있고 `kb-consistency-check.sh`가 본문 vs json 단일값을 단언한다면 드리프트 경고가 날 수 있음 -> controller 확인 권고.
3. 그 외 `docs/`(debate-synthesis, skill-spec, specs, plans)의 옛 모션/절제 문구는 설계 이력 문서라 의도적으로 미수정.

---

## Follow-up sync (5 files)

> 위 "우려 1·2"가 가리킨 stale 모션 문구를, scope를 명시받아 후속 정합화한 결과. SOURCE(`...\marketplaces\frontend-designer-pro\references\`)만 수정. 캐시 미수정, 커밋 없음, ASCII punctuation만.
> 공통 새 규칙: 장식 모션(scroll-reveal/count-up/parallax/ambient loop)은 길이 자유 + 루프 허용. `--motion-duration-fast`(120ms)/`--motion-duration-base`(200ms)는 기능 UI 피드백 기본값으로만 유지(상한 아님). reduced-motion 폴백(`--motion-reduce` -> 0, @media reset)은 성역으로 보존.

### references/art-brief-template.md (HIGH -- 디자인 SSOT 시드)
- §4 표(L116-119) before: "등장 횟수 = 진입 시 1회만(반복.무한 루프 금지)", "지속 시간 = <=250ms". after: "장식 모션 = 길이 자유, 반복.무한 루프 허용" 행 + "기능 UI 피드백 = 기본 120/200ms(상한 아님)" 행으로 분리. 비개발자 신호 문구를 "움직임을 마음껏 넣어도 됨(천천히/반복 OK)"로 교체.
- L196 체크리스트 before: "§4 모션 예산: 1회 . <=250ms . reduced-motion 0 명시". after: "장식 모션 길이.반복 자유 / 기능 UI 기본 120.200ms / reduced-motion 0(필수) 명시".
- L232-233 luxury 예시 before: "등장 1회 . <=200ms ...". after: 절제를 "이 brief의 선택(상한 규칙 아님)"으로 재서술, transform/opacity 표지 페이드인 1회 유지. **보존**: "prefers-reduced-motion 시 0(필수)" 유지. (§5 expression/data zone, §3 대비 표면 지도, 차트 인코딩 등 무관 내용 무수정.)

### references/a11y-checklist.md (CAREFUL -- preserve rule 적용)
- §5.2 제목 + 첫 bullet(L234-236) before: 제목 "(모션 예산 = 1회.<=250ms.reduced 0)" + "art brief 모션 예산: 진입 1회.<=250ms.prefers-reduced-motion에서 0". after: 제목 "(reduced 시 0 -- 필수)"; 번들 문장을 **분리** -- (a) 장식 모션 길이.반복 무제한 + 기능 UI 기본 120/200ms(상한 아님), (b) reduced-motion 0 폴백 필수(면제 불가)로 명시.
- L263 a11y 1급 토큰 주석 before: "모션 예산 상한 <=250ms". after: "기능 UI 피드백 기본값(상한 아님). 장식 모션은 길이.반복 자유".
- **MUST PRESERVE 확인**: L239-244 `@media (prefers-reduced-motion: reduce)` reset 블록(`animation-duration:.001ms !important` 등) 그대로 보존. "OS 움직임 줄이기 시 애니메이션.패럴랙스.자동재생 끔" bullet 유지. 대비(APCA/WCAG)/키보드/landmark/aria-live/CVD 등 무관 항목 무수정.

### references/build-boilerplate.md
- L194 토큰 주석 before: "모션 예산 상한 <=250ms". after: "기능 UI 피드백 기본값(상한 아님). 장식 모션은 길이.반복 자유".
- L369 Tier 1 표 행 before: 수단 "진입 1회 애니메이션" / 허용조건 "모션 예산 준수(1회.<=250ms)". after: 수단에 "스크롤 등장.카운트업.은은한 루프 등 장식 애니메이션" 추가, 허용조건 "장식 모션 길이.반복 자유(무한 루프 허용), 기능 UI 기본 120/200ms". **보존**: "prefers-reduced-motion: reduce 폴백 필수" + 폴백 열 "reduced-motion 시 0" 유지. L162-163 reduced-motion 전역 차단 블록, L385 grain 폴백 무수정.

### references/token-system.md
- L136 7키 표 행 before: "200ms (모션 예산 <=250ms 준수)". after: "200ms (기능 UI 피드백 기본값 -- 상한 아님; 장식 모션은 길이.반복 자유)".
- L153 CSS 골격 주석 before: "모션 예산 <=250ms". after: "기능 UI 피드백 기본값(상한 아님). 장식 모션은 길이.반복 자유". **보존**: L159-160 `@media (prefers-reduced-motion: reduce){ --motion-reduce:0 }`, L169-175 `calc(... * var(--motion-reduce))` reduced-motion 트릭, a11y 1급 4종 7키 lint 강제 무수정.

### references/tokens.contract.json
- `motion` 블록 before: `--motion-budget-max: "250ms"` 키 존재. after: `--motion-budget-max` 제거; `decorativeMotion: { maxDuration: null, loopAllowed: true }` + `$note`(fast/base는 기능 UI 기본값.상한 아님; 장식 모션 무제한.루프 허용; 유일한 필수 모션 규칙은 reduced-motion 폴백) 추가. **보존**: `--motion-duration-fast/base` 기본값, `--motion-reduce-default: "1"`, `a11yPrimaryTokens`의 `--motion-reduce`, contrast(APCA/WCAG)/focus/naming/lintGrades 전부 무수정. `node -e require()` 파싱으로 JSON 유효성 확인(`JSON OK`, budget-max present:false, a11yPrimaryTokens has --motion-reduce:true).

### Self-review (re-grep)
- 5파일 ceiling 잔재 0건: `250ms` / `<=250` / `진입 1회` / `모션 예산 상한` / `무한 루프 금지` / `budget-max` 매치 없음.
- reduced-motion 폴백 잔존: art-brief 3 / a11y 7 / build 6 / token-system 11 / json 3 매치.
- a11y `@media (prefers-reduced-motion: reduce)` reset 블록 + `animation-duration:.001ms !important` 그대로 확인.
- JSON 유효 + `--motion-budget-max` 제거 + `--motion-reduce` 토큰 보존 확인. 캐시 미수정, 커밋 없음.

---

## Encoding fix

> 위 작업으로 ADD된 라인(diff의 `+` 라인, `+++` 헤더 제외)에 섞여 든 비-ASCII 타이포그래피 구두점을 ASCII로 변환. 권위 소스 = `docs/superpowers/reports/2026-06-17-review-diff.txt`. ADD 라인만 수정했고, 기존(미변경) 라인은 같은 문자가 있어도 그대로 두었다(의도된 house style). SOURCE(`...\marketplaces\frontend-designer-pro\`)만 수정. 캐시 미수정, 커밋 없음.

### 변환 문자별 건수 (ADD 라인 내 출현 횟수 기준)
- `·` (U+00B7 가운뎃점) -> `-` : 264
- `—` (U+2014 em-dash) -> `--` : 33
- `→` (U+2192 우화살표) -> `->` : 8
- `≥` (U+2265) -> `>=` : 4
- `↔` (U+2194 좌우화살표) -> `<->` : 1
- (출현 없음: `–` en-dash / `≤` / `←` / `…` / 곡선따옴표 `' ' " "` -- 변환 불필요)

### 영향받은 파일 (ADD 라인 수)
- agents/design-redteam-pro.md (8), references/_block-card.md (4), references/_contract.md (2), references/a11y-checklist.md (3), references/aesthetic-directions.md (11), references/anti-slop-checklist.md (24), references/art-brief-template.md (5), references/build-boilerplate.md (2), references/color-token-contract.md (12), references/token-system.md (2), skills/frontend-designer-pro/SKILL.md (12).
- 총 12개 대상 파일 중 11개 수정(85개 ADD 라인). `references/tokens.contract.json`은 ADD 라인에 매핑 문자가 없어 미수정(JSON 유효성 재확인 통과).

### 검증 (step-5)
- 명령: `git -C "..." diff | grep -nP '^\+' | grep -nP '[비-ASCII 매핑 문자]'`
- 결과: `CLEAN: no non-ASCII typographic punctuation in added lines`
- 독립 교차검증(sandbox, git diff 직접 파싱): ADD(`+`) 라인 중 매핑 문자 잔존 = 0건.
- `tokens.contract.json` JSON 유효성: VALID JSON.

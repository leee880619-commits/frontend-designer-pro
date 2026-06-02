# anti-slop-checklist.md — 산출 직전 필수 BLOCK 게이트

> **이 파일은 무엇인가?** 결과물을 사용자 폴더로 내보내기 **직전**, 런타임 에이전트(`design-lead-pro`)와 감사관(`design-redteam-pro`)이 **반드시 통과시켜야 하는 9개 BLOCK 항목**의 단일 점검표다. "AI가 방금 만든 티"(= AI slop)를 만드는 가장 흔한 9가지 징후를 잡아낸다.
>
> **이 게이트의 자리(SSOT 정합)**: skill-spec §1의 7단계 "산출 직전 단일 무결성 게이트(BLOCK)" 중 **anti-slop 부분**이다. 같은 게이트에서 토큰 lint(`token-system.md`)·APCA/WCAG 대비(`color-token-contract.md`)·axe/CVD(`a11y-checklist.md`)가 병렬로 함께 돈다. 이 파일은 그중 **미적 슬롭(slop)** 전담이다.
>
> **skip 불가**. 사용자가 "리뷰 스킵"을 요청해도 BLOCK 항목이 하나라도 걸리면 출고할 수 없다(skill-spec §1·§7, 프로젝트 CLAUDE.md mandatory_review와 동일선상).

---

## 0. 통과 판정 규칙 (Pass/Fail Rule)

런타임 에이전트는 아래 절차를 **기계적으로** 따른다. 판단 여지를 최소화하기 위함이다.

1. **전수 점검**: 산출 HTML/CSS 각 파일에 대해 §2의 9개 항목(A1~A9)을 **모두** 점검한다. 하나도 건너뛰지 않는다.
2. **하나라도 걸리면 = FAIL**: 9개 중 단 하나라도 [징후]에 해당하면 그 파일은 **BLOCK(출고 금지)**.
3. **교체 → 재점검 루프**: FAIL 항목의 [교체안]을 적용한 뒤, **9개 전부를 처음부터 다시** 점검한다(교체가 새 슬롭을 부르는 일이 잦으므로 부분 재점검 금지).
4. **2회 연속 통과 시 PASS**: 무수정으로 9개 전부를 통과한 점검 1회 + 직전에 교체가 있었다면 그 직후 1회 = 안정 통과로 본다. 무수정 1회 통과면 즉시 PASS.
5. **무한 루프 방지**: 같은 항목이 3회 교체에도 계속 FAIL이면, 해당 면이 art brief(`art-brief-template.md`)의 무드와 충돌하는지 확인하고, 충돌이면 `design-redteam-pro`에게 ASK(설계 재확인)로 에스컬레이션한다. 임의로 통과시키지 않는다.

### 신호등 카피 매핑 (비개발자 보고용)

점검 결과는 사용자에게 숫자가 아니라 신호등으로 보고한다(skill-spec §8-5).

| 내부 상태 | 사용자에게 보이는 문구 | 실생활 1줄 |
|-----------|------------------------|-----------|
| 9개 전부 통과 | 초록 "사람이 다듬은 느낌 ✓" | "AI가 자동으로 찍어낸 흔한 모양이 아닙니다." |
| 1~2개 걸려 자동 교체함 | 노랑 "흔한 부분을 다듬었어요" | "기본형으로 보일 뻔한 곳을 의도적인 선택으로 바꿨습니다." |
| 3개 이상 걸려 재설계 | 빨강 "방향을 다시 잡았어요" | "처음 안이 너무 평범해 톤을 새로 잡았습니다." |

---

## 1. 자동 점검 방법 (grep 가능한 1차 스캔)

아래는 **1차 자동 필터**다. grep으로 "냄새나는 패턴"을 빠르게 후보로 올린 뒤, 사람/에이전트의 눈으로 §2의 [징후] 정의에 맞는지 **최종 확정**한다. grep은 후보 발굴용이지 단독 판정 도구가 아니다(예: 보라색 자체가 죄는 아니다 — "화이트 위 보라 그라데이션"이 문제).

```bash
# A1 보라 그라데이션 on 화이트 — 보라 계열 hex + gradient + 흰 배경 동시 출현
grep -niE "linear-gradient|radial-gradient" *.html *.css
grep -niE "#[89ab][0-9a-f]{1,2}(ff|f7|f0)|rebeccapurple|blueviolet|#6[0-9a-f]?[0-9a-f]?f|oklch\([0-9.]+ +0\.[12][0-9]* +2[789][0-9]" *.html *.css   # 보라~인디고 색상각(H≈270~300) 후보

# A2 기본 폰트 방치 — Inter/Roboto/system-ui만 있고 의도적 폰트페어 없음
grep -niE "font-family[^;]*(Inter|Roboto|system-ui|-apple-system|Segoe UI|Helvetica|Arial)" *.html *.css
grep -niE "Pretendard|Noto Sans KR|Source Serif|Newsreader|Spline|Fraunces|Space Grotesk|IBM Plex" *.html *.css  # 의도적 폰트가 하나라도 있나?(없으면 A2 의심)

# A3 균등 3카드 그리드 — repeat(3, 1fr) / grid-template-columns: 1fr 1fr 1fr
grep -niE "repeat\(3, *1fr\)|grid-template-columns: *1fr +1fr +1fr|repeat\(auto-fit, *minmax" *.html *.css

# A4 의미없는 이모지 아이콘 — 본문/카드 머리의 단독 이모지
grep -nP "[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}\x{2190}-\x{21FF}\x{2B00}-\x{2BFF}]" *.html

# A5 가운데정렬 hero — text-align:center + 큰 제목 + 제네릭 일러스트(unDraw/blob)
grep -niE "text-align: *center" *.html *.css
grep -niE "undraw|storyset|drawkit|blob|illustration|hero-image|placeholder" *.html *.css

# A6 톤 없는 회색 박스 — #fff/#f0~#f9 카드 + 옅은 회색 테두리 + 동일 그림자
grep -niE "background: *#(fff|f[0-9a-f]f[0-9a-f]?f?|fafafa|f5f5f5|eee)|border: *1px +solid +#(ddd|eee|e[0-9a-f]e[0-9a-f])" *.html *.css
grep -niE "box-shadow: *0 +[0-9]+px +[0-9]+px +rgba\(0, *0, *0, *0\.0?[0-9]" *.html *.css   # 흔한 0,0,0,0.0x 회색 그림자

# A7 accent 3개+ 남발(60-30-10 위반) — accent 토큰/색 사용처가 3종 이상
grep -nioE "var\(--color-accent[^)]*\)|--accent-?[0-9a-z]*" *.html *.css | sort -u   # 서로 다른 accent 변수 수 세기
grep -ncE "var\(--color-(brand|accent)" *.html   # 강조색 총 사용 횟수(과다 출현 신호)

# A8 명사구 차트 제목 — <figcaption>/차트 title이 "월별 매출" 같은 명사구(동사·결론 없음)
grep -niE "<figcaption[^>]*>|<h[2-6][^>]*>.{0,40}(현황|추이|분포|비율|통계|매출|지표|데이터)</" *.html

# A9 무의미 통통 모션 — bounce/pulse/wobble/float 무한 반복, 의미 없는 scale 키프레임
grep -niE "animation[^;]*(bounce|pulse|wobble|float|shake|infinite)|@keyframes +(bounce|pulse|wobble|float)" *.html *.css
grep -niE "transition[^;]*[0-9]+ms[^;]*ease.*all|animation-duration: *[3-9][0-9]{2,}ms|animation-duration: *[0-9.]+s" *.html *.css  # 250ms 초과·all 트랜지션
```

> **한계**: grep은 보라색 색상각(H)이나 "균등함"을 완벽히 잡지 못한다. 1차 후보를 §2 정의로 사람이 확정한다. 색 판정이 애매하면 `color-token-contract.md`의 OKLCH H값(보라≈270~330)으로 역산해 확인한다.

---

## 2. BLOCK 항목 9선 (각: 징후 / 왜 slop인가 / 교체안)

### A1. 보라 그라데이션 on 화이트 (Purple gradient on white)

| 구분 | 내용 |
|------|------|
| **징후** | 흰/거의 흰 배경 위, 인디고~보라(H≈270~300) 계열 `linear-gradient`. 특히 버튼·hero 배경·카드 헤더에 보라→파랑 또는 보라→분홍 그라데이션. `#6366f1`, `#8b5cf6`, `#a855f7` 류 + `linear-gradient(135deg, ...)`. |
| **왜 slop인가** | 2021~2024 노코드/AI 스타터 템플릿(Vercel·Linear 모방 다수)의 사실상 디폴트. "방금 부트스트랩한 SaaS" 인상을 줘 **의도성이 0**으로 읽힌다. 보라 그라데이션은 브랜드 의미가 아니라 "고를 줄 몰라서 고른 색"의 대명사가 됐다. |
| **교체안** | (1) **단색 + 면 대비**로 전환: 그라데이션 대신 art brief 무드 색 1개의 평면 채움. 깊이는 그라데이션이 아니라 **여백·크기·굵기**로 만든다(skill-spec §0-2). (2) 그라데이션이 꼭 필요하면 **동일 색상각 내 명도 그라데이션**(예: 같은 H, L만 차이)으로 한정하고 채도를 art brief의 data/expression zone 규칙에 맞춘다. (3) 색은 임의 hex가 아니라 `var(--color-brand-500)` 등 토큰에서만(`token-system.md`, raw hex 금지). (4) 보라가 정말 브랜드 색이라면 art brief에 그 근거 1문장을 박는다 — 근거 없는 보라는 BLOCK. |

### A2. 기본 폰트 방치 (Inter / Roboto / system 무개입)

| 구분 | 내용 |
|------|------|
| **징후** | `font-family`가 `Inter` 또는 `Roboto` 단독, 혹은 `system-ui, -apple-system, Segoe UI, Arial`만으로 끝. 제목과 본문이 **같은 폰트·같은 굵기**. 한국어 본문에 폰트 지정이 없어 OS 기본(맑은 고딕 등)으로 떨어짐. |
| **왜 slop인가** | Inter/Roboto/system 단독은 "타이포에 아무 결정도 하지 않았다"는 신호다. 사람이 다듬은 디자인은 거의 항상 **제목/본문 폰트페어** 또는 최소한 **굵기·자간·크기 대비**를 의도적으로 준다. 무개입 타이포는 슬롭의 가장 조용한 형태다. |
| **교체안** | (1) art brief 무드에 맞는 **폰트페어 1쌍** 지정: 예) editorial=세리프 제목(Source Serif/Newsreader)+산세리프 본문, technical=Space Grotesk/IBM Plex, luxury=절제된 세리프+넓은 자간. (`aesthetic-directions.md`의 폰트페어 매핑 사용). (2) **한국어는 Pretendard 서브셋 woff2 동봉**, 없으면 `Pretendard, "Pretendard Variable", system-ui` 폴백 스택 + `word-break:keep-all`(`build-boilerplate.md`). (3) 폰트 추가가 불가능한 환경이면 **최소 위계라도**: 제목 700/본문 400, 제목 자간 -0.02em, 본문 line-height 1.6+로 "의도"를 만든다. system-ui 단독으로 끝내지 않는다. |

### A3. 균등 3카드 그리드 (Equal 3-up card grid)

| 구분 | 내용 |
|------|------|
| **징후** | `grid-template-columns: repeat(3, 1fr)`로 폭·높이·그림자·패딩이 **완전히 똑같은** 카드 3장(또는 4장)이 한 줄로. 각 카드 = 아이콘 + 짧은 제목 + 2줄 설명. "Features" 섹션의 전형. |
| **왜 slop인가** | 모든 항목을 **동일 시각 무게**로 두는 것은 "무엇이 중요한지 결정하지 않았다"는 뜻 → 위계 부재 = 슬롭. 균등 그리드는 정보 우선순위를 디자이너가 포기했다는 증거다. |
| **교체안** | (1) **비대칭 레이아웃**: 가장 중요한 1개를 2칸 폭/큰 카드로(`grid-template-columns: 2fr 1fr 1fr` 또는 `grid-template-areas`로 spotlight). (2) **위계 부여**: 1순위 카드만 강조색·큰 제목·일러스트, 나머지는 텍스트 위주. (3) 항목이 진짜 동급이면 **그리드 대신 흐름**(가로 스크롤·세로 리스트·지그재그)으로 단조로움을 깬다. (4) 카드 수가 콘텐츠상 꼭 3이어야 할 근거가 없으면 2개 또는 5개로 바꿔 "3의 관성"을 깬다. 핵심은 **하나가 더 커야 한다**. |

### A4. 의미 없는 이모지 아이콘 (Decorative emoji as icons)

| 구분 | 내용 |
|------|------|
| **징후** | 카드/리스트/제목 앞에 🚀✨💡🎯🔥📊 같은 이모지를 "아이콘"으로 사용. 의미 연결이 약하고(로켓=빠름? 전구=아이디어?) 색·크기가 본문과 따로 논다. 스크린리더가 "로켓 발사" 식으로 읽어버림. |
| **왜 slop인가** | 이모지 아이콘은 **아이콘 시스템을 만들지 않은 자리를 때운 것**이다. 플랫폼마다 모양이 다르고(렌더 불일치), 브랜드 톤과 무관하며, 의미 없는 장식은 art brief의 "하지 말 것"에 항상 포함된다. 접근성에도 해롭다(`a11y-checklist.md`). |
| **교체안** | (1) **인라인 SVG 아이콘**으로 교체(`build-boilerplate.md`, 런타임 0KB·`stroke="currentColor"`로 토큰 색 상속·`aria-hidden="true"`). 24x24 그리드·1.5px stroke로 통일된 한 벌. (2) 아이콘이 **정보를 전달하지 않으면 아예 제거** — 장식이면 빼는 게 낫다. (3) 의미가 꼭 필요하면 **텍스트 라벨 + SVG**를 함께(색만으로 의미 전달 금지, `color-token-contract.md` 이중인코딩). (4) 데이터 맥락의 이모지(차트 옆 🔼)는 직접 라벨/화살표 SVG로 대체. |

### A5. 가운데정렬 hero + 제네릭 일러스트 (Centered hero + stock illustration)

| 구분 | 내용 |
|------|------|
| **징후** | 화면 최상단 `text-align:center`로 큰 제목 + 한 줄 부제 + 버튼 1~2개 + 그 위/옆에 unDraw·Storyset·blob·보라 캐릭터 일러스트. 모든 요소가 정중앙 축에 정렬. |
| **왜 slop인가** | "센터 hero + 무료 일러스트"는 2020년대 SaaS 랜딩의 복제 템플릿 그 자체다. unDraw 류 일러스트는 수만 개 사이트가 공유 → **브랜드 고유성 0**. 모든 것을 가운데 두는 것은 레이아웃 결정을 안 한 것과 같다. |
| **교체안** | (1) **비대칭 hero**: 텍스트 좌측 정렬 + 우측에 실제 제품 스크린샷/데이터 미리보기/추상 기하 패턴(인라인 SVG). 또는 텍스트만으로도 타이포 스케일·여백으로 강렬하게. (2) 제네릭 일러스트 **삭제** — 실제 콘텐츠(차트·UI 캡처·실제 수치)로 대체. (3) 가운데정렬은 발표 슬라이드 표지(expression zone, skill-spec §4.4)처럼 의도가 분명할 때만. 정보 밀도 화면에선 좌측 정렬 기준선이 가독을 높인다. (4) 일러스트가 꼭 필요하면 art brief 무드 색으로 **직접 그린 인라인 SVG 추상 패턴**(grain·gradient mesh 절제)으로. |

### A6. 톤 없는 회색 박스 (Tone-less gray boxes)

| 구분 | 내용 |
|------|------|
| **징후** | `#fff`/`#f9fafb`/`#f5f5f5` 배경 + `1px solid #e5e7eb` 테두리 + `box-shadow: 0 1px 3px rgba(0,0,0,0.1)` 카드가 화면을 덮음. 배경·카드·테두리가 전부 **채도 0의 회색 계열**이라 어디에도 무드가 없다. |
| **왜 slop인가** | 순수 무채색 회색은 "색 결정을 안 했다"는 디폴트다. 사람이 다듬은 UI는 중성색에도 **미세한 색온도**(따뜻한 회색/차가운 회색, OKLCH로 약한 C 부여)를 넣어 무드를 입힌다. 회색 박스 천국은 슬롭의 배경음이다. |
| **교체안** | (1) **중성색에 색온도 주입**: `color-token-contract.md`의 OKLCH 앵커에서 brand H를 살짝 머금은 회색 램프 파생(예: 차가운 무드면 H≈250의 C≈0.01 회색). 순수 `#808080` 금지. (2) **면 분리는 그림자가 아니라 배경 명도 단차 + 여백**으로(skill-spec §0-2). 모든 카드 동일 그림자는 위계를 안 만든다 — 강조 카드만 그림자/테두리 차별. (3) 테두리·배경·그림자가 다 회색이면 최소 1개를 무드 색으로 교체(예: 강조 카드 좌측 2px brand 보더). (4) 모든 색은 토큰에서만(raw hex 금지, `token-system.md`). |

### A7. accent 3개+ 남발 (60-30-10 위반)

| 구분 | 내용 |
|------|------|
| **징후** | 한 화면에 서로 다른 강조색(accent)이 3종 이상 — 파랑 버튼 + 초록 배지 + 주황 알림 + 보라 링크가 다 동시에 진하게. 60-30-10 비율(중성 60 / 보조 30 / 강조 10)이 깨져 강조색 면적이 10%를 크게 넘음. |
| **왜 slop인가** | "모든 게 강조면 아무것도 강조가 아니다." accent 남발은 **시선 우선순위를 설계하지 않은** 슬롭이다. 색이 많을수록 전문성이 아니라 미숙함으로 읽힌다. 60-30-10은 skill-spec §4.3·§8-3의 secure-by-default 하한선이다. |
| **교체안** | (1) **accent 1개로 강제 축소**(C레벨·보고서는 화면당 1~2개, skill-spec §4.3). 나머지 "강조"는 중성색 + 굵기/크기로 위계. (2) 의미색(성공/경고/오류)은 accent와 **역할 분리**: 의미색은 상태 전달 전용(`color-token-contract.md` 의미 스케일), 브랜드 accent는 행동 유도 전용. (3) 색 사용 면적을 **60-30-10으로 재배분**: 중성 배경/텍스트 60%, 보조 톤 30%, brand accent ≤10%. (4) 차트 색은 별도 네임스페이스(`color.viz.categorical.1~8`, CVD안전 8색 이내, `token-system.md`) — UI accent와 섞지 않는다. |

### A8. 명사구 차트 제목 (Noun-phrase chart titles)

| 구분 | 내용 |
|------|------|
| **징후** | 차트/표 제목이 "월별 매출", "사용자 추이", "지역별 분포" 같은 **명사구**(동사·결론 없음). `figcaption`이나 차트 위 제목이 무엇을 보라는 결론을 말하지 않고 주제만 라벨링. |
| **왜 slop인가** | 명사구 제목은 "데이터를 그려는 놨는데 **무슨 말을 하려는지는 안 정했다**"는 슬롭이다. 사람이 다듬은 보고서는 차트마다 **결론형 takeaway title**을 단다(skill-spec §4.2·§4.3, `chart-decision.md`). 독자가 "그래서 뭐?"를 스스로 풀게 두는 건 미완성이다. |
| **교체안** | (1) **결론형 문장으로 교체**: "월별 매출" → "3분기 매출이 전년 대비 18% 증가했다", "지역별 분포" → "수요의 절반이 수도권에 집중된다". 주어+동사+핵심 수치. (2) 슬라이드/섹션은 **1주장 = 1결론 제목**(skill-spec §4.4). (3) 명사형 주제는 부제/캡션으로 내리고 제목 자리엔 결론을. (4) 결론이 안 떠오르면 그 차트가 정말 필요한지 재검토(`chart-decision.md` 데이터잉크 규율). |

### A9. 무의미 통통 모션 (Gratuitous bouncy motion)

| 구분 | 내용 |
|------|------|
| **징후** | `animation: bounce/pulse/wobble/float ... infinite`로 요소가 끝없이 튀거나 둥둥 뜸. `transition: all 0.4s ease`로 모든 속성이 같이 움직임. hover 시 과한 scale(1.1+)·회전. duration이 250ms 초과거나 무한 반복. `prefers-reduced-motion` 미대응. |
| **왜 slop인가** | 의미 없는 모션은 "움직이면 멋있어 보이겠지"라는 슬롭이다. 사람이 다듬은 모션은 **상태 변화를 설명하는 1회·짧은(≤250ms)** 움직임만 쓴다(art brief 모션 예산: 1회·≤250ms·reduced-motion 0, skill-spec §2). 무한 통통 모션은 주의를 분산시키고 접근성을 해친다(전정 장애). |
| **교체안** | (1) **무한 애니메이션 제거**. 모션은 상태 전환(나타남·강조·피드백)에만, **1회·≤250ms**. (`build-boilerplate.md` Tier1: transform/opacity만). (2) `transition: all` → **속성 한정**(`transition: transform 180ms ease, opacity 180ms ease`). (3) hover scale은 1.02~1.04로 절제, 회전 금지. (4) **`@media (prefers-reduced-motion: reduce)` 폴백 필수** — 모션 0으로 떨어뜨림(`a11y-checklist.md`, 누락 시 axe/CVD 게이트와 별개로 여기서도 BLOCK). (5) 토큰 사용: `var(--motion-duration-base)`, raw px/ms 하드코딩은 토큰 lint(`token-system.md`)에서도 잡힌다. |

---

## 3. 도메인별 가중 (Domain weighting)

9개 항목은 모든 도메인에 적용되지만, 도메인에 따라 **특히 치명적인 항목**이 다르다. 점검 시 가중치를 둔다(skill-spec §4).

| 도메인 | 특히 엄격하게 볼 항목 | 이유 |
|--------|----------------------|------|
| 웹앱 (§4.1) | A3(균등 그리드)·A9(모션) | 인터랙티브 화면일수록 위계·모션 절제가 신뢰를 만든다. |
| 분석 보고서 (§4.2) | A8(명사구 제목)·A7(색 남발)·A6(회색 박스) | 결론형 제목·CVD안전 색·data zone 절제가 협상 불가. |
| C레벨 보고서 (§4.3) | A1(보라 그라데이션)·A7(accent 남발)·A5(센터 hero) | "신뢰·절제 > 화려함"이 art brief에 못박힌 도메인. 화려함이 곧 감점. |
| 발표 PPT (§4.4) | A4(이모지)·A8(명사구 제목)·A9(모션) | 슬라이드당 1주장·결론형 제목·빔 가독. 표지(expression zone)는 A5 가운데정렬 허용 예외. |
| 기타 (§4.5) | 확정 도메인의 가중 상속 | 도메인 확정 후 해당 행 적용. 마케팅 랜딩은 가독 하한선 위에서 A5·A9 일부 완화 가능. |

> **expression zone 예외**: art brief가 정의한 expression zone(표지·간지·풀블리드 장식면, `art-brief-template.md`의 no-text AND no-meaning)은 A5(가운데정렬)·A1(그라데이션) 일부를 **무드 자유로 허용**한다. 단 텍스트가 올라오는 순간 성역(APCA AND WCAG)으로 복귀하며, 스크림 오버레이 위 대비를 재측정한다(`a11y-checklist.md`). data zone(차트·표·본문)은 예외 없이 9개 전부 엄격 적용.

---

## 4. 의도성 증거 (Intentionality evidence) — 메타 게이트

위 9개를 모두 통과해도, **각 주요 미적 선택에 "왜 이 폰트/색/레이아웃인가" 1문장 근거가 없으면 그 자체가 slop**이다(skill-spec §8-10). 산출물의 art brief 또는 편집 가이드(`non-dev-copy.md`)에 아래가 채워졌는지 확인한다.

- [ ] 폰트페어 선택 근거 1문장 (예: "임원 신뢰감을 위해 절제된 세리프 제목")
- [ ] 강조색(brand accent) 선택 근거 1문장
- [ ] 핵심 레이아웃(비대칭/그리드 깸) 근거 1문장
- [ ] 모션 사용 시 "무엇을 설명하는 모션인지" 1문장

근거가 비어 있으면 BLOCK이 아니라 **ASK**(설계자에게 근거 요청)로 분류해 `design-redteam-pro` 루프로 보낸다. 근거 없는 미적 선택은 우연이고, 우연은 슬롭이다.

---

## 5. 빠른 요약 (런타임 1줄 체크)

> 출고 전 이 9개를 소리 내어 묻는다. 하나라도 "예"면 멈추고 교체한다.
>
> 1. 화이트 위에 보라 그라데이션 있나? (A1)
> 2. Inter/Roboto/system 폰트로 끝났나? (A2)
> 3. 똑같은 카드 3장이 한 줄로 있나? (A3)
> 4. 의미 없는 이모지를 아이콘처럼 썼나? (A4)
> 5. 가운데정렬 hero + 흔한 일러스트인가? (A5)
> 6. 모든 게 채도 0 회색 박스인가? (A6)
> 7. 강조색이 3종 이상 진하게 있나? / 60-30-10 깨졌나? (A7)
> 8. 차트 제목이 명사구(결론 없음)인가? (A8)
> 9. 무한·과한 통통 모션이 있나? / reduced-motion 폴백 없나? (A9)
>
> 전부 "아니요" → PASS. 사용자에게 "사람이 다듬은 느낌 ✓"로 보고.

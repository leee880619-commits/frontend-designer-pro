# 01 — 6인 전문가 토론 종합 (Debate Synthesis)

> 워크플로우 `fdp-debate` (13개 에이전트: 입장 6 → 교차토론 6 → 종합 1) 산출.
> 종합 빌드 청사진은 [`02-skill-spec.md`](./02-skill-spec.md) 참조. 이 문서는 그 청사진이 도출된 **토론의 근거**다.

## 토론으로 해소된 4대 핵심 긴장

| 긴장 | 해소 방식 | 책임 |
|------|-----------|------|
| (a) 미적 대담함 vs 접근성/가독성 | **면적 기반 분리** — 텍스트·의미색=APCA AND WCAG 거부권 성역 / 텍스트 없는 장식면(no-text AND no-meaning)=무드 자유. 위계는 대비를 깎지 않고 크기·굵기·여백으로. | art-director ↔ color-scientist ↔ a11y-ux-lead |
| (b) 전문가 깊이 vs 비개발자 단순함 | **깊이는 백스테이지, 표면은 그림** — OKLCH·APCA·토큰은 산출 내부에서만. 사용자에겐 썸네일·느낌단어·신호등·효과 1문장. | 6인 전원 |
| (c) 자기완결 vs 경량 | **위치 분리** — references/엔 지식(KB) 전부 번들, 산출물엔 tokens.css 1장+인라인 SVG+서브셋 폰트만(런타임 0KB). | design-system-architect ↔ frontend-engineer |
| (d) 무조건 질문게이트 vs 비개발자 피로도 | **질문은 1회·묶음·그림·★추천 디폴트** — 취향 갈리는 4~5개만 능동 질문, 품질 하한선은 secure-by-default로 안 물음. '모름'도 안전한 길로. | 6인 전원 |

## 추가 합의 계약

- **art brief 1페이지 = 단일 상류 SSOT**: 무드 + 대비 거부권 표면 지도 + 모션 예산 + expression/data zone 경계 + 차트 표현층/인코딩층 분리. color·token·a11y·dataviz가 모두 이 한 장을 입력으로 받음.
- **단일 무결성 게이트(BLOCK)**: anti-slop + 토큰lint + APCA AND WCAG + axe + CVD를 하나의 리포트로. skip 불가.
- **대비 게이트는 'AND'**: color-scientist가 a11y의 'or'를 'and'로 수정 — APCA Lc(1차) AND WCAG(하위호환) 둘 다 통과.
- **탐색은 자유, 양산은 표준**: 샘플 시안은 독립 토큰셋으로 다양하게, 선택된 1안만 3계층 SSOT 정규화.
- **차트 권한 분리**: 데이터↔스케일 매핑=dataviz 거부권 / 색공간·램프 생성·대비검증=color-scientist / 차트 제목·여백·강조색=art brief.
- **비용 계층(Tier 0/1/2)**: personality는 비용 0 수단(타이포·여백·CSS grid 비대칭) 1차, 비싼 장식은 성능 예산 통과+폴백 시만.

---

## 라운드 1 — 6인 입장 (핵심만)

### 아트 디렉터 (art-director)
**도메인**: 아트 디렉션 — 미적 방향성 결정, 비주얼 임팩트, 브랜드 톤, AI slop 제거. "예쁘게"가 아니라 "왜 이 방향인가"를 의도로 못박는 사람.
**절대 양보 불가**:
- 기본 스택·기본 룩을 '아무 방향 없이' 산출하는 것 절대 반대. 모든 산출물은 사전에 의도적으로 '하나의 미적 방향'을 골라 정밀 실행 — 방향 없는 결과물은 그 자체가 AI slop.
- anti-slop 체크리스트 통과는 산출의 필수 게이트(skip 불가). 보라 그라데이션 on 화이트·기본폰트 방치·균등 3카드·의미없는 이모지 무조건 차단.
- 샘플 N개는 색만 바꾼 변주가 아니라 서로 다른 personality. 비교의 가치는 다양성에서.
- 임팩트가 가독·신뢰를 이기면 안 되는 도메인(C레벨/분석보고서)이 있다 — 도메인 적합성이 미적 야심보다 우선.
**예상 충돌**: color-scientist(대담한 지배색 vs WCAG 채도·명도 제약) / a11y-ux-lead(글래스모피즘·저대비·모션 hero) / design-system-architect(시안별 personality vs 단일 토큰 일관성) / frontend-engineer(대담한 방향의 구현 비용·성능) / dataviz(에디토리얼 임팩트 vs 데이터 정직성).

### 디자인 시스템 아키텍트 (design-system-architect)
**도메인**: 디자인 토큰(reference→semantic 2계층), 컴포넌트/상태 매트릭스, 토큰 그래프 일관성, 멀티 도메인 단일 토큰 소스.
**절대 양보 불가**:
- 단일 토큰 소스(SSOT) 양보 불가. 4개 도메인이 각자 색·간격·폰트를 손으로 적는 순간 일관성은 거짓말. tokens.json 1개에서 전부 파생되지 않으면 '전문가급'이 아니다.
- raw hex/임의 px 직접 등장은 BLOCK. 토큰 lint 0건이 최종 게이트, '리뷰 스킵'에도 우회 불가.
- 비개발자에게 토큰은 보이면 안 되고, 혜택(한 곳 수정→전체 반영)은 보여야. 성공 지표='사용자가 토큰 존재를 몰라도 결과가 일관'.
- 상태 매트릭스 누락(focus-visible/empty/error)은 미완성. AI slop의 핵심 징후가 '해피 패스만 그린 화면'.
**예상 충돌**: color-scientist(색 결정 권한·네이밍) / frontend-engineer(토큰 추상화 비용·경량 모드) / art-director(표현 자유 vs 시스템 일관성) / dataviz(차트 색을 별도 체계로 가져갈 위험) / a11y(포커스링·대비 토큰 레이어 경계).

### 색채 과학자 (color-scientist)
**도메인**: OKLCH/OKLAB 지각 균일 색공간 팔레트·램프, APCA/WCAG 대비, 다크모드, CVD 안전성, character-first 조화.
**절대 양보 불가**:
- 색의 source of truth는 무조건 OKLCH. HSL lightness 램프는 같은 'L=50%'라도 노랑·파랑 체감 밝기가 천차만별이라 시스템이 깨진다. hex는 폴백 출력일 뿐.
- 대비 검증 없는 색은 산출 불가. 모든 텍스트-배경은 APCA(1차)+WCAG(하위호환) 통과. 미관 vs 가독성 충돌 시 가독성 승.
- CVD 안전성·색 외 이중 부호화는 기본. 색만으로 구분하는 설계는 남성 약 8% 배제.
- accent는 희소 자원. 화면당 1~2개, 60-30-10 — 모든 게 강조되면 'AI slop 무지개'.
**예상 충돌**: art-director(고채도 순색 vs APCA/CVD) / a11y(WCAG 'or' vs APCA 'and') / design-system-architect(색공간 source 권한) / dataviz(차트 기본 팔레트 vs OKLCH 파생) / frontend-engineer(구형 브라우저 vs OKLCH).

### 접근성 & UX 리드 (a11y-ux-lead)
**도메인**: WCAG 2.2 AA/APCA·키보드·포커스·시맨틱 HTML·반응형·절제된 모션을 4개 도메인 전부에 강제하는 게이트키퍼.
**절대 양보 불가**:
- 접근성은 기본 품질. 비개발자가 '몰라서 요청 안 했다'고 AA·키보드·반응형을 빼는 것 금지. secure-by-default.
- 대비비·키보드·focus-visible은 hill to die on — 어떤 미적 이유로도 양보 불가.
- 측정 없는 'A11y Pass' 금지 — axe/Lighthouse 실측 증거 없으면 '완료' 아님.
- 보고서·PPT도 웹앱과 동일 a11y 기준. '읽기/발표용이라 인터랙션 적다'는 면죄부 아님.
**예상 충돌**: art-director(미니멀 저대비·hairline·풀블리드) / color-scientist(팔레트 APCA 임계) / dataviz(다색 구분 색약·차트 애니메이션) / frontend-engineer(시맨틱·포커스 관리 구현 비용) / design-system-architect(포커스링·motion 토큰 1급화).

### 데이터 시각화 & 보고서 전문가 (dataviz-report-specialist)
**도메인**: 분석 리포트, C레벨 덱, HTML 슬라이드, 차트 선택·정보 위계·스토리텔링.
**절대 양보 불가**:
- 차트의 정확성은 미학보다 절대 우위. 축 0 시작 위반·발산 데이터에 순차 스케일·파이 7항목·이중 Y축 같은 '거짓말하는 차트'는 어떤 이유로도 불가.
- 모든 차트·슬라이드·섹션은 결론형 제목(takeaway title). 명사구 제목('월별 매출')은 해석 떠넘기기 직무유기.
- 보고서/덱은 스택보다 스토리라인이 먼저. '질문→답→근거' 논증 구조 없으면 실패작.
- 출처·기준일·표본수·가정 메타데이터 없는 C레벨/분석 보고서는 미완성·출고 거부.
**예상 충돌**: color-scientist(데이터 색 스케일 결정권) / frontend-engineer(인터랙티브 차트 라이브러리) / art-director(풀블리드·드라마틱 레이아웃 vs 데이터 잉크) / a11y(이중 인코딩 범위) / design-system-architect(차트 전용 스케일 분리).

### 프론트엔드 구현 엔지니어 (frontend-implementation-engineer)
**도메인**: 무빌드 산출·실행 가능성·성능(INP/LCP/CLS)·프레임워크 적합성·크로스브라우저·코드 품질.
**절대 양보 불가**:
- 무빌드 더블클릭 동작은 협상 불가. 비개발자가 열기만 하면 동작. npm/node/서버 전제는 명시적 개발팀 인계 케이스 아닌 한 불합격.
- 프레임워크 기본값 없음. Vanilla부터 검토, React/Vue/Svelte는 상태 복잡도가 실제 요구할 때만. 기본 스택 고정은 1급 제약 위반.
- 성능 예산(LCP<2.5s/CLS<0.1/INP<200ms)과 'JS 에러·404 0건'은 완료 조건. 실측 없는 '동작할 것'은 미완성.
- 한국어 가독성(keep-all·줄간격·폰트 폴백)·오프라인 폰트 폴백은 모든 도메인 하한선.
**예상 충돌**: design-system-architect(토큰 추상화의 빌드 의존) / art-director(화려한 모션·이미지 vs 성능 예산) / dataviz(무거운 차트 라이브러리) / a11y(ARIA·포커스 트랩 JS 비용) / 전원('일단 React+Vite' 기본값 반대).

---

## 라운드 2 — 교차 토론 (이견·반박·절충·수정 권고)

> 전문가별 핵심 반박과 최종 수정 권고만 발췌. (전문은 워크플로우 산출 원본 보존)

### 아트 디렉터
- **vs design-system-architect**: 시안 단계와 구현 단계 혼동 반박 → '탐색은 자유(시안별 독립 토큰), 양산은 표준(선택 후 3계층 정규화)'. 레이아웃 의도는 토큰이 아니라 art brief 텍스트로.
- **vs color-scientist**: 대비 거부권은 '텍스트가 올라가는 면'에만. 텍스트 없는 장식 면은 무드 채도 자유. 텍스트는 대비 확보된 별도 면에 배치(레이아웃으로 해결).
- **vs a11y-ux-lead**: '모션=적'은 과잉 교정 → 모션 '예산제'(1회·≤250ms·reduced-motion 0). 무의미한 통통 모션만 slop.
- **vs dataviz**: 데이터 인코딩은 dataviz 불가침, 표현층(타이포·여백·강조색 1개·캡션)은 art brief 지휘. 3D/그림자/무의미 그라디언트 공동 금지.
- **vs frontend-engineer**: '대담함=무거움'은 게으른 구현 변명 → 그레인=SVG/소형타일, 비대칭=CSS Grid(비용 0), 폰트=subset+preload+swap. 구현 기법으로 예산 맞추고 장식부터 버리지 않음.
- **수정 권고**: art brief를 명시적 SSOT로 격상(충돌 해소 조항 내장) / anti-slop 항목을 6인 통합 / 차트 표현층·인코딩층 분리 계약 / 모든 미적 선택에 '의도성 증거' 1문장 전 도메인 필수.

### 디자인 시스템 아키텍트
- **vs frontend-engineer**: 3계층 전부 강제는 철회 → reference→semantic 2계층 BLOCK, component 옵션(경량 모드). lint는 50줄 인라인 JS, 빌드 의존 없음.
- **vs color-scientist**: OKLCH source 동의, 단 12단계 전수 박기 반대 → 참조되는 5~7단계만(고아 토큰 금지).
- **vs art-director**: 다양성은 reference 레이어 교체로, 일관성은 semantic 구조 공유로. 예외는 '명명된 예외 슬롯'으로만.
- **vs a11y**: 포커스링·motion·터치타깃은 semantic 1급 토큰으로 승격(컴포넌트에 흩으면 드리프트).
- **수정 권고**: 3계층 → 2계층 BLOCK+1옵션 / tokens.css=런타임 SSOT·tokens.json=카탈로그 원본 / 검증 통합(토큰lint+APCA+axe 단일 무결성 리포트) / a11y 1급 토큰 승격 / 차트 독립 네임스페이스 color.viz.* / 비개발자 노출은 '디자인 사전 HTML 1장 + README 한 단락'.

### 색채 과학자
- **vs dataviz**: 결정권 통째 가져가기 반대 → 스케일 종류·매핑 의미=dataviz, 램프 수치 생성(OKLCH 등간격·CVD)=color-scientist. 둘 다 통과해야 출고.
- **vs a11y**: 'or'가 위험 → 'AND'. WCAG는 다크모드·회색 텍스트에서 부정확하므로 APCA 1차 + WCAG 보조 둘 다.
- **vs art-director**: 무드/hue는 art brief SSOT, 본문·UI·텍스트 슬롯 채도·명도는 대비 게이트 범위로 자동 클램프. 미달 색은 동일 hue 대체안 거부권.
- **vs frontend-engineer**: OKLCH는 빌드 의존 아님 → oklch() 1차 + @supports not hex 폴백, 산출 시점 1회 계산 하드코딩. 런타임 색 라이브러리 0.
- **수정 권고**: 색 SSOT=OKLCH 앵커+파생(네이밍은 design-system 수용 계약) / 대비 게이트 'APCA AND WCAG' 확정 / dataviz 색 분업 계약 / 면적 기반 이중 트랙 / OKLCH 무빌드 점진 향상 / CVD 이중 부호화 강도 합의 / 색 질문 1개·기본값 always-on·신호등 결과.

### 접근성 & UX 리드
- **vs art-director**: 위계는 크기/굵기/여백/레이아웃으로, 대비를 깎아서 만들지 마라. 풀블리드·글래스모피즘 위 텍스트는 스크림 오버레이 의무+스크림 위 APCA 재측정.
- **vs design-system-architect**: 포커스링·모션·터치타깃은 semantic 1급, 경량 모드에서도 생략 불가(누락 시 lint BLOCK).
- **vs color-scientist**: '장식색 자유'를 'no-text AND no-meaning'으로 엄격 정의. 텍스트 한 글자라도 올라가거나 의미 전달하면 게이트 적용.
- **vs frontend-engineer**: 접근성 JS(스킵링크·포커스트랩·aria-live·키보드 핸들러)는 '정당화되는 인터랙션' 1순위·성능 예산 내 비절약 대상. 단 focus-visible/reduced-motion은 순수 CSS 우선.
- **vs dataviz**: 이중 부호화 1순위는 '직접 라벨+명도 분리'(패턴은 흑백 인쇄/고밀도만). 모든 차트 스크린리더용 데이터테이블 대체본은 협상 불가.
- **수정 권고**: APCA Lc 1차+WCAG 하위호환 이중 게이트 / 스크림 오버레이 의무 / 포커스·모션·터치타깃 semantic 1급 / 'no-text AND no-meaning' 정의 / 차트 table 대체본 의무 / 접근성 JS 비절약+CSS 우선 / 실측 강제(dev-only, 산출물 무게 0) / a11y 질문 1개(모름→예) / 보고서·C레벨·PPT도 동일 기준.

### 데이터 시각화 & 보고서 전문가
- **vs art-director**: data zone(차트·표·KPI)은 데이터 잉크 규율(3D/그림자/그라디언트 금지), expression zone(표지·간지·타이포)은 미적 자유. art brief에 'data zone=절제 영역' 명문화 요구.
- **vs color-scientist**: 색공간·램프·대비검증=color-scientist, 데이터↔스케일 매핑·축 0 시작·인코딩 일관성=dataviz. 램프 3종을 데이터에 '배정'하는 계약.
- **vs a11y**: 무차별 패턴 채우기는 차트를 시끄럽게 → 1순위는 직접 라벨+명도 차이, 패턴은 흑백 인쇄/인접 segment만. 데이터테이블 대체본이 패턴보다 우선.
- **vs frontend-engineer**: 정적 SVG 기본 동의, 단 고밀도 데이터는 호버·필터가 본질 → 인터랙션 2조건(정적 불가 밀도 + 정적 폴백) 충족 시 경량 허용.
- **vs design-system-architect**: 정적 산출물에 8상태 전수는 과잉 → 차트/표 필수 4상태(empty·overflow·NA·print) 재정의.
- **수정 권고**: 차트 토큰 분리 레이어(color.viz.*) / 데이터↔스케일 결정권 분리 계약 / expression vs data zone 2분할 art brief 명시 / takeaway title 강제 / 정적 4상태 / 직접라벨+명도 우선·table 대체본 / 메타데이터 푸터 필수 / 정적 SVG 기본·인터랙션 2조건 / '하고 싶은 말 5지선다'+전문성 엔진에 숨김(단 데이터 정직성 결정만 명시 동의).

### 프론트엔드 구현 엔지니어
- **vs design-system-architect**: 도메인 무차별 8상태 강제는 무빌드·경량과 충돌 → 웹앱 8상태, 정적 보고서/PPT는 focus-visible+empty+overflow+print 4상태. lint는 개발 시점만(사용자 폴더에 node 스크립트 금지).
- **vs art-director**: intentionality 100% 동의, 단 성능 예산 깨면 '느리게 다듬은 티'. 비용 계층(Tier 0/1/2)으로 personality 분리.
- **vs color-scientist**: 슬라이더 재파생은 산출 시점에 우리가 수행(tokens.css 재생성), 산출물은 정적 1장 유지. 라이브 테마 편집기는 개발팀 인계 케이스로 분리.
- **vs a11y**: 포커스 트랩/aria-live는 실제 동적 DOM 교체에만. 정적 다중페이지·앵커 보고서는 landmark+스킵링크+focus-visible로 충분.
- **vs art-director(샘플)**: 풀 산출 N벌은 비용 N배·헤드리스 캡처 전제 → 경량 시안 1장씩 + index.html iframe/링크 비교. 선택 1안만 풀 확장.
- **수정 권고**: 무빌드 더블클릭 hill 유지(토큰·OKLCH가 순수 CSS로 양립 확인) / 검증 인프라·산출 자산 물리 분리(사용자 폴더에 빌드 잔재·도구 금지) / 비용 계층 구조화 / 차트 정적 인라인 SVG 기본 / 상태·포커스·aria-live는 실제 인터랙션에만 청구 / 샘플 경량+선택 1안 풀 확장 / 한국어 타이포 하한선 토큰화 / 프레임워크 결정 트리(React 기본값 고정 반대).

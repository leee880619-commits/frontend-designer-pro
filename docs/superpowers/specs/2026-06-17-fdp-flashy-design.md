# frontend-designer-pro 화려함 전환 설계 (2026-06-17)

## 1. 목표

`frontend-designer-pro`(이하 pro)를 일반 `frontend-designer` 스킬처럼 **화려한(maximalist) 출력**이 나오도록 전환한다. 단 **접근성 하한선은 유지**하고 **모든 도메인**(웹앱/분석보고서/C레벨/발표덱/Python웹앱/기타)에 적용한다.

배경: pro는 "절제(restraint)" 우선 철학이라 일반 designer 대비 결과가 차분/밋밋하게 나온다. 사용자가 일반 designer 수준의 시각 임팩트를 원한다.

## 2. 확정된 결정 (사용자 승인)

- **개선 범위**: 완전 전환 (절제 제거).
- **접근성 하한선**: 유지 (대비 이중 게이트 APCA+WCAG, 키보드/스킵링크/시맨틱, reduced-motion 폴백, 터치 타깃).
- **도메인 범위**: 모든 도메인.
- **품질 4항목**: 유지 (anti-slop A2 의도적 폰트 / A3 Bento(균등카드 금지) / A4 이모지 아이콘 금지 / A8 결론형 차트제목). 일반 designer도 이 4개는 지키며, 제거하면 오히려 더 AI슬롭스러워지므로 남긴다.
- **적용 위치**: 캐시(실행본) + 마켓플레이스 소스 둘 다 동일 반영.
- **실행 방식**: superpowers 워크플로우, 모든 서브에이전트 Opus 구동.

## 3. 변경 대상 (화려함 잠금 해제 = 제거/완화)

> 모든 경로는 두 곳에 적용한다:
> - 캐시: `C:\Users\lee880619\.claude\plugins\cache\frontend-designer-pro\frontend-designer-pro\1.4.1\`
> - 소스: `C:\Users\lee880619\.claude\plugins\marketplaces\frontend-designer-pro\`

| # | 제약 | 파일 | 조치 |
|---|------|------|------|
| C1 | 모션 예산 (`--motion-duration-base` 200ms, 상한 <=250ms, 진입 1회) | `references/_contract.md §1` | 상한 제거/대폭 상향. 긴 지속, 스크롤 리빌, 루프 애니메이션 허용. **단 `--motion-reduce` 0 및 reduced-motion 폴백 토큰은 유지(접근성)** |
| C2 | Tier2 효과 성능예산/폴백 강제 (글래스모피즘/3D틸트/마그네틱/카운트업/패럴랙스/스크롤리빌) | `skills/frontend-designer-pro/SKILL.md` 렌즈6 (line ~167) | Tier2를 성능예산/art-brief 정당화 없이 기본 허용. 일반 designer 기법(스크롤 애니메이션/글래스/틸트/마그네틱/카운트업)을 권장 기법으로 명시 |
| C3 | A1 보라 그라데이션-온-화이트 금지 | `references/anti-slop-checklist.md` A1 | 그라데이션 일반 허용. 보라-온-화이트 클리셰만 "비권장 메모"로 강등(BLOCK 아님) |
| C4 | A7 accent 과다 금지 (accent <=2, <=10% 면적, 60-30-10) | `references/anti-slop-checklist.md` A7 | accent 개수/면적 캡 제거. 대담한 색/다색 허용 |
| C5 | A9 모션 캡 (통통/무한/>250ms 금지) | `references/anti-slop-checklist.md` A9 | "통통/무한/>250ms 금지" 제거. **reduced-motion 폴백 필수 조항은 유지(접근성)** |
| C6 | 도메인 절제 기본값 (luxury/editorial 채도 캡, C레벨 "절제>화려") | `references/aesthetic-directions.md`, `references/color-token-contract.md` | 도메인별 OKLCH 채도(C) 상한 상향. C레벨/보고서의 "신뢰/가독/절제 > 화려함" 강제 해제. 모든 도메인 bold 허용 |
| C7 | 게이트 SSOT의 위 항목 BLOCK 등록 | `references/_block-card.md` | A1/A7/A9-모션 관련 BLOCK 등록을 완화/제거. Tier2/채도 관련 하드게이트 해제 |
| C8 | redteam 미적 BLOCK 검사 | `agents/design-redteam-pro.md §2.1` | C3~C7에서 푼 항목의 BLOCK/grep 검사 비활성화. **접근성/품질4항목 검사는 유지** |
| C9 | SKILL.md 본문의 절제 서술 | `skills/frontend-designer-pro/SKILL.md` (모션 예산 문구, anti-slop 9항목 나열 등 line 55,137 등) | C1~C7과 일관되게 본문 서술 갱신(상충 문구 제거) |

## 4. 유지 대상 (변경 금지)

### 4.1 접근성 하한선 (사용자 결정)
- 대비 이중 게이트: 본문 APCA Lc>=75 AND WCAG 4.5:1, 보조/대형/UI 등급별 임계.
- 완전 키보드 내비 + `:focus-visible` 2px(대비 3:1) + skip link + landmark/h1->h6 위계.
- reduced-motion 폴백 (`@media (prefers-reduced-motion: reduce)` 0 처리) -- C1/C5에서 손대지 않는다.
- 터치 타깃 >=24px(권장 44px), 동적 DOM 교체 시 포커스 관리/aria-live.
- 차트 대체본(table+caption+th scope), CVD 안전 이중 인코딩(직접라벨+명도분리).

### 4.2 품질 4항목 (anti-slop 잔류)
- A2 의도적 폰트(기본폰트 방치 금지), A3 Bento(균등 3카드 금지), A4 이모지 아이콘 금지, A8 결론형 차트제목.

### 4.3 거버넌스 골격
- 질문 게이트, 무결성 게이트 자체(skip 불가), light/full 모드, 메타데이터 푸터, 무빌드 더블클릭 -- 구조는 유지. 게이트의 "미적 BLOCK 기준"만 완화한다.

## 5. 검증 기준 (성공 조건)

1. 변경 후 화려한 산출물(스크롤 애니메이션 + 글래스모피즘 + 대담한 색/그라데이션 + 카운트업 등)이 **무결성 게이트를 통과**한다(이전에는 BLOCK).
2. **접근성 위반(저대비 본문, 키보드 불가, reduced-motion 폴백 누락)은 여전히 BLOCK**된다.
3. 품질 4항목 위반(이모지 아이콘, 기본폰트, 균등카드, 명사구 차트제목)은 여전히 지적된다.
4. 캐시/소스 두 위치의 해당 파일이 **동일 내용**이다.
5. 샘플 1개를 실제로 생성해 1~3을 눈으로 확인한다.

## 6. 범위 밖 (Out of Scope)

- pro의 질문 게이트/모드 분류/저장 인계 등 워크플로우 골격 재설계.
- 일반 `frontend-designer` 스킬 수정.
- 플러그인 버전 bump/배포(원격 push)는 사용자 지시 시에만.

## 7. 위험 / 주의

- 캐시와 소스가 byte-identical이 아닐 수 있음(파일 수 상이 보고됨). 각 위치에서 동일 의미 변경을 보장하되, 라인 번호는 위치별로 재확인.
- `_contract.md`가 상수 SSOT이므로 여기 값과 SKILL.md/_block-card.md 서술이 어긋나면 게이트가 오작동. 세 파일 일관성 필수.
- redteam과 references를 동시에 풀어야 full 모드 왕복에서 다시 BLOCK되지 않음.

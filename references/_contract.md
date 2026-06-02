# _contract.md — 상수·토큰명·임계값 단일 진실원천 (KB SSOT)

> **이 파일의 정체**: references 전반에 흩어져 복제되던 상수·정규 토큰명·임계값·lint 규칙을 **한 번만** 정의하는 단일 소스. 다른 references는 이 값을 **복제하지 말고 이 파일을 링크**한다.
>
> **자기완결의 재정의**: "각 파일이 단독으로 읽힌다"가 아니라 **"KB 묶음이 단독으로 동작한다"**. 상수는 여기서만 정의하고 나머지는 참조 → 시간이 지나도 갈라지지 않는다.
>
> **검증**: `tools/kb-consistency-check.sh`가 references 전체에서 아래 상수를 grep해 **단일값인지 단언**한다(위반 시 비0 종료). 머신 판독용 미러는 `references/tokens.contract.json`.

---

## 1. 모션 (motion)

| 상수 | 확정값 | 예산 상한 | 비고 |
|------|--------|-----------|------|
| `--motion-duration-fast` | **120ms** | — | 짧은 마이크로 인터랙션 |
| `--motion-duration-base` | **200ms** | **≤250ms** | 보통 애니메이션. 예산 상한(250ms)과 기본값(200ms)은 다른 개념 — 기본값은 200ms로 단일 확정 |
| `--motion-reduce` | `1`(허용) / reduced 시 `0` | — | `@media (prefers-reduced-motion: reduce)`에서 0 |

> 모션 예산 규율: **1회·≤250ms·reduced 0**(`anti-slop-checklist.md`·`a11y-checklist.md` §5.2).

## 2. 포커스 (focus)

| 상수 | 확정값 | 비고 |
|------|--------|------|
| `--focus-ring-color` | `var(--color-brand-500)` | 배경 대비 3:1 이상(UI 게이트) |
| `--focus-ring-width` | **2px** | `:focus-visible` 표시 굵기 |
| `--focus-ring-offset` | **2px** | 요소와 링 사이 간격 |
| `--target-size-min` | **24px** | 최소 터치 타깃(권장 44px) |

## 3. 대비 임계 (APCA Lc AND WCAG) — 성역 / BLOCK

> **이중 게이트**: 두 값을 **AND**로 통과해야 PASS(`color-token-contract.md` §3 / `a11y-checklist.md` §1.2). 측정 대상 = **전경색 vs 실제 깔리는 배경색**(그라데이션/이미지/글래스면 가장 불리한 지점).

| 텍스트/요소 역할 | APCA Lc 하한 | WCAG 비율 하한 |
|------------------|-------------|----------------|
| **본문**(14~18px 일반 굵기) | **Lc ≥ 75** | **≥ 4.5:1** |
| **보조 텍스트**(캡션·메타) | **Lc ≥ 60** | ≥ 4.5:1 |
| **대형 텍스트**(≥24px 또는 ≥18.66px bold) / **UI 컴포넌트**(버튼 테두리·아이콘·focus ring·차트 축선) / **incidental(출처·푸터·저작권·백링크 등 의도적 de-emphasize spot 텍스트)** | **Lc ≥ 45** | **≥ 3:1** |
| **비활성(disabled)** | **Lc ≥ 30** | (권장) |

> **역할 분류 주의**: 같은 작은 글씨라도 **핵심 본문**은 Lc≥75로 엄격히, **incidental(footer·copyright·메타·백링크)** 은 spot-text 밴드 Lc≥45로 본다. 평면적으로 모든 작은 글씨를 본문 기준으로 과탐하면 의도적으로 낮춘 푸터·출처를 "FAIL"로 오판해, 비개발자가 멀쩡한 요소를 고치려 드는 오해를 부른다. `tools/_audit.html`의 `roleOf()`가 `<small>`·`<footer>`/`[role=contentinfo]` 후손·메타 클래스 신호로 incidental을 판별한다. incidental 낮음은 **연성 경고(DevTools APCA 교차확인 권장)**, 핵심 FAIL은 **BLOCK**으로 분리 보고.
> **AND 극단 상충**: 아주 밝거나 어두운 짝에서 APCA와 WCAG가 한쪽만 통과할 수 있다. 이 경우 **둘 다 통과할 때까지** 명도를 한 스텝씩 조정한다(더 엄격한 쪽을 따른다).
> **간이 APCA 한계**: references/`tools/_audit.html`의 APCA는 폰트 크기·굵기 룩업을 생략한 간이판(보수적). 경계 케이스(임계 ±2 이내)는 **Chrome DevTools 내장 APCA**(설치 0) 또는 axe-core로 교차검증.

## 4. 정규 토큰명 (canonical token names) — reference 계층

> **컨벤션 1종 고정: `--color-*`**. `--ref-*` 접두는 금지. 의미·계층:

| 계층 | 접두/형식 | 예 | 직접 raw 값 |
|------|-----------|-----|-------------|
| **reference**(원자재 팔레트) | `--color-<계열>-<단계>` · `--space-N` · `--font-*` · `--line-*` · `--radius-*` · `--shadow-*` · `--duration-*` | `--color-brand-500`, `--color-gray-900`, `--space-4` | 허용(원자재라 날값 OK) |
| **차트 전용**(독립 네임스페이스) | `--color-viz-categorical-1~8` · `--color-viz-sequential-*` · `--color-viz-diverging-*` · `--color-viz-grid` · `--color-viz-axis` · `--color-viz-annotation` | `--color-viz-categorical-1` | 허용 |
| **semantic**(역할) | `--text-*` · `--bg-*` · `--border-*` · `--accent` 등 | `--text-body: var(--color-gray-900)` | **금지**(반드시 `var()`) |
| **component**(옵션) | `--button-*` 등 | `--button-primary-bg: var(--accent)` | **금지** |
| **a11y 1급**(semantic 승격) | 아래 §5 7키 | `--focus-ring-width: 2px` | **raw 허용**(설계상 px/플래그값 — lint HARDCODE 면제) |

- **차트 색**: `--color-viz-*` 독립 네임스페이스. categorical은 **8색 이내**. `--color-viz-accent`/`--color-viz-neutral` 같은 임의 명명 금지 → `categorical-1~8`로.
- **brand 강조색**: reference는 `--color-brand-500`. semantic `--accent: var(--color-brand-500)`. `--color-accent-*`를 reference로 두지 않는다.

## 5. a11y 1급 토큰 7키 (경량 모드에서도 필수 — 누락 시 lint BLOCK)

```
--focus-ring-color  --focus-ring-width  --focus-ring-offset
--motion-duration-fast  --motion-duration-base  --motion-reduce  --target-size-min
```

> 이 7키는 **lint의 ORPHAN·HARDCODE 검사에서 면제**된다(`:root` 직접 소비 대상이고, width/offset/target-size/duration은 설계상 raw px·ms·플래그를 담음). `token-lint.js`의 `A11Y` 배열이 이 목록과 일치해야 한다.

## 6. lint 규칙 (정규식) — `token-lint.js` 정합

| 규칙 | 정의 | 등급 |
|------|------|------|
| `isRef`(reference 계층 판별) | `/^--color-\|^--space-\|^--font-\|^--line-\|^--radius-\|^--shadow-\|^--duration-/` | — |
| DANGLING | `var(--x)`인데 `--x` 미정의 | BLOCK |
| CIRCULAR | A→B→A 순환 참조 | BLOCK |
| ORPHAN | 정의됐으나 미참조(§5 a11y 7키 면제) | WARN |
| HARDCODE | semantic/component(=비-reference, **§5 a11y 7키 제외**)에 `var()` 대신 날 hex/px | BLOCK |
| A11Y-MISS | §5 7키 중 하나라도 누락 | BLOCK |

> **HARDCODE의 a11y 면제**: `isRef`가 `--focus-*`/`--motion-*`/`--target-*`를 reference로 인정하지 않아, 설계상 raw px를 담는 a11y 7키(`--focus-ring-width:2px` 등)가 HARDCODE로 **오판 BLOCK**되던 문제. lint는 `A11Y` 배열에 든 이름을 HARDCODE 검사에서도 면제한다(ORPHAN 면제와 동일하게).

## 7. 언어 (lang)

| 상수 | 기본값 | 비고 |
|------|--------|------|
| `<html lang>` | **`ko`**(기본) | 비한국어 청중 산출 시 `{{LANG}}`로 파라미터화(`build-boilerplate.md` §1). 스크린리더 발음·`word-break` 동작 전제 |

---

> **변경 절차**: 위 값 중 하나를 바꾸려면 (1) 이 파일을 고치고 (2) `tokens.contract.json` 미러를 동기화하고 (3) 해당 값을 참조하는 references·`tools/_audit.html`을 갱신한 뒤 (4) `tools/kb-consistency-check.sh`로 단일값 단언을 통과시킨다. 어느 하나만 고치면 드리프트가 재발한다.
>
> **함수 본문 동기**: `tools/_audit.html`은 `apcaLc`/`wcagRatio`/`lintTokens`/CVD 행렬을 `color-token-contract.md` §3.2·§7.3 / `token-system.md` §8에서 **본문째 복제**해 담는다(무빌드·라이브러리 0이라 import 불가). 측정식·lint 로직을 한쪽에서 고치면 **반드시 양쪽을 함께** 고친다. `kb-consistency-check.sh`는 임계 상수 드리프트는 잡지만 함수 본문 드리프트는 grep으로 못 잡으므로, 이 동기는 변경자가 수동 보장한다(`_audit.html` 상단·각 함수 주석에 "사본 — 양쪽 동기" 명시).

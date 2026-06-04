# 05 — dogfood / 검증 리포트 (v1.0.0 복원 + v1.0.1 델타)

> 이 문서는 레드팀 지적 **F5(dogfood 리포트 유실)**를 해소하기 위해 복원·갱신한 검증 기록이다.
> v1.0.0의 dogfood는 실제로 수행됐으나(아래 §1) 리포트 파일이 최종 레포에 커밋되지 않았다. 여기서 그 결과를 복원하고, v1.0.1 변경의 검증을 덧붙인다.

## 1. v1.0.0 dogfood (실측 기록 — frontend-forge 빌드 세션에서 복원)

- **도구**: `/dogfood` 스킬 + agent-browser 0.27.1 (Chrome 149 headless), 동일출처 보장을 위해 `python -m http.server`로 서빙.
- **대상**: 스킬 방법론으로 생성한 "분석 보고서 샘플 갤러리(시안 3종: editorial / soft-modern / technical)" — 현재 `examples/demo-analysis-gallery/`.
- **결과**: **PASS**
  - ✅ 렌더 정상 · 콘솔 에러 0건 · 무빌드(JS 0바이트, `file://` 더블클릭 동작)
  - ✅ 시안 3종 personality 구분(폰트 스택·radius·팔레트 상이) · 갤러리 iframe + 정적 링크 폴백 동작
  - ✅ 대비(APCA AND WCAG)·CVD 3종·토큰 lint 게이트 통과
  - ⚠️→✅ 검증 중 OKLCH 색 readback 관련 이슈 1건 발견 → `_audit.html`의 1×1 캔버스 픽셀 readback으로 수정 → 재검증 통과 (스크린샷 8장 확보)

> 근거: 빌드 세션(`tool/frontend-forge`) 대화 기록. 당시 작성된 `docs/03-dogfood-report.md`가 이후 `03-landing-art-brief.md`와 번호 충돌로 최종 레포에 누락됐다.

## 2. v1.0.1 변경의 성격과 검증

v1.0.1 변경은 **런타임 산출물(데모 HTML)을 바꾸지 않는다**. 변경은 ① 경로 해석 수정(F1) ② Python 분기 신설(F2, 문서) ③ 저장위치 규칙(F3, 문서) ④ 첨부의도 필드(F4, 문서) ⑤ 패키징 메타·README다.

- **`examples/` 무변경 확인**: `git status examples/` = 빈 출력. 데모 갤러리 HTML이 v1.0.0과 **바이트 동일**이므로, §1의 렌더 PASS가 그대로 유효하다(렌더는 결정론적).
- **자동 일관성 게이트 PASS**: `bash tools/kb-consistency-check.sh` → `RESULT: PASS`(신규 `python-ui-theming.md`의 모션 토큰을 `_contract.md` 확정값 200ms/120ms·`--motion-reduce` 곱셈 패턴으로 정렬한 뒤 통과).
- **패키징 JSON 유효**: `plugin.json`·`marketplace.json` 파싱 정상, `version: 1.0.1` 동기화.
- **경로 무결성(F1)**: `skills/`·`agents/`에 잔여 바 상대경로(`references/…`·`tools/…`) **0건**, 전부 `${CLAUDE_PLUGIN_ROOT}/…` 절대경로로 치환. 이중 치환 0건.

## 3. 잔여 검증 한계 (정직 보고)

- **F1의 설치 런타임 실측 미수행**: `${CLAUDE_PLUGIN_ROOT}` 치환이 설치된 플러그인에서 실제로 resolve되는지는 **공식 문서·claude-code-guide 확인에 근거**한 것으로, 설치본을 재호출한 end-to-end 실측은 이 세션에서 수행하지 않았다. 다음 실사용 1회 또는 별도 설치 테스트로 최종 확인 권장.
- **4.6 Python 분기 실산출 미검증**: 신설 분기는 reference 지식(테마 주입 패턴)으로 자기완결돼 있으나, 실제 Streamlit/Gradio 앱에 적용한 산출 dogfood는 아직 없다(첫 실사용 시 검증 대상).

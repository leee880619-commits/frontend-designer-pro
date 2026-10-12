# frontend-designer-pro Flashy Conversion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert `frontend-designer-pro` so it produces maximalist/flashy output like the regular `frontend-designer` skill, while keeping accessibility floors and 4 quality anti-slop items, across all domains.

**Architecture:** The plugin's "restraint" is enforced across 7 files (references + SKILL.md + redteam agent). We loosen the aesthetic-suppressing gates (motion budget, Tier2 gating, gradient ban, accent cap, per-domain saturation caps, redteam aesthetic BLOCKs) and keep the accessibility gates and 4 quality items untouched. There is no code test harness; each task's "test" is a grep verification that the restraint text changed AND the preserved text remains, plus a final acceptance check that generates a sample.

**Tech Stack:** Markdown reference files, CSS custom-property token contracts, Claude Code plugin agent prompts. No build, no runtime tests.

## Global Constraints

These apply to EVERY task implicitly.

- **Dual-location:** Apply each change in BOTH locations, identical content:
  - Cache (runs now): `C:\Users\lee880619\.claude\plugins\cache\frontend-designer-pro\frontend-designer-pro\1.4.1\`
  - Source (persists): `C:\Users\lee880619\.claude\plugins\marketplaces\frontend-designer-pro\`
- **Concrete loosened values (use identically across _contract.md, _block-card.md, SKILL.md, redteam):**
  - Motion: remove the `<=250ms` ceiling and the "entry-once / no infinite" rule for DECORATIVE motion. Keep `--motion-duration-fast`/`--motion-duration-base` as defaults for functional UI feedback. Decorative animation (scroll-reveal, count-up, parallax, looping ambient) is allowed at any duration AND may loop, PROVIDED a `prefers-reduced-motion: reduce` fallback exists.
  - Accent: remove the hard cap "accent <=2 anchors / <=10% area". 60-30-10 becomes a non-blocking suggestion. Bold/multi-accent palettes allowed.
  - Saturation: remove per-domain OKLCH chroma (C) caps. Allow high chroma (e.g. C up to ~0.30) in ALL domains including C-level/report/deck. Contrast gate still constrains text colors naturally.
  - Tier2 effects (glassmorphism, 3D tilt, magnetic buttons, count-up, parallax, scroll-reveal): allowed by default, NOT gated behind performance-budget + art-brief justification. Performance budget (LCP/CLS/INP) stays as advisory, not a BLOCK.
- **PRESERVE (do not weaken) -- accessibility floor:** APCA Lc + WCAG 4.5:1 dual contrast gate; full keyboard nav + `:focus-visible` 2px (3:1) + skip link + landmark + h1->h6 hierarchy; `prefers-reduced-motion: reduce` fallback (`--motion-reduce:0` and the @media reset); touch target >=24px; chart `table+caption+th scope` alt; CVD dual-encoding (direct label + lightness separation).
- **PRESERVE -- quality 4 anti-slop items:** A2 (deliberate fonts, no default-font abandonment), A3 (Bento / no equal 3-card grid), A4 (no emoji-as-icons), A8 (conclusion/takeaway chart titles, no bare noun-phrase). Do NOT touch these.
- **PRESERVE -- governance skeleton:** question gate, the integrity gate itself (still skip-impossible), light/full mode split, metadata footer, no-build double-click handoff. Only the AESTHETIC BLOCK CRITERIA loosen.
- **Constant consistency:** `_contract.md` is the constants SSOT. Any value referenced in `_block-card.md`, `SKILL.md`, or `design-redteam-pro.md` must match `_contract.md`.
- **No auto-commit, no remote push** unless the user later asks.
- **cp949 safety:** ASCII punctuation only in any new/edited text (`-` or `--` not em-dash, straight quotes, `...`, `->`). Korean text is fine.

---

### Task 1: Loosen anti-slop A1 / A7 / A9 (keep A2-A4-A8 and reduced-motion)

**Files:**
- Modify: `references/anti-slop-checklist.md` (both locations) -- items A1 (~L78-92), A7 (~L126-140), A9 (~L142-150+)

**Interfaces:**
- Produces: the canonical wording for "gradients allowed", "accent cap removed", "decorative motion allowed but reduced-motion required" that Tasks 3 and 7 must mirror.

- [ ] **Step 1: Read the file** and locate items A1, A7, A9 by their headings.
- [ ] **Step 2: Edit A1 (purple gradient on white).** Change from a BLOCK to a non-blocking note: gradients (including multi-stop, vivid) are allowed as a deliberate choice. Keep only a soft advisory that the specific "indigo/violet gradient on plain white SaaS-hero" combo is an overused cliche to avoid by default -- NOT a BLOCK.
- [ ] **Step 3: Edit A7 (accent overspray).** Remove the hard cap (3+ accents OR >20% area = BLOCK; the <=2 anchor / <=10% rule). Reframe 60-30-10 as an optional balance suggestion. Bold and multi-accent palettes are permitted.
- [ ] **Step 4: Edit A9 (bouncy motion).** Remove the "no bounce/pulse/wobble/float infinite", ">250ms forbidden", and "entry-once" prohibitions. Decorative motion may be long-running and looping. KEEP the requirement that a `prefers-reduced-motion: reduce` fallback exists -- this stays a BLOCK (accessibility).
- [ ] **Step 5: Confirm A2, A3, A4, A8 are UNCHANGED** (deliberate fonts / Bento / no emoji icons / conclusion chart titles).
- [ ] **Step 6: Verify (grep).** Run in each location:
  - `references/anti-slop-checklist.md` no longer contains a BLOCK on accent count/area or on motion duration/loop.
  - It still contains the `prefers-reduced-motion` requirement and A2/A3/A4/A8 intact.
- [ ] **Step 7: Diff both locations** to confirm A1/A7/A9 wording is identical in cache and source.

---

### Task 2: Loosen motion budget in _contract.md (constants SSOT)

**Files:**
- Modify: `references/_contract.md` (both locations) -- Section 1 (motion), ~L15-19

**Interfaces:**
- Consumes: motion wording from Task 1 (A9).
- Produces: the authoritative motion constants/rules referenced by `_block-card.md` (Task 3), `SKILL.md` (Task 4), redteam (Task 7).

- [ ] **Step 1: Read Section 1 (모션).**
- [ ] **Step 2: Edit the ceiling.** Remove the hard `<=250ms` ceiling and the "1 entry only / no infinite" rule for decorative motion. Keep `--motion-duration-fast` (120ms) and `--motion-duration-base` (200ms) as DEFAULTS for functional UI transitions. Add that decorative motion (reveal/count-up/parallax/ambient loop) is unrestricted in duration and may loop.
- [ ] **Step 3: Keep `--motion-reduce` 0** and the reduced-motion contract intact (accessibility). State explicitly that reduced-motion fallback remains mandatory.
- [ ] **Step 4: Verify (grep).** `_contract.md` Section 1 no longer asserts a 250ms ceiling or no-loop rule; still defines `--motion-reduce` 0 and reduced-motion requirement.
- [ ] **Step 5: Diff both locations** for identical Section 1.

---

### Task 3: Relax aesthetic BLOCKs in _block-card.md (hard gate SSOT)

**Files:**
- Modify: `references/_block-card.md` (both locations) -- Section A (anti-slop), and any motion/accent/saturation hard-gate lines

**Interfaces:**
- Consumes: Task 1 (A1/A7/A9 wording), Task 2 (motion constants).
- Produces: the gate definition the runtime + redteam treat as BLOCK truth.

- [ ] **Step 1: Read the card.** Find Section A (anti-slop A1-A9) and any lines registering accent-cap / motion-cap / Tier2 / saturation as BLOCK.
- [ ] **Step 2: Remove/relax** the BLOCK registration for A1 (gradient), A7 (accent cap), and the A9 motion-duration/loop prohibitions. Remove any Tier2-gating BLOCK and per-domain saturation-cap BLOCK.
- [ ] **Step 3: Keep as BLOCK:** the contrast dual-gate (Section C), keyboard/structure/axe (Section D), reduced-motion fallback presence, and A2/A3/A4/A8.
- [ ] **Step 4: Verify (grep).** Section A no longer BLOCKs gradient/accent-count/motion-duration; Sections C/D and reduced-motion still present as BLOCK; A2/A3/A4/A8 still listed.
- [ ] **Step 5: Diff both locations.**

---

### Task 4: Unlock Tier2 + fix body text in SKILL.md

**Files:**
- Modify: `skills/frontend-designer-pro/SKILL.md` (both locations) -- Lens 6 Tier system (~L167), motion-budget mention (~L55), anti-slop list framing (~L137)

**Interfaces:**
- Consumes: Tasks 1-3 (loosened wording + constants).
- Produces: the user-facing/runtime instruction body consistent with the loosened gates.

- [ ] **Step 1: Read Lens 6 (frontend-implementation-engineer) Tier list (~L167).**
- [ ] **Step 2: Edit Tier system.** Move Tier2 effects (video/grain/parallax + glassmorphism/3D tilt/magnetic/count-up/scroll-reveal) to "allowed by default". Keep performance budget (LCP<2.5s/CLS<0.1/INP<200ms) as ADVISORY, and `prefers-reduced-motion` fallback as REQUIRED. State that flashy techniques (scroll-reveal animations, glassmorphism, tilt, magnetic buttons, count-up, bold gradients/colors) are encouraged like the regular frontend-designer.
- [ ] **Step 3: Edit motion-budget line (~L55, art brief / 모션 예산).** Replace "진입 1회 / <=250ms" with the loosened rule (decorative motion unrestricted + reduced-motion fallback). Keep expression-zone vs data-zone concept.
- [ ] **Step 4: Edit anti-slop list framing (~L137, Lens 1).** Update the parenthetical 9-item list so it no longer names gradient/accent-overspray/bouncy-motion as auto-avoid; keep listing the quality items (default font, equal 3-card, emoji icons, noun-phrase chart title). Keep accessibility language.
- [ ] **Step 5: Scan the rest of SKILL.md** for any other "절제 > 화려" / motion-cap / accent-cap phrasing in domain notes (esp. C-level §4.3, report §4.2) and reconcile with "bold allowed in all domains" (coordinate with Task 5).
- [ ] **Step 6: Verify (grep).** No remaining `<=250ms`, "진입 1회", "accent ... 1~2" hard limits; Tier2 effects present as allowed; reduced-motion + dual-contrast language intact.
- [ ] **Step 7: Diff both locations.**

---

### Task 5: Lift per-domain restraint defaults in aesthetic-directions.md

**Files:**
- Modify: `references/aesthetic-directions.md` (both locations) -- domain sections (§1-8) + cheat sheet (§9/§10)

**Interfaces:**
- Consumes: Global Constraints (bold allowed all domains).
- Produces: domain aesthetic defaults consistent with Task 6 chroma ranges.

- [ ] **Step 1: Read the domain mapping** (luxury/editorial/minimal/soft-modern/technical/editorial-bold/marketing).
- [ ] **Step 2: Edit C-level/report defaults.** Remove the "절제/신뢰 > 화려함" mandate as a hard default. Allow bold/maximalist direction as a first-class option in every domain (still default-suggestable, not forced-restrained).
- [ ] **Step 3: Raise chroma guidance** so no domain is capped at low C; align numbers with Task 6.
- [ ] **Step 4: Verify (grep).** No domain section forces low-chroma/restraint-only; bold permitted everywhere; quality + accessibility unaffected.
- [ ] **Step 5: Diff both locations.**

---

### Task 6: Raise OKLCH chroma ranges in color-token-contract.md (keep contrast gate)

**Files:**
- Modify: `references/color-token-contract.md` (both locations) -- per-domain chroma ranges; 60-30-10 wording

**Interfaces:**
- Consumes: Task 5 (domain defaults).
- Produces: chroma ranges referenced by color ramp derivation.

- [ ] **Step 1: Read chroma/saturation ranges and the 60-30-10 / accent rules.**
- [ ] **Step 2: Edit chroma ranges.** Raise per-domain C upper bounds (allow vivid, e.g. up to ~0.30) for all domains. Reframe 60-30-10 / accent-count as suggestion, not cap (mirror Task 1 A7).
- [ ] **Step 3: PRESERVE the contrast contract** (APCA Lc + WCAG thresholds, hex fallback for oklch, CVD dual-encoding). These are accessibility -- do not weaken.
- [ ] **Step 4: Verify (grep).** Chroma caps raised; contrast/CVD thresholds intact.
- [ ] **Step 5: Diff both locations.**

---

### Task 7: Disable loosened aesthetic checks in design-redteam-pro.md

**Files:**
- Modify: `agents/design-redteam-pro.md` (both locations) -- §2.1 anti-slop validation (A1/A7/A9 checks + grep hints), any Tier2/saturation/motion BLOCK conditions

**Interfaces:**
- Consumes: Tasks 1-6 (must mirror exactly so full-mode review does not re-BLOCK flashy output).

- [ ] **Step 1: Read §2.1** and the BLOCK/grep logic.
- [ ] **Step 2: Remove/disable** the BLOCK checks for A1 (gradient), A7 (accent count/area), A9 motion-duration/loop, Tier2 gating, and per-domain saturation caps.
- [ ] **Step 3: KEEP** redteam checks for: dual-contrast gate, keyboard/structure/axe, reduced-motion fallback presence, CVD dual-encoding, and A2/A3/A4/A8.
- [ ] **Step 4: Verify (grep).** Redteam no longer BLOCKs gradient/accent/motion-duration/Tier2; still BLOCKs contrast/keyboard/reduced-motion/quality-4 violations.
- [ ] **Step 5: Diff both locations.**

---

### Task 8: Dual-location consistency sweep + acceptance test

**Files:**
- Read-only verification across all 7 modified files in both locations.

- [ ] **Step 1: Consistency sweep.** For each of the 7 files, diff cache vs source; confirm the loosened sections are byte-equivalent (or semantically identical where pre-existing diffs were unrelated).
- [ ] **Step 2: Constant cross-check.** Confirm motion/accent/saturation rules agree across `_contract.md`, `_block-card.md`, `SKILL.md`, `design-redteam-pro.md` (no file still asserts a removed cap).
- [ ] **Step 3: Acceptance -- flashy passes.** Mentally (or by generating a small sample HTML) confirm a design using scroll-reveal + glassmorphism + bold gradient + multi-accent + count-up would now PASS the integrity gate.
- [ ] **Step 4: Acceptance -- a11y still blocks.** Confirm a design with low-contrast body text, no keyboard support, or missing reduced-motion fallback would still BLOCK.
- [ ] **Step 5: Acceptance -- quality still flagged.** Confirm emoji-icons / default-fonts / equal-3-card / noun-phrase chart titles are still flagged.
- [ ] **Step 6: Report** the final state (what loosened, what preserved, both locations confirmed) to the user. Do not commit unless asked.

---

## Self-Review (against spec 2026-06-17-fdp-flashy-design.md)

**Spec coverage:**
- C1 motion budget -> Task 2 (+ Task 4 body). C2 Tier2 -> Task 4. C3 A1 gradient -> Task 1. C4 A7 accent -> Task 1 (+ Task 6). C5 A9 motion -> Task 1. C6 domain restraint/chroma -> Tasks 5+6. C7 _block-card -> Task 3. C8 redteam -> Task 7. C9 SKILL body -> Task 4. All covered.
- Preserve accessibility -> stated in Global Constraints + verify steps in Tasks 1,2,3,6,7,8. Preserve quality-4 -> Tasks 1,3,4,7,8. Dual-location -> every task + Task 8.
- Verification §5 -> Task 8 Steps 3-5.

**Placeholder scan:** Edits are prose/config; steps give concrete target STATE + grep verification rather than before/after bytes (executing subagent reads exact bytes). No TBD/TODO. Acceptable for non-code edits.

**Type consistency:** Loosened values (motion/accent/saturation) defined once in Global Constraints and referenced identically by Tasks 2/3/4/6/7. Consistent.

---
name: career-record-builder
description: Build, audit, and synthesize evidence-based records of past projects across web chat sessions and CLI repos to prepare for technical job interviews. Use when asked to document project accomplishments, build a career record, review past project evidence, or generate an interview pack.
---

# Career Record Builder & Reviewer

## Purpose
Build, verify, and reshape evidence-based records of past projects across disparate AI sessions (ChatGPT, Claude web, CLI agents) into concrete, defensible interview records and rehearsal packs.

---

## The Cross-Tool Context Model
When working across multiple AI tools, evidence is split:
- **CLI Agents (Claude Code, Antigravity CLI, Cursor)**: Have filesystem access. Extract from git commits, PR descriptions, issue trackers, architecture markdown files, and local notes.
- **Web Chat Agents (ChatGPT, Claude Web)**: No direct filesystem or cross-chat memory. Extract from attached files, pasted transcripts, or quick session summaries.

### Stage 0: Quick Session Ledger (Zero-Friction Capture)
When ending an exploratory or design conversation in any web or CLI tool, capture context immediately using this template before closing the session:

```markdown
### Session Context: <Topic / Date>
- Goal: <Problem being solved>
- Decisions Made: <Decisions reached + rationale>
- Alternatives & Trade-offs: <Options considered and why discarded>
- Architecture / Stack / Artifacts: <Files modified, libraries, patterns>
- Failure Modes / Roadblocks: <Bugs, unexpected constraints, what broke>
- Open Questions: <Unresolved gaps>
```

---

## Pipeline

1. **Stage 1: Career Record Builder.** One dated file per project within a role (`<company>/<role>/<project-slug>_<YYYY-MM-DD>.md`).
2. **Stage 1.5: Career Record Reviewer & Auditor.** Resolves gaps and audits claims against verified sources. Produces `<original-name>_reviewed_<YYYY-MM-DD>.md`.
3. **Stage 2: Interview Pack Generator.** Reshapes audited records for specific interview rounds (Behavioral STAR, System Design, Technical Deep-Dive).

---

## File & Repository Conventions
- Path convention: `career-context/` or local working repo:
  - Raw/Draft records: `<company>/<role>/<project-slug>_<YYYY-MM-DD>.md`
  - Reviewed records: `<original-name>_reviewed_<YYYY-MM-DD>.md`
  - Interview packs: `<company>/<role>/interview_packs/<stage_slug>_<YYYY-MM-DD>.md`
- Immutability: Files never edit earlier files. Each run creates a new dated file.
- Linking: Files link to previous versions via frontmatter (`supersedes`, `previous_runs`, `sources`).

---

## Stage 1: Record Builder Workflow

### Inputs
- `COMPANY`, `ROLE`, `PROJECT`: Provided by user. If missing, ask.
- `SOURCES`:
  - CLI: Repos, `git log`, diffs, notes, design docs.
  - Web: Transcripts, pasted logs, exported chats.
- `PREVIOUS_RUNS`: Filenames of earlier records (optional).

### Extraction & Authoring Rules
1. **No Hallucination**: Never invent facts, numbers, dates, or tools. If not in a source, do not include as a fact.
2. **CLI Git Mining**: When in a CLI agent with repo access:
   - Run `git log --author="<User>" --oneline --stat` to discover actual commit scope and timelines.
   - Inspect commit messages, PRs, and config files for concrete design choices.
   - Cite actual commit hashes, PR numbers, or file paths.
3. **Ownership Calibration**:
   - `owned`: Designed or built from scratch.
   - `collaborated`: Shared work (specify who did what if known).
   - `extended`: Built on top of pre-existing systems (detail baseline).
   - If ambiguous, choose the weaker label and open a gap.
4. **Metrics**: Prefer measurable impact (latency, throughput, cost, reliability). If none exists, write `no metric found`—never estimate or invent numbers.
5. **Accomplishments**: Select 3 to 5 key accomplishments. Fully develop each with STAR fields, trade-offs, and failure recovery. Work that does not make the cut goes to "Other work (not developed)".
6. **Language**: Write in English, preserving exact technical terms, tool names, and metrics.

### Stage 1 Record Template
```markdown
---
company:
role:
project:
period:
run_date:
sources: []
previous_runs: []
supersedes:
related: []
role_focus_tags: []
---

# <Project> at <Company>

## Summary
3-5 lines. Overall scope, impact, and ownership level.

## Context
Team structure, core business problem, why it mattered.

## Responsibilities
- Bulleted list, each cited with source.

## Accomplishments
### [ID: short-slug] Title
- Ownership: owned | collaborated | extended
- Situation: Context and problem.
- Task: Specific objective and technical constraint.
- Action: Concrete implementation steps taken (tools, architectures, algorithms).
- Trade-offs & Alternatives: Options considered and why rejected.
- What Went Wrong / Failure Mode: Roadblocks, bugs, edge cases encountered and how resolved.
- Result: Measurable outcomes or "no metric found".
- Sources: [File/line, commit hash, PR, or chat session identifier]

## Other work (not developed)
- One line per item.

## Architecture & How It Was Done
Stack, system flow, design decisions, database schemas/APIs, key components.

## Skills & Technologies Demonstrated

## Changes vs. Previous Run
(Only if previous runs exist; highlight contradictions or additions)

## Gaps / Needs Input
### [GAP-01] Short title
- Affects: <accomplishment ID or section>
- Question: <specific question for the user>
- Why it matters: <interview context, e.g. "weakens trade-off explanation">
- Evidence that would resolve it: <e.g. PR, metric, design doc, personal confirmation>
- Where to look: <suggested files or "user confirmation only">
- Status: open
```

---

## Stage 1.5: Reviewer & Auditor Workflow

Run in a separate session or agent when possible to act as an independent check.

### Audit Process
1. **Read Record & Sources**: Check all claims against available evidence.
2. **Gap Resolution**:
   - Evidence found: Write answer under the gap, cite source, set `Status: resolved`.
   - Partial evidence: Note what was found and what is missing, set `Status: partial`.
   - Not found: Set `Status: unresolved`.
   - Personal only: Set `Status: open (user only)` and restate question.
3. **Accomplishment Audit**:
   - `Ownership check`: Confirm `owned` / `collaborated` / `extended` or downgrade.
   - `Metrics check`: Per number: `confirmed` | `not found` | `differs (state source value)`.
   - `Action & Trade-offs`: Check if trade-offs were real or LLM-inferred.
4. **Output**: Save as `<original-name>_reviewed_<YYYY-MM-DD>.md` with `supersedes: <original-file>`. Do not modify original accomplishment text; append the `## Audit` and `## Review Summary` sections.

### Audit Section Template
```markdown
## Audit

### [ID] Accomplishment title
- Verdict: supported | partially supported | overstated | unsupported | cannot verify
- Ownership check: confirmed | downgrade to <label> | cannot verify
- Metrics check: [per number: confirmed | not found | differs]
- Action check: [confirmed | inferred / unsupported]
- Issues: Specific discrepancies with cited sources.
- Suggested fix: Grounded, defensible wording adjustment for interview delivery.

## Review Summary
- Gaps: <n> resolved, <n> partial, <n> unresolved, <n> open (user only)
- Accomplishments by verdict: supported <n>, partially supported <n>, overstated <n>, unsupported <n>, cannot verify <n>
- Priority Questions for the User (Ranked by interview vulnerability):
  1. ...
```

---

## Stage 2: Interview Pack Generator

Reshapes audited records into interview-ready formats (Behavioral STAR, System Design, or Deep-Dive):
- Use ONLY verified claims from audited records (incorporating suggested fixes for overstated items).
- Highlight explicit ownership boundaries to prevent overclaiming during probing.
- Pre-generate answers to standard technical follow-up questions:
  - *"What was the hardest bug you hit in this architecture?"*
  - *"Why did you pick this database/framework over alternative X?"*
  - *"What would you redesign if scale increased 10x?"*

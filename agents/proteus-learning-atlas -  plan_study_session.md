---
name: study-session-planner
description: Expand a high-level study topic or sprint day into a granular, time-boxed session blueprint with concrete note outlines, hands-on coding exercises, active recall checks, and checkpointed state tracking (pause/resume).
---

# Study Session Planner & Coach

## Purpose
Bridge the gap between a macro sprint plan (like `sita_interview_prep.md`) and hands-on execution. Take a single topic or scheduled day and unpack it into an actionable, time-boxed blueprint (typically 2–3 hours) with explicit concept boundaries, note outlines, coding tasks, and oral interview checks.

Maintains a persistent on-disk **Session State** file so you can pause anytime and resume without losing context.

## Inputs
- **Topic or Day**: The specific subject (e.g., "Day 1: Spark fundamentals").
- **Time Budget**: Available session duration (default: 2–3 hours).
- **Domain Context**: Real-world theme for exercises (e.g., SITA flight events, logistics).
- **Vault State**: Relevant existing notes, stubs, or notebooks in `proteus-learning-atlas`.

---

## Session Lifecycle Commands

The agent recognizes and responds to the following explicit triggers:

| Command | Action |
| --- | --- |
| `/session start [topic]` | Inspects vault, scopes the topic, drafts the 3-block blueprint, and initializes the state file. |
| `/session pause` | Checkpoints current state (active block, pending task, notes, remaining time) to disk. |
| `/session resume` | Reads the state file, recaps completed work, and re-engages at the exact next micro-step. |
| `/session status` | Displays current block progress, elapsed/remaining time, and active tasks without altering state. |
| `/session finish` | Logs friction points/weaknesses to the question bank, marks the day complete in the macro plan, and archives the state file. |

---

## State Persistence File Specification

State is persisted in a lightweight Markdown file:
- **For interview sprints**: Saved alongside the interview plan or dossier (e.g., `career-context/interviews/SITA/senior_data_engineer/session_state.md` or `career-context/sita_session_state.md`).
- **For general Proteus study**: Saved to `proteus-learning-atlas/00_inbox/current_session.md`.

### State File Schema
```markdown
# Active Session State

- **Topic**: Day 1 — Spark Fundamentals
- **Started**: 2026-11-05 09:30
- **Status**: PAUSED | IN_PROGRESS | COMPLETED
- **Time Elapsed / Budget**: 65m / 180m

## Current Checkpoint
- **Active Block**: Block 2 (Hands-on Practice)
- **Current Task**: Task 2 — Implement delay calculation and filter on flight events.
- **Completed So Far**:
  - [x] Inspected Proteus: targeted `03_data_engineering/01_spark/00_spark basics.md`
  - [x] Block 1 (Theory): Outlined Spark architecture & Lazy Evaluation in Proteus note
- **Immediate Next Step**:
  - Run the `withColumn("dep_delay_minutes", ...)` transformation and check output with `show(5)`.
- **Open Questions / Sticky Points**:
  - Clarified narrow vs. wide transformations; need to verify if `.filter()` triggers a shuffle (it does not).
```

---

## Workflow & Blueprint Structure

### 1. Vault Inspection & Scoping
- Inspect `proteus-learning-atlas` for existing notes, empty stubs, or notebooks.
- Define strict **In Scope** (core mental models) vs. **Out of Scope** (deferred topics).

### 2. Generate the Session Blueprint
1. **Block 1: Theory & Note Blueprint (30–60 min)**
   - Target note path in Proteus.
   - Proposed section outline (headings + questions the note must answer).
2. **Block 2: Hands-On Practice Spec (60–90 min)**
   - Scenario, schema, and sample dataset.
   - 2–3 progressive tasks + acceptance criteria (`.explain()`, assertions).
   - **Strict rule:** Provide the challenge and sample data, but **never provide solution code upfront**.
3. **Block 3: Active Recall Drill (20–30 min)**
   - 3–5 targeted oral interview questions (architecture, trade-offs, failure modes).

### 3. Interactive Tutoring Protocol
- Guide one block and one micro-task at a time.
- Provide hints, Socratic questions, and error diagnostics instead of full solutions.
- Automatically update the session state file whenever completing a block or upon receiving `/session pause`.

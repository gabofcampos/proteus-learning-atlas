---
name: interview-prep-planner
description: Build realistic, time-boxed technical interview study plans from a target stack, interview context, existing knowledge base, and available study time. Use when asked to prepare for a technical interview or create a study sprint.
---

# Interview Prep Planner

## Purpose
Produce a short, prioritized, actionable interview study guide grounded in the user's existing knowledge, not a generic curriculum. Optimize for interview readiness within a hard time budget. The user's actual pace may be roughly twice a typical estimate; use conservative estimates and explicitly cut scope rather than overfill the schedule.

## Inputs
Collect only missing essentials:
- Target role and technology stack (required)
- Available days and realistic hours per day (required)
- Knowledge base path or repository (optional; inspect if accessible)
- Interview format and date (optional)
- Self-rated familiarity by technology (optional; infer tentatively from existing notes and exercises, then ask about uncertainty)

Do not ask a long questionnaire. If a repository is available, inspect its README, structure, relevant notes, notebooks and exercises before proposing new materials. Do not treat the existence of a note as proof of mastery.

## Workflow
1. **Inventory**: Find relevant existing notes, exercises and projects. Record paths. Do not restructure or overwrite without approval.
2. **Gap analysis**: Classify each topic as `comfortable`, `revision`, `relearn`, or `new`, and mark uncertain assessments. Prefer explicit user statements over inferred expertise.
3. **Prioritize**: Rank by likely interview relevance, weakness, prerequisite dependencies and practical testability. Do not pretend to know interview content that has not been provided.
4. **Budget**: Calculate available study hours. Reserve at least 15% for recall, mock questions and spillover. Estimate conservatively (roughly 2x optimistic task estimates). Keep a hard ceiling; move lower-priority topics to Round 2.
5. **Plan**: Create one row per day/session with focus, short theory deliverable, concrete practice deliverable, time budget and exit criterion. Prefer revising existing materials over creating duplicates.
6. **Learning assets**: For theory, suggest concise Markdown notes in the knowledge base. For practice, choose existing notebooks, new notebooks, SQL exercises or LeetCode as appropriate. Do not force LeetCode for distributed systems or architecture topics.
7. **Interview checks**: Include 2–4 oral questions per major topic and at least one mixed mock interview near the end. Distinguish explanation, coding and design.
8. **Adapt**: When a session overruns, reduce scope or move tasks to Round 2. Never silently extend the time budget. Ask for progress and adjust the remaining plan.

## Output
By default generate a concise study plan with:
- Context and assumptions
- Knowledge assessment with confidence levels
- Total available hours and allocation
- Day-by-day table: topic, theory, practice, estimated time, exit criterion
- Specific existing knowledge-base references, when available
- `Round 2 / deferred` section
- 3–5 next actions

When working in a repository, offer to save the plan as `interview-prep/<company-or-role>/study-plan.md` or an existing project-appropriate location. Only create files after the user requests it or authorizes changes. Follow existing repository conventions and `AGENTS.md`.

## Tutoring rules
- Prefer guiding questions and hints before solutions, unless solutions are requested.
- Make each exercise independently runnable and checkable.
- Avoid building full infrastructure or portfolio projects during short interview sprints unless explicitly requested.
- Prioritize conceptual understanding plus hands-on coding, not polished notes.
- Label assumptions and unknowns clearly.
- Use the user's language.

## Example invocation
"Create a 6-day interview prep plan for a Data Engineer role using Python, SQL, Spark, Kafka, Azure and streaming. I have 3 hours/day. Inspect my Proteus knowledge base. I need to relearn Spark, know Python and SQL, and am new to Kafka. Give me concise theory notes and practical notebook/LeetCode exercises, with conservative estimates."

# proteus-learning-atlas

**Proteus** (`proteus-learning-atlas`) is a personal, evolving knowledge base designed to capture, organize, connect, and retain technical knowledge.

It is a git-versioned repository built around Markdown and Obsidian, intended to be readable and usable by both humans and AI agents.

## why Proteus exists

long story short? I found myself wanting to learn in a more structured manner and to have something to show for it. 

on a daily basis, learning happens in many different contexts: professional projects, prepping for technical interviews, personal projects, research, debug sessions and convos with coleagues.

before proteus, I found myself learning stuff, not really connecting concepts, and quickly putting it away in some corner of my mind, in most cases, never to be found again. 
the idea behind proteus is to have my learning centralized and hopefully never really forgotten or at least to have a way to relearn.

Proteus' purpose is to turn **isolated learning experiences into structured, reusable, interconnected knowledge**.

## what Proteus contains

Proteus is not restricted to a particular technology or discipline. It grows alongside my interests and professional development.

Its knowledge can include:

- **Technical concepts:** Explanations of technologies, algorithms, architectures, and engineering principles.
    
- **Practical learning:** Code examples, SQL exercises, Python notebooks, and hands-on experiments.
    
- **Project-derived knowledge:** Lessons learned from building software, processing datasets, and solving real engineering problems.
    
- **Interview preparation:** Questions, solutions, technical gaps, and concepts worth revisiting.
    
- **Research and references:** External resources, documentation, and connections between related topics.
    

current areas of interest include data engineering, distributed processing, Python, SQL, geospatial engineering, and AI systems; this can evolve in any and all directions.

## How Proteus works

Proteus follows a few guiding principles:

1. **Learn by doing.** Knowledge often originates in real problems, experiments, and projects.
    
2. **Capture understanding, not just information.** Notes should explain why something works, not merely record commands or definitions.
    
3. **Connect related ideas.** Knowledge becomes more useful when concepts can be explored through their relationships.
    
4. **Keep knowledge reusable.** Notes should remain valuable beyond the specific situation in which they were created.
    
5. **Evolve continuously.** Existing knowledge can be corrected, expanded, reorganized, and refined as understanding improves.
    

## Proteus and AI agents

Proteus is also intended to function as a persistent knowledge resource for AI-assisted workflows.

An AI agent working with Proteus should understand that:

- Proteus is a **knowledge repository**, not an application or a single software project.
    
- Its primary purpose is to preserve and develop understanding over time.
    
- Markdown notes are the main medium for documenting concepts and connecting knowledge.
    
- Executable examples and notebooks can complement conceptual notes.
    
- Existing knowledge should be consulted before creating redundant explanations.
    
- New knowledge should be integrated into relevant topics rather than indiscriminately appended.
    
- Notes should distinguish established facts, personal observations, hypotheses, and unresolved questions.
    
- Agents should preserve the owner's reasoning and intent rather than replace it with generic documentation.
    

The goal is for AI agents to help maintain and extend the knowledge base while keeping it understandable and useful to its human owner.

## What Proteus is not

Proteus is not intended to be:
   
- A collection of automatically generated notes without demonstrated understanding.
	- AI is great, sometimes. Sometimes, I would much rather take the time myself to try to digest and understand a new piece of information.
    
- A replacement for dedicated software project repositories.
	- there might be some references to notebooks in here, but some concepts might come from private repos, day to day coding at work, or public repos I'm working on.
    
- A static encyclopedia that must be complete or perfectly organized.
	- above all, my intention with Proteus was to allow my learning to be. simply exist and learn in a messy manner. cleanliness and perfection have their place my learning notes are not that place. I'd rather have messy notes and learn than be stuck by the laziness of creating pretty notes 
    
## long-term vision

Proteus aims to become a personal technical atlas: a place where knowledge accumulated over years can be rediscovered, connected, challenged, and applied to new problems.

It should make it easier for its owner (ME) to understand what they know, identify what they have yet to learn, and build on previous experience without repeatedly starting from scratch.

## Agents / skills

- [`agents/proteus-learning-atlas -  todo audit from the obsidian graph.md`](agents/proteus-learning-atlas%20-%20%20todo%20audit%20from%20the%20obsidian%20graph.md) — reconstructs the Obsidian graph from the vault's markdown files (empty stub notes + `[[links]]` with no matching note) and folds anything missing into `00_inbox/ToDo.md`. Run it by asking Claude to audit the vault for unfinished notes.

# Proteus Learning Atlas — TODO audit from the Obsidian graph

This skill reconstructs what Obsidian's graph view shows (real notes + phantom/unresolved nodes) by parsing the vault's markdown files directly, since there's no programmatic access to the Obsidian app itself. It finds notes that exist but are unfinished, and concepts that are linked-to but don't have a note yet, then folds anything new into `00_inbox/ToDo.md`.

Vault path: `/Users/gabrielfernandezcampos/Documents/mpp/proteus-learning-atlas` (reach it via the device bridge — `device_bash`, with the folder mounted under `$HOME/mnt/proteus-learning-atlas` or similar; check the session's connected folders for the exact mount name).

**Hard project rules — do not violate these:**
- Only read files inside the `proteus-learning-atlas` folder.
- Never write or modify any file in the vault except `00_inbox/ToDo.md`. Every other file is read-only, no matter what this skill finds.

## Steps

1. **Scan the vault.** Walk all `.md` files, excluding `.git` and `.obsidian`. Also build a lookup of every file in the vault by basename (both with and without extension, lowercased) — needed to correctly resolve links that point at non-markdown files (images, notebooks), not just other notes.

2. **Find empty/stub notes.** Any existing `.md` file whose stripped content is trivially short (e.g. under ~5 characters) is a stub that was created but never written — flag it by its path/title.

3. **Find unresolved links.** Parse every `[[...]]` reference (both `[[link]]` and embed `![[link]]` forms; strip any `|alias` or `#heading` suffix). For each target, resolve by basename (with or without extension) against the full vault file lookup from step 1 — not just against `.md` files, so real embeds of images/notebooks aren't false positives. Anything that doesn't resolve to any file in the vault is a phantom node: a concept that's referenced but has no note yet.

4. **Re-read `00_inbox/ToDo.md` fresh, right before comparing or editing.** Never rely on a copy read earlier in the conversation — Gabriel edits this file directly in Obsidian in parallel, so always `cat`/read it anew immediately before use.

5. **De-duplicate against the current ToDo.** Drop any stub note or unresolved link that's already mentioned (even loosely/by topic) in the current ToDo content, so nothing gets listed twice.

6. **Present findings before writing.** Show Gabriel the two groups — empty/stub notes to finish, and notes to create (linked but missing) — and ask whether to add them to the ToDo before editing the file. Don't write unprompted.

7. **On confirmation, edit `00_inbox/ToDo.md` in place**, reading it fresh one more time immediately before the edit (per step 4). Match the file's existing formatting conventions: top-level items as `- item`, sub-items tab-indented as `\t- subitem`. If group headers like "empty/stub notes to finish" or "notes to create (linked but missing)" already exist in the file from a prior run of this skill, append new items under those existing headers instead of creating duplicate header lines. Do a precise, minimal edit (exact string match/replace on the current content) rather than rewriting the whole file, so any other manual edits Gabriel has made elsewhere in the file are preserved.

8. Confirm what was added, in the same terse style as the rest of the ToDo — no extra commentary added to the file itself.
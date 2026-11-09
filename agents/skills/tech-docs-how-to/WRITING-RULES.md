# Writing rules

These rules apply to every document, including documents outside the Diátaxis framework. The skill for each form of document adds its own rules on top of these.

## Tell the truth

Never document from memory. Read the source, and run the thing you are describing.

Run every command you publish. Confirm every path, symbol, flag, and output against the working tree.

In your final report, state what you ran and what you could not check. In the document itself, mark anything the reader cannot rely on.

State limitations plainly. Leave out marketing language.

## Write for one reader

Name the intended reader before you write.

Make one page serve one need. When adjacent material comes up, link to it instead of absorbing it.

Define or link every term the intended reader may not know. Do not explain a simple idea with harder words.

Do not assume a reader arrived from the previous page. Many readers land on a page from a search.

## Make code samples work when pasted

Make commands paste and run unchanged.

Omit a leading `$` from commands meant for copying. Show a prompt only where one is needed to separate typed input from displayed output.

Use non-interactive flags such as `--yes`, so that pasted lines are not consumed as answers to a prompt.

Chain dependent commands with `&&` and line continuations, so that a sequence stops at its first failure.

Keep line numbers out of copyable text.

Prefer long flag names such as `--recursive`. They explain themselves.

Separate what the reader must change from what must stay. At the top of a shell sample, assign editable values to commented variables and reference them as `${VAR?}`, so that an unset value fails loudly. In source code, use commented named constants for fixed values.

```bash
# Name of the database to back up. Change this to your own.
DATABASE_NAME='pets'

mkdir -p backups && \
  pg_dump --format=custom --file="backups/${DATABASE_NAME?}.dump" "${DATABASE_NAME?}"
```

Choose realistic example values that cannot be mistaken for keywords or library names. Use a `pets` table with a `pet_name` column, never `tbl` with a column called `column`.

Replace tedious manual edits with a command.

Give the full path of every file the reader touches, and show exactly where a change goes.

Pin versions, and say which version you tested.

## Structure the page for skimming

Write descriptive headings that make sense out of context. Use "Install Go 1.23", not "Installation".

Keep casing, point of view, and tense consistent across headings. Nest only what belongs to its parent.

Write for readers who skim. Use heading levels to show hierarchy, and add short comments to code samples where the purpose of a line is not obvious.

Link generously to every feature you mention.

Follow the project's existing frontmatter, navigation, file naming, and cross-reference conventions. Where the project uses canonical cross-repository URIs, such as Mori's `mori://` form, use those rather than paths.

## Match the project's voice

Before drafting, read one or two hand-written pages near the target, preferring pages of the same form. Match their sentence length, formality, terminology, and spelling.

Do not sample generated pages. They show a generator's habits, not an author's.

Where the project's voice conflicts with the rules of the form you are writing, the form's rules win. A tutorial says "we" even when the surrounding pages do not.

For a document outside Diátaxis, the project's voice governs.

If no hand-written pages exist, use the form's default voice.

## Sources

These rules paraphrase the following works, read on 2026-11-09.

- *Diátaxis*, by Daniele Procida: https://diataxis.fr/
- "How to write exceptional documentation", by Chris Nicholas: https://chrisnicholas.dev/blog/how-to-write-exceptional-documentation
- "Rules for Writing Software Tutorials", by Michael Lynch: https://refactoringenglish.com/excerpts/rules-for-software-tutorials/

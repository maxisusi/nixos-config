# Comments and documentation

Never conflate the two kinds. A **doc comment** sits on a declaration and serves
a caller who will not read the body. An **implementation comment** sits in the
flow of code and serves whoever edits the lines below it.

## Doc comments

- Document every public API and every module or package header: what it is for,
  plus any contract callers cannot infer.
- Follow the language's documentation idiom: rustdoc, godoc, docstrings, JSDoc.
- Terseness may not cut the contract; it may cut everything else.

## Implementation comments

- Default to none. Write one only when you can name the mistake it prevents: a
  wrong edit, or a wrong assumption acted on. One someone would plausibly make,
  not one they conceivably could. If you cannot name it, write nothing.
- Write the cause and stop. One sentence; a second only to name a second
  mistake. Whatever the reader derives from the cause is not written.

## Both

- Do not paraphrase the code. State what it does not make plain: invariants
  other code must not break, constraints, non-local effects.
- Never argue that a change is worthwhile, narrate the reasoning behind a value,
  or restate a cited reference.
- Rationale for the change belongs in the commit message. The file gets only
  what constrains the next edit.
- Neighbouring files set no precedent for how much to comment.
- Write every comment as if the file had always existed. Delete any sentence
  that only makes sense to a reader who knows what the code used to be, where it
  moved from, or which alternative was rejected. A constraint on future edits
  earns its place; an account of past ones does not — that is what git is for.
- Cite specs and upstream issues that future work will need; otherwise omit.
- When editing, reformulate rather than append: a terse whole, not a minimal
  diff.
- Before finishing, weigh every comment you wrote or modified against these
  rules, and rewrite or delete those that fail.

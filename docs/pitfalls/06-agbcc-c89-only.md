# 06 — agbcc is C89-only

**Class:** build-system / language compatibility
**Severity:** compile error
**Status:** known constraint; just write C89

## Symptom

Familiar-looking C code that fails to compile under agbcc:

- `int x = ...; printf(...); int y = ...;` — declarations after statements
- `for (int i = 0; ...; ++i)` — declaration in for-statement
- `//` line comments (older agbcc; current builds usually allow them)
- `bool`, `true`, `false` — no `<stdbool.h>` in agbcc's headers
- compound literals: `(struct Foo){.a = 1}` — C99
- designated initializers: `{.field = value}` — C99
- `inline` keyword

Error messages from agbcc are terse and often unhelpful (`parse error`,
`mixed declarations and code`).

## Why

agbcc is built from gcc 2.9-arm-000512, which predates the C99
standard. It implements C89 with a few GNU extensions but rejects
most C99/C11 syntax.

## Fix

Write C89:

```c
/* before C89 */
void fn(void) {
    do_something();
    int x = compute();
    use(x);
}

/* after — all decls at top of block */
void fn(void) {
    int x;
    do_something();
    x = compute();
    use(x);
}
```

For loop counters:

```c
/* C99 */
for (int i = 0; i < n; i++) { ... }

/* C89 */
int i;
for (i = 0; i < n; i++) { ... }
```

For boolean values:

```c
/* C99 */
#include <stdbool.h>
bool flag = true;

/* C89 — use u8 or u32 */
u32 flag = 1;
```

## When the editor's clangd disagrees

Clangd is configured against modern C/C++ and will flag the C89 style
as outdated. Ignore its diagnostics for `src/c/` files — the actual
build uses agbcc which has different expectations.

The clangd diagnostics about `'EWRAM.h' file not found` etc. are
also expected — clangd doesn't know the project's include paths
(`cpp -Iconstants/headers -undef -nostdinc` is the actual preprocess
step). Build success is the source of truth.

## Related

- Memory: [[decomp_no_agbcc_fork]] — we don't patch agbcc; we live
  with its quirks during the project and plan an end-of-project
  refactor pass once the binary-compat constraint goes away.
- `Makefile` lines around `CC = tools/agbcc/bin/agbcc`

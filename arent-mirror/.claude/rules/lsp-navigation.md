---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.py"
  - "**/*.go"
  - "**/*.rs"
  - "**/*.cpp"
  - "**/*.c"
  - "**/*.h"
  - "**/*.hpp"
  - "**/*.cs"
  - "**/*.java"
  - "**/*.kt"
  - "**/*.kts"
  - "**/*.swift"
  - "**/*.php"
  - "**/*.lua"
---

# LSP Navigation

Use LSP tools for type information, diagnostics, and symbol resolution:

- **Discovery**: Grep / Glob for finding files and text matches
- **Understanding**: LSP tools (`lsp_hover`, `lsp_find_references`, `lsp_get_diagnostics`) for types and symbols
- Do not guess type signatures — use `lsp_hover` to confirm
- Do not use find-and-replace for renaming symbols — use `lsp_rename` to catch all references
- Resolve all LSP diagnostics before committing. Do not silence them with `// @ts-ignore` or similar

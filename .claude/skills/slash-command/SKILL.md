---
name: slash-command
description: Create and edit Claude Code slash commands. Use when the user wants to create a new slash command, add a custom command, or modify an existing command in .claude/commands/.
---

# Creating Slash Commands

Slash commands are markdown files that define reusable prompts for Claude Code.

## File Location

- **Project commands**: `.claude/commands/*.md` - shared via version control
- **Personal commands**: `~/.claude/commands/*.md` - user-specific

The filename (without `.md`) becomes the command name: `fix-lint.md` → `/fix-lint`

## File Format

```markdown
---
allowed-tools: Read, Grep, Bash(git:*)
argument-hint: [file] [options]
description: Short description shown in /help
model: claude-sonnet-4-5-20250929
---

Command instructions here. Use $ARGUMENTS for all args or $1, $2 for positional.
```

### Frontmatter Fields (all optional)

| Field | Purpose |
|-------|---------|
| `allowed-tools` | Restrict which tools the command can use |
| `argument-hint` | Show expected arguments in help (e.g., `[filename]`) |
| `description` | Description shown in `/help` output |
| `model` | Override model (e.g., `claude-3-5-haiku-20241022` for fast tasks) |

## Dynamic Content

### Arguments
- `$ARGUMENTS` - all arguments as single string
- `$1`, `$2`, etc. - positional arguments

### Bash Output
Include shell command output using the bang-backtick syntax.

**Syntax:** Place an exclamation mark immediately before a backtick-wrapped command.

**Examples in a command file:**
```text
Current branch: (BANG)(TICK)git branch --show-current(TICK)
Changes: (BANG)(TICK)git diff --stat(TICK)
```
Where BANG = exclamation mark and TICK = backtick character.

### File Contents
Use `@filepath` to include file contents:
```markdown
Review this config: @tsconfig.json
```

## Namespacing

Subdirectories organize commands:
```
.claude/commands/
├── git/
│   ├── commit.md     # /commit (project:git)
│   └── pr.md         # /pr (project:git)
└── test.md           # /test (project)
```

## Examples

### Simple command
```markdown
---
description: Run all tests
---
Run the test suite and fix any failures.
```

### With arguments and tool restrictions
```markdown
---
allowed-tools: Bash(npm test:*), Read, Edit
argument-hint: [test-pattern]
description: Run tests matching pattern
---
Run tests matching: $ARGUMENTS

If tests fail, analyze and fix them.
```

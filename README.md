# Lord of the Code

A code review and quality assurance skill for [Claude Code](https://claude.ai/claude-code) that uses named characters from Middle-earth, each mapped to a specific AI model tier and expertise area.

Deploy Sauron for coordinate audits, Gandalf for architecture reviews, swarms of Uruk-Hai for adversarial bug hunting, and more — all with consistent personalities and the right model for the job.

## Characters

| Character | Model | Expertise |
|-----------|-------|-----------|
| **Sauron** | Opus | Coordinates, data flow, state correctness, dimensional analysis |
| **Gandalf** | Opus | Architecture, maintainability, API design, abstraction boundaries |
| **Frodo** | Opus | User experience, workflows, error messages, edge cases from the user's perspective |
| **Aragorn** | Sonnet | Security, input validation, boundary defense, resource exhaustion |
| **Legolas** | Sonnet | Performance, hot paths, memory profiling, algorithmic complexity |
| **Gimli** | Sonnet | Build systems, dependencies, cross-platform, CI/CD |
| **Uruk-Hai** | Haiku | Adversarial bug hunting, crash finding, edge case fuzzing (deploy in waves) |
| **Gollum** | Haiku | Style nitpicking, naming conventions, dead code, TODO tracking |
| **Ents** | Haiku | Test coverage analysis, assertion quality, test case design |

## Council Formations

| Formation | Characters | Use Case |
|-----------|-----------|----------|
| **The Fellowship** | Sauron + Gandalf + Frodo | Full review: correctness, architecture, UX |
| **The Horde** | 3-5 Uruk-Hai per wave | Adversarial sweep: repeat until 3 clean waves in a row |
| **Council of Elrond** | Gandalf + Frodo + Aragorn + Legolas | Design review before implementation |
| **The War Council** | All characters | Pre-release full-codebase audit |

## Installation

### As a Claude Code Skill

Copy `lord-of-the-code.md` to your Claude Code skills directory:

```bash
# macOS / Linux
cp lord-of-the-code.md ~/.claude/skills/

# Windows
copy lord-of-the-code.md %USERPROFILE%\.claude\skills\
```

Then invoke in any Claude Code session:

```
/lord-of-the-code
```

Claude will ask which formation or character you want to deploy.

### As a CLAUDE.md Reference

Add to your project's `CLAUDE.md`:

```markdown
## Code Review

Use the Lord of the Code skill (`/lord-of-the-code`) for code reviews.
See `.claude/skills/lord-of-the-code.md` for character definitions.
```

### Manual Usage (without skill)

You can use the characters directly by asking Claude Code to spawn agents with specific model levels:

```
Deploy Sauron (opus) to audit the coordinate transforms in src/transforms/
Deploy 5 Uruk-Hai (haiku) to hunt bugs in src/engine/
Deploy Gandalf (opus) to review the architecture of the new module
```

## How It Works

Each character is an AI agent spawned at a specific model tier:

- **Opus characters** (Sauron, Gandalf, Frodo) do deep, thorough analysis. Use them for critical reviews where correctness matters more than speed.
- **Sonnet characters** (Aragorn, Legolas, Gimli) provide balanced analysis. Good for implementation reviews and specialized concerns.
- **Haiku characters** (Uruk-Hai, Gollum, Ents) are fast and cheap. Deploy them in swarms for broad coverage. The Uruk-Hai adversarial sweep protocol requires 3 consecutive clean waves before declaring code hardened.

## The Uruk-Hai Protocol

The signature technique: deploy waves of 3-5 haiku-level adversarial reviewers, each targeting different code sections. Fix any bugs found, then deploy the next wave on the fixed code. Repeat until 3 consecutive waves return CLEAN.

This has been tested on production codebases and typically finds 10-15 real bugs across 8-12 waves before converging to clean.

```
Wave 1:  5 bugs found  → fix all
Wave 2:  3 bugs found  → fix all
Wave 3:  1 bug found   → fix it
Wave 4:  0 bugs        → clean wave 1/3
Wave 5:  1 bug found   → fix, counter resets
Wave 6:  0 bugs        → clean wave 1/3
Wave 7:  0 bugs        → clean wave 2/3
Wave 8:  0 bugs        → clean wave 3/3 ✓ HARDENED
```

## Examples

**"I need a thorough review of my new payment module"**
→ Deploy The Fellowship (Sauron + Gandalf + Frodo)

**"Hunt for bugs before release"**
→ Run the Uruk-Hai Protocol until 3 clean waves

**"Is this API design sound?"**
→ Deploy Council of Elrond (Gandalf + Frodo + Aragorn + Legolas)

**"Check if this builds cleanly on all platforms"**
→ Deploy Gimli

**"Find performance bottlenecks"**
→ Deploy Legolas

**"Audit coordinate transforms between systems"**
→ Deploy Sauron

## License

MIT

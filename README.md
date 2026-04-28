# Lord of the Code

A code review skill for [Claude Code](https://claude.ai/code) that uses named characters from Middle-earth, each mapped to a specific AI model tier and expertise area.

Deploy Sauron for correctness audits, Gandalf for architecture reviews, swarms of Uruk-Hai for adversarial bug hunting, and more — all with consistent personalities and the right model for the job.

## Installation

```bash
git clone https://github.com/thereprocase/lord-of-the-code
cd lord-of-the-code
bash install.sh
```

This installs:
- **Skill** → `~/.claude/skills/lord-of-the-code/SKILL.md`
- **Agents** → `~/.claude/agents/{sauron,gandalf,frodo,...}.md` (10 agents)
- **Alias** → `~/.claude/skills/lotc/SKILL.md` (shorthand)

Restart Claude Code after installing.

## Usage

```
/lord-of-the-code [formation]     Full name
/lotc [formation]                 Shorthand — identical behavior
```

With no arguments, an Ent triages your code and recommends which reviewers to deploy.

## Characters

| Character | Model | Expertise |
|-----------|-------|-----------|
| **Sauron** | Opus | Coordinates, data flow, state correctness, dimensional analysis |
| **Gandalf** | Opus | Architecture, maintainability, API design, abstraction boundaries |
| **Frodo** | Opus | User experience, workflows, error messages, edge cases |
| **Aragorn** | Sonnet | Security, input validation, boundary defense, resource exhaustion |
| **Legolas** | Sonnet | Performance, hot paths, memory profiling, algorithmic complexity |
| **Gimli** | Sonnet | Build systems, dependencies, cross-platform, CI/CD |
| **Ents** | Sonnet | Test coverage, assertion quality, test case design, **triage** |
| **Telchar** | Sonnet | **Anvil-smith of Nogrod** — operates the local-LLM anvil MCP on behalf of a trio channel; refreshes from canonical anvil/houtini docs every invocation |
| **Uruk-Hai** | Haiku | Adversarial bug hunting, crash finding, edge case fuzzing |
| **Gollum** | Haiku | Style nitpicking, naming conventions, dead code, TODO tracking |

## Council Formations

| Formation | Characters | Use Case |
|-----------|-----------|----------|
| **The Three Seers** | Sauron + Gandalf + Frodo | Deep review: correctness, architecture, UX |
| **The Horde** | 3-5 Uruk-Hai per wave | Adversarial sweep until 3 clean waves |
| **Council of Elrond** | Gandalf + Frodo + Aragorn + Legolas | Design review before implementation |
| **The War Council** | All characters | Pre-release full-codebase audit |
| **Scribe-Merge** | Ent triage → recommended formation | **Review → fix → merge** workflow (see below) |

## Scribe-Merge: Review → Fix → Merge

The full branch-to-main workflow in one command:

```
/lotc scribe-merge
```

**What it does (5 phases):**

1. **Triage** — Ent reads the branch diff, recommends reviewers
2. **Review** — Deploys recommended formation, writes report to `docs/kbn-reports/{branch}-merge-review.md`
3. **Fix** — Presents findings, fixes criticals/warnings with your approval, commits fixes
4. **Verify** — If fixes were substantial, Ent triages the fixes and recommends a re-review formation
5. **MR** — Pushes branch, creates MR/PR (auto-detects GitLab vs GitHub), attaches report summary

User confirms at each phase. Works on any git repo — auto-detects base branch and git host.

## The Uruk-Hai Protocol

Deploy waves of 3-5 haiku-level adversarial reviewers. Fix bugs found, deploy next wave. Repeat until 3 consecutive clean waves.

```
Wave 1:  5 bugs found  → fix all
Wave 2:  3 bugs found  → fix all
Wave 3:  1 bug found   → fix it
Wave 4:  0 bugs        → clean 1/3
Wave 5:  1 bug found   → fix, counter resets
Wave 6:  0 bugs        → clean 1/3
Wave 7:  0 bugs        → clean 2/3
Wave 8:  0 bugs        → clean 3/3 HARDENED
```

## Examples

| Need | Command |
|------|---------|
| Thorough review of a new module | `/lotc three-seers` |
| Bug hunt before release | `/lotc horde` |
| API design review | `/lotc council-of-elrond` |
| Merge a feature branch | `/lotc scribe-merge` |
| Build system audit | Deploy Gimli |
| Performance analysis | Deploy Legolas |
| Security review | Deploy Aragorn |

## Repo Structure

```
lord-of-the-code/
├── SKILL.md              # Skill definition (characters, formations, scribe-merge)
├── agents/               # Agent definitions (10 .md files with YAML frontmatter)
├── install.sh            # Installs skill + agents + /lotc alias
├── README.md
└── LICENSE
```

## How It Works

Each character is an AI agent spawned at a specific model tier via Claude Code's Agent tool:

- **Opus** (Sauron, Gandalf, Frodo) — deep, thorough analysis for critical reviews
- **Sonnet** (Aragorn, Legolas, Gimli, Ents, Telchar) — balanced analysis for implementation reviews; Telchar also operates the local-LLM anvil
- **Haiku** (Uruk-Hai, Gollum) — fast and cheap, deploy in swarms for broad coverage

The `install.sh` script copies agent definitions to `~/.claude/agents/` and the skill to `~/.claude/skills/lord-of-the-code/`. The `/lotc` alias is generated at install time by patching the `name` field in the SKILL.md — same content, just a shorter invocation name.

## License

MIT

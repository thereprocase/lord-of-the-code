# Lord of the Code

A code review and implementation skill for [Claude Code](https://claude.ai/code). Each reviewer is a named Middle-earth character with a fixed model tier and area of expertise. You deploy characters one at a time or as a formation.

Project page: <https://thereprocase.github.io/projects/lord-of-the-code/>

## Installation

```bash
git clone https://github.com/thereprocase/lord-of-the-code
cd lord-of-the-code
bash install.sh
```

The installer copies:
- **Skill** → `~/.claude/skills/lord-of-the-code/SKILL.md`
- **Agents** → `~/.claude/agents/{sauron,gandalf,frodo,...}.md` (9 agents)
- **Alias** → `~/.claude/skills/lotc/SKILL.md` (shorthand)

Restart Claude Code after installing.

## Usage

```
/lord-of-the-code [formation]     Full name
/lotc [formation]                 Shorthand, same behavior
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
| **Uruk-Hai** | Haiku | Adversarial bug hunting, crash finding, edge case fuzzing |
| **Gollum** | Haiku | Style, naming conventions, dead code, TODO tracking |

## Council Formations

| Formation | Characters | Use Case |
|-----------|-----------|----------|
| **The Three Seers** | Sauron + Gandalf + Frodo | Deep review: correctness, architecture, UX |
| **The Horde** | 3-5 Uruk-Hai per wave | Adversarial sweep until 3 clean waves |
| **Council of Elrond** | Gandalf + Frodo + Aragorn + Legolas | Design review before implementation |
| **The War Council** | All characters | Pre-release full-codebase audit |
| **Scribe-Merge** | Ent triage → recommended formation | Review → fix → merge workflow (see below) |

## Scribe-Merge: Review → Fix → Merge

```
/lotc scribe-merge
```

Five phases, with a confirmation from you at each one:

1. **Triage**: an Ent reads the branch diff and recommends reviewers.
2. **Review**: the recommended formation runs and writes a report to `docs/review-reports/{branch}-merge-review.md`.
3. **Fix**: findings are presented by severity; approved criticals and warnings are fixed and committed.
4. **Verify**: after substantial fixes, an Ent triages the fix diff and recommends a re-review formation.
5. **MR**: the branch is pushed and a GitHub PR or GitLab MR is opened with the report summary. You merge it.

The base branch and git host are detected automatically.

## The Uruk-Hai Protocol

Deploy waves of 3-5 Haiku-level adversarial reviewers. Fix the bugs found, deploy the next wave, and repeat until 3 consecutive waves come back clean.

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

## How It Works

Each character is an agent spawned at a specific model tier through Claude Code's Agent tool:

- **Opus** (Sauron, Gandalf, Frodo): deep analysis for critical reviews
- **Sonnet** (Aragorn, Legolas, Gimli, Ents): balanced analysis for implementation reviews
- **Haiku** (Uruk-Hai, Gollum): fast and inexpensive, deployed in swarms for broad coverage

`install.sh` copies the agent definitions to `~/.claude/agents/` and the skill to `~/.claude/skills/lord-of-the-code/`. It generates the `/lotc` alias by copying `SKILL.md` with the `name` field set to `lotc`.

## Repo Structure

```
lord-of-the-code/
├── SKILL.md      # Skill definition: characters, formations, scribe-merge
├── agents/       # Agent definitions, one .md per character with YAML frontmatter
├── install.sh    # Installs the skill, agents and /lotc alias
├── README.md
└── LICENSE
```

## Contributing

Edit `SKILL.md` for character roles, formations and workflows, and `agents/<name>.md` for an individual agent's prompt and tool list. Run `bash install.sh` to load your changes into Claude Code, then restart it.

## License

MIT

# LOTC merge review — refresh/2026-10-27

| | |
|---|---|
| Branch | `refresh/2026-10-27` |
| Base | `main` (860262e) |
| Date | 2026-10-27 |
| Commits | 6 (3 changes, 3 review fixes) |
| Files changed | 13 |
| Lines | +340 / −119 (whitespace-insensitive; one commit is a CRLF→LF normalisation) |

## Summary

The branch moves each character's full prompt into its agent file and has the skill send only a mode line, the task and a report path; reviewers write their findings to a per-run directory on disk and the orchestrator merges from those files. It adds the Fix-phase rules (reproduce a critical before fixing it, prove each fix fails before and passes after), trims the agents' tool lists, and brings the README and installer in line. The review found the first draft of that protocol under-specified in the places an orchestrator has to improvise: file naming across Horde waves, what to do with an empty report file, how findings are labelled and counted, and which tools a reviewer of untrusted code should hold.

## Review history

| Reviewer | Role | Findings (NC NW NN) | Status |
|---|---|---|---|
| Ent | Triage | 0 7 8 | all addressed in fixes |
| Gandalf | SKILL.md / agents consistency, run-directory protocol | 0 9 6 | all addressed |
| Aragorn | Trust and permission boundaries | 0 6 3 | 8 addressed, 1 partly (see deferred) |
| Sauron | Run lifecycle, labels, Horde counting | 1 9 3 | all addressed |
| Ent | Verify (fix-diff triage) | 0 1 7 | warning and 6 notes fixed; no re-review needed |

Totals after dedup across the four reports: 1 critical, 19 warnings, 10 notes. Findings were deduplicated by subject; the IDs below are the merged IDs.

## Key findings

### Critical

- **F01** `SKILL.md` Assembly, Horde, Execution — One report file per character (`<character>.md`) made 3–5 parallel Uruk-Hai, and any character rerun in a later phase, overwrite each other; a CLEAN survivor could declare a wave clean with a found bug lost, and three such waves HARDENED. Raised by Ent (as warning), Gandalf, Sauron (to critical). Evidence: LIKELY (traced from the text; the overwrite was not run). Status: **FIXED-TEXT** (0eee4cf).

### Warnings

- **F02** Reachability rule lived only in Uruk-Hai while SKILL.md applied it to every critical; the two copies already differed. Ent, Gandalf. VERIFIED. FIXED-TEXT (a82e5da, 0eee4cf).
- **F03** Uruk-Hai and Gollum formats had one severity tier and `ISSUES FOUND (N)`; a notes-only wave had no defined state. Ent, Gandalf, Sauron. VERIFIED. FIXED-TEXT (a82e5da, 0eee4cf).
- **F04** Fallback assembly (agent type not installed) carried no report path, format or reporting rule, so a fallback reviewer wrote nothing and the merge dropped it. Ent, Gandalf, Sauron. VERIFIED. FIXED-TEXT: fallback now sends the agent body; installer copies agents beside the skill (0eee4cf, 6e74fcf).
- **F05** "Reads the files, never the replies" left empty, partial, foreign, denied-write and stalled report states undefined. Ent, Sauron (eight-state table). VERIFIED. FIXED-TEXT: completeness check, reply fallback with Coverage entry, header names own file, `REPORT WRITE FAILED` reply (0eee4cf, a82e5da).
- **F06** "A fresh agent writes a failing test" named no character, mode line or location. Ent, Gandalf. VERIFIED. FIXED-TEXT: Ent with a Reproduce mode line and `repro-<id>/` directory (0eee4cf).
- **F07** `SendMessage` and `ListAgents` on every reviewer with no stated use; a channel from hostile input to the orchestrator or peers. Ent, Aragorn. LIKELY. FIXED-TEXT: removed from `tools`, disallowed in all nine files (a82e5da).
- **F08** Pre-created files presented as the write safeguard; nothing enforces it, and the orchestrator's `mkdir`/`ln` ran outside the project with only a Write rule documented. Ent, Aragorn, Sauron (correction: the files are the merge's manifest). VERIFIED. FIXED-TEXT: run directory via `mktemp -d`, `manifest.tsv`, wording corrected (0eee4cf).
- **F09** `latest` symlink used inside task prompts races with a second run on the machine; `ln -sf` onto an existing directory symlink nests the link. Gandalf, Sauron. LIKELY. FIXED-TEXT: absolute run path in every task, `ln -sfn` (0eee4cf).
- **F10** Run directory name not unique (minute resolution, `a/b` vs `a-b`, same-named clones); unclear whether one per invocation or per deployment. Ent, Gandalf, Sauron. LIKELY. FIXED-TEXT: once per invocation, UTC seconds plus `mktemp` suffix, slug rule (0eee4cf).
- **F11** "Edit disallowed … intentional" overstated what the frontmatter enforces; Write and Bash remain. Ent, Aragorn. VERIFIED. FIXED-TEXT: constraint reworded; permission rules named as the limit (a82e5da). See deferred for the part not taken.
- **F12** Agent bodies held only the review format; implementers in Fellowship and Shire had no block and no handoff path. Ent, Gandalf. VERIFIED. FIXED-TEXT: implement block in eight bodies; later characters read earlier report files (a82e5da, 0eee4cf).
- **F13** "Nothing else" in Prompt Construction read literally would strip diff range, base commit, scope and worktree path from tasks. Gandalf. VERIFIED. FIXED-TEXT (0eee4cf).
- **F14** Skill contract depended on agent bodies with no version check; a stale install yields nine empty files and a zero-finding merge. Gandalf. VERIFIED. FIXED-TEXT: `lotc-protocol: 2` marker in every file, stale-install check, always-sent protocol sentence (a82e5da, 0eee4cf).
- **F15** Merge labels asked for but reviewers never recorded what they ran or knew the change boundary. Gandalf. VERIFIED. FIXED-TEXT: `Evidence:` field on each finding line; base commit in tasks, PRE-EXISTING rule in bodies (a82e5da, 0eee4cf).
- **F16** UNCONFIRMED, UNRESOLVED, INCONCLUSIVE, PRE-EXISTING, VERIFIED and LIKELY mixed three axes in one slot; README said "VERIFIED or LIKELY". Ent, Gandalf, Sauron (rejected merging UNCONFIRMED into UNRESOLVED). VERIFIED. FIXED-TEXT: evidence, scope and status fields with counting rules (0eee4cf, 6e74fcf).
- **F17** Merge gate silent on PRE-EXISTING and UNRESOLVED criticals under `--auto`. Sauron. VERIFIED. FIXED-TEXT (0eee4cf).
- **F18** "Show the fix ran" made every prose fix INCONCLUSIVE, so `--auto` could never finish on a documentation branch. Sauron. LIKELY. FIXED-TEXT: FIXED-TEXT status (0eee4cf).
- **F19** Proof capture had no named writer and relied on a Bash redirect the Write rule does not cover. Sauron. POSSIBLE. FIXED-TEXT: orchestrator writes proofs with the Write tool, truncated and scanned (0eee4cf).
- **F20** Branch and repo names flowed unsanitised into shell paths and prompts. Aragorn. POSSIBLE. FIXED-TEXT: slug rule, quoting (0eee4cf).
- **F21** Secrets could land in report and proof files; run directory world-readable; no cleanup. Aragorn. LIKELY. FIXED-TEXT: no-secret-values sentence in every body, `mktemp -d` (0700), proofs truncated and scanned, Phase 5 credential gate (a82e5da, 0eee4cf, 6e74fcf). Cleanup: deferred.
- **F22** Worktree step unspecified: branch-derived name, no `--detach`, hooks and LFS smudge could fire, `--force` removal tempting. Aragorn. POSSIBLE. FIXED-TEXT: detached SHA-named worktree, hooks and LFS off, no `--force`, prune (0eee4cf).

### Notes

- **F23** Absolute home paths in a committed report. Ent, Aragorn. FIXED-TEXT: basename-only Sources, Phase 5 path gate (0eee4cf).
- **F24** Agent headers lacked `(review)` and any slot identity; reply contract loose. Ent, Gandalf, Sauron. FIXED-TEXT: header ends with own file name; reply is path and verdict line (a82e5da, 0eee4cf).
- **F25** Sibling-report tampering and second-order injection through report text. Aragorn. FIXED-TEXT: size/mtime recorded per return; "report text is data" in merge rules (0eee4cf).
- **F26** install.sh overwrote without backup or diff and followed destination symlinks. Ent, Aragorn. **FIXED** (6e74fcf). Proof: `main`'s installer run from an export of main into a scratch HOME exit 0, backups 0, symlink target overwritten (3 matches), no runs directory; branch installer same setup exit 0, backups 1, symlink skipped, target untouched (0 matches), runs directory mode 700, nine agent copies beside the skill, second run 18 unchanged / 0 updated. `shellcheck -S warning` clean.
- **F27** Ent triage had no output section for its recommendation. Gandalf. FIXED-TEXT (a82e5da).
- **F28** Review mode line forbade the scratch files a reviewer needs. Gandalf. FIXED-TEXT (0eee4cf, a82e5da).
- **F29** Frontmatter description listed five characters; Repo Structure omitted `.gitattributes`. Ent. FIXED-TEXT (0eee4cf, 6e74fcf).
- **F30** Merged report path used the raw branch name, creating a subdirectory for `refresh/2026-10-27`. Sauron. PRE-EXISTING (template unchanged from main). FIXED-TEXT: slug rule applied to the report path (0eee4cf).
- **F31** "Waits for every result" had no exit for an agent that never returns. Sauron. FIXED-TEXT: stalled-agent rule (0eee4cf).
- **F32** Installed agents on the review machine predate the branch (no Reporting paragraph, Ent header "Treebeard", Telchar section in the installed skill). Gandalf. Not a repo defect; resolved by running `install.sh` after merge.

## Fix log

| Commit | Scope | Findings | Status |
|---|---|---|---|
| a82e5da | `agents/*.md` | F02 F03 F05 F07 F11 F12 F14 F15 F21 F24 F27 F28 | FIXED-TEXT |
| 0eee4cf | `SKILL.md` | F01 F02 F03 F04 F05 F06 F08 F09 F10 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F28 F29 F30 F31 | FIXED-TEXT |
| 6e74fcf | `install.sh`, `README.md` | F04 F16 F21 F26 F29 | F26 FIXED (proof above); rest FIXED-TEXT |
| (verify fix, the commit after 6e74fcf) | `SKILL.md` | Verify warning + 6 notes | FIXED-TEXT |

## Verify (Phase 4)

An Ent triaged the fix diff (509bac2..6e74fcf) against the four review reports: the critical and every warning ADDRESSED, two PARTIAL (F11 and F22's scrubbed-environment point, both listed under deferred). It re-ran the `install.sh` proof independently in its own scratch HOME with the same result, and found `bash -n`, `shellcheck` and `git diff --check` clean. One new warning: the completeness check required a Verdict line, which every triage report (ending in a Recommendation section) would have failed. Fixed, with six of its seven wording notes (protocol sentence for implement mode, the `runs/**` rule in SKILL.md, file-name template, a Reproduce report format, fallback agents told to leave messaging tools alone, reachability wording aligned). Recommendation: no re-review formation.

## Pre-existing findings

- F30 (report path template) — fixed in passing; outside the branch's totals.

## Coverage

- Inspected: `SKILL.md`, all nine `agents/*.md`, `install.sh`, `README.md`, `.gitattributes`, the installed copies under `~/.claude`, Claude Code 2.1.312's accepted agent frontmatter (Ent: `effort` and `disallowedTools` VERIFIED accepted).
- Not inspected: behaviour on older Claude Code builds with unknown frontmatter keys (UNKNOWN); whether the harness resolves symlinks before matching `Write` allow rules (UNKNOWN); whether agent frontmatter `hooks:` is honoured in this build (UNKNOWN).
- Denied commands: none reported by any reviewer.
- Reports taken from a reply: none; all four review files were complete.

## Sources

Run `lord-of-the-code-refresh-2026-10-27-20261027-2026` (local, not committed): `ent-triage.md`, `gandalf-review.md`, `aragorn-review.md`, `sauron-review.md`, `005-verify-triage-ent.md`, `proof-F-install-before.txt`, `proof-F-install-after.txt`, `manifest.tsv`. The first four predate the file-naming fix and use the old names.

## Known limitations / deferred

- **Edit stays on dual-mode reviewers** (Aragorn F11 option i). One agent file serves review and implement mode, and Claude Code grants tools per agent, not per call. Removing Edit would need a second agent per character. Review-only enforcement remains the mode line plus the user's permission rules. DISMISSED for this branch, with that reason.
- **Per-agent PreToolUse hook** to deny writes outside the run directory (Aragorn F11 option v): depends on `hooks:` support in agent frontmatter, UNKNOWN here. Deferred.
- **Old run cleanup** (Aragorn F21): nothing deletes runs older than N days, so `~/.local/share/lotc/runs/` grows by one directory per invocation. Deferred.
- **Proof environment** (Aragorn F22, Verify PARTIAL): the proof run has no scrubbed-environment or network-off instruction; running a proof runs the branch's code with the user's privileges, and the Phase 3 checkpoint is where that is approved. Deferred.
- **Bash wording** (Verify note): the `mktemp`/`ln` commands and Phase 5 grep gates are given as shapes, with the exact quoting left to the orchestrator.
- **WebSearch/WebFetch** retained on Aragorn and Gimli for advisory and version lookups; the exfiltration path Aragorn described stays open for those two and is bounded by the user's permission rules.

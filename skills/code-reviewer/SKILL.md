---
name: code-reviewer
description: >-
  Comprehensive workflow for reviewing code branches against the main line,
  inspecting diffs, validating quality, and reporting structured findings. Use
  when asked to check out a branch, compare it with master, assess risks, and
  summarize review outcomes.
---

# Code Review Guide

## Scope
- Focus on repository branches supplied in the request.
- Compare against `master` (or another explicitly named base) for drift.
- Produce a concise, evidence-based review summary highlighting approval
  status, risks, and follow-up items.

## Quick Start
1. Capture Jira ticket info using jira_get_issue MCP tool if a ticket ID was provided (summary, status, acceptance criteria).
2. Load repo context (read applicable `AGENTS.md` instructions).
3. Fetch updates and check out target branch.
4. Identify base branch (`master` unless specified) and diff scope.
5. Review diffs file-by-file, noting risks, tests, ticket alignment, and missing coverage.
6. Validate build/test signals if feasible.
7. Craft summary with approval stance, Jira alignment, key findings, and next steps.

### Jira Verification Workflow (when ticket supplied)
1. Treat the ticket as the source of truth for scope and acceptance criteria.
2. Capture ticket basics at the start of review:
   - ID, summary, status, owner(s)
   - Acceptance criteria / testing requirements
   - Due dates or release vehicles
3. Cross-reference PR contents with the ticket:
   - Confirm branch name or PR title references the ticket ID.
   - Ensure files changed match the ticket scope; flag any extra migrations / config edits.
   - Check acceptance criteria are addressed in code, tests, or documentation.
4. Inspect Jira history for warnings:
   - Blockers, dependencies, escalations, or QA notes.
   - Recently added comments that may affect review focus.
5. Validate code vs. ticket:
   - For each acceptance criterion, map to implementation evidence (files, tests).
   - Note unmet criteria or missing tests and call them out as review findings.
6. Document findings referencing the ticket:
   - Mention satisfied criteria or concerns in the summary.
   - Suggest Jira updates (status change, new subtask) if scope deviates.
7. If ticket info is missing, request clarification before approving.

## Detailed Workflow

- Locate the ticket link/ID mentioned in the request (e.g., `INDIGO-123`).
- Open the ticket directly or via the `implement-jira-task` skill to gather summary, status, owners, acceptance criteria, and due dates.
- Confirm the PR title/description references the same ticket and the branch scope matches ticket expectations.
- Note any acceptance criteria or edge cases that must be validated in code review or testing.
- Capture ticket status transitions or blockers to mention in the review summary.

### 1. Collect Context
- Read `README.md`, PR description (if available), and any linked specs.
- Capture branch name, base branch, and high-level feature intent.
- Note required tooling, lint, or test commands.
- Record how the change should satisfy the Jira ticket (if applicable).

### 2. Branch Preparation
- `git fetch --all --prune`
- `git checkout <target-branch>`
- Ensure workspace clean; stash local changes if necessary.
- Confirm branch currency with `git status` and `git pull --ff-only` if
  allowed.

### 3. Establish Diff Baseline
- Determine base branch (default `master`).
- Run `git merge-base` if clarification needed.
- Use `git diff <base>...HEAD --stat` to scope change size.

### 4. Inspect Changes
- Prefer `git diff` or IDE diff with `--color-words` for readability.
- Review commit history (`git log <base>..HEAD --oneline`) for intent.
- For each file:
  - Understand functional impact and test coverage.
  - Identify risky changes (state mutations, concurrency, security, perf).
  - Flag style/test gaps relative to project standards.

### 5. Validate Behavior
- Execute targeted tests or builds when feasible and cost-effective.
- Capture results (pass/fail, logs, skipped due to constraints).
- Note any manual steps the author should run if not covered.

### 6. Summarize Findings
- State approval recommendation (approve / request changes / block).
- List major findings with evidence: file, reasoning, severity, and whether they violate ticket criteria.
- Call out validation steps taken (tests run, commands).
- Mention Jira ticket alignment: status, unmet acceptance criteria, or discrepancies.
- Note deferred checks or open questions.
- Provide actionable next steps for the author (including ticket updates when needed).

## Deliverables
- Concise written summary (bulleted is fine) with:
  - Decision and rationale
  - Key issues or confirmations
  - Suggested follow-up work
- Optional: inline comments using `::code-comment{}` for precise findings.

## References
- `references/workflow-checklist.md` — condensed checklist for live reviews.
- `references/review-summaries.md` — templates and phrasing examples.

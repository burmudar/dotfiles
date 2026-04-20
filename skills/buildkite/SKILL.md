---
name: buildkite
description: Debugs failed Buildkite CI builds. Use when analyzing CI failures, reading build logs, or troubleshooting pipeline issues.
---

# Buildkite CI Debugging

Diagnose failed Buildkite builds for the Sourcegraph pipeline.

## Quick Start

Given a build URL like `https://buildkite.com/sourcegraph/sourcegraph/builds/344886`:

- Extract org: `sourcegraph`, pipeline: `sourcegraph`, build number: `344886`

## Finding Builds

List recent builds for a branch:

```
list_builds(org_slug="sourcegraph", pipeline_slug="sourcegraph", branch="main", per_page=10, detail_level="summary")
```

Filter by state (failed, passed, running, canceled):

```
list_builds(org_slug="sourcegraph", pipeline_slug="sourcegraph", state="failed", per_page=10)
```

## Workflow

### 1. Get build overview and failed jobs

```
get_build(org_slug="sourcegraph", pipeline_slug="sourcegraph", build_number="...", detail_level="detailed", job_state="failed,broken")
```

This returns:

- Build state, branch, commit
- List of failed jobs with their `id`, `name`, and `exit_status`

### 2. Read failure logs

For quick diagnosis (most failures show at end):

```
tail_logs(org_slug="sourcegraph", pipeline_slug="sourcegraph", build_number="...", job_id="...", tail=100)
```

### 3. Search logs for patterns

```
search_logs(org_slug="sourcegraph", pipeline_slug="sourcegraph", build_number="...", job_id="...", pattern="error|failed|FAIL", context=3)
```

### 4. Check annotations

Build annotations often contain test failure summaries:

```
list_annotations(org_slug="sourcegraph", pipeline_slug="sourcegraph", build_number="...")
```

## Common Patterns

| Failure Type  | Search Pattern                       |
| ------------- | ------------------------------------ |
| Test failures | `FAIL\|FAILED\|panic`                |
| Build errors  | `error:\|Error:\|compilation failed` |
| Timeouts      | `timeout\|exceeded\|deadline`        |
| OOM           | `out of memory\|OOMKilled`           |

## Org and Pipeline

For this repository:

- `org_slug`: `sourcegraph`
- `pipeline_slug`: `sourcegraph`

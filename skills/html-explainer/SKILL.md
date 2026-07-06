---
name: html-explainer
description: >-
  Use when the user asks for a rich, interactive explanation of any topic —
  a concept, a system, a codebase, an algorithm, a paper, a code change/PR, or
  anything they want to learn or teach. Produces a single self-contained HTML
  file with a table of contents, diagrams, and an interactive multiple-choice
  quiz that checks understanding.
---

# HTML Explainer

Produce a rich, interactive, self-contained HTML explanation of whatever the
user wants to understand. This is general-purpose: the subject can be a concept,
a system's architecture, a codebase, an algorithm, a research paper, a code
change / diff / PR, or any topic the user is trying to learn or teach.

First, investigate the subject thoroughly (read the relevant code, docs, or
source material) so the explanation is grounded in fact, not speculation.

## Sections

Adapt the sections to the subject, but generally include:

- **Background**: Explain the surrounding context relevant to the topic. The
  reader's starting knowledge is unknown, so include a deep background for
  beginners (clearly marked as skippable for those already familiar), then a
  narrower background directly relevant to the topic.
- **Intuition**: Explain the core intuition. Focus on the essence, not full
  details. Use concrete examples with toy data. Use figures and diagrams
  liberally.
- **Details / Walkthrough**: A high-level walkthrough of the substance —
  the mechanism, the code, the argument. Group and order it in an
  understandable way.
- **Quiz**: Five multiple-choice questions that test the reader's understanding.
  Medium difficulty — hard enough that you must actually understand the material
  to answer, but not gotchas. The goal is to help the reader confirm they truly
  understood. Presented as interactive multiple-choice; clicking an answer
  reveals whether it was correct and gives feedback explaining why each option
  is right or wrong.

## Quiz behavior

- Each question has 3–5 options.
- Clicking an option immediately shows correct/incorrect state (e.g. ✅ / ❌)
  and per-option feedback explaining the reasoning.
- Don't reveal the answer before the user clicks.
- Keep a running score, and show a summary once all questions are answered.

## Difficulty levels

Author the quiz with **two difficulty levels** so the reader can escalate:

- **Level 1 (default)**: medium difficulty — conceptual understanding, the kind
  of questions in the main Quiz section above.
- **Level 2 (harder)**: quantitative reasoning, edge cases, corner behaviors,
  "what breaks if…" scenarios, and questions that combine multiple ideas from
  the explanation. Still fair (no gotchas), just deeper.

Implementation:
- Add a difficulty toggle at the top of the quiz section (two buttons/tabs:
  "Level 1" and "Level 2 (harder)"). Default to Level 1.
- Switching level swaps the question set and resets the score for that level.
- Both levels share the same interactive behavior (per-option feedback, running
  score, copy-results button).
- In the score summary: if the user aces Level 1, nudge them toward Level 2; if
  they're on Level 2, the copy-results payload should note the level so the
  in-session follow-up is calibrated correctly.
- Store both question sets in the page's JavaScript (e.g. `QUESTIONS.level1` and
  `QUESTIONS.level2`), each with 5 questions.

When the user pastes back a perfect Level 1 score in-session, offer a Level 2
set directly in chat as well (don't require regenerating the HTML).

## Feedback loop (adaptive follow-up)

The HTML runs in a sandboxed browser and cannot talk back to the agent session
on its own. To close the loop, make the quiz emit a copyable results summary and
tell the user to paste it back.

- After the last question, show a **"Copy results for follow-up"** button that
  writes a compact plain-text summary to the clipboard via
  `navigator.clipboard.writeText`. The summary must include:
  - the topic/title and the score (e.g. `Score: 3/5`),
  - one line per question marked ✅/❌,
  - for each missed question, the exact option the user chose,
  - a trailing line asking for tailored follow-up on the missed items.
- Include a hint under the button: "Paste this back into your agent session to
  get tailored follow-up questions."

When the user pastes results back into the session, act as an adaptive tutor:
- Acknowledge what they got right briefly; focus on what they missed.
- For each wrong answer, diagnose the likely misconception (based on the option
  they chose), re-explain that specific point concretely, then ask a fresh
  follow-up question to confirm they now understand — e.g. "I see you missed the
  false-negative question. Here's the intuition… want to try a variation?"
- Offer to regenerate an updated HTML with a new mini-quiz targeting the weak
  spots if they prefer to keep practicing in that format.
- If they scored full marks, offer a harder "level 2" set instead.

## Format

- Output a **single self-contained HTML file** with inline CSS and JavaScript —
  no external dependencies or CDN links.
- One long page with section headers and a table of contents at the top. Don't
  use tabs for top-level structure.
- Include basic responsive styling so it reads well on a phone.
- Save the file outside the code repo with a filename that starts with today's
  date in `YYYY-MM-DD-` format (keeps files time-sorted and out of version
  control). Example: `/tmp/2026-01-12-explanation-raft-consensus.html`.
- After saving, tell the user the path and offer to open it.

## Writing style

- Write with the clarity and flow of Martin Kleppmann: engaging, classic style,
  smooth transitions between sections.
- Use callouts for key concepts, definitions, and important edge cases.

## Diagrams

- Pick a small number of reusable diagram families and apply them throughout
  rather than inventing a new visual language per figure. Useful kinds:
  - A simplified version of a UI, to explain UI behavior.
  - A system diagram showing data flow / communication between components —
    **include example data flowing through it**.
- Don't use ASCII diagrams. Use simple HTML/CSS designs for diagrams, HTML lists
  for lists, etc.
- For code blocks, always use `<pre>` tags. If you use a styled `<div>` instead,
  it **must** set `white-space: pre` or `pre-wrap`, or the browser collapses
  newlines onto one line. Before saving, scan every code block and confirm its
  CSS includes `white-space: pre` or `pre-wrap`.

---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces HTML output.
---

# Explain Diff

Please make me a rich, interactive explanation of the specified code change.

It should have these sections:

- Background: Explain the existing system relevant to this change. (You should broadly explore surrounding code for this.) We don't know how much the reader already knows, so include a deep background for beginners (note that it can be skipped if the reader is already familiar), and then a more narrow background directly relevant to the change.
- Intuition: Explain the core intuition for the code change. The focus here is to explain the essence, not the full details. Use concrete examples with toy data. Use figures and diagrams liberally. If it is helpful to create a bespoke interactive visualization to illustrate the concept (e.g. a simulator based on how the system actually works, do so. If you deem it necessary, you can use deno, svelte, etc. to create the visualization - do so.)
- Code: Do a high-level walkthrough of the changes to the code. Group/order the changes in an understandable way.
- Quiz: Come up with five questions that test the reader's knowledge of this PR. This should be medium difficulty, difficult enough that you actually need to understand the substance of the PR to answer them, but not gotchas. The goal is to help the reader make sure that they've actually understood. These should be presented as interactive multiple-choice questions, and when the user clicks, it tells them whether they were correct and gives feedback. For each of the incorrect answers, if the user chooses them it should also tell why that particular answer was incorrect.
  - The page should include some simple javascript logic that randomises the order of the quiz answers on every page load.
  - All four options in a question must be indistinguishable by surface features: roughly the same length (within ~25% of each other), the same level of technical specificity, and the same tone. A test-savvy reader must not be able to guess the answer without understanding the material. The most common failure mode: writing the correct answer as a long, precise sentence full of file names and mechanism, while the distractors are short generic sentences. Fix it by making the distractors equally long and specific — give each one concrete (but wrong) mechanisms, plausible-sounding file/function names, and confident phrasing — and/or by trimming the correct answer down. A wrong answer should read like something a reasonably informed colleague might actually believe.
  - Bad (correct answer sticks out): ✗ "In the scheduler" / ✗ "In the UI layer" / ✓ "In `GitHubSource.excludes` (internal/repos/github.go), which drops locked repos at list time during external service sync, so the fetch path never re-checks the flag" / ✗ "In gitserver".
  - Good (uniform depth): ✗ "In the scheduler's ranking query, which deprioritizes locked repos so they are fetched last but never skipped entirely" / ✗ "In gitserver's `IsCloneable` pre-flight check, which runs `git ls-remote` before every clone and records lock refusals" / ✓ "In `GitHubSource.excludes` during listing, which silently drops locked repos from the sync results before they reach the database" / ✗ "In the syncer's diff step, which marks locked repos as blocked in the repo table so the UI can hide them".
  - Before saving the file, do a final pass over each quiz question: check whether the correct option is the longest or the only one naming concrete identifiers. If that's true for two or more questions, rewrite those options until length and specificity no longer correlate with correctness.

Format:

- Output a single self-contained HTML file which includes CSS and JavaScript. Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too. Put the file in a global place on my computer outside of the code repo, and make sure the filename always starts with today's date in `YYYY-MM-DD-` format, because it helps keep the files time-sorted and out of version control. For example: /tmp/2026-01-12-explanation-<slug>.html
- Please write with the clarity and flow of Martin Kleppmann, making it engaging and written in classic style. Transitions between sections should be smooth.
- Some tips on diagrams. Ideally, you should pick a small number of diagram families that can be reused throughout the explanation to explain various cases. Some useful kinds of diagrams:
  - A very simplified version of the UI that the user sees in the app, to explain UI changes.
  - A system diagram showing data flow or communication between components. Make sure to include example data here!
- Don't use ASCII diagrams. Always use simple HTML designs for your diagrams, HTML lists for lists of things, etc.
  - For code blocks, always use `<pre>` tags. If you use a custom styled div instead, it **must** have
    `white-space: pre-wrap` in its CSS, or the browser will collapse all newlines into a single line.
    Before saving the file, scan each code block in the HTML source and confirm its CSS includes
    `white-space: pre` or `pre-wrap`.

- Use callouts for key concepts or definitions, important edge cases, etc.


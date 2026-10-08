# AI-Powered Daily Standup Briefing: Automating Sprint Visibility

## Context

Every sprint, the team I work with, a cross-functional group of engineers and QA building a B2B2C platform, moves roughly **60 primary tickets** through a multi-stage workflow in two-week cycles. Standups run four times a week, plus dedicated backlog refinement.

Those meetings only work if everyone shares the same picture of the board. In practice, that picture depended on two things: how current the Jira data was, and how consistently the delivery-hygiene work (status updates, blocker follow-up, cross-team dependencies) was being done.

## The Problem

The board and reality had drifted apart, and I could see it every day:

- **Stale statuses.** Tickets sat in "Ready for QA" while QA had already logged time against them. The work was in progress; the status said otherwise.
- **Unexplained blockers.** Tickets were marked Blocked with no documented reason, or with a reason that lived only in a comment thread.
- **Silent stagnation.** Tickets stayed in the same status for **20+ days** with no documented explanation.
- **Fast standups, slow follow-through.** Tickets were reviewed quickly, and when a blocker came up it was acknowledged, but no owner or next step was captured. Nothing moved.

Because I couldn't trust the board, I audited it myself before every standup, and I often learned about blockers live, in the meeting. In effect I was covering two roles: owning the product and auditing the board.

The cost showed up in three places: **decisions that came late** because a blocker surfaced late, **meeting time spent asking for status** instead of resolving issues, and **limited visibility for stakeholders** into what was really stuck.

## My Role

This wasn't in my job description or on my backlog. As Product Owner I'm accountable for outcomes, so I treated the visibility gap as a product problem with a user (me), a job to be done ("walk into every standup knowing what changed, what's blocked, and what needs a decision") and clear success criteria.

- **Defined the requirements like a PRD:** sources of truth, time windows (Monday covers the weekend), what counts as a blocker, and what the system must never do: guess.
- **Designed the logic:** a documentation check for every blocker (documented / partial or contradictory / none), exact-day aging of tickets sitting in one status, and a day-over-day comparison against the previous report.
- **Built it as an AI agent** on Claude, connected to Jira, Confluence and Slack through MCP connectors, and ran it as a scheduled task.
- **Iterated through multiple pilot runs.** The first version relied on full ticket change histories, which exceeded payload limits, so I redesigned it around lightweight queries that return only what changed. Early versions also over-flagged tickets carrying outdated block reasons, so I separated true blockers from a "data hygiene" list.
- **Kept judgment human.** Backlog refinement and prioritization stay manual by design. The automation informs decisions; it doesn't make them.

## The Automation Flow

[Insert flow diagram SVG here]

The flow runs in five stages, every weekday at 6:30 am:

1. **Trigger:** a scheduled task starts a Claude agent, skips weekends, and sets the time window (Monday covers since Friday).
2. **Context:** it resolves the active sprint and loads yesterday's report as the baseline.
3. **Collect:** five lightweight query branches gather status changes, days in status, blocked-since dates, comments and blocker documentation.
4. **Compose:** it assembles a one-page report in ten fixed sections.
5. **Deliver:** the full report is published to Confluence and an executive summary lands in my Slack DM. Any failure triggers an alert instead of silence.

Key design decisions:

- **Lightweight over exhaustive:** small, targeted queries instead of heavy data pulls.
- **Facts or silence:** the agent never guesses; anything it can't verify is listed under "Data gaps".
- **Two surfaces, two depths:** Confluence for the full picture, Slack for the 30-second version.
- **A feedback loop:** today's report becomes tomorrow's baseline, which is what makes "what's new since yesterday" possible.

### The Report Template (Confluence)

> Placeholders shown for illustration only.

| Section | What goes here |
| :--- | :--- |
| **Header** | Sprint name and dates · business days left · time window · ticket count |
| **TL;DR:** *Here goes xxx* | The 3 things I must know before the meeting, in plain language |
| **New since last report:** *Here goes xxx* | Blockers that appeared or cleared, tickets added to or removed from the sprint |
| **Blockers:** *Here goes xxx* | Ticket · owner · blocked since (date + days) · reason · documentation check |
| **Status changes:** *Here goes xxx* | Ticket · from → to · owner, for the last 24 hours |
| **5+ days in the same status:** *Here goes xxx* | Idle tickets grouped by status, with exact age |
| **Relevant comments:** *Here goes xxx* | One-line synthesis of decisions, questions and asks, with PO-input items marked |
| **Questions for standup:** *Here goes xxx* | Up to five concrete questions derived from the data above |
| **Board by epic and status:** *Here goes xxx* | Every primary ticket, grouped by epic and ordered like the board |
| **Data gaps:** *Here goes xxx* | Only appears when a query failed; names exactly what is missing |

### The Slack Summary

> **Standup Prep: [Date]** · Sprint [X] · [N] business days left
> **Key points:** Here goes xxx / Here goes xxx / Here goes xxx
> **Blockers:** [TICKET] · [N days] · [documented / partial / none]
> **Movement:** [N] status changes · [N] tickets idle 5+ days
> **Questions for standup:** Here go the top questions
> **Full report:** [link to Confluence page]

*Under ~15 lines: the headline version, with the full report one click away.*

## Impact

*Time figures below are estimates from the pilot phase; first-run findings are measured.*

| Metric | Before | After |
| :--- | :--- | :--- |
| **Daily standup prep** | ~30 min of manual board auditing | ~5 min reading the briefing (**~80% reduction, est.**) |
| **Time recovered** | n/a | **~2 hrs/week, ~4 hrs/sprint** (est.) |
| **Blocker awareness** | Learned live, during the standup | Surfaced before the meeting, with days blocked and documentation status |
| **Idle-ticket visibility** | Ad hoc checks | Every ticket idle 5+ days listed daily with exact age |

**First-run findings (measured):** on its first pass over a ~60-ticket sprint, the briefing surfaced roughly **two-thirds of tickets idle for 5+ days**, about **30 of them for 14+ days**, and **several blockers with missing or contradictory documentation**: issues that were invisible in day-to-day board views.

**Beyond the numbers:** standups shifted from "what's the status?" to "what do we do about it?", and I got back the time I had been spending as a second set of eyes on the board.

**Next:** I'm tracking the share of tickets idle 5+ days per sprint, average days spent in Blocked, and a short team pulse on standup clarity to validate these estimates over the next two sprints.

---

**For the portfolio index:**
*Built an AI-powered daily briefing that audits sprint health every morning and delivers a one-page report to Confluence plus a Slack summary. Surfaced stale tickets, undocumented blockers and day-over-day changes before standup, cutting prep time by an estimated ~80%. Technical Product Owner | AI Automation | Jira | Agile.*

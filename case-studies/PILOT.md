# AI-Powered Daily Standup Briefing: Restoring Sprint Visibility with Automation

## Context

I'm the Product Owner of the Platform Experience team, the configuration and management layer of a B2B2C platform. Every other stream (core APIs, client SDKs, hosted solutions, developer documentation) has to pass through our layer to ship, so our backlog isn't a single team's backlog. It holds **multiple epics from different teams**, from customer-facing console features and security capabilities to partner integrations and production support.

Sprints run two weeks, and on average we carry **~61 primary items per sprint** (stories, tasks and bugs, excluding sub-tasks).

Work moves through a multi-stage workflow (Submitted, In Progress, Code Review, Ready for QA, In QA Review, Ready for UAT, plus Blocked), and the team runs four stand-ups a week, one of them focused on estimation, plus product backlog refinement. Keeping that board accurate depends on delivery hygiene: timely status updates, blocker follow-up and cross-team dependency tracking.

## The Problem

**The problem:** the board no longer reflected the real state of the work, and I had no reliable, daily way to see where the sprint actually stood.

**What it looked like:**

- **23 items** were sitting in "Ready for QA" or "In QA Review" at one point, 18 of them in the active sprint. **10 of those had waited 25+ days (~1.8 sprints).**
- **3 items triggered the tool's automatic alert** for carrying over **9 sprints** without closing.
- **Statuses contradicted reality.** QA time was logged on items still showing "Ready for QA". An item rejected in review still showed as waiting for QA. A fix sat untested for **31 days (~2.2 sprints)** after development finished it.
- **Items sat in the same status for 20+ days (~1.4 sprints)** with no documented reason.
- **Blocked items had no documented reason**, or cited dependencies that were already Done or Cancelled. One blocker on another team had no ticket and no owner.
- **Entire chains of related stories had not started**, with nothing on the board explaining why.

**The pain point:** this wasn't a lack of data. It was a lack of a trustworthy, daily signal. Board hygiene depended on manual follow-up, and stand-ups had moved to a fast, epic-level review that made individual stale items easy to miss. When a blocker was raised, it was acknowledged without an owner or a next step, and some blockers were never raised at all. To compensate, I audited the backlog by hand for **~45 minutes every day**, effectively covering two roles: owning the product and auditing the board.

**The consequences:**

- **Late decisions.** Blockers surfaced late or never, so unblocking, re-prioritization and escalation all happened late.
- **Invisible blockers.** Some were never mentioned in the daily scrum. I learned about them live in the meeting, or not at all.
- **Wasted meeting time.** Stand-ups were spent asking for status instead of resolving issues.
- **Hidden capacity problems.** Active QA work looked idle, rejected work looked like it was waiting for QA, and overloaded people or people who had left the team stayed hidden behind stale statuses.
- **Weak forecasting.** From the board alone, I couldn't tell what was in progress versus genuinely stopped, which undermined delivery forecasts and stakeholder updates.
- **Risk to priority commitments.** Critical items for a strategic partner and a security capability required by a customer went untouched or unstarted for most of a sprint.
- **Lost PO time.** Hours each week went to manual auditing instead of refinement and stakeholder work.

## My Role

This wasn't in my job description or on my backlog. As Product Owner, I'm accountable for the backlog and for outcomes, and that accountability rests on transparency: if I can't see where the sprint really stands, I can't inspect progress, re-prioritize or help unblock the team. So I treated the visibility gap as a product problem, with a user (me), a job to be done and testable success criteria.

**From pain point to requirement.** I wrote it as an enabler story with acceptance criteria:

> As a Product Owner of a multi-team backlog,
> I want a daily briefing of what changed, what is blocked and what has stalled,
> So that I can lead every stand-up with a clear view of the sprint and act on blockers the same day.

- *Given* a new weekday morning, *when* the briefing runs, *then* I receive a one-page report before the first stand-up covering the last 24 hours (on Mondays, since Friday).
- *Given* a ticket is Blocked, *when* it appears in the report, *then* it shows how long it has been blocked and whether its reason is documented, partial or missing.
- *Given* a ticket has stayed in one status for 5+ days, *then* it appears with its exact age.
- *Given* the system cannot verify a fact, *then* it is listed under "Data gaps" instead of guessed.

**The solution.** An AI agent, built on Claude and connected to Jira, Confluence and Slack through MCP connectors, that runs as a scheduled task every weekday at 6:30 am. It audits the active sprint, compares it against the previous day's report, and delivers a one-page briefing to Confluence plus an executive summary in Slack. The full design is in the next section.

**What I did:**

- **Defined the requirements like a PRD:** sources of truth, time windows, what counts as a blocker, and what the system must never do, which is guess.
- **Designed the logic:** a documentation check for every blocker, exact-day aging of items in one status, and a day-over-day comparison.
- **Iterated through multiple pilot runs.** The first version relied on full ticket histories, which exceeded payload limits, so I redesigned it around lightweight queries that return only what changed. Early versions also over-flagged tickets carrying outdated block reasons, so I separated true blockers from a "data hygiene" list.
- **Kept judgment human.** Refinement, estimation and prioritization stay manual by design. The automation informs decisions; it doesn't make them.

## The Automation Flow

The flow runs in five stages every weekday at 6:30 am.

**1. Trigger.** A scheduled task starts a Claude agent. It skips weekends and sets the time window: the last 24 hours, or since Friday on Mondays.

**2. Context.** The agent resolves the active sprint of my team's board, scoped to the board and not to the sprint name, so look-alike sprints from other teams never mix in. It then loads yesterday's report as the baseline for "what's new."

**3. Collect.** Five lightweight query branches, each built to return only small result sets:

- **Status changes:** one query per source status, giving from → to for every ticket that moved.
- **Days in status:** threshold queries (5, 6, 7, 10, 14 and 30 days) that bucket every idle ticket by exact age.
- **Blocked since:** day-by-day date probing that finds the exact date a ticket entered Blocked.
- **Comments:** read in small batches, ignoring automation noise and keeping decisions, asks and PO mentions.
- **Blockers:** block reason, flags, issue links and recent comments, classified as documented, partial or contradictory, or undocumented.

**4. Compose.** The agent assembles a one-page report in ten fixed sections, in English, using only verified facts.

**5. Deliver.** The full report is published to Confluence and a short summary is sent to my Slack. If anything fails, a Slack alert explains what went wrong instead of failing silently.

**Key design decisions:**

- **Lightweight over exhaustive:** small, targeted queries instead of heavy data pulls.
- **Facts or silence:** anything unverifiable is listed under "Data gaps."
- **Two surfaces, two depths:** Confluence for the full picture, Slack for the 30-second version.
- **A feedback loop:** today's report becomes tomorrow's baseline, which is what makes "what changed since yesterday" possible.

### The Report Template (Confluence)

| Section | What it contains |
| :--- | :--- |
| **Header** | Sprint name and dates, business days left, the time window used and the ticket count |
| **TL;DR** | The three things I must know before the meeting, in plain language |
| **New since last report** | Blockers that appeared or cleared, and tickets added to or removed from the sprint |
| **Blockers** | Ticket, owner, blocked since (date and days), reason, and a documentation check |
| **Status changes** | Every ticket that moved in the window, shown as from → to with its owner |
| **5+ days in the same status** | Idle tickets grouped by status, with exact age |
| **Relevant comments** | A one-line synthesis of decisions, questions and asks, with items needing PO input marked |
| **Questions for standup** | Up to five concrete questions derived from the data above |
| **Board by epic and status** | Every primary ticket, grouped by epic and ordered like the board |
| **Data gaps** | Appears only when a query failed, and names exactly what is missing |

### The Slack Summary

The headline version, in under 15 lines:

> **Standup Prep:** the date, the sprint and the business days left
> **Key points:** the three facts that matter most before today's stand-up
> **Blockers:** one line each, with days blocked and documentation status
> **Movement:** the count of status changes and of tickets idle 5+ days
> **Questions for standup:** the top questions to raise
> **Full report:** a link to the Confluence page

### Flow Diagram

![End-to-end automation flow](./assets/standup-prep-automation-flow.svg)

*The five stages, from the 6:30 am trigger to Confluence and Slack. The dashed arrow is the feedback loop: each report becomes the next day's baseline.*

## Impact

*Time figures are estimates from the pilot phase.*

| Metric | Before | After |
| :--- | :--- | :--- |
| **Daily prep time** | ~45 min reading the backlog | ~5 min reading the briefing (**~89% reduction, est.**) |
| **Time recovered** | n/a | **~3+ hrs/week, ~6-7 hrs/sprint** (est.) |
| **Blocker awareness** | Learned live in the stand-up, or not at all when a blocker was never raised | Surfaced before the meeting, with days blocked and documentation status |
| **Idle-ticket visibility** | Ad hoc, manual checks | Every ticket idle 5+ days (~0.4 sprints) listed daily with exact age |

**First-run findings (measured, rounded):** on its first pass over a ~60-item sprint, the briefing surfaced **43 of 63 items idle for 5+ days (about two-thirds)**, **29 of them for 14+ days (1+ sprint)**, and several blockers with missing or contradictory documentation, all before the first stand-up.

**Beyond the numbers:** I now walk into every stand-up knowing what moved, what is blocked and what needs a decision, with the questions already prepared. The aim is to move the conversation from "what's the status?" to "what do we do about it?", while the time I used to spend auditing goes back to refinement and stakeholder work.

**Next:** I'm tracking the share of items idle 5+ days per sprint, average days spent in Blocked, and a short team pulse on stand-up clarity to validate these estimates over the next two sprints.

---

**For the portfolio index:**
*Built an AI-powered daily briefing that audits a ~61-item, multi-team sprint backlog every morning and delivers a one-page report to Confluence plus a Slack summary. Surfaced stale tickets, undocumented blockers and day-over-day changes before stand-up, cutting daily prep from ~45 to ~5 minutes (est.). Technical Product Owner | AI Automation | Jira | Agile.*

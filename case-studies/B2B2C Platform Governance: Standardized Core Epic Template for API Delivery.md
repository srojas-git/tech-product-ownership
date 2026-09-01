# B2B2C Platform Governance: Standardized Core Epic Template

## Context

Prior to this template, epic creation across the organization lacked structure and standardization — not just within a single team, but at the org level. Every Product Owner defined epics differently, with no shared expectation of what information needed to exist before an item reached engineering.

## The Problem

Incomplete specs meant that critical context — business rationale, acceptance criteria, technical standards — was missing at the moment of grooming. This forced grooming sessions to double as discovery sessions, creating rework and "double stepping": POs scrambled to backfill information mid-sprint, and developers were left interpreting business intent instead of building against a clear definition of done.

As Helmuth von Moltke the Elder observed, no plan survives first contact with reality — and neither did these epics. Refinement sessions regularly ran long as teams tried to reverse-engineer requirements that should have existed from the start, costing an estimated **4+ hours per sprint** in clarification meetings alone.

## My Role

I identified this as a systemic, org-level gap rather than a team-specific issue, and proposed a standardized Core Epic Template to Connected Core leadership. I designed the field structure — covering user story format, standards compliance (REST API, logging, CI/CD), and a mandatory Tech Lead solution design section — and drove its adoption as the default epic format for the team, partnering with Tech Leads to validate that the fields actually reflected what engineering needed to start work without follow-up questions.

## The Template

> **Note:** The table below is filled with dummy/placeholder data for illustration purposes only.

```markdown
### Metadata

| | | | |
| :--- | :--- | :--- | :--- |
| **Type:** | Epic | **Priority:** | Medium |
| **Status:** | Backlog | **Assignee:** | Unassigned |
| **Reporter:** | S. Rojas | **Resolution:** | Unresolved |
| **Components:** | Partner Console | **Labels:** | dx, api |
| **Affects Versions:** | N/A | **Fix Versions:** | v2.4 |
| **Remaining Estimate:** | 20h | **Time Spent:** | 0h |
| **Original Estimate:** | 20h | **Votes:** | 0 |

### Custom Fields

| Field | Value |
| :--- | :--- |
| **Epic Name:** | Partner Webhook Retry Mechanism |
| **Sprint:** | Sprint 34 |
| **Project Category:** | Platform Experience |
| **Investment Category:** | Reliability |
| **Business Line:** | Partner Solutions |
| **Work Type:** | Feature Enhancement |
| **Domain / Group Owning:** | Connected Platform |
| **Date/Time Groomed:** | 15/Sep/26 |

---

### User Story

| | |
| :--- | :--- |
| **AS A** | Financial partner integrating via the Partner API |
| **I WANT** | Failed webhook deliveries to automatically retry with exponential backoff |
| **SO THAT** | I don't lose critical transaction events due to transient network failures |

### Background / Context

Partners currently experience silent data loss when webhook endpoints are temporarily unavailable. Support tickets related to "missing events" have increased 30% quarter-over-quarter, and root cause analysis traced the majority to failed deliveries with no retry logic.

### Assumptions

- Partner endpoints follow standard HTTP response codes to signal failure
- Retry logic will not exceed a 24-hour delivery window
- No changes required to the partner-facing API contract

### Definition of Done

- [ ] Retry logic implemented with exponential backoff (max 5 attempts)
- [ ] Failed deliveries logged and queryable via internal dashboard
- [ ] Unit and integration tests covering retry edge cases
- [ ] Solution reviewed and signed off by Tech Lead
- [ ] Release notes drafted for partner-facing changelog

### Standards

| Description | Standard / Link |
| :--- | :--- |
| REST API Guidelines | Internal REST API Standards Doc |
| Logging Standards | Internal Logging Guidelines |
| CI/CD Pipeline | Internal CI/CD Wiki |

### Acceptance Criteria

- Given a webhook delivery fails with a 5xx response, when the retry mechanism triggers, then the system attempts redelivery with exponential backoff up to 5 times
- Given all retries are exhausted, when the final attempt fails, then the event is logged as "failed" and surfaced in the monitoring dashboard

### Testing Notes

Test against simulated partner endpoints returning intermittent 500s and timeouts. Validate backoff intervals match spec (1m, 5m, 15m, 30m, 1h).

### Solution Design (Tech Lead)
Tech Lead: [Name]

### Comments
Template only — no work required until fields above are completed.
```

## Impact

Standardizing epic structure eliminated the discovery-during-grooming pattern, recovering approximately **4 hours per sprint** previously lost to requirement clarification meetings — time redirected toward actual refinement and delivery work. It also created a consistent enough structure between Confluence documentation and Jira epics to lay the groundwork for further workflow automation between the two tools.

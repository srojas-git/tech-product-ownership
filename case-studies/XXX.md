# Cross-Team Dependency Mapping — Platform Experience (PE)

**Category:** Agile Delivery & Product Discovery

## Context
The Platform Experience (PE) team sits at the center of the Experian Partner Services delivery model — the console and CRM configuration layer that every other stream (Connected Core, Connected SDK, Hosted Experiences, Dev Docs) has to pass through in some form. Despite that central position, there was no shared, explicit map of how PE blocked other teams, how other teams blocked PE, or what specifically was being exchanged (an API, a configuration, a piece of documentation, an approval).

## The Problem
Without a clear map of these dependencies, teams routinely hit the same failure pattern: a blocker would surface, and instead of going directly to the right owner, people would "double-step" — pinging multiple contacts across multiple teams to figure out who could actually unblock the item. On average, this added up to roughly 3 days of lost time per blocker, just in the process of finding the right person before any actual resolution work could start.

## My Role
Building a cross-team dependency map wasn't formally part of the PO scope for this stream. I identified it as a real pain point affecting delivery speed for the whole program and took it on as a self-initiated improvement, on top of my core backlog and requirements responsibilities.

## Artifact / Action
I set up structured working sessions with the Product Owners of each dependent team (Connected Core, Connected SDK, Hosted Experiences) to map, for every pair of teams:
- **Direction** — whether the dependency was inbound (they block PE) or outbound (PE blocks them)
- **Type** — whether the blocker was technical (API/backend), configuration-related, or documentation-related
- **Owner** — the specific point of contact responsible for resolving it, not just the team name

I consolidated this into an interactive stakeholder and dependency mapping tool, layered on top of the team's existing org chart, so anyone hitting a blocker could immediately see who to go to and what kind of dependency was involved — without needing to ask around first.

## Result
The mapping was well received and escalated up to the VP of Product, who had it shared across the broader program. Time-to-resolution on cross-team blockers dropped from an average of ~3 days (spent locating the right owner) to same-day resolution in most cases, meaningfully improving delivery velocity for PE and its dependent teams.

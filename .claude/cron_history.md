# Cron history

Crons scheduled via `/loop` or CronCreate in this repo, with their prompts
preserved verbatim so they can be recreated later.

State: `active` (still in CronList), `paused` (deleted by user, kept here
for easy resume), `expired` (auto-removed after 7 days), `done` (one-shot
fired).

## paused

### 8d842ac8 — every 5m (recurring) — paused 2026-05-25
Originally created by `/loop 5m`. Self-deleted on user request to pause.

Prompt (verbatim):
```
check crontodo.md and if there's something in there, do that and then clear the to-do. if not, continue normal work
```

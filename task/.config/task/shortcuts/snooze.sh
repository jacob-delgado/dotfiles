#!/usr/bin/env bash
# taskwarrior-tui shortcut 1 — snooze: hide the selected task(s) until tomorrow.
# Invoked with the selected/marked task UUID(s) as positional args ($@).
# rc overrides silence the bulk/confirmation prompts so it runs in one keypress.
exec task rc.bulk=0 rc.confirmation=off rc.dependency.confirmation=off \
  rc.recurrence.confirmation=off "$@" modify wait:tomorrow

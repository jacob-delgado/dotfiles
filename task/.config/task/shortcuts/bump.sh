#!/usr/bin/env bash
# taskwarrior-tui shortcut 3 — escalate the selected task(s): priority High + next.
# Invoked with the selected/marked task UUID(s) as positional args ($@).
exec task rc.bulk=0 rc.confirmation=off rc.dependency.confirmation=off \
  rc.recurrence.confirmation=off "$@" modify priority:H +next

#!/usr/bin/env bash
# taskwarrior-tui shortcut 2 — pull the selected task(s) into today (due:today).
# Invoked with the selected/marked task UUID(s) as positional args ($@).
exec task rc.bulk=0 rc.confirmation=off rc.dependency.confirmation=off \
  rc.recurrence.confirmation=off "$@" modify due:today

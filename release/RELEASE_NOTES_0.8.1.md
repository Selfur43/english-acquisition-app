# 0.8.1+51 Learning Insights Data Contract Repair

- Fixes the Gate 4 analyzer failure from 0.8.0.
- Extends MasteryRecord with the real SQLite `attempts` value.
- Maps `activity_mastery.attempts` into the domain model instead of hiding the field.
- Adds an in-memory SQLite regression test proving two recorded attempts are exposed as `attempts == 2`.
- Preserves the Learning insights dashboard, Recommended setup, AI English Reflex Coach Windows title, startup PIN, profile switching, local data isolation, backup, and rollback.

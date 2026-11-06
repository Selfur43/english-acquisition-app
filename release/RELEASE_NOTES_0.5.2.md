
# 0.5.2+26 V7 Validation Candidate

- Fixes the locked-log failure by separating the PowerShell transcript log from the native-tool output log.
- Adds learner-scoped schema audit.
- Adds byte-preserving database backup/restore service and test.
- Adds offline dependency and updater-gate static audit.
- Adds full source/build/user-data rollback.
- Adds seven explicit release gates and an eight-second application smoke launch.
- Remains `NEEDS_WINDOWS_EVIDENCE` until the target computer prints the exact success marker.

# Repository Inspection Rules

The actual source of truth is the Flutter project tree.

Inspect these locations:
- lib/
- test/
- tool/
- scripts/
- windows/
- pubspec.yaml
- pubspec.lock
- analysis_options.yaml

Never inspect, request, create, or edit:
- .flutter-plugins
- .flutter-plugins-dependencies
- .dart_tool/
- build/
- windows/flutter/ephemeral/
- english_acquisition_app_current_sources_utf8.txt
- log files
- backup files

If a generated file is absent:
1. Treat its absence as non-blocking.
2. Continue inspecting the real source files.
3. Use pubspec.yaml and pubspec.lock for dependency analysis.
4. Never return an empty result solely because a generated file is missing.

During a read-only audit:
- Do not modify files.
- Do not use Apply.
- Report every successfully inspected path.
- Report failed paths without stopping the remaining audit.

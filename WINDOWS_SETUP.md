# Windows Setup and Acceptance

## Required tools

- Flutter stable
- Git for Windows
- Visual Studio with Desktop development with C++

## Commands

Full setup and verification:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\bootstrap_verify_and_run_windows.ps1
```

Development run with the Flutter 3.47 Windows Impeller workaround:

```powershell
.\scripts\run_windows.ps1
```

Stable release run:

```powershell
.\scripts\run_windows_release.ps1
```

## Acceptance checklist

- invalid credentials are rejected
- `furkan` signs in
- `learner2` signs in
- the currently authenticated user is restored after restart
- sign-out clears the session
- release build remains open

The Android SDK and Chrome are not required for Windows-only Phase 1 verification.


# 0.7.0+40 Startup Lock and Profile Switching

Visible updates aligned with the supplied application screenshots:
- PIN entry is mandatory after every application process start
- saved session ID is cleared during initialization
- prominent Switch profile action in the Today app bar
- Lock now action in a new active-profile security banner
- profile, goals, and learning-session providers are invalidated before switching
- current learner data remains learner-scoped and local
- existing adaptive plan, goals, profile, mastery, and progress screens are preserved

Evidence additions:
- saved-session startup-lock regression test
- sign-out/profile-switch regression test
- source-level verification for visible controls and provider invalidation

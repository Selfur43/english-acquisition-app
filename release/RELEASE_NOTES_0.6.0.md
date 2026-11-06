# 0.6.0+30 Two-Profile PIN Security

Visible product improvement:
- profile selector for exactly USER_1 and USER_2
- first sign-in creates a separate six-digit PIN per profile
- iterated HMAC-SHA256 PIN hashing with individual random salts
- credential records stored through Windows secure storage
- five wrong attempts lock only the selected profile for five minutes
- attempts reset after a correct PIN
- password text and the shared `change-me-now` credential removed

Evidence additions:
- separate-credential test
- non-plaintext hash test
- invalid-format test
- per-profile lockout and timed-unlock test

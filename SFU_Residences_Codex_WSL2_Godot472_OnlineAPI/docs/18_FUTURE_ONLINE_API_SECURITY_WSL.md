# 18 — Future ONLY: secure online dialogue under Debian WSL2

This is a design sketch for **later phases**, not an authorization to implement today. User explicitly requested **online-only** model calls via their own OpenAI Platform API key. The current 3D exploration build launches with **no network, key, accounts or character code**.

## Online-only constraints
- No local GGUF/llama.cpp/Ollama, no model downloads, no VRAM reservation for local inference.
- Future fictional NPCs must be clearly established adult characters; avoid recreating identifiable actual students/residents. NPCs never need to enter buildings in current outdoor-only precinct.
- Settings someday: `AI Conversations` enabled opt-in, user-entered API key, masked form, Show/Hide action, Validate (explicit API call), model selector, per-session budget/usage info, Delete credential, Delete NPC dialogue histories, notice about transmitted dialogue and metered charges.
- ChatGPT subscription and OpenAI Platform API credentials/billing are separate. A ChatGPT username/password is never an API secret and must never be requested in-game.

## WSL2 trust boundary
- If future game runs on Debian WSL2, a **local-user-owned credential broker** could run in Debian and use Linux Secret Service *if genuinely available*; WSL Debian does not automatically have a desktop keyring/DBus Secret Service. Do not presume GNOME Keyring is installed.
- If Secret Service unavailable, the simplest safe development mode is **memory-only key during the current session**, no persistence. Do not silently write a key to `user://`, JSON, TOML, `.env`, CLI arguments, repo, debug output or logs.
- An optional future Windows-native broker can use Windows Credential Manager; bridging WSL2 -> host adds networking/permissions complexity, so write and review a threat model, loopback binding, random per-session handshake/authentication, CORS/origin restrictions and local-process attack risk before implementation. Never expose an unauthenticated HTTP proxy on `0.0.0.0` or Docker public ports.
- A *user-entered key* must not end up bundled in redistributed game files or embedded into executable assets. For wider distribution, use a user-authenticated backend and official API security guidance; BYOK remains user-controlled and user-billed.

## Transport and privacy
- Only official OpenAI HTTPS endpoints with full TLS verification. Keys only in authorization header set by trusted backend/broker. Never weaken TLS or log headers. Minimize NPC conversation payload and omit location telemetry, images/files and personally identifying details unless explicit consent.
- Rate limits: 401 invalid key, 403 missing access, 429 quota, 5xx transient, network errors, timeouts, cancellation, exponential backoff (bounded); do not retry non-idempotent operations blindly.
- Constrain requests/session, optional absolute token and per-session estimated cost caps, user-adjustable. Pricing, retention, model availability and policy can change; verify from official docs when implementation starts.
- Consent and user controls: default chat history transient, explicit opt-in for persistence, per-NPC data separation, delete all history and revoke API key instructions. Don't leak secrets through crash dumps, telemetry, Godot remote debugger, support logs or screenshots.
- The system should use `DialogueProvider` interface for mock and OpenAI adapter while game update/physics is decoupled; no API call on render thread. Test with mocked responses first in future session.

## Later acceptance
Test with dummy keys/mock server first, then user consent to a real billed API request. Tests: no key, key removed, key expired, wrong model ID, network down, 401/429/5xx, cancellation, multiple NPC context isolation, zero stored plaintext, credential mechanism absent, no untrusted bind interfaces. **Never include actual key in repo, prompt or test screenshots.**

Official guidance:
- https://platform.openai.com/api-keys
- https://platform.openai.com/docs/
- https://help.openai.com/en/articles/5112595-best-practices-for-api-key-safety
- https://help.openai.com/en/articles/9039756-managing-billing-for-chatgpt-and-the-api-platform

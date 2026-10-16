# 09 — FUTURE ONLY: adult fictional NPCs and online API conversations

**Not part of the current five-hour build. Do not implement NPCs, chat, API settings, API requests, or authentication now.** The current deliverable remains an exterior-only, playable SFU Residences reconstruction.

## Future vision
Fictional adult (21+) NPCs can roam outdoor routes, talk with the player and potentially participate in consensual romance/story systems. Do not imitate identifiable real residents or SFU students. **Online-only LLM conversations**, using an OpenAI API key entered by the player in future in-game Settings. No offline models, llama.cpp, bundled weights, or GPU inference. Rendering stays on the GTX 1650; remote inference runs through an API. The game must still launch and remain explorable without a key, with conversations disabled and clear status messaging.

## Important account distinction
A ChatGPT subscription/login is **not** an OpenAI API credential. The player needs a separately created OpenAI Platform API key and API billing; ChatGPT Plus/Pro does not automatically include API credits. Never ask for ChatGPT passwords, cookies, session tokens, or account login credentials. Use official API documentation and current supported models at implementation time; do not hardcode a model name or price as permanent.

## Future UI and architecture
- Settings > AI Conversations: provider = OpenAI API, masked API key entry, Show/Hide toggle, Save/Forget key, connection test, model selector or validated configurable model ID, optional budget/usage indicator and explicit notice of usage-based billing.
- `DialogueProvider` abstraction with async `OpenAIConversationProvider`, cancellable requests, streaming when supported, rate-limit and timeout handling, safe UI errors, retries with backoff, conversation context limits and per-NPC memory policies.
- No API calls on render/physics thread. Do not send player position, real-world personal information or arbitrary scene files to the API. Only the minimum opted-in fictional dialogue context. Explicit user choice for persistent chat history; support clearing stored histories.
- Keep NPC spawning and world geometry separate from the network provider; reserve outdoor navigation/spawn metadata only in the present session.

## API-key security — future implementation requirements
- Never commit keys, place them in scene files/resources, logs, crash dumps, telemetry, screenshots, test fixtures, command-line arguments, or build artifacts. `.env` files must be ignored; include placeholder examples only.
- Prefer a trusted **user-controlled local companion service** (loopback only) to hold credentials and call the OpenAI API, with secrets stored using the OS credential manager (Windows Credential Manager / macOS Keychain / Linux Secret Service). Godot should not persist raw secrets in `user://` config or export them in game data.
- The Settings UI can securely hand the key to that local service; avoid writing it to disk unencrypted. If a secure OS credential store cannot be used, offer session-only memory with explicit warning and no persistence rather than pretending plaintext is secure.
- HTTPS with certificate verification to the official API; never disable TLS verification. No untrusted proxy endpoints by default. Keep network destination allowlisted, enforce reasonable request size/timeouts, and redact authorization headers and conversation contents from logs.
- **Threat model:** on a user's own computer, a determined local administrator/malware can extract credentials; no client-only solution guarantees secrecy. If the game is distributed, a direct client-to-API key can be extracted from process memory. For a commercial/shared deployment, prefer a controlled server-side proxy with per-user authentication and rate/budget controls instead of embedding a developer key.
- API costs, limits, data retention and privacy depend on current OpenAI API terms and settings. Present clear disclosure that dialogue text is transmitted to an online service. Provide deletion and key-revocation instructions. Test missing/invalid/revoked keys, offline network, 401/429/5xx, cancellation and no secret leakage.

## Later milestones (not this session)
1. Outdoor adult NPC rigs, animation, pathing and interaction triggers with scripted placeholder text.
2. Per-NPC personalities, dialogue UI, state, bounded context and a mock provider.
3. Settings + OS credential integration + optional local companion service + OpenAI API adapter; opt-in online conversations and safe error handling.
4. Privacy, cost-control, consent, testing and performance; then deepen relationship and story mechanics.

## Current-session acceptance
No network API, keys, UI for chat, NPCs, dialogue, or offline inference should be built now. The environment must be standalone and playable. Only keep clean extension points and metadata.

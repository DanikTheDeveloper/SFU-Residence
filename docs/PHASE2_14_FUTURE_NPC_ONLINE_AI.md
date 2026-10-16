# 14 — Future online conversations only (DO NOT IMPLEMENT THIS SESSION)

Future world architecture may support fictional adult NPCs (21+), named outdoor spawn points, navigation, personality records and opt-in relationship dialogue; no real SFU student identities, photos or personality imitation. No actual NPCs, triggers, romances, conversation UI, API calls or keys in Phase 2.

Future LLM mode: **online OpenAI API only**, user enters an OpenAI Platform API key in Settings. ChatGPT paid subscriptions and OpenAI API billing are separate; do not ask for ChatGPT passwords or sessions. Option to run/explore the game without an API key must remain.

Security architecture later: provide a local user-controlled companion service with secure OS keychain/credential storage when possible, not plaintext `user://`, no hardcoded secrets in Godot/source/logs; HTTPS with validation; secrets redact from logs; explicit retention settings, conversation history deletion, minimal per-NPC context, per-request timeout and cost/budget warnings, no key in git. Warn users any key stored/used locally may be extracted by malware. Server-side proxy preferred for distributed/commercial releases; never embed developer API keys in client binaries.

The present Phase-2 task shall not use network API to generate buildings, and shall not instantiate or implement dialogue machinery. Only avoid tightly coupling path topology/building modeling to future NPC systems.

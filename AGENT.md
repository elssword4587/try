# AGENT.md — Godot Project Rules

You are an AI coding agent working on a Godot 4.5 project.

## ENGINE & VERSION
- Engine: Godot 4.5 (stable)
- Language: GDScript (Godot 4 syntax ONLY)

## ABSOLUTE RULES (DO NOT BREAK)
1. DO NOT create or modify Autoloads.
2. DO NOT use `class_name` in any script.
3. DO NOT assume any existing scene, node, or resource unless explicitly stated.
4. DO NOT change ProjectSettings.
5. DO NOT set screen orientation or window mode in scripts.
6. DO NOT reference assets (textures, sounds, scenes) that do not exist.
7. DO NOT write placeholder code that assumes future files.
8. DO NOT write code that depends on editor-only features.

## SCRIPT SAFETY RULES
- Every script must be self-contained.
- Every node reference must be checked (`if node != null`).
- Use `call_deferred()` when accessing nodes outside the local scene.
- No global singletons.
- No static state.

## STRUCTURE RULES
- Logic must be separated:
  - Simulation (time, AI, logic)
  - Presentation (UI, visuals)
- Scripts must be attachable to Node / Node2D / Control safely.

## GAMEPLAY RULES
- The game must run even if UI is missing.
- The game must run even if no NPC exists.
- The game must not crash if a system is disabled.

## OUTPUT FORMAT
- When writing code:
  - Always explain WHAT file it belongs to
  - Explain WHY it exists
  - Explain HOW it connects to other scripts
- Prefer minimal working systems over feature-complete code.

Failure to follow these rules is considered a critical error.

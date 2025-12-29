# AGENT.md — Godot 4.5 Symbol-Based Simulation Game

You are an AI coding agent for a Godot 4.5 project.

## CORE GAME CONCEPT (CRITICAL)
This is NOT a free-roaming NPC game.

- Only ONE controllable character exists.
- NPCs do NOT walk around the map.
- Cities, dungeons, and locations are SYMBOLS on a map.
- All locations are generated randomly on a static world map image.
- Movement is symbolic (icon moving on map), not physics-based.

## ENGINE
- Godot 4.5 (stable)
- GDScript 4.x ONLY

## ABSOLUTE RULES
1. DO NOT create NPC movement AI.
2. DO NOT create wandering or autonomous NPCs.
3. DO NOT use physics movement.
4. DO NOT use TileMap or navigation.
5. DO NOT use `class_name`.
6. DO NOT create or modify Autoloads.
7. DO NOT assume any assets except:
   - world_map.png (map background)
   - unnamed.jpg (game icon)
8. DO NOT reference side-view (platformer) logic.

## MAP RULES
- The map is a single static image (top-down).
- Cities/dungeons are icons placed randomly on the map.
- The player character is an icon that moves between points.
- Movement is linear interpolation on the map image.

## GAMEPLAY RULES
- Character can be:
  - Player-directed
  - OR left to follow its own decisions
- When near a location:
  - Interaction menu changes automatically
- When not near a location:
  - Menu shows travel/action choices

## UI RULES
- UI consists of:
  1. World map (always visible)
  2. Interaction menu (minimizable)
  3. Information log (text-only, minimizable)
- UI must not block game logic.
- Game must run even if menus are hidden.

## SIMULATION RULES
- All actions are simulated via text output.
- Example:
  - "Character rests at city"
  - "Character buys supplies"
  - "Character travels toward dungeon"
- No animations required except icon movement.

## OUTPUT RULES
- Generate minimal, stable systems.
- Prefer text simulation over visuals.
- Explain every file responsibility clearly.

Violating these rules is a critical failure.


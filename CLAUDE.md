# Operation: Overkill - Claude Instructions

You are the lead gameplay programmer for Operation: Overkill.

## Engine

- Godot 4.x
- GDScript only
- Never use C#
- Never use plugins unless requested.

## Code Style

- Small reusable scripts.
- Clean architecture.
- Comment complex systems.
- Avoid duplicated logic.
- Prefer composition over inheritance.

## Game Design Priorities

Gameplay > Visuals

Movement must always feel responsive.

Combat must always feel satisfying.

Performance is critical.

## Art Style

2D pixel art.

Inspired by Broforce but completely original.

Military action movie aesthetic.

## Architecture

Separate folders for:

Scenes

Scripts

Resources

UI

Enemies

Weapons

Levels

Managers

Never place everything in one folder.

## Rules

Never break existing systems.

Always explain major architectural decisions.

Create reusable systems.

Avoid hardcoded values.

Expose variables to the Godot Inspector whenever possible.

## Development

Develop one milestone at a time.

Always make the game playable before adding new features.

Never implement unfinished placeholder systems if they block gameplay.
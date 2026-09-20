Tatical Turn base resource management dungeon crawler shooter game
# General doc
1) Overview
   - One-sentence pitch: create a team of 4 asteroid miners and complete objectives against waves of monsters. 
   - Target audience: tatical turn base tactics enjoyed that are too overwhelmed by games like battlements and enjoy a more streamline game, xcom  remake level depth
   - Platforms: oc
   - Player fantasy: Make tatical risk reward decisions that determine the success of each mission and the extended run. 
   - Design pillars (3–5): 1. Make synergies enjoyable and discoverable between playable characters, make success rewarding when you beat the odds, find a balance between rng and skill, 
   - Non-goals:

2) Core gameplay
   - Core loop: explore -> fight -> mine -> resupply/upgrade -> escape -> repeat 
   - Controls summary: point and click for turn base actions, wasd to rotate and move camera, qe to rotate camera, zx to change characters, maybe some short cuts to shoot ?
   - Win/lose conditions: win - complete all objectives on the level, escape with at least one of the 4 playable characters
   - Game modes: story - hand crafted maps where you progress through all possible maps and environments and objectives. Functionally it is like the tutorial to the rouge lite mode
   - rouge lite - presedually generated Levels with progressive difficulty. The idea is it is like a campaign with things that carry over each mission. You can spend gold on permanent upgrades for the mission.
   - challenge - maybe the same as the story but forces specific challenges to the mission, like a extra global effect or character specific requirements. 

3) Systems (rules)
Focuses on action points which are spent to do actions
   - Movement: move a specific number of tiles for 1 action
   - Combat: mainly by shooting or hitting enemies, shooting costs an amo but hitting is always free. 
   - Progression: mine resources for resupply or save for score and currency to spend after a mission. Score is used to give xp and to obtain unlocks over time. Mining walls can reveal secret locations with upgrades inside
   - Economy: see above
   - AI: simple ai that always rushes the enemy
   - Difficulty and balancing notes: difficulty should heat up over time with more waves and stronger enemies. 

4) Content
   - Levels / maps: hex based maps kinda looking like gloomhaven in principle. Levels contain caves that players will need to explore and explore adjacent tunnels to complete objectives
   - Characters / classes: heavy gunner, demolitions, engineer, driller, scout, ranger, survivalist, 
   Each class needs 2 weapons, a support skill and a way to navigate traps/pits. 
   - Enemies: see enemies of drg and role of them
   - Items: expendables like healing items, grenades, upgrades and miracle resources
   - Narrative beats:

5) UX and UI
   - Player journey (flow):
   - HUD requirements:
   - Menus:
   - Accessibility:

6) Production
   - Milestones:
   - Risks and unknowns:
   - Dependencies:

7) Marketing and monetization
   - Positioning:
   - Competitors:
   - Pricing / business model:

## ALPHA
I think a good alpha will be to use a simple grid map and make a single enemy and PC. Try to implement a shoot action.

# gemini help
That is a fantastic project concept. Translating a physical board game's mechanics into a digital turn-based video game is an excellent way to scope your first project in Godot. Board games already have rigid, well-defined rules, which makes translating them into code much easier.
To make a turn-based resource management horde shooter in Godot 4, you will want to build your architecture around three core pillars.
------------------------------
## 1. The Grid & Movement System (Tactical Layout)
To handle the tactical positioning of both your dwarves and the horde, you need a solid foundation for the map.

* Use TileMapLayer (Godot 4): Break your cave down into grid coordinates. This makes calculating weapon ranges, splash damage, and line-of-sight incredibly straightforward.
* A Grid Pathfinding (AStarGrid2D):* Godot has a built-in 2D A* pathfinding class. You can instantly generate paths for your horde, telling them to bypass walls but move toward the closest player. It handles hundreds of enemies efficiently.

## 2. The Horde Engine (Turn Management)
In a real-time game, enemies move constantly. In a turn-based board game style, you need a strict Turn State Machine.

* Player Phase: Players get a set number of Action Points (AP) to move, mine, or shoot.
* The Event/Spawn Phase: After players use their AP, draw from a digital "Event Deck." This increments a "Threat Meter" and spawns batches of enemies at designated spawn holes on the edges of the TileMap.
* Horde Phase: To prevent the game from freezing while 50 bugs take individual turns, animate them simultaneously. Group enemy movements into a single phase where they all shift one tile closer to the players at the same time, attacking if they touch a player's tile.

## 3. Resource & Inventory Systems
Because resource scarcity drives the tension, make your data structures robust.

* Custom Resources (Resource class): Godot allows you to create custom data objects. Create an ItemResource or WeaponResource that holds variables like max_ammo, current_ammo, damage, and aoe_radius.
* The Shared Supply Pool: If you want a co-op vibe, give the team a shared UI element tracking "Nitra" or "Supplies." Spending actions to mine ore updates a global Singleton autoload script (e.g., GlobalInventory.gd), which players can access to call in ammo drops.

------------------------------
## Recommended Godot Project Structure

📦 project_root
 ┣ 📂 Systems/
 ┣ ┃ ┣ 📜 TurnManager.gd      # Handles Player Phase vs. Bug Phase
 ┣ ┃ ┗ 📜 EnemySpawner.gd     # Reads "Swarm Cards" and places bugs
 ┣ 📂 Entities/
 ┣ ┃ ┣ 📂 Player/
 ┣ ┃ ┃ ┗ 📜 Player.gd         # AP tracking, health, mining actions
 ┣ ┃ ┗ 📂 Enemies/
 ┣ ┃ ┃ ┗ 📜 Glyphid.gd        # Basic AI, uses AStarGrid2D to track players
 ┣ 📂 Resources/
 ┣ ┃ ┣ 📜 WeaponData.gd       # Custom resource script for gun stats
 ┣ ┃ ┗ 🗃️ Minigun.tres        # Instance of WeaponData with custom stats
 ┗ 📜 MainLevel.tscn          # Holds the TileMapLayer and UI

## A Great Starting Point
Start small. Do not try to build classes, destructible terrain, and 10 enemy types on day one.
Your Minimum Viable Product (MVP) should just be:

   1. One player icon on a gray tile grid that can move 3 spaces per turn.
   2. A button to "End Turn".
   3. Ending the turn spawns 3 red bug icons that walk 1 tile closer to you.
   4. If you press a key, you shoot the closest bug.

Would you like to start by looking at how to write the Turn Manager script to cycle between the player and the enemies, or would you prefer a breakdown of how to set up Godot's A pathfinding* for a turn-based grid?



Yes, writing functions that take abstract inputs is good practice in Godot too. Your Python instincts transfer well: a function like `find_path(from_cell, to_cell)` that doesn't care who is calling is exactly what you want. The part that's different is that Godot adds a tree of nodes, and the question becomes which node owns which function.

## The core rule: a script owns the things its node is responsible for

Ask of each function: **"whose data does this read or change?"** Put it on the node that owns that data.

- Changes a unit's own health, AP, position or animation → on the **unit**.
- Needs to know about the map (walkable, neighbours, paths, occupancy) → on **GridManager**.
- Needs to know whose turn it is or what phase we're in → on **TurnManager**.
- Coordinates several of those → on a **parent or manager**, which calls the others.

This is the same idea as Python classes: each one has one job and its own state.

## Which direction should calls go?

Godot has a well-known mantra: **"call down, signal up."**

- **Call down.** A parent can call functions on its children directly, because it knows they exist: `player_team.selected_unit.move_along(path)`.
- **Signal up.** A child shouldn't reach up and call its parent's functions or assume what's above it. Instead it emits a signal (`unit_died`, `cell_clicked`), and whoever cares connects to it.

This is what makes your "self-contained scenes" goal work. A unit scene that only emits signals and exposes a few functions can be dropped into any level and even tested by itself (F6 runs the current scene alone).

For siblings that need to talk, like `GridManager` and `TurnManager` under `Manager`, the usual options are:

- A parent (`MainGame` or `LevelManager`) wires them together in `_ready()`: `grid.cell_clicked.connect(turn_manager.on_cell_clicked)`.
- Or, for things truly global, an **autoload** singleton (Project Settings > Globals). It's convenient but overusing it is the equivalent of Python global variables. It's fine for an event bus or shared constants.

## A practical checklist for placing a function

1. **Can it be a pure function?** Takes inputs, returns outputs, touches no node state (like your `get_hex_distance`). Put it in a utility script or in whichever manager is closest, and call it from anywhere. These are the easiest to reuse and test.
2. **Does it act on one unit?** Put it on the unit script. Don't put it in `PlayerTeam` just because that's the parent.
3. **Does it act on many units, or need to choose between them?** That's parent or manager work (`PlayerTeam` selecting the active character, `TurnManager` looping through enemies).
4. **Does it need to know about a sibling's internals?** Reconsider. Pass the data in as an argument, or emit a signal, rather than reaching sideways.

## Two Godot-specific tips

- **Avoid long `get_node("../../Manager/GridManager")` paths.** They break when you rearrange the tree, which will happen a lot. Prefer signals, or `@export var grid: GridManager` so you drag the reference into place in the Inspector.
- **Use `class_name`** on scripts (`class_name Unit`) so you can type function arguments: `func move_along(path: Array[Vector2i]) -> void`. That gives you Python-with-type-hints-style clarity, plus autocomplete.

## Applied to your move example

Your instinct of a unit that waits for a click and then moves splits nicely under these rules:

- The **input** (click to cell) is detected once, by the level or `GridManager`, which emits `cell_clicked(cell)`.
- A **manager** (`TurnManager` or `PlayerTeam`) decides what that click means right now: are we in the player phase, which unit is selected, does it have AP?
- `GridManager.find_path(...)` answers the map question.
- `unit.move_along(path)` does the unit's own work.

Nothing in that chain has to know the full tree, and every piece is testable on its own. If you're unsure early on, don't agonize: put the function where it feels right, and if it starts needing lots of data from elsewhere, that's the signal to move it. Refactoring in Godot is cheap.

If it would help, send me your `TurnManager` and `player_team` scripts when you start them and I can suggest where each function should sit.

No, it isn't importing anything. It's the same dot notation you use in Python, reading left to right as "get this object, then call a function on it."

```gdscript
player_team.selected_unit.move_along(path)
```

- `player_team` is a variable holding a reference to the `PlayerTeam` node (an object).
- `.selected_unit` is a variable _inside_ that node's script, holding whichever character is currently selected (for example `CharacterB`).
- `.move_along(path)` calls the function `move_along`, which is defined in that unit's own script, and passes it `path` as the argument.

The Python equivalent is almost identical:

```python
player_team.selected_unit.move_along(path)
```

Here `player_team` is an instance of a class, `selected_unit` is an attribute holding another instance, and `move_along` is a method on it. Nodes with scripts are just objects.

## Where the pieces come from

For that line to work, each part has to exist somewhere:

```gdscript
# player_team.gd  (attached to the PlayerTeam node)
extends Node
class_name PlayerTeam

var selected_unit: Unit   # set when the player switches characters with z/x
```

```gdscript
# unit.gd  (attached to CharacterB, grunt, etc.)
extends Node2D
class_name Unit

func move_along(path: Array[Vector2i]) -> void:
	for cell in path:
		# move one cell at a time
		pass
```

The unit's script defines `move_along`, and `PlayerTeam` just holds a reference to a unit and calls it. Nothing gets copied or imported, and the function still runs inside that unit's script using that unit's own data.

## How the calling script gets `player_team`

There is no `import` step for nodes. The script that wants to make the call needs a reference to the node, and there are three common ways to get one:

1. **`@export var player_team: PlayerTeam`** puts a slot in the Inspector, and you drag the node into it. This is the most robust option and survives rearranging the tree.
2. **`@onready var player_team = $PlayerTeam`** finds it by path, and works when it's a child of the script's own node.
3. **A parent passes it in** through a function argument or connects things up in `_ready()`.

You only need `class_name` (as in `class_name Unit`) so that Godot knows the type for autocomplete and type hints. It's closer to Python's type annotation than to an import. If a script has a `class_name`, you can use that name anywhere in the project without importing it. Without one, you'd load the script explicitly with `preload("res://unit.gd")`, which is the closest thing to a Python `import`.

Also, `selected_unit` will be `null` until you set it, and calling a function on `null` gives an error. Setting it in `PlayerTeam._ready()` (for example to the first child) avoids that while you're getting started.
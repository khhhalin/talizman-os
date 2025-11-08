# Developer Notes

Refactor summary:

- `BoardDataLoader.gd` is an autoload coordinator: it parses JSON, applies shape/layout, expands regions, validates maps, and delegates board construction.
- `regions.gd` contains region parsing logic.
- `validator.gd` validates maps; use `MapValidator.validate(map)`.
- `BoardBuilder.gd` performs scene instantiation and neighbor wiring.
- `tile.gd` is now a small, self-drawing Tile node exposing `apply_properties(props)` and `set_grid(...)`.

Editor plugin:

- Install/enable the addon in the Project > Project Settings > Plugins panel (look for "Board Tools").
- When enabled, selecting a Board node shows a "Rebuild from Map" button and a "Visualize Edges" checkbox in the inspector.

Running tests locally in the editor:

- Open `tests/test_validator.gd` or `tests/test_board_builder.gd` in a scene, run the scene, and check the Output.

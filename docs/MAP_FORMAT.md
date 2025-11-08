# Map JSON Format

This project supports data-driven maps defined by JSON files located under `res://config/`.

Top-level structure (recommended):

{
  "nodes": [ {"id": "A", "x": 0, "y": 0, "tile": "rest" }, ... ],
  "edges": [ {"from": "A", "to": "B", "directed": false}, ... ],
  "regions": { ... }  # optional region shorthand supported
}

Region formats are flexible and support multiple human-friendly notations. See `game/board/regions.gd` for the exact rules.

You can also provide a separate shape/layout JSON with rows to assign coordinates:

{
  "rows": [ ["A","B"], ["C","D"] ]
}

Color maps are simple mappings from tile type to hex color, e.g. `{"rest":"#aaaaaa", "start":"#00ff00"}`.

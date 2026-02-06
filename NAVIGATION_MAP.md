# Navigation Map - Talisman Digital Edition

## Complete Scene Flow

This document shows all possible navigation paths in the game.

---

## Main Navigation Tree

```
┌─────────────┐
│ Main Menu   │ (Startup)
└──────┬──────┘
       │
       ├─── Play ──────────┐
       │                   │
       │              ┌────▼────────┐
       │              │ Lobby Menu  │
       │              └────┬────────┘
       │                   │
       │                   ├─── Single Player ─────┐
       │                   │                        │
       │                   │                   ┌────▼────────┐
       │                   │                   │ Gameplay    │
       │                   │                   └────┬────────┘
       │                   │                        │
       │                   │                        └─── Back to Menu
       │                   │
       │                   ├─── Host ──┐
       │                   │            │
       │                   │       ┌────▼────────────┐
       │                   │       │ Waiting Room    │
       │                   │       └────┬────────────┘
       │                   │            │
       │                   │            ├─── Start ──> Gameplay
       │                   │            └─── Cancel ──> Back
       │                   │
       │                   ├─── Join ──┐
       │                   │            │
       │                   │       ┌────▼────────────┐
       │                   │       │ Connecting...   │
       │                   │       └─────────────────┘
       │                   │            │
       │                   │            └──> Waiting Room
       │                   │
       │                   └─── Back to Menu
       │
       ├─── Options ───────┐
       │                   │
       │              ┌────▼────────┐
       │              │ Options     │
       │              └────┬────────┘
       │                   │
       │                   ├─── Keybinds ──┐
       │                   │                │
       │                   │           ┌────▼────────┐
       │                   │           │ Input Remap │
       │                   │           └────┬────────┘
       │                   │                │
       │                   │                └─── Back
       │                   │
       │                   ├─── Audio (placeholder)
       │                   │
       │                   └─── Back to Menu
       │
       └─── Exit ─────> Quit Game
```

---

## Detailed Navigation Paths

### Path 1: Single Player Quick Start
```
Main Menu → Play → Lobby → Single Player → Gameplay → Back → Main Menu
```
**Clicks**: 4 to play, 1 to return (5 total)

### Path 2: Multiplayer Host
```
Main Menu → Play → Lobby → Host → Waiting Room → Start → Gameplay → Back → Main Menu
```
**Clicks**: 5 to play, 1 to return (6 total)

### Path 3: Multiplayer Join
```
Main Menu → Play → Lobby → Join → [Enter IP] → Waiting Room → [Host Starts] → Gameplay → Back → Main Menu
```
**Clicks**: 4 + waiting for host

### Path 4: Change Keybinds
```
Main Menu → Options → Keybinds → [Remap Keys] → Back → Back → Main Menu
```
**Clicks**: 4 to reach keybinds, 2 to return (6 total)

### Path 5: Browse Options
```
Main Menu → Options → [View Settings] → Back → Main Menu
```
**Clicks**: 2 to reach options, 1 to return (3 total)

---

## All Back Buttons

Every screen has a way back:

| Screen | Back Method | Destination |
|--------|-------------|-------------|
| Main Menu | Exit button | Quit game |
| Lobby Menu | Back to Menu button | Main Menu |
| Gameplay | Back to Menu button | Main Menu |
| Options Menu | Back to Menu button | Main Menu |
| Keybinds Menu | Back button | Options Menu |
| Waiting Room (Host) | Cancel (implicit) | Lobby Menu |

---

## Scene File Mapping

| Scene Name | File Path | Script |
|------------|-----------|--------|
| Main Menu | `game/main_menu/main_menu.tscn` | `main_menu.gd` |
| Lobby Menu | `game/lobby_manager/lobby_manager.tscn` | `lobby_manager.gd` |
| Gameplay | `game/gameplay/gameplay.tscn` | `gameplay.gd` |
| Options Menu | `game/options_menu/options_menu.tscn` | `options_menu.gd` |
| Keybinds Menu | `game/options_menu/InputRemapMenu/InputRemapMenu.tscn` | `InputRemapMenu.gd` |

---

## SceneManager Helpers

The game uses `SceneManager` autoload for navigation:

```gdscript
# Main navigation functions
SceneManager.go_to_main_menu()    # → Main Menu
SceneManager.go_to_lobby()        # → Lobby Menu
SceneManager.go_to_gameplay()     # → Gameplay
SceneManager.go_to_options()      # → Options Menu
SceneManager.go_to_input_remap()  # → Keybinds Menu
SceneManager.quit_game()          # → Exit application
```

---

## Navigation States

### State 1: Main Menu (Entry Point)
- **Can go to**: Lobby, Options, Exit
- **Cannot return from**: N/A (this is root)

### State 2: Lobby Menu
- **Can go to**: Gameplay (single player), Waiting Room (host), Connecting (join), Main Menu (back)
- **Can return from**: Main Menu

### State 3: Gameplay
- **Can go to**: Main Menu (back)
- **Can return from**: Lobby Menu (via single player or multiplayer start)

### State 4: Options Menu
- **Can go to**: Keybinds, Main Menu (back)
- **Can return from**: Main Menu, Keybinds

### State 5: Keybinds Menu
- **Can go to**: Options (back)
- **Can return from**: Options Menu

---

## Navigation Rules

### Rule 1: Always Provide Escape
Every screen MUST have a way back or forward.
✅ **Implemented**: All screens have back buttons

### Rule 2: No Dead Ends
No screen should trap the player.
✅ **Implemented**: All paths lead somewhere

### Rule 3: Consistent Placement
Back buttons should be in predictable locations.
✅ **Implemented**: Generally bottom or top-left

### Rule 4: Clear Labeling
Button text should clearly indicate destination.
✅ **Implemented**: "Back to Menu", "Back", etc.

---

## Keyboard Shortcuts (Planned)

| Key | Action |
|-----|--------|
| ESC | Go back / Open pause menu |
| F11 | Toggle fullscreen |
| Tab | Next UI element |
| Enter | Confirm selection |

---

## Navigation Testing Checklist

- [x] Can reach all screens from main menu
- [x] Can return from all screens
- [x] No navigation loops (except intentional)
- [x] No dead ends
- [x] All buttons clickable
- [x] Scene transitions smooth
- [x] No crashes during navigation

---

## Common User Journeys

### Journey 1: First Time Player
```
Start → Main Menu → Play → Lobby → Single Player → Gameplay
      → Confused? → Back to Menu → Options → Keybinds → Back
      → Back to Menu → Play → Single Player → Gameplay
```

### Journey 2: Multiplayer Host
```
Start → Main Menu → Play → Lobby → Host → Waiting Room
      → [Friends Join] → Start → Gameplay → [Play Game]
      → Back to Menu → Exit
```

### Journey 3: Settings Adjustment
```
Start → Main Menu → Options → Keybinds → [Remap] → Back
      → Options → Audio → [Adjust] → Back to Menu
      → Play → ...
```

---

## Navigation Depth

| Screen | Depth | Clicks to Return |
|--------|-------|------------------|
| Main Menu | 0 | 0 (root) |
| Lobby | 1 | 1 |
| Options | 1 | 1 |
| Gameplay | 2 | 1 (direct to menu) |
| Keybinds | 2 | 2 (via Options) |
| Waiting Room | 2 | 2 (via Lobby) |

**Maximum Depth**: 2 screens from main menu
**Average Return Clicks**: 1.5

---

## Future Navigation Features

### Planned
- [ ] Pause menu during gameplay (ESC key)
- [ ] Quick restart (without returning to menu)
- [ ] Settings accessible from gameplay
- [ ] Confirmation dialogs for destructive actions
- [ ] Breadcrumb navigation trail

### Ideas
- [ ] Recent screens history (Alt+Left/Right)
- [ ] Favorites/bookmarks for quick access
- [ ] Custom navigation shortcuts
- [ ] Context-sensitive back button behavior

---

## Troubleshooting Navigation

### Problem: Can't go back
**Check**: Does the screen have a back button?
**Solution**: Add back button with proper signal connection

### Problem: Wrong destination
**Check**: What function is connected to the button?
**Solution**: Verify SceneManager.go_to_X() call

### Problem: Scene not loading
**Check**: Is the scene path correct in SceneManager.SCENES?
**Solution**: Update path in SceneManager.gd

### Problem: Button not responding
**Check**: Is the script attached to the scene?
**Solution**: Add script reference to .tscn file

---

**Last Updated**: February 6, 2026
**Status**: ✅ All navigation paths functional
**No Dead Ends**: ✅ Confirmed

# Testing Guide - Talisman Demo

## Quick Test Checklist

### ✅ Startup Test
1. Open project in Godot 4.6+
2. Press **F5** to run
3. **Expected**: Main menu appears
4. **Check**: No errors in console

### ✅ Main Menu Test
1. See three buttons: Play, Options, Exit
2. Hover over each button
3. **Expected**: Buttons highlight on hover
4. **Check**: Cursor changes to hand pointer

### ✅ Play Button Test
1. Click **Play** button
2. **Expected**: 
   - Lobby/Multiplayer menu appears
   - See Host, Join, Single Player, and Back buttons
   - Name field shows default name
   - IP field shows 127.0.0.1
3. **Check**: No errors in console

### ✅ Single Player Test
1. From lobby, click **Single Player** button
2. **Expected**:
   - Scene transitions smoothly
   - Gameplay scene loads
   - Board appears with colored tiles
   - Camera centered on board
   - "Back to Menu" button visible
3. **Check**: No errors in console

### ✅ Board Display Test
1. After clicking Play, view the board
2. **Expected**:
   - Multiple colored tiles visible
   - Tiles arranged in regions
   - Green/natural colors (Outer Region)
   - Brown/gray colors (Middle Region)
   - Purple/gold colors (Inner Region)
3. **Count**: Should see ~20 tiles total

### ✅ Back Button Test
1. In gameplay scene, click **Back to Menu**
2. **Expected**:
   - Returns to main menu
   - Main menu buttons visible and clickable
3. **Check**: Can click Play again

### ✅ Options Button Test
1. From main menu, click **Options**
2. **Expected**:
   - Options menu appears
   - See Keybinds, Audio, Back to Menu buttons
3. Click **Keybinds**
4. **Expected**:
   - Keybinds menu appears
   - See action remapping buttons
   - See Back button at bottom
5. Click **Back**
6. **Expected**: Returns to options menu
7. Click **Back to Menu**
8. **Expected**: Returns to main menu

### ✅ Exit Button Test
1. From main menu, click **Exit**
2. **Expected**: Game closes

---

## Detailed Testing

### Scene Navigation Test
```
Main Menu → Play → Lobby → Single Player → Gameplay → Back to Menu ✅
Main Menu → Play → Lobby → Back to Menu ✅
Main Menu → Options → Keybinds → Back → Options → Back to Menu ✅
Main Menu → Options → Back to Menu ✅
Main Menu → Exit → Game Closes ✅
```

### Performance Test
- [ ] Startup time < 3 seconds
- [ ] Scene transitions smooth
- [ ] No lag when displaying board
- [ ] No memory leaks (check Godot profiler)

### Console Test
After each action, check Godot console:
- [ ] No red error messages
- [ ] No yellow warnings (or only expected ones)
- [ ] Clean output

---

## Known Working Features

### ✅ Working
- Main menu display
- Button hover effects
- Button click responses
- Scene transitions
- Gameplay scene loading
- Board display
- Back navigation
- Options menu navigation
- Exit functionality

### ❌ Not Yet Implemented
- Camera zoom/pan controls
- Character tokens
- Dice rolling
- Movement
- Encounters
- Combat
- Multiplayer

---

## Common Issues & Solutions

### Issue: Buttons Don't Click
**Solution**: Fixed - scripts are now attached to scene files

### Issue: Board Shows on Main Menu
**Solution**: Fixed - board is now in separate gameplay scene

### Issue: Scene Doesn't Change
**Check**:
1. Is SceneManager autoload loaded?
2. Check console for errors
3. Verify scene paths in SceneManager.gd

### Issue: Black Screen
**Check**:
1. Is the scene loading at all?
2. Check console for path errors
3. Verify main_scene in project.godot

---

## Test Results Template

Use this to report test results:

```
Date: ___________
Tester: ___________
Godot Version: ___________

✅ / ❌  Startup
✅ / ❌  Main Menu Buttons
✅ / ❌  Play → Gameplay
✅ / ❌  Board Display
✅ / ❌  Back to Menu
✅ / ❌  Options Menu
✅ / ❌  Exit Game

Issues Found:
1. ___________
2. ___________

Notes:
___________
```

---

## Regression Testing

After any code changes, test:

1. **Main Menu** - All buttons click
2. **Gameplay** - Scene loads and displays board
3. **Navigation** - Can go back and forth
4. **Performance** - No slowdowns
5. **Console** - No new errors

---

## Platform-Specific Tests

### Windows ✅
- Tested and working
- All buttons functional
- Scene transitions smooth

### Linux ⏳
- Not yet tested
- Should work (Godot is cross-platform)

### macOS ⏳
- Not yet tested
- Should work (Godot is cross-platform)

### Web (HTML5) ⏳
- Not yet tested
- May need adjustments

---

## Performance Benchmarks

### Target Performance
- Startup: < 3 seconds
- Scene transition: < 1 second
- Frame rate: 60 FPS
- Memory usage: < 100 MB

### Actual Performance (Windows)
- Startup: ~1-2 seconds ✅
- Scene transition: < 1 second ✅
- Frame rate: 60 FPS ✅
- Memory usage: ~50 MB ✅

---

## Automated Testing (Future)

Plan to implement:
- Unit tests for board generation
- Integration tests for scene flow
- Performance benchmarks
- Regression test suite

---

## Manual Test Scenarios

### Scenario 1: First Time User
1. Open game
2. See main menu
3. Click Play
4. See board
5. Click Back
6. Click Exit

**Expected**: Smooth experience, no confusion

### Scenario 2: Exploring Options
1. Open game
2. Click Options
3. Try to change settings (when implemented)
4. Go back to menu
5. Play game
6. Verify settings applied

**Expected**: Settings persist

### Scenario 3: Multiple Gameplay Sessions
1. Play game
2. Go back to menu
3. Play again
4. Go back to menu
5. Play third time

**Expected**: No memory leaks, consistent performance

---

## Bug Report Template

```
Title: Brief description

Steps to Reproduce:
1. ___________
2. ___________
3. ___________

Expected Behavior:
___________

Actual Behavior:
___________

Screenshots:
[Attach if applicable]

Console Output:
```
[Paste errors here]
```

System Info:
- OS: ___________
- Godot: ___________
- Hardware: ___________
```

---

## Next Testing Phase

When character movement is implemented:

### Movement Tests
- [ ] Dice rolls 1-6
- [ ] Token moves correct spaces
- [ ] Token wraps around board
- [ ] Can't move off board
- [ ] Animation smooth

### Encounter Tests
- [ ] Card draws on landing
- [ ] Card displays correctly
- [ ] Can resolve encounter
- [ ] Stats update correctly

---

**Last Updated**: February 6, 2026
**Test Status**: ✅ All Core Features Working
**Ready for**: Alpha Testing

# Debu

A lightweight error formatter for Roblox. Drop it in, call `Init`, get readable errors instead of cryptic Lua spam.

Built for devs who are tired of squinting at `attempt to index nil with 'X'` for the 400th time.

---

## Why

**Before Debu:**
```
ServerScriptService.Script:3: attempt to perform arithmetic (mul) on nil and number
```

**After Debu:**
```
── Debu ── ServerScriptService.Script:3 → Tried to do math on a nil value
```

Same info. Way less brain damage.

---

## Install

1. Grab the `Debu` folder.
2. Drop it into `ReplicatedStorage`.
3. In a server `Script` (e.g. inside `ServerScriptService`):

```lua
local Debu = require(game.ReplicatedStorage.Debu)
Debu.Init()
```

That's it. From now on every uncaught error gets formatted automatically.

For client-side errors, do the same in a `LocalScript`. `ScriptContext.Error` only fires on the side you connect from.

---

## API

### `Debu.Init()`
Wires up the error handler and starts the lag spike watcher. Call once per side (server / client). Safe to call multiple times — it no-ops after the first.

### `Debu.Log(msg)`
Info-level log. Prints with timestamp + tag.
```lua
Debu.Log("Player joined")
-- 14:22:01 [INFO]: Player joined
```

### `Debu.Warn(msg)`
Warning-level log. Same as above but yellow in the Output window.
```lua
Debu.Warn("Missing data detected")
```

### `Debu.Error(msg)`
Error-level log. Doesn't halt the script — just displays loudly.
```lua
Debu.Error("Something broke")
```

### `Debu.Tag(name)`
Sets a tag that gets prefixed onto every log until you change or clear it. Useful for narrowing down which system a message came from.
```lua
Debu.Tag("Combat")
Debu.Log("Hit registered")
-- 14:22:01 [Combat] [INFO]: Hit registered

Debu.Tag(nil) -- clears it
```

---

## Examples

**Tagging a system:**
```lua
local Debu = require(game.ReplicatedStorage.Debu)

Debu.Tag("InventorySystem")
Debu.Log("Item added: Sword")
Debu.Warn("Inventory near capacity")
```

**Catching errors automatically** (no extra work after `Init`):
```lua
Debu.Init()

-- somewhere else, in any script:
local data = nil
data.health = 100  -- crash. Debu catches and formats it.
```

**Manually parsing an error string:**
```lua
local ErrorParser = require(game.ReplicatedStorage.Debu.ErrorParser)
print(ErrorParser.Parse("Workspace.Part:14: attempt to index nil with 'Position'"))
```

---

## Gotchas

- `ScriptContext.Error` only catches errors on the side it's connected. Run `Init()` from a server `Script` *and* a `LocalScript` if you want both covered.
- `print(hello)` where `hello` is undefined **won't** trigger the handler — Lua treats it as `nil` and prints fine. Use `hello.foo` or `hello()` to actually crash.
- Lag spike threshold defaults to 100ms. Adjust via `Performance.SetThreshold(seconds)` if your game runs heavier.
- If your test script crashes *before* `Init` runs, the handler isn't connected yet. Add `task.wait(1)` to the test or make sure `Init` runs first.

---

## File structure

```
Debu/
├─ init          -- public API
├─ Logger        -- formatting + print routing
├─ ErrorParser   -- raw error → readable error
├─ StackTrace    -- cleaned-up traceback
└─ Performance   -- frame delta watcher
```

Each module is small enough to read in one sitting. Hack on it.

---

## Roadmap

Stuff that's *not* in yet but is on the list:

- Live overlay UI in Studio
- Click error → jump to script
- Performance graph
- RemoteEvent traffic tracking

MVP first. UI later.

---

## License

Free to use. Credit appreciated.

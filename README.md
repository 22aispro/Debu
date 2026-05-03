# Debu

Lightweight error formatter and runtime diagnostics module for Roblox.

Debu intercepts uncaught errors via `ScriptContext.Error`, parses them into a structured format, and reports them through a unified logger. It also includes frame-delta monitoring for detecting lag spikes.

---

## Features

- Automatic interception and formatting of uncaught runtime errors
- Pattern-based translation of common Lua error messages into readable explanations
- Tagged logging for system-level context
- Heartbeat-based lag spike detection with configurable threshold
- No external dependencies

---

## Installation

1. Place the `Debu` folder inside `ReplicatedStorage`.
2. In a server `Script`, require and initialize:

```lua
local Debu = require(game.ReplicatedStorage.Debu)
Debu.Init()
```

For client-side error capture, repeat the call inside a `LocalScript`. `ScriptContext.Error` is scoped per-side and must be connected on each.

---

## API

### `Debu.Init()`
Connects the error handler and starts the performance watcher. Idempotent — subsequent calls are ignored.

### `Debu.Log(message: string)`
Prints an info-level message via `print`. Output includes timestamp and active tag.

### `Debu.Warn(message: string)`
Prints a warning-level message via `warn`.

### `Debu.Error(message: string)`
Prints an error-level message via `warn`. Does not halt execution.

### `Debu.Tag(name: string?)`
Sets the active tag prepended to all subsequent log output. Pass `nil` to clear.

---

## Usage

**Initialization:**
```lua
local Debu = require(game.ReplicatedStorage.Debu)
Debu.Init()
```

**Tagged logging:**
```lua
Debu.Tag("InventorySystem")
Debu.Log("Item added")
-- 14:22:01 [InventorySystem] [INFO]: Item added
```

**Direct error parsing:**
```lua
local ErrorParser = require(game.ReplicatedStorage.Debu.ErrorParser)
print(ErrorParser.Parse("Workspace.Part:14: attempt to index nil with 'Position'"))
```

---

## Output format

Raw Roblox error:
```
ServerScriptService.Script:3: attempt to perform arithmetic (mul) on nil and number
```

Debu output:
```
── Debu ── ServerScriptService.Script:3 → Tried to do math on a nil value
```

---

## Configuration

### Lag spike threshold
Default: `0.1` seconds (100ms). Adjust via:
```lua
local Performance = require(game.ReplicatedStorage.Debu.Performance)
Performance.SetThreshold(0.05) -- 50ms
```

---

## Notes

- `ScriptContext.Error` only fires for uncaught errors. Errors caught by `pcall` are not reported.
- The handler is scoped per execution context. Server and client require separate `Init()` calls.
- `print(undefinedVar)` does not raise an error in Lua and will not trigger the handler.
- If a script errors before `Init()` connects, that error is not captured. Ensure `Init()` runs first or delay test scripts with `task.wait`.

---

## File structure

```
Debu/
├─ Logger        -- output formatting and routing
├─ ErrorParser   -- raw error string → structured output
├─ StackTrace    -- traceback filtering
└─ Performance   -- frame delta monitoring
```

---

## Roadmap

- Studio overlay UI
- Click-to-source navigation from errors
- Performance graph
- RemoteEvent traffic logging

---

## License

Free to use. Attribution appreciated.

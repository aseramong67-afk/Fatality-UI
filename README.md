# Fatality
Fatality.Win UI for Roblox - Dark Theme

![image](https://github.com/user-attachments/assets/f1023175-a33b-44fc-8a24-636103e8324e)


# Usage
- [Document](https://cat-sus.gitbook.io/fatality)
- [Example](https://github.com/4lpaca-pin/Fatality/blob/main/example.luau)

# Interactive ESP Preview
Every window gets a single **Interactive ESP Preview** panel docked to the **side** of the
window (outside the tab content): a live ESP mock-up (dummy player with name, distance,
health bar, weapon and right side flags) plus a `Drag & Drop Elements` chip row (`Box`,
`Money`, `Defusing`, `Armor`, `Hit`, `His Bomb`, `Break LC`, `Taser`, `Ammo Bar`, `Ammo`,
`Ping`, `Item Name`, `Armor Bar`).

- The panel is **shared by all tabs**: switching tabs never touches it, it only fades
  together with the whole UI (show/hide key) and follows the window when you drag it.
- **Click** a chip - toggles its element in the preview.
- **Drag** a chip onto the stage - enables the element; drop it outside the stage - disables it.
- **`?`** in the panel header - shows a short hint, **chevron** - collapses/expands the panel.
- Its state is stored in the window config, so it is saved/loaded with the rest of your settings.

```lua
local Window = Fatal.new({
	Name = "FATALITY",
	Expire = "never",
	ESPPreview = false -- opt-out: no side panel
})

-- Or pass a config (side defaults to "right"):
local Window = Fatal.new({
	Name = "FATALITY",
	Expire = "never",
	ESPPreviewPosition = "left", -- "left" | "right", side of the window
	ESPPreview = {
		Name = "ESP PREVIEW",   -- header title
		Position = "right",     -- "left" | "right", side of the window
		Height = 0,             -- extra height for the stage
		Flag = "LegitESP",      -- config flag (persisted in the window config)
		Callback = function(Key: string, Value: boolean)
			print("[ESP Preview]", Key, Value)
		end
	}
})
```

Window level options: `ESPPreview: boolean | table` (default: panel with defaults) and
`ESPPreviewPosition: string` (default `"right"`).

The returned response supports `GetValue()` / `SetValue(Table)` (config save & load),
`SetElement(Key, Enabled)`, `SetCollapsed(Enabled)` and `Flag`.

> `MenuLib:AddESPPreview(Config)` is still available for a **tab-local** preview
> (inside a menu column, fades with the tab). The automatic side panel above replaces
> the old behavior of adding a preview into every menu.

## Custom chips (binding the preview to a real ESP)

`Config.Elements` replaces the default chip row with your own set - each entry is
`{ Key, Label, Default }`. Chip keys are also the keys reported to `Config.Callback`,
so you can wire them to any ESP. Stage keys that have a visual on the preview:

| Key | Stage element | Typical flag |
| --- | --- | --- |
| `ESP` | the whole dummy entity | master ESP toggle |
| `Box` | corner box | `Boxes` |
| `Name` | player name | `Names` |
| `Distance` | distance label | `Distance` |
| `ItemName` | weapon name | `Weapon` |
| `Health` | health bar + HP value | `Healthbar` |
| `Tracer` | tracer line (stage bottom → dummy) | `Tracers_Enabled` |

The remaining keys of the default set (`Money`, `Defusing`, `Armor`, `Hit`, `HisBomb`,
`BreakLC`, `Taser`, `AmmoBar`, `Ammo`, `Ping`, `ArmorBar`) only report through the
callback - map them to your own flags if you include them. A key without a stage
visual (e.g. a pure config toggle) works too: it still gets a chip and a callback.

```lua
Fatal.new({
	Name = "FATALITY",
	Expire = "never",
	ESPPreview = {
		Elements = {
			{ Key = "ESP", Label = "Enemy ESP", Default = true },
			{ Key = "Box", Label = "Box", Default = true },
			{ Key = "Name", Label = "Names", Default = true },
			{ Key = "Distance", Label = "Distance", Default = true },
			{ Key = "ItemName", Label = "Weapon", Default = true },
			{ Key = "Health", Label = "Health bar", Default = true },
			{ Key = "Tracer", Label = "Tracers", Default = true }
		},
		Callback = function(Key, Value)
			-- apply to your ESP flags here, then refresh it
		end
	}
})
```

See `example.luau` for a full working setup: the PastaSense `modules/esp.lua` module is
embedded into the script and every chip of the side panel is bound to the real
ESP flags (`S.ESP_Enabled`, `ESPFlags.Boxes`, `ESPFlags.Names`, `ESPFlags.Distance`,
`ESPFlags.Weapon`, `ESPFlags.Healthbar`, `S.Tracers_Enabled`).


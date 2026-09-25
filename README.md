# Fatality
Fatality.Win UI for Roblox - Dark Theme

![image](https://github.com/user-attachments/assets/f1023175-a33b-44fc-8a24-636103e8324e)


# Usage
- [Document](https://cat-sus.gitbook.io/fatality)
- [Example](https://github.com/4lpaca-pin/Fatality/blob/main/example.luau)

# Interactive ESP Preview
Every menu automatically gets an **Interactive ESP Preview** panel: a live ESP mock-up
(dummy player with name, distance, health bar, weapon and right side flags) plus a
`Drag & Drop Elements` chip row (`Box`, `Money`, `Defusing`, `Armor`, `Hit`, `His Bomb`,
`Break LC`, `Taser`, `Ammo Bar`, `Ammo`, `Ping`, `Item Name`, `Armor Bar`).

- **Click** a chip - toggles its element in the preview.
- **Drag** a chip onto the stage - enables the element; drop it outside the stage - disables it.
- **`?`** in the panel header - shows a short hint, **chevron** - collapses/expands the panel.
- The panel is attached to the menu (it fades together with the menu tab) and its state
  is stored in the window config, so it is saved/loaded with the rest of your settings.

```lua
-- Automatic (default). Disable it for a specific menu:
local Menu = Fatal:AddMenu({
	Name = "LEGIT",
	Icon = "eye",
	ESPPreview = false -- opt-out
})

-- Or place it manually with a custom config:
Menu:AddESPPreview({
	Name = "ESP PREVIEW",       -- header title
	Position = "right",         -- "left" | "center" | "right"
	Height = 0,                 -- extra height for the stage
	Flag = "LegitESP",          -- config flag (persisted in the window config)
	Callback = function(Key: string, Value: boolean)
		print("[ESP Preview]", Key, Value)
	end
})
```

Menu level options: `ESPPreview: boolean` (default `true`) and
`ESPPreviewPosition: string` (default `"right"`).

The returned response supports `GetValue()` / `SetValue(Table)` (config save & load),
`SetElement(Key, Enabled)`, `SetCollapsed(Enabled)` and `Flag`.


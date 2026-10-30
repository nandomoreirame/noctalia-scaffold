-- Scaffold bar widget: glyph + label (the `label` setting); click toggles the
-- Hello World panel. All decisions live in lib/present.luau.

local present = require("./lib/present.luau")

local PANEL = "nandomoreirame/scaffold:panel"

local function render()
	local vertical = barWidget.isVertical()
	local m = present.bar(noctalia.getConfig("label"), vertical)

	local children = {
		ui.glyph({ name = m.glyph, color = "on_surface" }),
	}
	if m.showLabel then
		table.insert(children, ui.label({ text = m.label, color = "on_surface" }))
	end

	local container = if vertical then ui.column else ui.row
	barWidget.render(container({ gap = 6, align = "center", paddingH = 8, paddingV = 2 }, children))
	barWidget.setTooltip(noctalia.tr("bar.tooltip"))
end

function update()
	render()
end

function onClick()
	noctalia.togglePanel(PANEL)
end

render()

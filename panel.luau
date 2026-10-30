-- Scaffold panel: "Hello World!" centered, translated subtitle below.
-- The host already pads the panel, so the root adds no padding.

local present = require("./lib/present.luau")

function render()
	local m = present.panel(noctalia.tr("panel.subtitle"))
	panel.render(ui.column({ flexGrow = 1, align = "center", justify = "center", gap = 6 }, {
		ui.label({ text = m.headline, fontSize = 20, fontWeight = "bold", color = "on_surface" }),
		ui.label({ text = m.subtitle, fontSize = 12, color = "on_surface_variant" }),
	}))
end

function onOpen(_context: any)
	render()
end

render()

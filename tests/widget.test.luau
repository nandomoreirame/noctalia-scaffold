local assert = require("./support/assert")
local runner = require("./support/runner")
local mock = require("./support/noctalia_mock")
local entry = require("./support/entry")

local describe, it = runner.describe, runner.it

local function last(loaded, path)
	local calls = mock.calls(loaded.env, path)
	return calls[#calls]
end

local function texts(node, out)
	out = out or {}
	if typeof(node) == "table" and node.type then
		if node.props.text then
			table.insert(out, node.props.text)
		end
		for _, child in node.children or {} do
			texts(child, out)
		end
	end
	return out
end

describe("widget", function()
	it("renders the glyph and the configured label", function()
		local w = entry.load("widget.luau", { config = { label = "hello" } })
		local tree = last(w, "barWidget.render")[1]
		assert.equal(tree.type, "row")
		assert.equal(tree.children[1].type, "glyph")
		assert.equal(texts(tree)[1], "hello")
	end)

	it("falls back to scaffold when the setting is blank", function()
		local w = entry.load("widget.luau", { config = { label = "  " } })
		assert.equal(texts(last(w, "barWidget.render")[1])[1], "scaffold")
	end)

	it("shows only the glyph on a vertical bar", function()
		local w = entry.load("widget.luau", { vertical = true, config = { label = "scaffold" } })
		local tree = last(w, "barWidget.render")[1]
		assert.equal(tree.type, "column")
		assert.equal(#tree.children, 1)
	end)

	it("uses the translated tooltip", function()
		local w = entry.load("widget.luau", { config = { label = "scaffold" } })
		assert.equal(last(w, "barWidget.setTooltip")[1], "bar.tooltip")
	end)

	it("toggles its panel on click", function()
		local w = entry.load("widget.luau", { config = { label = "scaffold" } })
		w.call("onClick")
		assert.equal(last(w, "noctalia.togglePanel")[1], "nandomoreirame/scaffold:panel")
	end)

	it("re-renders on update so a changed setting shows up", function()
		local w = entry.load("widget.luau", { config = { label = "scaffold" } })
		local before = #mock.calls(w.env, "barWidget.render")
		w.call("update")
		assert.equal(#mock.calls(w.env, "barWidget.render"), before + 1)
	end)
end)

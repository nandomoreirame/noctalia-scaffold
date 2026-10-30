local assert = require("./support/assert")
local runner = require("./support/runner")
local mock = require("./support/noctalia_mock")
local entry = require("./support/entry")

local describe, it = runner.describe, runner.it

local function last(loaded, path)
	local calls = mock.calls(loaded.env, path)
	return calls[#calls]
end

describe("panel", function()
	it("centers Hello World! with the translated subtitle below", function()
		local p = entry.load("panel.luau")
		local tree = last(p, "panel.render")[1]
		assert.equal(tree.type, "column")
		assert.equal(tree.props.align, "center")
		assert.equal(tree.props.justify, "center")
		assert.equal(tree.props.flexGrow, 1)
		assert.equal(tree.children[1].props.text, "Hello World!")
		assert.equal(tree.children[2].props.text, "panel.subtitle")
	end)

	it("renders again when opened", function()
		local p = entry.load("panel.luau")
		local before = #mock.calls(p.env, "panel.render")
		p.call("onOpen", {})
		assert.equal(#mock.calls(p.env, "panel.render"), before + 1)
	end)
end)

local assert = require("./support/assert")
local runner = require("./support/runner")
local modules = require("./support/modules")

local describe, it = runner.describe, runner.it
local present = modules.load("lib/present.luau")

describe("present.label", function()
	it("uses the configured label", function()
		assert.equal(present.label("hello"), "hello")
	end)

	it("trims surrounding whitespace", function()
		assert.equal(present.label("  hi  "), "hi")
	end)

	it("falls back to scaffold when empty, blank or not a string", function()
		assert.equal(present.label(""), "scaffold")
		assert.equal(present.label("   "), "scaffold")
		assert.equal(present.label(nil), "scaffold")
		assert.equal(present.label(42), "scaffold")
	end)
end)

describe("present.bar", function()
	it("shows glyph and label on a horizontal bar", function()
		local m = present.bar("scaffold", false)
		assert.equal(m.glyph, "sparkles")
		assert.equal(m.label, "scaffold")
		assert.equal(m.showLabel, true)
	end)

	it("hides the label on a vertical bar", function()
		assert.equal(present.bar("scaffold", true).showLabel, false)
	end)
end)

describe("present.panel", function()
	it("keeps the headline literal and passes the subtitle through", function()
		local m = present.panel("translated subtitle")
		assert.equal(m.headline, "Hello World!")
		assert.equal(m.subtitle, "translated subtitle")
	end)
end)

local assert = require("./support/assert")
local runner = require("./support/runner")
local modules = require("./support/modules")

local describe, it = runner.describe, runner.it

local toml = modules.text("plugin.toml")

local function has(needle: string)
	if string.find(toml, needle, 1, true) == nil then
		error("plugin.toml lacks " .. needle)
	end
end

describe("plugin.toml", function()
	it("declares the id, api level, widget and panel", function()
		for _, needle in {
			'id = "nandomoreirame/scaffold"',
			'name = "Scaffold"',
			"plugin_api = 22",
			'license = "MIT"',
			'entry = "widget.luau"',
			'entry = "panel.luau"',
		} do
			has(needle)
		end
	end)

	it("ships the panel attached, near the click, 320x160", function()
		for _, needle in { 'placement = "attached"', "open_near_click = true", "width = 320", "height = 160" } do
			has(needle)
		end
	end)

	it("declares the label setting with its default and translated keys", function()
		for _, needle in {
			'key = "label"',
			'type = "string"',
			'default = "scaffold"',
			'label_key = "settings.label.label"',
			'description_key = "settings.label.description"',
		} do
			has(needle)
		end
	end)

	it("keeps the description within 120 characters", function()
		local description = string.match(toml, '\ndescription%s*=%s*"([^"]*)"')
		assert.equal(description ~= nil and utf8.len(description) <= 120, true)
	end)
end)

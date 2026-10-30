-- Setting and locale strings -> bar and panel models.
-- Pure: no noctalia / barWidget / panel / ui, so tests run without a shell.

local Present = {}

Present.DEFAULT_LABEL = "scaffold"
Present.HEADLINE = "Hello World!"

-- Setting value -> label shown in the bar; blank or missing falls back to the default.
function Present.label(raw: any): string
	if typeof(raw) ~= "string" then
		return Present.DEFAULT_LABEL
	end
	local trimmed = string.match(raw, "^%s*(.-)%s*$") or ""
	if trimmed == "" then
		return Present.DEFAULT_LABEL
	end
	return trimmed
end

function Present.bar(raw: any, vertical: boolean): any
	return { glyph = "sparkles", label = Present.label(raw), showLabel = not vertical }
end

-- The headline stays literal in every locale; i18n lives in the subtitle.
function Present.panel(subtitle: string): any
	return { headline = Present.HEADLINE, subtitle = subtitle }
end

return Present

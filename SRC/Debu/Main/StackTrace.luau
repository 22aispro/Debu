local StackTrace = {}

local NOISE = {
	"CoreGui",
	"CorePackages",
	"RobloxGui",
	"PlayerScripts",
	"PlayerScriptsLoader",
	"ReplicatedFirst",
	"RobloxScriptSecurity",
	"rbxasset://",
	"ModuleScript:Core",
	"Internal"
}

-- || helper functions || --

local function isNoise(line)
	for _, NoiseEntry in NOISE do
		if string.find(line, NoiseEntry, 1, true) then
			return true
		end
	end

	return false
end

-- || public API || --

function StackTrace.Get(skip_levels)
	local Raw = debug.traceback("", (skip_levels or 0) + 1)
	local Results = {}

	for Line in string.gmatch(Raw, "[^\n]+") do
		if Line and Line:match("%S") and not isNoise(Line) then
			table.insert(Results, (Line:gsub("^%s+", "")))
		end
	end

	return Results
end

function StackTrace.Format(skip_levels)
	local Frames = StackTrace.Get(skip_levels)

	if #Frames == 0 then
		return ""
	end

	return "  → " .. table.concat(Frames, "\n  → ")
end

return StackTrace

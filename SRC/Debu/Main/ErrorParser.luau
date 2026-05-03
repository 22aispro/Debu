local ErrorParser = {}

local Explanations = {
	{
		pattern = "attempt to index nil with '(.-)'",
		template = "Tried to read '%1' from something that doesn't exist (nil)"
	},

	{
		pattern = "attempt to index (%a+) with '(.-)'",
		template = "Tried to read '%2' from a %1 value (can't do that)"
	},

	{
		pattern = "attempt to call a (%a+) value",
		template = "Tried to call something that's a %1, not a function"
	},
	
	{
		pattern = "attempt to perform arithmetic %(.-%) on a (%a+) value",
		template = "Tried to do math on a %1 value"
	},

	{
		pattern = "attempt to perform arithmetic on a nil value",
		template = "Tried to do math with nil (missing value)"
	},

	{
		pattern = "attempt to compare (%a+) with (%a+)",
		template = "Tried to compare two incompatible types: %1 and %2"
	},

	{
		pattern = "attempt to concatenate a nil value",
		template = "Tried to join text with nil (missing string value)"
	},

	{
		pattern = "attempt to concatenate (%a+) value",
		template = "Tried to join text with a %1 value (must be a string)"
	},
}

-- || helper functions || --

local function split_error(raw)
	local ScriptPath, LineNumber, RawMessage =
		string.match(raw, "(.-):(%d+): (.+)")

	if not ScriptPath then
		return nil, nil, nil
	end

	return ScriptPath, tonumber(LineNumber), RawMessage
end

local function explain(raw_message)
	for _, Entry in Explanations do
		local c1, c2 = string.match(raw_message, Entry.pattern)

		if c1 then
			local Result = Entry.template
			Result = Result:gsub("%%1", c1 or "")
			Result = Result:gsub("%%2", c2 or "")
			return Result
		end
	end

	return raw_message
end

-- || public API || --

function ErrorParser.Parse(raw)
	local ScriptPath, LineNum, RawMessage = split_error(raw)

	if not ScriptPath then
		return raw
	end

	local Message = explain(RawMessage)

	local Lines = {
		"── Debu caught an error ──",
		"	──  	Script:  " .. ScriptPath,
		"	──  	Line:    " .. tostring(LineNum),
		"	──  	Reason:  " .. Message,
		""
	}

	return table.concat(Lines, "\n")
end

return ErrorParser

local Logger = {}

local CurrentTag = nil

-- || helper functions || -- 

local function format(level, msg)
	local time = os.date("%H:%M:%S")
	if CurrentTag then
		return string.format("%s [%s] [%s]: %s", time, CurrentTag, level, msg)
	else
		return string.format("%s [%s]: %s", time, level, msg)
	end
end

-- || public API || --

function Logger.SetTag(tag)
	CurrentTag = tag
end

function Logger.Log(msg)
	print(format("INFO", msg))
end

function Logger.Warn(msg)
	warn(format("WARN", msg))
end

function Logger.Error(msg)
	warn(format("ERROR", msg))
end

return Logger

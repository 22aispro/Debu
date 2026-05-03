local ScriptContext = game:GetService("ScriptContext")

local Logger 		= require("@self/Logger")
local ErrorParser 	= require("@self/ErrorParser")
local StackTrace 	= require("@self/StackTrace")
local Performance 	= require("@self/Performance")

local Debu = {}

local initialized = false

function Debu.Init()
	if initialized then
		return
	end

	local ScriptContext = game:GetService("ScriptContext")

	ScriptContext.Error:Connect(function(message, stack_trace, script_instance)
		local Message = ErrorParser.Parse(message)
		warn(Message)
		warn(stack_trace)
	end)

	Performance.Start(Logger)

	initialized = true

	Logger.Log("Debu initialized")
end

function Debu.Log(msg)
	Logger.Log(msg)
end

function Debu.Warn(msg)
	Logger.Warn(msg)
end

function Debu.Error(msg)
	Logger.Error(msg)
end

function Debu.Tag(name)
	Logger.SetTag(name)
end

return Debu

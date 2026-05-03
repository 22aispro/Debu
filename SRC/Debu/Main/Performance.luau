local RunService = game:GetService("RunService")

local Performance = {}

local SPIKE_THRESHOLD = .1
local connection = nil
local Logger = nil

-- || public API || --

function Performance.Start(logger_ref)
	Logger = logger_ref

	if connection then
		connection:Disconnect()
		connection = nil
	end

	connection = RunService.Heartbeat:Connect(function(dt)
		if dt > SPIKE_THRESHOLD then
			local ms = math.floor(dt * 1000)
			local threshold_ms = math.floor(SPIKE_THRESHOLD * 1000)

			Logger.Warn(
				"Lag spike: " .. ms .. "ms (threshold " .. threshold_ms .. "ms)"
			)
		end
	end)
end

function Performance.Stop()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

function Performance.SetThreshold(seconds)
	SPIKE_THRESHOLD = seconds
end

return Performance

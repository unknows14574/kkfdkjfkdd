local Jobs     = {}
local LastTime = nil

local function GetTime()
	local timestamp = os.time()

	return {
		d = os.date('*t', timestamp).wday, 
		h = tonumber(os.date('%H', timestamp)), 
		m = tonumber(os.date('%M', timestamp))
	}
end

local function OnTime(d, h, m)
	for i, value in pairs(Jobs) do
		if value.h == h and value.m == m then
			value.cb(d, h, m)
		end
	end
end

local function Tick()
	local time = GetTime()

	if time.h ~= LastTime.h or time.m ~= LastTime.m then
		OnTime(time.d, time.h, time.m)
		LastTime = time
	end

	SetTimeout(60000, Tick)
end

LastTime = GetTime()

Tick()

-- Appel cron
function CronRunAt(h, m, cb)
	table.insert(Jobs, {
		h  = h,
		m  = m,
		cb = cb
	})
end

AddEventHandler('cron:runAt', function(h, m, cb)
	CronRunAt(h, m, cb)
end)

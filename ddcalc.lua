local oldfmt = string.format
---@diagnostic disable-next-line: lowercase-global
function bin(x, l)
	assert(x == math.ceil(x))
	local r,length = {}, math.floor(math.log(x, 2))+1
	l = l or 0
	length = length > l and length or l
	-- init table to ensure everything is in the array part
	for _=1,length do table.insert(r, 0) end
	for i=length,1,-1 do
		r[i] = x & 1
		x = x >> 1
	end
	assert(x == 0)
	return table.concat(r)
end
local replacementFuncs = {
	["^%%[0]?[1-9]?[0-9]*b$"] = function(fmt, arg)
		local flag,width = fmt:match("^%%([0 ]?)([1-9]?[0-9]*)b$")
		assert(flag and width, "invalid format '"..fmt.."' given")
		flag = flag == "" and " " or flag
		if flag == "0" then
			return bin(arg, tonumber(width)), "%%s"
		else
			return bin(arg), "%%"..width.."s"
		end
	end
}
function string.format(fmt,...)
	local args = {...}
	local matches = {}
	for match in fmt:gmatch("%%[%-%+ 0#]?[1-9]?[0-9]?%.?[0-9]?[0-9]?%a") do
		table.insert(matches, match)
		local replFoo
		for k,v in pairs(replacementFuncs) do
			if match:match(k) then
				assert(not replFoo, "multiple replacements match")
				replFoo = v
			end
		end
		if replFoo then
			local replA,replB = replFoo(match, args[#matches])
			fmt = fmt:gsub("%"..match, replB, 1)
			args[#matches] = replA
		end
	end
	return oldfmt(fmt,table.unpack(args))
end
---@diagnostic disable-next-line: lowercase-global
function f(...)
	return string.format(...)
end

---@diagnostic disable-next-line: lowercase-global
date = require"date"
local dobj = getmetatable(date())
function dobj:dur()
	local function roundZ(num)
		if num >= 0 then return math.floor(num)
        else return math.ceil(num) end
	end
	local function rem(x, y)
		return math.fmod(roundZ(x), y)
	end
	return ("%d %d:%d:%d"):format(roundZ(self:spandays()), rem(self:spanhours(),24), rem(self:spanminutes(),60), rem(self:spanseconds(),60))
end
function date.from_dur(o)
	local day,hour,min,sec = o.day or 0, o.hour or 0, o.min or 0, o.sec or 0
	for k,_ in pairs(o) do assert(k=="day" or k=="hour" or k=="min" or k=="sec", "Unknown key "..k) end
	local now = date()
	local d   = now:copy()
		:adddays(day)
		:addhours(hour)
		:addminutes(min)
		:addseconds(sec)
	return d - now
end

function math.avg(...)
	return math.sum(...) /#{...}
end
function math.sum(...)
	local r = 0
	for _,v in ipairs{...} do r = r+v end
	return r
end
function math.factorial(n)
    assert(n >= 0)
    local prod = 1
    for i=1,n do
        prod = prod * i
    end
    return prod
end
function math.binomial(n,k)
	return math.factorial(n) / (math.factorial(k) * math.factorial(n-k))
end

---@diagnostic disable-next-line: lowercase-global
int = {}
function int.from_bytes(endian, ...)
	local r = 0
	if endian == "little" then
		local p = 0
		for _,v in ipairs{...} do
			r = r + (v << p)
			p = p+8
		end
	elseif endian == "big" then
		local p = #{...}*8 - 8
		for _,v in ipairs{...} do
			r = r + (v << p)
			p = p-8
		end
	else
		error("endian must be either 'big' or 'little'")
	end
	return r
end

function int.to_bytes(endian, length, x)
	assert(length >= 0, "length must be >= 0")
	local mask = 255
	local r = {}
	if endian == "little" then
		for i=1,length do
			r[i] = x & mask
			x = x >> 8
		end
	elseif endian == "big" then
		-- init table to ensure everything is in the array part
		for _=1,length do table.insert(r, 0) end
		for i=length,1,-1 do
			r[i] = x & mask
			x = x >> 8
		end
	else
		error("endian must be either 'big' or 'little'")
	end
	return r
end


---@diagnostic disable-next-line: lowercase-global
pl = require"pl"
---@diagnostic disable-next-line: lowercase-global
compr = require"pl.comprehension".new()
---@diagnostic disable-next-line: lowercase-global
seq = require"pl.seq" -- map, zip, etc
---@diagnostic disable-next-line: lowercase-global
map,filter,reduce,zip = seq.map, seq.filter, seq.reduce, seq.zip

---@diagnostic disable-next-line: lowercase-global
-- random = {}
-- function random.perm()
-- end

local prompt    = require"prompt"
prompt.colorize = true
prompt.name     = "ddcalc"
prompt.history  = "/home/lukas/.cache/ddcalc/ddcalc.hist"

if arg[0]:match("ddcalc.lua") then
	print("map(fn,iter[,arg])", "filter(iter,pred[,arg])", "reduce(fn,iter,init)", "\nzip(iter,iter)", "compr(str)(tab)")
	print("date(year, month, day, hour, min, sec, ticks)", "date(str)", "date(true_utc)", "\ndate:fmt(fmt_str)", "date:get/set/add", "date:span (durations)")
	prompt.enter()
end

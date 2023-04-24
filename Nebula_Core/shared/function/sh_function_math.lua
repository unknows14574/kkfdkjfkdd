if Core == nil then
    Core = {}
end

Core.Math = {}

--Math Trim
Core.Math.Trim = function(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end

--Math Round
Core.Math.Round = function(num, numDecimalPlaces)
-- function MathRound(num, numDecimalPlaces)
    if numDecimalPlaces == 0 then
        return math.floor(num + 0.5)
    end
    return math.floor(num * (10 ^ (numDecimalPlaces or 0)) + 0.5) / (10 ^ (numDecimalPlaces or 0))
end

--Génération Random Lettre Length
Core.Math.RandomStringLength = function(Length, Upper)
-- function RandomStringLength(Length, Upper)
    local chars = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
    local randomString = ''

    for i = 1, Length do
        randomString = randomString .. chars[math.random(1, #chars)]
    end

    return ((Upper and string.upper(randomString)) or randomString)
end

--Génération Random Number Length
Core.Math.RandomNumberLength = function(Length)
-- function RandomNumberLength(Length)
    local randomNumber = ""

    for i = 1, Length do
        randomNumber = randomNumber .. math.random(0, 9)
    end

    return randomNumber
end

--Function
Core.Math.StringSplit = function(inputstr, sep)
-- function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

Core.Math.Tablelength = function(T)
-- function Tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

Core.Math.FirstLetterToUpper = function(valeur)
    return string.upper(string.sub(valeur, 1, 1)) .. string.lower(string.sub(valeur, 2))
end

Core.Math.PairsByKeys = function(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

Core.Math.SearchTable = function(Table, Search, ...)
    if Search == nil or Search == "" then
        return Table
    end
    local NewTable = {}
    for k, v in pairs(Table) do
        if ... == nil then
            if (type(k) == "string" and k ~= nil and string.find(string.lower(k), Search) == 1) or (type(v) == "string" and k ~= nil and string.find(string.lower(v), Search) == 1) then
                return Table
            end
        else
            for l, item in pairs({...}) do
                if Search ~= "" and v[item] ~= nil and type(v) == "table" and string.find(string.lower(v[item]), Search) == 1 then
                    table.insert(NewTable, v)
                    break
                end
            end 
            
        end        
    end

    print(#NewTable)
    return ((#NewTable > 0 and NewTable) or nil)
end
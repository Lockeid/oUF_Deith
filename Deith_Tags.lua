--== Custom colors ==--
local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {0, 144/255, 1}
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})



oUF.Tags['[coloredmana]'] = function(unit)
	local r, g, b, t
	local _, ptype = UnitPowerType(unit)
	local p = UnitPower(unit)

	t = colors.power[ptype]
	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	return string.format("|cff%02x%02x%02x%d|r",r*255,g*255,b*255,p)

end

oUF.TagEvents['[coloredmana]']   = 'UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER'

oUF.Tags['[coloredmanaper]'] = function(unit)
	local r, g, b, t
	local _, ptype = UnitPowerType(unit)
	local p = UnitPower(unit)
	local pmax = UnitPowerMax(unit)

	t = colors.power[ptype]
	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	return string.format("|cff%02x%02x%02x%d/%d|r",r*255,g*255,b*255,p,pmax)

end

oUF.TagEvents['[coloredmanaper]']   = "UNIT_MAXENERGY UNIT_MAXFOCUS UNIT_MAXMANA UNIT_MAXRAGE UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_MAXRUNIC_POWER UNIT_RUNIC_POWER"

local numberize = function(v)
	if v <= 9999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 10000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

oUF.Tags['[gradienthp]'] = function(unit)
	local cur = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	--local cfm, mfm


	local r, g, b	
	--r, g, b = oUF.ColorGradient(cur/max, .69,.31,.31, .65,.63,.35, .33,.59,.33)
	r, g, b = oUF.ColorGradient(cur/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
	
	return string.format("|cff%02x%02x%02x"..numberize(cur).."/"..numberize(max).."|r",r*255,g*255,b*255)

end

oUF.TagEvents['[gradienthp]']   = "UNIT_HEALTH UNIT_MAXHEALTH"

oUF.Tags['[shortname]'] = function(unit)	
	local name = UnitName(unit)
	return (string.len(name) > 10) and string.gsub(name, "%s?(.)%S+%s", "%1. ") or name
end

oUF.TagEvents['[shortname]'] = 'UNIT_NAME_UPDATE'



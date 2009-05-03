--== Options ==--
-- true to enable; false to disable
local background = true --little background behind the unit frames
local healthtext_opt = true --text for health or not
local powertext_opt = true -- text for power or not
local leader = true -- leader icon or not
local RI = true -- raid icons or not
local name_opt = true -- name text or not
local playerCB = true -- player castbar or not
local targetCB = true -- target castbar or not
local target_debuff = true -- target debuffs or not
local target_buff = true -- target buffs or not
local reputation = true
local experience = false

local function Hex(r, g, b)
	if type(r) == "table" then
		if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

--== Textures Options ==--
local frameborder = "Interface\\AddOns\\oUF_Deith\\media\\frameborder3"
local font, fontsize = "Fonts\\FRIZQT__.ttf", 12		-- The font and fontsize
local backdrop = {
 		bgFile = "Interface\\AddOns\\oUF_Deith\\media\\HalBackgroundA", tile = true, tileSize = 16,
		insets = {left = -2, right = -2, top = -2, bottom = -2},
	}


--local statusbar = "Interface\\AddOns\\RaccoonUI\\textures\\dP"
local statusbar = [[Interface\Addons\oUF_Deith\media\DsmV1]]
local backdrop2 = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}
local playerClass = select(2, UnitClass("player"))
local buff = 'Interface\\AddOns\\oUF_Deith\\media\\border'
local color_rb = 0
local color_gb = 0
local color_bb = 0
local alpha_fb = 0.35
--== End of textures options ==--


--== Custom colors ==--
local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {0, 252/255, 1}
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})



--== The function to create font strings, thanks to Caellian ==--
local function SetFontString(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH('LEFT')
	fs:SetShadowColor(0,0,0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end


local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end 

--== Skin the buttons (buffs and debuffs) ==--
local auraIcon = function(self, button, icons)
	icons.showDebuffType = true

	button.icon:SetTexCoord(.07, .93, .07, .93)
	button.icon:SetPoint('TOPLEFT', button, 'TOPLEFT', 1, -1)
	button.icon:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 1)
	
	button.overlay:SetTexture(buff)
	button.overlay:SetTexCoord(0,1,0,1)
	button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end
	
	button.cd:SetReverse()
	button.cd:SetPoint('TOPLEFT', button, 'TOPLEFT', 2, -2) 
	button.cd:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)     
end

--== The Druid mana ==--
local function UpdateDruidPower(self, event, unit)
	if(unit and unit ~= self.unit) then return end

	local bar = self.DruidPower
	local num, str = UnitPowerType('player')
	local min = UnitPower('player', (num ~= 0) and 0 or 3)
	local max = UnitPowerMax('player', (num ~= 0) and 0 or 3)

	bar:SetMinMaxValues(0, max)

	if(min ~= max) then
		bar:SetValue(min)
		bar:SetAlpha(1)

		if(num ~= 0) then
			bar:SetStatusBarColor(unpack(colors.power['MANA']))
			bar.Text:SetFormattedText('%d - %d%%', min, math.floor(min / max * 100))
		else
			bar:SetStatusBarColor(unpack(colors.power['ENERGY']))
			bar.Text:SetText()
		end
	else
		bar:SetAlpha(0)
		bar.Text:SetText()
	end
end

--== The layout really begins here ==--
local function Style(self, unit)
	self.colors = colors
	self.menu = menu
	self:RegisterForClicks('AnyUp')
	self:SetAttribute('*type2', 'menu')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	--== Unit Backgrounds ==--

	--[[local bg = CreateFrame("Frame", nil, self)
	bg:SetParent(self)
	bg:SetFrameStrata("BACKGROUND")
	bg:SetFrameLevel(1)
	bg:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\AddOns\\sTweak\\textures\\border2px",
		tile = true, tileSize = 8, edgeSize = 14,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	bg:SetBackdropBorderColor(70/255,70/255,70/255,1)
	bg:SetBackdropColor(0, 0, 0, 1)
	bg:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
	bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)]]


	self:SetBackdrop(backdrop2)
	self:SetBackdropColor(0,0,0,0.35)

	local TopLeft = self:CreateTexture(nil, "OVERLAY")
	TopLeft:SetTexture(frameborder)
	TopLeft:SetTexCoord(0, 1/3, 0, 1/3)
	TopLeft:SetPoint("TOPLEFT", self, -6, 6)
	TopLeft:SetWidth(14) TopLeft:SetHeight(14)
	TopLeft:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)

	local TopRight = self:CreateTexture(nil, "OVERLAY")
	TopRight:SetTexture(frameborder)
	TopRight:SetTexCoord(2/3, 1, 0, 1/3)
	TopRight:SetPoint("TOPRIGHT", self, 6, 6)
	TopRight:SetWidth(14) TopRight:SetHeight(14)
	TopRight:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)

	local BottomLeft = self:CreateTexture(nil, "OVERLAY")
	BottomLeft:SetTexture(frameborder)
	BottomLeft:SetTexCoord(0, 1/3, 2/3, 1)
	BottomLeft:SetPoint("BOTTOMLEFT", self, -6, -6)
	BottomLeft:SetWidth(14) BottomLeft:SetHeight(14)
	BottomLeft:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)

	local BottomRight = self:CreateTexture(nil, "OVERLAY")
	BottomRight:SetTexture(frameborder)
	BottomRight:SetTexCoord(2/3, 1, 2/3, 1)
	BottomRight:SetPoint("BOTTOMRIGHT", self, 6, -6)
	BottomRight:SetWidth(14) BottomRight:SetHeight(14)
	BottomRight:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)

	local TopEdge = self:CreateTexture(nil, "OVERLAY")
	TopEdge:SetTexture(frameborder)
	TopEdge:SetTexCoord(1/3, 2/3, 0, 1/3)
	TopEdge:SetPoint("TOPLEFT", TopLeft, "TOPRIGHT")
	TopEdge:SetPoint("TOPRIGHT", TopRight, "TOPLEFT")
	TopEdge:SetHeight(14)
	TopEdge:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)
		
	local BottomEdge = self:CreateTexture(nil, "OVERLAY")
	BottomEdge:SetTexture(frameborder)
	BottomEdge:SetTexCoord(1/3, 2/3, 2/3, 1)
	BottomEdge:SetPoint("BOTTOMLEFT", BottomLeft, "BOTTOMRIGHT")
	BottomEdge:SetPoint("BOTTOMRIGHT", BottomRight, "BOTTOMLEFT")
	BottomEdge:SetHeight(14)
	BottomEdge:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)
		
	local LeftEdge = self:CreateTexture(nil, "OVERLAY")
	LeftEdge:SetTexture(frameborder)
	LeftEdge:SetTexCoord(0, 1/3, 1/3, 2/3)
	LeftEdge:SetPoint("TOPLEFT", TopLeft, "BOTTOMLEFT")
	LeftEdge:SetPoint("BOTTOMLEFT", BottomLeft, "TOPLEFT")
	LeftEdge:SetWidth(14)
	LeftEdge:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)
		
	local RightEdge = self:CreateTexture(nil, "OVERLAY")
	RightEdge:SetTexture(frameborder)
	RightEdge:SetTexCoord(2/3, 1, 1/3, 2/3)
	RightEdge:SetPoint("TOPRIGHT", TopRight, "BOTTOMRIGHT")
	RightEdge:SetPoint("BOTTOMRIGHT", BottomRight, "TOPRIGHT")
	RightEdge:SetWidth(14)
	RightEdge:SetVertexColor(color_rb,color_gb,color_bb,alpha_fb)	



--== Plugins part ==--
	--== BarFader options ==--
	self.BarFade = true
	self.BarFadeMinAlpha = 0.1

	--== Debuff Highlight ==--
	self.DebuffHighlightBackdrop = true

	--== Let's swing ==--
 if unit == 'player' then
	self.Swing = CreateFrame('StatusBar',nil,self)
	self.Swing:SetWidth(230)
	self.Swing:SetHeight(4)
	self.Swing:SetPoint("BOTTOM", self, "TOP", 0, 8)
	self.Swing:SetStatusBarTexture(statusbar)
	self.Swing:SetStatusBarColor(70/255,70/255,70/255)
	
	self.Swing.Text = SetFontString(self.Swing, font, 12)
	self.Swing.Text:SetPoint('LEFT', self.Swing,'LEFT',4, 0)
	self.Swing.Text:SetWidth(225)
	self.Swing.Text:SetTextColor(1,1,1)
	self.Swing.Text:SetJustifyH('LEFT')

	self.Swing.disableMelee = true
	self.Swing.disableRanged = false
 end



	--== Reputation ==--
if unit == 'player' then
  if reputation == true  then
	self.Reputation = CreateFrame('StatusBar',nil,self)
	self.Reputation.MouseOver = true
	self.Reputation.Tooltip = true

	self.Reputation:SetWidth(230)
	self.Reputation:SetHeight(14)
	self.Reputation:SetPoint("TOP", self, "BOTTOM", 0, -26.75)
	self.Reputation:SetStatusBarTexture(statusbar)
	self.Reputation:SetStatusBarColor(7/255,79/255,86/255)

	self.Reputation:SetBackdrop(backdrop2)
	self.Reputation:SetBackdropColor(0,0,0,0.35)


	self.Reputation.Text = SetFontString(self.Reputation, font, 12)
	self.Reputation.Text:SetPoint('TOPLEFT', self.Reputation,'TOPLEFT',8, 0)
	self.Reputation.Text:SetWidth(225)
	self.Reputation.Text:SetTextColor(1,1,1)
	self.Reputation.Text:SetJustifyH('LEFT')
  end

	--== Experience ==--
  if experience == true then 
	self.Experience = CreateFrame('StatusBar',nil,self)
	self.Experience.MouseOver = true
	self.Experience.Tooltip = true

	self.Experience:SetWidth(230)
	self.Experience:SetHeight(14)
	self.Experience:SetPoint("TOP", self, "BOTTOM", 0, -36.50)
	self.Experience:SetStatusBarTexture(statusbar)
	self.Experience:SetStatusBarColor(7/255,79/255,86/255)


	self.Experience:SetBackdrop(backdrop2)
	self:SetBackdropColor(0,0,0,0.35)
	
  end
end
	
	--== oUF_PowerSpark ==--
--[[ Uncomment to enable it	
 	if unit == "player" then
 		-- Power spark!
 		local spark = pp:CreateTexture(nil, "OVERLAY")
 		spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
 		spark:SetVertexColor(1, 1, 1, 0.5)
 		spark:SetBlendMode("ADD")
 		spark:SetHeight(self.Power:GetHeight()*2)
 		spark:SetWidth(self.Power:GetHeight())
 		--  Options and settings
 		--spark.rtl = true
 		--    Make the spark go from Right To Left instead
 		--    Defaults to false
 		spark.manatick = true
 		--    Show mana regen ticks outside FSR (like the energy ticker)
 		--    Defaults to false
 		spark.highAlpha = 1
 		--    What alpha setting to use for the FSR and energy spark
 		--    Defaults to spark:GetAlpha()
 		spark.lowAlpha = 0.25
 		--    What alpha setting to use for the mana regen ticker
 		--    Defaults to highAlpha / 4
 		self.Spark = spark
 	end
]]--

--== End of plugin part ==--
	
	--== Health bar ==--
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint"TOP"
	self.Health:SetStatusBarTexture(statusbar)
	self.Health:SetHeight(16)	
	self.Health:SetStatusBarColor(70/255,70/255,70/255,1)
	self.Health:SetPoint"RIGHT"
	self.Health:SetPoint"LEFT"

	--== Health bar settings ==--
	self.Health.colorTapping = true
	self.Health.colorDisconnected = true 
	self.Health.colorClass = false
	self.Health.colorClassNPC = false

	
	--== The health text ==--
  if healthtext_opt == true then
	local healthtext = SetFontString(self.Health, font, 12) 	
	self:Tag(healthtext,'[gradienthp]')
	if unit == 'target' then
		healthtext:SetWidth(130)
		healthtext:SetJustifyH('RIGHT')
		healthtext:SetPoint('RIGHT', self.Health, 'RIGHT',-2,3.45)

	else
		healthtext:SetPoint('LEFT',self.Health,'LEFT',2.45,3.45)
		healthtext:SetJustifyH("LEFT")
	end
  end
	
	
	--== The power bar (mana, runic power,rage and energy) ==--
	self.Power = CreateFrame('StatusBar', nil, self)
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 1.45,-1.45 )
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1.45,-1.45 )
	self.Power:SetStatusBarTexture(statusbar)
	self.Power:SetHeight(5)
	self.Power:SetParent(self)

	--== The power bar settings ==--
	self.Power.colorClass = true
	self.Power.colorClassNPC = true
	self.Power.colorPower = false


	


	--== The Power texts customisation ==--
 if powertext_opt == true then
	local powertext = SetFontString(self.Power, font, 10)
	local class, enClass = UnitClass('player')
	if unit == 'player' then
		if enClass == 'DEATHKNIGHT' or enClass =='ROGUE' or enClass =='WARRIOR' then
			self:Tag(powertext,'[coloredmana]')
		else 
			self:Tag(powertext, '[coloredmanaper]')
		end
	powertext:SetPoint('RIGHT',self.Health,'RIGHT',-2.45,3.45)
	powertext:SetJustifyH('RIGHT')
	end
	
  end

	--== The druid mana again ==--
	if(playerClass == 'DRUID') then
		self.DruidPower = CreateFrame('StatusBar', nil, self)
		self.DruidPower:SetAllPoints(self.Power)
		self.DruidPower:SetStatusBarTexture(texture)
		self.DruidPower:SetHeight(1)
		self.DruidPower:SetWidth(230)
		self.DruidPower:SetAlpha(0)

		self.DruidPower.Text = SetFontString(self.Power, font, 10)
		self.DruidPower.Text:SetPoint('RIGHT', self.DruidPower)
		self.DruidPower.Text:SetTextColor(unpack(colors.power['MANA']))

		table.insert(self.__elements, UpdateDruidPower)
		self:RegisterEvent('UNIT_MANA', UpdateDruidPower)
		self:RegisterEvent('UNIT_ENERGY', UpdateDruidPower)
		self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', UpdateDruidPower)
	end
	--== Leader Icon ==--
  if leader == true then
	self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Leader:SetPoint('TOPLEFT', self, -1,1 )
	self.Leader:SetHeight(16)
	self.Leader:SetWidth(16)
  end

	--== Raid Icons ==--
  if RI == true then
	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetPoint('BOTTOM', self,'TOP' ,0,3)
	self.RaidIcon:SetHeight(16)
	self.RaidIcon:SetWidth(16)
	
   end
	--== The name customisation ==--
  if name_opt == true then
      if unit == "target" then
	local name = SetFontString(self.Health, font, 10) 
	name:SetJustifyH('LEFT')
	name:SetWidth(100)

	name:SetPoint('TOPLEFT',self.Health,'TOPLEFT',2.45,3.45)
	self:Tag(name,"[level][shortclassification] [raidcolor][shortname]")
		
      end
 end 
	
			

	--== Player Castbar ==--

  if playerCB == true then
	if unit == 'player' then 
			self.Castbar = CreateFrame('StatusBar', nil, self)
			self.Castbar:SetWidth(230)
			self.Castbar:SetHeight(10)
			self.Castbar:SetPoint("TOP", self, "BOTTOM", 0, -20.75)
			self.Castbar:SetStatusBarTexture(statusbar)
			self.Castbar:SetStatusBarColor(70/255,70/255,70/255)

		--== The spell casted ==--
			self.Castbar.Text = SetFontString(self.Castbar, font, 11)
			self.Castbar.Text:SetPoint('TOPLEFT', self.Castbar,'TOPLEFT',8, 0)
			self.Castbar.Text:SetWidth(225)
			self.Castbar.Text:SetTextColor(1,1,1)
			self.Castbar.Text:SetJustifyH('LEFT')

		--== The time to cast ==--
			self.Castbar.Time = SetFontString(self.Castbar, font, 9)
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -1, 1)
			self.Castbar.Time:SetTextColor(1,1,1)
			self.Castbar.Time:SetJustifyH('RIGHT')

		--== A little background ==--
			self.Castbar:SetBackdrop(backdrop2)
			self.Castbar:SetBackdropColor(0,0,0,0.35)



			--[[self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
			self.Castbar.Icon:SetPoint('LEFT', self.Castbar,'RIGHT',3,0)
			self.Castbar.Icon:SetHeight(18)
			self.Castbar.Icon:SetWidth(18)]]
		
		--== The safezone 
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil,'BORDER')
			self.Castbar.SafeZone:SetTexture(222/255,126/255,0,.75)
			
	end
  end
	
	--== Target Castbar, everything is like the previous cast bar  ==--
  
	if unit == 'target' then 
	  if targetCB == true then
			self.Castbar = CreateFrame('StatusBar', nil, self)
			self.Castbar:SetWidth(230)
			self.Castbar:SetHeight(10)
			self.Castbar:SetPoint("TOP", self, "BOTTOM", 0, -20.75)
			self.Castbar:SetStatusBarTexture(statusbar)
			self.Castbar:SetStatusBarColor(70/255,70/255,70/255)


			self.Castbar.Text = SetFontString(self.Castbar, font, 11)
			self.Castbar.Text:SetPoint('RIGHT', self.Castbar,'RIGHT',-2, 0)
			self.Castbar.Text:SetJustifyH('RIGHT')
			self.Castbar.Text:SetWidth(225)
			self.Castbar.Text:SetTextColor(1,1,1)

			self.Castbar.Time = SetFontString(self.Castbar, font, 9)
			self.Castbar.Time:SetPoint('LEFT', self.Castbar,1, 1)
			self.Castbar.Time:SetTextColor(1,1,1)
			self.Castbar.Time:SetJustifyH('LEFT')

			

			self.Castbar:SetBackdrop(backdrop2)
			self.Castbar:SetBackdropColor(0,0,0,0.35)

			

			--[[self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
			self.Castbar.Icon:SetPoint('RIGHT', self.Castbar,'LEFT',-3,0)
			self.Castbar.Icon:SetHeight(18)
			self.Castbar.Icon:SetWidth(18)]]
	  end 
			
			--== Target Buffs ==--
	  if target_buff == true then
			self.Buffs = CreateFrame('Frame', nil, self)
			self.Buffs.size = 16 * 1.1
			self.Buffs["growth-x"] = "RIGHT"
			self.Buffs["growth-y"] = "UP"
			self.Buffs.spacing = 4.3
			self.Buffs:SetHeight(self.Buffs.size)
			self.Buffs:SetWidth(self.Buffs.size * 6)
			self.Buffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 7.45, -1.45)
	  end		
		
			--== Target Debuffs ==--
	  if target_debuff == true then		
			self.Debuffs = CreateFrame('Frame', nil, self)
			self.Debuffs.size = 19 * 1.1
			self.Debuffs.spacing = 4.3
			self.Debuffs:SetHeight(self.Debuffs.size)
			self.Debuffs:SetWidth(self.Debuffs.size * 6)
			self.Debuffs['growth-y'] = 'UP'
			self.Debuffs['growth-x'] = 'RIGHT'
			self.Debuffs.showDebuffType = true
			self.Debuffs.num = 40
			self.Debuffs.filter = false
			self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7.75)
	  end
	end


			--== Set the height and the width of our frames ==--

	if unit == 'player' or unit == 'target' then
		self:SetAttribute('initial-height', 21)        -- the frames' height 
	   	 self:SetAttribute('initial-width', 230)        -- the frames' width
	end
	
	self.PostCreateAuraIcon = auraIcon
			
	return self
end


oUF:RegisterStyle("Deith_Normal", Style)
oUF:SetActiveStyle("Deith_Normal")

oUF:Spawn("player"):SetPoint("RIGHT", UIParent, "CENTER", -200, -150)
oUF:Spawn("target"):SetPoint("LEFT", UIParent, "CENTER", 200, -150)

--== Options ==--
-- 1 to enable; false to disable
local background = true --little background behind the unit frames
local healthtext_opt = true --text for health or not
local leader = true -- leader icon or not
local RI = true  -- raid icons or not
local name_opt = true -- name text or not

--== Textures Options ==--
local color
local frameborder = "Interface\\AddOns\\oUF_Deith\\media\\frameborder3"
local font, fontsize = "Fonts\\FRIZQT__.ttf", 12		-- The font and fontsize
local backdrop = {
 		bgFile = "Interface\\AddOns\\oUF_Deith\\media\\HalBackgroundA", tile = true, tileSize = 16,
		insets = {left = -2, right = -2, top = -2, bottom = -2},
	}
local backdrop2 = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	insets = {top = -3, left = -3, bottom = -2, right = -3},
}
--local statusbar = "Interface\\AddOns\\RaccoonUI\\textures\\dP"
local statusbar = [[Interface\Addons\oUF_Deith\media\DsmV1]]
local border = "Interface\\AddOns\\oUF_Deith\\media\\border"		-- Buff borders
local playerClass = select(2, UnitClass("player"))
local color_rb = 0
local color_gb = 0
local color_bb = 0
local alpha_fb = 0.35
--== End of textures options ==--

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

local function Style(self, unit)
	self.colors = colors
	self.menu = menu
	self:RegisterForClicks('AnyUp')
	self:SetAttribute('*type2', 'menu')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	--== Unit Backgrounds ==--
if background == true then
	self:SetBackdrop(backdrop2)
	self:SetBackdropColor(0,0,0,0.35)
end

	--== BarFader options ==--
	self.BarFade = true
	self.BarFadeMinAlpha = 0.15
	
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint"TOP"
	self.Health:SetStatusBarTexture(statusbar)
	self.Health:SetStatusBarColor(70/255,70/255,70/255)
	self.Health:SetHeight(7)
	self.Health:SetPoint"RIGHT"
	self.Health:SetPoint"LEFT"
	self.Health.colorDisconnected = true 
	self.Health.colorClass = false
	
if healthtext_opt == true then
	local Healthtext = SetFontString(self.Health, font, 12) 
	Healthtext:SetPoint('BOTTOM',self,'TOP',0,2)
	Healthtext:SetJustifyH('LEFT')
	self:Tag(Healthtext,'[gradienthp]')
	if unit == 'focus' or unit == 'pet' then
		Healthtext:ClearAllPoints()
		Healthtext:SetPoint('TOP', self, 'BOTTOM',0,-3.45)
	end
	if unit == 'targettarget' then
		Healthtext:Hide()
	end
end	


	
	--== Leader Icon ==--
if leader == true then
	self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Leader:SetPoint('TOPRIGHT', self, -1,-1 )
	self.Leader:SetHeight(16)
	self.Leader:SetWidth(16)
end

	--== Raid Icons ==--
if RI == true then
	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetPoint('BOTTOM', self.Portrait,'TOP' ,0,3)
	self.RaidIcon:SetHeight(16)
	self.RaidIcon:SetWidth(16)
end

	--== The name customisation ==--
if name_opt == true then
	local Name = SetFontString(self.Health, font, 10) 
	Name:SetPoint('RIGHT',self,'LEFT',0,-.45) 
	self:Tag(Name,'[raidcolor][name]|r [level] [shortclassification] ')
	if unit == 'targettarget' then
		Name:ClearAllPoints()
		Name:SetPoint('BOTTOM',self,'TOP',0,2)
	end
end
	

	self:SetAttribute('initial-height', 7)        -- the frames' height 
	self:SetAttribute('initial-width', 100)        -- the frames' width
	
	
	return self
end


oUF:RegisterStyle("Deith_Small", Style)
oUF:SetActiveStyle("Deith_Small")

oUF:Spawn("pet"):SetPoint("TOPRIGHT", oUF.units.player, "TOPLEFT", -12.45, -1.45)			-- Positions goes here!
oUF:Spawn("targettarget"):SetPoint("BOTTOMRIGHT", oUF.units.target, "TOPRIGHT",-1.45, 10.45)
oUF:Spawn("focus"):SetPoint("BOTTOMRIGHT", oUF.units.player, "BOTTOMLEFT", -12.45, 1.45)
		

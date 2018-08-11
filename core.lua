local addon, bdq = ...
local config = bdCore.config.profile['Quests']

-------------------------------------------------------
-- 
-------------------------------------------------------


function createScrollFrame()
	--parent frame 
	local frame = CreateFrame("Frame", "MyFrame", UIParent) 
	frame:SetSize(config.width, config.height) 
	frame:SetPoint("CENTER") 
	
	local texture = frame:CreateTexture() 
	texture:SetAllPoints() 
	texture:SetTexture(1,1,1,1) 
	frame.background = texture 

	--scrollframe 
	scrollframe = CreateFrame("ScrollFrame", nil, frame) 
	scrollframe:SetPoint("TOPLEFT", 10, -10) 
	scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 
	local texture = scrollframe:CreateTexture() 
	texture:SetAllPoints() 
	texture:SetTexture(.5,.5,.5,1) 
	frame.scrollframe = scrollframe 

	--scrollbar 
	scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
	scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -16) 
	scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 4, 16) 
	scrollbar:SetMinMaxValues(1, 200) 
	scrollbar:SetValueStep(1) 
	scrollbar.scrollStep = 1 
	scrollbar:SetValue(0) 
	scrollbar:SetWidth(16) 
	scrollbar:SetScript("OnValueChanged", 
	function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
	end) 
	local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
	scrollbg:SetAllPoints(scrollbar) 
	scrollbg:SetTexture(0, 0, 0, 0.4) 
	frame.scrollbar = scrollbar 

	--content frame 
	local content = CreateFrame("Frame", nil, scrollframe) 
	content:SetSize(config.width, 2000) 
	local texture = content:CreateTexture() 
	texture:SetAllPoints() 
	texture:SetTexture("Interface\\GLUES\\MainMenu\\Glues-BlizzardLogo") 
	content.texture = texture 
	scrollframe.content = content 

	scrollframe:SetScrollChild(content)

	return content
end

-- createScrollFrame()
--parent frame 
--[[
local frame = CreateFrame("Frame", "bdQuests", UIParent) 
frame:SetSize(150, 200) 
frame:SetPoint("CENTER") 
frame.scrollframe = CreateFrame("ScrollFrame", nil, frame) 
frame.scrollframe:SetPoint("TOPLEFT", 10, -10) 
frame.scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 
frame.scrollbar = CreateFrame("Slider", nil, frame.scrollframe, "UIPanelScrollBarTemplate") 
frame.scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -16) 
frame.scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 4, 16) 
frame.scrollbar:SetMinMaxValues(1, 200) 
frame.scrollbar:SetValueStep(1) 
frame.scrollbar.scrollStep = 1
frame.scrollbar:SetValue(0) 
frame.scrollbar:SetWidth(16) 
frame.scrollbar:SetScript("OnValueChanged", 
function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end) 
 
--content frame 
frame.scrollframe.content = CreateFrame("Frame", nil, frame.scrollframe) 
frame.scrollframe.content:SetSize(128, 128) 
frame.scrollframe:SetScrollChild(frame.scrollframe.content)

local main = frame.scrollframe.content

bdCore:makeMovable(frame)--]]
-- bdCore:setBackdrop(main)

bdq.main = CreateFrame("frame", "bdQuests", UIParent)
-- bdq.main:SetSize(config.width + 46, config.height)
-- bdq.main:SetPoint("RIGHT", UIParent, "RIGHT", -20, 0)


--scrollframe 
local scrollframe = CreateFrame("ScrollFrame", nil, bdq.main) 
scrollframe:SetAllPoints()
local mask = CreateFrame("Frame", nil, scrollframe) 
mask:SetSize(config.width + 140, config.height + 4)
local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", bdq.main, "TOPRIGHT", 4, -14) 
scrollbar:SetPoint("BOTTOMLEFT", bdq.main, "BOTTOMRIGHT", 4, 14) 
scrollbar:SetMinMaxValues(1, 200) 
scrollbar:SetValueStep(1) 
scrollbar.scrollStep = 1
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar:SetScript("OnValueChanged", function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end) 
local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg:SetAllPoints(scrollbar) 
scrollbg:SetTexture(0, 0, 0, 0.4)

-- set
bdq.main.scrollframe = scrollframe 
bdq.main.scrollbar = scrollbar
scrollframe.content = mask 
scrollframe:SetScrollChild(mask)

bdq.main.content = CreateFrame("Frame", nil, mask)
bdq.main.content:SetSize(config.width, 30)
bdq.main.content:SetPoint("TOP", mask, "TOP", -10, 0)
bdq.main.content:SetPoint("BOTTOM", mask, "BOTTOM", -10, 0)


-- local bdq.main = 


LoadAddOn('Blizzard_ObjectiveTracker')
-- ObjectiveTrackerFrame:ClearAllPoints()
-- ObjectiveTrackerFrame:SetParent(bdq.main.content)
-- ObjectiveTrackerFrame:SetPoint("TOPLEFT", bdq.main.content, "TOPLEFT")
-- ObjectiveTrackerFrame:SetPoint("BOTTOMRIGHT", bdq.main.content, "BOTTOMRIGHT")
bdq.anchor = CreateFrame("frame", "bdQuests", UIParent)
bdq.anchor:SetSize(config.width, 40)
bdq.anchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -240)
bdCore:makeMovable(bdq.anchor)

-- ObjectiveTrackerBlocksFrame:SetParent(main)
ObjectiveTrackerBlocksFrame:SetPoint("TOPLEFT", bdq.anchor, "TOPLEFT", 0)

local function reskinHeader(header)

end

local function noAnimation(frame)
	if (not frame) then return end
	local children = {frame:GetChildren()}

	for k, frame in pairs(children) do
		local ani_group = {frame:GetAnimationGroups()}
		-- user placed frames don't animate
		frame:SetMovable(true)
		frame:SetUserPlaced(true)
		frame:SetDontSavePosition(true)
		if (not ani_group.hooked) then
			if (ani_group) then
				for a, anis in pairs(ani_group) do

					-- end all animations
					local ani_singles = {anis:GetAnimations()}
					for b, as in pairs(ani_singles) do
						as:SetDuration(0)
						as:SetStartDelay(0)
						as:SetEndDelay(0)

					end
				end
			end
		end

		if (frame:GetChildren()) then
			noAnimation(frame)
		end
	end
end

local function stripTextures(frame)
	local textures = {frame:GetRegions()}
	for k, v in pairs(textures) do
		if (v:GetObjectType() == "Texture") then
			v:Hide()
			v.Show = function() return end
		end
	end
end

local function kill(frame)
	if (not frame) then return end
	frame:Hide()
	frame.Show = function() return end
end

OBJECTIVE_TRACKER_HEADER_OFFSET_X = 0
OBJECTIVE_TRACKER_LINE_WIDTH = config.width
OBJECTIVE_TRACKER_HEADER_HEIGHT = 40
OBJECTIVE_TRACKER_ITEM_WIDTH = 24

DEFAULT_OBJECTIVE_TRACKER_MODULE.blockOffsetY = -20
DEFAULT_OBJECTIVE_TRACKER_MODULE.fromHeaderOffsetY = -10
DEFAULT_OBJECTIVE_TRACKER_MODULE.fromModuleOffsetY = -20
DEFAULT_OBJECTIVE_TRACKER_MODULE.lineSpacing = 8

-- todo: move this to an event system rather than on update
bdq.main:SetScript("OnUpdate", function()
	noAnimation(ObjectiveTrackerBlocksFrame)
	--ObjectiveTrackerBlocksFrame:StopAnimating()

	-- Headers
	local children = {ObjectiveTrackerBlocksFrame:GetChildren()}
	for k, frame in pairs(children) do
		-- scrollHeight = scrollHeight + frame:GetHeight()
		-- World Quests
		if (frame.ScrollContents and not frame.hooked) then
			frame.hooked = true
			local wqs = {frame.ScrollContents:GetChildren()}
			for k, wq in pairs(wqs) do
				--print(wq.Text:GetText())
			end
		end

		-- Individual Quests
		if (frame.HeaderText and not frame.hooked) then
			frame.hooked = true

			local r, g, b, a = 0, 0, 0, 0

			frame.title = frame:CreateTexture(nil, "BACKGROUND")
			frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT")
			frame.title:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -24)
			frame.title:SetTexture(bdCore.media.flat)
			frame.title:SetVertexColor(r, g, b, .5)

			frame.content = frame:CreateTexture(nil, "BACKGROUND")
			frame.content:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT")
			frame.content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, -6)
			frame.content:SetTexture(bdCore.media.flat)
			frame.content:SetVertexColor(r, g, b, .2)


			frame.HeaderText:SetPoint("TOPLEFT", frame, "TOPLEFT")
			frame.HeaderText:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -24)
			frame.HeaderText:SetJustifyH("CENTER")
			frame.HeaderText:SetJustifyV("MIDDLE")
			frame.HeaderText:SetFont(bdCore.media.font, 14, "OUTLINE")
			frame.HeaderText:SetShadowColor(0,0,0,0)

			--print(frame.HeaderText:GetText())
		end

		if (frame.currentLine and not frame.hooked) then
			frame.currentLine.Text:SetText("   "..frame.currentLine.Text:GetText())
		end

		-- Headers
		if (not frame.hooked and frame.Text) then
			frame.hooked = true

			stripTextures(frame)
			frame:SetHeight(30)
			frame.Text:SetAllPoints(frame)
			frame.Text:SetJustifyH("CENTER")
			frame.Text:SetFont(bdCore.media.font, 15, "OUTLINE")
			frame.Text:SetShadowColor(0,0,0,0)
			--frame.Text:SetTextColor( unpack(bdCore.media.blue) )

			local r, g, b, a = 0,0,0,0
			frame:SetBackdrop({ bgFile = bdCore.media.flat, edgeFile = bdCore.media.flat, edgeSize = 2})
			frame:SetBackdropColor(r, g, b, .7)

			frame:SetBackdropBorderColor(0,0,0,1)


			--[[

				frame.background = frame:CreateTexture('bdbackground', "BORDER", nil, -7)
				frame.background:SetTexture(bdCore.media.flat)
				frame.background:SetAllPoints(frame)
				frame.background:SetVertexColor(r, g, b, 1)
				frame.background:SetAlpha(0.4)
				
			local r, g, b, a = unpack(bdCore.media.border);
				frame.border = frame:CreateTexture('bdborder', "BACKGROUND", nil, -8)
				frame.border:SetTexture(bdCore.media.flat)
				frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
	--			frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)--]]
			--[[	frame.border:SetVertexColor(r, g, b, 1)--]]

		end
	end
end)






-- function ObjectiveTrackerTimerBar_OnUpdate(self, elapsed)
-- 	print("here")
-- end

bdq.main:RegisterEvent("QUEST_ACCEPTED")
--bdq.main:RegisterEvent("QUEST_REMOVED")
bdq.main:SetScript("OnEvent", function(self, event, arg1, arg2)
	--ObjectiveTracker_Update(nil, arg2)

	--[[ObjectiveTracker_ReorderModules();
	local tracker = ObjectiveTrackerFrame
	for i = 1, #tracker.MODULES do
	 	local module = tracker.MODULES[i];
		 module:StaticReanchor();
		 ObjectiveTracker_CheckAndHideHeader(tracker.MODULES[i].Header);
	 	--module:Update();
	end--]]
	--print(event, ...)
end)


-- _G['ObjectiveTrackerHeaderTemplate']:SetScript("OnPlay", function(self)
-- 	print("startyed")
-- 	self:Finish()
-- end)
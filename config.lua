local addon, bdq = ...

local c = {}
function bdq:configCallback() bdCore:triggerEvent("bdQuests_reconfig") end

-- Sizing
c[#c+1] = {tab = {
	type= "tab",
	value = "Sizing & Display"
}}
	c[#c+1] = {height = {
		label = "Height",
		type= "slider",
		value=500,
		min=100,
		step=2,
		max=1400,
		callback = bdq.configCallback
	}}

	c[#c+1] = {width = {
		label = "Width",
		type= "slider",
		value=250,
		min=100,
		step=2,
		max=500,
		callback = bdq.configCallback
	}}

-- Automation
c[#c+1] = {tab = {
	type= "tab",
	value = "Automation"
}}


bdCore:addModule("Quests", c)
local config = bdCore.config.profile['Quests']

SetCVar('showQuestTrackingTooltips', '1')
SetCVar('UnitNameFriendlySpecialNPCName', 1)
SetCVar('showQuestUnitCircles', 1)
local addon, bdq = ...

local c = {}
function bdq:configCallback() bdCore:triggerEvent("bdQuests_reconfig") end

-- Sizing
c[#c+1] = {tab = {
	type= "tab",
	value = "Sizing & Display"
}}
	c[#c+1] = {height = {
		type= "slider",
		value=500,
		min=100,
		step=2,
		max=1400,
		callback = bdq.configCallback
	}}

	c[#c+1] = {width = {
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


SetCVar('showQuestTrackingTooltips', '1')
SetCVar('UnitNameFriendlySpecialNPCName', 1)
SetCVar('showQuestUnitCircles', 1)
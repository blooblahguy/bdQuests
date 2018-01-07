local addon, bdq = ...
local config = bdCore.config.profile['Quests']

-- Main Window
bdq.main = CreateFrame("frame", 'bdQuests', UIParent)
bdq.main:SetSize(config.width, config.height)
bdq.main:SetPoint("LEFT", UIParent, "LEFT", 20, 0)	
bdCore:setBackdrop(bdq.main)
bdCore:makeMovable(bdq.main)

local aq = bdq.activeQuests
local awq = bdq.activeWorldQuests

local headerframes = {}
local titleframes = {}
local objectiveframes = {}

function bdq:CreateHeader(text)
	local frame = table.remove(headerframes) or CreateFrame("Frame", nil, UIParent)
end

function bdq:CreateTitle(text)
	local frame = table.remove(titleframes) or CreateFrame("Frame", nil, UIParent)
end


--[[
for i = 1, 30 do
	local entry = CreateFrame("frame", "bdQuests_"..i, bdq.main)

	entry.title = CreateFrame("frame", nil, entry)
	entry.title.text = entry.title:CreateFontString(nil)
	entry.title.text:SetAllPoints()
	entry.title.text:SetJustifyH("CENTER")
	entry.title.text:SetFont(bdCore.media.font, 13)
	entry.title.text:SetTextColor(unpack(bdCore.media.blue))
	entry.title.SetText = entry.title.text.SetText

	entry.info = CreateFrame("frame", nil, entry)
	entry.info.text = entry.info.text:CreateFontString(nil)
	entry.info.text:SetAllPoints()
	entry.info.text:SetJustifyH("LEFT")
	entry.info.text:SetFont(bdCore.media.font, 13)
	entry.info.SetText = entry.info.text.SetText


end--]]


local QuestLogIndex = {}
local QuestObjectiveStrings = {}

function bdq.redraw()
	local index = 1
	for k, v in pairs(awq) do
		
		index = index + 1
	end

	for k, v in pairs(aq) do


		index = index + 1
	end
end

function bdq.update(self, event, ...)

	local quests = GetNumQuestLogEntries()
	local watched = GetNumQuestWatches()



	local zoneid = select(1, GetCurrentMapAreaID())
	-- Summary Bar 

	-- Active world quests
	if (event == "PLAYER_LOGIN") then
		for k, task in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(zoneid)) do
			if task.inProgress then
				-- track active world quests
				local questID = task.questId
				local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
				if questName then
					print(k, questID, questName)
					awq[ questName ] = questID
				end
			end
		end
	end

	if (event == "QUEST_ACCEPTED") then
		local questLogIndex, questID = ...
		if IsQuestTask(questID) then
			print('TASK_QUEST_ACCEPTED', questID, questLogIndex, GetQuestLogTitle(questLogIndex))
			local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
			if questName then
				awq[ questName ] = questID
			end
		else
			print('QUEST_ACCEPTED', questID, questLogIndex, GetQuestLogTitle(questLogIndex))
		end
	end

	if (event == "QUEST_REMOVED") then
		local questID = ...
		local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
		if questName and ActiveWorldQuests[ questName ] then
			awq[ questName ] = nil
			print('TASK_QUEST_REMOVED', questID, questName)
			-- get task progress when it's updated to display on the nameplate
			-- C_TaskQuest.GetQuestProgressBarInfo
		end
	end

	if (event == "UNIT_QUEST_LOG_CHANGED") then
		local unitID = ...
	end

	if (event == 'QUEST_LOG_UPDATE') then
		wipe(QuestLogIndex)
		for i = 1, GetNumQuestLogEntries() do
			-- for i = 1, GetNumQuestLogEntries() do if not select(4,GetQuestLogTitle(i)) and select(11,GetQuestLogTitle(i)) then QuestLogPushQuest(i) end end
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory = GetQuestLogTitle(i)
			if not isHeader then
				QuestLogIndex[title] = i
				for objectiveID = 1, GetNumQuestLeaderBoards(i) or 0 do
					local objectiveText, objectiveType, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(questID, objectiveID, false)
					--if objectiveText then
						aq[ title .. objectiveText ] = {questID, objectiveID, i, isBounty}
					--endSS
				end
			else
				--print(title,isTask)
			end
		end
		
		--[[for plate, f in pairs(addon:GetActiveNameplates()) do
			UpdateQuestIcon(plate, f._unitID)
		end--]]
	end

	-- Activity Bar

	-- Quest progress/displays
	--print(aq, #aq)
	for k, v in pairs(aq) do
		print(k, unpack(v))
	end
	
	bdq:redraw();
end

bdq.main:RegisterEvent("PLAYER_LOGIN")
bdq.main:RegisterEvent("QUEST_ACCEPTED")
bdq.main:RegisterEvent("QUEST_REMOVED")
bdq.main:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
bdq.main:RegisterEvent("QUEST_LOG_UPDATE")
bdq.main:SetScript("OnEvent", bdq.update)

-- display
	-- summary bar (# completed, # within 500 yds, x/25 if > 20)
	-- active world quests
	-- activity bar
	-- super tracked quest (the one with the arrow)
	-- quests < 100 yards away
	-- watched quests
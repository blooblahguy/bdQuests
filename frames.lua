local addon, bdq = ...

-- Main Window
bdq.main = CreateFrame("frame", nil, UIParent)
bdq.main:SetSize(config.width, config.height)
bdq.main:SetPoint("RIGHT", UIParent, "RIGHT", -20, 0)
bdCore:setBackdrop(bdq.main)
bdCore:makeMovable(bdq.main)

bdq.activeQuests = {}
local aq = bdq.activeQuests

function bdq.main:update(self, event, ...)

	local quests = GetNumQuestLogEntries()
	local watched = GetNumQuestWatches()

	-- Summary Bar 

	-- Active world quests
	if (event == "PLAYER_LOGIN") then
		for k, task in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(GetCurrentMapAreaID())) do
			if task.inProgress then
				-- track active world quests
				local questID = task.questId
				local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
				if questName then
					print(k, questID, questName)
					ActiveWorldQuests[ questName ] = questID
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
				ActiveWorldQuests[ questName ] = questID
			end
		else
			print('QUEST_ACCEPTED', questID, questLogIndex, GetQuestLogTitle(questLogIndex))
		end
	end

	if (event == "QUEST_REMOVED") then
		local questID = ...
		local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
		if questName and ActiveWorldQuests[ questName ] then
			ActiveWorldQuests[ questName ] = nil
			print('TASK_QUEST_REMOVED', questID, questName)
			-- get task progress when it's updated to display on the nameplate
			-- C_TaskQuest.GetQuestProgressBarInfo
		end
	end

	if (event == "UNIT_QUEST_LOG_CHANGED") then
		local unitID = ...
	end

	-- Activity Bar

	-- Quest progress/displays
end

bdq.main:RegisterEvent("PLAYER_LOGIN")
bdq.main:RegisterEvent("QUEST_ACCEPTED")
bdq.main:RegisterEvent("QUEST_REMOVED")
bdq.main:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
bdq.main:RegisterEvent("QUEST_LOG_UPDATE")
bdq.main:SetScript("OnEvent", bdq.main.update)

-- display
	-- summary bar (# completed, # within 500 yds, x/25 if > 20)
	-- active world quests
	-- activity bar
	-- super tracked quest (the one with the arrow)
	-- quests < 100 yards away
	-- watched quests
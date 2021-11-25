local QBCore = exports['qb-core']:GetCoreObject()
cooldown = 0
ispriority = false
ishold = false


QBCore.Functions.CreateCallback('qb-scoreboard:server:GetCurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
	local ArmyCount = 0
    local AmbulanceCount = 0
    
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceCount = PoliceCount + 1
            end
			if (Player.PlayerData.job.name == "army" and Player.PlayerData.job.onduty) then
                ArmyCount = ArmyCount + 1
            end

            if ((Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
                AmbulanceCount = AmbulanceCount + 1
            end
        end
    end

    cb(PoliceCount, ArmyCount, AmbulanceCount)
end)

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetConfig', function(source, cb)
--if Player.PlayerData.job.name == "police" then
    cb(Config.IllegalActions, Config.IllegalActions2)
--	end
--	if Player.PlayerData.job.name == "army" then
	-- cb()
--	end
end)


QBCore.Functions.CreateCallback('qb-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            players[Player.PlayerData.source] = {}
            players[Player.PlayerData.source].permission = QBCore.Functions.IsOptin(Player.PlayerData.source)
        end
    end
    cb(players)
end)

RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
	Config.IllegalActions2[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)


QBCore.Commands.Add("priority", "إعلان أولوية", {}, false, function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.PlayerData.job.name == "police" or xPlayer.PlayerData.job.name == "army" then
    TriggerEvent("cooldownt")
	TriggerClientEvent('chatMessage', -1, "النظام", "error", "تم تفعيل نظام الأولوية")
	else
TriggerClientEvent('chatMessage', -1, "خطأ", "error", "الأمر متاح للشرطة فقط")	
		end
end)

QBCore.Commands.Add("cancelpriority", "إلغاء الأولوية", {}, false, function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.PlayerData.job.name == "police" or xPlayer.PlayerData.job.name == "army" then
    TriggerEvent("cancelcooldown")
TriggerClientEvent('chatMessage', -1, "النظام", "error", "تم إلغاء نظام الأولوية")	
	else
TriggerClientEvent('chatMessage', -1, "خطأ", "error", "الأمر متاح للشرطة فقط")			
		end
end)

RegisterNetEvent('isPriority', function()
	ispriority = true
	Wait(1)
	TriggerClientEvent('UpdatePriority', -1, ispriority)
end)

RegisterNetEvent('isOnHold',function()
	ishold = true
	Wait(1)
	TriggerClientEvent('UpdateHold', -1, ishold)
end)

RegisterNetEvent('isHoldOrnot', function()
	if ishold == true then
	Wait(1)
	TriggerClientEvent('UpdateHold', -1, ishold)
	end
end)

RegisterNetEvent("cooldownt", function()
	if ispriority == true then
		ispriority = false
		TriggerClientEvent('UpdatePriority', -1, ispriority)
	end
	Wait(1)
	if ishold == true then
		ishold = false
		TriggerClientEvent('UpdateHold', -1, ishold)
	end
	Wait(1)
	if cooldown == 0 then
		cooldown = 0
		cooldown = cooldown + 21
		while cooldown > 0 do
			cooldown = cooldown - 1
			TriggerClientEvent('UpdateCooldown', -1, cooldown)
			Wait(60000)
		end
	elseif cooldown ~= 0 then
		CancelEvent()
	end
end)

RegisterNetEvent("cancelcooldown", function()
	Wait(1)
	while cooldown > 0 do
		cooldown = cooldown - 1
		TriggerClientEvent('UpdateCooldown', -1, cooldown)
		Wait(100)
	end
	
end)
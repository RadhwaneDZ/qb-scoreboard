local QBCore = exports['qb-core']:GetCoreObject()
local scoreboardOpen = false
local PlayerOptin = {}
local cooldown = 0
local ispriority = false
local ishold = false
local PlayerJob = {}
-- Functions

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end
    
    return closePlayers
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
	PlayerJob = QBCore.Functions.GetPlayerData().job
	
	if PlayerJob and PlayerJob.name ~= "police" then
    QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetConfig', function(config)
        Config.IllegalActions = config
    end)
	end
	if PlayerJob and PlayerJob.name ~= "army" then
	 QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetConfig', function(config)
		 Config.IllegalActions2 = config
    end)
	end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
if PlayerJob.name == "police" then
    Config.IllegalActions[activity].busy = busy
end
if PlayerJob.name == "army" then
	Config.IllegalActions2[activity].busy = busy
	end
end)

RegisterCommand('scoreboard', function()
    if not scoreboardOpen then
        QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetPlayersArrays', function(playerList)
            QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetActivity', function(cops, armys, ambulance)
                QBCore.Functions.TriggerCallback("qb-scoreboard:server:GetCurrentPlayers", function(Players)
                    PlayerOptin = playerList
                    Config.CurrentCops = cops
					Config.CurrentArmys = armys

                    SendNUIMessage({
                        action = "open",
                        players = Players,
                        maxPlayers = Config.MaxPlayers,
                        requiredCops = Config.IllegalActions,
						requiredArmys = Config.IllegalActions2,
                        currentCops = Config.CurrentCops,
						currentArmys = Config.CurrentArmys,
                        currentAmbulance = ambulance
                    })
                    scoreboardOpen = true
                end)
            end)
        end)
    else
        SendNUIMessage({
            action = "close",
        })
        scoreboardOpen = false
    end
end)

CreateThread(function()
    while true do
        if scoreboardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 5.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)

                if Config.ShowIDforALL or PlayerOptin[PlayerId].permission then
                    DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.5, '['..PlayerId..']')
                end
            end
        end
        Wait(5)
    end
end)

RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)

RegisterNetEvent('UpdateCooldown')
AddEventHandler('UpdateCooldown', function(newCooldown)
    cooldown = newCooldown
	TriggerEvent('chatMessage', "SYSTEM", "error", "تم تفعيل نظام الأولوية يمنع عمل اي عمل اجرامي")
	--PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('UpdatePriority')
AddEventHandler('UpdatePriority', function(newispriority)
    ispriority = newispriority
end)

RegisterNetEvent('UpdateHold')
AddEventHandler('UpdateHold', function(newishold)
    ishold = newishold
end)

CreateThread(function()
	while true do
		Wait(0)
		if ishold == true then
			DrawText2("~w~Algerian Roleplay ~r~ﺔﻳﻮﻟﻭﻷﺍ ﻡﺎﻈﻧ: ~r~ﻡﺍﺮﺟﻷﺍ ﻊﻨﻤﻳ",0.015 ,0.)
        else
            if cooldown <= 0 then
               -- DrawText2("~w~Algerian Roleplay ~r~ﺔﻳﻮﻟﻭﻷﺍ ﻡﺎﻈﻧ : ~w~".. cooldown .." ~w~ﺔﻘﻴﻗﺩ",0.005 ,0)
            else
               -- DrawText2('~w~Algerian Roleplay | ~w~Priority Cooldown: ~w~'.. cooldown ..' ~w~Mins')
                DrawText2("~w~Algerian Roleplay ~r~ﺔﻳﻮﻟﻭﻷﺍ ﻡﺎﻈﻧ : ~w~".. cooldown .." ~w~ﺔﻘﻴﻗﺩ",0.005 ,0)
            end
		end
	end
end)

function DrawText2(text)
        RegisterFontFile('out')
        fontId = RegisterFontId('Arb')
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextScale(0.0, 0.30)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(0.789, 0.950)
end
Config = Config or {}

-- Open scoreboard key
Config.OpenKey = 'HOME' 

-- Max Server Players
Config.MaxPlayers = GetConvarInt('sv_maxclients', 64) -- It returnes 64 if it cant find the Convar Int

-- Minimum Police for Actions
Config.IllegalActions = {
    ["houserobbery"] = { -- police 
        minimum = 2,
        busy = false,
    },
    ["citznebrob"] = { -- police 
        minimum = 3,
        busy = false,
    },
    ["storerobbery"] = { -- police 
        minimum = 3,
        busy = false,
    },
    ["ammunation"] = { -- police 
        minimum = 3,
        busy = false,
    },
    ["policerob"] = { -- police 
        minimum = 4,
        busy = false,
    },
	    ["jewellery"] = { -- police 
        minimum = 5,
        busy = false,
    },
   -- ["ikearobbery"] = {
   --     minimum = 5,
   --     busy = false,
   -- },

    --["truckrob"] = {
    --    minimum = 5,
    --    busy = false,
    --},
    --["bankrobbery"] = {
    --    minimum = 5,
    --    busy = false,
    --},
    --["pacific"] = {
    --    minimum = 6,
    --    busy = false,
    --},
   -- ["humanelabs"] = {
   --     minimum = 7,
   --     busy = false,
   -- },
}
Config.IllegalActions2 = {

    ["ikearobbery"] = {
        minimum = 4,
        busy = false,
    },
    ["truckrob"] = {
        minimum = 5,
        busy = false,
    },
    ["bankrobbery"] = {
        minimum = 5,
        busy = false,
    },
    ["pacific"] = {
        minimum = 6,
        busy = false,
    },
    ["humanelabs"] = {
        minimum = 7,
        busy = false,
    },
}

-- Current Cops Online
Config.CurrentCops = 0
Config.CurrentArmys = 0

-- Current Ambulance / Doctors Online
Config.CurrentAmbulance = 0

-- Show ID's for all players or Opted in Staff
Config.ShowIDforALL = true
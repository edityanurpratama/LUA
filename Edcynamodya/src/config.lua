-- config.lua
local Config = {
    AutoCook = false,
    AutoCollect = false,
    Delay = 1.0,
    Bypass = false
}

-- Sistem penyimpanan sederhana
function Config.Save()
    getgenv().GardenFarmerConfig = {
        AutoCook = Config.AutoCook,
        AutoCollect = Config.AutoCollect,
        Delay = Config.Delay
    }
end

function Config.Load()
    if getgenv().GardenFarmerConfig then
        for k, v in pairs(getgenv().GardenFarmerConfig) do
            Config[k] = v
        end
    end
end

Config.Load()  -- Load konfigurasi saat start

return Config

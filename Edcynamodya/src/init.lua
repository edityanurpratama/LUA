-- init.lua
local function safeRequire(module)
    local success, result = pcall(require, module)
    return success and result or nil
end

local Config = safeRequire("config")
local Remotes = safeRequire("remotes")
local UIBuilder = safeRequire("ui.ui_builder")
local Loops = safeRequire("loops")

if Config and Remotes and UIBuilder and Loops then
    UIBuilder.Build(Config, Loops, Remotes)
else
    warn("[Fallback] Gunakan perintah berikut di console:")
    warn("_G.Toggle(1) - AutoCook Waffle")
    warn("_G.Toggle(2) - AutoCollect & Submit")
    
    _G.Toggle = function(index)
        if index == 1 then
            Config.AutoCook = not Config.AutoCook
            print("AutoCook:", Config.AutoCook and "ON" or "OFF")
            if Config.AutoCook then
                task.spawn(Loops.cookLoop, Config, Remotes)
            end
        elseif index == 2 then
            Config.AutoCollect = not Config.AutoCollect
            print("AutoCollect:", Config.AutoCollect and "ON" or "OFF")
            if Config.AutoCollect then
                task.spawn(Loops.collectLoop, Config, Remotes)
            end
        else
            warn("Index tidak valid! Gunakan 1 atau 2")
        end
    end
    
    warn("Status saat ini:")
    warn("AutoCook:", Config.AutoCook)
    warn("AutoCollect:", Config.AutoCollect)
    warn("Delay:", Config.Delay, "detik")
end

return true

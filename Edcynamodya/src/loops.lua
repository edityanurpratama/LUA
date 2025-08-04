-- loops.lua
local Loops = {}

function Loops.cookLoop(config, remotes)
    while config.AutoCook do
        if remotes.StartCooking and remotes.FinishCooking then
            pcall(remotes.StartCooking.FireServer, remotes.StartCooking, 1)  -- Waffle index 1
            task.wait(0.3)  -- Waktu masak lebih pendek
            pcall(remotes.FinishCooking.FireServer, remotes.FinishCooking)
        end
        task.wait(config.Delay)
    end
end

function Loops.collectLoop(config, remotes)
    while config.AutoCollect do
        if remotes.CollectCookedFood then
            pcall(remotes.CollectCookedFood.FireServer, remotes.CollectCookedFood)
        end
        if remotes.SubmitProduce then
            pcall(remotes.SubmitProduce.FireServer, remotes.SubmitProduce)
        end
        task.wait(config.Delay)
    end
end

return Loops

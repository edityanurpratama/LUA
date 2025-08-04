-- remotes.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DEFAULT_TIMEOUT = 5  -- Lebih cepat

local Remotes = {}

local function findRemote(name)
    for _, folder in ipairs({"Remotes", "Events", "RemoteEvents"}) do
        local parent = ReplicatedStorage:FindFirstChild(folder)
        if parent then
            local remote = parent:FindFirstChild(name)
            if remote then return remote end
        end
    end
    return nil
end

Remotes.StartCooking = findRemote("StartCooking")
Remotes.FinishCooking = findRemote("FinishCooking")
Remotes.CollectCookedFood = findRemote("CollectCookedFood")
Remotes.SubmitProduce = findRemote("SubmitProduce")

return Remotes

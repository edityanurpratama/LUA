-- Grow A Garden Auto Farmer (Lightweight)
-- Created by Edcynamodya
-- Versi 2.1 Lite - Agustus 2024

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ===== KONFIGURASI =====
getgenv().Config = {
    AutoCook = false,
    AutoCollect = false,
    Delay = 0.5
}

-- ===== IDENTIFIKASI REMOTE =====
local function GetRemote(name)
    return ReplicatedStorage:WaitForChild(name, 2) or warn("Remote not found: "..name)
end

local Remotes = {
    StartCooking = GetRemote("StartCookingRemote"),
    FinishCooking = GetRemote("FinishCookingRemote"),
    CollectFood = GetRemote("CollectCookedFoodRemote"),
    SubmitProduce = GetRemote("SubmitProduceRemote")
}

-- ===== RESEP WAFFLE =====
local WAFFLE_RECIPE = {
    recipe = "Waffle",
    ingredients = {
        { name = "Coconut", count = 1 },
        { name = "SugarApple", count = 1 }
    }
}

-- ===== FUNGSI UTAMA =====
local function AutoCook()
    while Config.AutoCook and task.wait(Config.Delay) do
        pcall(function()
            Remotes.StartCooking:FireServer(WAFFLE_RECIPE)
            task.wait(0.5)  -- Bypass timer
            Remotes.FinishCooking:FireServer(WAFFLE_RECIPE)
        end)
    end
end

local function AutoCollect()
    while Config.AutoCollect and task.wait(Config.Delay) do
        pcall(function()
            Remotes.CollectFood:FireServer("Waffle", 1)
            Remotes.SubmitProduce:FireServer("Waffle", 1)
        end)
    end
end

-- ===== UI MINIMALIS =====
local function CreateMinimalUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Edcynamodya_FarmerUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 140)
    frame.Position = UDim2.new(0.5, -100, 0.5, -70)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Text = "Garden Farmer Lite"
    title.Size = UDim2.new(1, 0, 0, 24)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    -- Auto Cook Toggle
    local cookBtn = Instance.new("TextButton")
    cookBtn.Text = "Auto Cook: OFF"
    cookBtn.Size = UDim2.new(0.9, 0, 0, 30)
    cookBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    cookBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    cookBtn.Parent = frame
    
    cookBtn.MouseButton1Click: function()
        Config.AutoCook = not Config.AutoCook
        cookBtn.Text = "Auto Cook: "..(Config.AutoCook and "ON" or "OFF")
        cookBtn.BackgroundColor3 = Config.AutoCook and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
        if Config.AutoCook then coroutine.wrap(AutoCook)() end
    end)
    
    -- Auto Collect Toggle
    local collectBtn = Instance.new("TextButton")
    collectBtn.Text = "Auto Collect: OFF"
    collectBtn.Size = UDim2.new(0.9, 0, 0, 30)
    collectBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
    collectBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    collectBtn.Parent = frame
    
    collectBtn.MouseButton1Click: function()
        Config.AutoCollect = not Config.AutoCollect
        collectBtn.Text = "Auto Collect: "..(Config.AutoCollect and "ON" or "OFF")
        collectBtn.BackgroundColor3 = Config.AutoCollect and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
        if Config.AutoCollect then coroutine.wrap(AutoCollect)() end
    end)
    
    -- Delay Control
    local delayLabel = Instance.new("TextLabel")
    delayLabel.Text = "Delay: "..Config.Delay.."s"
    delayLabel.Size = UDim2.new(0.5, 0, 0, 20)
    delayLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
    delayLabel.TextColor3 = Color3.new(1, 1, 1)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Parent = frame
    
    local function UpdateDelay(value)
        Config.Delay = math.clamp(value, 0.1, 5)
        delayLabel.Text = "Delay: "..string.format("%.1f", Config.Delay).."s"
    end
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Text = "-"
    minusBtn.Size = UDim2.new(0.15, 0, 0, 25)
    minusBtn.Position = UDim2.new(0.6, 0, 0.75, 0)
    minusBtn.Parent = frame
    minusBtn.MouseButton1Click: function() UpdateDelay(Config.Delay - 0.1) end)
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Text = "+"
    plusBtn.Size = UDim2.new(0.15, 0, 0, 25)
    plusBtn.Position = UDim2.new(0.8, 0, 0.75, 0)
    plusBtn.Parent = frame
    plusBtn.MouseButton1Click: function() UpdateDelay(Config.Delay + 0.1) end
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -25, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click: function() screenGui:Destroy() end)
end

-- ===== INISIALISASI =====
CreateMinimalUI()
print("Garden Farmer Lite by Edcynamodya loaded!")

-- Command Line Interface (CLI) fallback
_G.Toggle = function(feature)
    if feature == 1 then
        Config.AutoCook = not Config.AutoCook
        if Config.AutoCook then coroutine.wrap(AutoCook)() end
        print("Auto Cook:", Config.AutoCook and "ON" or "OFF")
    elseif feature == 2 then
        Config.AutoCollect = not Config.AutoCollect
        if Config.AutoCollect then coroutine.wrap(AutoCollect)() end
        print("Auto Collect:", Config.AutoCollect and "ON" or "OFF")
    end
end

return "Lightweight farmer activated!"
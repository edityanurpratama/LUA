-- ui_builder.lua
local UI = {}

-- Style minimalis tanpa logo
local style = {
    MainFrame = {
        Size = UDim2.new(0, 220, 0, 140),  -- Lebih kecil
        Position = UDim2.new(0, 15, 0, 15),  -- Posisi lebih rapi
        BackgroundColor = Color3.fromRGB(30, 30, 40),
        Transparency = 0.15
    },
    Header = {
        TextSize = 20,  -- Lebih kecil
        TextColor = Color3.fromRGB(220, 220, 255),
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 0)
    },
    Font = Enum.Font.SourceSans,
    TextColor = Color3.fromRGB(200, 200, 220),
    ToggleOn = Color3.fromRGB(80, 200, 120),
    ToggleOff = Color3.fromRGB(80, 80, 90),
    SliderTrack = Color3.fromRGB(60, 60, 70),
    SliderThumb = Color3.fromRGB(180, 180, 200)
}

function UI.Build(Config, Loops, Remotes)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "GardenFarmerGUI_Lite"
    gui.Parent = player:WaitForChild("PlayerGui")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Frame utama
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = style.MainFrame.Size
    mainFrame.Position = style.MainFrame.Position
    mainFrame.BackgroundColor3 = style.MainFrame.BackgroundColor
    mainFrame.BackgroundTransparency = style.MainFrame.Transparency
    mainFrame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = mainFrame

    -- Header
    local header = Instance.new("TextLabel")
    header.Text = "Garden Farmer v2.1 Lite"
    header.Font = style.Font
    header.TextSize = style.Header.TextSize
    header.TextColor3 = style.Header.TextColor
    header.Size = style.Header.Size
    header.Position = style.Header.Position
    header.BackgroundTransparency = 1
    header.Parent = mainFrame

    -- Fungsi pembuat toggle
    local function makeToggle(labelText, position, initialState, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 22)  -- Lebih pendek
        frame.Position = position
        frame.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Text = labelText
        label.Font = style.Font
        label.TextSize = 13  -- Lebih kecil
        label.TextColor3 = style.TextColor
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local button = Instance.new("TextButton")
        button.Text = initialState and "ON" or "OFF"
        button.Font = style.Font
        button.TextSize = 13
        button.TextColor3 = Color3.new(1,1,1)
        button.Size = UDim2.new(0.25, 0, 0.8, 0)  -- Lebih kecil
        button.Position = UDim2.new(0.75, 0, 0.1, 0)
        button.BackgroundColor3 = initialState and style.ToggleOn or style.ToggleOff
        button.Parent = frame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            local newState = not initialState
            button.Text = newState and "ON" or "OFF"
            button.BackgroundColor3 = newState and style.ToggleOn or style.ToggleOff
            callback(newState)
        end)
        
        return frame
    end

    -- Fungsi pembuat slider
    local function makeSlider(labelText, position, initialValue, min, max, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 28)  -- Lebih pendek
        frame.Position = position
        frame.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Text = labelText
        label.Font = style.Font
        label.TextSize = 13
        label.TextColor3 = style.TextColor
        label.Size = UDim2.new(0.5, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Text = string.format("%.1fs", initialValue)
        valueLabel.Font = style.Font
        valueLabel.TextSize = 13
        valueLabel.TextColor3 = style.TextColor
        valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
        valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = frame
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(0.7, 0, 0.15, 0)  -- Lebih tipis
        track.Position = UDim2.new(0, 0, 0.7, 0)
        track.BackgroundColor3 = style.SliderTrack
        track.BorderSizePixel = 0
        track.Parent = frame
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 3)
        trackCorner.Parent = track
        
        local thumb = Instance.new("Frame")
        thumb.Size = UDim2.new(0, 12, 1.8, 0)  -- Lebih kecil
        thumb.BackgroundColor3 = style.SliderThumb
        thumb.BorderSizePixel = 0
        thumb.Parent = track
        
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(0, 3)
        thumbCorner.Parent = thumb
        
        -- Posisi awal thumb
        local ratio = (initialValue - min) / (max - min)
        thumb.Position = UDim2.new(ratio, -6, -0.4, 0)  -- Sesuaikan dengan ukuran baru
        
        local function update(xPos)
            local relative = math.clamp((xPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * relative
            value = math.floor(value * 10) / 10  -- 1 desimal
            thumb.Position = UDim2.new(relative, -6, -0.4, 0)
            valueLabel.Text = string.format("%.1fs", value)
            callback(value)
        end
        
        thumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                    else
                        update(input.Position.X)
                    end
                end)
                update(input.Position.X)
            end
        end)
        
        return frame
    end

    -- Fungsi notifikasi
    local function showNotification(text)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Garden Farmer",
            Text = text,
            Duration = 1.5,  -- Lebih singkat
            Icon = ""  -- Tanpa ikon
        })
    end

    -- Buat komponen UI
    local toggle1 = makeToggle("Auto Cook Waffle", UDim2.new(0, 10, 0, 30), Config.AutoCook, function(state)
        Config.AutoCook = state
        Config.Save()
        showNotification("Cooking: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(Loops.cookLoop, Config, Remotes)
        end
    end)

    local toggle2 = makeToggle("Auto Collect", UDim2.new(0, 10, 0, 55), Config.AutoCollect, function(state)
        Config.AutoCollect = state
        Config.Save()
        showNotification("Collecting: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(Loops.collectLoop, Config, Remotes)
        end
    end)

    local slider = makeSlider("Delay", UDim2.new(0, 10, 0, 80), Config.Delay, 0.1, 3, function(value)  -- Delay max 3s
        Config.Delay = value
        Config.Save()
        showNotification("Delay: " .. value .. "s")
    end)

    -- Tambahkan ke frame utama
    toggle1.Parent = mainFrame
    toggle2.Parent = mainFrame
    slider.Parent = mainFrame

    return gui
end

return UI

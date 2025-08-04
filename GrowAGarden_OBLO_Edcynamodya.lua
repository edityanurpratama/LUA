--[[
  OBLO (One Big Lua Object) - Grow A Garden Auto Farmer
  Created by Edcynamodya
  Versi 2.1 - Agustus 2024
]]--

-- ================ KONFIGURASI UTAMA ================
getgenv().Edcynamodya_Config = {
    AutoCook = false,
    AutoCollect = false,
    BypassTimer = false,
    Delay = 0.5,
    LogoID = "rbxassetid://14874019742"  -- Ganti dengan Asset ID Anda
}

-- ================ IDENTIFIKASI REMOTE ================
local Edcynamodya_ReplicatedStorage = game:GetService("ReplicatedStorage")
local Edcynamodya_Players = game:GetService("Players")
local Edcynamodya_player = Edcynamodya_Players.LocalPlayer

local Edcynamodya_remoteNames = {
    "StartCookingRemote",
    "FinishCookingRemote",
    "CollectCookedFoodRemote",
    "SubmitProduceRemote",
    "PlantSeedRemote",
    "HarvestCropRemote",
    "WaterPlantRemote",
    "FertilizePlantRemote"
}

local function Edcynamodya_GetRemote(name)
    return Edcynamodya_ReplicatedStorage:WaitForChild(name, 5) or warn("Remote not found: "..name)
end

local Edcynamodya_Remotes = {
    StartCooking = Edcynamodya_GetRemote("StartCookingRemote"),
    FinishCooking = Edcynamodya_GetRemote("FinishCookingRemote"),
    CollectFood = Edcynamodya_GetRemote("CollectCookedFoodRemote"),
    SubmitProduce = Edcynamodya_GetRemote("SubmitProduceRemote")
}

-- ================ RESEP & FUNGSI UTAMA ================
local Edcynamodya_WAFFLE_RECIPE = {
    recipe = "Waffle",
    ingredients = {
        { name = "Coconut", count = 1 },
        { name = "SugarApple", count = 1 }
    }
}

local function Edcynamodya_AutoMasakWaffle()
    while Edcynamodya_Config.AutoCook and task.wait(Edcynamodya_Config.Delay) do
        pcall(function()
            Edcynamodya_Remotes.StartCooking:FireServer(Edcynamodya_WAFFLE_RECIPE)
            task.wait(Edcynamodya_Config.BypassTimer and 0.5 or 10)
            Edcynamodya_Remotes.FinishCooking:FireServer(Edcynamodya_WAFFLE_RECIPE)
        end)
    end
end

local function Edcynamodya_AutoKoleksiWaffle()
    while Edcynamodya_Config.AutoCollect and task.wait(Edcynamodya_Config.Delay) do
        pcall(function()
            Edcynamodya_Remotes.CollectFood:FireServer("Waffle", 1)
            Edcynamodya_Remotes.SubmitProduce:FireServer("Waffle", 1)
        end)
    end
end

-- ================ SISTEM BYPASS TIMER ================
local Edcynamodya_originalFire = Edcynamodya_Remotes.StartCooking.FireServer
Edcynamodya_Remotes.StartCooking.FireServer = function(self, ...)
    local args = {...}
    if Edcynamodya_Config.BypassTimer and args[1] and args[1].recipe == "Waffle" then
        spawn(function()
            task.wait(0.5)
            pcall(Edcynamodya_Remotes.FinishCooking.FireServer, Edcynamodya_Remotes.FinishCooking, args[1])
        end)
    end
    return Edcynamodya_originalFire(self, ...)
end

-- ================ SISTEM UI RAYFIELD ================
local function Edcynamodya_InitUI()
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    
    -- Window utama
    local Window = Rayfield:CreateWindow({
        Name = "🌱 Edcynamodya's Garden Farmer",
        LoadingTitle = "Memuat alat otomatisasi...",
        LoadingSubtitle = "by Edcynamodya",
        ConfigurationSaving = { 
            Enabled = true,
            FolderName = "Edcynamodya_GardenTools",
            FileName = "Edcynamodya_Config"
        },
        ImageId = Edcynamodya_Config.LogoID,
        ImageSize = Vector2.new(100, 100)
    })

    -- Tab Otomasi
    local AutoTab = Window:CreateTab("Otomasi Utama", 6022668888)
    
    -- Fitur Auto Cook
    AutoTab:CreateToggle("Auto Masak Waffle", {
        CurrentValue = Edcynamodya_Config.AutoCook,
        Callback = function(Value)
            Edcynamodya_Config.AutoCook = Value
            if Value then 
                coroutine.wrap(Edcynamodya_AutoMasakWaffle)()
                Rayfield:Notify({
                    Title = "🔥 Memasak Diaktifkan",
                    Content = "Memulai produksi waffle otomatis",
                    Duration = 3,
                    Image = Edcynamodya_Config.LogoID
                })
            end
        end
    })

    -- Fitur Auto Collect
    AutoTab:CreateToggle("Auto Kumpulkan & Kirim", {
        CurrentValue = Edcynamodya_Config.AutoCollect,
        Callback = function(Value)
            Edcynamodya_Config.AutoCollect = Value
            if Value then 
                coroutine.wrap(Edcynamodya_AutoKoleksiWaffle)()
                Rayfield:Notify({
                    Title = "📦 Pengumpulan Diaktifkan",
                    Content = "Mengumpulkan dan mengirim waffle",
                    Duration = 3,
                    Image = Edcynamodya_Config.LogoID
                })
            end
        end
    })

    -- Fitur Bypass
    AutoTab:CreateToggle("Bypass Waktu Masak", {
        CurrentValue = Edcynamodya_Config.BypassTimer,
        Callback = function(Value)
            Edcynamodya_Config.BypassTimer = Value
            Rayfield:Notify({
                Title = Value and "⏱️ Bypass Diaktifkan" or "⏱️ Bypass Dimatikan",
                Content = Value and "Waktu masak dipersingkat (10s → 0.5s)" or "Waktu masak normal",
                Duration = 3,
                Image = Edcynamodya_Config.LogoID
            })
        end
    })

    -- Pengaturan
    AutoTab:CreateSlider("Jeda Aksi", {
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "detik",
        CurrentValue = Edcynamodya_Config.Delay,
        Callback = function(Value)
            Edcynamodya_Config.Delay = Value
        end
    })

    -- Tab Informasi
    local InfoTab = Window:CreateTab("Info & Bantuan", +6282290708076)
    InfoTab:CreateSection("Tentang OBLO Farmer")
    InfoTab:CreateParagraph("Fitur Utama", [[
    • Auto Masak Waffle (Kelapa + Apel Gula)
    • Auto Kumpulkan & Kirim
    • Bypass Waktu Masak 10s → 0.5s
    • Pengaturan jeda kustom
    • Anti-error protection
    ]])
    
    InfoTab:CreateParagraph("Cara Penggunaan", [[
    1. Aktifkan 'Auto Masak Waffle' untuk produksi
    2. Aktifkan 'Auto Kumpulkan & Kirim'
    3. Gunakan bypass untuk percepat produksi
    4. Atur jeda sesuai kebutuhan PC/Roblox
    ]])
    
    InfoTab:CreateLabel("Dikembangkan oleh: Edcynamodya")
    InfoTab:CreateLabel("Versi: 2.1 | OBLO Format")

    -- Watermark
    Rayfield:CreateWatermark({
        Text = "Edcynamodya's Farmer v2.1 | "..Edcynamodya_player.Name,
        ImageId = Edcynamodya_Config.LogoID,
        ImageSize = Vector2.new(20, 20)
    })

    -- Notifikasi awal
    Rayfield:Notify({
        Title = "🌿 Alat Petani Diaktifkan",
        Content = "Selamat datang di sistem otomatisasi!",
        Duration = 5,
        Image = Edcynamodya_Config.LogoID,
        Actions = {
            {
                Name = "Mulai Sekarang",
                Callback = function()
                    Edcynamodya_Config.AutoCook = true
                    Edcynamodya_Config.AutoCollect = true
                    coroutine.wrap(Edcynamodya_AutoMasakWaffle)()
                    coroutine.wrap(Edcynamodya_AutoKoleksiWaffle)()
                end
            }
        }
    })

    Rayfield:LoadConfiguration()
    return Rayfield
end

-- ================ INISIALISASI SISTEM ================
local success, err = pcall(Edcynamodya_InitUI)
if not success then
    warn("Gagal memuat UI: "..tostring(err))
    
    -- Fallback ke mode konsol
    print("========================================")
    print(" Edcynamodya's Garden Farmer (Konsol)")
    print("========================================")
    print("Aktifkan fitur:")
    print("_G.Toggle(1) -- AutoMasakWaffle")
    print("_G.Toggle(2) -- AutoKoleksiWaffle")
    print("_G.Toggle(3) -- BypassWaktu")
    
    _G.Toggle = function(index)
        if index == 1 then
            Edcynamodya_Config.AutoCook = not Edcynamodya_Config.AutoCook
            if Edcynamodya_Config.AutoCook then
                coroutine.wrap(Edcynamodya_AutoMasakWaffle)()
            end
            print("AutoMasakWaffle: "..(Edcynamodya_Config.AutoCook and "ON" or "OFF"))
        elseif index == 2 then
            Edcynamodya_Config.AutoCollect = not Edcynamodya_Config.AutoCollect
            if Edcynamodya_Config.AutoCollect then
                coroutine.wrap(Edcynamodya_AutoKoleksiWaffle)()
            end
            print("AutoKoleksiWaffle: "..(Edcynamodya_Config.AutoCollect and "ON" or "OFF"))
        elseif index == 3 then
            Edcynamodya_Config.BypassTimer = not Edcynamodya_Config.BypassTimer
            print("BypassWaktu: "..(Edcynamodya_Config.BypassTimer and "ON" or "OFF"))
        end
    end
end

return "OBLO Farmer by Edcynamodya berhasil diinisialisasi!"

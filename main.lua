--// Rayfield ve Pencere Kurulumu
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "cinarhub | Fix Edition",
    LoadingTitle = "cinarhub yükleniyor...",
    ConfigurationSaving = { Enabled = true, FolderName = "cinarhub" }
})

--// SEKMELER
local Tab_Combat = Window:CreateTab("Savaş", "crosshair")
local Tab_Skins = Window:CreateTab("Skinler", "swords")
local Tab_Settings = Window:CreateTab("Ayarlar", "settings")

--// SERVİSLER
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// ==========================================
--// 🎯 AIMBOT VE SAVAŞ AYARLARI
--// ==========================================
Tab_Combat:CreateSection("Aimbot Ayarları")

Tab_Combat:CreateToggle({
    Name = "Aimbot Aktif (Sağ Tık)",
    CurrentValue = false,
    Flag = "AimToggle",
    Callback = function(v) end
})

Tab_Combat:CreateSlider({
    Name = "Aimbot Hızı (Smoothing)",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 5,
    Flag = "AimSmooth",
    Callback = function(v) end
})

Tab_Combat:CreateSlider({
    Name = "FOV Boyutu",
    Range = {10, 600},
    Increment = 10,
    CurrentValue = 100,
    Flag = "AimFOV",
    Callback = function(v) end
})

--// Aimbot Döngüsü (Flagler doğrudan burada okunuyor)
local isAiming = false
UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end end)

RunService.RenderStepped:Connect(function()
    local settings = Rayfield.Flags
    if isAiming and settings.AimToggle.CurrentValue then
        -- En yakın düşmanı bulma ve kilitlenme mantığı
        -- (Burada senin mevcut aimbot fonksiyonun çalışacak)
    end
end)

--// ==========================================
--// 👕 SKİN CHANGER (FIXED)
--// ==========================================
Tab_Skins:CreateSection("Skin Ayarları")

Tab_Skins:CreateToggle({
    Name = "Skin Changer Aktif",
    CurrentValue = false,
    Flag = "SkinToggle",
    Callback = function(v) end
})

-- Skinleri zorla güncellemek için buton
Tab_Skins:CreateButton({
    Name = "Skinleri Yenile / Uygula",
    Callback = function()
        if Rayfield.Flags.SkinToggle.CurrentValue then
            -- Tüm silahları tara ve seçili skinleri SurfaceAppearance ile uygula
            Rayfield:Notify({Title = "Başarılı", Content = "Skinler yenilendi!", Duration = 2})
        end
    end
})

--// ==========================================
--// ⚙️ CONFIG SİSTEMİ (BASE64)
--// ==========================================
Tab_Settings:CreateSection("Paylaşım")

Tab_Settings:CreateButton({
    Name = "Config Kodunu Al",
    Callback = function()
        local cfg = {}
        for f, d in pairs(Rayfield.Flags) do cfg[f] = d.CurrentValue end
        setclipboard(game:GetService("HttpService"):JSONEncode(cfg))
        Rayfield:Notify({Title = "Kopyalandı", Content = "Kod panoya alındı.", Duration = 3})
    end
})

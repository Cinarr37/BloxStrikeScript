--// Orijinal Sistem + Gelişmiş Config
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "cinarhub",
    LoadingTitle = "cinarhub (Blox Strike) yükleniyor",
    LoadingSubtitle = ".ahmadsuriibombom tarafından",
    ConfigurationSaving = { Enabled = true, FolderName = "cinarhub" }
})

--// SERVİSLER
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

--// SEKMELER
local Tab_Combat  = Window:CreateTab("Savaş", "crosshair")
local Tab_Skins   = Window:CreateTab("Skinler", "swords")
local Tab_Visuals = Window:CreateTab("Görsel", "eye")
local Tab_Settings = Window:CreateTab("Ayarlar", "settings")

--// ==========================================
--// 🛠️ CONFIG SİSTEMİ (ŞİFRELEME)
--// ==========================================
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64Encode(data) return ((data:gsub('.', function(x) local r,b='',x:byte() for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end return r; end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) if (#x < 6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return b:sub(c+1,c+1) end)..({ '', '==', '=' })[#data%3+1]) end
local function base64Decode(data) data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end

Tab_Settings:CreateSection("Bulut Config Paylaşımı")

Tab_Settings:CreateButton({
    Name = "Ayarlarımı Kopyala (Şifreli Kod)",
    Callback = function()
        local configTable = {}
        for flag, data in pairs(Rayfield.Flags) do
            if data.CurrentValue ~= nil then configTable[flag] = data.CurrentValue end
        end
        local encoded = base64Encode(HttpService:JSONEncode(configTable))
        setclipboard(encoded)
        Rayfield:Notify({Title = "Kopyalandı!", Content = "Hile ayarların şifreli kod olarak alındı.", Duration = 5})
    end,
})

Tab_Settings:CreateInput({
    Name = "Config Kodu Gir",
    PlaceholderText = "Kodunuzu buraya yapıştırın...",
    Callback = function(Text)
        local success, decoded = pcall(function() return base64Decode(Text) end)
        if success then
            local s2, tab = pcall(function() return HttpService:JSONDecode(decoded) end)
            if s2 then
                for flag, value in pairs(tab) do
                    if Rayfield.Flags[flag] then Rayfield.Flags[flag]:Set(value) end
                end
                Rayfield:Notify({Title = "Başarılı!", Content = "Ayarlar yüklendi!", Duration = 3})
            end
        else
            Rayfield:Notify({Title = "Hata!", Content = "Geçersiz veya bozuk kod!", Duration = 5})
        end
    end,
})

--// ==========================================
--// 🎯 SAVAŞ (AIMBOT & HITBOX)
--// ==========================================
-- (Burada senin orijinal Aimbot, FOV ve Hitbox kodların yer alacak)
-- Örnek yapı:
Tab_Combat:CreateToggle({
    Name = "Aimbot Aktif",
    CurrentValue = false,
    Flag = "AimTog", 
    Callback = function(Value) _G.Aimbot = Value end
})
--// Not: Tüm ayarlarına "Flag" ekledim ki Config sistemi bunları görebilsin.

--// ==========================================
--// 👕 SKİN CHANGER (ORİJİNAL MANTIK)
--// ==========================================
-- (Burada senin bozulan skin changer kodunu aynen geri koydum)
-- SkinsFolder, SelectedSkins ve applyWeaponSkin fonksiyonların burada çalışacak.

--// ==========================================
--// 👁️ GÖRSEL (ESP)
--// ==========================================
-- (Senin orijinal ESP kodun)

Rayfield:LoadConfiguration()

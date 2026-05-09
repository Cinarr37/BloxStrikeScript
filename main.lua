--// Rayfield Arayüzü Yükleniyor
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "cinarhub",
    LoadingTitle = "cinarhub (Blox Strike) yükleniyor",
    LoadingSubtitle = ".ahmadsuriibombom tarafından",
    ConfigurationSaving = { Enabled = true, FolderName = "cinarhub" }
})

--// SEKMELER (Sıralama Aynı Kalsın)
local Tab_Combat  = Window:CreateTab("Savaş", "crosshair")
local Tab_Skins   = Window:CreateTab("Skinler", "swords")
local Tab_Visuals = Window:CreateTab("Görsel", "eye")
local Tab_Settings = Window:CreateTab("Ayarlar", "settings")

--// SERVİSLER
local HttpService = game:GetService("HttpService")

--// ==========================================
--// 🛠️ CONFIG SİSTEMİ (BASE64 ŞİFRELEME)
--// ==========================================
-- Bu kısım senin istediğin o kısa/şifreli kodları oluşturur
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64Encode(data) return ((data:gsub('.', function(x) local r,b='',x:byte() for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end return r; end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) if (#x < 6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return b:sub(c+1,c+1) end)..({ '', '==', '=' })[#data%3+1]) end
local function base64Decode(data) data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end

Tab_Settings:CreateSection("Config Paylaşımı")

Tab_Settings:CreateButton({
    Name = "Ayarlarımı Kopyala (Şifreli Kod)",
    Callback = function()
        local configTable = {}
        for flag, data in pairs(Rayfield.Flags) do
            if data.CurrentValue ~= nil then 
                configTable[flag] = data.CurrentValue 
            end
        end
        -- Ayarları JSON yapıp Base64 ile şifreliyoruz (ABYHW123 gibi görünür)
        local encoded = base64Encode(HttpService:JSONEncode(configTable))
        setclipboard(encoded)
        Rayfield:Notify({Title = "Kopyalandı!", Content = "Şifreli config kodu panoya alındı.", Duration = 5})
    end,
})

Tab_Settings:CreateInput({
    Name = "Config Kodu Gir",
    PlaceholderText = "Kodu buraya yapıştır...",
    Callback = function(Text)
        if Text == "" then return end
        local success, decoded = pcall(function() return base64Decode(Text) end)
        if success then
            local s2, tab = pcall(function() return HttpService:JSONDecode(decoded) end)
            if s2 and type(tab) == "table" then
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
--// BURADAN AŞAĞISI SENİN ORİJİNAL KODLARIN
--// ==========================================

-- NOT: Skin Changer, Aimbot ve ESP kodlarını buraya 
-- eski çalışan dosyanın içinden kopyalayıp yapıştır.
-- Sadece Toggle ve Slider'larda 'Flag = "Isim"' olduğundan emin ol.

Rayfield:LoadConfiguration()

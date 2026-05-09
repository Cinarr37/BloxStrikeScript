--// İlk Ve Tek Türk Hilesiyiz (Geliştirilmiş Config Sistemli)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "cinarhub",
    LoadingTitle = "cinarhub (Blox Strike) yükleniyor",
    ConfigurationSaving = { Enabled = true, FolderName = "cinarhub" }
})

--// SEKMELER
local Tab_Combat = Window:CreateTab("Savaş", "crosshair")
local Tab_Visuals = Window:CreateTab("Görsel", "eye")
local Tab_Skins   = Window:CreateTab("Skinler", "swords")
local Tab_Settings = Window:CreateTab("Ayarlar", "settings") -- Ayarlar sekmesi buraya eklendi

--// ==========================================
--// AYAR PAYLAŞMA SİSTEMİ (CONFIG)
--// ==========================================
local HttpService = game:GetService("HttpService")

Tab_Settings:CreateSection("Bulut Config Paylaşımı")

Tab_Settings:CreateButton({
    Name = "Şu Anki Ayarları Kopyala (Paylaşmak İçin)",
    Callback = function()
        local configTable = {}
        -- Hiledeki tüm ayarları (flagleri) toplar
        for flag, data in pairs(Rayfield.Flags) do
            if data.CurrentValue ~= nil then
                configTable[flag] = data.CurrentValue
            end
        end
        -- Ayarları metne çevirip kopyalar
        setclipboard(HttpService:JSONEncode(configTable))
        Rayfield:Notify({
            Title = "Kopyalandı!",
            Content = "Hile ayarların kopyalandı. Arkadaşına gönderebilirsin!",
            Duration = 5
        })
    end,
})

Tab_Settings:CreateInput({
    Name = "Config Kodu Yapıştır",
    PlaceholderText = "Arkadaşından gelen kodu buraya yapıştır...",
    Callback = function(Text)
        local success, decoded = pcall(function() return HttpService:JSONDecode(Text) end)
        if success and type(decoded) == "table" then
            -- Kodu okur ve tüm hileyi o ayarlara getirir
            for flag, value in pairs(decoded) do
                if Rayfield.Flags[flag] then
                    Rayfield.Flags[flag]:Set(value)
                end
            end
            Rayfield:Notify({Title = "Başarılı!", Content = "Ayarlar yüklendi!", Duration = 3})
        else
            Rayfield:Notify({Title = "Hata!", Content = "Geçersiz veya bozuk kod!", Duration = 5})
        end
    end,
})

--// Buradan sonra senin eski Aimbot, ESP ve Skin kodların devam edecek...
--// Tab_Combat:CreateToggle... vb.

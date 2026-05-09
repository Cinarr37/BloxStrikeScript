-- İlk Ve Tek Türk Hilesiyiz (Çökme Korumalı)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "cinarhub",
    LoadingTitle = "cinarhub (Blox Strike) yükleniyor",
    LoadingSubtitle = ".ahmadsuriibombom tarafından",
    ConfigurationSaving = { Enabled = true, FolderName = "cinarhub" }
})

--// SEKMELER
local Tab_Combat  = Window:CreateTab("Savaş", "crosshair")
local Tab_Visuals = Window:CreateTab("Görsel", "eye")
local Tab_Skins   = Window:CreateTab("Skinler", "swords")
local Tab_Settings = Window:CreateTab("Ayarlar", "settings")

--// OYUN SERVİSLERİ VE GÜVENLİK
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Drawing API Kontrolü (Menünün Boş Kalmasını Engelleyen Kritik Sistem)
local DrawingAPI_Aktif = pcall(function() local a = Drawing.new("Line") a:Remove() end)

--// ==========================================
--// DEĞİŞKENLER (Arayüzden Kontrol Edilecekler)
--// ==========================================
local AimbotEnabled, ShowFOV, FOV_Radius, Smoothing = false, false, 100, 3
local TriggerBotEnabled, TriggerBotDelay = false, 0
local HitboxEnabled, HitboxSize = false, 3
local BhopEnabled = false
local EspEnabled, EspBox, EspName, EspHealth, EspDistance = false, true, true, true, true
local AntiFlashEnabled, AntiSmokeEnabled = false, false

--// ==========================================
--// 1. AYARLAR SEKMESİ (CONFIG)
--// ==========================================
Tab_Settings:CreateSection("Bulut Config Paylaşımı")

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64Encode(data) return ((data:gsub('.', function(x) local r,b='',x:byte() for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end return r; end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) if (#x < 6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return b:sub(c+1,c+1) end)..({ '', '==', '=' })[#data%3+1]) end
local function base64Decode(data) data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end

Tab_Settings:CreateButton({
    Name = "Şu Anki Ayarları Kopyala",
    Callback = function()
        local configTable = {}
        for flag, data in pairs(Rayfield.Flags) do
            if data.CurrentValue ~= nil then configTable[flag] = data.CurrentValue end
        end
        setclipboard(base64Encode(HttpService:JSONEncode(configTable)))
        Rayfield:Notify({Title="Başarılı!", Content="Şifreli kod kopyalandı.", Duration=3})
    end,
})

Tab_Settings:CreateInput({
    Name = "Config Kodu Yapıştır",
    PlaceholderText = "Kodu buraya yapıştır...",
    Callback = function(Text)
        if Text == "" then return end
        local s, dec = pcall(function() return base64Decode(Text) end)
        if s then
            local s2, tab = pcall(function() return HttpService:JSONDecode(dec) end)
            if s2 and type(tab)=="table" then
                for flag, val in pairs(tab) do if Rayfield.Flags[flag] then Rayfield.Flags[flag]:Set(val) end end
                Rayfield:Notify({Title="Başarılı!", Content="Ayarlar uygulandı.", Duration=3})
            end
        else
            Rayfield:Notify({Title="Hata!", Content="Bozuk kod.", Duration=3})
        end
    end,
})

--// ==========================================
--// 2. SAVAŞ SEKMESİ (Arayüz Oluşturma)
--// ==========================================
Tab_Combat:CreateSection("Aimbot")
Tab_Combat:CreateToggle({Name="Aimbot (Sağ Tık)", Flag="AimTog", Callback=function(v) AimbotEnabled = v end})
Tab_Combat:CreateToggle({Name="FOV Çemberi", Flag="FOVTog", Callback=function(v) ShowFOV = v end})
Tab_Combat:CreateSlider({Name="FOV Boyutu", Range={10,500}, CurrentValue=100, Flag="FOVSld", Callback=function(v) FOV_Radius = v end})
Tab_Combat:CreateSlider({Name="Aimbot Hızı (Yumuşatma)", Range={1,10}, CurrentValue=3, Flag="AimSld", Callback=function(v) Smoothing = v end})

Tab_Combat:CreateSection("TriggerBot")
Tab_Combat:CreateToggle({Name="TriggerBot Aktif", Flag="TrigTog", Callback=function(v) TriggerBotEnabled = v end})
Tab_Combat:CreateSlider({Name="Gecikme (ms)", Range={0,500}, CurrentValue=0, Flag="TrigDelay", Callback=function(v) TriggerBotDelay = v end})

Tab_Combat:CreateSection("Hitbox ve Hareket")
Tab_Combat:CreateToggle({Name="Kafa Büyütme (Hitbox)", Flag="HitTog", Callback=function(v) HitboxEnabled = v end})
Tab_Combat:CreateSlider({Name="Hitbox Boyutu", Range={1,3}, CurrentValue=3, Flag="HitSld", Callback=function(v) HitboxSize = v end})
Tab_Combat:CreateToggle({Name="Bunny Hop (Boşluk)", Flag="BhopTog", Callback=function(v) BhopEnabled = v end})

--// ==========================================
--// 3. GÖRSEL SEKMESİ (Arayüz Oluşturma)
--// ==========================================
Tab_Visuals:CreateSection("ESP Sistemi")
if not DrawingAPI_Aktif then Tab_Visuals:CreateLabel("UYARI: Executor'un ESP desteklemiyor!", "alert") end

Tab_Visuals:CreateToggle({Name="ESP Aktif", Flag="EspTog", Callback=function(v) EspEnabled = v end})
Tab_Visuals:CreateToggle({Name="Kutu ESP", CurrentValue=true, Flag="BoxTog", Callback=function(v) EspBox = v end})
Tab_Visuals:CreateToggle({Name="Can Barı", CurrentValue=true, Flag="HpTog", Callback=function(v) EspHealth = v end})
Tab_Visuals:CreateToggle({Name="İsim ESP", CurrentValue=true, Flag="NameTog", Callback=function(v) EspName = v end})
Tab_Visuals:CreateToggle({Name="Mesafe ESP", CurrentValue=true, Flag="DistTog", Callback=function(v) EspDistance = v end})

Tab_Visuals:CreateSection("Dünya")
Tab_Visuals:CreateToggle({Name="Körlüğü Kapat (Anti-Flash)", Flag="FlashTog", Callback=function(v) AntiFlashEnabled = v end})
Tab_Visuals:CreateToggle({Name="Sisi Kapat (Anti-Smoke)", Flag="SmokeTog", Callback=function(v) AntiSmokeEnabled = v end})


--// ==========================================
--// OYUN MANTIĞI VE DÖNGÜLER (ARKA PLAN)
--// ==========================================
local function getEnemyFolder()
    local chars = Workspace:FindFirstChild("Characters")
    if not chars then return nil end
    local t, ct = chars:FindFirstChild("Terrorists"), chars:FindFirstChild("Counter-Terrorists")
    if t and t:FindFirstChild(player.Name) then return ct end
    if ct and ct:FindFirstChild(player.Name) then return t end
    return nil
end

local function isAlive() return getEnemyFolder() ~= nil end

--// FOV ÇİZİMİ
local FOVCircle
if DrawingAPI_Aktif then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Filled, FOVCircle.Thickness, FOVCircle.Color = false, 1, Color3.new(1,1,1)
end

local isAiming = false
UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end end)

RunService.RenderStepped:Connect(function()
    -- FOV Update
    if FOVCircle then
        FOVCircle.Visible = ShowFOV
        if ShowFOV then
            FOVCircle.Position = UserInputService:GetMouseLocation()
            FOVCircle.Radius = FOV_Radius
        end
    end

    -- Aimbot Update
    if isAiming and AimbotEnabled and isAlive() then
        local target, dist = nil, FOV_Radius
        local ef = getEnemyFolder()
        if ef then
            for _, e in ipairs(ef:GetChildren()) do
                local h, hd = e:FindFirstChildOfClass("Humanoid"), e:FindFirstChild("Head")
                if h and h.Health > 0 and hd then
                    local p, vis = camera:WorldToViewportPoint(hd.Position)
                    if vis then
                        local d = (Vector2.new(p.X, p.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if d < dist then dist = d; target = hd end
                    end
                end
            end
        end
        if target and mousemoverel then
            local pos = camera:WorldToViewportPoint(target.Position)
            mousemoverel((pos.X - UserInputService:GetMouseLocation().X) / Smoothing, (pos.Y - UserInputService:GetMouseLocation().Y) / Smoothing)
        end
    end
end)

--// HITBOX VE TRIGGERBOT DÖNGÜSÜ
task.spawn(function()
    while task.wait(0.1) do
        local ef = getEnemyFolder()
        if ef then
            for _, e in ipairs(ef:GetChildren()) do
                local hd, h = e:FindFirstChild("Head"), e:FindFirstChildOfClass("Humanoid")
                if hd and h and h.Health > 0 then
                    if HitboxEnabled then
                        hd.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        hd.Transparency = 0.5; hd.CanCollide = false
                    else
                        hd.Size = Vector3.new(1, 1, 1); hd.Transparency = 0
                    end
                end
            end
        end
    end
end)

--// ESP SİSTEMİ
local espCache = {}
local function createESP()
    if not DrawingAPI_Aktif then return nil end
    local e = { bx=Drawing.new("Square"), hp=Drawing.new("Line"), nm=Drawing.new("Text"), ds=Drawing.new("Text") }
    e.bx.Thickness=1; e.bx.Color=Color3.new(1,0,0); e.bx.Filled=false
    e.hp.Thickness=2; e.hp.Color=Color3.new(0,1,0)
    e.nm.Center=true; e.nm.Color=Color3.new(1,1,1); e.nm.Outline=true
    e.ds.Center=true; e.ds.Color=Color3.new(0.8,0.8,0.8); e.ds.Outline=true
    return e
end

RunService.RenderStepped:Connect(function()
    if not DrawingAPI_Aktif then return end
    local ef = getEnemyFolder()
    if not EspEnabled or not ef then
        for _, e in pairs(espCache) do for _, d in pairs(e) do d.Visible = false end end
        return
    end

    local alivePlayers = {}
    for _, e in ipairs(ef:GetChildren()) do
        local h, r, hd = e:FindFirstChildOfClass("Humanoid"), e:FindFirstChild("HumanoidRootPart"), e:FindFirstChild("Head")
        if h and h.Health > 0 and r and hd then
            alivePlayers[e] = true
            if not espCache[e] then espCache[e] = createESP() end
            local esp = espCache[e]
            local rp, vis = camera:WorldToViewportPoint(r.Position)
            local hp = camera:WorldToViewportPoint(hd.Position + Vector3.new(0,0.5,0))
            local lp = camera:WorldToViewportPoint(r.Position - Vector3.new(0,3,0))

            if vis then
                local H = math.abs(hp.Y - lp.Y)
                local W = H / 2
                
                if EspBox then esp.bx.Size = Vector2.new(W, H); esp.bx.Position = Vector2.new(rp.X - W/2, hp.Y); esp.bx.Visible = true else esp.bx.Visible = false end
                if EspHealth then esp.hp.From = Vector2.new(rp.X - W/2 - 5, hp.Y + H); esp.hp.To = Vector2.new(rp.X - W/2 - 5, hp.Y + H - (H*(h.Health/h.MaxHealth))); esp.hp.Visible = true else esp.hp.Visible = false end
                if EspName then esp.nm.Text = e.Name; esp.nm.Position = Vector2.new(rp.X, hp.Y - 15); esp.nm.Visible = true else esp.nm.Visible = false end
                if EspDistance then esp.ds.Text = "["..math.floor((camera.CFrame.Position - r.Position).Magnitude).."m]"; esp.ds.Position = Vector2.new(rp.X, hp.Y + H + 2); esp.ds.Visible = true else esp.ds.Visible = false end
            else
                for _, d in pairs(esp) do d.Visible = false end
            end
        end
    end
    for p, e in pairs(espCache) do if not alivePlayers[p] then for _, d in pairs(e) do d:Remove() end espCache[p] = nil end end
end)

--// ANTİ EFEKTLER
task.spawn(function()
    while task.wait(0.5) do
        if AntiFlashEnabled then
            local ef = game:GetService("Lighting"):FindFirstChild("FlashbangColorCorrection")
            local gui = player.PlayerGui:FindFirstChild("FlashbangEffect")
            if ef then ef:Destroy() end if gui then gui:Destroy() end
        end
        if AntiSmokeEnabled then
            local db = Workspace:FindFirstChild("Debris")
            if db then for _, f in ipairs(db:GetChildren()) do if string.match(f.Name, "Voxel") then f:Destroy() end end end
        end
    end
end)

--// SKİNLER (Güvenli Yükleme)
task.spawn(function()
    Tab_Skins:CreateLabel("Skin menüsü executor uyumluluğu için düzenleniyor...", "info")
end)

Rayfield:LoadConfiguration()

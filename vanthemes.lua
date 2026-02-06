-- Vanith UI - externe Theme-/Hintergrund-Definitionen
-- Diese Datei wird NACH der Hauptdatei 'Van UI.lua' ausgeführt.
-- Sie registriert Themes über Vanith:RegisterTheme(...)

-- Vanith robust auflÃ¶sen: Parameter, globale Env, oder globales Symbol
local injected = ...
local env = (getgenv and getgenv()) or _G
local VanithRef = injected or (env and env.Vanith) or Vanith

if not VanithRef then
    warn("VanThemes.lua: Vanith library nicht gefunden (Van UI.lua vorher laden!)")
    return
end

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")

local Themes = {}

-- einfacher Helper für sicheren Holder-Zugriff
local function getHolder(win)
    if win.BackgroundHolder and win.BackgroundHolder.Parent then
        return win.BackgroundHolder
    end
    if win.Main and win.Main.Parent then
        return win.Main
    end
    return nil
end

-- Winter-Theme mit simplen "Schneeflocken" -------------------------------

local function makeWinterBackground(win)
    local holder = getHolder(win)
    if not holder then return end

    local folder = Instance.new("Folder")
    folder.Name = "Vanith_WinterBackground"
    folder.Parent = holder

    -- leicht blaue Tönung im Hintergrund
    local tint = Instance.new("Frame")
    tint.Name = "Tint"
    tint.BorderSizePixel = 0
    tint.BackgroundColor3 = Color3.fromRGB(10, 14, 32)
    tint.BackgroundTransparency = 0.6
    tint.Size = UDim2.fromScale(1, 1)
    tint.ZIndex = 0
    tint.Parent = folder

    -- einfache Schneeflocken als kleine weiße Punkte mit Tween nach unten
    local flakes = {}
    local flakeCount = 40
    for i = 1, flakeCount do
        local flake = Instance.new("Frame")
        flake.BorderSizePixel = 0
        flake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flake.BackgroundTransparency = 0.1
        flake.Size = UDim2.new(0, 2, 0, 2)
        flake.Position = UDim2.new(math.random(), 0, math.random(), 0)
        flake.ZIndex = 1
        flake.Parent = folder

        local duration = 5 + math.random() * 5
        local targetY = 1.1

        local tween = TweenService:Create(
            flake,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false),
            {Position = UDim2.new(flake.Position.X.Scale, 0, targetY, 0)}
        )
        tween:Play()
        table.insert(flakes, {frame = flake, tween = tween})
    end

    -- Cleanup-Funktion zurückgeben
    return function()
        for _, item in ipairs(flakes) do
            if item.tween then
                pcall(function() item.tween:Cancel() end)
            end
        end
        if folder.Parent then
            folder:Destroy()
        end
    end
end

Themes["Winter"] = {
    Theme = {
        Accent  = Color3.fromRGB(140, 190, 255),
        BG0     = Color3.fromRGB(8, 10, 20),
        BG1     = Color3.fromRGB(14, 18, 32),
        BG2     = Color3.fromRGB(18, 24, 40),
        Stroke  = Color3.fromRGB(70, 100, 150),
        Text    = Color3.fromRGB(230, 240, 255),
        Muted   = Color3.fromRGB(150, 170, 200),
        DimText = Color3.fromRGB(110, 130, 170),
        Track   = Color3.fromRGB(24, 28, 40),
        Field   = Color3.fromRGB(18, 20, 30),
    },
    Background = makeWinterBackground,
}

-- Einfaches Oster-Theme mit Pastellfarben --------------------------------

local function makeEasterBackground(win)
    local holder = getHolder(win)
    if not holder then return end

    local folder = Instance.new("Folder")
    folder.Name = "Vanith_EasterBackground"
    folder.Parent = holder

    local base = Instance.new("Frame")
    base.Name = "Base"
    base.BorderSizePixel = 0
    base.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
    base.BackgroundTransparency = 0.4
    base.Size = UDim2.fromScale(1, 1)
    base.ZIndex = 0
    base.Parent = folder

    local colors = {
        Color3.fromRGB(255, 204, 204),
        Color3.fromRGB(255, 229, 204),
        Color3.fromRGB(221, 255, 204),
        Color3.fromRGB(204, 238, 255),
        Color3.fromRGB(229, 204, 255),
    }

    for i = 1, 10 do
        local bubble = Instance.new("Frame")
        bubble.BorderSizePixel = 0
        bubble.BackgroundColor3 = colors[((i - 1) % #colors) + 1]
        bubble.BackgroundTransparency = 0.3
        bubble.Size = UDim2.new(0, 60, 0, 60)
        bubble.Position = UDim2.new(math.random(), -30, math.random(), -30)
        bubble.ZIndex = 1
        bubble.Parent = folder

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = bubble
    end

    return function()
        if folder.Parent then
            folder:Destroy()
        end
    end
end

Themes["Easter"] = {
    Theme = {
        Accent  = Color3.fromRGB(255, 170, 220),
        BG0     = Color3.fromRGB(255, 248, 252),
        BG1     = Color3.fromRGB(250, 236, 248),
        BG2     = Color3.fromRGB(244, 224, 244),
        Stroke  = Color3.fromRGB(220, 190, 220),
        Text    = Color3.fromRGB(90, 60, 90),
        Muted   = Color3.fromRGB(140, 110, 140),
        DimText = Color3.fromRGB(170, 140, 170),
        Track   = Color3.fromRGB(240, 220, 240),
        Field   = Color3.fromRGB(252, 244, 252),
    },
    Background = makeEasterBackground,
}

-- Neon-Theme mit bewegten Linien -----------------------------------------

local function makeNeonBackground(win)
    local holder = getHolder(win)
    if not holder then return end

    local folder = Instance.new("Folder")
    folder.Name = "Vanith_NeonBackground"
    folder.Parent = holder

    local tint = Instance.new("Frame")
    tint.Name = "Tint"
    tint.BorderSizePixel = 0
    tint.BackgroundColor3 = Color3.fromRGB(8, 4, 16)
    tint.BackgroundTransparency = 0.15
    tint.Size = UDim2.fromScale(1, 1)
    tint.ZIndex = 0
    tint.Parent = folder

    local lines = {}
    for i = 1, 8 do
        local line = Instance.new("Frame")
        line.BorderSizePixel = 0
        line.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        line.BackgroundTransparency = 0.4
        line.Size = UDim2.new(1, 0, 0, 2)
        line.Position = UDim2.new(0, 0, (i - 1) / 8, 0)
        line.ZIndex = 1
        line.Parent = folder

        local duration = 3 + math.random() * 3
        local tween = TweenService:Create(
            line,
            TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(0, 0, line.Position.Y.Scale + 0.08, 0)}
        )
        tween:Play()
        table.insert(lines, {frame = line, tween = tween})
    end

    return function()
        for _, item in ipairs(lines) do
            if item.tween then
                pcall(function() item.tween:Cancel() end)
            end
        end
        if folder.Parent then
            folder:Destroy()
        end
    end
end

Themes["Neon"] = {
    Theme = {
        Accent  = Color3.fromRGB(0, 255, 200),
        BG0     = Color3.fromRGB(8, 6, 14),
        BG1     = Color3.fromRGB(14, 10, 24),
        BG2     = Color3.fromRGB(18, 14, 32),
        Stroke  = Color3.fromRGB(60, 40, 90),
        Text    = Color3.fromRGB(235, 235, 255),
        Muted   = Color3.fromRGB(150, 150, 180),
        DimText = Color3.fromRGB(120, 120, 150),
        Track   = Color3.fromRGB(24, 20, 36),
        Field   = Color3.fromRGB(16, 12, 24),
    },
    Background = makeNeonBackground,
}

-- Forest-Theme mit sanften "Lichtflecken" --------------------------------

local function makeForestBackground(win)
    local holder = getHolder(win)
    if not holder then return end

    local folder = Instance.new("Folder")
    folder.Name = "Vanith_ForestBackground"
    folder.Parent = holder

    local base = Instance.new("Frame")
    base.Name = "Base"
    base.BorderSizePixel = 0
    base.BackgroundColor3 = Color3.fromRGB(14, 20, 14)
    base.BackgroundTransparency = 0.2
    base.Size = UDim2.fromScale(1, 1)
    base.ZIndex = 0
    base.Parent = folder

    local spots = {}
    for i = 1, 12 do
        local spot = Instance.new("Frame")
        spot.BorderSizePixel = 0
        spot.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
        spot.BackgroundTransparency = 0.6
        spot.Size = UDim2.new(0, 120, 0, 120)
        spot.Position = UDim2.new(math.random(), -60, math.random(), -60)
        spot.ZIndex = 1
        spot.Parent = folder

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = spot

        local tween = TweenService:Create(
            spot,
            TweenInfo.new(6 + math.random() * 4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundTransparency = 0.3}
        )
        tween:Play()
        table.insert(spots, {frame = spot, tween = tween})
    end

    return function()
        for _, item in ipairs(spots) do
            if item.tween then
                pcall(function() item.tween:Cancel() end)
            end
        end
        if folder.Parent then
            folder:Destroy()
        end
    end
end

Themes["Forest"] = {
    Theme = {
        Accent  = Color3.fromRGB(120, 190, 120),
        BG0     = Color3.fromRGB(10, 16, 10),
        BG1     = Color3.fromRGB(16, 22, 16),
        BG2     = Color3.fromRGB(20, 28, 20),
        Stroke  = Color3.fromRGB(60, 80, 60),
        Text    = Color3.fromRGB(230, 245, 230),
        Muted   = Color3.fromRGB(150, 170, 150),
        DimText = Color3.fromRGB(110, 130, 110),
        Track   = Color3.fromRGB(22, 28, 22),
        Field   = Color3.fromRGB(16, 20, 16),
    },
    Background = makeForestBackground,
}

-- Sunset-Theme mit warmem Verlauf und Partikeln ---------------------------

local function makeSunsetBackground(win)
    local holder = getHolder(win)
    if not holder then return end

    local folder = Instance.new("Folder")
    folder.Name = "Vanith_SunsetBackground"
    folder.Parent = holder

    local base = Instance.new("Frame")
    base.Name = "Base"
    base.BorderSizePixel = 0
    base.BackgroundColor3 = Color3.fromRGB(40, 16, 10)
    base.BackgroundTransparency = 0.15
    base.Size = UDim2.fromScale(1, 1)
    base.ZIndex = 0
    base.Parent = folder

    local particles = {}
    for i = 1, 20 do
        local p = Instance.new("Frame")
        p.BorderSizePixel = 0
        p.BackgroundColor3 = Color3.fromRGB(255, 180, 120)
        p.BackgroundTransparency = 0.4
        p.Size = UDim2.new(0, 3, 0, 3)
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.ZIndex = 1
        p.Parent = folder

        local duration = 4 + math.random() * 4
        local tween = TweenService:Create(
            p,
            TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(p.Position.X.Scale, 0, p.Position.Y.Scale + 0.06, 0)}
        )
        tween:Play()
        table.insert(particles, {frame = p, tween = tween})
    end

    return function()
        for _, item in ipairs(particles) do
            if item.tween then
                pcall(function() item.tween:Cancel() end)
            end
        end
        if folder.Parent then
            folder:Destroy()
        end
    end
end

Themes["Sunset"] = {
    Theme = {
        Accent  = Color3.fromRGB(255, 160, 100),
        BG0     = Color3.fromRGB(22, 10, 8),
        BG1     = Color3.fromRGB(30, 14, 10),
        BG2     = Color3.fromRGB(38, 18, 12),
        Stroke  = Color3.fromRGB(100, 60, 40),
        Text    = Color3.fromRGB(255, 230, 210),
        Muted   = Color3.fromRGB(190, 150, 120),
        DimText = Color3.fromRGB(160, 120, 100),
        Track   = Color3.fromRGB(32, 18, 14),
        Field   = Color3.fromRGB(26, 12, 10),
    },
    Background = makeSunsetBackground,
}

-- Mono-Theme ohne Hintergrundanimation -----------------------------------

Themes["Mono"] = {
    Theme = {
        Accent  = Color3.fromRGB(220, 220, 220),
        BG0     = Color3.fromRGB(12, 12, 12),
        BG1     = Color3.fromRGB(18, 18, 18),
        BG2     = Color3.fromRGB(24, 24, 24),
        Stroke  = Color3.fromRGB(80, 80, 80),
        Text    = Color3.fromRGB(240, 240, 240),
        Muted   = Color3.fromRGB(170, 170, 170),
        DimText = Color3.fromRGB(120, 120, 120),
        Track   = Color3.fromRGB(22, 22, 22),
        Field   = Color3.fromRGB(16, 16, 16),
    },
    Background = nil,
}

-- Ocean-Theme mit sanfter Welle ------------------------------------------

local function makeOceanBackground(win)
    local holder = getHolder(win)
    if not holder then return end

    local folder = Instance.new("Folder")
    folder.Name = "Vanith_OceanBackground"
    folder.Parent = holder

    local base = Instance.new("Frame")
    base.Name = "Base"
    base.BorderSizePixel = 0
    base.BackgroundColor3 = Color3.fromRGB(6, 14, 26)
    base.BackgroundTransparency = 0.2
    base.Size = UDim2.fromScale(1, 1)
    base.ZIndex = 0
    base.Parent = folder

    local wave = Instance.new("Frame")
    wave.BorderSizePixel = 0
    wave.BackgroundColor3 = Color3.fromRGB(60, 130, 200)
    wave.BackgroundTransparency = 0.6
    wave.Size = UDim2.new(1, 0, 0, 80)
    wave.Position = UDim2.new(0, 0, 0.7, 0)
    wave.ZIndex = 1
    wave.Parent = folder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = wave

    local tween = TweenService:Create(
        wave,
        TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(0, 0, 0.62, 0)}
    )
    tween:Play()

    return function()
        pcall(function() tween:Cancel() end)
        if folder.Parent then
            folder:Destroy()
        end
    end
end

Themes["Ocean"] = {
    Theme = {
        Accent  = Color3.fromRGB(120, 190, 255),
        BG0     = Color3.fromRGB(6, 10, 18),
        BG1     = Color3.fromRGB(10, 16, 26),
        BG2     = Color3.fromRGB(14, 20, 32),
        Stroke  = Color3.fromRGB(50, 80, 120),
        Text    = Color3.fromRGB(230, 245, 255),
        Muted   = Color3.fromRGB(150, 175, 200),
        DimText = Color3.fromRGB(110, 135, 160),
        Track   = Color3.fromRGB(18, 24, 32),
        Field   = Color3.fromRGB(12, 18, 26),
    },
    Background = makeOceanBackground,
}

-- alle Themes bei Vanith registrieren ------------------------------------

for name, def in pairs(Themes) do
    VanithRef:RegisterTheme(name, def)
end

return Themes

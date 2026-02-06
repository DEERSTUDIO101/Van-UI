-- Vanith UI - externe Theme-/Hintergrund-Definitionen
-- Diese Datei wird NACH der Hauptdatei 'Van UI.lua' ausgeführt.
-- Sie registriert Themes über Vanith:RegisterTheme(...)

if not Vanith then
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

-- alle Themes bei Vanith registrieren ------------------------------------

for name, def in pairs(Themes) do
    Vanith:RegisterTheme(name, def)
end

return Themes


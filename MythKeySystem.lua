local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()

-- Daten für die Validierung
local trueData = "85eea4d090ee43d99ef357eaecaae134"
local falseData = "7abb4acc362d4d119602450c5a6e4a82"

-- KeyGuardian-Setup
KeyGuardLibrary.Set({
    publicToken = "ca02dc6077074a89b877349f9b9894ab",
    privateToken = "cc60f57a2fe1409187d2677d9c3f5242",
    trueData = trueData,
    falseData = falseData,
})

-- Standardkey
local defaultKey = "prefis8b03e264f1244d7da9db6149389aa1bf"

-- Exportiere Funktionen für MythHub.lua
local MythKeySystem = {}

-- Standardfunktionen
MythKeySystem.getKeyLink = function()
    return KeyGuardLibrary.getLink()
end

MythKeySystem.validateKey = function(key)
    local response = KeyGuardLibrary.validateDefaultKey(key or defaultKey)
    return response == trueData
end

MythKeySystem.isKeyValid = false

-- Modernes 3D-KeySystem
MythKeySystem.initialize = function(savedKey)
    -- Hauptfunktion für das KeySystem
    
    -- Erstelle die UI für das KeySystem
    local KeySystemUI = Instance.new("ScreenGui")
    KeySystemUI.Name = "MythKeySystemUI"
    KeySystemUI.ResetOnSpawn = false
    KeySystemUI.IgnoreGuiInset = true
    KeySystemUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Parent kann CoreGui oder PlayerGui sein
    pcall(function()
        KeySystemUI.Parent = game:GetService("CoreGui")
    end)
    if not KeySystemUI.Parent then
        KeySystemUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Hintergrund Frame mit Blur-Effekt
    local BackgroundFrame = Instance.new("Frame")
    BackgroundFrame.Name = "Background"
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    BackgroundFrame.BackgroundTransparency = 0.2
    BackgroundFrame.BorderSizePixel = 0
    BackgroundFrame.Parent = KeySystemUI
    
    -- Blur-Effekt
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 20
    BlurEffect.Parent = game:GetService("Lighting")
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 500, 0, 400)
    MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainContainer.BackgroundTransparency = 0.1
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = KeySystemUI
    
    -- Abgerundete Ecken für den Container
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainContainer
    
    -- 3D Animation für den Container Eingangseffekt
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    MainContainer.BackgroundTransparency = 1
    local animationTime = 0.5
    local tweenInfo = TweenInfo.new(animationTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local sizeTween = game:GetService("TweenService"):Create(
        MainContainer, 
        tweenInfo, 
        {Size = UDim2.new(0, 500, 0, 400), BackgroundTransparency = 0.1}
    )
    sizeTween:Play()

    -- Logo Container
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.Size = UDim2.new(0, 150, 0, 150)
    LogoContainer.Position = UDim2.new(0.5, 0, 0, 60)
    LogoContainer.AnchorPoint = Vector2.new(0.5, 0)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = MainContainer
    
    -- Logo Image
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "LogoImage"
    LogoImage.Size = UDim2.new(1, 0, 1, 0)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "https://raw.githubusercontent.com/SainteOfficial/pesawgpuhwepughp-wgeinw-/refs/heads/master/MYTHLOGO.png"
    LogoImage.ScaleType = Enum.ScaleType.Fit
    LogoImage.Parent = LogoContainer
    
    -- 3D Rotation Animation für das Logo
    spawn(function()
        local angle = 0
        local angleY = 0
        while KeySystemUI.Parent do
            angle = angle + 2
            angleY = 10 * math.sin(math.rad(angle))
            
            LogoImage.Rotation = angleY
            LogoImage.ImageTransparency = 0.05 + (math.sin(math.rad(angle*2)) * 0.1)
            LogoImage.Size = UDim2.new(
                0.95 + (math.sin(math.rad(angle*3)) * 0.05),
                0,
                0.95 + (math.sin(math.rad(angle*3)) * 0.05),
                0
            )
            
            wait(0.016) -- ~60fps
        end
    end)
    
    -- Titel mit Gradient
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0, 50)
    TitleLabel.Position = UDim2.new(0, 0, 0, 220)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "MYTH HUB"
    TitleLabel.TextSize = 32
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = MainContainer
    
    -- Animierter Gradient für den Titel
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 255))
    })
    TitleGradient.Parent = TitleLabel
    
    -- Animiere den Gradient
    spawn(function()
        local offset = 0
        while KeySystemUI.Parent do
            offset = (offset + 0.003) % 1
            TitleGradient.Offset = Vector2.new(offset, 0)
            wait(0.016)
        end
    end)
    
    -- Key Input Box
    local KeyBox = Instance.new("TextBox")
    KeyBox.Name = "KeyBox"
    KeyBox.Size = UDim2.new(0, 350, 0, 50)
    KeyBox.Position = UDim2.new(0.5, 0, 0, 280)
    KeyBox.AnchorPoint = Vector2.new(0.5, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    KeyBox.BackgroundTransparency = 0.3
    KeyBox.BorderSizePixel = 0
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.Text = savedKey or ""
    KeyBox.PlaceholderText = "Enter your key here..."
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 18
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = MainContainer
    
    -- Abgerundete Ecken für die TextBox
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 8)
    KeyBoxCorner.Parent = KeyBox
    
    -- Animierter Border
    local KeyBorder = Instance.new("UIStroke")
    KeyBorder.Color = Color3.fromRGB(80, 80, 200)
    KeyBorder.Thickness = 2
    KeyBorder.Parent = KeyBox
    
    -- Animiere den Border
    spawn(function()
        local sinVal = 0
        while KeySystemUI.Parent do
            sinVal = sinVal + 0.05
            KeyBorder.Color = Color3.fromRGB(
                80 + (30 * math.sin(sinVal)),
                80 + (30 * math.sin(sinVal + 2)),
                200 + (30 * math.sin(sinVal + 4))
            )
            wait(0.016)
        end
    end)
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(0, 350, 0, 30)
    StatusLabel.Position = UDim2.new(0.5, 0, 0, 340)
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Enter your key to continue"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 16
    StatusLabel.Parent = MainContainer
    
    -- Buttons Container
    local ButtonsContainer = Instance.new("Frame")
    ButtonsContainer.Name = "ButtonsContainer"
    ButtonsContainer.Size = UDim2.new(0, 350, 0, 50)
    ButtonsContainer.Position = UDim2.new(0.5, 0, 0, 380)
    ButtonsContainer.AnchorPoint = Vector2.new(0.5, 0)
    ButtonsContainer.BackgroundTransparency = 1
    ButtonsContainer.Parent = MainContainer
    
    -- Submit Button
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(0, 150, 0, 40)
    SubmitButton.Position = UDim2.new(0, 0, 0, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
    SubmitButton.BackgroundTransparency = 0.1
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Text = "VERIFY"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 18
    SubmitButton.Parent = ButtonsContainer
    
    -- Abgerundete Ecken für Submit Button
    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 8)
    SubmitCorner.Parent = SubmitButton
    
    -- Gradient für Submit Button
    local SubmitGradient = Instance.new("UIGradient")
    SubmitGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 240))
    })
    SubmitGradient.Rotation = 90
    SubmitGradient.Parent = SubmitButton
    
    -- Get Key Button
    local GetKeyButton = Instance.new("TextButton")
    GetKeyButton.Name = "GetKeyButton"
    GetKeyButton.Size = UDim2.new(0, 150, 0, 40)
    GetKeyButton.Position = UDim2.new(1, 0, 0, 0)
    GetKeyButton.AnchorPoint = Vector2.new(1, 0)
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    GetKeyButton.BackgroundTransparency = 0.1
    GetKeyButton.BorderSizePixel = 0
    GetKeyButton.Font = Enum.Font.GothamBold
    GetKeyButton.Text = "GET KEY"
    GetKeyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    GetKeyButton.TextSize = 18
    GetKeyButton.Parent = ButtonsContainer
    
    -- Abgerundete Ecken für Get Key Button
    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 8)
    GetKeyCorner.Parent = GetKeyButton
    
    -- Hover-Animation für Submit Button
    SubmitButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            SubmitButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 160, 0, 45), BackgroundColor3 = Color3.fromRGB(100, 100, 220)}
        ):Play()
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            SubmitButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 150, 0, 40), BackgroundColor3 = Color3.fromRGB(80, 80, 200)}
        ):Play()
    end)
    
    -- Hover-Animation für Get Key Button
    GetKeyButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            GetKeyButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 160, 0, 45), BackgroundColor3 = Color3.fromRGB(60, 60, 90)}
        ):Play()
    end)
    
    GetKeyButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            GetKeyButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 150, 0, 40), BackgroundColor3 = Color3.fromRGB(50, 50, 70)}
        ):Play()
    end)
    
    -- Funktionstaste für Enter
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Return and KeySystemUI.Parent then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Hintergrund-Partikel Animation
    for i = 1, 30 do
        local particle = Instance.new("Frame")
        particle.Name = "Particle" .. i
        particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = Color3.fromRGB(
            math.random(100, 200),
            math.random(100, 200),
            math.random(200, 255)
        )
        particle.BackgroundTransparency = math.random(7, 9) / 10
        particle.BorderSizePixel = 0
        particle.ZIndex = 0
        particle.Parent = MainContainer
        
        -- Runde Partikel
        local particleCorner = Instance.new("UICorner")
        particleCorner.CornerRadius = UDim.new(1, 0)
        particleCorner.Parent = particle
        
        -- Partikel Animation
        spawn(function()
            local speedX = math.random(-20, 20) / 1000
            local speedY = math.random(-20, 20) / 1000
            
            while KeySystemUI.Parent do
                particle.Position = UDim2.new(
                    (particle.Position.X.Scale + speedX) % 1,
                    0,
                    (particle.Position.Y.Scale + speedY) % 1,
                    0
                )
                wait(0.016)
            end
        end)
    end
    
    -- Submit Button Funktionalität
    SubmitButton.MouseButton1Click:Connect(function()
        -- Klick-Animation
        game:GetService("TweenService"):Create(
            SubmitButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 140, 0, 35)}
        ):Play()
        
        wait(0.1)
        
        game:GetService("TweenService"):Create(
            SubmitButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 150, 0, 40)}
        ):Play()
        
        -- Validierung
        local keyInput = KeyBox.Text
        
        if keyInput == "" then
            -- Fehler-Animation
            StatusLabel.Text = "Please enter a key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Schüttel-Animation für die TextBox
            local originalPosition = KeyBox.Position
            for i = 1, 5 do
                KeyBox.Position = originalPosition + UDim2.new(0, 5, 0, 0)
                wait(0.05)
                KeyBox.Position = originalPosition - UDim2.new(0, 5, 0, 0)
                wait(0.05)
            end
            KeyBox.Position = originalPosition
            return
        end
        
        -- Lade-Animation
        StatusLabel.Text = "Verifying your key..."
        StatusLabel.TextColor3 = Color3.fromRGB(80, 170, 255)
        
        -- Key validieren
        local isValid = MythKeySystem.validateKey(keyInput)
        
        if isValid then
            -- Erfolg-Animation
            StatusLabel.Text = "Key verified successfully!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- Speichere den key
            local WindowUtil = game:GetService("ReplicatedStorage"):FindFirstChild("SharedModules") and 
                               require(game:GetService("ReplicatedStorage").SharedModules:FindFirstChild("WindowUtil"))
                               
            if WindowUtil then
                WindowUtil:SetSetting("MythHubKey", keyInput)
            end
            
            -- Erfolgreich-Animation
            for i = 1, 3 do
                local originalSize = LogoImage.Size
                game:GetService("TweenService"):Create(
                    LogoImage,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(1.2, 0, 1.2, 0)}
                ):Play()
                wait(0.2)
                game:GetService("TweenService"):Create(
                    LogoImage,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {Size = originalSize}
                ):Play()
                wait(0.2)
            end
            
            -- Schließen-Animation
            game:GetService("TweenService"):Create(
                MainContainer,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
            ):Play()
            
            -- Blur entfernen
            for i = 20, 0, -1 do
                BlurEffect.Size = i
                wait(0.02)
            end
            
            wait(0.5)
            
            -- UI entfernen
            KeySystemUI:Destroy()
            BlurEffect:Destroy()
            
            -- Key ist valid
            MythKeySystem.isKeyValid = true
            return true
        else
            -- Fehler-Animation
            StatusLabel.Text = "Invalid key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Schüttel-Animation für die TextBox
            local originalPosition = KeyBox.Position
            for i = 1, 5 do
                KeyBox.Position = originalPosition + UDim2.new(0, 5, 0, 0)
                wait(0.05)
                KeyBox.Position = originalPosition - UDim2.new(0, 5, 0, 0)
                wait(0.05)
            end
            KeyBox.Position = originalPosition
            
            -- Key ist invalid
            MythKeySystem.isKeyValid = false
            return false
        end
    end)
    
    -- Get Key Button Funktionalität
    GetKeyButton.MouseButton1Click:Connect(function()
        -- Klick-Animation
        game:GetService("TweenService"):Create(
            GetKeyButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 140, 0, 35)}
        ):Play()
        
        wait(0.1)
        
        game:GetService("TweenService"):Create(
            GetKeyButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 150, 0, 40)}
        ):Play()
        
        -- KeyGuardian Link kopieren
        local keyLink = MythKeySystem.getKeyLink()
        setclipboard(keyLink)
        
        -- Bestätigungs-Animation
        StatusLabel.Text = "Key link copied to clipboard!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Bestätigungs-Blink Animation
        for i = 1, 3 do
            GetKeyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            wait(0.1)
            GetKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            wait(0.1)
        end
    end)
    
    -- Drag-Funktion für das UI
    local UserInputService = game:GetService("UserInputService")
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    MainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                local delta = input.Position - dragStart
                MainContainer.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    -- Prüfe den anfangs übergebenen Key
    if savedKey and savedKey ~= "" then
        local isValid = MythKeySystem.validateKey(savedKey)
        MythKeySystem.isKeyValid = isValid
        
        if isValid then
            -- Schließen-Animation wenn key valid ist
            game:GetService("TweenService"):Create(
                MainContainer,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
            ):Play()
            
            -- Blur entfernen
            for i = 20, 0, -1 do
                BlurEffect.Size = i
                wait(0.02)
            end
            
            wait(0.5)
            
            -- UI entfernen
            KeySystemUI:Destroy()
            BlurEffect:Destroy()
            
            return true
        end
    end
    
    -- Falls wir hier ankommen, bleib bei der UI und gib false zurück
    return false
end

-- Rückgabe des KeySystems
return MythKeySystem

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

-- Premium KeySystem im minimalistischen Design
MythKeySystem.initialize = function(savedKey)
    -- Services
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    
    -- Hauptfunktion für das KeySystem
    -- Erstelle die UI für das KeySystem
    local KeySystemUI = Instance.new("ScreenGui")
    KeySystemUI.Name = "MythKeySystemUI"
    KeySystemUI.ResetOnSpawn = false
    KeySystemUI.IgnoreGuiInset = true
    KeySystemUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    KeySystemUI.DisplayOrder = 999
    
    -- Parent kann CoreGui oder PlayerGui sein
    pcall(function()
        KeySystemUI.Parent = game:GetService("CoreGui")
    end)
    if not KeySystemUI.Parent then
        KeySystemUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Blur-Effekt
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 0
    BlurEffect.Parent = game:GetService("Lighting")
    
    -- Animiere Blur
    TweenService:Create(BlurEffect, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = 20}):Play()
    
    -- Background Image mit Parallax-Effekt
    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "BackgroundImage"
    BackgroundImage.Size = UDim2.new(1.2, 0, 1.2, 0) -- Größer für Parallax-Effekt
    BackgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    BackgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
    BackgroundImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundImage.Image = "rbxassetid://13928991786" -- Anime city
    BackgroundImage.ImageTransparency = 0
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.Parent = KeySystemUI
    
    -- Animiere Hintergrundbild
    TweenService:Create(BackgroundImage, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {ImageTransparency = 0.2}):Play()
    
    -- Parallax-Effekt für den Hintergrund
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local viewportSize = workspace.CurrentCamera.ViewportSize
            
            local xOffset = (mousePos.X / viewportSize.X) - 0.5
            local yOffset = (mousePos.Y / viewportSize.Y) - 0.5
            
            TweenService:Create(BackgroundImage, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5 - (xOffset * 0.05), 0, 0.5 - (yOffset * 0.05), 0)
            }):Play()
        end
    end)
    
    -- Animation für sanftes Zoomen des Hintergrunds
    spawn(function()
        local originalSize = UDim2.new(1.2, 0, 1.2, 0)
        local zoomedSize = UDim2.new(1.25, 0, 1.25, 0)
        
        while KeySystemUI.Parent do
            TweenService:Create(BackgroundImage, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = zoomedSize}):Play()
            wait(15)
            TweenService:Create(BackgroundImage, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = originalSize}):Play()
            wait(15)
        end
    end)
    
    -- Blur-Overlay anstatt Dark-Overlay für Glasmorphism-Effekt
    local BlurOverlay = Instance.new("Frame")
    BlurOverlay.Name = "BlurOverlay"
    BlurOverlay.Size = UDim2.new(1, 0, 1, 0)
    BlurOverlay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    BlurOverlay.BackgroundTransparency = 1
    BlurOverlay.BorderSizePixel = 0
    BlurOverlay.Parent = KeySystemUI
    
    -- Animiere Blur-Overlay
    TweenService:Create(BlurOverlay, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundTransparency = 0.65}):Play()
    
    -- Füge Partikel für Dynamik hinzu
    spawn(function()
        for i = 1, 30 do
            local particle = Instance.new("Frame")
            particle.Name = "Particle" .. i
            particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
            particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            particle.BackgroundTransparency = math.random(7, 9) / 10
            particle.BorderSizePixel = 0
            particle.ZIndex = 2
            particle.Parent = BlurOverlay
            
            local cornerRadius = Instance.new("UICorner")
            cornerRadius.CornerRadius = UDim.new(1, 0)
            cornerRadius.Parent = particle
            
            spawn(function()
                local speed = math.random(10, 40) / 1000
                local direction = math.random() > 0.5 and 1 or -1
                
                while KeySystemUI.Parent do
                    particle.Position = UDim2.new(
                        particle.Position.X.Scale,
                        0,
                        (particle.Position.Y.Scale + (speed * direction)) % 1,
                        0
                    )
                    particle.Rotation = particle.Rotation + (speed * 50)
                    wait()
                end
            end)
        end
    end)
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    MainContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainContainer.BackgroundTransparency = 1
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = KeySystemUI
    
    -- Abgerundete Ecken für den Container
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainContainer
    
    -- Animiere Container Erscheinen
    TweenService:Create(MainContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 260),
        BackgroundTransparency = 0.2
    }):Play()
    
    -- Inneres Glow für den Container
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 80, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 1
    UIStroke.Parent = MainContainer
    
    -- Animiere Glow
    TweenService:Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Transparency = 0.7}):Play()
    
    -- Animiere UIStroke Farbe
    spawn(function()
        local hue = 0
        
        while KeySystemUI.Parent do
            hue = (hue + 0.001) % 1
            UIStroke.Color = Color3.fromHSV(hue, 0.8, 1)
            RunService.RenderStepped:Wait()
        end
    end)
    
    -- Glaseffekt
    local GlassOverlay = Instance.new("Frame")
    GlassOverlay.Name = "GlassOverlay"
    GlassOverlay.Size = UDim2.new(1, 0, 1, 0)
    GlassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassOverlay.BackgroundTransparency = 0.94
    GlassOverlay.BorderSizePixel = 0
    GlassOverlay.Parent = MainContainer
    
    -- Header mit Titel
    local HeaderContainer = Instance.new("Frame")
    HeaderContainer.Name = "HeaderContainer"
    HeaderContainer.Size = UDim2.new(1, 0, 0, 70)
    HeaderContainer.BackgroundTransparency = 1
    HeaderContainer.Parent = MainContainer
    
    -- Drei Punkte
    local DotsContainer = Instance.new("Frame")
    DotsContainer.Name = "DotsContainer"
    DotsContainer.Size = UDim2.new(1, 0, 0, 20)
    DotsContainer.Position = UDim2.new(0, 0, 0, 10)
    DotsContainer.BackgroundTransparency = 1
    DotsContainer.Parent = HeaderContainer
    
    -- Erstelle die drei Punkte
    for i = 1, 3 do
        local Dot = Instance.new("Frame")
        Dot.Name = "Dot" .. i
        Dot.Size = UDim2.new(0, 4, 0, 4)
        Dot.Position = UDim2.new(0.5, (i-2) * 8, 0.5, 0)
        Dot.AnchorPoint = Vector2.new(0.5, 0.5)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dot.BackgroundTransparency = 1
        Dot.BorderSizePixel = 0
        
        local UICornerDot = Instance.new("UICorner")
        UICornerDot.CornerRadius = UDim.new(1, 0)
        UICornerDot.Parent = Dot
        
        Dot.Parent = DotsContainer
        
        -- Animiere das Erscheinen der Punkte
        TweenService:Create(Dot, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.1 * i), {
            BackgroundTransparency = 0.2
        }):Play()
    end
    
    -- Titel
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Position = UDim2.new(0, 0, 0, 30)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "MYTHHUB PREMIUM"
    TitleLabel.TextSize = 22
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = HeaderContainer
    
    -- Animiere Titel
    TweenService:Create(TitleLabel, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.3), {
        TextTransparency = 0
    }):Play()
    
    -- Untertitel
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 20)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, 55)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = "AUTHENTICATION SYSTEM"
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.TextTransparency = 1
    SubtitleLabel.Parent = HeaderContainer
    
    -- Animiere Untertitel
    TweenService:Create(SubtitleLabel, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.4), {
        TextTransparency = 0
    }):Play()
    
    -- Key Input Box
    local KeyInputContainer = Instance.new("Frame")
    KeyInputContainer.Name = "KeyInputContainer"
    KeyInputContainer.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInputContainer.Position = UDim2.new(0.5, 0, 0, 100)
    KeyInputContainer.AnchorPoint = Vector2.new(0.5, 0)
    KeyInputContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    KeyInputContainer.BackgroundTransparency = 1
    KeyInputContainer.BorderSizePixel = 0
    KeyInputContainer.Parent = MainContainer
    
    -- Abgerundete Ecken für Input
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = KeyInputContainer
    
    -- Animiere Input Container
    TweenService:Create(KeyInputContainer, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.5), {
        BackgroundTransparency = 0.8
    }):Play()
    
    -- Input Box Stroke
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(60, 80, 255)
    InputStroke.Thickness = 1.5
    InputStroke.Transparency = 1
    InputStroke.Parent = KeyInputContainer
    
    -- Animiere Input Stroke
    TweenService:Create(InputStroke, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.5), {
        Transparency = 0.7
    }):Play()
    
    -- Input Icon
    local InputIcon = Instance.new("ImageLabel")
    InputIcon.Name = "InputIcon"
    InputIcon.Size = UDim2.new(0, 20, 0, 20)
    InputIcon.Position = UDim2.new(0, 12, 0.5, 0)
    InputIcon.AnchorPoint = Vector2.new(0, 0.5)
    InputIcon.BackgroundTransparency = 1
    InputIcon.Image = "rbxassetid://9405924327" -- Key icon
    InputIcon.ImageTransparency = 1
    InputIcon.Parent = KeyInputContainer
    
    -- Animiere Icon
    TweenService:Create(InputIcon, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.6), {
        ImageTransparency = 0.2
    }):Play()
    
    -- Input Box Text
    local KeyBox = Instance.new("TextBox")
    KeyBox.Name = "KeyBox"
    KeyBox.Size = UDim2.new(1, -50, 1, 0)
    KeyBox.Position = UDim2.new(0, 40, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.Text = savedKey or ""
    KeyBox.PlaceholderText = "Enter your key here..."
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
    KeyBox.TextSize = 14
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.ClearTextOnFocus = false
    KeyBox.TextTransparency = 1
    KeyBox.Parent = KeyInputContainer
    
    -- Animiere TextBox
    TweenService:Create(KeyBox, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.6), {
        TextTransparency = 0
    }):Play()
    
    -- Verify Button
    local VerifyButton = Instance.new("TextButton")
    VerifyButton.Name = "VerifyButton"
    VerifyButton.Size = UDim2.new(0.85, 0, 0, 45)
    VerifyButton.Position = UDim2.new(0.5, 0, 0, 160)
    VerifyButton.AnchorPoint = Vector2.new(0.5, 0)
    VerifyButton.BackgroundColor3 = Color3.fromRGB(40, 70, 255)
    VerifyButton.BackgroundTransparency = 1
    VerifyButton.BorderSizePixel = 0
    VerifyButton.Font = Enum.Font.GothamBold
    VerifyButton.Text = "VERIFY KEY"
    VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyButton.TextSize = 16
    VerifyButton.TextTransparency = 1
    VerifyButton.Parent = MainContainer
    
    -- Button abgerundete Ecken
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = VerifyButton
    
    -- Button Gradient
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 70, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 120, 255))
    })
    ButtonGradient.Rotation = 45
    ButtonGradient.Parent = VerifyButton
    
    -- Animiere Button
    TweenService:Create(VerifyButton, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.7), {
        BackgroundTransparency = 0,
        TextTransparency = 0
    }):Play()
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(0.85, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0.5, 0, 0, 215)
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Please enter your key"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusLabel.TextSize = 14
    StatusLabel.TextTransparency = 1
    StatusLabel.Parent = MainContainer
    
    -- Animiere Status
    TweenService:Create(StatusLabel, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.8), {
        TextTransparency = 0
    }):Play()
    
    -- Get Key Button
    local GetKeyButton = Instance.new("TextButton")
    GetKeyButton.Name = "GetKeyButton"
    GetKeyButton.Size = UDim2.new(0.3, 0, 0, 20)
    GetKeyButton.Position = UDim2.new(0.5, 0, 0, 235)
    GetKeyButton.AnchorPoint = Vector2.new(0.5, 0)
    GetKeyButton.BackgroundTransparency = 1
    GetKeyButton.Font = Enum.Font.Gotham
    GetKeyButton.Text = "GET KEY"
    GetKeyButton.TextColor3 = Color3.fromRGB(80, 120, 255)
    GetKeyButton.TextSize = 14
    GetKeyButton.TextTransparency = 0
    GetKeyButton.Parent = MainContainer
    
    -- Animiere Get Key Button
    TweenService:Create(GetKeyButton, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0.9), {
        TextTransparency = 0
    }):Play()
    
    -- Animiere Get Key Button Hover-Effekt
    GetKeyButton.MouseEnter:Connect(function()
        TweenService:Create(GetKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(120, 150, 255)
        }):Play()
    end)
    
    GetKeyButton.MouseLeave:Connect(function()
        TweenService:Create(GetKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(80, 120, 255)
        }):Play()
    end)
    
    -- Animiere Verify Button Hover
    VerifyButton.MouseEnter:Connect(function()
        TweenService:Create(VerifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 90, 255)
        }):Play()
    end)
    
    VerifyButton.MouseLeave:Connect(function()
        TweenService:Create(VerifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 70, 255)
        }):Play()
    end)
    
    -- Animation Input Box wenn Fokus
    KeyBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0,
            Color = Color3.fromRGB(100, 150, 255)
        }):Play()
        
        TweenService:Create(KeyInputContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.7
        }):Play()
    end)
    
    KeyBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.7,
            Color = Color3.fromRGB(60, 80, 255)
        }):Play()
        
        TweenService:Create(KeyInputContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        }):Play()
    end)
    
    -- Enter-Taste Funktion
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Return and KeySystemUI.Parent then
            VerifyButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Verify Button Funktionalität
    VerifyButton.MouseButton1Click:Connect(function()
        -- Klick-Animation
        TweenService:Create(VerifyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.8, 0, 0, 42)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(VerifyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.85, 0, 0, 45)
        }):Play()
        
        -- Validierung
        local keyInput = KeyBox.Text
        
        if keyInput == "" then
            -- Fehler-Animation
            StatusLabel.Text = "Please enter a key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Schüttel-Animation für die TextBox
            local originalPosition = KeyInputContainer.Position
            for i = 1, 5 do
                TweenService:Create(KeyInputContainer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = originalPosition + UDim2.new(0, 5, 0, 0)
                }):Play()
                wait(0.05)
                TweenService:Create(KeyInputContainer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = originalPosition - UDim2.new(0, 5, 0, 0)
                }):Play()
                wait(0.05)
            end
            TweenService:Create(KeyInputContainer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = originalPosition
            }):Play()
            
            return
        end
        
        -- Lade-Animation
        StatusLabel.Text = "Verifying..."
        StatusLabel.TextColor3 = Color3.fromRGB(80, 170, 255)
        
        -- Key validieren
        local isValid = MythKeySystem.validateKey(keyInput)
        
        if isValid then
            -- Erfolg-Animation
            StatusLabel.Text = "Success! Welcome to MYTHHUB PREMIUM"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- Speichere den key
            local WindowUtil = game:GetService("ReplicatedStorage"):FindFirstChild("SharedModules") and 
                               require(game:GetService("ReplicatedStorage").SharedModules:FindFirstChild("WindowUtil"))
                               
            if WindowUtil then
                WindowUtil:SetSetting("MythHubKey", keyInput)
            end
            
            -- Erfolgsanimation für den Button
            TweenService:Create(VerifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            }):Play()
            
            -- Pulsierender Effekt für den Button
            for i = 1, 3 do
                TweenService:Create(VerifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0.9, 0, 0, 50)
                }):Play()
                wait(0.3)
                TweenService:Create(VerifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.new(0.85, 0, 0, 45)
                }):Play()
                wait(0.3)
            end
            
            -- Animiere das Ausblenden des UI
            TweenService:Create(MainContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(BlurOverlay, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(BackgroundImage, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play()
            
            -- Blur ausblenden
            TweenService:Create(BlurEffect, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                Size = 0
            }):Play()
            
            wait(0.9)
            
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
            local originalPosition = KeyInputContainer.Position
            for i = 1, 5 do
                TweenService:Create(KeyInputContainer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = originalPosition + UDim2.new(0, 5, 0, 0)
                }):Play()
                wait(0.05)
                TweenService:Create(KeyInputContainer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = originalPosition - UDim2.new(0, 5, 0, 0)
                }):Play()
                wait(0.05)
            end
            TweenService:Create(KeyInputContainer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = originalPosition
            }):Play()
            
            -- Key ist invalid
            MythKeySystem.isKeyValid = false
            return false
        end
    end)
    
    -- Get Key Button Funktionalität
    GetKeyButton.MouseButton1Click:Connect(function()
        -- Klick-Animation
        TweenService:Create(GetKeyButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextSize = 16
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(GetKeyButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextSize = 14
        }):Play()
        
        -- KeyGuardian Link kopieren
        local keyLink = MythKeySystem.getKeyLink()
        setclipboard(keyLink)
        
        -- Bestätigungs-Animation
        local originalText = GetKeyButton.Text
        GetKeyButton.Text = "COPIED!"
        StatusLabel.Text = "Key link copied to clipboard!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Bestätigungs-Animation für Button
        TweenService:Create(GetKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(100, 255, 100)
        }):Play()
        
        wait(2)
        
        -- Reset Button
        GetKeyButton.Text = originalText
        TweenService:Create(GetKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(80, 120, 255)
        }):Play()
        
        StatusLabel.Text = "Please enter your key"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)
    
    -- Drag-Funktion für das UI
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
                TweenService:Create(MainContainer, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                }):Play()
            end
        end
    end)
    
    -- Prüfe den anfangs übergebenen Key
    if savedKey and savedKey ~= "" then
        local isValid = MythKeySystem.validateKey(savedKey)
        MythKeySystem.isKeyValid = isValid
        
        if isValid then
            -- Wenn key gültig ist, UI ausblenden
            TweenService:Create(MainContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(BlurOverlay, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(BackgroundImage, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play()
            
            -- Blur ausblenden
            TweenService:Create(BlurEffect, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                Size = 0
            }):Play()
            
            wait(0.9)
            
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

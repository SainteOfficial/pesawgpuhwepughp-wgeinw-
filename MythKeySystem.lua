local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()

-- Key System Configurations
local publicToken = "m4gixscrpter"
local privateToken = "0v9ASD90vas90vDSAOvjdsa90VDSOAVDSOJA(DJSa90vjdsaVDSAojvdas90VDSJADSAV"
local trueData = "mythhub authorized"
local falseData = ""
local logoUrl = "https://raw.githubusercontent.com/SainteOfficial/pesawgpuhwepughp-wgeinw-/refs/heads/master/MYTHLOGO.png"
local fadeInSpeed = 0.6
local fadeOutSpeed = 0.8

-- Create the key system object
local KeySystem = KeyGuardLibrary:CreateKeySystem(publicToken, privateToken, trueData, falseData)

-- Functions for the key system
local function GetKeyLink()
    return KeySystem:GetLink()
end

local function KeyIsValid(key)
    return KeySystem:VerifyKey(key)
end

-- Export the key system object
local MythKeySystem = {}
MythKeySystem.KeyIsValid = KeyIsValid
MythKeySystem.GetKeyLink = GetKeyLink

-- Diese Funktion wird von MythHub.lua aufgerufen
function MythKeySystem.initialize()
    return MythKeySystem.ValidateKey()
end

-- UI elements and animations for the key system
function MythKeySystem.CreateKeyUI()
    -- Main player variables
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    -- Services
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    
    -- Create the ScreenGUI
    local keySystemGui = Instance.new("ScreenGui")
    keySystemGui.Name = "MythKeySystem"
    keySystemGui.IgnoreGuiInset = true
    keySystemGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keySystemGui.ResetOnSpawn = false
    keySystemGui.Parent = player.PlayerGui
    
    -- Create the background with enhanced blur effect
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.Parent = keySystemGui
    
    -- Add blur effect
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 15
    blurEffect.Parent = game:GetService("Lighting")
    
    -- Add atmospheric particles
    local particles = Instance.new("Frame")
    particles.Name = "Particles"
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.BorderSizePixel = 0
    particles.Parent = keySystemGui
    particles.ZIndex = 2
    
    -- Generate particle elements
    for i = 1, 30 do
        local particle = Instance.new("Frame")
        particle.Name = "Particle_" .. i
        particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = Color3.fromRGB(
            math.random(180, 255),
            math.random(180, 255),
            math.random(200, 255)
        )
        particle.BackgroundTransparency = math.random(40, 80)/100
        particle.BorderSizePixel = 0
        particle.ZIndex = 2
        
        -- Round corners for particles
        local particleCorner = Instance.new("UICorner")
        particleCorner.CornerRadius = UDim.new(1, 0)
        particleCorner.Parent = particle
        
        particle.Parent = particles
        
        -- Animate particles
        spawn(function()
            while particle.Parent do
                local duration = math.random(3, 8)
                local targetPos = UDim2.new(math.random(), 0, math.random(), 0)
                TweenService:Create(
                    particle, 
                    TweenInfo.new(duration, Enum.EasingStyle.Linear), 
                    {Position = targetPos, BackgroundTransparency = math.random(40, 80)/100}
                ):Play()
                wait(duration)
            end
        end)
    end
    
    -- Main container for all UI elements with enhanced 3D effect
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 420, 0, 520)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainContainer.BorderSizePixel = 0
    mainContainer.BackgroundTransparency = 0.05
    mainContainer.Parent = keySystemGui
    mainContainer.ZIndex = 5
    
    -- Rounded corners for the container
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = UDim.new(0, 20)
    cornerRadius.Parent = mainContainer
    
    -- Enhanced 3D shadow for the container
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 60, 1, 60)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.Parent = mainContainer
    shadow.ZIndex = 4

    -- Premium gradient for the container
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    gradient.Rotation = 45
    gradient.Parent = mainContainer
    
    -- Inner glow effect
    local innerGlow = Instance.new("Frame")
    innerGlow.Name = "InnerGlow"
    innerGlow.Size = UDim2.new(1, -4, 1, -4)
    innerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    innerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    innerGlow.BackgroundTransparency = 1
    innerGlow.BorderSizePixel = 0
    innerGlow.ZIndex = 6
    innerGlow.Parent = mainContainer
    
    local innerGlowStroke = Instance.new("UIStroke")
    innerGlowStroke.Color = Color3.fromRGB(100, 100, 240)
    innerGlowStroke.Thickness = 2
    innerGlowStroke.Transparency = 0.7
    innerGlowStroke.Parent = innerGlow
    
    local innerGlowCorner = Instance.new("UICorner")
    innerGlowCorner.CornerRadius = UDim.new(0, 18)
    innerGlowCorner.Parent = innerGlow
    
    -- Logo container with enhanced 3D effect
    local logoContainer = Instance.new("Frame")
    logoContainer.Name = "LogoContainer"
    logoContainer.Size = UDim2.new(0, 160, 0, 160)
    logoContainer.Position = UDim2.new(0.5, 0, 0, 60)
    logoContainer.AnchorPoint = Vector2.new(0.5, 0)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = mainContainer
    logoContainer.ZIndex = 7
    
    -- Logo with enhanced 3D shadow
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.BackgroundTransparency = 1
    logo.Image = logoUrl
    logo.Parent = logoContainer
    logo.ZIndex = 8
    
    -- Enhanced 3D effect for the logo
    local logoShadow = Instance.new("ImageLabel")
    logoShadow.Name = "LogoShadow"
    logoShadow.Size = UDim2.new(1, 30, 1, 30)
    logoShadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    logoShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    logoShadow.BackgroundTransparency = 1
    logoShadow.Image = logoUrl
    logoShadow.ImageTransparency = 0.8
    logoShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    logoShadow.Parent = logoContainer
    logoShadow.ZIndex = 7

    -- Logo glow effect
    local logoGlow = Instance.new("ImageLabel")
    logoGlow.Name = "LogoGlow"
    logoGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
    logoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    logoGlow.BackgroundTransparency = 1
    logoGlow.Image = logoUrl
    logoGlow.ImageTransparency = 0.9
    logoGlow.ImageColor3 = Color3.fromRGB(120, 120, 255)
    logoGlow.Parent = logoContainer
    logoGlow.ZIndex = 6
    
    -- Animate logo pulsing
    spawn(function()
        while logoGlow.Parent do
            local growInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local shrinkInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            
            local growTween = TweenService:Create(logoGlow, growInfo, {
                Size = UDim2.new(1.4, 0, 1.4, 0),
                ImageTransparency = 0.7
            })
            
            local shrinkTween = TweenService:Create(logoGlow, shrinkInfo, {
                Size = UDim2.new(1.2, 0, 1.2, 0),
                ImageTransparency = 0.9
            })
            
            growTween:Play()
            wait(2)
            shrinkTween:Play()
            wait(2)
        end
    end)
    
    -- Create floating effect for logo
    spawn(function()
        local floatOffset = 0
        local floatSpeed = 1
        local originalY = logo.Position.Y.Scale
        
        RunService.RenderStepped:Connect(function(dt)
            if not logo.Parent then return end
            
            floatOffset = floatOffset + dt * floatSpeed
            local newY = originalY + math.sin(floatOffset) * 0.02
            
            logo.Position = UDim2.new(0.5, 0, newY, 0)
            logoShadow.Position = UDim2.new(0.5, 0, newY + 0.02, 8)
        end)
    end)
    
    -- Title with premium styling
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 300, 0, 50)
    title.Position = UDim2.new(0.5, 0, 0, 220)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "MythHub KeySystem"
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = mainContainer
    title.ZIndex = 9
    
    -- Add text stroke for better visibility
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(80, 80, 200)
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.7
    titleStroke.Parent = title
    
    -- Text gradient
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 255))
    })
    titleGradient.Parent = title
    
    -- Animate title gradient
    spawn(function()
        local offset = 0
        while title.Parent do
            offset = (offset + 0.5) % 1
            titleGradient.Offset = Vector2.new(offset, 0)
            wait(0.03)
        end
    end)
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(0, 300, 0, 30)
    subtitle.Position = UDim2.new(0.5, 0, 0, 265)
    subtitle.AnchorPoint = Vector2.new(0.5, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Please enter your access key"
    subtitle.TextSize = 16
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subtitle.Parent = mainContainer
    subtitle.ZIndex = 9
    
    -- Key input field with enhanced 3D styling
    local keyInputContainer = Instance.new("Frame")
    keyInputContainer.Name = "KeyInputContainer"
    keyInputContainer.Size = UDim2.new(0, 340, 0, 50)
    keyInputContainer.Position = UDim2.new(0.5, 0, 0, 310)
    keyInputContainer.AnchorPoint = Vector2.new(0.5, 0)
    keyInputContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    keyInputContainer.BorderSizePixel = 0
    keyInputContainer.Parent = mainContainer
    keyInputContainer.ZIndex = 9
    
    -- Rounded corners for input container
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = keyInputContainer
    
    -- Input container inner shadow
    local inputShadow = Instance.new("Frame")
    inputShadow.Name = "InputShadow"
    inputShadow.Size = UDim2.new(1, 0, 1, 0)
    inputShadow.Position = UDim2.new(0, 0, 0, 0)
    inputShadow.BackgroundTransparency = 1
    inputShadow.BorderSizePixel = 0
    inputShadow.Parent = keyInputContainer
    inputShadow.ZIndex = 9
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(100, 100, 240)
    inputStroke.Thickness = 2
    inputStroke.Transparency = 0.8
    inputStroke.Parent = inputShadow
    
    local inputCornerShadow = Instance.new("UICorner")
    inputCornerShadow.CornerRadius = UDim.new(0, 10)
    inputCornerShadow.Parent = inputShadow
    
    -- Input field for key
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0.5, 0, 0.5, 0)
    keyInput.AnchorPoint = Vector2.new(0.5, 0.5)
    keyInput.BackgroundTransparency = 1
    keyInput.Font = Enum.Font.Gotham
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.TextSize = 16
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.Parent = keyInputContainer
    keyInput.ZIndex = 10
    keyInput.ClearTextOnFocus = false
    
    -- Key icon
    local keyIcon = Instance.new("ImageLabel")
    keyIcon.Name = "KeyIcon"
    keyIcon.Size = UDim2.new(0, 20, 0, 20)
    keyIcon.Position = UDim2.new(0, 15, 0.5, 0)
    keyIcon.AnchorPoint = Vector2.new(0, 0.5)
    keyIcon.BackgroundTransparency = 1
    keyIcon.Image = "rbxassetid://3926307971"
    keyIcon.ImageRectOffset = Vector2.new(164, 404)
    keyIcon.ImageRectSize = Vector2.new(36, 36)
    keyIcon.ImageColor3 = Color3.fromRGB(150, 150, 240)
    keyIcon.Parent = keyInputContainer
    keyIcon.ZIndex = 10
    
    keyInput.Position = UDim2.new(0.5, 10, 0.5, 0)
    
    -- Submit button with enhanced 3D styling
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0, 160, 0, 50)
    submitButton.Position = UDim2.new(0.5, -85, 0, 380)
    submitButton.AnchorPoint = Vector2.new(0.5, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
    submitButton.BorderSizePixel = 0
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Text = "SUBMIT"
    submitButton.TextSize = 18
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Parent = mainContainer
    submitButton.ZIndex = 10
    
    -- Rounded corners for submit button
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 10)
    submitCorner.Parent = submitButton
    
    -- Button gradient
    local submitGradient = Instance.new("UIGradient")
    submitGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 220))
    })
    submitGradient.Rotation = 45
    submitGradient.Parent = submitButton
    
    -- Button shadow
    local submitShadow = Instance.new("Frame")
    submitShadow.Name = "SubmitShadow"
    submitShadow.Size = UDim2.new(1, 0, 1, 0)
    submitShadow.Position = UDim2.new(0, 0, 0, 4)
    submitShadow.BackgroundColor3 = Color3.fromRGB(40, 40, 120)
    submitShadow.BorderSizePixel = 0
    submitShadow.ZIndex = 9
    submitShadow.Parent = submitButton
    
    local submitShadowCorner = Instance.new("UICorner")
    submitShadowCorner.CornerRadius = UDim.new(0, 10)
    submitShadowCorner.Parent = submitShadow
    
    -- Get Key button
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Size = UDim2.new(0, 160, 0, 50)
    getKeyButton.Position = UDim2.new(0.5, 85, 0, 380)
    getKeyButton.AnchorPoint = Vector2.new(0.5, 0)
    getKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Font = Enum.Font.GothamBold
    getKeyButton.Text = "GET KEY"
    getKeyButton.TextSize = 18
    getKeyButton.TextColor3 = Color3.fromRGB(220, 220, 240)
    getKeyButton.Parent = mainContainer
    getKeyButton.ZIndex = 10
    
    -- Rounded corners for get key button
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 10)
    getKeyCorner.Parent = getKeyButton
    
    -- Button gradient
    local getKeyGradient = Instance.new("UIGradient")
    getKeyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 65)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 90))
    })
    getKeyGradient.Rotation = 45
    getKeyGradient.Parent = getKeyButton
    
    -- Button shadow
    local getKeyShadow = Instance.new("Frame")
    getKeyShadow.Name = "GetKeyShadow"
    getKeyShadow.Size = UDim2.new(1, 0, 1, 0)
    getKeyShadow.Position = UDim2.new(0, 0, 0, 4)
    getKeyShadow.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    getKeyShadow.BorderSizePixel = 0
    getKeyShadow.ZIndex = 9
    getKeyShadow.Parent = getKeyButton
    
    local getKeyShadowCorner = Instance.new("UICorner")
    getKeyShadowCorner.CornerRadius = UDim.new(0, 10)
    getKeyShadowCorner.Parent = getKeyShadow
    
    -- Status message
    local statusMessage = Instance.new("TextLabel")
    statusMessage.Name = "StatusMessage"
    statusMessage.Size = UDim2.new(0, 340, 0, 30)
    statusMessage.Position = UDim2.new(0.5, 0, 0, 450)
    statusMessage.AnchorPoint = Vector2.new(0.5, 0)
    statusMessage.BackgroundTransparency = 1
    statusMessage.Font = Enum.Font.Gotham
    statusMessage.Text = ""
    statusMessage.TextSize = 16
    statusMessage.TextColor3 = Color3.fromRGB(180, 180, 200)
    statusMessage.Parent = mainContainer
    statusMessage.ZIndex = 10
    
    -- Animation functions
    local function fadeIn(obj, endTrans, duration)
        local startTrans = obj.BackgroundTransparency
        local fadeStep = (startTrans - endTrans) / 10
        for i = 1, 10 do
            obj.BackgroundTransparency = startTrans - (fadeStep * i)
            wait(duration / 10)
        end
        obj.BackgroundTransparency = endTrans
    end
    
    local function buttonHoverEffect(button, shadowObj, originalPos, hoverPos)
        local isHovering = false
        
        button.MouseEnter:Connect(function()
            isHovering = true
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {Position = hoverPos}):Play()
            game:GetService("TweenService"):Create(shadowObj, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.5, 2)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            isHovering = false
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {Position = originalPos}):Play()
            game:GetService("TweenService"):Create(shadowObj, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.5, 4)}):Play()
        end)
        
        return {
            PressEffect = function()
                if isHovering then
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset + 2)}):Play()
                    game:GetService("TweenService"):Create(shadowObj, TweenInfo.new(0.1), {Position = UDim2.new(0.5, 0, 0.5, 2)}):Play()
                    wait(0.1)
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {Position = hoverPos}):Play()
                    game:GetService("TweenService"):Create(shadowObj, TweenInfo.new(0.1), {Position = UDim2.new(0.5, 0, 0.5, 2)}):Play()
                end
            end
        }
    end
    
    local function pulseEffect(obj, duration, scale)
        local originalSize = obj.Size
        local targetSize = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset * scale, originalSize.Y.Scale * scale, originalSize.Y.Offset * scale)
        
        game:GetService("TweenService"):Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = targetSize}):Play()
        wait(duration)
        game:GetService("TweenService"):Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = originalSize}):Play()
    end
    
    local function showSuccessAnimation()
        -- Create a success circle
        local successCircle = Instance.new("Frame")
        successCircle.Name = "SuccessCircle"
        successCircle.Size = UDim2.new(0, 0, 0, 0)
        successCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        successCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        successCircle.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        successCircle.BackgroundTransparency = 0.2
        successCircle.BorderSizePixel = 0
        successCircle.Parent = mainContainer
        
        -- Rounded corners for the circle
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = successCircle
        
        -- Animate the circle
        game:GetService("TweenService"):Create(successCircle, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 300)}):Play()
        wait(0.5)
        game:GetService("TweenService"):Create(successCircle, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.5)
        
        successCircle:Destroy()
    end
    
    local function showErrorAnimation()
        -- Shake the container
        local originalPos = mainContainer.Position
        for i = 1, 6 do
            local xOffset = (i % 2 == 0) and 10 or -10
            game:GetService("TweenService"):Create(mainContainer, TweenInfo.new(0.05), {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + xOffset, originalPos.Y.Scale, originalPos.Y.Offset)}):Play()
            wait(0.05)
        end
        game:GetService("TweenService"):Create(mainContainer, TweenInfo.new(0.05), {Position = originalPos}):Play()
        
        -- Red outline for the input field
        local originalColor = inputStroke.Color
        inputStroke.Color = Color3.fromRGB(255, 80, 80)
        wait(0.5)
        game:GetService("TweenService"):Create(inputStroke, TweenInfo.new(0.3), {Color = originalColor}):Play()
    end
    
    -- Add animations for introduction
    background.BackgroundTransparency = 1
    mainContainer.Position = UDim2.new(0.5, 0, 1.5, 0)
    
    -- Animate appearance
    game:GetService("TweenService"):Create(background, TweenInfo.new(fadeInSpeed), {BackgroundTransparency = 0.3}):Play()
    wait(fadeInSpeed * 0.5)
    game:GetService("TweenService"):Create(mainContainer, TweenInfo.new(fadeInSpeed, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    
    -- Logo animation
    logo.ImageTransparency = 1
    logoShadow.ImageTransparency = 1
    game:GetService("TweenService"):Create(logo, TweenInfo.new(fadeInSpeed), {ImageTransparency = 0}):Play()
    game:GetService("TweenService"):Create(logoShadow, TweenInfo.new(fadeInSpeed), {ImageTransparency = 0.8}):Play()
    
    -- Interactive animations for buttons
    local checkButtonEffects = buttonHoverEffect(submitButton, submitShadow, submitButton.Position, UDim2.new(0.5, 0, 0, 378))
    local getKeyButtonEffects = buttonHoverEffect(getKeyButton, getKeyShadow, getKeyButton.Position, UDim2.new(0.5, 0, 0, 378))
    
    -- 3D rotation for the logo
    spawn(function()
        while true do
            for i = 0, 360, 1 do
                if not logoContainer or not logoContainer.Parent then
                    return
                end
                
                local rad = math.rad(i)
                local xOffset = math.sin(rad) * 5
                local yOffset = math.cos(rad) * 3
                
                logoContainer.Position = UDim2.new(0.5, xOffset, 0, 50 + yOffset)
                
                wait(0.03)
            end
        end
    end)
    
    -- Button press animations
    local function animateButtonPress(button, shadowFrame)
        local originalPosition = button.Position
        local pressedPosition = UDim2.new(
            originalPosition.X.Scale, 
            originalPosition.X.Offset, 
            originalPosition.Y.Scale, 
            originalPosition.Y.Offset + 4
        )
        
        -- Hide shadow
        shadowFrame.Visible = false
        
        -- Move button down
        button.Position = pressedPosition
        
        -- Short wait
        wait(0.1)
        
        -- Restore position and shadow
        button.Position = originalPosition
        shadowFrame.Visible = true
    end
    
    -- Add click animations to buttons
    submitButton.MouseButton1Click:Connect(function()
        animateButtonPress(submitButton, submitShadow)
        
        -- Validation
        local key = keyInput.Text
        
        if key == "" then
            statusMessage.Text = "Please enter your key"
            statusMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Show checking animation
        statusMessage.Text = "Checking key..."
        statusMessage.TextColor3 = Color3.fromRGB(180, 180, 200)
        
        -- Verify key
        local isKeyValid = KeyIsValid(key)
        
        if isKeyValid then
            -- Success animation
            statusMessage.Text = "Key verified successfully!"
            statusMessage.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- Add success particles
            for i = 1, 30 do
                local particle = Instance.new("Frame")
                particle.Name = "SuccessParticle"
                particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
                particle.Position = UDim2.new(math.random(1, 10)/10, 0, math.random(1, 10)/10, 0)
                particle.BackgroundColor3 = Color3.fromRGB(
                    math.random(50, 150), 
                    math.random(200, 255), 
                    math.random(50, 150)
                )
                particle.BorderSizePixel = 0
                particle.ZIndex = 8
                particle.Parent = mainContainer
                
                local particleCorner = Instance.new("UICorner")
                particleCorner.CornerRadius = UDim.new(1, 0)
                particleCorner.Parent = particle
                
                -- Animate particle
                spawn(function()
                    local randX = math.random(-100, 100) / 100
                    local randY = math.random(-100, 0) / 100
                    
                    for t = 0, 1, 0.05 do
                        if not particle.Parent then break end
                        
                        particle.Position = UDim2.new(
                            particle.Position.X.Scale + randX * 0.03,
                            particle.Position.X.Offset,
                            particle.Position.Y.Scale + randY * 0.03 - 0.02, 
                            particle.Position.Y.Offset
                        )
                        
                        particle.BackgroundTransparency = t
                        wait(0.03)
                    end
                    
                    if particle.Parent then
                        particle:Destroy()
                    end
                end)
            end
            
            -- Save valid key
            KeySystem.SavedKey = key
            
            -- Wait a moment before closing
            wait(1)
            
            -- Close animation - fade out
            local closeTween = TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1.5, 0)
            })
            
            local fadeOutTween = TweenService:Create(background, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            })
            
            closeTween:Play()
            fadeOutTween:Play()
            
            -- Wait for animation to finish
            wait(0.8)
            
            -- Cleanup
            keySystemGui:Destroy()
            
            -- Return true to the caller
            return true
        else
            -- Failure animation
            statusMessage.Text = "Invalid key. Please try again."
            statusMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Shake animation
            for i = 1, 6 do
                mainContainer.Position = UDim2.new(0.5, math.random(-10, 10), 0.5, math.random(-5, 5))
                wait(0.04)
            end
            
            -- Reset position
            mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            return false
        end
    end)
    
    -- Get key button animation and function
    getKeyButton.MouseButton1Click:Connect(function()
        animateButtonPress(getKeyButton, getKeyShadow)
        
        -- Show checking animation
        statusMessage.Text = "Getting key link..."
        statusMessage.TextColor3 = Color3.fromRGB(180, 180, 200)
        
        -- Get key link
        local keyLink = GetKeyLink()
        
        if keyLink and keyLink ~= "" then
            -- Copy to clipboard
            local success = pcall(function()
                setclipboard(keyLink)
            end)
            
            if success then
                statusMessage.Text = "Link copied to clipboard!"
                statusMessage.TextColor3 = Color3.fromRGB(100, 200, 255)
            else
                statusMessage.Text = keyLink
                statusMessage.TextColor3 = Color3.fromRGB(100, 200, 255)
            end
            
            -- Attempt to open in browser
            pcall(function()
                game:GetService("GuiService"):OpenBrowserWindow(keyLink)
            end)
        else
            statusMessage.Text = "Error getting key link"
            statusMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    -- Interactive hover effects for buttons
    local function setupButtonHover(button, gradient, originalTopColor, hoverTopColor)
        -- Original colors
        local originalColorSequence = gradient.Color
        
        -- Hover color sequence - brighten the top color
        local hoverColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0, hoverTopColor),
            ColorSequenceKeypoint.new(1, originalColorSequence.Keypoints[1].Value)
        })
        
        button.MouseEnter:Connect(function()
            -- Scale up slightly
            local growTween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 5, button.Size.Y.Scale, button.Size.Y.Offset + 2)
            })
            growTween:Play()
            
            -- Change gradient
            gradient.Color = hoverColorSequence
        end)
        
        button.MouseLeave:Connect(function()
            -- Scale back to original
            local shrinkTween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 5, button.Size.Y.Scale, button.Size.Y.Offset - 2)
            })
            shrinkTween:Play()
            
            -- Restore original gradient
            gradient.Color = originalColorSequence
        end)
    end
    
    -- Setup hover effects
    setupButtonHover(
        submitButton, 
        submitGradient, 
        Color3.fromRGB(60, 60, 180), 
        Color3.fromRGB(90, 90, 255)
    )
    
    setupButtonHover(
        getKeyButton, 
        getKeyGradient, 
        Color3.fromRGB(50, 50, 65), 
        Color3.fromRGB(80, 80, 110)
    )
    
    -- Focus effect for input field
    keyInput.Focused:Connect(function()
        -- Grow the stroke
        local growStroke = TweenService:Create(inputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 3,
            Transparency = 0.5
        })
        growStroke:Play()
    end)
    
    keyInput.FocusLost:Connect(function()
        -- Shrink the stroke back
        local shrinkStroke = TweenService:Create(inputStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 2,
            Transparency = 0.8
        })
        shrinkStroke:Play()
    end)
    
    -- Return KeySystem object
    return KeySystem
end

function MythKeySystem.ValidateKey()
    -- Try to read the saved key
    local key = ""
    local success, result = pcall(function()
        return readfile("MythHubKey.txt")
    end)
    
    if success then
        key = result
        -- Check the saved key
        if KeyIsValid(key) then
            return true
        end
    end
    
    -- Show the UI if no valid key is found
    return MythKeySystem.CreateKeyUI()
end

return MythKeySystem
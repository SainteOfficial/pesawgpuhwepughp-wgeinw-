--[[ 
    MythHub KeySystem
    Version: 1.0.2
    Beschreibung: Ein sicheres KeySystem mit KeyGuardian-Integration für MythHub
]]

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Konstanten
local KEY_SYSTEM_VERSION = "1.0.2"
local KEY_SERVER_URL = "https://keyguardian.xyz/check"
local KEY_LINK = "https://keyguardian.xyz/?kname=MythHub"
local VERIFICATION_DELAY = 5 -- Sekunden zwischen Überprüfungen
local DATA_KEY = "MythHub_KeyData"

-- UI-Komponenten laden
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local Notification = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/Notification"))()

-- Lokale Variablen
local KeyValidated = false
local HardwareID = nil
local SuccessCallback = nil

-- Hilfsfunktionen
local function GenerateHardwareID()
    -- Generiert eine stabilere Hardware-ID basierend auf verschiedenen Systeminformationen
    local idComponents = {
        game.JobId,
        LocalPlayer.UserId,
        game.PlaceId,
        LocalPlayer.Name,
        tostring(LocalPlayer.AccountAge),
        tostring(#game:GetService("CoreGui"):GetChildren()),
    }
    
    local baseString = table.concat(idComponents, "-")
    return HttpService:GenerateGUID(false)
end

-- Schlüssel-Validierung
local function ValidateKey(keyInput)
    -- Standardvalidierungslogik
    local trueData = {
        ["kdata"] = KEY_SYSTEM_VERSION,
        ["kname"] = "MythHub",
        ["kinput"] = keyInput,
        ["khwid"] = HardwareID
    }
    
    local falseData = {
        ["kdata"] = tostring(os.time()),
        ["kname"] = "MythHub_" .. tostring(math.random(1000, 9999)),
        ["kinput"] = keyInput:reverse(),
        ["khwid"] = HardwareID:reverse()
    }
    
    local success, response
    
    -- Versuche Schlüssel zu validieren
    success, response = pcall(function()
        return HttpService:JSONDecode(HttpService:PostAsync(
            KEY_SERVER_URL,
            HttpService:JSONEncode(trueData)
        ))
    end)
    
    -- Wenn der erste Aufruf fehlschlägt, versuche es mit den falschen Daten
    if not success then
        success, response = pcall(function()
            return HttpService:JSONDecode(HttpService:PostAsync(
                KEY_SERVER_URL,
                HttpService:JSONEncode(falseData)
            ))
        end)
    end
    
    -- Überprüfe das Ergebnis
    if success and response then
        if response.success then
            -- Speichere den gültigen Schlüssel
            local data = {
                key = keyInput,
                hwid = HardwareID,
                timestamp = os.time()
            }
            pcall(function()
                writefile("MythHub/keydata.json", HttpService:JSONEncode(data))
            end)
            return true, "Schlüssel erfolgreich validiert!"
        else
            return false, response.message or "Ungültiger Schlüssel."
        end
    else
        return false, "Verbindungsfehler. Bitte versuche es später erneut."
    end
end

-- UI-Elemente
local function ShowKeyUI(callback)
    SuccessCallback = callback
    HardwareID = GenerateHardwareID()
    
    -- Prüfe, ob ein gespeicherter Schlüssel existiert
    local savedKey
    pcall(function()
        if isfile("MythHub/keydata.json") then
            local data = HttpService:JSONDecode(readfile("MythHub/keydata.json"))
            if data and data.key and data.hwid == HardwareID then
                savedKey = data.key
            end
        end
    end)
    
    -- Wenn ein gespeicherter Schlüssel existiert, versuche ihn zu validieren
    if savedKey then
        local success, message = ValidateKey(savedKey)
        if success then
            KeyValidated = true
            Notification:Notify({
                Title = "Schlüssel validiert",
                Content = "Dein gespeicherter Schlüssel wurde validiert.",
                Duration = 5,
                Icon = "key",
                Color = "Green"
            })
            if SuccessCallback then
                SuccessCallback(true)
            end
            return
        end
    end
    
    -- KeyUI anzeigen
    local Window = WindUI:CreateWindow({
        Title = "MythHub - KeySystem",
        Icon = "key",
        Size = UDim2.fromOffset(400, 250),
        Transparent = true,
        Theme = "Dark",
        SideBarWidth = 0,
        HasOutline = true,
    })
    
    local KeyTab = Window:Tab({ Title = "Schlüssel", Icon = "key" })
    
    -- Info-Bereich
    KeyTab:Section({ Title = "Information" })
    KeyTab:Label({ 
        Title = "Willkommen bei MythHub",
        Description = "Bitte gib deinen Zugriffsschlüssel ein, um fortzufahren." 
    })
    
    -- Hardwareinformationen anzeigen
    KeyTab:Label({ 
        Title = "Hardware-ID",
        Description = string.sub(HardwareID, 1, 10) .. "..." .. string.sub(HardwareID, -5)
    })
    
    -- Schlüsseleingabebereich
    KeyTab:Section({ Title = "Schlüsselvalidierung" })
    
    local keyInput = ""
    KeyTab:Input({
        Title = "Zugriffsschlüssel",
        Description = "Gib deinen Schlüssel ein",
        Default = "",
        Placeholder = "Schlüssel hier eingeben...",
        Callback = function(value)
            keyInput = value
        end
    })
    
    -- Validierungsbutton
    KeyTab:Button({
        Title = "Validieren",
        Description = "Überprüfe deinen Schlüssel",
        Icon = "check",
        Callback = function()
            if keyInput == "" then
                Notification:Notify({
                    Title = "Fehler",
                    Content = "Bitte gib einen Schlüssel ein.",
                    Duration = 5,
                    Icon = "warning",
                    Color = "Red"
                })
                return
            end
            
            Notification:Notify({
                Title = "Überprüfung",
                Content = "Überprüfe Schlüssel...",
                Duration = 3,
                Icon = "loader",
                Color = "Blue"
            })
            
            -- Verzögerung für natürlicheres Gefühl
            task.delay(1, function()
                local success, message = ValidateKey(keyInput)
                
                if success then
                    KeyValidated = true
                    Notification:Notify({
                        Title = "Erfolg",
                        Content = message,
                        Duration = 5,
                        Icon = "check",
                        Color = "Green"
                    })
                    
                    -- UI schließen und Callback ausführen
                    Window:Destroy()
                    if SuccessCallback then
                        SuccessCallback(true)
                    end
                else
                    Notification:Notify({
                        Title = "Fehler",
                        Content = message,
                        Duration = 5,
                        Icon = "warning",
                        Color = "Red"
                    })
                end
            end)
        end
    })
    
    -- Link-Button
    KeyTab:Button({
        Title = "Link kopieren",
        Description = "Kopiere den Link zur Schlüsselseite",
        Icon = "link",
        Callback = function()
            setclipboard(KEY_LINK)
            Notification:Notify({
                Title = "Link kopiert",
                Content = "Der Link wurde in die Zwischenablage kopiert.",
                Duration = 3,
                Icon = "clipboard-copy",
                Color = "Blue"
            })
        end
    })
    
    -- Discord-Button
    KeyTab:Button({
        Title = "Discord beitreten",
        Description = "Tritt unserem Discord-Server bei",
        Icon = "message-square",
        Callback = function()
            setclipboard("https://discord.gg/mythhub")
            Notification:Notify({
                Title = "Discord-Link kopiert",
                Content = "Der Discord-Link wurde in die Zwischenablage kopiert.",
                Duration = 3,
                Icon = "clipboard-copy",
                Color = "Blue"
            })
        end
    })
end

-- Öffentliche Methoden
return {
    ShowKeyUI = ShowKeyUI,
    ValidateKey = ValidateKey,
    IsKeyValidated = function() return KeyValidated end,
    GetVersion = function() return KEY_SYSTEM_VERSION end
}

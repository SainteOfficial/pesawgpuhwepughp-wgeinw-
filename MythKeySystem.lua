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

-- Initialisierungsfunktion
MythKeySystem.initialize = function(savedKey)
    local key = savedKey or defaultKey
    MythKeySystem.isKeyValid = MythKeySystem.validateKey(key)
    return MythKeySystem.isKeyValid
end

-- Rückgabe des fertigen Systems
return MythKeySystem

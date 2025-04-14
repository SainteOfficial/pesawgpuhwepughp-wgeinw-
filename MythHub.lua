-- KeySystem laden
local success, MythKeySystem = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/SainteOfficial/pesawgpuhwepughp-wgeinw-/refs/heads/master/MythKeySystem.lua"))()
end)

if not success then
    -- Verbesserte Fehlerbehandlung
    warn("MythKeySystem konnte nicht geladen werden: " .. tostring(MythKeySystem))
    game.Players.LocalPlayer:Kick("MythKeySystem konnte nicht geladen werden. Bitte überprüfe die Internetverbindung oder kontaktiere den Entwickler.")
    return
end

-- Key validieren mit dem neuen KeySystem
local keyValidationSuccess, isKeyValid = pcall(function()
    return MythKeySystem.initialize()
end)

if not keyValidationSuccess then
    warn("Fehler bei der Key-Validierung: " .. tostring(isKeyValid))
    game.Players.LocalPlayer:Kick("Fehler bei der Key-Validierung. Bitte kontaktiere den Entwickler.")
    return
end

if not isKeyValid then
    -- Beende das Script, wenn der Key nicht gültig ist
    return
end

-- Ab hier läuft das normale Script, wenn der Key valid ist
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "MythHub",
    Icon = "star",
    Author = "MythHub",
    Folder = "MythHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = false,
    SideBarWidth = 200,
    HasOutline = true,
})

-- Create Tabs
local Tabs = {
    DashboardTab = Window:Tab({ Title = "Dashboard", Icon = "home", Desc = "Overview and statistics" }),
    AutoFarmTab = Window:Tab({ Title = "Auto Farm", Icon = "swords", Desc = "Automatic farming features" }),
    TowersTab = Window:Tab({ Title = "Towers", Icon = "tower", Desc = "Battle and Infinite Tower features" }),
    RaidsTab = Window:Tab({ Title = "Raids", Icon = "dragon", Desc = "Raid battle features" }),
    ExplorationTab = Window:Tab({ Title = "Exploration", Icon = "compass", Desc = "Exploration features" }),
    ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart", Desc = "Shop automation" }),
    MiscTab = Window:Tab({ Title = "Misc", Icon = "settings", Desc = "Miscellaneous features" }),
}

-- Konfigurationsverwaltung
local ConfigManager = {}

-- Konfigurationsstruktur
local Config = {
    autoFarmSettings = {
        selectedLocation = nil,
        selectedEnemy = nil,
        autoPickupEnabled = false
    },
    explorationSettings = {
        autoDeployEnabled = {
            easy = false,
            medium = false,
            hard = false,
            extreme = false,
            nightmare = false
        },
        autoClaimEnabled = {
            easy = false,
            medium = false,
            hard = false,
            extreme = false,
            nightmare = false
        }
    },
    towerSettings = {
        autoBattleTower = false,
        autoInfiniteTower = false,
        autoPauseInfiniteTower = false
    },
    raidSettings = {
        autoDetectDragon = false,
        autoEternalDragon = false,
        autoShadowDragon = false
    },
    miscSettings = {
        autoUpgradeStats = {
            BOSS_CHANCE = false,
            BORDER_CHANCE = false,
            POTION_DURATION = false,
            COOLDOWN_REDUCTION = false,
            LUCK = false
        },
        fpsBoostEnabled = false,
        disableParticles = false,
        webhookURL = "",
        webhookInterval = 15,
        webhookEnabled = false
    },
    customFarmSettings = {
        selectedLocations = {},
        includeNormal = true,
        includeBosses = false
    }
}

-- Auto Farm Section
local enemies = {
    ["Ninja Village"] = {
        "Rock Lee (unstoppable_fist)",
        "Kakashi (copy_ninja)",
        "Sasuke (awakened_dark_avenger)",
        "Naruto Sage (awakened_promised_child)",
        "Pain (six_paths_of_pain)",
        "Naruto Rage (bijuu_beast) [BOSS]"
    },
    ["Green Village"] = {
        "Son Gohan (ultimate_warrior)",
        "Captain Ginyu (body_switcher)",
        "Piccolo (namekian_sage)",
        "Vegeta (awakened_prideful_prince)",
        "Goku (awakened_earth_strongest)",
        "Frieza (awakened_galactic_tyrant) [BOSS]"
    },
    ["Shibuya Station"] = {
        "Nobara (cursed_doll)",
        "Megumi (awakened_shadow_summoner)",
        "Yuji (cursed_fist)",
        "Yuta (rika_blessing)",
        "Gojo (limitless_master)",
        "Sukuna (king_of_curses) [BOSS]"
    },
    ["Titans City"] = {
        "Erwin (survey_commander)",
        "Mikasa (blade_warrior)",
        "Reiner (armored_giant)",
        "Zeke (beast_giant)",
        "Levi (blade_captain)",
        "Eren (combat_giant) [BOSS]"
    },
    ["Dimensional Fortress"] = {
        "Kaigaku (thunder_demon)",
        "Hantengu (childish_demon)",
        "Akaza (compass_demon)",
        "Doma (awakened_frost_demon)",
        "Kokushibo (awakened_six_eyed_slayer)",
        "Muzan (awakened_pale_demon_lord) [BOSS]"
    },
    ["Candy Island"] = {
        "Daifuku (genie_commander)",
        "Perospero (candy_master)",
        "Cracker (biscuit_warrior)",
        "Smoothie (juice_queen)",
        "Katakuri (mochi_emperor)",
        "Big Mom (soul_queen) [BOSS]"
    },
    ["Solo City"] = {
        "Cha Hae-In (light_saintess)",
        "Thomas Andre (the_goliath)",
        "Tank (shadow_bear)",
        "Igris (shadow_commander)",
        "Beru (shadow_ant)",
        "Sung Jinwoo (awakened_shadow_monarch) [BOSS]"
    }
}

-- Auto Farm Tab Content
Tabs.AutoFarmTab:Section({ Title = "Enemy Farm" })

local selectedLocation = nil
local selectedEnemy = nil

local enemyDropdown = Tabs.AutoFarmTab:Dropdown({
    Title = "Select Enemy",
    Values = {},
    Callback = function(enemy)
        selectedEnemy = enemy
    end
})

Tabs.AutoFarmTab:Dropdown({
    Title = "Select Location",
    Values = {
        "Ninja Village",
        "Green Village",
        "Shibuya Station",
        "Titans City",
        "Dimensional Fortress",
        "Candy Island",
        "Solo City"
    },
    Callback = function(location)
        selectedLocation = location
        if enemies[location] then
            enemyDropdown:Refresh(enemies[location])
        end
    end
})

Tabs.AutoFarmTab:Toggle({
    Title = "Auto Farm Selected Enemy",
    Default = false,
    Callback = function(state)
        if state and selectedEnemy then
            -- Extract the enemy ID from the selected enemy string
            local enemyId = selectedEnemy:match("%(([^)]+)%)")
            if enemyId then
                -- Auto farm logic here
                local args = {
                    [1] = enemyId
                }
                game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("9efaaa87-7d74-4d63-8466-8bb11b0391ad"):FireServer(unpack(args))
            end
        end
    end
})

-- Towers Tab Content
Tabs.TowersTab:Section({ Title = "Battle Tower" })

Tabs.TowersTab:Toggle({
    Title = "Auto Battle Tower",
    Default = false,
    Callback = function(state)
        if state then
            -- Battle Tower auto logic
            local LocalUser = require(game:GetService("ReplicatedStorage"):WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")).LocalUser
            local battleTowerWave = LocalUser.metadata:getAsNumber("battle_tower_wave") or 1
            
            local args = {
                [1] = battleTowerWave
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("c67fb799-bc7a-48f6-ae2e-f14301ded8d5"):FireServer(unpack(args))
        end
    end
})

Tabs.TowersTab:Section({ Title = "Infinite Tower" })

Tabs.TowersTab:Toggle({
    Title = "Auto Infinite Tower",
    Default = false,
    Callback = function(state)
        _G.AutoInfiniteTower = state
        
        if state then
            -- Wenn Nightmare Tower aktiv ist, deaktiviere ihn zuerst
            if _G.AutoNightmareTower then
                -- Nightmare Tower deaktivieren, ohne weitere Events auszulösen
                _G.AutoNightmareTower = false
                
                -- Timer stoppen
                if _G.NightmareTowerLoop then
                    _G.NightmareTowerLoop:Disconnect()
                    _G.NightmareTowerLoop = nil
                end
                
                -- Benachrichtigung
                WindUI:Notify({
                    Title = "Tower Konflikt",
                    Content = "Nightmare Tower wurde deaktiviert, da Infinite Tower aktiviert wurde",
                    Duration = 3,
                    Icon = "alert-triangle",
                    Color = "Orange"
                })
            end
            
            -- Starte den Timer für die automatische Ausführung
            if _G.InfiniteTowerLoop then
                _G.InfiniteTowerLoop:Disconnect()
                _G.InfiniteTowerLoop = nil
            end
            
            _G.InfiniteTowerLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.AutoInfiniteTower and (not _G.LastInfiniteTowerTime or os.time() - _G.LastInfiniteTowerTime >= 10) then
                    local args = {
                        [1] = "infinite_tower"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("8979e7ea-9775-4c4c-8568-ceac4fe26b11"):FireServer(unpack(args))
                    _G.LastInfiniteTowerTime = os.time()
                end
            end)
            
            -- Initial ausführen
            local args = {
                [1] = "infinite_tower"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("8979e7ea-9775-4c4c-8568-ceac4fe26b11"):FireServer(unpack(args))
            _G.LastInfiniteTowerTime = os.time()
        else
            -- Timer stoppen
            if _G.InfiniteTowerLoop then
                _G.InfiniteTowerLoop:Disconnect()
                _G.InfiniteTowerLoop = nil
            end
            
            -- Tower beenden
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("56501597-da2f-4bf8-8d1c-05c3dd5e2053"):FireServer()
        end
    end
})

Tabs.TowersTab:Toggle({
    Title = "Auto Pause Infinite Tower",
    Default = false,
    Callback = function(state)
        if state then
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("6263b280-9765-4af6-8a4a-cf278320082c"):FireServer()
        end
    end
})

-- Neuer Toggle für Nightmare Tower
Tabs.TowersTab:Section({ Title = "Nightmare Tower" })

Tabs.TowersTab:Toggle({
    Title = "Auto Nightmare Tower",
    Default = false,
    Callback = function(state)
        _G.AutoNightmareTower = state
        
        if state then
            -- Wenn Infinite Tower aktiv ist, deaktiviere ihn zuerst
            if _G.AutoInfiniteTower then
                -- Infinite Tower deaktivieren, ohne weitere Events auszulösen
                _G.AutoInfiniteTower = false
                
                -- Timer stoppen
                if _G.InfiniteTowerLoop then
                    _G.InfiniteTowerLoop:Disconnect()
                    _G.InfiniteTowerLoop = nil
                end
                
                -- Benachrichtigung
                WindUI:Notify({
                    Title = "Tower Konflikt",
                    Content = "Infinite Tower wurde deaktiviert, da Nightmare Tower aktiviert wurde",
                    Duration = 3,
                    Icon = "alert-triangle",
                    Color = "Orange"
                })
            end
            
            -- Starte den Timer für die automatische Ausführung
            if _G.NightmareTowerLoop then
                _G.NightmareTowerLoop:Disconnect()
                _G.NightmareTowerLoop = nil
            end
            
            -- Funktion für Restart-Überprüfung
            if _G.NightmareTowerRestartCheck then
                _G.NightmareTowerRestartCheck:Disconnect()
                _G.NightmareTowerRestartCheck = nil
            end
            
            -- Verbindung, die prüft, ob der Tower zu Ende ist und die RESTART-Schaltfläche angezeigt wird
            _G.NightmareTowerRestartCheck = game:GetService("RunService").Heartbeat:Connect(function()
                local player = game.Players.LocalPlayer
                if not player then return end
                
                local success, result = pcall(function()
                    local gui = player.PlayerGui["infinite-tower-floor-summary"]
                    if not gui then return false end
                    
                    -- Neuer Pfad zum Exit-Button
                    local button = gui.Transition.Frame.Frame:GetChildren()[2].Frame.Frame.Frame.TextButton
                    
                    -- Prüfen, ob der Text "Exit" ist
                    if button and button.Text == "Exit" then
                        return true
                    end
                    
                    return false
                end)
                
                -- Wenn der Exit-Button gefunden wurde, beende den Tower und starte ihn neu
                if success and result then
                    -- Tower beenden
                    game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("56501597-da2f-4bf8-8d1c-05c3dd5e2053"):FireServer()
                    
                    -- Kurze Wartezeit
                    task.wait(1)
                    
                    -- Tower neu starten mit nightmare_tower Parameter
                    local args = {
                        [1] = "nightmare_tower"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("8979e7ea-9775-4c4c-8568-ceac4fe26b11"):FireServer(unpack(args))
                    
                    -- Benachrichtigung
                    WindUI:Notify({
                        Title = "Nightmare Tower",
                        Content = "Nightmare Tower neu gestartet",
                        Duration = 3,
                        Icon = "refresh-cw"
                    })
                    
                    -- Kurze Pause, um mehrfache Aktionen zu vermeiden
                    task.wait(2)
                end
                
                -- Nicht zu oft prüfen (alle 0.5 Sekunden reicht)
                task.wait(0.5)
            end)
            
            -- Normale Timer-Funktionalität (alle 10 Sekunden)
            _G.NightmareTowerLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.AutoNightmareTower and (not _G.LastNightmareTowerTime or os.time() - _G.LastNightmareTowerTime >= 10) then
                    local args = {
                        [1] = "nightmare_tower"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("8979e7ea-9775-4c4c-8568-ceac4fe26b11"):FireServer(unpack(args))
                    _G.LastNightmareTowerTime = os.time()
                end
            end)
            
            -- Initial ausführen
            local args = {
                [1] = "nightmare_tower"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("8979e7ea-9775-4c4c-8568-ceac4fe26b11"):FireServer(unpack(args))
            _G.LastNightmareTowerTime = os.time()
            
            WindUI:Notify({
                Title = "Nightmare Tower",
                Content = "Nightmare Tower aktiviert",
                Duration = 3,
                Icon = "tower"
            })
        else
            -- Timer stoppen
            if _G.NightmareTowerLoop then
                _G.NightmareTowerLoop:Disconnect()
                _G.NightmareTowerLoop = nil
            end
            
            -- Restart-Check stoppen
            if _G.NightmareTowerRestartCheck then
                _G.NightmareTowerRestartCheck:Disconnect()
                _G.NightmareTowerRestartCheck = nil
            end
            
            -- Tower beenden
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("56501597-da2f-4bf8-8d1c-05c3dd5e2053"):FireServer()
            
            WindUI:Notify({
                Title = "Nightmare Tower",
                Content = "Nightmare Tower deaktiviert",
                Duration = 3,
                Icon = "tower"
            })
        end
    end
})

-- Raids Tab Content - Completely restructured
Tabs.RaidsTab:Section({ Title = "Raid Dragons" })

-- Dragon auto farm
Tabs.RaidsTab:Toggle({
    Title = "Auto Detect & Farm Active Dragon",
    Default = false,
    Callback = function(state)
        _G.AutoDetectDragon = state
        
        if state then
            -- Raid detection variables
            _G.InDragonRaid = false -- Whether player is in a raid
            _G.EndingRaid = false -- Whether raid is ending (reward screen)
            _G.LastRaidAttempt = 0 -- Time of last raid start attempt
            
            -- Virtual Input Function for clicking on screen
            local function virtualClick()
                -- Using VirtualInputManager to simulate clicks without moving cursor
                local vim = game:GetService("VirtualInputManager")
                local screenSize = workspace.CurrentCamera.ViewportSize
                
                -- Click in the center of the screen
                local centerX = screenSize.X / 2
                local centerY = screenSize.Y / 2
                
                -- Press and release mouse button 1 (left click)
                vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                task.wait(0.1)
                vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                
                -- Small delay between clicks
                task.wait(0.3)
            end
            
            -- Check current raid status
            _G.CheckRaidStatusConnection = game:GetService("RunService").Heartbeat:Connect(function()
                -- Check if player is in a fight
                local player = game.Players.LocalPlayer
                local playerGui = player:FindFirstChild("PlayerGui")
                
                if playerGui then
                    -- Use the specific GUIs mentioned to check if in battle
                    local inBattle = playerGui:FindFirstChild("battle") ~= nil or playerGui:FindFirstChild("HideBattleButton") ~= nil
                    local battleEnding = playerGui:FindFirstChild("reward-ui") ~= nil or playerGui:FindFirstChild("battle-end") ~= nil
                    
                    -- Update state based on GUI presence
                    if inBattle then
                        _G.InDragonRaid = true
                        _G.EndingRaid = false
                    elseif battleEnding then
                        -- Battle has ended, but rewards UI is showing
                        _G.InDragonRaid = false
                        _G.EndingRaid = true
                        
                        -- Click to dismiss reward screens
                        virtualClick()
                        virtualClick()
                        virtualClick()
                    else
                        -- No battle or ending screens
                        _G.InDragonRaid = false
                        _G.EndingRaid = false
                    end
                end
                
                -- Limit how often we check this
                task.wait(0.2)
            end)
            
            -- Main raid detection logic
            _G.DragonDetectionConnection = game:GetService("RunService").Heartbeat:Connect(function()
                -- If already in a raid or raid is ending, don't start new one
                if _G.InDragonRaid or _G.EndingRaid then
                    return
                end
                
                -- Check if we tried to start a raid recently (within 2 seconds)
                if os.time() - _G.LastRaidAttempt < 2 then
                    return
                end
                
                -- Path to the raid portal UI
                local raidPortal = workspace:FindFirstChild("lobby")
                if not raidPortal then return end
                
                local teleport = raidPortal:FindFirstChild("portals")
                if not teleport then return end
                
                local raidTeleport = teleport:FindFirstChild("raid_teleportation")
                if not raidTeleport then return end
                
                local attachment = raidTeleport:FindFirstChild("Attachment")
                if not attachment then return end
                
                local billboardGui = attachment:FindFirstChild("BillboardGui")
                if not billboardGui then return end
                
                -- Check if there's an active raid
                local dragonLabel = billboardGui:FindFirstChild("TextLabel")
                local timeLabel = billboardGui:GetChildren()[3]
                
                if dragonLabel and timeLabel then
                    local dragonText = dragonLabel.Text
                    local timeText = timeLabel.Text
                    
                    -- Check if there's a raid timer active
                    if timeText:match("Raid ends in %d+:%d+") then
                        local dragonType = nil
                        
                        -- Determine dragon type from label
                        if dragonText:match("Eternal Dragon") then
                            dragonType = "eternal_dragon"
                        elseif dragonText:match("Shadow Dragon") then
                            dragonType = "shadow_dragon"
                        end
                        
                        -- If dragon type is identified, start raid
                        if dragonType then
                            -- Update raid status and set attempt time
                            _G.LastRaidAttempt = os.time()
                            _G.InDragonRaid = true
                            
                            local args = {
                                [1] = dragonType
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("9efaaa87-7d74-4d63-8466-8bb11b0391ad"):FireServer(unpack(args))
                            
                            -- Notify user which raid is active
                            WindUI:Notify({
                                Title = "Auto Raid",
                                Content = "Starting " .. (dragonType == "eternal_dragon" and "Eternal Dragon" or "Shadow Dragon") .. " raid",
                                Duration = 3,
                                Icon = "dragon"
                            })
                        end
                    end
                end
                
                -- Wait to prevent excessive checks
                task.wait(1)
            end)
        else
            if _G.DragonDetectionConnection then
                _G.DragonDetectionConnection:Disconnect()
                _G.DragonDetectionConnection = nil
            end
            
            if _G.CheckRaidStatusConnection then
                _G.CheckRaidStatusConnection:Disconnect()
                _G.CheckRaidStatusConnection = nil
            end
            
            _G.InDragonRaid = false
            _G.EndingRaid = false
            _G.LastRaidAttempt = 0
        end
    end
})

-- Manual dragon options
Tabs.RaidsTab:Toggle({
    Title = "Auto Eternal Dragon",
    Default = false,
    Callback = function(state)
        if state then
            local args = {
                [1] = "eternal_dragon"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("9efaaa87-7d74-4d63-8466-8bb11b0391ad"):FireServer(unpack(args))
        end
    end
})

Tabs.RaidsTab:Toggle({
    Title = "Auto Shadow Dragon",
    Default = false,
    Callback = function(state)
        if state then
            local args = {
                [1] = "shadow_dragon"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("9efaaa87-7d74-4d63-8466-8bb11b0391ad"):FireServer(unpack(args))
        end
    end
})

-- Raid Potions - Completely separated section
Tabs.RaidsTab:Section({ Title = "Raid Potions" })

-- Raid Potions information
Tabs.RaidsTab:Paragraph({
    Title = "Raid Potions",
    Desc = "Purchase potions to improve raid drops and cooldowns",
    Color = "Orange",
    Image = "flask"
})

-- Raid Potions buttons
local raidPotions = {
    ["Raid Luck Potion"] = "raid_luck_potion",
    ["Raid Border Chance Potion"] = "raid_border_chance_potion",
    ["Raid Cooldown Potion"] = "raid_cooldown_potion",
    ["Raid Boss Chance Potion"] = "raid_boss_chance_potion",
    ["Raid Moon Cycle Reroll Potion"] = "raid_moon_cycle_reroll_potion"
}

for potionName, potionId in pairs(raidPotions) do
    Tabs.RaidsTab:Button({
        Title = "Buy " .. potionName,
        Callback = function()
            local args = {
                [1] = potionId,
                [2] = 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("57250fb8-7458-427c-851a-063889d30f2c"):FireServer(unpack(args))
            
            -- Notify user that the potion was purchased
            WindUI:Notify({
                Title = "Shop",
                Content = "Purchased: " .. potionName,
                Duration = 2,
                Icon = "shopping-cart"
            })
        end
    })
end

-- Exploration Tab Content
Tabs.ExplorationTab:Section({ Title = "Exploration" })

-- Setup deployments for each difficulty
local deploymentUnits = {
    ["Easy"] = {
        difficultyId = "easy",
        minDenominator = 10000 -- 10K
    },
    ["Medium"] = {
        difficultyId = "medium",
        minDenominator = 1000000 -- 1M
    },
    ["Hard"] = {
        difficultyId = "hard",
        minDenominator = 10000000 -- 10M
    },
    ["Extreme"] = {
        difficultyId = "extreme",
        minDenominator = 100000000 -- 100M
    },
    ["Nightmare"] = {
        difficultyId = "nightmare",
        minDenominator = 1000000000 -- 1B
    }
}

-- Funktion zum Finden der Einheiten mit der niedrigsten passenden Denominator für die Schwierigkeit
local function getBestUnitsForDeployment(minDenominator)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RuntimeLib = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")
    local module = require(RuntimeLib)
    
    -- Module importieren ohne script zu verwenden
    local LocalUserModule = ReplicatedStorage:WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")
    local LocalUser = require(LocalUserModule).LocalUser
    
    -- Alle Karten abrufen
    local bestUnits = {}
    
    local success, cards = pcall(function()
        return LocalUser.deck:getCards()
    end)
    
    if not success then
        -- Keine Benachrichtigung mehr, stattdessen nur Konsolen-Log
        print("Fehler: Konnte Karteninventar nicht abrufen")
        return {"light_admiral:rainbow", "light_admiral:rainbow", "light_admiral:rainbow", "light_admiral:rainbow"} -- Fallback
    end
    
    -- Karten in Array konvertieren und filtern nach passendem Denominator
    local cardArray = {}
    for cardId, userCard in pairs(cards) do
        local card = userCard:getCard()
        -- Nur Kampfkarten (keine Support-Karten) mit ausreichendem Denominator
        if not card.isSupport and card.denominator and card.denominator >= minDenominator then
            table.insert(cardArray, {
                id = card.id,
                denominator = card.denominator
            })
        end
    end
    
    -- Nach Denominator sortieren (aufsteigend, um die schwächsten passenden zuerst zu nehmen)
    table.sort(cardArray, function(a, b)
        return (a.denominator or 0) < (b.denominator or 0)
    end)
    
    -- Die 4 schwächsten passenden Karten auswählen (oder weniger, falls nicht genug vorhanden)
    for i = 1, 4 do
        if cardArray[i] then
            table.insert(bestUnits, cardArray[i].id)
        else
            table.insert(bestUnits, "light_admiral:rainbow") -- Fallback wenn nicht genügend Karten
        end
    end
    
    -- Keine Benachrichtigung mehr über ausgewählte Einheiten
    
    return bestUnits
end

-- Variablen für Exploration-Automatisierung
_G.ExplorationToggles = {
    easy = false,
    medium = false,
    hard = false,
    extreme = false,
    nightmare = false
}

-- Funktion zur automatischen Ausführung der Exploration-Aktionen
local function RunExplorationCycle()
    -- Nichts tun, wenn keine Schwierigkeit aktiviert ist
    local activeToggles = {}
    for diff, isEnabled in pairs(_G.ExplorationToggles) do
        if isEnabled then
            table.insert(activeToggles, diff)
        end
    end
    
    if #activeToggles == 0 then
        return
    end
    
    -- Aktuelle Phase (Deploy oder Claim) und aktuelle Schwierigkeit verfolgen
    _G.ExplorationPhase = _G.ExplorationPhase or "Deploy"
    _G.CurrentDifficultyIndex = _G.CurrentDifficultyIndex or 1
    
    -- Aktuelle Schwierigkeit ermitteln
    local currentDifficulty = activeToggles[_G.CurrentDifficultyIndex]
    
    -- Nichts tun, wenn keine Schwierigkeit gefunden wurde
    if not currentDifficulty then
        _G.CurrentDifficultyIndex = 1
        return
    end
    
    -- Die entsprechende Aktion für die aktuelle Schwierigkeit ausführen
    if _G.ExplorationPhase == "Deploy" then
        -- Deploy für aktuelle Schwierigkeit
        local difficultyName
        for name, info in pairs(deploymentUnits) do
            if info.difficultyId == currentDifficulty then
                difficultyName = name
                break
            end
        end
        
        -- Wenn keine passende Schwierigkeit gefunden wurde, uppercase first letter
        if not difficultyName then
            difficultyName = currentDifficulty:sub(1,1):upper() .. currentDifficulty:sub(2)
        end
        
        -- Keine Benachrichtigung mehr
        
        -- Einheiten auswählen und deployen
        local bestUnits = getBestUnitsForDeployment(deploymentUnits[difficultyName].minDenominator)
                local args = {
            [1] = currentDifficulty,
            [2] = bestUnits
        }
        game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("171e5a3a-8c09-493b-8c8e-c1f2cf4376bd"):FireServer(unpack(args))
        
        -- Zur nächsten Phase wechseln
        _G.ExplorationPhase = "Claim"
    else
        -- Claim für aktuelle Schwierigkeit
        local difficultyName = currentDifficulty:sub(1,1):upper() .. currentDifficulty:sub(2)
        
        -- Keine Benachrichtigung mehr
        
        -- Belohnungen abholen
        local args = {
            [1] = currentDifficulty
        }
        game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("4964b823-bc36-4e56-a57e-8531f145d655"):FireServer(unpack(args))
        
        -- Zur nächsten Phase und Schwierigkeit wechseln
        _G.ExplorationPhase = "Deploy"
        _G.CurrentDifficultyIndex = _G.CurrentDifficultyIndex + 1
        
        -- Wenn alle Schwierigkeiten durchlaufen wurden, von vorne beginnen
        if _G.CurrentDifficultyIndex > #activeToggles then
            _G.CurrentDifficultyIndex = 1
            end
        end
end

-- Timer-Verbindung zurücksetzen, falls vorhanden
if _G.ExplorationTimer then
    _G.ExplorationTimer:Disconnect()
    _G.ExplorationTimer = nil
end

-- Neuen Timer für den Exploration-Zyklus erstellen
spawn(function()
    while wait(3) do  -- 3 Sekunden zwischen den Aktionen warten
        pcall(RunExplorationCycle)
    end
end)

-- Strong visual separator
Tabs.ExplorationTab:Paragraph({
    Title = "Exploration Automatisierung",
    Desc = "Ein Toggle pro Schwierigkeit aktiviert beide Funktionen: Deploy und Claim",
    Color = "Blue",
    Image = "compass"
})

-- Unified toggles for each difficulty
local difficulties = {
    "Easy",
    "Medium",
    "Hard",
    "Extreme",
    "Nightmare"
}

for _, difficulty in ipairs(difficulties) do
    local lowerDiff = difficulty:lower()
    
    Tabs.ExplorationTab:Toggle({
        Title = "Auto " .. difficulty .. " (Deploy + Claim)",
        Default = false,
        Callback = function(state)
            _G.ExplorationToggles[lowerDiff] = state
            
            if state then
                -- Keine Benachrichtigung mehr
                
                -- Sofort die ersten Aktionen ausführen
                local claimArgs = {
                    [1] = lowerDiff
                }
                game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("4964b823-bc36-4e56-a57e-8531f145d655"):FireServer(unpack(claimArgs))
                
                wait(1)
                
                local deployArgs = {
                    [1] = deploymentUnits[difficulty].difficultyId,
                    [2] = getBestUnitsForDeployment(deploymentUnits[difficulty].minDenominator)
                }
                game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("171e5a3a-8c09-493b-8c8e-c1f2cf4376bd"):FireServer(unpack(deployArgs))
            else
                -- Keine Benachrichtigung mehr
            end
        end
    })
end

-- Second Section: Auto Claim
Tabs.ExplorationTab:Section({ Title = "Auto Claim" })

local difficulties = {
    "Nightmare",
    "Extreme",
    "Hard",
    "Medium",
    "Easy"
}

for _, difficulty in ipairs(difficulties) do
    Tabs.ExplorationTab:Toggle({
        Title = "Auto Claim " .. difficulty,
        Default = false,
        Callback = function(state)
            local lowerDiff = difficulty:lower()
            _G.ExplorationToggles.Claim[lowerDiff] = state
            
            if state then
                local args = {
                    [1] = lowerDiff
                }
                game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("4964b823-bc36-4e56-a57e-8531f145d655"):FireServer(unpack(args))
            end
        end
    })
end

-- Towers Tab Content
Tabs.TowersTab:Button({
    Title = "Check Current Floor",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        local success, result = pcall(function()
            local LocalUser = require(ReplicatedStorage:WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")).LocalUser
            
            if LocalUser and LocalUser.infiniteTower then
                local document = LocalUser.infiniteTower:getDocument()
                if document and document.floor then
                    return document.floor
                end
            end
            return nil
        end)
        
        if success and result then
            WindUI:Notify({
                Title = "Infinite Tower",
                Content = "Current Floor: " .. result,
                Duration = 5,
                Icon = "tower"
            })
        else
            WindUI:Notify({
                Title = "Infinite Tower",
                Content = "Not currently in Infinite Tower mode",
                Duration = 5,
                Icon = "alert-triangle",
                Color = "Orange"
            })
        end
    end
})

Tabs.TowersTab:Toggle({
    Title = "Auto Pause Infinite Tower",
    Default = false,
    Callback = function(state)
        if state then
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("6263b280-9765-4af6-8a4a-cf278320082c"):FireServer()
        end
    end
})

Tabs.TowersTab:Button({
    Title = "Check Battle Tower Level",
    Callback = function()
        local function checkBattleTowerLevel()
            local LocalUserModule = game:GetService("ReplicatedStorage"):WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")
            
            local success, result = pcall(function()
                local LocalUser = require(LocalUserModule).LocalUser
                local battleTowerWave = LocalUser.metadata:getAsNumber("battle_tower_wave")
                return battleTowerWave or 1
            end)
            
            if success then
                WindUI:Notify({
                    Title = "Battle Tower",
                    Content = "Current Level: " .. result,
                    Duration = 5,
                    Icon = "tower"
                })
            else
                WindUI:Notify({
                    Title = "Battle Tower",
                    Content = "Error retrieving level",
                    Duration = 5,
                    Icon = "alert-triangle",
                    Color = "Red"
                })
            end
        end
        
        checkBattleTowerLevel()
    end
})

-- Shop Tab Content - Completely restructured
Tabs.ShopTab:Section({ Title = "Shop" })

-- Shop introduction
Tabs.ShopTab:Paragraph({
    Title = "Regular Potions",
    Desc = "Purchase potions to boost gameplay",
    Color = "Blue",
    Image = "potion"
})

-- Small Potions
Tabs.ShopTab:Section({ Title = "Small Potions" })
local smallPotions = {
    ["Small Cooldown Reduction Potion"] = "small_cooldown_reduction_potion",
    ["Small Luck Potion"] = "small_luck_potion"
}

for potionName, potionId in pairs(smallPotions) do
    Tabs.ShopTab:Button({
        Title = "Buy " .. potionName,
        Callback = function()
            local args = {
                [1] = potionId,
                [2] = 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("57250fb8-7458-427c-851a-063889d30f2c"):FireServer(unpack(args))
            
            -- Notify user that the potion was purchased
            WindUI:Notify({
                Title = "Shop",
                Content = "Purchased: " .. potionName,
                Duration = 2,
                Icon = "shopping-cart"
            })
        end
    })
end

-- Medium Potions
Tabs.ShopTab:Section({ Title = "Medium Potions" })
local mediumPotions = {
    ["Medium Luck Potion"] = "medium_luck_potion",
    ["Medium Cooldown Reduction Potion"] = "medium_cooldown_reduction_potion"
}

for potionName, potionId in pairs(mediumPotions) do
    Tabs.ShopTab:Button({
        Title = "Buy " .. potionName,
        Callback = function()
            local args = {
                [1] = potionId,
                [2] = 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("57250fb8-7458-427c-851a-063889d30f2c"):FireServer(unpack(args))
            
            -- Notify user that the potion was purchased
            WindUI:Notify({
                Title = "Shop",
                Content = "Purchased: " .. potionName,
                Duration = 2,
                Icon = "shopping-cart"
            })
        end
    })
end

-- Large Potions
Tabs.ShopTab:Section({ Title = "Large Potions" })
local largePotions = {
    ["Large Cooldown Reduction Potion"] = "large_cooldown_reduction_potion",
    ["Large Luck Potion"] = "large_luck_potion"
}

for potionName, potionId in pairs(largePotions) do
    Tabs.ShopTab:Button({
        Title = "Buy " .. potionName,
        Callback = function()
            local args = {
                [1] = potionId,
                [2] = 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("57250fb8-7458-427c-851a-063889d30f2c"):FireServer(unpack(args))
            
            -- Notify user that the potion was purchased
            WindUI:Notify({
                Title = "Shop",
                Content = "Purchased: " .. potionName,
                Duration = 2,
                Icon = "shopping-cart"
            })
        end
    })
end

-- Misc Tab Content - Completely restructured
Tabs.MiscTab:Section({ Title = "Auto Stats" })

local stats = {
    ["Boss Chance"] = "BOSS_CHANCE",
    ["Border Chance"] = "BORDER_CHANCE",
    ["Potion Duration"] = "POTION_DURATION",
    ["Cooldown Reduction"] = "COOLDOWN_REDUCTION",
    ["Luck"] = "LUCK"
}

for statName, statId in pairs(stats) do
    Tabs.MiscTab:Toggle({
        Title = "Auto Upgrade " .. statName,
        Default = false,
        Callback = function(state)
            if state then
                local args = {
                    [1] = statId
                }
                game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("499542e6-c5a3-47ba-8533-aa5ce418d917"):FireServer(unpack(args))
            end
        end
    })
end

-- Performance section
Tabs.MiscTab:Section({ Title = "Performance" })

Tabs.MiscTab:Paragraph({
    Title = "Performance Options",
    Desc = "Enhance your game performance with these settings",
    Color = "Green",
    Image = "settings"
})

-- Anti-AFK Toggle
Tabs.MiscTab:Toggle({
    Title = "Anti-AFK",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        
        if state then
            -- Starte Anti-AFK
            _G.AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                -- Simuliere Bewegung, um AFK-Kick zu verhindern
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                
                -- Benachrichtigung
                WindUI:Notify({
                    Title = "Anti-AFK",
                    Content = "AFK-Erkennung verhindert",
                    Duration = 2,
                    Icon = "shield"
                })
            end)
            
            -- Benachrichtigung beim Aktivieren
            WindUI:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK-Schutz aktiviert",
                Duration = 3,
                Icon = "user-check"
            })
        else
            -- Stoppe Anti-AFK
            if _G.AntiAFKConnection then
                _G.AntiAFKConnection:Disconnect()
                _G.AntiAFKConnection = nil
            end
            
            -- Benachrichtigung beim Deaktivieren
            WindUI:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK-Schutz deaktiviert",
                Duration = 3,
                Icon = "user-x"
            })
        end
    end
})

-- FPS Boost option
Tabs.MiscTab:Toggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(state)
        if state then
            -- Disable unnecessary rendering features
            local lighting = game:GetService("Lighting")
            
            -- Store original values to restore later
            _G.OriginalLightingSettings = {
                Brightness = lighting.Brightness,
                GlobalShadows = lighting.GlobalShadows,
                Technology = lighting.Technology,
                Ambient = lighting.Ambient,
                OutdoorAmbient = lighting.OutdoorAmbient
            }
            
            -- Apply performance settings
            lighting.GlobalShadows = false
            lighting.Technology = Enum.Technology.Compatibility
            lighting.Brightness = 0.1
            
            -- Reduce graphics quality
            settings().Rendering.QualityLevel = 1
            
            -- Remove terrain details
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
            
            -- Notify user
            WindUI:Notify({
                Title = "Performance",
                Content = "FPS Boost enabled",
                Duration = 3,
                Icon = "zap"
            })
        else
            -- Restore original settings
            if _G.OriginalLightingSettings then
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = _G.OriginalLightingSettings.GlobalShadows
                lighting.Technology = _G.OriginalLightingSettings.Technology
                lighting.Brightness = _G.OriginalLightingSettings.Brightness
                lighting.Ambient = _G.OriginalLightingSettings.Ambient
                lighting.OutdoorAmbient = _G.OriginalLightingSettings.OutdoorAmbient
                
                -- Restore terrain
                workspace.Terrain.WaterWaveSize = 0.15
                workspace.Terrain.WaterWaveSpeed = 10
                workspace.Terrain.WaterReflectance = 0.05
                workspace.Terrain.WaterTransparency = 0.7
                
                -- Restore graphics quality
                settings().Rendering.QualityLevel = 7
                
                _G.OriginalLightingSettings = nil
                
                -- Notify user
                WindUI:Notify({
                    Title = "Performance",
                    Content = "FPS Boost disabled",
                    Duration = 3,
                    Icon = "zap-off"
                })
            end
        end
    end
})

-- Disable particles option
Tabs.MiscTab:Toggle({
    Title = "Disable Particles",
    Default = false,
    Callback = function(state)
        _G.DisableParticles = state
        
        if state then
            -- Connect to RenderStepped to disable particles as they appear
            _G.ParticleConnection = game:GetService("RunService").RenderStepped:Connect(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end
            end)
            
            -- Notify user
            WindUI:Notify({
                Title = "Performance",
                Content = "Particles disabled",
                Duration = 3,
                Icon = "snowflake-off"
            })
        else
            if _G.ParticleConnection then
                _G.ParticleConnection:Disconnect()
                _G.ParticleConnection = nil
            end
            
            -- Notify user
            WindUI:Notify({
                Title = "Performance",
                Content = "Particles enabled",
                Duration = 3,
                Icon = "snowflake"
            })
        end
    end
})

-- Webhook settings section
Tabs.MiscTab:Section({ Title = "Discord Webhook" })

Tabs.MiscTab:Paragraph({
    Title = "Discord Notifications",
    Desc = "Send game notifications to your Discord server",
    Color = "Blue",
    Image = "message-square"
})

-- Webhook URL input
Tabs.MiscTab:Input({
    Title = "Discord Webhook URL",
    Default = "",
    PlaceholderText = "Enter your Discord webhook URL here",
    Callback = function(input)
        _G.WebhookURL = input
    end
})

-- Webhook interval dropdown
local webhookIntervals = {"5", "10", "15", "30", "60"}
Tabs.MiscTab:Dropdown({
    Title = "Notification Interval (minutes)",
    Values = webhookIntervals,
    Default = "15",
    Callback = function(selected)
        _G.WebhookInterval = tonumber(selected)
    end
})

-- Toggle webhook notifications
Tabs.MiscTab:Toggle({
    Title = "Enable Discord Notifications",
    Default = false,
    Callback = function(state)
        _G.WebhookEnabled = state
        
        if state then
            if not _G.WebhookURL or _G.WebhookURL == "" then
                WindUI:Notify({
                    Title = "Webhook Error",
                    Content = "Please enter a valid webhook URL first",
                    Duration = 5,
                    Icon = "alert-triangle",
                    Color = "Red"
                })
                return
            end
            
            -- Start webhook notifications
            _G.LastWebhookTime = os.time()
            
            _G.WebhookConnection = game:GetService("RunService").Heartbeat:Connect(function()
                -- Check if it's time to send a webhook
                local currentTime = os.time()
                local intervalInSeconds = (_G.WebhookInterval or 15) * 60
                
                if currentTime - _G.LastWebhookTime >= intervalInSeconds then
                    -- Send webhook notification
                    -- This function will be implemented later
                    WindUI:Notify({
                        Title = "Discord Notification",
                        Content = "Sending update to Discord...",
                        Duration = 3,
                        Icon = "send"
                    })
                    
                    -- Update last webhook time
                    _G.LastWebhookTime = currentTime
                end
                
                -- Only check every 30 seconds to save performance
                task.wait(30)
            end)
        else
            if _G.WebhookConnection then
                _G.WebhookConnection:Disconnect()
                _G.WebhookConnection = nil
            end
        end
    end
})

-- Auto Farm Tab additional content
Tabs.AutoFarmTab:Section({ Title = "Auto Pickup" })

Tabs.AutoFarmTab:Toggle({
    Title = "Auto Pickup Items",
    Default = false,
    Callback = function(state)
        _G.AutoPickup = state
        
        if state then
            -- Initialize variables
            _G.LastItemCheck = 0
            _G.TargetItem = nil
            _G.CurrentlyTweening = false
            
            -- Function to find the closest item
            local function findClosestItem()
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                if not character then return nil end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then return nil end
                
                -- Check for items in the folder
                local folder = workspace:FindFirstChild("Folder")
                if not folder then return nil end
                
                -- Get all items in the folder
                local items = folder:GetChildren()
                
                if #items == 0 then return nil end
                
                -- Find the closest item
                local closestItem = nil
                local closestDistance = math.huge
                
                for _, item in pairs(items) do
                    if item:IsA("Model") then
                        local itemPosition = item:GetPivot().Position
                        local distance = (itemPosition - humanoidRootPart.Position).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestItem = item
                        end
                    end
                end
                
                return closestItem
            end
            
            -- Auto pickup loop with better performance
            _G.AutoPickupConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                if not character then return end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then return end
                
                -- If we're currently tweening to an item, don't search for a new one
                if _G.CurrentlyTweening then return end
                
                -- Check if we have a target item and it still exists
                if _G.TargetItem and _G.TargetItem.Parent then
                    -- We already have a target, continue moving to it
                    local itemPosition = _G.TargetItem:GetPivot().Position
                    local distance = (itemPosition - humanoidRootPart.Position).Magnitude
                    
                    -- If we're close enough, we probably picked it up
                    if distance < 5 then
                        WindUI:Notify({
                            Title = "Auto Pickup",
                            Content = "Item collected",
                            Duration = 1,
                            Icon = "check"
                        })
                        
                        _G.TargetItem = nil
                        
                        -- Immediately find the next item
                        _G.TargetItem = findClosestItem()
                        if _G.TargetItem then
                            WindUI:Notify({
                                Title = "Auto Pickup",
                                Content = "Moving to next item",
                                Duration = 1,
                                Icon = "package"
                            })
                        end
                        
                        return
                    end
                    
                    -- Calculate tween time based on distance (faster for closer items)
                    local tweenTime = math.min(distance / 100, 1.5)
                    
                    _G.CurrentlyTweening = true
                    
                    -- Tween to item position
                    local tween = game:GetService("TweenService"):Create(
                        humanoidRootPart,
                        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
                        {CFrame = CFrame.new(itemPosition)}
                    )
                    
                    tween:Play()
                    
                    tween.Completed:Connect(function()
                        task.wait(0.2) -- Small wait to pick up item
                        _G.CurrentlyTweening = false
                        
                        -- Check if we still have the same target and it exists
                        if _G.TargetItem and _G.TargetItem.Parent then
                            -- If we're still far from the item after tweening, it might be unreachable
                            local newDistance = (_G.TargetItem:GetPivot().Position - humanoidRootPart.Position).Magnitude
                            if newDistance > 10 then
                                -- Item might be unreachable, forget it
                                _G.TargetItem = nil
                                
                                -- Try to find a new item immediately
                                _G.TargetItem = findClosestItem()
                            end
                        else
                            -- Item no longer exists, we probably picked it up
                            _G.TargetItem = nil
                            
                            -- Try to find a new item immediately
                            _G.TargetItem = findClosestItem()
                            if _G.TargetItem then
                                WindUI:Notify({
                                    Title = "Auto Pickup",
                                    Content = "Moving to next item",
                                    Duration = 1,
                                    Icon = "package"
                                })
                            end
                        end
                    end)
                else
                    -- Only check for new items every 0.5 seconds if we don't have a target
                    local currentTime = tick()
                    if currentTime - _G.LastItemCheck < 0.5 then 
                        return
                    end
                    
                    _G.LastItemCheck = currentTime
                    
                    -- Find a new target item
                    _G.TargetItem = findClosestItem()
                    
                    if _G.TargetItem then
                        WindUI:Notify({
                            Title = "Auto Pickup",
                            Content = "Moving to item",
                            Duration = 1,
                            Icon = "package"
                        })
                    end
                end
            end)
        else
            if _G.AutoPickupConnection then
                _G.AutoPickupConnection:Disconnect()
                _G.AutoPickupConnection = nil
            end
            _G.CurrentlyTweening = false
            _G.TargetItem = nil
        end
    end
})

-- Debug button to show items in Folder
Tabs.AutoFarmTab:Button({
    Title = "Check Available Items",
    Callback = function()
        local folder = workspace:FindFirstChild("Folder")
        if not folder then
            WindUI:Notify({
                Title = "Items",
                Content = "No item folder found",
                Duration = 3,
                Icon = "alert-triangle",
                Color = "Red"
            })
            return
        end
        
        local items = folder:GetChildren()
        
        WindUI:Notify({
            Title = "Items Found",
            Content = "Found " .. #items .. " items in the world",
            Duration = 3,
            Icon = "package"
        })
        
        -- Print item details to console
        print("\n==== ITEMS IN WORLD ====")
        for i, item in ipairs(items) do
            if i <= 10 then -- Only print first 10 to avoid spam
                print("Item " .. i .. ": " .. item.Name .. " (Type: " .. item.ClassName .. ")")
            end
        end
        if #items > 10 then
            print("... and " .. (#items - 10) .. " more items")
        end
        print("=======================")
    end
})

-- Auto Farm All Enemies and Bosses
Tabs.AutoFarmTab:Section({ Title = "Auto Farm Sequences" })

-- Definition aller Gegner
local allEnemies = {
    -- Ninja Village
    {name = "Rock Lee", id = "unstoppable_fist", isBoss = false, location = "Ninja Village"},
    {name = "Kakashi", id = "copy_ninja", isBoss = false, location = "Ninja Village"},
    {name = "Sasuke", id = "awakened_dark_avenger", isBoss = false, location = "Ninja Village"},
    {name = "Naruto Sage", id = "awakened_promised_child", isBoss = false, location = "Ninja Village"},
    {name = "Pain", id = "six_paths_of_pain", isBoss = false, location = "Ninja Village"},
    {name = "Naruto Rage", id = "bijuu_beast", isBoss = true, location = "Ninja Village"},
    
    -- Green Village
    {name = "Son Gohan", id = "ultimate_warrior", isBoss = false, location = "Green Village"},
    {name = "Captain Ginyu", id = "body_switcher", isBoss = false, location = "Green Village"},
    {name = "Piccolo", id = "namekian_sage", isBoss = false, location = "Green Village"},
    {name = "Vegeta", id = "awakened_prideful_prince", isBoss = false, location = "Green Village"},
    {name = "Goku", id = "awakened_earth_strongest", isBoss = false, location = "Green Village"},
    {name = "Frieza", id = "awakened_galactic_tyrant", isBoss = true, location = "Green Village"},
    
    -- Shibuya Station
    {name = "Nobara", id = "cursed_doll", isBoss = false, location = "Shibuya Station"},
    {name = "Megumi", id = "awakened_shadow_summoner", isBoss = false, location = "Shibuya Station"},
    {name = "Yuji", id = "cursed_fist", isBoss = false, location = "Shibuya Station"},
    {name = "Yuta", id = "rika_blessing", isBoss = false, location = "Shibuya Station"},
    {name = "Gojo", id = "limitless_master", isBoss = false, location = "Shibuya Station"},
    {name = "Sukuna", id = "king_of_curses", isBoss = true, location = "Shibuya Station"},
    
    -- Titans City
    {name = "Erwin", id = "survey_commander", isBoss = false, location = "Titans City"},
    {name = "Mikasa", id = "blade_warrior", isBoss = false, location = "Titans City"},
    {name = "Reiner", id = "armored_giant", isBoss = false, location = "Titans City"},
    {name = "Zeke", id = "beast_giant", isBoss = false, location = "Titans City"},
    {name = "Levi", id = "blade_captain", isBoss = false, location = "Titans City"},
    {name = "Eren", id = "combat_giant", isBoss = true, location = "Titans City"},
    
    -- Dimensional Fortress
    {name = "Kaigaku", id = "thunder_demon", isBoss = false, location = "Dimensional Fortress"},
    {name = "Hantengu", id = "childish_demon", isBoss = false, location = "Dimensional Fortress"},
    {name = "Akaza", id = "compass_demon", isBoss = false, location = "Dimensional Fortress"},
    {name = "Doma", id = "awakened_frost_demon", isBoss = false, location = "Dimensional Fortress"},
    {name = "Kokushibo", id = "awakened_six_eyed_slayer", isBoss = false, location = "Dimensional Fortress"},
    {name = "Muzan", id = "awakened_pale_demon_lord", isBoss = true, location = "Dimensional Fortress"},
    
    -- Candy Island
    {name = "Daifuku", id = "genie_commander", isBoss = false, location = "Candy Island"},
    {name = "Perospero", id = "candy_master", isBoss = false, location = "Candy Island"},
    {name = "Cracker", id = "biscuit_warrior", isBoss = false, location = "Candy Island"},
    {name = "Smoothie", id = "juice_queen", isBoss = false, location = "Candy Island"},
    {name = "Katakuri", id = "mochi_emperor", isBoss = false, location = "Candy Island"},
    {name = "Big Mom", id = "soul_queen", isBoss = true, location = "Candy Island"},
    
    -- Solo City
    {name = "Cha Hae-In", id = "light_saintess", isBoss = false, location = "Solo City"},
    {name = "Thomas Andre", id = "the_goliath", isBoss = false, location = "Solo City"},
    {name = "Tank", id = "shadow_bear", isBoss = false, location = "Solo City"},
    {name = "Igris", id = "shadow_commander", isBoss = false, location = "Solo City"},
    {name = "Beru", id = "shadow_ant", isBoss = false, location = "Solo City"},
    {name = "Sung Jinwoo", id = "awakened_shadow_monarch", isBoss = true, location = "Solo City"}
}

-- Kampffunktion für alle Auto-Farm Modi
local function fightEnemy(enemyId)
    local args = {
        [1] = enemyId
    }
    game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("9efaaa87-7d74-4d63-8466-8bb11b0391ad"):FireServer(unpack(args))
end

-- Auto Farm alle normalen Gegner
Tabs.AutoFarmTab:Toggle({
    Title = "Auto Farm All Normal Enemies",
    Default = false,
    Callback = function(state)
        _G.AutoFarmAllEnemies = state
        
        if state then
            -- Globale Variablen für das Auto-Farming
            _G.CurrentEnemyIndex = 1
            _G.InBattle = false
            _G.LastEnemyTime = 0
            
            -- Kampfstatus erkennen
            _G.BattleStatusConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local player = game.Players.LocalPlayer
                local playerGui = player:FindFirstChild("PlayerGui")
                
                if playerGui then
                    -- Überprüfen, ob der Spieler in einem Kampf ist
                    local inBattle = playerGui:FindFirstChild("battle") ~= nil or 
                                     playerGui:FindFirstChild("HideBattleButton") ~= nil
                    _G.InBattle = inBattle
                end
                
                task.wait(0.5) -- Überprüfen Sie den Kampfstatus alle 0,5 Sekunden
            end)
            
            -- Auto Farm Loop für normale Gegner
            _G.AutoFarmEnemiesConnection = game:GetService("RunService").Heartbeat:Connect(function()
                -- Wenn der Spieler in einem Kampf ist, nicht fortfahren
                if _G.InBattle then return end
                
                -- Warten Sie zwischen den Gegnern
                local currentTime = os.time()
                if currentTime - _G.LastEnemyTime < 5 then 
                    return 
                end
                
                -- Sortiere Feinde für normales Farming (keine Bosse)
                local regularEnemies = {}
                for _, enemy in ipairs(allEnemies) do
                    if not enemy.isBoss then
                        table.insert(regularEnemies, enemy)
                    end
                end
                
                -- Wenn alle Gegner bekämpft wurden, beginnen Sie von vorne
                if _G.CurrentEnemyIndex > #regularEnemies then
                    _G.CurrentEnemyIndex = 1
                    
                    WindUI:Notify({
                        Title = "Auto Farm",
                        Content = "Alle Gegner bekämpft, starte von vorne",
                        Duration = 3,
                        Icon = "refresh-cw"
                    })
                    
                    return
                end
                
                -- Gegner bekämpfen
                local currentEnemy = regularEnemies[_G.CurrentEnemyIndex]
                fightEnemy(currentEnemy.id)
                
                -- Aktualisieren Sie Variablen
                _G.LastEnemyTime = currentTime
                _G.CurrentEnemyIndex = _G.CurrentEnemyIndex + 1
                
                -- Benachrichtigung anzeigen
                WindUI:Notify({
                    Title = "Auto Farm",
                    Content = "Bekämpfe " .. currentEnemy.name .. " in " .. currentEnemy.location,
                    Duration = 3,
                    Icon = "swords"
                })
            end)
        else
            -- Verbindungen trennen, wenn deaktiviert
            if _G.AutoFarmEnemiesConnection then
                _G.AutoFarmEnemiesConnection:Disconnect()
                _G.AutoFarmEnemiesConnection = nil
            end
            
            if _G.BattleStatusConnection then
                _G.BattleStatusConnection:Disconnect()
                _G.BattleStatusConnection = nil
            end
        end
    end
})

-- Auto Farm alle Bosse
Tabs.AutoFarmTab:Toggle({
    Title = "Auto Farm All Bosses",
    Default = false,
    Callback = function(state)
        _G.AutoFarmAllBosses = state
        
        if state then
            -- Globale Variablen für das Boss-Farming
            _G.CurrentBossIndex = 1
            _G.InBossBattle = false
            _G.LastBossTime = 0
            
            -- Kampfstatus erkennen (falls noch nicht verbunden)
            if not _G.BattleStatusConnection then
                _G.BattleStatusConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    local player = game.Players.LocalPlayer
                    local playerGui = player:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- Überprüfen, ob der Spieler in einem Kampf ist
                        local inBattle = playerGui:FindFirstChild("battle") ~= nil or 
                                         playerGui:FindFirstChild("HideBattleButton") ~= nil
                        _G.InBossBattle = inBattle
                    end
                    
                    task.wait(0.5)
                end)
            end
            
            -- Boss Auto Farm Loop
            _G.AutoFarmBossesConnection = game:GetService("RunService").Heartbeat:Connect(function()
                -- Wenn der Spieler in einem Kampf ist, nicht fortfahren
                if _G.InBossBattle then return end
                
                -- Warten Sie zwischen den Bossen
                local currentTime = os.time()
                if currentTime - _G.LastBossTime < 5 then 
                    return 
                end
                
                -- Bosse filtern
                local bosses = {}
                for _, enemy in ipairs(allEnemies) do
                    if enemy.isBoss then
                        table.insert(bosses, enemy)
                    end
                end
                
                -- Wenn alle Bosse bekämpft wurden, beginnen Sie von vorne
                if _G.CurrentBossIndex > #bosses then
                    _G.CurrentBossIndex = 1
                    
                    WindUI:Notify({
                        Title = "Boss Farm",
                        Content = "Alle Bosse bekämpft, starte von vorne",
                        Duration = 3,
                        Icon = "refresh-cw"
                    })
                    
                    return
                end
                
                -- Boss bekämpfen
                local currentBoss = bosses[_G.CurrentBossIndex]
                fightEnemy(currentBoss.id)
                
                -- Aktualisieren Sie Variablen
                _G.LastBossTime = currentTime
                _G.CurrentBossIndex = _G.CurrentBossIndex + 1
                
                -- Benachrichtigung anzeigen
                WindUI:Notify({
                    Title = "Boss Farm",
                    Content = "Bekämpfe BOSS: " .. currentBoss.name .. " in " .. currentBoss.location,
                    Duration = 3,
                    Icon = "shield"
                })
            end)
        else
            -- Verbindungen trennen, wenn deaktiviert
            if _G.AutoFarmBossesConnection then
                _G.AutoFarmBossesConnection:Disconnect()
                _G.AutoFarmBossesConnection = nil
            end
            
            -- Trennen Sie die BattleStatusConnection nur, wenn beide Auto Farm-Optionen deaktiviert sind
            if not _G.AutoFarmAllEnemies and _G.BattleStatusConnection then
                _G.BattleStatusConnection:Disconnect()
                _G.BattleStatusConnection = nil
            end
        end
    end
})

-- Custom Auto Farm mit Multiselect
Tabs.AutoFarmTab:Section({ Title = "Custom Auto Farm" })

-- Locations für den Custom Auto Farm
local allLocations = {
    "Ninja Village",
    "Green Village",
    "Shibuya Station",
    "Titans City",
    "Dimensional Fortress",
    "Candy Island",
    "Solo City"
}

-- Hilfsfunktion zum Erstellen der Gegner-Liste aus Standorten
local function getEnemiesFromLocations(locations, includeBosses, includeNormal)
    local result = {}
    
    for _, enemy in ipairs(allEnemies) do
        local includeThisEnemy = false
        
        -- Prüfen, ob der Gegner an einem der ausgewählten Standorte ist
        for _, location in ipairs(locations) do
            if enemy.location == location then
                -- Prüfen, ob wir diesen Gegnertyp einbeziehen sollen
                if (enemy.isBoss and includeBosses) or (not enemy.isBoss and includeNormal) then
                    includeThisEnemy = true
                    break
                end
            end
        end
        
        if includeThisEnemy then
            table.insert(result, enemy)
        end
    end
    
    return result
end

-- Multi-Select für Locations
local selectedLocations = {}
Tabs.AutoFarmTab:Dropdown({
    Title = "Select Locations",
    Values = allLocations,
    Multi = true,
    Default = {},
    Callback = function(selected)
        selectedLocations = selected
        
        -- Benachrichtigung, wenn Standorte ausgewählt wurden
        if #selected > 0 then
            WindUI:Notify({
                Title = "Locations Selected",
                Content = #selected .. " locations selected",
                Duration = 2,
                Icon = "map-pin"
            })
        end
    end
})

-- Toggle für Gegnertypen
local includeNormal = true
local includeBosses = false

Tabs.AutoFarmTab:Toggle({
    Title = "Include Normal Enemies",
    Default = true,
    Callback = function(state)
        includeNormal = state
    end
})

Tabs.AutoFarmTab:Toggle({
    Title = "Include Bosses",
    Default = false,
    Callback = function(state)
        includeBosses = state
    end
})

-- Start Custom Farm Button
Tabs.AutoFarmTab:Button({
    Title = "Start Custom Farm",
    Callback = function()
        -- Prüfen, ob mindestens ein Standort ausgewählt wurde
        if #selectedLocations == 0 then
            WindUI:Notify({
                Title = "Error",
                Content = "Bitte wähle mindestens einen Standort aus!",
                Duration = 3,
                Icon = "alert-triangle",
                Color = "Red"
            })
            return
        end
        
        -- Prüfen, ob mindestens ein Gegnertyp ausgewählt wurde
        if not includeNormal and not includeBosses then
            WindUI:Notify({
                Title = "Error",
                Content = "Bitte wähle mindestens einen Gegnertyp aus!",
                Duration = 3,
                Icon = "alert-triangle",
                Color = "Red"
            })
            return
        end
        
        -- Gegner basierend auf Standorten und Typen filtern
        local filteredEnemies = getEnemiesFromLocations(selectedLocations, includeBosses, includeNormal)
        
        if #filteredEnemies == 0 then
            WindUI:Notify({
                Title = "Error",
                Content = "Keine Gegner gefunden, die zu deinen Filterkriterien passen!",
                Duration = 3,
                Icon = "alert-triangle",
                Color = "Red"
            })
            return
        end
        
        -- Auto Farm starten
        _G.CustomEnemyIndex = 1
        _G.CustomEnemies = filteredEnemies
        _G.InCustomBattle = false
        _G.LastCustomTime = 0
        
        -- Kampfstatus erkennen
        if _G.CustomBattleStatusConnection then
            _G.CustomBattleStatusConnection:Disconnect()
        end
        
        _G.CustomBattleStatusConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            local playerGui = player:FindFirstChild("PlayerGui")
            
            if playerGui then
                -- Überprüfen, ob der Spieler in einem Kampf ist
                local inBattle = playerGui:FindFirstChild("battle") ~= nil or 
                                 playerGui:FindFirstChild("HideBattleButton") ~= nil
                _G.InCustomBattle = inBattle
            end
            
            task.wait(0.5)
        end)
        
        -- Custom Auto Farm Loop
        if _G.CustomFarmConnection then
            _G.CustomFarmConnection:Disconnect()
        end
        
        _G.CustomFarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
            -- Wenn der Spieler in einem Kampf ist, nicht fortfahren
            if _G.InCustomBattle then return end
            
            -- Warten Sie zwischen den Gegnern
            local currentTime = os.time()
            if currentTime - _G.LastCustomTime < 5 then 
                return 
            end
            
            -- Wenn alle Gegner bekämpft wurden, beginnen Sie von vorne
            if _G.CustomEnemyIndex > #_G.CustomEnemies then
                _G.CustomEnemyIndex = 1
                
                WindUI:Notify({
                    Title = "Custom Auto Farm",
                    Content = "Alle ausgewählten Gegner bekämpft, starte von vorne",
                    Duration = 3,
                    Icon = "refresh-cw"
                })
                
                return
            end
            
            -- Gegner bekämpfen
            local currentEnemy = _G.CustomEnemies[_G.CustomEnemyIndex]
            fightEnemy(currentEnemy.id)
            
            -- Aktualisieren Sie Variablen
            _G.LastCustomTime = currentTime
            _G.CustomEnemyIndex = _G.CustomEnemyIndex + 1
            
            -- Benachrichtigung anzeigen
            local enemyType = currentEnemy.isBoss and "BOSS: " or ""
            WindUI:Notify({
                Title = "Custom Auto Farm",
                Content = "Bekämpfe " .. enemyType .. currentEnemy.name .. " in " .. currentEnemy.location,
                Duration = 3,
                Icon = currentEnemy.isBoss and "shield" or "swords"
            })
        end)
        
        -- Feedback, dass Custom Farm gestartet wurde
        WindUI:Notify({
            Title = "Custom Auto Farm",
            Content = "Starte Farm mit " .. #filteredEnemies .. " ausgewählten Gegnern",
            Duration = 3,
            Icon = "play"
        })
    end
})

-- Stop Custom Farm Button
Tabs.AutoFarmTab:Button({
    Title = "Stop Custom Farm",
    Callback = function()
        if _G.CustomFarmConnection then
            _G.CustomFarmConnection:Disconnect()
            _G.CustomFarmConnection = nil
        end
        
        if _G.CustomBattleStatusConnection then
            _G.CustomBattleStatusConnection:Disconnect()
            _G.CustomBattleStatusConnection = nil
        end
        
        WindUI:Notify({
            Title = "Custom Auto Farm",
            Content = "Custom Auto Farm gestoppt",
            Duration = 3,
            Icon = "stop-circle"
        })
    end
})

-- Information zur Abklingzeit
Tabs.AutoFarmTab:Paragraph({
    Title = "Wichtiger Hinweis",
    Desc = "Alle Gegner und Bosse haben nach dem Besiegen eine Abklingzeit von 10 Minuten!",
    Color = "Orange",
    Image = "info"
})

-- Dashboard Tab content
Tabs.DashboardTab:Section({ Title = "Player Info" })

Tabs.DashboardTab:Paragraph({
    Title = "MythHub Dashboard",
    Desc = "Welcome to MythHub - Your ultimate farming assistant",
    Color = "Blue",
    Image = "home"
})

-- Key System Info
Tabs.DashboardTab:Section({ Title = "Key System" })

Tabs.DashboardTab:Paragraph({
    Title = "MythHub Key Info",
    Desc = "Du nutzt MythHub mit einem gültigen Key. Klicke unten, um einen Key-Link für Freunde zu erhalten.",
    Color = "Green",
    Image = "key"
})

Tabs.DashboardTab:Button({
    Title = "Get Key Link",
    Callback = function()
        local keyLink = MythKeySystem.getKeyLink()
        setclipboard(keyLink)
        
        WindUI:Notify({
            Title = "Key Link",
            Content = "KeyGuardian-Link in Zwischenablage kopiert!",
            Duration = 3,
            Icon = "key"
        })
    end
})

-- Current player info
Tabs.DashboardTab:Section({ Title = "Player Stats" })

Tabs.DashboardTab:Button({
    Title = "Check Stats",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalUser = require(ReplicatedStorage:WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")).LocalUser
        
        -- Available upgrade points
        local upgradePoints = LocalUser.upgrades:getCards()
        
        -- Get other important stats
        local battleTowerWave = LocalUser.metadata:getAsNumber("battle_tower_wave") or 1
        
        -- Notify stats
        WindUI:Notify({
            Title = "Player Stats",
            Content = "Upgrade Points: " .. upgradePoints .. "\nBattle Tower Level: " .. battleTowerWave,
            Duration = 5,
            Icon = "info"
        })
    end
})

-- Active timers and boosts
Tabs.DashboardTab:Button({
    Title = "Check Active Boosts",
    Callback = function()
        local player = game.Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalUser = require(ReplicatedStorage:WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")).LocalUser
        
        -- Check for active potions
        local potions = {}
        local backpackItems = LocalUser.atomMap.player().backpack.items
        
        for itemId, itemData in pairs(backpackItems) do
            if itemData.equipped then
                table.insert(potions, itemId)
            end
        end
        
        if #potions > 0 then
            WindUI:Notify({
                Title = "Active Boosts",
                Content = #potions .. " active boost(s) found",
                Duration = 3,
                Icon = "zap"
            })
        else
            WindUI:Notify({
                Title = "Active Boosts",
                Content = "No active boosts found",
                Duration = 3,
                Icon = "zap-off"
            })
        end
    end
})

-- Game server info
Tabs.DashboardTab:Button({
    Title = "Server Info",
    Callback = function()
        local players = game:GetService("Players"):GetPlayers()
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        
        WindUI:Notify({
            Title = "Server Info",
            Content = "Players: " .. #players .. "/12\nPing: " .. math.floor(ping) .. "ms",
            Duration = 5,
            Icon = "server"
        })
    end
})

-- Quick actions section
Tabs.DashboardTab:Section({ Title = "Quick Actions" })

Tabs.DashboardTab:Button({
    Title = "Check Inventory",
    Callback = function()
        -- Display inventory notification
        WindUI:Notify({
            Title = "Inventory Check",
            Content = "View console for detailed inventory information",
            Duration = 5,
            Icon = "package"
        })
        
        -- Print card inventory to console
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RuntimeLib = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")
        local module = require(RuntimeLib)
        local LocalUser = module.import(script, ReplicatedStorage, "TS", "user", "local", "local-user").LocalUser
        
        -- Function to safely print values
        local function safePrint(name, value)
            if value == nil then
                print(name .. ": nil")
                return
            end
            print(name .. ": " .. tostring(value))
        end
        
        -- Function to list all cards in user's inventory
        local success, cards = pcall(function()
            return LocalUser.deck:getCards()
        end)
        
        if not success then
            print("Error accessing deck: " .. tostring(cards))
            return
        end
        
        local count = 0
        print("\n====== CARD INVENTORY ======")
        
        for cardId, userCard in pairs(cards) do
            count = count + 1
            local card = userCard:getCard()
            
            print("\n--- CARD " .. count .. " ---")
            safePrint("ID", card.id)
            safePrint("Amount", userCard:getAmount())
            safePrint("Is Support", card.isSupport)
            safePrint("Denominator", card.denominator)
        end
        
        print("\n" .. count .. " cards found")
        print("====== END OF INVENTORY ======")
    end
})

-- Teleport to areas
Tabs.DashboardTab:Section({ Title = "Quick Teleports" })

local teleportLocations = {
    ["Ninja Village"] = Vector3.new(-1152, 296, -3744),
    ["Green Village"] = Vector3.new(-2532, 254, -8184),
    ["Shibuya Station"] = Vector3.new(-4992, 299, -2784),
    ["Titans City"] = Vector3.new(-3840, 255, -3744),
    ["Dimensional Fortress"] = Vector3.new(-6768, 256, -4080),
    ["Candy Island"] = Vector3.new(-8016, 255, -4080),
    ["Solo City"] = Vector3.new(-9312, 255, -4080)
}

for locationName, position in pairs(teleportLocations) do
    Tabs.DashboardTab:Button({
        Title = "Teleport to " .. locationName,
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(position)
                
                WindUI:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. locationName,
                    Duration = 2,
                    Icon = "map-pin"
                })
            else
                WindUI:Notify({
                    Title = "Teleport Failed",
                    Content = "Character not found",
                    Duration = 2,
                    Icon = "alert-triangle",
                    Color = "Red"
                })
            end
        end
    })
end

-- Funktion zum Speichern der Konfiguration
function ConfigManager:SaveConfig()
    -- Aktuelle Einstellungen in die Konfiguration übertragen
    -- Auto Farm
    Config.autoFarmSettings.selectedLocation = selectedLocation
    Config.autoFarmSettings.selectedEnemy = selectedEnemy
    Config.autoFarmSettings.autoPickupEnabled = _G.AutoPickup or false
    
    -- Custom Farm
    Config.customFarmSettings.selectedLocations = selectedLocations or {}
    Config.customFarmSettings.includeNormal = includeNormal
    Config.customFarmSettings.includeBosses = includeBosses
    
    -- Raid Settings
    Config.raidSettings.autoDetectDragon = _G.AutoDetectDragon or false
    
    -- Misc Settings
    Config.miscSettings.fpsBoostEnabled = (_G.OriginalLightingSettings ~= nil)
    Config.miscSettings.disableParticles = _G.DisableParticles or false
    Config.miscSettings.webhookURL = _G.WebhookURL or ""
    Config.miscSettings.webhookInterval = _G.WebhookInterval or 15
    Config.miscSettings.webhookEnabled = _G.WebhookEnabled or false
    
    -- Speichern der Konfiguration mit WindUI
    WindowUtil = require(game.ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("WindowUtil"))
    WindowUtil:SetSetting("MythHubConfig", Config)
    
    WindUI:Notify({
        Title = "Konfiguration",
        Content = "Einstellungen wurden gespeichert!",
        Duration = 3,
        Icon = "save"
    })
end

-- Funktion zum Laden der Konfiguration
function ConfigManager:LoadConfig()
    -- Laden der Konfiguration mit WindUI
    WindowUtil = require(game.ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("WindowUtil"))
    local savedConfig = WindowUtil:GetSetting("MythHubConfig")
    
    if savedConfig then
        -- Konfiguration auf gespeicherte Werte setzen
        Config = savedConfig
        
        -- Auto Farm Einstellungen anwenden
        selectedLocation = Config.autoFarmSettings.selectedLocation
        selectedEnemy = Config.autoFarmSettings.selectedEnemy
        _G.AutoPickup = Config.autoFarmSettings.autoPickupEnabled
        
        -- Custom Farm Einstellungen anwenden
        selectedLocations = Config.customFarmSettings.selectedLocations or {}
        includeNormal = Config.customFarmSettings.includeNormal
        includeBosses = Config.customFarmSettings.includeBosses
        
        -- Raid Einstellungen anwenden
        _G.AutoDetectDragon = Config.raidSettings.autoDetectDragon
        
        -- Misc Einstellungen anwenden
        _G.DisableParticles = Config.miscSettings.disableParticles
        _G.WebhookURL = Config.miscSettings.webhookURL
        _G.WebhookInterval = Config.miscSettings.webhookInterval
        _G.WebhookEnabled = Config.miscSettings.webhookEnabled
        
        -- FPS Boost wenn aktiviert
        if Config.miscSettings.fpsBoostEnabled then
            -- FPS Boost Funktionalität hier aktivieren
            local lighting = game:GetService("Lighting")
            
            -- Store original values to restore later
            _G.OriginalLightingSettings = {
                Brightness = lighting.Brightness,
                GlobalShadows = lighting.GlobalShadows,
                Technology = lighting.Technology,
                Ambient = lighting.Ambient,
                OutdoorAmbient = lighting.OutdoorAmbient
            }
            
            -- Apply performance settings
            lighting.GlobalShadows = false
            lighting.Technology = Enum.Technology.Compatibility
            lighting.Brightness = 0.1
            
            -- Reduce graphics quality
            settings().Rendering.QualityLevel = 1
            
            -- Remove terrain details
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
        end
        
        -- Benachrichtigung
        WindUI:Notify({
            Title = "Konfiguration",
            Content = "Einstellungen wurden geladen!",
            Duration = 3,
            Icon = "download"
        })
        
        return true
    else
        -- Keine gespeicherte Konfiguration gefunden
        WindUI:Notify({
            Title = "Konfiguration",
            Content = "Keine gespeicherten Einstellungen gefunden!",
            Duration = 3,
            Icon = "alert-triangle",
            Color = "Orange"
        })
        
        return false
    end
end

-- Tabs für Konfigurationsmanagement
Tabs.MiscTab:Section({ Title = "Konfiguration" })

Tabs.MiscTab:Button({
    Title = "Einstellungen speichern",
    Callback = function()
        ConfigManager:SaveConfig()
    end
})

Tabs.MiscTab:Button({
    Title = "Einstellungen laden",
    Callback = function()
        ConfigManager:LoadConfig()
    end
})

-- Versuche beim Start die Konfiguration zu laden
spawn(function()
    wait(2) -- Kurz warten, bis alles geladen ist
    ConfigManager:LoadConfig()
end) 

for difficultyName, deploymentInfo in pairs(deploymentUnits) do
    Tabs.ExplorationTab:Toggle({
        Title = "Auto Deploy " .. difficultyName,
        Default = false,
        Callback = function(state)
            if state then
                -- Dynamisch die besten Einheiten für diese Schwierigkeit auswählen
                local bestUnits = getBestUnitsForDeployment(deploymentInfo.minDenominator)
                
                local args = {
                    [1] = deploymentInfo.difficultyId,
                    [2] = bestUnits
                }
                game:GetService("ReplicatedStorage"):WaitForChild("JZ0"):WaitForChild("171e5a3a-8c09-493b-8c8e-c1f2cf4376bd"):FireServer(unpack(args))
                
                -- Benachrichtigung für den Benutzer
                WindUI:Notify({
                    Title = "Auto Deploy",
                    Content = difficultyName .. " Erkundung gestartet",
                    Duration = 3,
                    Icon = "compass"
                })
            end
        end
    })
end 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- Global States
getgenv().RoleESPEnabled = false
getgenv().GunESPEnabled = false
local autofarm = false
local autoCoinFarm = false
local autoKillAll = false
local autoShootMurden = false
local gardenAutoBuy = false
local gardenAutoCollect = false
local gardenAutoSell = false
local selectedSeed = "Sunflower Seed"
local toolGrabID = ""

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🍊 OrangeHub | V6.6",
   Icon = 0,
   LoadingTitle = "OrangeHub",
   LoadingSubtitle = "by LazyLaneTTLol",
   Theme = "AmberGlow",
   ConfigurationSaving = { Enabled = true, FolderName = "OrangeHubConfig" },
   KeySystem = true,
   KeySettings = {
      Title = "OrangeHub",
      Subtitle = "Key System",
      Note = "Join the Discord for the Key!",
      FileName = "OrangeKey",
      SaveKey = true,
      Key = {"iHateCherries1"}
   },
   Discord = { Enabled = true, Invite = "sCnMv4bcQX", RememberJoins = true }
})

-- Base ESP Folder
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "OrangeHub_ESP"
ESPFolder.Parent = game.CoreGui

-- [MM2 ROLE ESP LOGIC]
local function TrackPlayer(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_RoleESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = ESPFolder

    task.spawn(function()
        while player and player.Parent do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    highlight.Adornee = char
                    local knife = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                    local gun = char:FindFirstChild("Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun"))

                    if knife then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Murderer
                    elseif gun then
                        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Sheriff
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Innocent
                    end
                    highlight.Enabled = getgenv().RoleESPEnabled
                else
                    highlight.Enabled = false
                end
            end)
            task.wait(0.5)
        end
        highlight:Destroy()
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= lp then TrackPlayer(player) end
end
Players.PlayerAdded:Connect(function(p) if p ~= lp then TrackPlayer(p) end end)

-- Tabs
local HomeTab = Window:CreateTab("Home", 4483362458)
local mm2Tab = Window:CreateTab("MM2", 4483362458)
local GardenTab = Window:CreateTab("Grow a Garden", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

--- [1. HOME TAB] ---
HomeTab:CreateSection("External Loaders")

HomeTab:CreateButton({
    Name = "🚀 Launch PrismTweaks",
    Callback = function()
        Rayfield:Notify({Title = "Prism", Content = "Launching PrismTweaks...", Duration = 3})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmalaney96-alt/orangehub/refs/heads/main/prism.lua"))()
    end,
})

HomeTab:CreateSection("Links & Help")
HomeTab:CreateButton({ Name = "Copy Discord Invite", Callback = function() setclipboard("https://discord.gg/sCnMv4bcQX") end })
HomeTab:CreateButton({ Name = "Server Hop", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, lp) end })

--- [2. MM2 TAB - 10 FEATURES] ---
mm2Tab:CreateSection("1. Visuals & ESP")
mm2Tab:CreateToggle({ -- Feature 1
    Name = "Role ESP (Color Coded)",
    CurrentValue = false,
    Callback = function(v) getgenv().RoleESPEnabled = v end,
})

mm2Tab:CreateToggle({ -- Feature 2
    Name = "Gun Drop ESP",
    CurrentValue = false,
    Callback = function(v)
        getgenv().GunESPEnabled = v
        task.spawn(function()
            while getgenv().GunESPEnabled do
                local gun = workspace:FindFirstChild("GunDrop")
                if gun and not gun:FindFirstChild("GunESP_OH") then
                    local h = Instance.new("Highlight", gun)
                    h.Name = "GunESP_OH"
                    h.FillColor = Color3.fromRGB(255, 255, 0)
                end
                task.wait(1)
            end
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "GunDrop" and obj:FindFirstChild("GunESP_OH") then obj.GunESP_OH:Destroy() end
            end
        end)
    end,
})

mm2Tab:CreateSection("2. Auto-Farming")
mm2Tab:CreateToggle({ -- Feature 3
    Name = "Safe Zone XP Farm",
    CurrentValue = false,
    Callback = function(v)
        autofarm = v
        task.spawn(function()
            while autofarm do
                pcall(function()
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = CFrame.new(99.9, 140.4, 60.7)
                    end
                end)
                task.wait(0.1)
            end
        end)
    end,
})

mm2Tab:CreateToggle({ -- Feature 4
    Name = "Auto-Tween Coins",
    CurrentValue = false,
    Callback = function(v)
        autoCoinFarm = v
        task.spawn(function()
            while autoCoinFarm do
                local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Normal")
                local coins = map and map:FindFirstChild("CoinContainer")
                if coins then
                    for _, coin in pairs(coins:GetChildren()) do
                        if not autoCoinFarm then break end
                        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                            local dist = (hrp.Position - coin.Position).Magnitude
                            local tw = TweenService:Create(hrp, TweenInfo.new(dist/40, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                            tw:Play() tw.Completed:Wait()
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end,
})

mm2Tab:CreateSection("3. Combat & Movement")
mm2Tab:CreateButton({ -- Feature 5
    Name = "Grab Dropped Gun",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then lp.Character:PivotTo(gun.CFrame) end
    end
})

mm2Tab:CreateToggle({ -- Feature 6
    Name = "Kill All Players (Murderer)",
    CurrentValue = false,
    Callback = function(v)
        autoKillAll = v
        task.spawn(function()
            while autoKillAll do
                local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if not autoKillAll then break end
                        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                            knife.Parent = lp.Character
                            task.wait(0.1)
                            knife:Activate()
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end,
})

mm2Tab:CreateToggle({ -- Feature 7
    Name = "Auto Shoot Murderer (Sheriff)",
    CurrentValue = false,
    Callback = function(v)
        autoShootMurden = v
        task.spawn(function()
            while autoShootMurden do
                local gun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
                if gun then
                    for _, p in pairs(Players:GetPlayers()) do
                        local knife = p.Character and p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife"))
                        if knife and p.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                            gun.Parent = lp.Character
                            task.wait(0.1)
                            gun:Activate()
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

mm2Tab:CreateButton({ -- Feature 8
    Name = "Fling Murderer",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            local knife = p.Character and p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife"))
            if knife and p.Character:FindFirstChild("HumanoidRootPart") then
                local old = lp.Character.HumanoidRootPart.CFrame
                lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(999999, 999999, 999999)
                task.wait(0.2)
                lp.Character.HumanoidRootPart.CFrame = old
            end
        end
    end
})

mm2Tab:CreateButton({ -- Feature 9
    Name = "Teleport to Lobby",
    Callback = function()
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby and lobby:FindFirstChild("Spawns") then
            lp.Character:PivotTo(lobby.Spawns:GetChildren()[1].CFrame + Vector3.new(0,5,0))
        end
    end
})

mm2Tab:CreateButton({ -- Feature 10
    Name = "Teleport to Map",
    Callback = function()
        local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Normal")
        if map and map:FindFirstChild("Spawns") then
            lp.Character:PivotTo(map.Spawns:GetChildren()[1].CFrame + Vector3.new(0,5,0))
        end
    end
})

--- [3. GROW A GARDEN TAB] ---
GardenTab:CreateSection("Shop & Tools")
GardenTab:CreateDropdown({
   Name = "Select Seed to Buy",
   Options = {"Sunflower Seed", "Tomato Seed", "Berry Seed", "Wheat Seed", "Pumpkin Seed", "Carrot Seed"},
   CurrentOption = {"Sunflower Seed"},
   Callback = function(Option) selectedSeed = Option[1] end,
})

GardenTab:CreateToggle({
   Name = "Auto Buy Selected Seed",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoBuy = v
      task.spawn(function()
          while gardenAutoBuy do
             local remote = ReplicatedStorage:FindFirstChild("BuySeed", true) or ReplicatedStorage:FindFirstChild("Purchase", true)
             if remote then remote:InvokeServer(selectedSeed) end
             task.wait(1.5)
          end
      end)
   end
})

GardenTab:CreateButton({
    Name = "Teleport to Sam (Shop)",
    Callback = function()
        local sam = workspace:FindFirstChild("Sam", true) or workspace:FindFirstChild("Shop", true)
        if sam then lp.Character:PivotTo(sam:GetPivot() + Vector3.new(0,3,0)) end
    end
})

GardenTab:CreateSection("Farm Management")
GardenTab:CreateToggle({
   Name = "Auto Collect Grown Crops",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoCollect = v
      task.spawn(function()
          while gardenAutoCollect do
             for _, crop in pairs(workspace:GetChildren()) do
                if crop:FindFirstChild("ClickDetector") and (crop.Name:find("Grown") or crop.Name:find("Finished")) then
                   fireclickdetector(crop.ClickDetector)
                end
             end
             task.wait(1)
          end
      end)
   end
})

GardenTab:CreateToggle({
   Name = "Auto Sell Crops",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoSell = v
      task.spawn(function()
          while gardenAutoSell do
             local remote = ReplicatedStorage:FindFirstChild("Sell", true) or ReplicatedStorage:FindFirstChild("SellCrops", true)
             if remote then remote:InvokeServer() end
             task.wait(3)
          end
      end)
   end
})

--- [4. UNIVERSAL TAB] ---
ftTab:CreateSection("Tool Grabber")
ftTab:CreateInput({
   Name = "Enter Tool ID",
   PlaceholderText = "ID...",
   Callback = function(Text) toolGrabID = Text end,
})
ftTab:CreateButton({
   Name = "Grab Tool Into Backpack",
   Callback = function()
      local success, result = pcall(function() return game:GetObjects("rbxassetid://" .. toolGrabID)[1] end)
      if success and result then result.Parent = lp.Backpack end
   end
})

ftTab:CreateSection("World & Players")
ftTab:CreateButton({
    Name = "Fling All Players",
    Callback = function()
        local old = lp.Character.HumanoidRootPart.CFrame
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character then
                lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(500000, 500000, 500000)
                task.wait(0.1)
            end
        end
        lp.Character.HumanoidRootPart.CFrame = old
    end
})

ftTab:CreateButton({
    Name = "Give F3X Building Tools",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end
})

Rayfield:Notify({Title = "OrangeHub", Content = "V6.6 Prism Loaded!", Duration = 3})

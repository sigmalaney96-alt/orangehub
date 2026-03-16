local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- Variables
local currentTween
local mm2FarmActive = false
local autoKillInnocents = false
local autoShootSheriff = false
local autoGardenBuy = false
local autoGardenCollect = false
local selectedSeed = "Sunflower Seed" -- Default

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🍊 OrangeHub",
   Icon = 0,
   LoadingTitle = "OrangeHub | v4.0",
   LoadingSubtitle = "by LazyLaneTTLol",
   Theme = "AmberGlow",
   ConfigurationSaving = { Enabled = true, FolderName = "OrangeHubConfig" },
   KeySystem = true,
   KeySettings = {
      Title = "OrangeHub",
      Subtitle = "Key System",
      Note = "Key is in Discord | Discord : https://discord.gg/sCnMv4bcQX",
      FileName = "OrangeKey",
      SaveKey = true,
      Key = {"iHateCherries1"}
   }
})

-- Tabs
local MainTab = Window:CreateTab("Home", 4483362458)
local mm2Tab = Window:CreateTab("MM2", 4483362458)
local GardenTab = Window:CreateTab("Grow a Garden", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [MM2 TAB - FIXED & EXPANDED]
mm2Tab:CreateSection("Coin Farming")
mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins (FIXED)",
   CurrentValue = false,
   Flag = "MM2_CoinFix", 
   Callback = function(Value)
      mm2FarmActive = Value
      if mm2FarmActive then
         task.spawn(function()
            while mm2FarmActive do 
               -- MM2 map paths often change; this checks both common locations
               local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Normal")
               local container = map and map:FindFirstChild("CoinContainer")
               
               if container then
                  for _, coin in pairs(container:GetChildren()) do
                     if not mm2FarmActive then break end
                     local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                     if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/35, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        
                        -- Double Jump
                        local hum = lp.Character:FindFirstChild("Humanoid")
                        if hum then hum.Jump = true task.wait(0.1) hum.Jump = true end
                        task.wait(0.1)
                     end
                  end
               end
               task.wait(0.5)
            end
         end)
      end
   end,
})

mm2Tab:CreateSection("Combat")
mm2Tab:CreateToggle({
    Name = "Auto Kill Innocents (Murderer)",
    CurrentValue = false,
    Callback = function(Value)
        autoKillInnocents = Value
        task.spawn(function()
            while autoKillInnocents do
                local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                if knife then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            -- Only target players without a weapon (Innocents)
                            if not p.Backpack:FindFirstChild("Knife") and not p.Backpack:FindFirstChild("Gun") then
                                lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1)
                                task.wait(0.1)
                                knife:Activate() -- Slash
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

mm2Tab:CreateButton({
    Name = "Auto Grab Gun",
    Callback = function()
        local gunDrop = workspace:FindFirstChild("GunDrop")
        if gunDrop then
            lp.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
        else
            Rayfield:Notify({Title = "Notice", Content = "No gun dropped on floor.", Duration = 2})
        end
    end
})

-- [GROW A GARDEN TAB]
GardenTab:CreateSection("Garden Automations")
GardenTab:CreateDropdown({
   Name = "Select Seed to Buy",
   Options = {"Sunflower Seed", "Tomato Seed", "Berry Seed", "Wheat Seed"},
   CurrentOption = {"Sunflower Seed"},
   MultipleOptions = false,
   Callback = function(Option) selectedSeed = Option[1] end,
})

GardenTab:CreateToggle({
   Name = "Auto Buy Selected Seed",
   CurrentValue = false,
   Callback = function(v)
       autoGardenBuy = v
       while autoGardenBuy do
           -- Replace 'RemoteName' with the game's actual buy remote if known
           local shopRemote = ReplicatedStorage:FindFirstChild("BuySeed", true)
           if shopRemote then shopRemote:InvokeServer(selectedSeed) end
           task.wait(2)
       end
   end
})

GardenTab:CreateToggle({
    Name = "Auto Collect Crops",
    CurrentValue = false,
    Callback = function(v)
        autoGardenCollect = v
        while autoGardenCollect do
            for _, crop in pairs(workspace:GetChildren()) do
                if crop:FindFirstChild("ClickDetector") and crop.Name:find("Finished") then
                    fireclickdetector(crop.ClickDetector)
                end
            end
            task.wait(1)
        end
    end
})

-- [UNIVERSAL TAB]
ftTab:CreateSection("Fling Section")
ftTab:CreateButton({
    Name = "Fling (All Players)",
    Callback = function()
        local hrp = lp.Character.HumanoidRootPart
        local oldPos = hrp.CFrame
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                hrp.CFrame = p.Character.HumanoidRootPart.CFrame
                hrp.Velocity = Vector3.new(500000, 500000, 500000)
                task.wait(0.1)
            end
        end
        hrp.CFrame = oldPos
    end
})

ftTab:CreateSection("Tools")
ftTab:CreateButton({
    Name = "Give F3X Building Tools",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() -- Includes F3X and more
        Raystring = "F3X Loaded via Infinite Yield module."
    end
})

ftTab:CreateButton({
    Name = "Open Tool Grabber",
    Callback = function()
        -- Tool Grabber Window code...
    end
})

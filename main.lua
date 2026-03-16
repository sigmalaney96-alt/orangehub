local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- Variables
local currentTween
local mm2FarmActive = false
local gardenAutoBuy = false
local gardenAutoCollect = false
local gardenAutoSell = false
local selectedSeed = "Sunflower Seed"
local toolGrabID = ""

-- 99 Nights Data
local teleportTargets = {"Alien", "Alien Chest", "Alpha Wolf", "Bear", "Berry", "Chest", "Coal", "Item Chest", "Rifle", "Wolf"}
local AimbotTargets = {"Alien", "Alpha Wolf", "Wolf", "Cultist", "Bear"}

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🍊 OrangeHub | Multi-Game",
   Icon = 0,
   LoadingTitle = "OrangeHub",
   LoadingSubtitle = "by LazyLaneTTLol",
   Theme = "AmberGlow",
   ConfigurationSaving = { Enabled = true, FolderName = "OrangeHubConfig" },
   KeySystem = true,
   KeySettings = {
      Title = "OrangeHub",
      Subtitle = "Key System",
      Note = "Join the Discord for the Key!", -- Key removed from notes
      FileName = "OrangeKey",
      SaveKey = true,
      Key = {"iHateCherries1"}
   },
   Discord = {
      Enabled = true,
      Invite = "sCnMv4bcQX",
      RememberJoins = true
   }
})

-- Tabs
local HomeTab = Window:CreateTab("Home", 4483362458)
local mm2Tab = Window:CreateTab("MM2", 4483362458)
local GardenTab = Window:CreateTab("Grow a Garden", 4483362458)
local ForestTab = Window:CreateTab("99 Nights", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [HOME TAB]
HomeTab:CreateSection("OrangeHub Information")
HomeTab:CreateParagraph({Title = "Status", Content = "Version 5.5 | All Systems Functional."})

HomeTab:CreateButton({
   Name = "Copy Discord Invite",
   Callback = function()
      setclipboard("https://discord.gg/sCnMv4bcQX")
      Rayfield:Notify({Title = "Clipboard", Content = "Discord Link Copied!", Duration = 3})
   end,
})

HomeTab:CreateButton({
   Name = "Destroy UI",
   Callback = function() Rayfield:Destroy() end,
})

-- [MM2 TAB]
mm2Tab:CreateSection("Farming & Combat")

mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins",
   CurrentValue = false,
   Flag = "MM2_Farm",
   Callback = function(Value)
      mm2FarmActive = Value
      if mm2FarmActive then
         task.spawn(function()
            while mm2FarmActive do
               local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Normal")
               local coins = map and map:FindFirstChild("CoinContainer")
               if coins then
                  for _, coin in pairs(coins:GetChildren()) do
                     if not mm2FarmActive then break end
                     local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                     if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/40, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        
                        local hum = lp.Character:FindFirstChild("Humanoid")
                        if hum then hum.Jump = true task.wait(0.1) hum.Jump = true end
                        task.wait(0.2)
                     end
                  end
               end
               task.wait(1)
            end
         end)
      end
   end
})

mm2Tab:CreateButton({
    Name = "Grab Dropped Gun",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then lp.Character.HumanoidRootPart.CFrame = gun.CFrame end
    end
})

-- [GROW A GARDEN TAB]
GardenTab:CreateSection("Sam's Shop & Farm")

GardenTab:CreateDropdown({
   Name = "Select Seed to Buy",
   Options = {"Sunflower Seed", "Tomato Seed", "Berry Seed", "Wheat Seed", "Pumpkin Seed", "Carrot Seed"},
   CurrentOption = {"Sunflower Seed"},
   Callback = function(Option) selectedSeed = Option[1] end,
})

GardenTab:CreateToggle({
   Name = "Auto Buy from Sam",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoBuy = v
      while gardenAutoBuy do
         local shop = workspace:FindFirstChild("Sam") or workspace:FindFirstChild("Shop")
         local remote = ReplicatedStorage:FindFirstChild("BuySeed", true) or ReplicatedStorage:FindFirstChild("Purchase", true)
         if remote then remote:InvokeServer(selectedSeed) end
         task.wait(1)
      end
   end
})

GardenTab:CreateToggle({
   Name = "Auto Collect Crops",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoCollect = v
      while gardenAutoCollect do
         for _, crop in pairs(workspace:GetChildren()) do
            if crop:FindFirstChild("ClickDetector") and (crop.Name:find("Grown") or crop.Name:find("Finished")) then
               fireclickdetector(crop.ClickDetector)
            end
         end
         task.wait(1)
      end
   end
})

GardenTab:CreateToggle({
   Name = "Auto Sell Crops",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoSell = v
      while gardenAutoSell do
         local sellRemote = ReplicatedStorage:FindFirstChild("Sell", true) or ReplicatedStorage:FindFirstChild("SellCrops", true)
         if sellRemote then sellRemote:InvokeServer() end
         task.wait(5)
      end
   end
})

-- [99 NIGHTS TAB]
ForestTab:CreateSection("Forest Survival Utilities")

ForestTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Callback = function(state)
        _G.ForestESP = state
        while _G.ForestESP do
            for _, item in pairs(workspace:GetDescendants()) do
                if table.find(teleportTargets, item.Name) and not item:FindFirstChild("OrangeHighlight") then
                    local h = Instance.new("Highlight", item)
                    h.Name = "OrangeHighlight"
                    h.FillColor = Color3.fromRGB(255, 165, 0)
                    h.FillTransparency = 0.5
                end
            end
            task.wait(2)
        end
    end
})

ForestTab:CreateButton({
    Name = "Teleport to Closest Loot",
    Callback = function()
        local closest, dist = nil, math.huge
        for _, obj in pairs(workspace:GetDescendants()) do
            if table.find(teleportTargets, obj.Name) then
                local d = (lp.Character.HumanoidRootPart.Position - obj:GetPivot().Position).Magnitude
                if d < dist then dist = d closest = obj end
            end
        end
        if closest then lp.Character:PivotTo(closest:GetPivot() + Vector3.new(0,3,0)) end
    end
})

-- [UNIVERSAL TAB]
ftTab:CreateSection("Tool Grabber")

ftTab:CreateInput({
   Name = "Enter Tool ID",
   PlaceholderText = "Example: 1234567",
   Callback = function(Text) toolGrabID = Text end,
})

ftTab:CreateButton({
   Name = "Grab Tool Into Backpack",
   Callback = function()
      local success, result = pcall(function()
         return game:GetObjects("rbxassetid://" .. toolGrabID)[1]
      end)
      if success and result then
         result.Parent = lp.Backpack
         Rayfield:Notify({Title = "Success", Content = "Tool Imported!"})
      else
         Rayfield:Notify({Title = "Error", Content = "Could not grab tool."})
      end
   end
})

ftTab:CreateSection("Power Tools")

ftTab:CreateButton({
    Name = "Give F3X Building Tools",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() 
    end
})

ftTab:CreateButton({
    Name = "Fling All Players",
    Callback = function()
        local oldPos = lp.Character.HumanoidRootPart.CFrame
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(500000, 500000, 500000)
                task.wait(0.1)
            end
        end
        lp.Character.HumanoidRootPart.CFrame = oldPos
    end
})

Rayfield:Notify({Title = "OrangeHub", Content = "Systems Initialized!", Duration = 3})

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
local selectedSeed = "Sunflower Seed"
local toolGrabID = ""

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
      Note = "Join the Discord for the Key!",
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

--- [HOME TAB] ---
HomeTab:CreateSection("OrangeHub Information")
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

--- [MM2 TAB] ---
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
    Name = "Auto Grab Dropped Gun",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then lp.Character.HumanoidRootPart.CFrame = gun.CFrame end
    end
})

--- [GROW A GARDEN TAB] ---
GardenTab:CreateSection("Sam's Shop & Farm")
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
      while gardenAutoBuy do
         local remote = ReplicatedStorage:FindFirstChild("BuySeed", true) or ReplicatedStorage:FindFirstChild("Purchase", true)
         if remote then remote:InvokeServer(selectedSeed) end
         task.wait(1)
      end
   end
})

GardenTab:CreateToggle({
   Name = "Auto Collect & Sell",
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

--- [99 NIGHTS TAB] ---
ForestTab:CreateSection("99 Nights External Loader")
ForestTab:CreateButton({
    Name = "Load 99 Nights OrangeHub",
    Callback = function()
        Rayfield:Notify({Title = "Loader", Content = "Fetching 99 Nights Script...", Duration = 3})
        -- Updated URL with .lua extension
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmalaney96-alt/orangehub/refs/heads/main/orange99nights.lua"))()
    end
})

--- [UNIVERSAL TAB] ---
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

ftTab:CreateSection("Universal Tools")
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

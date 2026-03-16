local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- State Variables
local mm2FarmActive = false
local gardenAutoBuy = false
local gardenAutoCollect = false
local gardenAutoSell = false
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
      Note = "Join the Discord for the Key!", -- Key hidden from notes
      FileName = "OrangeKey",
      SaveKey = true,
      Key = {"iHateCherries1"}
   }
})

-- Tabs
local HomeTab = Window:CreateTab("Home", 4483362458)
local mm2Tab = Window:CreateTab("MM2", 4483362458)
local GardenTab = Window:CreateTab("Grow a Garden", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [HOME TAB]
HomeTab:CreateSection("OrangeHub Information")
HomeTab:CreateButton({
   Name = "Copy Discord Invite",
   Callback = function()
      setclipboard("https://discord.gg/sCnMv4bcQX")
      Rayfield:Notify({Title = "Clipboard", Content = "Discord Link Copied!", Duration = 3})
   end,
})

HomeTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local PlaceID = game.PlaceId
      local JobID = game.JobId
      game:GetService("TeleportService"):Teleport(PlaceID, lp)
   end,
})

-- [MM2 TAB]
mm2Tab:CreateSection("Auto Farming")
mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins",
   CurrentValue = false,
   Flag = "MM2_Farm",
   Callback = function(Value)
      mm2FarmActive = Value
      task.spawn(function()
         while mm2FarmActive do
            local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("Normal")
            local container = map and map:FindFirstChild("CoinContainer")
            if container then
               for _, coin in pairs(container:GetChildren()) do
                  if not mm2FarmActive then break end
                  local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                  if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                     local dist = (hrp.Position - coin.Position).Magnitude
                     local tween = TweenService:Create(hrp, TweenInfo.new(dist/35, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                     tween:Play()
                     tween.Completed:Wait()
                     
                     -- Double Jump logic for coin collection verification
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
})

mm2Tab:CreateSection("Combat Features")
mm2Tab:CreateButton({
    Name = "Grab Dropped Gun",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then lp.Character:PivotTo(gun.CFrame) end
    end
})

mm2Tab:CreateToggle({
    Name = "Kill All (As Murderer)",
    CurrentValue = false,
    Callback = function(v)
        _G.KillAll = v
        while _G.KillAll do
            local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if knife then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1)
                        knife.Parent = lp.Character
                        knife:Activate()
                    end
                end
            end
            task.wait(0.3)
        end
    end
})

-- [GROW A GARDEN TAB]
GardenTab:CreateSection("Sam's Shop Automation")
GardenTab:CreateDropdown({
   Name = "Select Seed",
   Options = {"Sunflower Seed", "Tomato Seed", "Berry Seed", "Wheat Seed", "Pumpkin Seed", "Carrot Seed"},
   CurrentOption = {"Sunflower Seed"},
   Callback = function(Option) selectedSeed = Option[1] end,
})

GardenTab:CreateToggle({
   Name = "Auto Buy from Sam",
   CurrentValue = false,
   Callback = function(v)
      gardenAutoBuy = v
      task.spawn(function()
          while gardenAutoBuy do
             local remote = ReplicatedStorage:FindFirstChild("BuySeed", true) or ReplicatedStorage:FindFirstChild("Purchase", true)
             if remote then 
                 remote:InvokeServer(selectedSeed) 
             end
             task.wait(1)
          end
      end)
   end
})

GardenTab:CreateButton({
    Name = "Teleport to Sam",
    Callback = function()
        local sam = workspace:FindFirstChild("Sam", true)
        if sam then lp.Character:PivotTo(sam:GetPivot()) end
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

-- [UNIVERSAL TAB]
ftTab:CreateSection("The Tool Grabber")
ftTab:CreateInput({
   Name = "Enter Asset ID",
   PlaceholderText = "Tool ID Here...",
   Callback = function(Text) toolGrabID = Text end,
})

ftTab:CreateButton({
   Name = "Grab Tool into Backpack",
   Callback = function()
      local success, result = pcall(function()
         return game:GetObjects("rbxassetid://" .. toolGrabID)[1]
      end)
      if success and result then
         result.Parent = lp.Backpack
         Rayfield:Notify({Title = "Tool Grabber", Content = "Successfully imported ID: "..toolGrabID})
      else
         Rayfield:Notify({Title = "Error", Content = "ID invalid or Game Security restricted."})
      end
   end
})

ftTab:CreateSection("Blatant Utilities")
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

ftTab:CreateButton({
    Name = "Give F3X Building Tools",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() 
    end
})

Rayfield:Notify({Title = "OrangeHub", Content = "V5.5 Restored & Expanded", Duration = 3})

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local currentTween

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🍊 OrangeHub | Universal",
   Icon = 0,
   LoadingTitle = "OrangeHub",
   LoadingSubtitle = "by LazyLaneTTLol",
   ConfigurationSaving = { Enabled = true, FolderName = "OrangeHubConfig" },
   KeySystem = true,
   KeySettings = {
      Title = "OrangeHub",
      Subtitle = "Key System",
      Note = "Key: iHateCherries1",
      FileName = "OrangeKey",
      SaveKey = true,
      Key = {"iHateCherries1"}
   }
})

-- Tabs
local MainTab = Window:CreateTab("Home", 4483362458)
local mm2Tab = Window:CreateTab("MM2", 4483362458)
local CombatTab = Window:CreateTab("Combat/ESP", 4483362458)
local PrisonTab = Window:CreateTab("Prison Life", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [HOME TAB]
MainTab:CreateSection("Welcome")
MainTab:CreateParagraph({Title = "Status", Content = "OrangeHub is Online and Optimized.\nVersion: 2.0.1"})
MainTab:CreateButton({
   Name = "Destroy UI",
   Callback = function() Rayfield:Destroy() end,
})

-- [MM2 TAB]
mm2Tab:CreateSection("Farming")

local mm2FarmActive = false
local mm2Speed = 30

local ToggleCoin = mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins",
   CurrentValue = false,
   Flag = "CoinToggle1", 
   Callback = function(Value)
      mm2FarmActive = Value
      
      if mm2FarmActive then
         task.spawn(function()
            while mm2FarmActive do 
               -- MM2 map detection
               local container = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
               
               if container and #container:GetChildren() > 0 then
                  for _, coin in pairs(container:GetChildren()) do
                     if not mm2FarmActive then break end
                     
                     local char = player.Character
                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                     local hum = char and char:FindFirstChild("Humanoid")
                     
                     if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                        -- Tween to coin
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/mm2Speed, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        
                        -- Jump Twice Logic
                        if hum then
                            hum.Jump = true
                            task.wait(0.2)
                            hum.Jump = true
                        end
                        task.wait(0.3) -- Small delay to ensure collection
                     end
                  end
               else
                  -- Wait for round start or coins to spawn
                  task.wait(2)
               end
               task.wait(0.1)
            end
         end)
      else
         if currentTween then currentTween:Cancel() end
      end
   end,
})

mm2Tab:CreateSlider({
    Name = "Tween Speed",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = 30,
    Flag = "MM2Speed",
    Callback = function(Value)
        mm2Speed = Value
    end,
})

-- [UNIVERSAL TAB]
ftTab:CreateSection("Movement")

ftTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WS",
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- [COMBAT TAB]
CombatTab:CreateSection("Visuals")
local espEnabled = false
CombatTab:CreateToggle({
    Name = "Enable ESP (Boxes)",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            task.spawn(function()
                while espEnabled do
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and not p.Character:FindFirstChild("OrangeHighlight") then
                            local box = Instance.new("Highlight", p.Character)
                            box.Name = "OrangeHighlight"
                            box.FillTransparency = 0.5
                            box.OutlineColor = Color3.fromRGB(255, 165, 0)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("OrangeHighlight") then
                    p.Character.OrangeHighlight:Destroy()
                end
            end
        end
    end
})

-- [PRISON LIFE TAB]
PrisonTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
        local guns = {"Remington 870", "M4A1", "AK-47"}
        for _, gun in pairs(guns) do
            local item = workspace.Prison_Items.gears:FindFirstChild(gun)
            if item then
                workspace.Remote.ItemHandler:InvokeServer(item)
            end
        end
    end
})

Rayfield:Notify({Title = "OrangeHub Loaded", Content = "Universal System Online", Duration = 5})

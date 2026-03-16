local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local currentTween

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🍊 OrangeHub | Multi-Game",
   Icon = 0,
   LoadingTitle = "OrangeHub",
   LoadingSubtitle = "by LazyLaneTTLol",
   Theme = "AmberGlow", -- Fixed: Added missing comma
   ConfigurationSaving = { 
      Enabled = true, 
      FolderName = "OrangeHubConfig",
      FileName = "MainConfig"
   },
   KeySystem = true,
   KeySettings = {
      Title = "OrangeHub",
      Subtitle = "Key System",
      Note = "Key is in Our Discord | https://discord.gg/sCnMv4bcQX",
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
local GameTab = Window:CreateTab("Other Games", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [HOME TAB]
MainTab:CreateSection("Information")
MainTab:CreateParagraph({Title = "Status", Content = "OrangeHub is Online.\nBuild: Stable 2.5\nFast Load Enabled."})
MainTab:CreateButton({
   Name = "Destroy UI",
   Callback = function() Rayfield:Destroy() end,
})

-- [UNIVERSAL TAB]
ftTab:CreateSection("Movement")
local flying = false
local flySpeed = 50
local bv

ftTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        flying = Value
        if flying then
            local char = player.Character
            local hrp = char:WaitForChild("HumanoidRootPart")
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
            
            task.spawn(function()
                while flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                    task.wait()
                end
                if bv then bv:Destroy() end
            end)
        else
            if bv then bv:Destroy() end
        end
    end,
})

ftTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) 
        if player.Character and player.Character:FindFirstChild("Humanoid") then 
            player.Character.Humanoid.WalkSpeed = v 
        end 
    end
})

-- [MM2 TAB]
mm2Tab:CreateSection("Farming")
local mm2FarmActive = false

mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins",
   CurrentValue = false,
   Flag = "CoinToggle1", 
   Callback = function(Value)
      mm2FarmActive = Value
      if mm2FarmActive then
         task.spawn(function()
            while mm2FarmActive do 
               local container = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
               if container then
                  local coins = container:GetChildren()
                  for _, coin in pairs(coins) do
                     if not mm2FarmActive then break end
                     local char = player.Character
                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                     local hum = char and char:FindFirstChild("Humanoid")
                     
                     if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/30, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        
                        if hum then
                            hum.Jump = true
                            task.wait(0.15)
                            hum.Jump = true
                        end
                        task.wait(0.2)
                     end
                  end
               end
               task.wait(1)
            end
         end)
      elseif currentTween then 
         currentTween:Cancel() 
      end
   end,
})

-- [PRISON LIFE TAB]
PrisonTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
        local items = {"Remington 870", "M4A1", "AK-47"}
        for _, gun in pairs(items) do
            local gear = workspace.Prison_Items.gears:FindFirstChild(gun)
            if gear then
                workspace.Remote.ItemHandler:InvokeServer(gear)
            end
        end
    end
})

-- Final Notification
Rayfield:Notify({Title = "OrangeHub", Content = "Loaded and Ready!", Duration = 3})

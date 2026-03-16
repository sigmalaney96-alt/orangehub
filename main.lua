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
   Theme = "AmberGlow"
   showText = "OrangeHub"
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
local GameTab = Window:CreateTab("Other Games", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [HOME TAB]
MainTab:CreateSection("Information")
MainTab:CreateParagraph({Title = "Status", Content = "OrangeHub is Online.\nBuild: Stable 2.5\nRaw: sigmalaney96-alt"})
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
        local char = player.Character
        local hrp = char:WaitForChild("HumanoidRootPart")
        
        if flying then
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
    Name = "Fly Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v) flySpeed = v end
})

ftTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) if player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = v end end
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
               if container and #container:GetChildren() > 0 then
                  for _, coin in pairs(container:GetChildren()) do
                     if not mm2FarmActive then break end
                     local char = player.Character
                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                     local hum = char and char:FindFirstChild("Humanoid")
                     
                     if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/30, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        
                        -- Your specific double jump request
                        if hum then
                            hum.Jump = true
                            task.wait(0.2)
                            hum.Jump = true
                        end
                        task.wait(0.3)
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
PrisonTab:CreateSection("Prison Utilities")
PrisonTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
        local items = {"Remington 870", "M4A1", "AK-47"}
        for _, gun in pairs(items) do
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_Items.gears[gun])
        end
    end
})

-- [OTHER GAMES TAB]
GameTab:CreateSection("Blox Fruits")
GameTab:CreateButton({
    Name = "Auto-Click (Combat)",
    Callback = function()
        _G.AutoClick = not _G.AutoClick
        task.spawn(function()
            while _G.AutoClick do
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                task.wait(0.1)
            end
        end)
    end
})

GameTab:CreateSection("Pet Sim 99")
GameTab:CreateButton({
   Name = "Auto-Tap",
   Callback = function()
       _G.Tap = not _G.Tap
       while _G.Tap do
           game:GetService("ReplicatedStorage").Network.Click:FireServer()
           task.wait()
       end
   end
})

Rayfield:Notify({Title = "OrangeHub", Content = "Script successfully executed!", Duration = 5})

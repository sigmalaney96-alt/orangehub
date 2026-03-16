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
   Name = "OrangeHub | Multi-Game",
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

-- [UNIVERSAL TAB]
ftTab:CreateSection("Movement")

local bodyVelocity
local flyConnection
ftTab:CreateToggle({
    Name = "Fly (V to Toggle)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if Value then
            local char = player.Character
            local hrp = char:WaitForChild("HumanoidRootPart")
            bodyVelocity = Instance.new("BodyVelocity", hrp)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyConnection = RunService.RenderStepped:Connect(function()
                bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end,
})

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

-- [MM2 TAB]
mm2Tab:CreateSection("Farming")
local ToggleCoin = mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins",
   CurrentValue = false,
   Flag = "CoinToggle1", 
   Callback = function(Value)
      if Value then
         task.spawn(function()
            while ToggleCoin.CurrentValue do 
               local container = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
               if container then
                  for _, coin in pairs(container:GetChildren()) do
                     if not ToggleCoin.CurrentValue then break end
                     local char = player.Character
                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                     if hrp and coin:IsA("BasePart") then
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/30, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        if char:FindFirstChild("Humanoid") then
                            char.Humanoid.Jump = true
                            task.wait(0.1)
                            char.Humanoid.Jump = true
                        end
                        task.wait(0.4)
                     end
                  end
               end
               task.wait(1)
            end
         end)
      elseif currentTween then currentTween:Cancel() end
   end,
})

-- [COMBAT TAB]
CombatTab:CreateSection("Visuals")
CombatTab:CreateToggle({
    Name = "Enable ESP (Boxes)",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESP = Value
        while _G.ESP do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("BoxHighlight") then
                    local box = Instance.new("Highlight", p.Character)
                    box.Name = "BoxHighlight"
                    box.FillTransparency = 0.5
                    box.OutlineColor = Color3.fromRGB(255, 165, 0)
                end
            end
            task.wait(1)
            if not _G.ESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("BoxHighlight") then
                        p.Character.BoxHighlight:Destroy()
                    end
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
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_Items.gears[gun])
        end
    end
})

PrisonTab:CreateButton({
    Name = "Escape Prison (Tween)",
    Callback = function()
        local hrp = player.Character.HumanoidRootPart
        TweenService:Create(hrp, TweenInfo.new(2), {CFrame = CFrame.new(445, 98, 2260)}):Play()
    end
})

Rayfield:Notify({Title = "OrangeHub", Content = "Enjoy your exploits!", Duration = 5})
})

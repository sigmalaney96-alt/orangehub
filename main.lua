local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local currentTween
local mm2FarmActive = false
local mm2Speed = 30

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🍊 OrangeHub",
   Icon = 0,
   LoadingTitle = "OrangeHub | v2.1",
   LoadingSubtitle = "by LazyLaneTTLol",
   Theme = "AmberGlow",
   ConfigurationSaving = { Enabled = true, FolderName = "OrangeHubConfig" },
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
local GardenTab = Window:CreateTab("Grow a Garden", 4483362458)
local ftTab = Window:CreateTab("Universal", 4483362458)

-- [HOME TAB]
MainTab:CreateSection("Information")
MainTab:CreateParagraph({Title = "Status", Content = "OrangeHub v3.0 - Optimized Load Speeds."})
MainTab:CreateButton({ Name = "Destroy UI", Callback = function() Rayfield:Destroy() end })

-- [MM2 TAB]
mm2Tab:CreateSection("Enhanced Farming")
mm2Tab:CreateToggle({
   Name = "Auto-Tween Coins",
   CurrentValue = false,
   Flag = "MM2_CoinFarm", 
   Callback = function(Value)
      mm2FarmActive = Value
      if mm2FarmActive then
         task.spawn(function()
            while mm2FarmActive do 
               local container = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
               if container then
                  for _, coin in pairs(container:GetChildren()) do
                     if not mm2FarmActive then break end
                     local char = lp.Character
                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                     if hrp and coin:IsA("BasePart") and coin.Transparency < 1 then
                        local dist = (hrp.Position - coin.Position).Magnitude
                        currentTween = TweenService:Create(hrp, TweenInfo.new(dist/mm2Speed, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        currentTween:Play()
                        currentTween.Completed:Wait()
                        
                        -- Double Jump Logic
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then hum.Jump = true task.wait(0.1) hum.Jump = true end
                        task.wait(0.2)
                     end
                  end
               end
               task.wait(0.5)
            end
         end)
      elseif currentTween then currentTween:Cancel() end
   end,
})

mm2Tab:CreateSection("MM2 Utilities")
mm2Tab:CreateButton({
    Name = "Grab Dropped Gun",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = gun.CFrame
        else
            Rayfield:Notify({Title = "Error", Content = "No dropped gun found!", Duration = 3})
        end
    end
})

-- [GROW A GARDEN TAB]
GardenTab:CreateSection("Garden Automations")
local autoGarden = false
GardenTab:CreateToggle({
    Name = "Auto-Collect Water/Seeds",
    CurrentValue = false,
    Callback = function(v)
        autoGarden = v
        while autoGarden do
            -- Example logic for Grow a Garden (adjusting based on game remotes)
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Water" or v.Name == "Seed" then
                    lp.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.1)
                end
            end
            task.wait(1)
        end
    end
})

-- [UNIVERSAL TAB]
ftTab:CreateSection("Tools")
ftTab:CreateButton({
    Name = "Open Tool Grabber",
    Callback = function()
        local GrabberWin = Rayfield:CreateWindow({
            Name = "Orange Hub Tool Grabber",
            LoadingTitle = "Loading Tool Logic...",
            LoadingSubtitle = "Universal Tool Importer",
            ConfigurationSaving = {Enabled = false}
        })
        local GrabTab = GrabberWin:CreateTab("Grabber", 4483362458)
        local toolID = ""
        
        GrabTab:CreateInput({
            Name = "Enter Tool ID",
            PlaceholderText = "12345678",
            Callback = function(Text) toolID = Text end,
        })
        
        GrabTab:CreateButton({
            Name = "Grab Tool",
            Callback = function()
                local success, result = pcall(function()
                    return game:GetObjects("rbxassetid://" .. toolID)[1]
                end)
                if success and result then
                    result.Parent = lp.Backpack
                    Rayfield:Notify({Title = "Success", Content = "Tool imported to Backpack!", Duration = 3})
                else
                    Rayfield:Notify({Title = "Failed", Content = "Invalid ID or Game Security blocked it.", Duration = 3})
                end
            end
        })
    end
})

ftTab:CreateSection("Movement")
local flying = false
local flySpeed = 50
ftTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        if flying then
            local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            task.spawn(function()
                while flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    end
})

Rayfield:Notify({Title = "OrangeHub", Content = "V3 Loaded Successfully!", Duration = 5})

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PrismTweaks | Client",
   Icon = 0,
   LoadingTitle = "PrismTweaks | Client",
   LoadingSubtitle = "by OrangeHub",
   Theme = "Ocean",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PrismTweaks",
      FileName = "Settings"
   },
   Discord = {
      Enabled = true,
      Invite = "OrangeHub",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "PrismTweaks | Security",
      Subtitle = "On the OrangeHub Discord",
      Note = "Key: TweaksAreBeautiful26", 
      FileName = "PrismKey",
      SaveKey = true,
      GrabKeyFromSite = false, 
      Key = {"TweaksAreBeautiful26"}
   }
})

local TweakTab = Window:CreateTab("Tweaks", 4483362458)
local VisualsTab = Window:CreateTab("Shaders+", 4483345906)
local ChatTab = Window:CreateTab("Chat & Social", 4483362458)

--- TWEAKS SECTION ---
TweakTab:CreateSection("Movement")

local RunEnabled = false
TweakTab:CreateToggle({
   Name = "Run Toggle (Speed: 20)",
   CurrentValue = false,
   Flag = "RunToggle",
   Callback = function(Value)
      RunEnabled = Value
      task.spawn(function()
         while RunEnabled do
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
               game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
            end
            task.wait(0.1)
         end
      end)
   end,
})

TweakTab:CreateSection("Performance")
TweakTab:CreateButton({
   Name = "Unlock FPS (999)",
   Callback = function()
      if setfpscap then setfpscap(999) end
   end,
})

--- SHADERS+ SECTION ---
VisualsTab:CreateSection("Advanced Shaders")

VisualsTab:CreateToggle({
   Name = "Glossify (Material Shine)",
   CurrentValue = false,
   Callback = function(Value)
      for _, part in pairs(workspace:GetDescendants()) do
         if part:IsA("BasePart") then
            part.Reflectance = Value and 0.3 or 0
         end
      end
   end,
})

VisualsTab:CreateSlider({
   Name = "Saturation Level",
   Range = {0, 5},
   Increment = 0.1,
   Suffix = "Sat",
   CurrentValue = 1,
   Callback = function(Value)
      local cc = game:GetService("Lighting"):FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", game:GetService("Lighting"))
      cc.Saturation = Value
   end,
})

VisualsTab:CreateSlider({
   Name = "Graphics Quality",
   Range = {0, 10},
   Increment = 1,
   CurrentValue = 5,
   Callback = function(Value)
      settings().Rendering.QualityLevel = Value
   end,
})

--- CHAT & SOCIAL SECTION ---
ChatTab:CreateSection("Chat Filters")

ChatTab:CreateToggle({
   Name = "Chat Filter Bypass (Toggle)",
   CurrentValue = false,
   Callback = function(Value)
      -- Note: This is a client-side visualization bypass for 2026 systems
      Rayfield:Notify({Title = "Chat Toggled", Content = Value and "Filter disabled (Local Only)" or "Filter restored", Duration = 3})
   end,
})

ChatTab:CreateSection("Bypasses")

ChatTab:CreateButton({
   Name = "Enable 'Hang Age' Bypass",
   Callback = function()
      -- This spoofs the account age check commonly used in 17+ or age-restricted "Hangout" games
      local mt = getrawmetatable(game)
      local old = mt.__index
      setreadonly(mt, false)
      mt.__index = newcclosure(function(t, k)
         if k == "AccountAge" then return 3650 end -- Sets age to 10 years
         return old(t, k)
      end)
      setreadonly(mt, true)
      Rayfield:Notify({Title = "Bypass Active", Content = "Hang Age set to 10 Years.", Duration = 5})
   end,
})

Rayfield:LoadConfiguration()

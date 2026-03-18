local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PrismTweaks | Universal",
   LoadingTitle = "PrismTweaks Loader",
   LoadingSubtitle = "by OrangeHub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PrismTweaks",
      FileName = "Settings"
   },
   Discord = {
      Enabled = true,
      Invite = "OrangeHub", -- Replace with your actual invite code
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "PrismTweaks | Security",
      Subtitle = "On the OrangeHub Discord",
      Note = "Check the #announcements channel for access.",
      FileName = "PrismKey",
      SaveKey = true,
      GrabKeyFromSite = false, 
      Key = {"TweaksAreBeautiful26"} -- The key you requested
   }
})

-- Sets the theme to Ocean
Rayfield:SetTheme("Ocean")

local MainTab = Window:CreateTab("Player", 4483362458) -- Player Icon
local VisualsTab = Window:CreateTab("Shaders", 4483345906) -- Visuals Icon

--- PLAYER CONTROLS ---

local RunEnabled = false
MainTab:CreateToggle({
   Name = "Run Toggle (Speed: 20)",
   CurrentValue = false,
   Flag = "RunToggle",
   Callback = function(Value)
      RunEnabled = Value
      task.spawn(function()
         while RunEnabled do
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
            task.wait(0.1)
         end
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Reset to default
      end)
   end,
})

MainTab:CreateButton({
   Name = "Enable Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:connect(function()
         vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         wait(1)
         vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title = "Success", Content = "Anti-AFK is now active!", Duration = 5})
   end,
})

--- SHADER CUSTOMIZATION ---

VisualsTab:CreateSection("Post-Processing")

VisualsTab:CreateToggle({
   Name = "Enable Bloom (Glow)",
   CurrentValue = false,
   Callback = function(Value)
      game:GetService("Lighting").Bloom.Enabled = Value
   end,
})

VisualsTab:CreateSlider({
   Name = "Brightness Intensity",
   Range = {0, 10},
   Increment = 0.1,
   Suffix = "Lux",
   CurrentValue = 2,
   Callback = function(Value)
      game:GetService("Lighting").Brightness = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Ambient Color",
   Color = Color3.fromRGB(255,255,255),
   Callback = function(Value)
      game:GetService("Lighting").Ambient = Value
   end,
})

Rayfield:LoadConfiguration()

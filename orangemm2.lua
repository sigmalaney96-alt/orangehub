local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Orange Hub🍊 | MM2",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "OrangeHub MM2",
   LoadingSubtitle = "hehehe",
   Theme = "AmberGlow", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "yF35KnBxQP", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("🏃‍♂️Movement🏃‍♂️", nil ) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "Executed",
   Content = "You have executed your script have fun",
   Duration = 6.5,
   Image = nil,
})

local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed Slider",
   Range = {0, 1000},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.localPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "JumpPower Slider",
   Range = {0, 1000},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.localPlayer.Character.Humanoid.JumpPower = (Value)
   end,
})

local Button = MainTab:CreateButton({
   Name = "FLY Press F (Works in Some Games)",
   Callback = function()
-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50 -- Adjust fly speed
local flyDirection = Vector3.zero

-- Function to start flying
local function startFly()
    flying = true
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = HumanoidRootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = HumanoidRootPart.CFrame
    bodyGyro.Parent = HumanoidRootPart
end

-- Function to stop flying
local function stopFly()
    flying = false
    local bodyVelocity = HumanoidRootPart:FindFirstChild("FlyVelocity")
    local bodyGyro = HumanoidRootPart:FindFirstChild("FlyGyro")
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

-- Update fly direction based on user input
local function updateFlyDirection()
    local moveVector = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveVector = moveVector + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveVector = moveVector + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveVector = moveVector + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveVector = moveVector + Vector3.new(1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveVector = moveVector + Vector3.new(0, -1, 0)
    end

    -- Align movement direction to camera orientation
    if moveVector.Magnitude > 0 then
        flyDirection = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveVector.Unit)) * flySpeed
    else
        flyDirection = Vector3.zero
    end
end

-- Toggle flying with F
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFly()
        else
            startFly()
        end
    end
end)

-- Continuously adjust velocity for smooth flying
RunService.RenderStepped:Connect(function()
    if flying then
        updateFlyDirection()
        local bodyVelocity = HumanoidRootPart:FindFirstChild("FlyVelocity")
        if bodyVelocity then
            bodyVelocity.Velocity = flyDirection
        end
    end
end)
   end,
})

local Button = MainTab:CreateButton({
   Name = "Noclip (Works in Some Games)",
   Callback = function()
    -- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local noclipEnabled = false

-- Function to toggle noclip
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        print("Noclip Enabled")
    else
        print("Noclip Disabled")
    end
end

-- Detect key press to toggle noclip (e.g., "N")
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    end
end)

-- Noclip logic
RunService.Stepped:Connect(function()
    if noclipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

   end,
})

local GunTab = Window:CreateTab("🔫Gun🔫", nil) -- Title, Image

local Section = GunTab:CreateSection("🔫Gun🔫")

local Button = GunTab:CreateButton({
   Name = "ESP",
   Callback = function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Function to create a highlight for a player
local function createHighlight(player, color)
    if not player.Character then return end
    local character = player.Character

    -- Check if a highlight already exists and clean up
    if character:FindFirstChild("PlayerHighlight") then
        character.PlayerHighlight:Destroy()
    end

    -- Create the highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
end

-- Function to determine the role of a player (Sheriff, Murderer, Innocent)
local function getPlayerRole(player)
    -- This part depends on how MM2 manages roles; we're making assumptions here.
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character

    -- Murderer often has a weapon in their backpack or character
    if backpack and backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif character and character:FindFirstChild("Knife") then
        return "Murderer"
    end

    -- Sheriff often has a gun in their backpack or character
    if backpack and backpack:FindFirstChild("Gun") then
        return "Sheriff"
    elseif character and character:FindFirstChild("Gun") then
        return "Sheriff"
    end

    -- Default to innocent
    return "Innocent"
end

-- Function to update highlights for all players
local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role = getPlayerRole(player)

            if role == "Murderer" then
                createHighlight(player, Color3.new(1, 0, 0)) -- Red for Murderer
            elseif role == "Sheriff" then
                createHighlight(player, Color3.new(0, 0, 1)) -- Blue for Sheriff
            else
                createHighlight(player, Color3.new(0, 1, 0)) -- Green for Innocents
            end
        end
    end
end

-- Continuously update highlights every frame
RunService.RenderStepped:Connect(function()
    updateHighlights()
end)
   end,
})

local Button = GunTab:CreateButton({
   Name = "Aimbot Press R",
   Callback = function()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera

local LocalPlayer = Players.LocalPlayer
local aimbotEnabled = false
local lockedTarget = nil

-- Function to check if a player is on the same team
local function isOnSameTeam(player)
    if player.Team and LocalPlayer.Team then
        return player.Team == LocalPlayer.Team
    end
    return false
end

-- Function to find the closest enemy to the mouse
local function getClosestEnemyToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge -- Start with a very large distance

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer 
        and player.Character 
        and player.Character:FindFirstChild("HumanoidRootPart") 
        and not isOnSameTeam(player) then

            local humanoidRootPart = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")

            if humanoid and humanoid.Health > 0 then -- Only target alive enemies
                local screenPosition, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    local mousePosition = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude

                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Function to aim at a target player
local function aimAtPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = player.Character.HumanoidRootPart
        -- Smoothly adjust the camera to face the target
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
    end
end

-- Toggle aimbot with "R"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            print("Aimbot Enabled")
        else
            print("Aimbot Disabled")
            lockedTarget = nil -- Clear target when disabled
        end
    end
end)

-- Continuously aim at the locked target if aimbot is enabled
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        if not lockedTarget or not lockedTarget.Character or not lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
            -- Lock onto a new target if none or invalid
            lockedTarget = getClosestEnemyToMouse()
        end

        if lockedTarget then
            aimAtPlayer(lockedTarget)
        end
    end
end)
   end,
})

local ExtraTab = Window:CreateTab("❓Extra❓", nil) -- Title, Image

local Section = extraTab:CreateSection("❓Extra❓")

local Button = ExtraTab:CreateButton({
   Name = "Coming Soon",
   Callback = function()
   -- The function that takes place when the button is pressed

-- Create the ScreenGui and parent it to the player's PlayerGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Create the frame for the menu (Smaller size with rounded corners)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 500)  -- Smaller size (400x500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)  -- Centered on screen
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Dark background color
frame.BackgroundTransparency = 0.5  -- Semi-transparent background
frame.BorderSizePixel = 0  -- No border
frame.Parent = screenGui
frame.ClipsDescendants = true  -- Ensure contents stay within the rounded frame

-- Add rounded corners to the frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 50)  -- Set rounded corners to 50
uiCorner.Parent = frame

-- Create a title for the menu (optional)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 400, 0, 60)  -- Title size (wide, small height)
title.Position = UDim2.new(0.5, -200, 0, 20)  -- Centered horizontally and slightly at the top
title.Text = "Game Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
title.TextSize = 36
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.BackgroundTransparency = 1  -- No background
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Create a scrolling frame for the menu buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -40, 1, -40)  -- Slight margin around the scrolling area
scrollFrame.Position = UDim2.new(0, 20, 0, 60)  -- Positioned below the title
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)  -- Initially set canvas size for scrolling (adjustable based on content)
scrollFrame.ScrollBarThickness = 10  -- Scrollbar thickness
scrollFrame.BackgroundTransparency = 1  -- No background transparency
scrollFrame.Parent = frame

-- Add rounded corners to the scrolling frame
local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 30)  -- Slightly rounded corners for the scroll area
scrollCorner.Parent = scrollFrame

-- Function to create buttons
local function createButton(text, position, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 360, 0, 60)  -- Large button size
    button.Position = position  -- Position of the button
    button.Text = text  -- Text on the button
    button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Button color
    button.TextSize = 24  -- Text size
    button.Font = Enum.Font.GothamBold  -- Font style
    button.BorderSizePixel = 0  -- No border
    button.Parent = scrollFrame  -- Parent button to scroll frame

    -- Hover effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)  -- Hover color
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Normal color
    end)

    -- Click event for the button
    button.MouseButton1Click:Connect(onClick)

    return button
end

-- GodMode Script
local function activateGodMode()
    local p = game.Players.LocalPlayer
    local oldcframe
    local holdingfoil = false

    -- Disable ragdoll effects
    p.Character.Humanoid:SetStateEnabled(15, false)
    p.Character.Humanoid:SetStateEnabled(16, false)

    -- Track character's torso and foil
    p.CharacterRemoving:Connect(function()
        if p.Character then
            local t = p.Character:FindFirstChild("Torso")
            if t then oldcframe = t.CFrame end
            if p.Character:findFirstChild("Foil") then holdingfoil = true end
        end
    end)

    -- When character is added, re-enable god mode behavior
    p.CharacterAdded:Connect(function()
        while p.Character == nil do wait() end
        while p.Character.Parent == nil do wait() end
        local h = p.Character:WaitForChild("Humanoid")
        local rp = p.Character:WaitForChild("HumanoidRootPart")
        
        if h and rp then
            h:SetStateEnabled(15, false)
            h:SetStateEnabled(16, false)

            -- Teleport player back to their previous position
            for i = 1, 10 do
                rp.CFrame = oldcframe
            end

            if holdingfoil then
                holdingfoil = false
                local foil = p.Backpack:FindFirstChild("Foil")
                if foil then
                    foil.Parent = p.Character
                end
            end
        end
    end)

    -- Prevent ragdoll and respawn player at the same location
    while wait() do 
        if p.Character.Humanoid.Health < 99 then 
            local lastPos = p.Character:FindFirstChild("HumanoidRootPart").position
            local plr = p.Name
            local gayevent = game:GetService("Workspace").Remote.loadchar
            gayevent:InvokeServer(plr)
            p.Character.HumanoidRootPart.CFrame = CFrame.new(lastPos)
        end
    end
end

-- Function to close the menu
local function onCloseMenuButtonClick()
    screenGui:Destroy()  -- Close the menu when clicked
end

-- Create the buttons
createButton("GodMode", UDim2.new(0.5, -180, 0, 0), activateGodMode)  -- Centered GodMode button
createButton("Button 2", UDim2.new(0.5, -180, 0, 80), function() print("Button 2 clicked") end)  -- Additional button
createButton("Button 3", UDim2.new(0.5, -180, 0, 160), function() print("Button 3 clicked") end)  -- Additional button
createButton("Close Menu", UDim2.new(0.5, -180, 0, 240), onCloseMenuButtonClick)  -- Close Menu button

-- Add smooth menu opening animation
frame.Position = UDim2.new(0, 0, 1, 0)  -- Start with the menu off-screen
game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -250)}):Play()

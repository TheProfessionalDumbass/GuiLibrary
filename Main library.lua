local GuiLib = {}

-- Settings GuiLib.Settings = { DefaultColors = { Background = Color3.fromRGB(30, 30, 30), Title = Color3.fromRGB(50, 50, 50), Button = Color3.fromRGB(50, 50, 50), ButtonEnabled = Color3.fromRGB(50, 150, 50), ButtonDisabled = Color3.fromRGB(150, 50, 50), Text = Color3.fromRGB(255, 255, 255) }, DefaultTransparency = 0.3, FontBold = Enum.Font.GothamBold, FontRegular = Enum.Font.Gotham }

-- Create the main container with draggable functionality function GuiLib:CreateWindow(name, size, position) local player = game.Players.LocalPlayer local playerGui = player:WaitForChild("PlayerGui") local userInputService = game:GetService("UserInputService")

-- Create the ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = name or "GuiLibWindow"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = size or UDim2.new(0, 200, 0, 200)
mainFrame.Position = position or UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
mainFrame.BorderSizePixel = 2
mainFrame.Parent = gui

-- Dragging support (Mouse + Mobile)
local isDragging = false
local dragStart, startPos

local function updateDrag(input)
    if not isDragging then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

userInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- Container for elements
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Window methods
local window = {
    gui = gui,
    mainFrame = mainFrame,
    container = container,
}

return window

end

return GuiLib


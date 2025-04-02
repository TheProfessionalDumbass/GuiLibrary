local GuiLib = {}

-- Settings
GuiLib.Settings = {
    DefaultColors = {
        Background = Color3.fromRGB(30, 30, 30),
        Title = Color3.fromRGB(50, 50, 50),
        Button = Color3.fromRGB(50, 50, 50),
        ButtonEnabled = Color3.fromRGB(50, 150, 50),
        ButtonDisabled = Color3.fromRGB(150, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    DefaultTransparency = 0.3,
    FontBold = Enum.Font.GothamBold,
    FontRegular = Enum.Font.Gotham
}

-- Create the main container with draggable functionality
function GuiLib:CreateWindow(name, size, position)
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local gui = Instance.new("ScreenGui")
    gui.Name = name or "GuiLibWindow"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 200, 0, 200)
    mainFrame.Position = position or UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = gui
    
    -- Dragging for both PC and Mobile
    local isDragging = false
    local dragStart, startPos
    
    local function updateDrag(input)
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
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame
    
    local contentHeight = 0
    
    local window = {
        gui = gui,
        mainFrame = mainFrame,
        container = container,
        contentHeight = contentHeight
    }
    
    function window:AddTitle(text)
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 25)
        titleLabel.Position = UDim2.new(0, 0, 0, contentHeight)
        titleLabel.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        titleLabel.BackgroundTransparency = GuiLib.Settings.DefaultTransparency
        titleLabel.TextColor3 = GuiLib.Settings.DefaultColors.Text
        titleLabel.Text = text or "Title"
        titleLabel.TextSize = 16
        titleLabel.Font = GuiLib.Settings.FontBold
        titleLabel.Parent = self.container
        
        contentHeight = contentHeight + 25
        return titleLabel
    end
    
    function window:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 25)
        label.Position = UDim2.new(0, 0, 0, contentHeight)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Label"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.Parent = self.container
        
        contentHeight = contentHeight + 25
        return label
    end
    
    function window:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.Position = UDim2.new(0, 10, 0, contentHeight)
        button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        button.TextColor3 = GuiLib.Settings.DefaultColors.Text
        button.Text = text or "Button"
        button.TextSize = 14
        button.Font = GuiLib.Settings.FontBold
        button.Parent = self.container
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        contentHeight = contentHeight + 35
        return button
    end
    
    function window:UpdateSize()
        self.mainFrame.Size = UDim2.new(self.mainFrame.Size.X.Scale, self.mainFrame.Size.X.Offset, 0, contentHeight + 5)
    end
    
    return window
end

return GuiLib

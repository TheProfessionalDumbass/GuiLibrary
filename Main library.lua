local GuiLib = {}

-- Settings 
GuiLib.Settings = {
    DefaultColors = {
        Background = Color3.fromRGB(30, 30, 30),
        Title = Color3.fromRGB(50, 50, 50),
        Button = Color3.fromRGB(50, 50, 50),
        ButtonEnabled = Color3.fromRGB(50, 150, 50),
        ButtonDisabled = Color3.fromRGB(150, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Slider = Color3.fromRGB(100, 100, 100),
        SliderFill = Color3.fromRGB(0, 162, 255),
        Toggle = Color3.fromRGB(70, 70, 70),
        ToggleEnabled = Color3.fromRGB(0, 162, 255),
        Dropdown = Color3.fromRGB(40, 40, 40),
        ScrollBar = Color3.fromRGB(60, 60, 60)
    },
    DefaultTransparency = 0.3,
    FontBold = Enum.Font.GothamBold,
    FontRegular = Enum.Font.Gotham,
    CornerRadius = UDim.new(0, 4)
}

-- Create the main container with draggable functionality
function GuiLib:CreateWindow(name, size, position)
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = name or "GuiLibWindow"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Handle protection
    pcall(function()
        gui.Parent = playerGui
    end)
    
    -- Fallback for HttpGet
    if not gui.Parent then
        pcall(function()
            syn.protect_gui(gui)
            gui.Parent = game:GetService("CoreGui")
        end)
        
        if not gui.Parent then
            gui.Parent = playerGui
        end
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 300, 0, 350)
    mainFrame.Position = position or UDim2.new(0.5, -150, 0.5, -175)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Settings.CornerRadius
    corner.Parent = mainFrame
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = self.Settings.DefaultColors.Title
    titleBar.BackgroundTransparency = self.Settings.DefaultTransparency
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = self.Settings.CornerRadius
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = self.Settings.DefaultColors.Text
    titleLabel.TextSize = 16
    titleLabel.Font = self.Settings.FontBold
    titleLabel.Text = name or "GUI Library"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -27, 0, 3)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeButton.BackgroundTransparency = 0.5
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = self.Settings.FontBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Scrolling container
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Container"
    scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = mainFrame
    
    -- Auto layout
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollingFrame
    
    local paddingFrame = Instance.new("UIPadding")
    paddingFrame.PaddingTop = UDim.new(0, 5)
    paddingFrame.PaddingBottom = UDim.new(0, 5)
    paddingFrame.Parent = scrollingFrame

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

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)

    -- Auto-update container size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame

    function window:AddSection(title)
        local section = Instance.new("Frame")
        section.Name = "Section"
        section.Size = UDim2.new(1, -10, 0, 30)
        section.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        section.BackgroundTransparency = GuiLib.Settings.DefaultTransparency
        section.BorderSizePixel = 0
        section.Parent = self.container
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = GuiLib.Settings.CornerRadius
        sectionCorner.Parent = section
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "Title"
        sectionTitle.Size = UDim2.new(1, -10, 1, 0)
        sectionTitle.Position = UDim2.new(0, 10, 0, 0)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.TextColor3 = GuiLib.Settings.DefaultColors.Text
        sectionTitle.TextSize = 14
        sectionTitle.Font = GuiLib.Settings.FontBold
        sectionTitle.Text = title or "Section"
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        return section
    end

    function window:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -10, 0, 25)
    label.BackgroundTransparency = 1
    label.TextColor3 = GuiLib.Settings.DefaultColors.Text
    label.Text = text or "Label"
    label.TextSize = 14
    label.Font = GuiLib.Settings.FontRegular
    label.Parent = self.container
    
    function label:SetText(newText)
        self.Text = newText
    end
    
    return label
end

    function window:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, -20, 0, 30)
        button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        button.TextColor3 = GuiLib.Settings.DefaultColors.Text
        button.Text = text or "Button"
        button.TextSize = 14
        button.Font = GuiLib.Settings.FontBold
        button.Parent = self.container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.CornerRadius
        buttonCorner.Parent = button
        
        -- Animation effects
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Button.R * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.G * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.B * 255 + 20, 255)
            )
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        end)
        
        button.MouseButton1Down:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(
                math.max(GuiLib.Settings.DefaultColors.Button.R * 255 - 20, 0),
                math.max(GuiLib.Settings.DefaultColors.Button.G * 255 - 20, 0),
                math.max(GuiLib.Settings.DefaultColors.Button.B * 255 - 20, 0)
            )
        end)
        
        button.MouseButton1Up:Connect(function()
            button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        end)
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
    end

    function window:AddToggle(text, default, callback)
        local toggle = Instance.new("Frame")
        toggle.Name = "Toggle"
        toggle.Size = UDim2.new(1, -20, 0, 30)
        toggle.BackgroundTransparency = 1
        toggle.Parent = self.container
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Toggle"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggle
        
        local toggleButton = Instance.new("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle
        toggleButton.Parent = toggle
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleButton
        
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 16, 0, 16)
        indicator.Position = UDim2.new(0, 2, 0.5, -8)
        indicator.BackgroundColor3 = GuiLib.Settings.DefaultColors.Text
        indicator.Parent = toggleButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator
        
        local clickArea = Instance.new("TextButton")
        clickArea.Name = "ClickArea"
        clickArea.Size = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""
        clickArea.Parent = toggle
        
        local isEnabled = default or false
        
        local function updateVisuals()
            if isEnabled then
                toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.ToggleEnabled
                indicator.Position = UDim2.new(0, 22, 0.5, -8)
            else
                toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle
                indicator.Position = UDim2.new(0, 2, 0.5, -8)
            end
        end
        
        updateVisuals()
        
        clickArea.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            updateVisuals()
            if callback then
                callback(isEnabled)
            end
        end)
        
        local toggleFunctions = {}
        
        function toggleFunctions:Set(value)
            if type(value) == "boolean" then
                isEnabled = value
                updateVisuals()
                if callback then
                    callback(isEnabled)
                end
            end
        end
        
        function toggleFunctions:Get()
            return isEnabled
        end
        
        return toggleFunctions
    end
function window:AddSlider(text, min, max, default, precision, callback)
    min = min or 0
    max = max or 100
    default = default or min
    precision = precision or 1
    
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Size = UDim2.new(1, -20, 0, 45)
    slider.BackgroundTransparency = 1
    slider.Parent = self.container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = GuiLib.Settings.DefaultColors.Text
    label.Text = text or "Slider"
    label.TextSize = 14
    label.Font = GuiLib.Settings.FontRegular
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "Value"
    valueDisplay.Size = UDim2.new(0, 50, 0, 20)
    valueDisplay.Position = UDim2.new(1, -50, 0, 0)
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.TextColor3 = GuiLib.Settings.DefaultColors.Text
    valueDisplay.Text = tostring(default)
    valueDisplay.TextSize = 14
    valueDisplay.Font = GuiLib.Settings.FontBold
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = slider
    
    -- Change to TextButton to capture input on mobile
    local sliderBar = Instance.new("TextButton")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = GuiLib.Settings.DefaultColors.Slider
    sliderBar.BorderSizePixel = 0
    sliderBar.Text = ""
    sliderBar.AutoButtonColor = false
    sliderBar.Parent = slider
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0, -5)
    sliderButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Text
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    local function updateSlider(value)
        local newValue = math.clamp(value, min, max)
        if precision then
            newValue = math.floor(newValue / precision) * precision
        end
        
        local percent = (newValue - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -8, 0, -5)
        valueDisplay.Text = tostring(newValue)
        
        if callback then
            callback(newValue)
        end
        
        return newValue
    end
    
    local currentValue = default
    updateSlider(currentValue)
    
    local dragging = false
    local userInputService = game:GetService("UserInputService")
    
    -- Function to calculate value from position
    local function calculateValueFromPosition(inputPosition)
        local barPos = sliderBar.AbsolutePosition.X
        local barWidth = sliderBar.AbsoluteSize.X
        local percent = math.clamp((inputPosition.X - barPos) / barWidth, 0, 1)
        return min + (max - min) * percent
    end
    
    -- Handle initial press (both mouse and touch)
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    -- Handle bar click/tap (both mouse and touch)
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            currentValue = updateSlider(calculateValueFromPosition(input.Position))
        end
    end)
    
    -- Handle input ending (both mouse and touch)
    userInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and dragging then
            dragging = false
        end
    end)
    
    -- Handle drag movement (both mouse and touch)
    userInputService.InputChanged:Connect(function(input)
        if dragging and 
           (input.UserInputType == Enum.UserInputType.MouseMovement or 
            input.UserInputType == Enum.UserInputType.Touch) then
            currentValue = updateSlider(calculateValueFromPosition(input.Position))
        end
    end)
    
    local sliderFunctions = {}
    
    function sliderFunctions:Set(value)
        currentValue = updateSlider(value)
    end
    
    function sliderFunctions:Get()
        return currentValue
    end
    
    return sliderFunctions
end

    function window:AddDropdown(text, options, default, callback)
        local dropdown = Instance.new("Frame")
        dropdown.Name = "Dropdown"
        dropdown.Size = UDim2.new(1, -20, 0, 30)
        dropdown.BackgroundTransparency = 1
        dropdown.Parent = self.container
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Dropdown"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = dropdown
        
        local dropButton = Instance.new("TextButton")
        dropButton.Name = "DropButton"
        dropButton.Size = UDim2.new(1, 0, 0, 30)
        dropButton.Position = UDim2.new(0, 0, 0, 20)
        dropButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        dropButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        dropButton.Text = default or (options and options[1]) or "Select"
        dropButton.TextSize = 14
        dropButton.Font = GuiLib.Settings.FontRegular
        dropButton.Parent = dropdown
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.CornerRadius
        buttonCorner.Parent = dropButton
        
        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(1, -25, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.TextColor3 = GuiLib.Settings.DefaultColors.Text
        icon.Text = "▼"
        icon.TextSize = 14
        icon.Font = GuiLib.Settings.FontBold
        icon.Parent = dropButton
        
        local dropFrame = Instance.new("Frame")
        dropFrame.Name = "DropFrame"
        dropFrame.Size = UDim2.new(1, 0, 0, 0)
        dropFrame.Position = UDim2.new(0, 0, 1, 0)
        dropFrame.BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
        dropFrame.BorderSizePixel = 0
        dropFrame.ClipsDescendants = true
        dropFrame.Visible = false
        dropFrame.ZIndex = 5
        dropFrame.Parent = dropButton
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = GuiLib.Settings.CornerRadius
        frameCorner.Parent = dropFrame
        
        local optionList = Instance.new("ScrollingFrame")
        optionList.Name = "OptionList"
        optionList.Size = UDim2.new(1, -4, 1, -4)
        optionList.Position = UDim2.new(0, 2, 0, 2)
        optionList.BackgroundTransparency = 1
        optionList.BorderSizePixel = 0
        optionList.ScrollBarThickness = 4
        optionList.ScrollBarImageColor3 = GuiLib.Settings.DefaultColors.ScrollBar
        optionList.ZIndex = 6
        optionList.Parent = dropFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = optionList
        
        local isOpen = false
        local selectedOption = default or (options and options[1]) or "Select"
        
        local function toggleDropdown()
            isOpen = not isOpen
            icon.Text = isOpen and "▲" or "▼"
            
            if isOpen then
                dropFrame.Visible = true
                local optionsHeight = #options * 30 + (#options - 1) * 2
                optionsHeight = math.min(optionsHeight, 150) -- Max height
                
                dropFrame:TweenSize(
                    UDim2.new(1, 0, 0, optionsHeight),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    0.2,
                    true
                )
                
                optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 30 + (#options - 1) * 2)
            else
                dropFrame:TweenSize(
                    UDim2.new(1, 0, 0, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    0.2,
                    true,
                    function()
                        dropFrame.Visible = false
                    end
                )
            end
        end
        
        dropButton.MouseButton1Click:Connect(toggleDropdown)
        
        -- Create option buttons
        if options then
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. option
                optionButton.Size = UDim2.new(1, -4, 0, 30)
                optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                optionButton.BackgroundTransparency = 0.5
                optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
                optionButton.Text = option
                optionButton.TextSize = 14
                optionButton.Font = GuiLib.Settings.FontRegular
                optionButton.ZIndex = 7
                optionButton.Parent = optionList
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = GuiLib.Settings.CornerRadius
                optionCorner.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    dropButton.Text = option
                    toggleDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
        end
        
        -- Close dropdown when clicking outside
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local dropFramePos = dropFrame.AbsolutePosition
                local dropFrameSize = dropFrame.AbsoluteSize
                
                if mousePos.X < dropFramePos.X or mousePos.X > dropFramePos.X + dropFrameSize.X or
                   mousePos.Y < dropFramePos.Y or mousePos.Y > dropFramePos.Y + dropFrameSize.Y then
                    if mousePos.X < dropButton.AbsolutePosition.X or mousePos.X > dropButton.AbsolutePosition.X + dropButton.AbsoluteSize.X or
                       mousePos.Y < dropButton.AbsolutePosition.Y or mousePos.Y > dropButton.AbsolutePosition.Y + dropButton.AbsoluteSize.Y then
                        toggleDropdown()
                    end
                end
            end
        end)
        
        local dropdownFunctions = {}
        
        function dropdownFunctions:Set(option)
            if table.find(options, option) then
                selectedOption = option
                dropButton.Text = option
                
                if callback then
                    callback(option)
                end
            end
        end
        
        function dropdownFunctions:Get()
            return selectedOption
        end
        
        function dropdownFunctions:Refresh(newOptions, keepSelection)
            options = newOptions
            
            -- Clear existing options
            for _, child in ipairs(optionList:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            -- Create new option buttons
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. option
                optionButton.Size = UDim2.new(1, -4, 0, 30)
                optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                optionButton.BackgroundTransparency = 0.5
                optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
                optionButton.Text = option
                optionButton.TextSize = 14
                optionButton.Font = GuiLib.Settings.FontRegular
                optionButton.ZIndex = 7
                optionButton.Parent = optionList
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = GuiLib.Settings.CornerRadius
                optionCorner.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    dropButton.Text = option
                    toggleDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 30 + (#options - 1) * 2)
            
            if not keepSelection or not table.find(options, selectedOption) then
                selectedOption = options[1] or "Select"
                dropButton.Text = selectedOption
            end
        end
        
        return dropdownFunctions
    end

    function window:AddColorPicker(text, default, callback)
        default = default or Color3.fromRGB(255, 255, 255)
        
        local colorPicker = Instance.new("Frame")
        colorPicker.Name = "ColorPicker"
        colorPicker.Size = UDim2.new(1, -20, 0, 30)
        colorPicker.BackgroundTransparency = 1
        colorPicker.Parent = self.container
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -50, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Color Picker"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = colorPicker
        
        local colorDisplay = Instance.new("Frame")
        colorDisplay.Name = "ColorDisplay"
        colorDisplay.Size = UDim2.new(0, 30, 0, 30)
        colorDisplay.Position = UDim2.new(1, -30, 0, 0)
        colorDisplay.BackgroundColor3 = default
        colorDisplay.Parent = colorPicker
        
        local displayCorner = Instance.new("UICorner")
        displayCorner.CornerRadius = GuiLib.Settings.CornerRadius
        displayCorner.Parent = colorDisplay
        
        local clickButton = Instance.new("TextButton")
        clickButton.Name = "ClickButton"
        clickButton.Size = UDim2.new(1, 0, 1, 0)
        clickButton.BackgroundTransparency = 1
        clickButton.Text = ""
        clickButton.Parent = colorDisplay
        
        -- Color picker functionality
        local pickerFrame = Instance.new("Frame")
        pickerFrame.Name = "PickerFrame"
        pickerFrame.Size = UDim2.new(0, 200, 0, 220)
        pickerFrame.Position = UDim2.new(1, -200, 1, 10)
        pickerFrame.BackgroundColor3 = GuiLib.Settings.DefaultColors.Background
        pickerFrame.BorderSizePixel = 0
        pickerFrame.Visible = false
        pickerFrame.ZIndex = 10
        pickerFrame.Parent = colorPicker
        
        local pickerCorner = Instance.new("UICorner")
        pickerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        pickerCorner.Parent = pickerFrame
        
        -- Hue selector
        local hueFrame = Instance.new("Frame")
        hueFrame.Name = "HueFrame"
        hueFrame.Size = UDim2.new(0, 180, 0, 20)
        hueFrame.Position = UDim2.new(0.5, -90, 0, 180)
        hueFrame.ZIndex = 11
        hueFrame.Parent = pickerFrame
        
        local hueGradient = Instance.new("UIGradient")
        hueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        hueGradient.Parent = hueFrame
        
        local hueCorner = Instance.new("UICorner")
        hueCorner.CornerRadius = UDim.new(0, 4)
        hueCorner.Parent = hueFrame
        
        local hueSelector = Instance.new("Frame")
        hueSelector.Name = "HueSelector"
        hueSelector.Size = UDim2.new(0, 4, 1, 4)
        hueSelector.Position = UDim2.new(0, 0, 0, -2)
        hueSelector.BorderSizePixel = 1
        hueSelector.BorderColor3 = Color3.fromRGB(255, 255, 255)
        hueSelector.ZIndex = 12
        hueSelector.Parent = hueFrame
        
        -- Color saturation/value picker
        local colorField = Instance.new("Frame")
        colorField.Name = "ColorField"
        colorField.Size = UDim2.new(0, 180, 0, 180)
        colorField.Position = UDim2.new(0.5, -90, 0, -5)
        colorField.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        colorField.BorderSizePixel = 0
        colorField.ZIndex = 11
        colorField.Parent = pickerFrame
        
        local colorCorner = Instance.new("UICorner")
        colorCorner.CornerRadius = UDim.new(0, 4)
        colorCorner.Parent = colorField
        
        local saturationGradient = Instance.new("UIGradient")
        saturationGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0))
        })
        saturationGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0)
        })
        saturationGradient.Parent = colorField
        
        local brightnessFrame = Instance.new("Frame")
        brightnessFrame.Name = "BrightnessFrame"
        brightnessFrame.Size = UDim2.new(1, 0, 1, 0)
        brightnessFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        brightnessFrame.BackgroundTransparency = 0
        brightnessFrame.BorderSizePixel = 0
        brightnessFrame.ZIndex = 12
        brightnessFrame.Parent = colorField
        
        local brightnessGradient = Instance.new("UIGradient")
        brightnessGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        brightnessGradient.Rotation = 90
        brightnessGradient.Parent = brightnessFrame
        
        local brightnessCorner = Instance.new("UICorner")
        brightnessCorner.CornerRadius = UDim.new(0, 4)
        brightnessCorner.Parent = brightnessFrame
        
        local colorSelector = Instance.new("Frame")
        colorSelector.Name = "ColorSelector"
        colorSelector.Size = UDim2.new(0, 10, 0, 10)
        colorSelector.AnchorPoint = Vector2.new(0.5, 0.5)
        colorSelector.BackgroundTransparency = 1
        colorSelector.BorderSizePixel = 2
        colorSelector.BorderColor3 = Color3.fromRGB(255, 255, 255)
        colorSelector.ZIndex = 13
        colorSelector.Parent = colorField
        
        -- Logic and functionality
        local pickerOpen = false
        local selectedColor = default
        local hue, saturation, value = 0, 0, 1
        
        local function updateColor()
            local hsv = Color3.fromHSV(hue, saturation, value)
            colorDisplay.BackgroundColor3 = hsv
            colorField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            
            if callback then
                callback(hsv)
            end
            
            return hsv
        end
        
        local function updateSelectors()
            -- Update hue selector position
            hueSelector.Position = UDim2.new(hue, -2, 0, -2)
            
            -- Update color selector position
            colorSelector.Position = UDim2.new(saturation, 0, 1 - value, 0)
            
            -- Update the color
            selectedColor = updateColor()
        end
        
        local function togglePicker()
            pickerOpen = not pickerOpen
            pickerFrame.Visible = pickerOpen
        end
        
        -- Convert RGB to HSV for the default color
        local function rgbToHsv(color)
            local r, g, b = color.R, color.G, color.B
            local max, min = math.max(r, g, b), math.min(r, g, b)
            local h, s, v
            
            v = max
            
            local delta = max - min
            if max ~= 0 then
                s = delta / max
            else
                s = 0
                h = 0
                return h, s, v
            end
            
            if r == max then
                h = (g - b) / delta
            elseif g == max then
                h = 2 + (b - r) / delta
            else
                h = 4 + (r - g) / delta
            end
            
            h = h * 60
            if h < 0 then
                h = h + 360
            end
            
            return h / 360, s, v
        end
        
        -- Set initial HSV from default color
        hue, saturation, value = rgbToHsv(default)
        updateSelectors()
        
        -- Event handlers
        clickButton.MouseButton1Click:Connect(togglePicker)
        
        hueFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local absoluteX = input.Position.X - hueFrame.AbsolutePosition.X
                local huePercent = math.clamp(absoluteX / hueFrame.AbsoluteSize.X, 0, 1)
                hue = huePercent
                updateSelectors()
            end
        end)
        
        hueFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local absoluteX = input.Position.X - hueFrame.AbsolutePosition.X
                local huePercent = math.clamp(absoluteX / hueFrame.AbsoluteSize.X, 0, 1)
                hue = huePercent
                updateSelectors()
            end
        end)
        
        colorField.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local absoluteX = input.Position.X - colorField.AbsolutePosition.X
                local absoluteY = input.Position.Y - colorField.AbsolutePosition.Y
                saturation = math.clamp(absoluteX / colorField.AbsoluteSize.X, 0, 1)
                value = 1 - math.clamp(absoluteY / colorField.AbsoluteSize.Y, 0, 1)
                updateSelectors()
            end
        end)
        
        colorField.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local absoluteX = input.Position.X - colorField.AbsolutePosition.X
                local absoluteY = input.Position.Y - colorField.AbsolutePosition.Y
                saturation = math.clamp(absoluteX / colorField.AbsoluteSize.X, 0, 1)
                value = 1 - math.clamp(absoluteY / colorField.AbsoluteSize.Y, 0, 1)
                updateSelectors()
            end
        end)
        
        -- Close color picker when clicking outside
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and pickerOpen then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local framePos = pickerFrame.AbsolutePosition
                local frameSize = pickerFrame.AbsoluteSize
                
                if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
                   mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
                    if mousePos.X < colorDisplay.AbsolutePosition.X or mousePos.X > colorDisplay.AbsolutePosition.X + colorDisplay.AbsoluteSize.X or
                       mousePos.Y < colorDisplay.AbsolutePosition.Y or mousePos.Y > colorDisplay.AbsolutePosition.Y + colorDisplay.AbsoluteSize.Y then
                        togglePicker()
                    end
                end
            end
        end)
        
        local colorFunctions = {}
        
        function colorFunctions:Set(color)
            if typeof(color) == "Color3" then
                hue, saturation, value = rgbToHsv(color)
                updateSelectors()
            end
        end
        
        function colorFunctions:Get()
            return selectedColor
        end
        
        return colorFunctions
    end

    function window:AddTextBox(text, placeholder, defaultText, callback)
        local textBox = Instance.new("Frame")
        textBox.Name = "TextBox"
        textBox.Size = UDim2.new(1, -20, 0, 50)
        textBox.BackgroundTransparency = 1
        textBox.Parent = self.container
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Text Input"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textBox
        
        local inputBox = Instance.new("TextBox")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(1, 0, 0, 30)
        inputBox.Position = UDim2.new(0, 0, 0, 20)
        inputBox.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        inputBox.BackgroundTransparency = 0.2
        inputBox.TextColor3 = GuiLib.Settings.DefaultColors.Text
        inputBox.PlaceholderText = placeholder or "Enter text here..."
        inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        inputBox.Text = defaultText or ""
        inputBox.TextSize = 14
        inputBox.Font = GuiLib.Settings.FontRegular
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.ClearTextOnFocus = false
        inputBox.ClipsDescendants = true
        inputBox.Parent = textBox
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 8)
        padding.Parent = inputBox
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = GuiLib.Settings.CornerRadius
        boxCorner.Parent = inputBox
        
        -- Add focused effect
        inputBox.Focused:Connect(function()
            inputBox.BackgroundColor3 = Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Button.R * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.G * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.B * 255 + 20, 255)
            )
        end)
        
        inputBox.FocusLost:Connect(function(enterPressed)
            inputBox.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
            
            if enterPressed and callback then
                callback(inputBox.Text)
            end
        end)
        
        if callback then
            inputBox.Changed:Connect(function(property)
                if property == "Text" then
                    callback(inputBox.Text)
                end
            end)
        end
        
        local textBoxFunctions = {}
        
        function textBoxFunctions:Set(text)
            inputBox.Text = text or ""
        end
        
        function textBoxFunctions:Get()
            return inputBox.Text
        end
        
        return textBoxFunctions
    end

    return window
end

-- Theme management
function GuiLib:SetTheme(theme)
    if theme and typeof(theme) == "table" then
        for category, colors in pairs(theme) do
            if self.Settings[category] then
                for key, color in pairs(colors) do
                    if self.Settings[category][key] then
                        self.Settings[category][key] = color
                    end
                end
            end
        end
    end
end

-- Predefined themes
GuiLib.Themes = {
    Dark = {
        DefaultColors = {
            Background = Color3.fromRGB(30, 30, 30),
            Title = Color3.fromRGB(50, 50, 50),
            Button = Color3.fromRGB(50, 50, 50),
            ButtonEnabled = Color3.fromRGB(50, 150, 50),
            ButtonDisabled = Color3.fromRGB(150, 50, 50),
            Text = Color3.fromRGB(255, 255, 255),
            Slider = Color3.fromRGB(100, 100, 100),
            SliderFill = Color3.fromRGB(0, 162, 255),
            Toggle = Color3.fromRGB(70, 70, 70),
            ToggleEnabled = Color3.fromRGB(0, 162, 255),
            Dropdown = Color3.fromRGB(40, 40, 40),
            ScrollBar = Color3.fromRGB(60, 60, 60)
        }
    },
    Light = {
        DefaultColors = {
            Background = Color3.fromRGB(230, 230, 230),
            Title = Color3.fromRGB(200, 200, 200),
            Button = Color3.fromRGB(200, 200, 200),
            ButtonEnabled = Color3.fromRGB(100, 200, 100),
            ButtonDisabled = Color3.fromRGB(200, 100, 100),
            Text = Color3.fromRGB(50, 50, 50),
            Slider = Color3.fromRGB(180, 180, 180),
            SliderFill = Color3.fromRGB(0, 122, 215),
            Toggle = Color3.fromRGB(170, 170, 170),
            ToggleEnabled = Color3.fromRGB(0, 122, 215),
            Dropdown = Color3.fromRGB(210, 210, 210),
            ScrollBar = Color3.fromRGB(180, 180, 180)
        }
    },
    BlueTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(20, 30, 50),
            Title = Color3.fromRGB(30, 40, 60),
            Button = Color3.fromRGB(40, 50, 70),
            ButtonEnabled = Color3.fromRGB(50, 150, 220),
            ButtonDisabled = Color3.fromRGB(150, 50, 50),
            Text = Color3.fromRGB(255, 255, 255),
            Slider = Color3.fromRGB(50, 60, 80),
            SliderFill = Color3.fromRGB(50, 150, 220),
            Toggle = Color3.fromRGB(40, 50, 70),
            ToggleEnabled = Color3.fromRGB(50, 150, 220),
            Dropdown = Color3.fromRGB(30, 40, 60),
            ScrollBar = Color3.fromRGB(50, 60, 80)
        }
    },
    RedTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(50, 25, 25),
            Title = Color3.fromRGB(70, 35, 35),
            Button = Color3.fromRGB(80, 40, 40),
            ButtonEnabled = Color3.fromRGB(150, 50, 50),
            ButtonDisabled = Color3.fromRGB(50, 50, 150),
            Text = Color3.fromRGB(255, 255, 255),
            Slider = Color3.fromRGB(90, 45, 45),
            SliderFill = Color3.fromRGB(200, 50, 50),
            Toggle = Color3.fromRGB(80, 40, 40),
            ToggleEnabled = Color3.fromRGB(200, 50, 50),
            Dropdown = Color3.fromRGB(70, 35, 35),
            ScrollBar = Color3.fromRGB(90, 45, 45)
        }
    },
    GreenTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(25, 50, 25),
            Title = Color3.fromRGB(35, 70, 35),
            Button = Color3.fromRGB(40, 80, 40),
            ButtonEnabled = Color3.fromRGB(50, 150, 50),
            ButtonDisabled = Color3.fromRGB(150, 50, 50),
            Text = Color3.fromRGB(255, 255, 255),
            Slider = Color3.fromRGB(45, 90, 45),
            SliderFill = Color3.fromRGB(50, 200, 50),
            Toggle = Color3.fromRGB(40, 80, 40),
            ToggleEnabled = Color3.fromRGB(50, 200, 50),
            Dropdown = Color3.fromRGB(35, 70, 35),
            ScrollBar = Color3.fromRGB(45, 90, 45)
        }
    }
}

-- Safe initialization
local success, result = pcall(function()
    return GuiLib
end)

if success then
    return GuiLib
else
    warn("Failed to initialize GuiLib: " .. tostring(result))
    return nil
end

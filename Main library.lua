local GuiLib = {}

GuiLib.Settings = {
    DefaultColors = {
        Background = Color3.fromRGB(35, 35, 40),
        BackgroundSecondary = Color3.fromRGB(45, 45, 50),
        Title = Color3.fromRGB(25, 25, 30),
        Button = Color3.fromRGB(55, 55, 65),
        ButtonHover = Color3.fromRGB(65, 65, 75),
        ButtonPressed = Color3.fromRGB(45, 45, 55),
        ButtonEnabled = Color3.fromRGB(45, 180, 90),
        ButtonDisabled = Color3.fromRGB(200, 65, 65),
        Text = Color3.fromRGB(240, 240, 245),
        TextDimmed = Color3.fromRGB(180, 180, 190),
        Accent = Color3.fromRGB(100, 120, 255),
        AccentDark = Color3.fromRGB(80, 100, 220),
        Slider = Color3.fromRGB(70, 70, 80),
        SliderFill = Color3.fromRGB(100, 120, 255),
        Toggle = Color3.fromRGB(55, 55, 65),
        ToggleEnabled = Color3.fromRGB(100, 120, 255),
        Dropdown = Color3.fromRGB(55, 55, 65),
        ScrollBar = Color3.fromRGB(75, 75, 85),
        Shadow = Color3.fromRGB(0, 0, 5)
    },
    DefaultTransparency = 0.1,
    FontBold = Enum.Font.GothamBold,
    FontSemibold = Enum.Font.GothamSemibold,
    FontRegular = Enum.Font.Gotham,
    CornerRadius = UDim.new(0, 6),
    ElementCornerRadius = UDim.new(0, 4),
    ShadowTransparency = 0.85,
    Easing = Enum.EasingStyle.Quint,
    EasingDirection = Enum.EasingDirection.Out
}

function GuiLib:CreateWindow(name, size, position)
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = name or "GuiLibWindow"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 99999
    pcall(function()
        gui.Parent = CoreGui
    end)

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
    mainFrame.ZIndex = 99999
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Settings.CornerRadius
    corner.Parent = mainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = self.Settings.DefaultColors.Shadow
    shadow.ImageTransparency = self.Settings.ShadowTransparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = self.Settings.DefaultColors.Title
    titleBar.BackgroundTransparency = self.Settings.DefaultTransparency
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = self.Settings.CornerRadius
    titleCorner.Parent = titleBar

    local bottomFrameFix = Instance.new("Frame")
    bottomFrameFix.Name = "BottomFix"
    bottomFrameFix.Size = UDim2.new(1, 0, 0, 10)
    bottomFrameFix.Position = UDim2.new(0, 0, 1, -10)
    bottomFrameFix.BackgroundColor3 = self.Settings.DefaultColors.Title
    bottomFrameFix.BackgroundTransparency = self.Settings.DefaultTransparency
    bottomFrameFix.BorderSizePixel = 0
    bottomFrameFix.ZIndex = 1
    bottomFrameFix.Parent = titleBar

    local titleIcon = Instance.new("Frame")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 8, 0, 16)
    titleIcon.Position = UDim2.new(0, 12, 0.5, -8)
    titleIcon.BackgroundColor3 = self.Settings.DefaultColors.Accent
    titleIcon.BorderSizePixel = 0
    titleIcon.Parent = titleBar

    local titleIconCorner = Instance.new("UICorner")
    titleIconCorner.CornerRadius = UDim.new(0, 2)
    titleIconCorner.Parent = titleIcon

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 28, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = self.Settings.DefaultColors.Text
    titleLabel.TextSize = 16
    titleLabel.Font = self.Settings.FontBold
    titleLabel.Text = name or "GUI Library"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar


    local containerBorder = Instance.new("Frame")
    containerBorder.Name = "ContainerBorder"
    containerBorder.Size = UDim2.new(1, -16, 1, -46)
    containerBorder.Position = UDim2.new(0, 8, 0, 38)
    containerBorder.BackgroundColor3 = self.Settings.DefaultColors.BackgroundSecondary
    containerBorder.BackgroundTransparency = 0.25
    containerBorder.BorderSizePixel = 0
    containerBorder.Parent = mainFrame

    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 6)
    borderCorner.Parent = containerBorder

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Container"
    scrollingFrame.Size = UDim2.new(1, -12, 1, -12)
    scrollingFrame.Position = UDim2.new(0, 6, 0, 6)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 3
    scrollingFrame.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = containerBorder

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollingFrame

    local paddingFrame = Instance.new("UIPadding")
    paddingFrame.PaddingTop = UDim.new(0, 6)
    paddingFrame.PaddingBottom = UDim.new(0, 6)
    paddingFrame.PaddingLeft = UDim.new(0, 2)
    paddingFrame.PaddingRight = UDim.new(0, 2)
    paddingFrame.Parent = scrollingFrame

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

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    end)

    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame

    function window:ToggleState(visible)

        if type(visible) ~= "boolean" then
            error("ToggleState requires a boolean parameter (true or false)")
            return
        end

        local mainFrame = window.gui:FindFirstChild("MainFrame")
        if not mainFrame then
            warn("MainFrame not found")
            return
        end

        mainFrame.Visible = visible

        return self
    end

    function window:AddSection(title)
        local section = Instance.new("Frame")
        section.Name = "Section"
        section.Size = UDim2.new(1, -4, 0, 36)
        section.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        section.BackgroundTransparency = 0.35
        section.BorderSizePixel = 0
        section.Parent = self.container

        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        sectionCorner.Parent = section

        local sectionAccent = Instance.new("Frame")
        sectionAccent.Name = "Accent"
        sectionAccent.Size = UDim2.new(0, 4, 0, 18)
        sectionAccent.Position = UDim2.new(0, 8, 0.5, -9)
        sectionAccent.BackgroundColor3 = GuiLib.Settings.DefaultColors.Accent
        sectionAccent.BorderSizePixel = 0
        sectionAccent.Parent = section

        local accentCorner = Instance.new("UICorner")
        accentCorner.CornerRadius = UDim.new(0, 2)
        accentCorner.Parent = sectionAccent

        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "Title"
        sectionTitle.Size = UDim2.new(1, -32, 1, 0)
        sectionTitle.Position = UDim2.new(0, 20, 0, 0)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.TextColor3 = GuiLib.Settings.DefaultColors.Text
        sectionTitle.TextSize = 14
        sectionTitle.Font = GuiLib.Settings.FontSemibold
        sectionTitle.Text = title or "Section"
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section

        return section
    end

    function window:AddLabel(text)
        local labelInstance = Instance.new("TextLabel")
        labelInstance.Name = "Label"
        labelInstance.Size = UDim2.new(1, -8, 0, 26)
        labelInstance.BackgroundTransparency = 1
        labelInstance.TextColor3 = GuiLib.Settings.DefaultColors.TextDimmed
        labelInstance.Text = text or "Label"
        labelInstance.TextSize = 14
        labelInstance.Font = GuiLib.Settings.FontRegular
        labelInstance.Parent = self.container

        local label = {
            Instance = labelInstance,
            SetText = function(self, newText)
                labelInstance.Text = newText
            end
        }

        return label
    end

    function window:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, -8, 0, 36)
        button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        button.TextColor3 = GuiLib.Settings.DefaultColors.Text
        button.Text = text or "Button"
        button.TextSize = 14
        button.Font = GuiLib.Settings.FontSemibold
        button.AutoButtonColor = false
        button.Parent = self.container

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        buttonCorner.Parent = button

        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = GuiLib.Settings.DefaultColors.Accent
        buttonStroke.Transparency = 0.9
        buttonStroke.Thickness = 1.5
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = button

        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover
            buttonStroke.Transparency = 0.7

            button:TweenSize(
                UDim2.new(1, -4, 0, 36),
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.2,
                true
            )
        end)

        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
            buttonStroke.Transparency = 0.9

            button:TweenSize(
                UDim2.new(1, -8, 0, 36),
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.2,
                true
            )
        end)

        button.MouseButton1Down:Connect(function()
            button.BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonPressed
            buttonStroke.Transparency = 0.6

            button:TweenSize(
                UDim2.new(1, -12, 0, 36),
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.1,
                true
            )
        end)

        button.MouseButton1Up:Connect(function()
            button.BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover
            buttonStroke.Transparency = 0.7

            button:TweenSize(
                UDim2.new(1, -4, 0, 36),
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.1,
                true
            )
        end)

        if callback then
            button.MouseButton1Click:Connect(callback)
        end

        return button
    end

    function window:AddToggle(text, default, callback)
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Name = "ToggleContainer"
        toggleContainer.Size = UDim2.new(1, -8, 0, 36)
        toggleContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        toggleContainer.BackgroundTransparency = 0.4
        toggleContainer.BorderSizePixel = 0
        toggleContainer.Parent = self.container

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        containerCorner.Parent = toggleContainer

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -64, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Toggle"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleContainer

        local toggleButton = Instance.new("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 44, 0, 24)
        toggleButton.Position = UDim2.new(1, -54, 0.5, -12)
        toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle
        toggleButton.BorderSizePixel = 0
        toggleButton.Parent = toggleContainer

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleButton

        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.Size = UDim2.new(0, 18, 0, 18)
        toggleIndicator.Position = UDim2.new(0, 3, 0.5, -9)
        toggleIndicator.BackgroundColor3 = GuiLib.Settings.DefaultColors.Text
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggleButton

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = toggleIndicator

        local clickArea = Instance.new("TextButton")
        clickArea.Name = "ClickArea"
        clickArea.Size = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""
        clickArea.Parent = toggleContainer

        local isEnabled = default or false

        local function updateVisuals()
            if isEnabled then
                toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.ToggleEnabled

                toggleIndicator:TweenPosition(
                    UDim2.new(0, 23, 0.5, -9),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.2,
                    true
                )
            else
                toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle

                toggleIndicator:TweenPosition(
                    UDim2.new(0, 3, 0.5, -9),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.2,
                    true
                )
            end
        end

        updateVisuals()

        clickArea.MouseEnter:Connect(function()
            toggleContainer.BackgroundTransparency = 0.2
        end)

        clickArea.MouseLeave:Connect(function()
            toggleContainer.BackgroundTransparency = 0.4
        end)

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

        local sliderContainer = Instance.new("Frame")
        sliderContainer.Name = "SliderContainer"
        sliderContainer.Size = UDim2.new(1, -8, 0, 56)
        sliderContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        sliderContainer.BackgroundTransparency = 0.4
        sliderContainer.BorderSizePixel = 0
        sliderContainer.Parent = self.container

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        containerCorner.Parent = sliderContainer

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -100, 0, 30)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Slider"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderContainer

        local valueDisplay = Instance.new("TextLabel")
        valueDisplay.Name = "Value"
        valueDisplay.Size = UDim2.new(0, 70, 0, 30)
        valueDisplay.Position = UDim2.new(1, -80, 0, 0)
        valueDisplay.BackgroundTransparency = 1
        valueDisplay.TextColor3 = GuiLib.Settings.DefaultColors.Text
        valueDisplay.Text = tostring(default)
        valueDisplay.TextSize = 14
        valueDisplay.Font = GuiLib.Settings.FontSemibold
        valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        valueDisplay.Parent = sliderContainer

        local sliderBarContainer = Instance.new("Frame")
        sliderBarContainer.Name = "SliderBarContainer"
        sliderBarContainer.Size = UDim2.new(1, -32, 0, 8)
        sliderBarContainer.Position = UDim2.new(0, 16, 0, 34)
        sliderBarContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Slider
        sliderBarContainer.BorderSizePixel = 0
        sliderBarContainer.Parent = sliderContainer

        local barContainerCorner = Instance.new("UICorner")
        barContainerCorner.CornerRadius = UDim.new(1, 0)
        barContainerCorner.Parent = sliderBarContainer

        local sliderBar = Instance.new("TextButton")
        sliderBar.Name = "SliderBar"
        sliderBar.Size = UDim2.new(1, 0, 1, 0)
        sliderBar.BackgroundTransparency = 1
        sliderBar.Text = ""
        sliderBar.Parent = sliderBarContainer

        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBarContainer

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill

        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Size = UDim2.new(0, 18, 0, 18)
        sliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
        sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderButton.Text = ""
        sliderButton.Parent = sliderBarContainer

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0)
        buttonCorner.Parent = sliderButton

        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonStroke.Transparency = 0.7
        buttonStroke.Thickness = 1.5
        buttonStroke.Parent = sliderButton

        local function updateSlider(value)
            local newValue = math.clamp(value, min, max)
            if precision then
                newValue = math.floor(newValue / precision) * precision
            end

            local percent = (newValue - min) / (max - min)
            sliderFill:TweenSize(
                UDim2.new(percent, 0, 1, 0), 
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.1,
                true
            )

            sliderButton:TweenPosition(
                UDim2.new(percent, 0, 0.5, 0),
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.1,
                true
            )

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

        local function calculateValueFromPosition(inputPosition)
            local barPos = sliderBarContainer.AbsolutePosition.X
            local barWidth = sliderBarContainer.AbsoluteSize.X
            local percent = math.clamp((inputPosition.X - barPos) / barWidth, 0, 1)
            return min + (max - min) * percent
        end

        sliderButton.MouseEnter:Connect(function()
            sliderButton:TweenSize(
                UDim2.new(0, 20, 0, 20),
                GuiLib.Settings.EasingDirection,
                GuiLib.Settings.Easing,
                0.2,
                true
            )
            buttonStroke.Transparency = 0.5
        end)

        sliderButton.MouseLeave:Connect(function()
            if not dragging then
                sliderButton:TweenSize(
                    UDim2.new(0, 18, 0, 18),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.2,
                    true
                )
                buttonStroke.Transparency = 0.7
            end
        end)

        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                sliderButton:TweenSize(
                    UDim2.new(0, 22, 0, 22),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.2,
                    true
                )
                buttonStroke.Transparency = 0.3
            end
        end)

        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                sliderButton:TweenSize(
                    UDim2.new(0, 22, 0, 22),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.2,
                    true
                )
                buttonStroke.Transparency = 0.3
                currentValue = updateSlider(calculateValueFromPosition(input.Position))
            end
        end)

        userInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                input.UserInputType == Enum.UserInputType.Touch) and dragging then
                dragging = false
                sliderButton:TweenSize(
                    UDim2.new(0, 18, 0, 18),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.2,
                    true
                )
                buttonStroke.Transparency = 0.7
            end
        end)

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
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, -8, 0, 66)
        dropdownContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        dropdownContainer.BackgroundTransparency = 0.4
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.Parent = self.container

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        containerCorner.Parent = dropdownContainer

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -16, 0, 30)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Dropdown"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = dropdownContainer

        local dropButton = Instance.new("TextButton")
        dropButton.Name = "DropButton"
        dropButton.Size = UDim2.new(1, -32, 0, 36)
        dropButton.Position = UDim2.new(0, 16, 0, 30)
        dropButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
        dropButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        dropButton.Text = default or (options and options[1]) or "Select"
        dropButton.TextSize = 14
        dropButton.Font = GuiLib.Settings.FontSemibold
        dropButton.AutoButtonColor = false
        dropButton.Parent = dropdownContainer

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        buttonCorner.Parent = dropButton

        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(1, -25, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.TextColor3 = GuiLib.Settings.DefaultColors.Accent
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
        frameCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        frameCorner.Parent = dropFrame

        local optionList = Instance.new("ScrollingFrame")
        optionList.Name = "OptionList"
        optionList.Size = UDim2.new(1, -8, 1, -8)
        optionList.Position = UDim2.new(0, 4, 0, 4)
        optionList.BackgroundTransparency = 1
        optionList.BorderSizePixel = 0
        optionList.ScrollBarThickness = 3
        optionList.ScrollBarImageColor3 = GuiLib.Settings.DefaultColors.ScrollBar
        optionList.ZIndex = 6
        optionList.Parent = dropFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 4)
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = optionList

        local isOpen = false
        local selectedOption = default or (options and options[1]) or "Select"

        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = GuiLib.Settings.DefaultColors.Accent
        buttonStroke.Transparency = 0.9
        buttonStroke.Thickness = 1.5
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = dropButton

        dropButton.MouseEnter:Connect(function()
            buttonStroke.Transparency = 0.7
            dropButton.BackgroundColor3 = Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 10, 255),
                math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 10, 255),
                math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 10, 255)
            )
        end)

        dropButton.MouseLeave:Connect(function()
            buttonStroke.Transparency = 0.9
            dropButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
        end)

        local function toggleDropdown()
            isOpen = not isOpen

            if isOpen then
                icon.Text = "▲"
                icon.TextColor3 = GuiLib.Settings.DefaultColors.Accent
                dropFrame.Visible = true

                local optionsHeight = #options * 34 + (#options - 1) * 4
                optionsHeight = math.min(optionsHeight, 150) 

                dropdownContainer:TweenSize(
                    UDim2.new(1, -8, 0, 66 + optionsHeight),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.3,
                    true
                )

                dropFrame:TweenSize(
                    UDim2.new(1, 0, 0, optionsHeight),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.3,
                    true
                )

                optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 34 + (#options - 1) * 4)
            else
                icon.Text = "▼"
                icon.TextColor3 = GuiLib.Settings.DefaultColors.Accent

                dropdownContainer:TweenSize(
                    UDim2.new(1, -8, 0, 66),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.3,
                    true
                )

                dropFrame:TweenSize(
                    UDim2.new(1, 0, 0, 0),
                    GuiLib.Settings.EasingDirection,
                    GuiLib.Settings.Easing,
                    0.3,
                    true,
                    function()
                        dropFrame.Visible = false
                    end
                )
            end
        end

        dropButton.MouseButton1Click:Connect(toggleDropdown)

        if options then
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. option
                optionButton.Size = UDim2.new(1, -8, 0, 30)
                optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                optionButton.BackgroundTransparency = 0.2
                optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
                optionButton.Text = option
                optionButton.TextSize = 14
                optionButton.Font = GuiLib.Settings.FontRegular
                optionButton.ZIndex = 7
                optionButton.AutoButtonColor = false
                optionButton.Parent = optionList

                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                optionCorner.Parent = optionButton

                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundTransparency = 0
                    optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover
                end)

                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundTransparency = 0.2
                    optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                end)

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

            for _, child in ipairs(optionList:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end

            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. option
                optionButton.Size = UDim2.new(1, -8, 0, 30)
                optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                optionButton.BackgroundTransparency = 0.2
                optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
                optionButton.Text = option
                optionButton.TextSize = 14
                optionButton.Font = GuiLib.Settings.FontRegular
                optionButton.ZIndex = 7
                optionButton.AutoButtonColor = false
                optionButton.Parent = optionList

                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                optionCorner.Parent = optionButton

                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundTransparency = 0
                    optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover
                end)

                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundTransparency = 0.2
                    optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                end)

                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    dropButton.Text = option
                    toggleDropdown()

                    if callback then
                        callback(option)
                    end
                end)
            end

            optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 34 + (#options - 1) * 4)

            if not keepSelection or not table.find(options, selectedOption) then
                selectedOption = options[1] or "Select"
                dropButton.Text = selectedOption
            end
        end

        return dropdownFunctions
    end

    function window:AddColorPicker(text, default, callback)
        default = default or Color3.fromRGB(255, 255, 255)

        local colorPickerContainer = Instance.new("Frame")
        colorPickerContainer.Name = "ColorPickerContainer"
        colorPickerContainer.Size = UDim2.new(1, -8, 0, 36)
        colorPickerContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        colorPickerContainer.BackgroundTransparency = 0.4
        colorPickerContainer.BorderSizePixel = 0
        colorPickerContainer.Parent = self.container

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        containerCorner.Parent = colorPickerContainer

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -66, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Color Picker"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = colorPickerContainer

        local colorDisplay = Instance.new("Frame")
        colorDisplay.Name = "ColorDisplay"
        colorDisplay.Size = UDim2.new(0, 36, 0, 26)
        colorDisplay.Position = UDim2.new(1, -46, 0.5, -13)
        colorDisplay.BackgroundColor3 = default
        colorDisplay.BorderSizePixel = 0
        colorDisplay.Parent = colorPickerContainer

        local displayCorner = Instance.new("UICorner")
        displayCorner.CornerRadius = UDim.new(0, 4)
        displayCorner.Parent = colorDisplay

        local displayStroke = Instance.new("UIStroke")
        displayStroke.Name = "DisplayStroke"
        displayStroke.Color = Color3.fromRGB(255, 255, 255)
        displayStroke.Transparency = 0.8
        displayStroke.Thickness = 1
        displayStroke.Parent = colorDisplay

        local clickButton = Instance.new("TextButton")
        clickButton.Name = "ClickButton"
        clickButton.Size = UDim2.new(1, 0, 1, 0)
        clickButton.BackgroundTransparency = 1
        clickButton.Text = ""
        clickButton.Parent = colorDisplay

        local pickerFrame = Instance.new("Frame")
        pickerFrame.Name = "PickerFrame"
        pickerFrame.Size = UDim2.new(0, 220, 0, 240)
        pickerFrame.Position = UDim2.new(1, -220, 1, 10)
        pickerFrame.BackgroundColor3 = GuiLib.Settings.DefaultColors.BackgroundSecondary
        pickerFrame.BackgroundTransparency = 0.1
        pickerFrame.BorderSizePixel = 0
        pickerFrame.Visible = false
        pickerFrame.ZIndex = 10
        pickerFrame.Parent = colorPickerContainer

        local pickerCorner = Instance.new("UICorner")
        pickerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        pickerCorner.Parent = pickerFrame

        local pickerTitle = Instance.new("TextLabel")
        pickerTitle.Name = "PickerTitle"
        pickerTitle.Size = UDim2.new(1, 0, 0, 30)
        pickerTitle.BackgroundTransparency = 1
        pickerTitle.TextColor3 = GuiLib.Settings.DefaultColors.Text
        pickerTitle.Text = "Select Color"
        pickerTitle.TextSize = 14
        pickerTitle.Font = GuiLib.Settings.FontSemibold
        pickerTitle.ZIndex = 11
        pickerTitle.Parent = pickerFrame

        local hueFrame = Instance.new("Frame")
        hueFrame.Name = "HueFrame"
        hueFrame.Size = UDim2.new(0, 190, 0, 20)
        hueFrame.Position = UDim2.new(0.5, -95, 0, 190)
        hueFrame.ZIndex = 11
        hueFrame.Parent = pickerFrame

        local hueCorner = Instance.new("UICorner")
        hueCorner.CornerRadius = UDim.new(0, 4)
        hueCorner.Parent = hueFrame

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

        local hueSelector = Instance.new("Frame")
        hueSelector.Name = "HueSelector"
        hueSelector.Size = UDim2.new(0, 6, 1, 6)
        hueSelector.Position = UDim2.new(0, 0, 0, -3)
        hueSelector.BorderSizePixel = 1
        hueSelector.BorderColor3 = Color3.fromRGB(255, 255, 255)
        hueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueSelector.BackgroundTransparency = 0.7
        hueSelector.ZIndex = 12
        hueSelector.Parent = hueFrame

        local colorField = Instance.new("Frame")
        colorField.Name = "ColorField"
        colorField.Size = UDim2.new(0, 190, 0, 150)
        colorField.Position = UDim2.new(0.5, -95, 0, 35)
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
        colorSelector.Size = UDim2.new(0, 14, 0, 14)
        colorSelector.AnchorPoint = Vector2.new(0.5, 0.5)
        colorSelector.BackgroundTransparency = 1
        colorSelector.BorderSizePixel = 2
        colorSelector.BorderColor3 = Color3.fromRGB(255, 255, 255)
        colorSelector.ZIndex = 13
        colorSelector.Parent = colorField

        local selectorInner = Instance.new("Frame")
        selectorInner.Name = "SelectorInner"
        selectorInner.Size = UDim2.new(0, 6, 0, 6)
        selectorInner.Position = UDim2.new(0.5, -3, 0.5, -3)
        selectorInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        selectorInner.BorderSizePixel = 0
        selectorInner.ZIndex = 14
        selectorInner.Parent = colorSelector

        local innerCorner = Instance.new("UICorner")
        innerCorner.CornerRadius = UDim.new(1, 0)
        innerCorner.Parent = selectorInner

        local currentColorDisplay = Instance.new("Frame")
        currentColorDisplay.Name = "CurrentColor"
        currentColorDisplay.Size = UDim2.new(0, 190, 0, 30)
        currentColorDisplay.Position = UDim2.new(0.5, -95, 1, -40)
        currentColorDisplay.BackgroundColor3 = default
        currentColorDisplay.BorderSizePixel = 0
        currentColorDisplay.ZIndex = 11
        currentColorDisplay.Parent = pickerFrame

        local currentColorCorner = Instance.new("UICorner")
        currentColorCorner.CornerRadius = UDim.new(0, 4)
        currentColorCorner.Parent = currentColorDisplay

        clickButton.MouseEnter:Connect(function()
            displayStroke.Transparency = 0.5
            colorPickerContainer.BackgroundTransparency = 0.2
        end)

        clickButton.MouseLeave:Connect(function()
            displayStroke.Transparency = 0.8
            colorPickerContainer.BackgroundTransparency = 0.4
        end)

        local pickerOpen = false
        local selectedColor = default
        local hue, saturation, value = 0, 0, 1

        local function updateColor()
            local hsv = Color3.fromHSV(hue, saturation, value)
            colorDisplay.BackgroundColor3 = hsv
            currentColorDisplay.BackgroundColor3 = hsv
            colorField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)

            if callback then
                callback(hsv)
            end

            return hsv
        end

        local function updateSelectors()

            hueSelector.Position = UDim2.new(hue, -3, 0, -3)

            colorSelector.Position = UDim2.new(saturation, 0, 1 - value, 0)

            selectedColor = updateColor()
        end

        local function togglePicker()
            pickerOpen = not pickerOpen
            pickerFrame.Visible = pickerOpen
        end

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

        hue, saturation, value = rgbToHsv(default)
        updateSelectors()

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
        local textBoxContainer = Instance.new("Frame")
        textBoxContainer.Name = "TextBoxContainer"
        textBoxContainer.Size = UDim2.new(1, -8, 0, 66)
        textBoxContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        textBoxContainer.BackgroundTransparency = 0.4
        textBoxContainer.BorderSizePixel = 0
        textBoxContainer.Parent = self.container

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        containerCorner.Parent = textBoxContainer

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -32, 0, 30)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Text Input"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textBoxContainer

        local inputBox = Instance.new("TextBox")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(1, -32, 0, 36)
        inputBox.Position = UDim2.new(0, 16, 0, 30)
        inputBox.BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
        inputBox.TextColor3 = GuiLib.Settings.DefaultColors.Text
        inputBox.PlaceholderText = placeholder or "Enter text here..."
        inputBox.PlaceholderColor3 = GuiLib.Settings.DefaultColors.TextDimmed
        inputBox.Text = defaultText or ""
        inputBox.TextSize = 14
        inputBox.Font = GuiLib.Settings.FontRegular
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.ClearTextOnFocus = false
        inputBox.ClipsDescendants = true
        inputBox.Parent = textBoxContainer

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        boxCorner.Parent = inputBox

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.Parent = inputBox

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Name = "BoxStroke"
        boxStroke.Color = GuiLib.Settings.DefaultColors.Accent
        boxStroke.Transparency = 0.9
        boxStroke.Thickness = 1.5
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxStroke.Parent = inputBox

        inputBox.Focused:Connect(function()
            inputBox.BackgroundColor3 = Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 15, 255),
                math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 15, 255),
                math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 15, 255)
            )
            boxStroke.Transparency = 0.5
        end)

        inputBox.FocusLost:Connect(function(enterPressed)
            inputBox.BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
            boxStroke.Transparency = 0.9

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

GuiLib.Themes = {
    Modern = {
        DefaultColors = {
            Background = Color3.fromRGB(35, 35, 40),
            BackgroundSecondary = Color3.fromRGB(45, 45, 50),
            Title = Color3.fromRGB(25, 25, 30),
            Button = Color3.fromRGB(55, 55, 65),
            ButtonHover = Color3.fromRGB(65, 65, 75),
            ButtonPressed = Color3.fromRGB(45, 45, 55),
            ButtonEnabled = Color3.fromRGB(45, 180, 90),
            ButtonDisabled = Color3.fromRGB(200, 65, 65),
            Text = Color3.fromRGB(240, 240, 245),
            TextDimmed = Color3.fromRGB(180, 180, 190),
            Accent = Color3.fromRGB(100, 120, 255),
            AccentDark = Color3.fromRGB(80, 100, 220),
            Slider = Color3.fromRGB(70, 70, 80),
            SliderFill = Color3.fromRGB(100, 120, 255),
            Toggle = Color3.fromRGB(55, 55, 65),
            ToggleEnabled = Color3.fromRGB(100, 120, 255),
            Dropdown = Color3.fromRGB(55, 55, 65),
            ScrollBar = Color3.fromRGB(75, 75, 85),
            Shadow = Color3.fromRGB(0, 0, 5)
        }
    },
    Dark = {
        DefaultColors = {
            Background = Color3.fromRGB(25, 25, 30),
            BackgroundSecondary = Color3.fromRGB(35, 35, 40),
            Title = Color3.fromRGB(20, 20, 25),
            Button = Color3.fromRGB(45, 45, 55),
            ButtonHover = Color3.fromRGB(55, 55, 65),
            ButtonPressed = Color3.fromRGB(35, 35, 45),
            ButtonEnabled = Color3.fromRGB(40, 160, 80),
            ButtonDisabled = Color3.fromRGB(180, 60, 60),
            Text = Color3.fromRGB(230, 230, 240),
            TextDimmed = Color3.fromRGB(170, 170, 180),
            Accent = Color3.fromRGB(90, 110, 235),
            AccentDark = Color3.fromRGB(70, 90, 210),
            Slider = Color3.fromRGB(60, 60, 70),
            SliderFill = Color3.fromRGB(90, 110, 235),
            Toggle = Color3.fromRGB(45, 45, 55),
            ToggleEnabled = Color3.fromRGB(90, 110, 235),
            Dropdown = Color3.fromRGB(45, 45, 55),
            ScrollBar = Color3.fromRGB(65, 65, 75),
            Shadow = Color3.fromRGB(0, 0, 5)
        }
    },
    Light = {
        DefaultColors = {
            Background = Color3.fromRGB(240, 240, 245),
            BackgroundSecondary = Color3.fromRGB(230, 230, 235),
            Title = Color3.fromRGB(250, 250, 255),
            Button = Color3.fromRGB(220, 220, 230),
            ButtonHover = Color3.fromRGB(210, 210, 220),
            ButtonPressed = Color3.fromRGB(200, 200, 210),
            ButtonEnabled = Color3.fromRGB(80, 190, 120),
            ButtonDisabled = Color3.fromRGB(220, 100, 100),
            Text = Color3.fromRGB(60, 60, 70),
            TextDimmed = Color3.fromRGB(120, 120, 130),
            Accent = Color3.fromRGB(70, 100, 245),
            AccentDark = Color3.fromRGB(50, 80, 225),
            Slider = Color3.fromRGB(200, 200, 210),
            SliderFill = Color3.fromRGB(70, 100, 245),
            Toggle = Color3.fromRGB(220, 220, 230),
            ToggleEnabled = Color3.fromRGB(70, 100, 245),
            Dropdown = Color3.fromRGB(220, 220, 230),
            ScrollBar = Color3.fromRGB(190, 190, 200),
            Shadow = Color3.fromRGB(180, 180, 190)
        }
    },
    BlueTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(20, 30, 55),
            BackgroundSecondary = Color3.fromRGB(30, 40, 65),
            Title = Color3.fromRGB(15, 25, 45),
            Button = Color3.fromRGB(35, 45, 75),
            ButtonHover = Color3.fromRGB(45, 55, 85),
            ButtonPressed = Color3.fromRGB(25, 35, 65),
            ButtonEnabled = Color3.fromRGB(40, 170, 100),
            ButtonDisabled = Color3.fromRGB(190, 70, 70),
            Text = Color3.fromRGB(230, 240, 255),
            TextDimmed = Color3.fromRGB(170, 180, 210),
            Accent = Color3.fromRGB(65, 130, 255),
            AccentDark = Color3.fromRGB(50, 110, 235),
            Slider = Color3.fromRGB(40, 50, 80),
            SliderFill = Color3.fromRGB(65, 130, 255),
            Toggle = Color3.fromRGB(35, 45, 75),
            ToggleEnabled = Color3.fromRGB(65, 130, 255),
            Dropdown = Color3.fromRGB(35, 45, 75),
            ScrollBar = Color3.fromRGB(45, 55, 85),
            Shadow = Color3.fromRGB(5, 10, 20)
        }
    },
    RedTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(45, 25, 30),
            BackgroundSecondary = Color3.fromRGB(55, 35, 40),
            Title = Color3.fromRGB(40, 20, 25),
            Button = Color3.fromRGB(65, 40, 45),
            ButtonHover = Color3.fromRGB(75, 50, 55),
            ButtonPressed = Color3.fromRGB(55, 30, 35),
            ButtonEnabled = Color3.fromRGB(50, 170, 100),
            ButtonDisabled = Color3.fromRGB(50, 50, 180),
            Text = Color3.fromRGB(240, 230, 230),
            TextDimmed = Color3.fromRGB(200, 180, 180),
            Accent = Color3.fromRGB(230, 80, 100),
            AccentDark = Color3.fromRGB(210, 60, 80),
            Slider = Color3.fromRGB(75, 45, 50),
            SliderFill = Color3.fromRGB(230, 80, 100),
            Toggle = Color3.fromRGB(65, 40, 45),
            ToggleEnabled = Color3.fromRGB(230, 80, 100),
            Dropdown = Color3.fromRGB(65, 40, 45),
            ScrollBar = Color3.fromRGB(75, 50, 55),
            Shadow = Color3.fromRGB(20, 10, 10)
        }
    },
    GreenTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(25, 45, 35),
            BackgroundSecondary = Color3.fromRGB(35, 55, 45),
            Title = Color3.fromRGB(20, 40, 30),
            Button = Color3.fromRGB(40, 65, 50),
            ButtonHover = Color3.fromRGB(50, 75, 60),
            ButtonPressed = Color3.fromRGB(30, 55, 40),
            ButtonEnabled = Color3.fromRGB(40, 180, 100),
            ButtonDisabled = Color3.fromRGB(190, 70, 70),
            Text = Color3.fromRGB(230, 240, 235),
            TextDimmed = Color3.fromRGB(180, 200, 190),
            Accent = Color3.fromRGB(70, 200, 120),
            AccentDark = Color3.fromRGB(50, 180, 100),
            Slider = Color3.fromRGB(45, 70, 55),
            SliderFill = Color3.fromRGB(70, 200, 120),
            Toggle = Color3.fromRGB(40, 65, 50),
            ToggleEnabled = Color3.fromRGB(70, 200, 120),
            Dropdown = Color3.fromRGB(40, 65, 50),
            ScrollBar = Color3.fromRGB(50, 75, 60),
            Shadow = Color3.fromRGB(10, 20, 15)
        }
    },
    PurpleTheme = {
        DefaultColors = {
            Background = Color3.fromRGB(40, 30, 55),
            BackgroundSecondary = Color3.fromRGB(50, 40, 65),
            Title = Color3.fromRGB(35, 25, 50),
            Button = Color3.fromRGB(55, 45, 75),
            ButtonHover = Color3.fromRGB(65, 55, 85),
            ButtonPressed = Color3.fromRGB(45, 35, 65),
            ButtonEnabled = Color3.fromRGB(50, 180, 100),
            ButtonDisabled = Color3.fromRGB(190, 70, 70),
            Text = Color3.fromRGB(230, 230, 240),
            TextDimmed = Color3.fromRGB(180, 180, 200),
            Accent = Color3.fromRGB(150, 100, 255),
            AccentDark = Color3.fromRGB(130, 80, 235),
            Slider = Color3.fromRGB(60, 50, 80),
            SliderFill = Color3.fromRGB(150, 100, 255),
            Toggle = Color3.fromRGB(55, 45, 75),
            ToggleEnabled = Color3.fromRGB(150, 100, 255),
            Dropdown = Color3.fromRGB(55, 45, 75),
            ScrollBar = Color3.fromRGB(65, 55, 85),
            Shadow = Color3.fromRGB(15, 10, 20)
        }
    }
}

local success, result = pcall(function()
    return GuiLib
end)

if success then
    return GuiLib
else
    assert("Failed to initialize library: " .. tostring(result))
    return nil
end

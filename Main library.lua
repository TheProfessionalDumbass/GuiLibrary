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
        ScrollBar = Color3.fromRGB(60, 60, 60),
        Accent = Color3.fromRGB(0, 162, 255) -- Added accent color
    },
    DefaultTransparency = 0.3,
    FontBold = Enum.Font.GothamBold,
    FontRegular = Enum.Font.Gotham,
    CornerRadius = UDim.new(0, 6) -- Increased corner radius
}

-- Utility functions for tweening
local TweenService = game:GetService("TweenService")

local function tweenProperty(instance, property, value, time, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        time or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(instance, tweenInfo, {[property] = value})
    tween:Play()
    return tween
end

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
        gui.Parent = CoreGui
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
    mainFrame.Size = size or UDim2.new(0, 650, 0, 300) -- Wider for horizontal layout
    mainFrame.Position = position or UDim2.new(0.5, -325, 0.5, -150)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    mainFrame.ClipsDescendants = true -- Prevent elements from spilling out

    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Settings.CornerRadius
    corner.Parent = mainFrame
    
    -- Add shadow with improved appearance
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame

    -- Title bar (now on the left side for horizontal layout)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(0, 200, 1, 0) -- Full height, fixed width
    titleBar.BackgroundColor3 = self.Settings.DefaultColors.Title
    titleBar.BackgroundTransparency = self.Settings.DefaultTransparency - 0.1 -- Slightly more opaque
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = self.Settings.CornerRadius
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = self.Settings.DefaultColors.Text
    titleLabel.TextSize = 18
    titleLabel.Font = self.Settings.FontBold
    titleLabel.Text = name or "GUI Library"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Accent line 
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(0.7, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 10, 0, 50)
    accentLine.BackgroundColor3 = self.Settings.DefaultColors.Accent
    accentLine.BorderSizePixel = 0
    accentLine.Parent = titleBar
    
    -- Close button (now at top of sidebar)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -30, 0, 10)
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
    
    -- Hover effect for close button
    closeButton.MouseEnter:Connect(function()
        tweenProperty(closeButton, "BackgroundTransparency", 0.3, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        tweenProperty(closeButton, "BackgroundTransparency", 0.5, 0.2)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        -- Fade out animation
        tweenProperty(mainFrame, "BackgroundTransparency", 1, 0.3)
        tweenProperty(titleBar, "BackgroundTransparency", 1, 0.3)
        
        -- Wait for animation to finish before destroying
        delay(0.3, function()
            gui:Destroy()
        end)
    end)
    
    -- Main content area (scrolling horizontally now)
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -210, 1, -20) -- Leave room for the sidebar
    contentArea.Position = UDim2.new(0, 205, 0, 10)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame
    
    -- Scrolling container (horizontal)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Container"
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scrollingFrame.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = contentArea
    
    -- Auto layout for content
    local listLayout = Instance.new("UIGridLayout")
    listLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    listLayout.CellSize = UDim2.new(0, 200, 0, 100) -- Default size for items
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollingFrame
    
    local paddingFrame = Instance.new("UIPadding")
    paddingFrame.PaddingTop = UDim.new(0, 5)
    paddingFrame.PaddingBottom = UDim.new(0, 5)
    paddingFrame.PaddingLeft = UDim.new(0, 5)
    paddingFrame.PaddingRight = UDim.new(0, 5)
    paddingFrame.Parent = scrollingFrame

    -- Sidebar navigation
    local navContainer = Instance.new("ScrollingFrame")
    navContainer.Name = "NavContainer"
    navContainer.Size = UDim2.new(1, -20, 1, -80)
    navContainer.Position = UDim2.new(0, 10, 0, 60)
    navContainer.BackgroundTransparency = 1
    navContainer.BorderSizePixel = 0
    navContainer.ScrollBarThickness = 4
    navContainer.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    navContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    navContainer.Parent = titleBar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 8)
    navLayout.FillDirection = Enum.FillDirection.Vertical
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

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
        scrollingFrame.CanvasSize = UDim2.new(0, listLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)
    
    -- Auto-update nav container size
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 10)
    end)

    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame
    window.navContainer = navContainer
    
    -- Add entry animation
    mainFrame.BackgroundTransparency = 1
    titleBar.BackgroundTransparency = 1
    
    tweenProperty(mainFrame, "BackgroundTransparency", self.Settings.DefaultTransparency, 0.5)
    tweenProperty(titleBar, "BackgroundTransparency", self.Settings.DefaultTransparency - 0.1, 0.5)

    -- Toggle window visibility
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
        
        if visible then
            mainFrame.Visible = true
            tweenProperty(mainFrame, "BackgroundTransparency", self.Settings.DefaultTransparency, 0.3)
        else
            tweenProperty(mainFrame, "BackgroundTransparency", 1, 0.3)
            delay(0.3, function()
                mainFrame.Visible = false
            end)
        end
        
        return self
    end

    -- Create section (card-based design)
    function window:AddSection(title)
        local section = Instance.new("Frame")
        section.Name = "Section_" .. title
        section.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        section.BackgroundTransparency = GuiLib.Settings.DefaultTransparency - 0.1
        section.BorderSizePixel = 0
        section.Parent = self.container
        
        -- Initial animation state
        section.Size = UDim2.new(0, 200, 0, 0)
        section.BackgroundTransparency = 1
        
        -- Animate in
        tweenProperty(section, "Size", UDim2.new(0, 200, 0, 200), 0.3)
        tweenProperty(section, "BackgroundTransparency", GuiLib.Settings.DefaultTransparency - 0.1, 0.3)
        
        -- Add inner shadow/glow effect
        local innerGlow = Instance.new("ImageLabel")
        innerGlow.Name = "InnerGlow"
        innerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        innerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        innerGlow.Size = UDim2.new(1, 10, 1, 10)
        innerGlow.BackgroundTransparency = 1
        innerGlow.Image = "rbxassetid://5554236805"
        innerGlow.ImageColor3 = GuiLib.Settings.DefaultColors.Accent
        innerGlow.ImageTransparency = 0.9
        innerGlow.ScaleType = Enum.ScaleType.Slice
        innerGlow.SliceCenter = Rect.new(23, 23, 277, 277)
        innerGlow.ZIndex = 0
        innerGlow.Parent = section
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = GuiLib.Settings.CornerRadius
        sectionCorner.Parent = section
        
        -- Header
        local headerContainer = Instance.new("Frame")
        headerContainer.Name = "HeaderContainer"
        headerContainer.Size = UDim2.new(1, 0, 0, 30)
        headerContainer.BackgroundTransparency = 0.7
        headerContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        headerContainer.BorderSizePixel = 0
        headerContainer.Parent = section
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        headerCorner.Parent = headerContainer
        
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
        sectionTitle.Parent = headerContainer
        
        -- Content container
        local contentContainer = Instance.new("ScrollingFrame")
        contentContainer.Name = "ContentContainer"
        contentContainer.Size = UDim2.new(1, -10, 1, -40)
        contentContainer.Position = UDim2.new(0, 5, 0, 35)
        contentContainer.BackgroundTransparency = 1
        contentContainer.BorderSizePixel = 0
        contentContainer.ScrollBarThickness = 4
        contentContainer.ScrollBarImageColor3 = GuiLib.Settings.DefaultColors.ScrollBar
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentContainer.Parent = section
        
        -- Auto layout
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.FillDirection = Enum.FillDirection.Vertical
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = contentContainer
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 5)
        contentPadding.PaddingBottom = UDim.new(0, 5)
        contentPadding.Parent = contentContainer
        
        -- Auto-update content container size
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Add navigation button
        local navButton = Instance.new("TextButton")
        navButton.Name = "NavButton_" .. title
        navButton.Size = UDim2.new(1, -20, 0, 30)
        navButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        navButton.BackgroundTransparency = 0.5
        navButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        navButton.Text = title
        navButton.TextSize = 14
        navButton.Font = GuiLib.Settings.FontRegular
        navButton.Parent = self.navContainer
        
        local navCorner = Instance.new("UICorner")
        navCorner.CornerRadius = GuiLib.Settings.CornerRadius
        navCorner.Parent = navButton
        
        -- Hover and click effects
        navButton.MouseEnter:Connect(function()
            tweenProperty(navButton, "BackgroundTransparency", 0.3, 0.2)
        end)
        
        navButton.MouseLeave:Connect(function()
            tweenProperty(navButton, "BackgroundTransparency", 0.5, 0.2)
        end)
        
        navButton.MouseButton1Down:Connect(function()
            tweenProperty(navButton, "BackgroundTransparency", 0.1, 0.1)
        end)
        
        navButton.MouseButton1Up:Connect(function()
            tweenProperty(navButton, "BackgroundTransparency", 0.3, 0.1)
        end)
        
        -- Click to scroll to section
        navButton.MouseButton1Click:Connect(function()
            -- Find the section's position in the container
            local layoutItems = {}
            for _, child in pairs(self.container:GetChildren()) do
                if child:IsA("Frame") and child.Name:match("^Section_") then
                    table.insert(layoutItems, child)
                end
            end
            
            table.sort(layoutItems, function(a, b)
                return a.LayoutOrder < b.LayoutOrder
            end)
            
            local index = 0
            for i, item in ipairs(layoutItems) do
                if item == section then
                    index = i
                    break
                end
            end
            
            if index > 0 then
                local cellWidth = 210 -- 200 + 10 padding
                self.container.CanvasPosition = Vector2.new((index - 1) * cellWidth, 0)
            end
            
            -- Highlight effect
            local originalColor = section.BackgroundColor3
            tweenProperty(section, "BackgroundColor3", GuiLib.Settings.DefaultColors.Accent, 0.3)
            delay(0.3, function()
                tweenProperty(section, "BackgroundColor3", originalColor, 0.5)
            end)
        end)
        
        return contentContainer
    end

    function window:AddLabel(text)
        local labelInstance = Instance.new("TextLabel")
        labelInstance.Name = "Label"
        labelInstance.Size = UDim2.new(1, -10, 0, 25)
        labelInstance.BackgroundTransparency = 1
        labelInstance.TextColor3 = GuiLib.Settings.DefaultColors.Text
        labelInstance.Text = text or "Label"
        labelInstance.TextSize = 14
        labelInstance.Font = GuiLib.Settings.FontRegular
        labelInstance.Parent = self.container
        
        -- Create a wrapper object
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
        button.Size = UDim2.new(1, -10, 0, 32)
        button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        button.TextColor3 = GuiLib.Settings.DefaultColors.Text
        button.Text = text or "Button"
        button.TextSize = 14
        button.Font = GuiLib.Settings.FontBold
        button.Parent = self.container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.CornerRadius
        buttonCorner.Parent = button
        
        -- Add subtle shadow
        local buttonShadow = Instance.new("ImageLabel")
        buttonShadow.Name = "Shadow"
        buttonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        buttonShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        buttonShadow.Size = UDim2.new(1, 6, 1, 6)
        buttonShadow.BackgroundTransparency = 1
        buttonShadow.Image = "rbxassetid://5554236805"
        buttonShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        buttonShadow.ImageTransparency = 0.8
        buttonShadow.ScaleType = Enum.ScaleType.Slice
        buttonShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        buttonShadow.ZIndex = 0
        buttonShadow.Parent = button
        
        -- Animation effects with improved tweening
        button.MouseEnter:Connect(function()
            tweenProperty(button, "BackgroundColor3", Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Button.R * 255 + 30, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.G * 255 + 30, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.B * 255 + 30, 255)
            ), 0.2, Enum.EasingStyle.Quad)
            
            tweenProperty(button, "Size", UDim2.new(1, -8, 0, 34), 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            tweenProperty(button, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.2)
            tweenProperty(button, "Size", UDim2.new(1, -10, 0, 32), 0.2)
        end)
        
        button.MouseButton1Down:Connect(function()
            tweenProperty(button, "BackgroundColor3", Color3.fromRGB(
                math.max(GuiLib.Settings.DefaultColors.Button.R * 255 - 30, 0),
                math.max(GuiLib.Settings.DefaultColors.Button.G * 255 - 30, 0),
                math.max(GuiLib.Settings.DefaultColors.Button.B * 255 - 30, 0)
            ), 0.1)
            
            tweenProperty(button, "Size", UDim2.new(1, -12, 0, 30), 0.1)
        end)
        
        button.MouseButton1Up:Connect(function()
            tweenProperty(button, "BackgroundColor3", Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Button.R * 255 + 30, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.G * 255 + 30, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.B * 255 + 30, 255)
            ), 0.1)
            
            tweenProperty(button, "Size", UDim2.new(1, -8, 0, 34), 0.1)
        end)
        
        if callback then
            button.MouseButton1Click:Connect(function()
                -- Ripple effect
                local ripple = Instance.new("Frame")
                ripple.Name = "Ripple"
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.7
                ripple.BorderSizePixel = 0
                ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.ZIndex = 2
                ripple.Parent = button
                
                local rippleCorner = Instance.new("UICorner")
                rippleCorner.CornerRadius = UDim.new(1, 0)
                rippleCorner.Parent = ripple
                
                tweenProperty(ripple, "Size", UDim2.new(2, 0, 2, 0), 0.5)
                tweenProperty(ripple, "BackgroundTransparency", 1, 0.5)
                
                game:GetService("Debris"):AddItem(ripple, 0.5)
                
                callback()
            end)
        end
        
        return button
    end

    function window:AddToggle(text, default, callback)
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Name = "Toggle"
        toggleContainer.Size = UDim2.new(1, -10, 0, 30)
        toggleContainer.BackgroundTransparency = 1
        toggleContainer.Parent = self.container
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Toggle"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleContainer
        
        local toggleButton = Instance.new("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 44, 0, 22)
        toggleButton.Position = UDim2.new(1, -44, 0.5, -11)
        toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle
        toggleButton.Parent = toggleContainer
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleButton
        
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 18, 0, 18)
        indicator.Position = UDim2.new(0, 2, 0.5, -9)
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
        clickArea.Parent = toggleContainer
        
        local isEnabled = default or false
        
        local function updateVisuals()
            if isEnabled then
                tweenProperty(toggleButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.ToggleEnabled, 0.3)
                tweenProperty(indicator, "Position", UDim2.new(0, 24, 0.5, -9), 0.3)
            else
                tweenProperty(toggleButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.Toggle, 0.3)
                tweenProperty(indicator, "Position", UDim2.new(0, 2, 0.5, -9), 0.3)
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
        slider.Size = UDim2.new(1, -10, 0, 50)
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
        sliderBar.Size = UDim2.new(1, 0, 0, 8) -- Thinner bar
        sliderBar.Position = UDim2.new(0, 0, 0, 30)
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
        sliderButton.Size = UDim2.new(0, 18, 0, 18)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0, -5)
        sliderButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Text
        sliderButton.Text = ""
        sliderButton.Parent = sliderBar
        
        -- Add shadow to slider button
        local buttonShadow = Instance.new("ImageLabel")
        buttonShadow.Name = "Shadow"
        buttonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        buttonShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        buttonShadow.Size = UDim2.new(1, 6, 1, 6)
        buttonShadow.BackgroundTransparency = 1
        buttonShadow.Image = "rbxassetid://5554236805"
        buttonShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        buttonShadow.ImageTransparency = 0.7
        buttonShadow.ScaleType = Enum.ScaleType.Slice
        buttonShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        buttonShadow.ZIndex = 0
        buttonShadow.Parent = sliderButton
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0)
        buttonCorner.Parent = sliderButton
        
        local function updateSlider(value)
            local newValue = math.clamp(value, min, max)
            if precision then
                newValue = math.floor(newValue / precision) * precision
            end
            
            local percent = (newValue - min) / (max - min)
            tweenProperty(sliderFill, "Size", UDim2.new(percent, 0, 1, 0), 0.1, Enum.EasingStyle.Quad)
            tweenProperty(sliderButton, "Position", UDim2.new(percent, -9, 0, -5), 0.1, Enum.EasingStyle.Quad)
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
                tweenProperty(sliderButton, "Size", UDim2.new(0, 22, 0, 22), 0.2) -- Grow when dragging
            end
        end)
        
        -- Handle bar click/tap (both mouse and touch)
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                tweenProperty(sliderButton, "Size", UDim2.new(0, 22, 0, 22), 0.2) -- Grow when dragging
                currentValue = updateSlider(calculateValueFromPosition(input.Position))
            end
        end)
        
        -- Handle input ending (both mouse and touch)
        userInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                input.UserInputType == Enum.UserInputType.Touch) and dragging then
                dragging = false
                tweenProperty(sliderButton, "Size", UDim2.new(0, 18, 0, 18), 0.2) -- Return to normal size
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
        dropdown.Size = UDim2.new(1, -10, 0, 60)
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
        dropButton.Size = UDim2.new(1, 0, 0, 34)
        dropButton.Position = UDim2.new(0, 0, 0, 22)
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
            
            if isOpen then
                icon.Text = "▲"
                dropFrame.Visible = true
                local optionsHeight = #options * 30 + (#options - 1) * 2
                optionsHeight = math.min(optionsHeight, 150) -- Max height
                
                tweenProperty(dropFrame, "Size", UDim2.new(1, 0, 0, optionsHeight), 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 30 + (#options - 1) * 2)
            else
                icon.Text = "▼"
                tweenProperty(dropFrame, "Size", UDim2.new(1, 0, 0, 0), 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                delay(0.3, function()
                    if not isOpen then -- Check again in case it was toggled
                        dropFrame.Visible = false
                    end
                end)
            end
        end
        
        dropButton.MouseButton1Click:Connect(toggleDropdown)
        
        -- Hover effect
        dropButton.MouseEnter:Connect(function()
            tweenProperty(dropButton, "BackgroundColor3", Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Button.R * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.G * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.B * 255 + 20, 255)
            ), 0.2)
        end)
        
        dropButton.MouseLeave:Connect(function()
            tweenProperty(dropButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.2)
        end)
        
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
                
                -- Option hover effect
                optionButton.MouseEnter:Connect(function()
                    tweenProperty(optionButton, "BackgroundTransparency", 0.3, 0.2)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    tweenProperty(optionButton, "BackgroundTransparency", 0.5, 0.2)
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
        colorPicker.Size = UDim2.new(1, -10, 0, 35)
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
        colorDisplay.Size = UDim2.new(0, 35, 0, 35)
        colorDisplay.Position = UDim2.new(1, -35, 0, 0)
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
        pickerFrame.Size = UDim2.new(0, 240, 0, 240)
        pickerFrame.Position = UDim2.new(1, -240, 1, 10)
        pickerFrame.BackgroundColor3 = GuiLib.Settings.DefaultColors.Background
        pickerFrame.BackgroundTransparency = 0.1
        pickerFrame.BorderSizePixel = 0
        pickerFrame.Visible = false
        pickerFrame.ZIndex = 10
        pickerFrame.Parent = colorPicker
        
        local pickerCorner = Instance.new("UICorner")
        pickerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        pickerCorner.Parent = pickerFrame
        
        -- Shadow for picker frame
        local pickerShadow = Instance.new("ImageLabel")
        pickerShadow.Name = "Shadow"
        pickerShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        pickerShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        pickerShadow.Size = UDim2.new(1, 20, 1, 20)
        pickerShadow.BackgroundTransparency = 1
        pickerShadow.Image = "rbxassetid://5554236805"
        pickerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        pickerShadow.ImageTransparency = 0.6
        pickerShadow.ScaleType = Enum.ScaleType.Slice
        pickerShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        pickerShadow.ZIndex = 9
        pickerShadow.Parent = pickerFrame
        
        -- Hue selector
        local hueFrame = Instance.new("Frame")
        hueFrame.Name = "HueFrame"
        hueFrame.Size = UDim2.new(0, 200, 0, 20)
        hueFrame.Position = UDim2.new(0.5, -100, 0, 200)
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
        colorField.Size = UDim2.new(0, 200, 0, 180)
        colorField.Position = UDim2.new(0.5, -100, 0, 10)
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
            tweenProperty(colorDisplay, "BackgroundColor3", hsv, 0.2)
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
            
            if pickerOpen then
                pickerFrame.Visible = true
                tweenProperty(pickerFrame, "BackgroundTransparency", 0.1, 0.3)
                tweenProperty(pickerFrame, "Size", UDim2.new(0, 240, 0, 240), 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                tweenProperty(pickerFrame, "BackgroundTransparency", 1, 0.3)
                tweenProperty(pickerFrame, "Size", UDim2.new(0, 240, 0, 0), 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                delay(0.3, function()
                    if not pickerOpen then -- Check again in case it was reopened
                        pickerFrame.Visible = false
                    end
                end)
            end
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
        textBox.Size = UDim2.new(1, -10, 0, 55)
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
        
        local inputContainer = Instance.new("Frame")
        inputContainer.Name = "InputContainer"
        inputContainer.Size = UDim2.new(1, 0, 0, 35)
        inputContainer.Position = UDim2.new(0, 0, 0, 20)
        inputContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        inputContainer.BackgroundTransparency = 0.2
        inputContainer.Parent = textBox
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        containerCorner.Parent = inputContainer
        
        local inputBox = Instance.new("TextBox")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(1, -16, 1, 0)
        inputBox.Position = UDim2.new(0, 8, 0, 0)
        inputBox.BackgroundTransparency = 1
        inputBox.TextColor3 = GuiLib.Settings.DefaultColors.Text
        inputBox.PlaceholderText = placeholder or "Enter text here..."
        inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        inputBox.Text = defaultText or ""
        inputBox.TextSize = 14
        inputBox.Font = GuiLib.Settings.FontRegular
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.ClearTextOnFocus = false
        inputBox.ClipsDescendants = true
        inputBox.Parent = inputContainer
        
        -- Add focused effect
        inputBox.Focused:Connect(function()
            tweenProperty(inputContainer, "BackgroundColor3", Color3.fromRGB(
                math.min(GuiLib.Settings.DefaultColors.Button.R * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.G * 255 + 20, 255),
                math.min(GuiLib.Settings.DefaultColors.Button.B * 255 + 20, 255)
            ), 0.2)
            
            tweenProperty(inputContainer, "BackgroundTransparency", 0, 0.2)
        end)
        
        inputBox.FocusLost:Connect(function(enterPressed)
            tweenProperty(inputContainer, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.2)
            tweenProperty(inputContainer, "BackgroundTransparency", 0.2, 0.2)
            
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
            ScrollBar = Color3.fromRGB(60, 60, 60),
            Accent = Color3.fromRGB(0, 162, 255)
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
            ScrollBar = Color3.fromRGB(180, 180, 180),
            Accent = Color3.fromRGB(0, 122, 215)
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
            ScrollBar = Color3.fromRGB(50, 60, 80),
            Accent = Color3.fromRGB(50, 150, 220)
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
            ScrollBar = Color3.fromRGB(90, 45, 45),
            Accent = Color3.fromRGB(200, 50, 50)
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
            ScrollBar = Color3.fromRGB(45, 90, 45),
            Accent = Color3.fromRGB(50, 200, 50)
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

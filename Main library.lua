--[[ GUI Library - Landscape Edition ]]
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

-- Custom shadow function for landscape orientation
function GuiLib:CreateShadow(parent, shadowSize, cornerRadius)
    local shadow = Instance.new("Frame")
    shadow.Name = "CustomShadow"
    shadow.Size = UDim2.new(1, shadowSize * 2, 1, shadowSize * 2)
    shadow.Position = UDim2.new(0, -shadowSize, 0, -shadowSize)
    shadow.BackgroundColor3 = self.Settings.DefaultColors.Shadow
    shadow.BackgroundTransparency = 0.2
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius or self.Settings.CornerRadius
    corner.Parent = shadow
    
    -- Create gradient for better shadow effect
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.4, 0.95),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Parent = shadow
    
    return shadow
end

function GuiLib:CreateWindow(name, size, position)
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = name or "GuiLibLandscape"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        gui.Parent = game:GetService("CoreGui")
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

    -- Create main frame with landscape orientation
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 650, 0, 350)  -- Default landscape size
    mainFrame.Position = position or UDim2.new(0.5, -325, 0.5, -175)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Settings.CornerRadius
    corner.Parent = mainFrame

    -- Create custom shadow
    self:CreateShadow(mainFrame, 20, self.Settings.CornerRadius)

    -- Title bar (now on the left side)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(0, 200, 1, 0)  -- Left sidebar
    titleBar.BackgroundColor3 = self.Settings.DefaultColors.Title
    titleBar.BackgroundTransparency = self.Settings.DefaultTransparency
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = self.Settings.CornerRadius
    titleCorner.Parent = titleBar

    -- Right frame fix to prevent corner bleeding
    local rightFrameFix = Instance.new("Frame")
    rightFrameFix.Name = "RightFix"
    rightFrameFix.Size = UDim2.new(0, 10, 1, 0)
    rightFrameFix.Position = UDim2.new(1, -10, 0, 0)
    rightFrameFix.BackgroundColor3 = self.Settings.DefaultColors.Title
    rightFrameFix.BackgroundTransparency = self.Settings.DefaultTransparency
    rightFrameFix.BorderSizePixel = 0
    rightFrameFix.ZIndex = 1
    rightFrameFix.Parent = titleBar

    local titleHeader = Instance.new("Frame")
    titleHeader.Name = "TitleHeader"
    titleHeader.Size = UDim2.new(1, 0, 0, 38)
    titleHeader.BackgroundColor3 = self.Settings.DefaultColors.Title
    titleHeader.BackgroundTransparency = 0
    titleHeader.BorderSizePixel = 0
    titleHeader.Parent = titleBar

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 6)
    headerCorner.Parent = titleHeader

    -- Fix for the header corners
    local headerBottomFix = Instance.new("Frame")
    headerBottomFix.Name = "HeaderBottomFix"
    headerBottomFix.Size = UDim2.new(1, 0, 0, 10)
    headerBottomFix.Position = UDim2.new(0, 0, 1, -10)
    headerBottomFix.BackgroundColor3 = self.Settings.DefaultColors.Title
    headerBottomFix.BorderSizePixel = 0
    headerBottomFix.Parent = titleHeader

    local titleIcon = Instance.new("Frame")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 8, 0, 16)
    titleIcon.Position = UDim2.new(0, 12, 0, 11)
    titleIcon.BackgroundColor3 = self.Settings.DefaultColors.Accent
    titleIcon.BorderSizePixel = 0
    titleIcon.Parent = titleHeader

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
    titleLabel.Parent = titleHeader

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 26, 0, 26)
    closeButton.Position = UDim2.new(1, -32, 0, 6)
    closeButton.BackgroundColor3 = self.Settings.DefaultColors.ButtonDisabled
    closeButton.BackgroundTransparency = 0.3
    closeButton.Text = ""
    closeButton.AutoButtonColor = false
    closeButton.Parent = titleHeader

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton

    local closeIcon = Instance.new("TextLabel")
    closeIcon.Name = "CloseIcon"
    closeIcon.Size = UDim2.new(1, 0, 1, 0)
    closeIcon.BackgroundTransparency = 1
    closeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeIcon.Text = "X"
    closeIcon.TextSize = 18
    closeIcon.Font = self.Settings.FontBold
    closeIcon.Parent = closeButton

    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundTransparency = 0.1
    end)

    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundTransparency = 0.3
    end)

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Navigation sidebar in the left panel
    local navContainer = Instance.new("ScrollingFrame")
    navContainer.Name = "NavContainer"
    navContainer.Size = UDim2.new(1, -16, 1, -46)
    navContainer.Position = UDim2.new(0, 8, 0, 38)
    navContainer.BackgroundTransparency = 1
    navContainer.BorderSizePixel = 0
    navContainer.ScrollBarThickness = 3
    navContainer.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    navContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    navContainer.Parent = titleBar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 8)
    navLayout.FillDirection = Enum.FillDirection.Vertical
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    local navPadding = Instance.new("UIPadding")
    navPadding.PaddingTop = UDim.new(0, 6)
    navPadding.PaddingBottom = UDim.new(0, 6)
    navPadding.PaddingLeft = UDim.new(0, 2)
    navPadding.PaddingRight = UDim.new(0, 2)
    navPadding.Parent = navContainer

    -- Content area (right side)
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -208, 1, -16)
    contentContainer.Position = UDim2.new(0, 200, 0, 8)
    contentContainer.BackgroundColor3 = self.Settings.DefaultColors.BackgroundSecondary
    contentContainer.BackgroundTransparency = 0.25
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = contentContainer

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Container"
    scrollingFrame.Size = UDim2.new(1, -16, 1, -16)
    scrollingFrame.Position = UDim2.new(0, 8, 0, 8)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = contentContainer

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

    titleHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    titleHeader.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)

    -- Update canvas size when content changes
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    end)
    
    -- Update navigation canvas size
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 12)
    end)

    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame
    window.navContainer = navContainer
    window.pages = {}
    window.currentPage = nil

    -- Function to toggle window visibility
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

    -- Add page function for tabbed interface
    function window:AddPage(name, icon)
        local pageButton = Instance.new("TextButton")
        pageButton.Name = "PageButton_" .. name
        pageButton.Size = UDim2.new(1, -16, 0, 36)
        pageButton.BackgroundColor3 = self.currentPage == name and GuiLib.Settings.DefaultColors.Accent or GuiLib.Settings.DefaultColors.Button
        pageButton.BackgroundTransparency = 0.2
        pageButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        pageButton.Text = name
        pageButton.TextSize = 14
        pageButton.Font = GuiLib.Settings.FontSemibold
        pageButton.AutoButtonColor = false
        pageButton.Parent = self.navContainer

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        buttonCorner.Parent = pageButton
        
        -- Icon (optional)
        if icon then
            local iconLabel = Instance.new("TextLabel")
            iconLabel.Name = "Icon"
            iconLabel.Size = UDim2.new(0, 20, 0, 20)
            iconLabel.Position = UDim2.new(0, 8, 0.5, -10)
            iconLabel.BackgroundTransparency = 1
            iconLabel.TextColor3 = GuiLib.Settings.DefaultColors.Text
            iconLabel.Text = icon
            iconLabel.TextSize = 16
            iconLabel.Font = GuiLib.Settings.FontBold
            iconLabel.Parent = pageButton
            
            -- Adjust text position
            pageButton.Text = "    " .. name
            pageButton.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- Create page content frame
        local pageFrame = Instance.new("ScrollingFrame")
        pageFrame.Name = "Page_" .. name
        pageFrame.Size = UDim2.new(1, 0, 1, 0)
        pageFrame.BackgroundTransparency = 1
        pageFrame.BorderSizePixel = 0
        pageFrame.ScrollBarThickness = 4
        pageFrame.ScrollBarImageColor3 = GuiLib.Settings.DefaultColors.ScrollBar
        pageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        pageFrame.Visible = false
        pageFrame.Parent = self.container

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.FillDirection = Enum.FillDirection.Vertical
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = pageFrame

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 6)
        pagePadding.PaddingBottom = UDim.new(0, 6)
        pagePadding.PaddingLeft = UDim.new(0, 2)
        pagePadding.PaddingRight = UDim.new(0, 2)
        pagePadding.Parent = pageFrame

        -- Update canvas size when content changes
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pageFrame.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 12)
        end)

        -- Button hover/press effects
        pageButton.MouseEnter:Connect(function()
            if self.currentPage ~= name then
                pageButton.BackgroundTransparency = 0
                pageButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover
            end
        end)

        pageButton.MouseLeave:Connect(function()
            if self.currentPage ~= name then
                pageButton.BackgroundTransparency = 0.2
                pageButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
            end
        end)

        pageButton.MouseButton1Click:Connect(function()
            self:SelectPage(name)
        end)

        -- Add page to pages table
        self.pages[name] = {
            button = pageButton,
            frame = pageFrame
        }

        -- If this is the first page, select it
        if not self.currentPage then
            self:SelectPage(name)
        end

        -- Return page for chaining
        return pageFrame
    end

    -- Function to select a page
    function window:SelectPage(name)
        if not self.pages[name] then return end
        
        -- Hide all pages and reset button styles
        for pageName, page in pairs(self.pages) do
            page.frame.Visible = false
            page.button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
            page.button.BackgroundTransparency = 0.2
        end
        
        -- Show selected page and highlight button
        self.pages[name].frame.Visible = true
        self.pages[name].button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Accent
        self.pages[name].button.BackgroundTransparency = 0
        
        self.currentPage = name
    end

    -- Section function (unchanged, but returns parent for better chaining)
    function window:AddSection(title, parent)
        local container = parent or self.container
        
        local section = Instance.new("Frame")
        section.Name = "Section"
        section.Size = UDim2.new(1, -4, 0, 36)
        section.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        section.BackgroundTransparency = 0.35
        section.BorderSizePixel = 0
        section.Parent = container

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

        return section, container
    end

    -- Modified the element creation functions to take a parent parameter
    function window:AddLabel(text, parent)
        local container = parent or self.container
        
        local labelInstance = Instance.new("TextLabel")
        labelInstance.Name = "Label"
        labelInstance.Size = UDim2.new(1, -8, 0, 26)
        labelInstance.BackgroundTransparency = 1
        labelInstance.TextColor3 = GuiLib.Settings.DefaultColors.TextDimmed
        labelInstance.Text = text or "Label"
        labelInstance.TextSize = 14
        labelInstance.Font = GuiLib.Settings.FontRegular
        labelInstance.Parent = container

        local label = {
            Instance = labelInstance,
            SetText = function(self, newText)
                labelInstance.Text = newText
            end
        }

        return label
    end

    function window:AddButton(text, callback, parent)
        local container = parent or self.container
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, -8, 0, 36)
        button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        button.TextColor3 = GuiLib.Settings.DefaultColors.Text
        button.Text = text or "Button"
        button.TextSize = 14
        button.Font = GuiLib.Settings.FontSemibold
        button.AutoButtonColor = false
        button.Parent = container

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

    function window:AddToggle(text, default, callback, parent)
        local container = parent or self.container
        
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Name = "ToggleContainer"
        toggleContainer.Size = UDim2.new(1, -8, 0, 36)
        toggleContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        toggleContainer.BackgroundTransparency = 0.4
        toggleContainer.BorderSizePixel = 0
        toggleContainer.Parent = container

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

    function window:AddSlider(text, min, max, default, precision, callback, parent)
        local container = parent or self.container
        
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
        sliderContainer.Parent = container

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

    -- Include the rest of your element functions with the parent parameter here
    function window:AddDropdown(text, options, default, callback, parent)
        local container = parent or self.container
        
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, -8, 0, 66)
        dropdownContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        dropdownContainer.BackgroundTransparency = 0.4
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.Parent = container

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

    -- Return window for method chaining
    return window
end

-- Theme system remains unchanged
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

-- Keep the existing themes
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
    warn("Failed to initialize GuiLib: " .. tostring(result))
    return nil
end

local GuiLib = {}

-- Settings 
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

-- TweenService for advanced animations
local TweenService = game:GetService("TweenService")

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

    -- Creating a horizontal layout
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 650, 0, 300)
    mainFrame.Position = position or UDim2.new(0.5, -325, 0.5, -150)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    
    -- Appear with a scale animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local openTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = size or UDim2.new(0, 650, 0, 300)}
    )
    openTween:Play()

    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Settings.CornerRadius
    corner.Parent = mainFrame
    
    -- Add shadow with improved appearance
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 60, 1, 60)
    shadow.Position = UDim2.new(0, -30, 0, -30)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = self.Settings.DefaultColors.Shadow
    shadow.ImageTransparency = self.Settings.ShadowTransparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame
    
    -- Shadow tween
    local shadowTween = TweenService:Create(
        shadow,
        TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2),
        {ImageTransparency = self.Settings.ShadowTransparency}
    )
    shadowTween:Play()

    -- Title bar (top)
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
    
    -- Bottom corner fix
    local bottomFrameFix = Instance.new("Frame")
    bottomFrameFix.Name = "BottomFix"
    bottomFrameFix.Size = UDim2.new(1, 0, 0, 10)
    bottomFrameFix.Position = UDim2.new(0, 0, 1, -10)
    bottomFrameFix.BackgroundColor3 = self.Settings.DefaultColors.Title
    bottomFrameFix.BackgroundTransparency = self.Settings.DefaultTransparency
    bottomFrameFix.BorderSizePixel = 0
    bottomFrameFix.ZIndex = 1
    bottomFrameFix.Parent = titleBar
    
    -- Title decoration with pulse effect
    local titleIcon = Instance.new("Frame")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 8, 0, 16)
    titleIcon.Position = UDim2.new(0, 12, 0.5, -8)
    titleIcon.BackgroundColor3 = self.Settings.DefaultColors.Accent
    titleIcon.BorderSizePixel = 0
    titleIcon.Parent = titleBar
    
    -- Create a pulse animation for the title icon
    spawn(function()
        while true do
            local pulseTween = TweenService:Create(
                titleIcon,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
                {Size = UDim2.new(0, 8, 0, 20), BackgroundTransparency = 0.3}
            )
            pulseTween:Play()
            wait(3)
        end
    end)
    
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
    
    -- Create a typing effect for the title
    titleLabel.Text = ""
    spawn(function()
        local titleText = name or "GUI Library"
        for i = 1, #titleText do
            titleLabel.Text = string.sub(titleText, 1, i)
            wait(0.03)
        end
    end)
    
    -- Close and minimize buttons
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 26, 0, 26)
    closeButton.Position = UDim2.new(1, -32, 0, 6)
    closeButton.BackgroundColor3 = self.Settings.DefaultColors.ButtonDisabled
    closeButton.BackgroundTransparency = 0.3
    closeButton.Text = ""
    closeButton.AutoButtonColor = false
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    local closeIcon = Instance.new("TextLabel")
    closeIcon.Name = "CloseIcon"
    closeIcon.Size = UDim2.new(1, 0, 1, 0)
    closeIcon.BackgroundTransparency = 1
    closeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeIcon.Text = "×"
    closeIcon.TextSize = 18
    closeIcon.Font = self.Settings.FontBold
    closeIcon.Parent = closeButton
    
    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 26, 0, 26)
    minimizeButton.Position = UDim2.new(1, -64, 0, 6)
    minimizeButton.BackgroundColor3 = self.Settings.DefaultColors.Button
    minimizeButton.BackgroundTransparency = 0.3
    minimizeButton.Text = ""
    minimizeButton.AutoButtonColor = false
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeButton
    
    local minimizeIcon = Instance.new("TextLabel")
    minimizeIcon.Name = "MinimizeIcon"
    minimizeIcon.Size = UDim2.new(1, 0, 1, 0)
    minimizeIcon.BackgroundTransparency = 1
    minimizeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeIcon.Text = "-"
    minimizeIcon.TextSize = 18
    minimizeIcon.Font = self.Settings.FontBold
    minimizeIcon.Parent = minimizeButton
    
    -- Button animations with improved effects
    closeButton.MouseEnter:Connect(function()
        local buttonTween = TweenService:Create(
            closeButton, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
            {BackgroundTransparency = 0, Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -33, 0, 5)}
        )
        buttonTween:Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        local buttonTween = TweenService:Create(
            closeButton, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
            {BackgroundTransparency = 0.3, Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -32, 0, 6)}
        )
        buttonTween:Play()
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        local buttonTween = TweenService:Create(
            minimizeButton, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
            {BackgroundTransparency = 0, Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -65, 0, 5)}
        )
        buttonTween:Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        local buttonTween = TweenService:Create(
            minimizeButton, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quint), 
            {BackgroundTransparency = 0.3, Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -64, 0, 6)}
        )
        buttonTween:Play()
    end)
    
    -- Close animation and function
    closeButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(
            mainFrame, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        
        local fadeTween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        
        local shadowFadeTween = TweenService:Create(
            shadow,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageTransparency = 1}
        )
        
        closeTween:Play()
        fadeTween:Play()
        shadowFadeTween:Play()
        
        closeTween.Completed:Connect(function()
            wait(0.1)
            gui:Destroy()
        end)
    end)
    
    -- Minimize function
    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            local minTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, size.X.Offset, 0, 38)}
            )
            minTween:Play()
            minimizeIcon.Text = "+"
        else
            local expandTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = size or UDim2.new(0, 650, 0, 300)}
            )
            expandTween:Play()
            minimizeIcon.Text = "-"
        end
    end)
    
    -- Horizontal layout with sidebar and main content
    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Name = "SidebarFrame"
    sidebarFrame.Size = UDim2.new(0, 180, 1, -46)
    sidebarFrame.Position = UDim2.new(0, 8, 0, 38)
    sidebarFrame.BackgroundColor3 = self.Settings.DefaultColors.BackgroundSecondary
    sidebarFrame.BackgroundTransparency = 0.25
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.ClipsDescendants = true
    sidebarFrame.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = self.Settings.CornerRadius
    sidebarCorner.Parent = sidebarFrame
    
    -- Main content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -196, 1, -46)
    contentFrame.Position = UDim2.new(0, 188, 0, 38)
    contentFrame.BackgroundColor3 = self.Settings.DefaultColors.BackgroundSecondary
    contentFrame.BackgroundTransparency = 0.25
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = self.Settings.CornerRadius
    contentCorner.Parent = contentFrame
    
    -- Sidebar scroll frame with hover effect
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, -12, 1, -12)
    sidebarScroll.Position = UDim2.new(0, 6, 0, 6)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 3
    sidebarScroll.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.Parent = sidebarFrame
    
    -- Scrolling container with smoother padding
    local containerBorder = Instance.new("Frame")
    containerBorder.Name = "ContainerBorder"
    containerBorder.Size = UDim2.new(1, -12, 1, -12)
    containerBorder.Position = UDim2.new(0, 6, 0, 6)
    containerBorder.BackgroundTransparency = 1
    containerBorder.BorderSizePixel = 0
    containerBorder.Parent = contentFrame
    
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
    
    -- Auto layouts
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarScroll
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 6)
    sidebarPadding.PaddingBottom = UDim.new(0, 6)
    sidebarPadding.PaddingLeft = UDim.new(0, 2)
    sidebarPadding.PaddingRight = UDim.new(0, 2)
    sidebarPadding.Parent = sidebarScroll
    
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
    
    -- Add decorative logo/icon to sidebar
    local logoFrame = Instance.new("Frame")
    logoFrame.Name = "LogoFrame"
    logoFrame.Size = UDim2.new(1, -16, 0, 50)
    logoFrame.BackgroundColor3 = self.Settings.DefaultColors.Title
    logoFrame.BackgroundTransparency = 0.2
    logoFrame.BorderSizePixel = 0
    logoFrame.Parent = sidebarScroll
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = self.Settings.ElementCornerRadius
    logoCorner.Parent = logoFrame
    
    local logoAccent = Instance.new("Frame")
    logoAccent.Name = "LogoAccent"
    logoAccent.Size = UDim2.new(0, 4, 0, 30)
    logoAccent.Position = UDim2.new(0, 8, 0.5, -15)
    logoAccent.BackgroundColor3 = self.Settings.DefaultColors.Accent
    logoAccent.BorderSizePixel = 0
    logoAccent.Parent = logoFrame
    
    local logoAccentCorner = Instance.new("UICorner")
    logoAccentCorner.CornerRadius = UDim.new(0, 2)
    logoAccentCorner.Parent = logoAccent
    
    local logoText = Instance.new("TextLabel")
    logoText.Name = "LogoText"
    logoText.Size = UDim2.new(1, -50, 1, 0)
    logoText.Position = UDim2.new(0, 20, 0, 0)
    logoText.BackgroundTransparency = 1
    logoText.TextColor3 = self.Settings.DefaultColors.Text
    logoText.TextSize = 18
    logoText.Font = self.Settings.FontBold
    logoText.Text = "GUI Library"
    logoText.TextXAlignment = Enum.TextXAlignment.Left
    logoText.Parent = logoFrame
    
    -- Create pulsing effect for logo accent
    spawn(function()
        while true do
            local accentTween = TweenService:Create(
                logoAccent,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
                {BackgroundTransparency = 0.5, Size = UDim2.new(0, 4, 0, 35)}
            )
            accentTween:Play()
            wait(3)
        end
    end)

    -- Dragging for both PC and Mobile with improved smoothness
    local isDragging = false
    local dragStart, startPos
    local dragSpeed = 0.07 -- Smoothness factor (lower = smoother)
    local lastMousePos = Vector2.new(0, 0)
    local velocityX, velocityY = 0, 0
    
    local function updateDrag()
        if not isDragging then return end
        
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local delta = mousePos - dragStart
        
        -- Calculate velocity for inertia
        velocityX = mousePos.X - lastMousePos.X
        velocityY = mousePos.Y - lastMousePos.Y
        lastMousePos = mousePos
        
        -- Smooth movement
        local newPosition = UDim2.new(
            startPos.X.Scale, 
            Lerp(mainFrame.Position.X.Offset, startPos.X.Offset + delta.X, dragSpeed),
            startPos.Y.Scale, 
            Lerp(mainFrame.Position.Y.Offset, startPos.Y.Offset + delta.Y, dragSpeed)
        )
        
        mainFrame.Position = newPosition
    end
    
    -- Linear interpolation function for smooth dragging
    function Lerp(a, b, t)
        return a + (b - a) * t
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            lastMousePos = input.Position
            
            -- Add highlighting effect when dragging
            local highlightTween = TweenService:Create(
                titleBar,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0}
            )
            highlightTween:Play()
            
            -- Continuous update for smoother dragging
            spawn(function()
                while isDragging do
                    updateDrag()
                    game:GetService("RunService").RenderStepped:Wait()
                end
            end)
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            
            -- Add inertia effect
            spawn(function()
                for i = 1, 10 do
                    if not isDragging then
                        velocityX = velocityX * 0.9
                        velocityY = velocityY * 0.9
                        
                        mainFrame.Position = UDim2.new(
                            mainFrame.Position.X.Scale,
                            mainFrame.Position.X.Offset + velocityX * 0.5,
                            mainFrame.Position.Y.Scale,
                            mainFrame.Position.Y.Offset + velocityY * 0.5
                        )
                        
                        wait(0.02)
                    end
                end
            end)
            
            -- Remove highlighting effect
            local unhighlightTween = TweenService:Create(
                titleBar,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = self.Settings.DefaultTransparency}
            )
            unhighlightTween:Play()
        end
    end)

    -- Auto-update container sizes
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 12)
    end)
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    end)

    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame

    -- Add this method to your UI library class/module
    function window:ToggleState(visible)
        -- Check if visible is a boolean
        if type(visible) ~= "boolean" then
            error("ToggleState requires a boolean parameter (true or false)")
            return
        end
        
        -- Get the main frame
        local mainFrame = window.gui:FindFirstChild("MainFrame")
        if not mainFrame then
            warn("MainFrame not found")
            return
        end
        
        if visible then
            -- Show with animation
            local showTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = size or UDim2.new(0, 650, 0, 300), BackgroundTransparency = self.Settings.DefaultTransparency}
            )
            showTween:Play()
        else
            -- Hide with animation
            local hideTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 0), BackgroundTransparency = 1}
            )
            hideTween:Play()
        end
        
        -- Return the new state for chaining
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
        
        -- Add entrance animation
        section.BackgroundTransparency = 1
        local sectionTween = TweenService:Create(
            section,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.35}
        )
        sectionTween:Play()
        
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
        
        -- Add a nice hover effect
        section.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                section,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            
            local accentTween = TweenService:Create(
                sectionAccent,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 4, 0, 22)}
            )
            
            hoverTween:Play()
            accentTween:Play()
        end)
        
        section.MouseLeave:Connect(function()
            local unhoverTween = TweenService:Create(
                section,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.35}
            )
            
            local accentTween = TweenService:Create(
                sectionAccent,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 4, 0, 18)}
            )
            
            unhoverTween:Play()
            accentTween:Play()
        end)
        
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
        
        -- Add fade-in animation
        labelInstance.TextTransparency = 1
        local textTween = TweenService:Create(
            labelInstance,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        textTween:Play()
        
        -- Create a wrapper object
        local label = {
            Instance = labelInstance,
            SetText = function(self, newText)
                -- Animate text change
                local fadeOutTween = TweenService:Create(
                    labelInstance,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {TextTransparency = 1}
                )
                
                fadeOutTween:Play()
                fadeOutTween.Completed:Connect(function()
                    labelInstance.Text = newText
                    
                    local fadeInTween = TweenService:Create(
                        labelInstance,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {TextTransparency = 0}
                    )
                    fadeInTween:Play()
                end)
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
        
        -- Add entrance animation
        button.BackgroundTransparency = 1
        button.TextTransparency = 1
        
        local introTween = TweenService:Create(
            button,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0, TextTransparency = 0}
        )
        introTween:Play()
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        buttonCorner.Parent = button
        
        -- Add a glow effect
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = GuiLib.Settings.DefaultColors.Accent
        buttonStroke.Transparency = 0.9
        buttonStroke.Thickness = 1.5
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = button
        
        -- Animation effects with improved tweens
        button.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                button,
                TweenInfo.new(0.3, Enum.EasingStyle.Back),
                {
                    BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover,
                    Size = UDim2.new(1, 0, 0, 36)
                }
            )
            
            local strokeTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.7}
            )
            
            hoverTween:Play()
            strokeTween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local unhoverTween = TweenService:Create(
                button,
                TweenInfo.new(0.3, Enum.EasingStyle.Back),
                {
                    BackgroundColor3 = GuiLib.Settings.DefaultColors.Button,
                    Size = UDim2.new(1, -8, 0, 36)
                }
            )
            
            local strokeTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.9}
            )
            
            unhoverTween:Play()
            strokeTween:Play()
        end)
        
        button.MouseButton1Down:Connect(function()
            local pressTween = TweenService:Create(
                button,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {
                    BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonPressed,
                    Size = UDim2.new(1, -16, 0, 36)
                }
            )
            
            local strokeTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {Transparency = 0.5}
            )
            
            pressTween:Play()
            strokeTween:Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            local releaseTween = TweenService:Create(
                button,
                TweenInfo.new(0.15, Enum.EasingStyle.Back),
                {
                    BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover,
                    Size = UDim2.new(1, 0, 0, 36)
                }
            )
            
            local strokeTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {Transparency = 0.7}
            )
            
            releaseTween:Play()
            strokeTween:Play()
        end)
        
        button.MouseButton1Click:Connect(function()
            -- Add a ripple effect when clicked
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.7
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Parent = button
            
            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple
            
            local rippleTween = TweenService:Create(
                ripple,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(2, 0, 2, 0)
                }
            )
            
            rippleTween:Play()
            rippleTween.Completed:Connect(function()
                ripple:Destroy()
            end)
            
            if callback then
                callback()
            end
        end)
        
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
        
        -- Entrance animation
        toggleContainer.BackgroundTransparency = 1
        local fadeInTween = TweenService:Create(
            toggleContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.4}
        )
        fadeInTween:Play()
        
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
        label.TextTransparency = 1
        label.Parent = toggleContainer
        
        -- Text fade in
        local textTween = TweenService:Create(
            label,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        textTween:Play()
        
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
                -- Smooth advanced animations
                local bgTween = TweenService:Create(
                    toggleButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quint),
                    {BackgroundColor3 = GuiLib.Settings.DefaultColors.ToggleEnabled}
                )
                
                local positionTween = TweenService:Create(
                    toggleIndicator,
                    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0, 23, 0.5, -9)}
                )
                
                -- Add a slight scale bounce effect
                local scaleTween = TweenService:Create(
                    toggleIndicator,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Size = UDim2.new(0, 20, 0, 20)}
                )
                
                local scaleDownTween = TweenService:Create(
                    toggleIndicator,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2),
                    {Size = UDim2.new(0, 18, 0, 18)}
                )
                
                bgTween:Play()
                positionTween:Play()
                scaleTween:Play()
                scaleDownTween:Play()
            else
                local bgTween = TweenService:Create(
                    toggleButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quint),
                    {BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle}
                )
                
                local positionTween = TweenService:Create(
                    toggleIndicator,
                    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0, 3, 0.5, -9)}
                )
                
                -- Add a slight scale bounce effect
                local scaleTween = TweenService:Create(
                    toggleIndicator,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Size = UDim2.new(0, 20, 0, 20)}
                )
                
                local scaleDownTween = TweenService:Create(
                    toggleIndicator,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2),
                    {Size = UDim2.new(0, 18, 0, 18)}
                )
                
                bgTween:Play()
                positionTween:Play()
                scaleTween:Play()
                scaleDownTween:Play()
            end
        end
        
        updateVisuals()
        
        -- Hover effect with improved animations
        clickArea.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                toggleContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            hoverTween:Play()
        end)
        
        clickArea.MouseLeave:Connect(function()
            local unhoverTween = TweenService:Create(
                toggleContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.4}
            )
            unhoverTween:Play()
        end)
        
        clickArea.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            updateVisuals()
            
            -- Add click ripple effect
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.7
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Parent = toggleContainer
            
            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple
            
            local rippleTween = TweenService:Create(
                ripple,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1.5, 0, 1.5, 0), BackgroundTransparency = 1}
            )
            
            rippleTween:Play()
            rippleTween.Completed:Connect(function()
                ripple:Destroy()
            end)
            
            if callback then
                callback(isEnabled)
            end
        end)
        
        local toggleFunctions = {}
        
        function toggleFunctions:Set(value)
            if type(value) == "boolean" and value ~= isEnabled then
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
        
        -- Entrance animation
        sliderContainer.BackgroundTransparency = 1
        local containerTween = TweenService:Create(
            sliderContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.4}
        )
        containerTween:Play()
        
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
        label.TextTransparency = 1
        label.Parent = sliderContainer
        
        -- Text fade in
        local textTween = TweenService:Create(
            label,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        textTween:Play()
        
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
        valueDisplay.TextTransparency = 1
        valueDisplay.Parent = sliderContainer
        
        -- Value display fade in
        local valueTween = TweenService:Create(
            valueDisplay,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        valueTween:Play()
        
        -- Change to TextButton to capture input on mobile
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
        sliderFill.Size = UDim2.new(0, 0, 1, 0) -- Start at 0
        sliderFill.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBarContainer
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Size = UDim2.new(0, 18, 0, 18)
        sliderButton.Position = UDim2.new(0, 0, 0.5, 0)
        sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderButton.Text = ""
        sliderButton.Parent = sliderBarContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0)
        buttonCorner.Parent = sliderButton
        
        -- Add a glow effect to the button
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonStroke.Transparency = 0.7
        buttonStroke.Thickness = 1.5
        buttonStroke.Parent = sliderButton
        
        -- Animate the slider to its initial position
        local initPercent = (default - min) / (max - min)
        local initTween = TweenService:Create(
            sliderFill,
            TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = UDim2.new(initPercent, 0, 1, 0)}
        )
        
        local buttonTween = TweenService:Create(
            sliderButton,
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(initPercent, 0, 0.5, 0)}
        )
        
        initTween:Play()
        buttonTween:Play()
        
        local function updateSlider(value)
            local newValue = math.clamp(value, min, max)
            if precision then
                newValue = math.floor(newValue / precision) * precision
            end
            
            local percent = (newValue - min) / (max - min)
            
            -- Smooth transitions
            local fillTween = TweenService:Create(
                sliderFill,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Size = UDim2.new(percent, 0, 1, 0)}
            )
            
            local positionTween = TweenService:Create(
                sliderButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Position = UDim2.new(percent, 0, 0.5, 0)}
            )
            
            fillTween:Play()
            positionTween:Play()
            
            -- Animate value display change
            local oldValue = valueDisplay.Text
            local fadeTween = TweenService:Create(
                valueDisplay,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {TextTransparency = 1}
            )
            
            fadeTween:Play()
            fadeTween.Completed:Connect(function()
                valueDisplay.Text = tostring(newValue)
                
                local fadeInTween = TweenService:Create(
                    valueDisplay,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                    {TextTransparency = 0}
                )
                fadeInTween:Play()
            end)
            
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
            local barPos = sliderBarContainer.AbsolutePosition.X
            local barWidth = sliderBarContainer.AbsoluteSize.X
            local percent = math.clamp((inputPosition.X - barPos) / barWidth, 0, 1)
            return min + (max - min) * percent
        end
        
        -- Hover and pressed effects with improved animations
        sliderButton.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                sliderButton,
                TweenInfo.new(0.3, Enum.EasingStyle.Back),
                {Size = UDim2.new(0, 22, 0, 22)}
            )
            
            local strokeTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.5}
            )
            
            hoverTween:Play()
            strokeTween:Play()
        end)
        
        sliderButton.MouseLeave:Connect(function()
            if not dragging then
                local leaveTween = TweenService:Create(
                    sliderButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back),
                    {Size = UDim2.new(0, 18, 0, 18)}
                )
                
                local strokeTween = TweenService:Create(
                    buttonStroke,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                    {Transparency = 0.7}
                )
                
                leaveTween:Play()
                strokeTween:Play()
            end
        end)
        
        -- Handle initial press (both mouse and touch)
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                local pressTween = TweenService:Create(
                    sliderButton,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Size = UDim2.new(0, 24, 0, 24)}
                )
                
                local strokeTween = TweenService:Create(
                    buttonStroke,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Transparency = 0.3}
                )
                
                pressTween:Play()
                strokeTween:Play()
            end
        end)
        
        -- Handle bar click/tap (both mouse and touch)
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                local pressTween = TweenService:Create(
                    sliderButton,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Size = UDim2.new(0, 24, 0, 24)}
                )
                
                local strokeTween = TweenService:Create(
                    buttonStroke,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Transparency = 0.3}
                )
                
                pressTween:Play()
                strokeTween:Play()
                
                currentValue = updateSlider(calculateValueFromPosition(input.Position))
            end
        end)
        
        -- Handle input ending (both mouse and touch)
        userInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                input.UserInputType == Enum.UserInputType.Touch) and dragging then
                dragging = false
                
                local releaseTween = TweenService:Create(
                    sliderButton,
                    TweenInfo.new(0.2, Enum.EasingStyle.Back),
                    {Size = UDim2.new(0, 18, 0, 18)}
                )
                
                local strokeTween = TweenService:Create(
                    buttonStroke,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {Transparency = 0.7}
                )
                
                releaseTween:Play()
                strokeTween:Play()
            end
        end)
        
        -- Handle drag movement (both mouse and touch) with improved smoothness
        userInputService.InputChanged:Connect(function(input)
            if dragging and 
               (input.UserInputType == Enum.UserInputType.MouseMovement or 
                input.UserInputType == Enum.UserInputType.Touch) then
                currentValue = updateSlider(calculateValueFromPosition(input.Position))
            end
        end)
        
        -- Hover effect for container
        sliderContainer.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                sliderContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            hoverTween:Play()
        end)
        
        sliderContainer.MouseLeave:Connect(function()
            local leaveTween = TweenService:Create(
                sliderContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.4}
            )
            leaveTween:Play()
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
        
        -- Entrance animation
        dropdownContainer.BackgroundTransparency = 1
        local containerTween = TweenService:Create(
            dropdownContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.4}
        )
        containerTween:Play()
        
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
        label.TextTransparency = 1
        label.Parent = dropdownContainer
        
        -- Text fade in
        local textTween = TweenService:Create(
            label,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        textTween:Play()
        
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
        dropButton.TextTransparency = 1 -- For animation
        dropButton.BackgroundTransparency = 1 -- For animation
        dropButton.Parent = dropdownContainer
        
        -- Button fade in
        local buttonTween = TweenService:Create(
            dropButton,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0, BackgroundTransparency = 0}
        )
        buttonTween:Play()
        
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
        icon.TextTransparency = 1
        icon.Parent = dropButton
        
        -- Icon fade in
        local iconTween = TweenService:Create(
            icon,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        iconTween:Play()
        
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
        
        -- Add a button glow effect
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = GuiLib.Settings.DefaultColors.Accent
        buttonStroke.Transparency = 0.9
        buttonStroke.Thickness = 1.5
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = dropButton
        
        -- Improved hover effects with tweens
        dropButton.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.7}
            )
            
            local bgTween = TweenService:Create(
                dropButton,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 10, 255),
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 10, 255),
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 10, 255)
                    )
                }
            )
            
            hoverTween:Play()
            bgTween:Play()
        end)
        
        dropButton.MouseLeave:Connect(function()
            local unhoverTween = TweenService:Create(
                buttonStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.9}
            )
            
            local bgTween = TweenService:Create(
                dropButton,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown}
            )
            
            unhoverTween:Play()
            bgTween:Play()
        end)
        
        local function toggleDropdown()
            isOpen = not isOpen
            
            if isOpen then
                -- Rotate icon
                local iconTween = TweenService:Create(
                    icon,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back),
                    {Rotation = 180}
                )
                iconTween:Play()
                
                dropFrame.Visible = true
                
                local optionsHeight = #options * 34 + (#options - 1) * 4
                optionsHeight = math.min(optionsHeight, 150) -- Max height
                
                -- Expand the container to accommodate the dropdown
                local expandTween = TweenService:Create(
                    dropdownContainer,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quint),
                    {Size = UDim2.new(1, -8, 0, 66 + optionsHeight)}
                )
                
                local dropFrameTween = TweenService:Create(
                    dropFrame,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quint),
                    {Size = UDim2.new(1, 0, 0, optionsHeight)}
                )
                
                expandTween:Play()
                dropFrameTween:Play()
                
                optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 34 + (#options - 1) * 4)
            else
                -- Rotate icon back
                local iconTween = TweenService:Create(
                    icon,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back),
                    {Rotation = 0}
                )
                iconTween:Play()
                
                -- Collapse back to original size
                local collapseTween = TweenService:Create(
                    dropdownContainer,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quint),
                    {Size = UDim2.new(1, -8, 0, 66)}
                )
                
                local dropFrameTween = TweenService:Create(
                    dropFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quint),
                    {Size = UDim2.new(1, 0, 0, 0)}
                )
                
                collapseTween:Play()
                dropFrameTween:Play()
                
                dropFrameTween.Completed:Connect(function()
                    if not isOpen then -- Check again in case it was reopened
                        dropFrame.Visible = false
                    end
                end)
            end
        end
        
        dropButton.MouseButton1Click:Connect(toggleDropdown)
        
        -- Create option buttons with animations
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
                
                -- Option hover effect with tweens
                optionButton.MouseEnter:Connect(function()
                    local hoverTween = TweenService:Create(
                        optionButton,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                        {BackgroundTransparency = 0, BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover}
                    )
                    hoverTween:Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    local unhoverTween = TweenService:Create(
                        optionButton,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                        {BackgroundTransparency = 0.2, BackgroundColor3 = GuiLib.Settings.DefaultColors.Button}
                    )
                    unhoverTween:Play()
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    
                    -- Animate text change
                    local textFadeTween = TweenService:Create(
                        dropButton,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {TextTransparency = 1}
                    )
                    
                    textFadeTween:Play()
                    textFadeTween.Completed:Connect(function()
                        dropButton.Text = option
                        
                        local textShowTween = TweenService:Create(
                            dropButton,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                            {TextTransparency = 0}
                        )
                        textShowTween:Play()
                    end)
                    
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
        
        -- Container hover effect
        dropdownContainer.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(
                dropdownContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            hoverTween:Play()
        end)
        
        dropdownContainer.MouseLeave:Connect(function()
            if not isOpen then
                local unhoverTween = TweenService:Create(
                    dropdownContainer,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                    {BackgroundTransparency = 0.4}
                )
                unhoverTween:Play()
            end
        end)
        
        local dropdownFunctions = {}
        
        function dropdownFunctions:Set(option)
            if table.find(options, option) then
                selectedOption = option
                
                -- Animate text change
                local textFadeTween = TweenService:Create(
                    dropButton,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {TextTransparency = 1}
                )
                
                textFadeTween:Play()
                textFadeTween.Completed:Connect(function()
                    dropButton.Text = option
                    
                    local textShowTween = TweenService:Create(
                        dropButton,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {TextTransparency = 0}
                    )
                    textShowTween:Play()
                end)
                
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
            
            -- Clear existing options with animation
            for _, child in ipairs(optionList:GetChildren()) do
                if child:IsA("TextButton") then
                    local fadeTween = TweenService:Create(
                        child,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {BackgroundTransparency = 1, TextTransparency = 1}
                    )
                    
                    fadeTween:Play()
                    fadeTween.Completed:Connect(function()
                        child:Destroy()
                    end)
                end
            end
            
            -- Wait for animations to complete
            wait(0.25)
            
            -- Create new option buttons with animations
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. option
                optionButton.Size = UDim2.new(1, -8, 0, 30)
                optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                optionButton.BackgroundTransparency = 1 -- Start transparent for animation
                optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
                optionButton.Text = option
                optionButton.TextSize = 14
                optionButton.TextTransparency = 1 -- Start transparent for animation
                optionButton.Font = GuiLib.Settings.FontRegular
                optionButton.ZIndex = 7
                optionButton.AutoButtonColor = false
                optionButton.Parent = optionList
                
                -- Fade in animation
                local appearTween = TweenService:Create(
                    optionButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                    {BackgroundTransparency = 0.2, TextTransparency = 0}
                )
                appearTween:Play()
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                optionCorner.Parent = optionButton
                
                -- Option hover effect
                optionButton.MouseEnter:Connect(function()
                    local hoverTween = TweenService:Create(
                        optionButton,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                        {BackgroundTransparency = 0, BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover}
                    )
                    hoverTween:Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    local unhoverTween = TweenService:Create(
                        optionButton,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                        {BackgroundTransparency = 0.2, BackgroundColor3 = GuiLib.Settings.DefaultColors.Button}
                    )
                    unhoverTween:Play()
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    
                    -- Animate text change
                    local textFadeTween = TweenService:Create(
                        dropButton,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {TextTransparency = 1}
                    )
                    
                    textFadeTween:Play()
                    textFadeTween.Completed:Connect(function()
                        dropButton.Text = option
                        
                        local textShowTween = TweenService:Create(
                            dropButton,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                            {TextTransparency = 0}
                        )
                        textShowTween:Play()
                    end)
                    
                    toggleDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 34 + (#options - 1) * 4)
            
            if not keepSelection or not table.find(options, selectedOption) then
                selectedOption = options[1] or "Select"
                
                -- Animate text change
                local textFadeTween = TweenService:Create(
                    dropButton,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {TextTransparency = 1}
                )
                
                textFadeTween:Play()
                textFadeTween.Completed:Connect(function()
                    dropButton.Text = selectedOption
                    
                    local textShowTween = TweenService:Create(
                        dropButton,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                        {TextTransparency = 0}
                    )
                    textShowTween:Play()
                end)
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
        
        -- Entrance animation
        colorPickerContainer.BackgroundTransparency = 1
        local containerTween = TweenService:Create(
            colorPickerContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.4}
        )
        containerTween:Play()
        
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
        label.TextTransparency = 1
        label.Parent = colorPickerContainer
        
        -- Text fade in
        local textTween = TweenService:Create(
            label,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        textTween:Play()
        
        local colorDisplay = Instance.new("Frame")
        colorDisplay.Name = "ColorDisplay"
        colorDisplay.Size = UDim2.new(0, 36, 0, 26)
        colorDisplay.Position = UDim2.new(1, -46, 0.5, -13)
        colorDisplay.BackgroundColor3 = default
        colorDisplay.BorderSizePixel = 0
        colorDisplay.BackgroundTransparency = 1 -- For animation
        colorDisplay.Parent = colorPickerContainer
        
        -- Color display fade in
        local displayTween = TweenService:Create(
            colorDisplay,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0}
        )
        displayTween:Play()
        
        local displayCorner = Instance.new("UICorner")
        displayCorner.CornerRadius = UDim.new(0, 4)
        displayCorner.Parent = colorDisplay
        
        -- Add a stroke to the color display
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
        
        -- Color picker functionality with improved animations
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
        
        -- Add a title to the picker
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
        
        -- Hue selector
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
        
        -- Color saturation/value picker
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
        
        -- Add a circle inside the selector
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
        
        -- Add current color display
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
        
        -- Hover effect for color display with improved animations
        clickButton.MouseEnter:Connect(function()
            local strokeTween = TweenService:Create(
                displayStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.5}
            )
            
            local containerTween = TweenService:Create(
                colorPickerContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            
            strokeTween:Play()
            containerTween:Play()
        end)
        
        clickButton.MouseLeave:Connect(function()
            local strokeTween = TweenService:Create(
                displayStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.8}
            )
            
            local containerTween = TweenService:Create(
                colorPickerContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.4}
            )
            
            strokeTween:Play()
            containerTween:Play()
        end)
        
        -- Logic and functionality
        local pickerOpen = false
        local selectedColor = default
        local hue, saturation, value = 0, 0, 1
        
        local function updateColor()
            local hsv = Color3.fromHSV(hue, saturation, value)
            
            -- Animate color changes
            local colorTween = TweenService:Create(
                colorDisplay,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = hsv}
            )
            
            local currentColorTween = TweenService:Create(
                currentColorDisplay,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = hsv}
            )
            
            colorTween:Play()
            currentColorTween:Play()
            
            colorField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            
            if callback then
                callback(hsv)
            end
            
            return hsv
        end
        
        local function updateSelectors()
            -- Update hue selector position with animation
            local hueTween = TweenService:Create(
                hueSelector,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Position = UDim2.new(hue, -3, 0, -3)}
            )
            hueTween:Play()
            
            -- Update color selector position with animation
            local selectorTween = TweenService:Create(
                colorSelector,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Position = UDim2.new(saturation, 0, 1 - value, 0)}
            )
            selectorTween:Play()
            
            -- Update the color
            selectedColor = updateColor()
        end
        
        local function togglePicker()
            pickerOpen = not pickerOpen
            
            if pickerOpen then
                -- Show the picker with animation
                pickerFrame.Size = UDim2.new(0, 220, 0, 0)
                pickerFrame.Visible = true
                pickerFrame.BackgroundTransparency = 1
                
                local expandTween = TweenService:Create(
                    pickerFrame,
                    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 220, 0, 240), BackgroundTransparency = 0.1}
                )
                expandTween:Play()
            else
                -- Hide the picker with animation
                local collapseTween = TweenService:Create(
                    pickerFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {Size = UDim2.new(0, 220, 0, 0), BackgroundTransparency = 1}
                )
                
                collapseTween:Play()
                collapseTween.Completed:Connect(function()
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
        
        -- Event handlers with improved interactivity
        clickButton.MouseButton1Click:Connect(function()
            togglePicker()
            
            -- Add click ripple effect
            local ripple = Instance.new("Frame")
            ripple.Name = "Ripple"
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.7
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Parent = colorDisplay
            
            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple
            
            local rippleTween = TweenService:Create(
                ripple,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}
            )
            
            rippleTween:Play()
            rippleTween.Completed:Connect(function()
                ripple:Destroy()
            end)
        end)
        
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
                
                -- Add a pulse effect to the selector
                local pulseTween = TweenService:Create(
                    selectorInner,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true),
                    {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0.5, -4, 0.5, -4)}
                )
                pulseTween:Play()
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
        local textBoxContainer = Instance.new("Frame")
        textBoxContainer.Name = "TextBoxContainer"
        textBoxContainer.Size = UDim2.new(1, -8, 0, 66)
        textBoxContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        textBoxContainer.BackgroundTransparency = 0.4
        textBoxContainer.BorderSizePixel = 0
        textBoxContainer.Parent = self.container
        
        -- Entrance animation
        textBoxContainer.BackgroundTransparency = 1
        local containerTween = TweenService:Create(
            textBoxContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.4}
        )
        containerTween:Play()
        
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
        label.TextTransparency = 1
        label.Parent = textBoxContainer
        
        -- Text fade in
        local textTween = TweenService:Create(
            label,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        )
        textTween:Play()
        
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
        inputBox.TextTransparency = 1
        inputBox.BackgroundTransparency = 1
        inputBox.Parent = textBoxContainer
        
        -- Input box fade in
        local boxTween = TweenService:Create(
            inputBox,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad),
            {TextTransparency = 0, BackgroundTransparency = 0}
        )
        boxTween:Play()
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        boxCorner.Parent = inputBox
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.Parent = inputBox
        
        -- Add a glow effect
        local boxStroke = Instance.new("UIStroke")
        boxStroke.Name = "BoxStroke"
        boxStroke.Color = GuiLib.Settings.DefaultColors.Accent
        boxStroke.Transparency = 0.9
        boxStroke.Thickness = 1.5
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxStroke.Parent = inputBox
        
        -- Add focused effect with advanced animations
        inputBox.Focused:Connect(function()
            local focusTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 15, 255),
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 15, 255),
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 15, 255)
                    )
                }
            )
            
            local strokeTween = TweenService:Create(
                boxStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.5, Thickness = 2}
            )
            
            -- Slightly increase size for focus effect
            local sizeTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Back),
                {Size = UDim2.new(1, -28, 0, 36)}
            )
            
            focusTween:Play()
            strokeTween:Play()
            sizeTween:Play()
        end)
        
        inputBox.FocusLost:Connect(function(enterPressed)
            local unfocusTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown}
            )
            
            local strokeTween = TweenService:Create(
                boxStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.9, Thickness = 1.5}
            )
            
            -- Return to original size
            local sizeTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Back),
                {Size = UDim2.new(1, -32, 0, 36)}
            )
            
            unfocusTween:Play()
            strokeTween:Play()
            sizeTween:Play()
            
            if enterPressed and callback then
                callback(inputBox.Text)
                
                -- Add a confirmation effect
                local flash = Instance.new("Frame")
                flash.Size = UDim2.new(1, 0, 1, 0)
                flash.BackgroundColor3 = GuiLib.Settings.DefaultColors.Accent
                flash.BackgroundTransparency = 0.7
                flash.BorderSizePixel = 0
                flash.ZIndex = 2
                flash.Parent = inputBox
                
                local flashCorner = Instance.new("UICorner") 
                flashCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                flashCorner.Parent = flash
                
                local flashTween = TweenService:Create(
                    flash,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad),
                    {BackgroundTransparency = 1}
                )
                
                flashTween:Play()
                flashTween.Completed:Connect(function()
                    flash:Destroy()
                end)
            end
        end)
        
        -- Hover effect
        inputBox.MouseEnter:Connect(function()
            if inputBox:IsFocused() then return end
            
            local hoverTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 5, 255),
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 5, 255),
                        math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 5, 255)
                    )
                }
            )
            
            local strokeTween = TweenService:Create(
                boxStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.7}
            )
            
            hoverTween:Play()
            strokeTween:Play()
        end)
        
        inputBox.MouseLeave:Connect(function()
            if inputBox:IsFocused() then return end
            
            local unhoverTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown}
            )
            
            local strokeTween = TweenService:Create(
                boxStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {Transparency = 0.9}
            )
            
            unhoverTween:Play()
            strokeTween:Play()
        end)
        
        -- Container hover effect
        textBoxContainer.MouseEnter:Connect(function()
            if inputBox:IsFocused() then return end
            
            local hoverTween = TweenService:Create(
                textBoxContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            
            hoverTween:Play()
        end)
        
        textBoxContainer.MouseLeave:Connect(function()
            if inputBox:IsFocused() then return end
            
            local unhoverTween = TweenService:Create(
                textBoxContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.4}
            )
            
            unhoverTween:Play()
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
            -- Animate text change
            local fadeTween = TweenService:Create(
                inputBox,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {TextTransparency = 1}
            )
            
            fadeTween:Play()
            fadeTween.Completed:Connect(function()
                inputBox.Text = text or ""
                
                local showTween = TweenService:Create(
                    inputBox,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {TextTransparency = 0}
                )
                
                showTween:Play()
            end)
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
            Text = Color3.fromRGB(235, 235, 240),
            TextDimmed = Color3.fromRGB(160, 160, 170),
            Accent = Color3.fromRGB(90, 110, 255),
            AccentDark = Color3.fromRGB(70, 90, 220),
            Slider = Color3.fromRGB(60, 60, 70),
            SliderFill = Color3.fromRGB(90, 110, 255),
            Toggle = Color3.fromRGB(45, 45, 55),
            ToggleEnabled = Color3.fromRGB(90, 110, 255),
            Dropdown = Color3.fromRGB(45, 45, 55),
            ScrollBar = Color3.fromRGB(65, 65, 75),
            Shadow = Color3.fromRGB(0, 0, 0)
        }
    },
    NeonNight = {
        DefaultColors = {
            Background = Color3.fromRGB(10, 10, 20),
            BackgroundSecondary = Color3.fromRGB(20, 20, 35),
            Title = Color3.fromRGB(15, 15, 25),
            Button = Color3.fromRGB(30, 30, 45),
            ButtonHover = Color3.fromRGB(50, 50, 80),
            ButtonPressed = Color3.fromRGB(20, 20, 35),
            ButtonEnabled = Color3.fromRGB(255, 0, 200),
            ButtonDisabled = Color3.fromRGB(120, 30, 60),
            Text = Color3.fromRGB(255, 255, 255),
            TextDimmed = Color3.fromRGB(170, 170, 190),
            Accent = Color3.fromRGB(0, 255, 200),
            AccentDark = Color3.fromRGB(0, 200, 160),
            Slider = Color3.fromRGB(25, 25, 35),
            SliderFill = Color3.fromRGB(0, 255, 200),
            Toggle = Color3.fromRGB(40, 40, 60),
            ToggleEnabled = Color3.fromRGB(255, 0, 200),
            Dropdown = Color3.fromRGB(35, 35, 50),
            ScrollBar = Color3.fromRGB(60, 60, 90),
            Shadow = Color3.fromRGB(5, 0, 10)
        }
    },
    PastelDream = {
        DefaultColors = {
            Background = Color3.fromRGB(250, 240, 245),
            BackgroundSecondary = Color3.fromRGB(240, 225, 230),
            Title = Color3.fromRGB(230, 200, 210),
            Button = Color3.fromRGB(220, 180, 200),
            ButtonHover = Color3.fromRGB(235, 200, 215),
            ButtonPressed = Color3.fromRGB(210, 170, 190),
            ButtonEnabled = Color3.fromRGB(180, 240, 190),
            ButtonDisabled = Color3.fromRGB(250, 140, 140),
            Text = Color3.fromRGB(70, 50, 60),
            TextDimmed = Color3.fromRGB(120, 100, 110),
            Accent = Color3.fromRGB(180, 140, 255),
            AccentDark = Color3.fromRGB(140, 100, 220),
            Slider = Color3.fromRGB(200, 180, 200),
            SliderFill = Color3.fromRGB(180, 140, 255),
            Toggle = Color3.fromRGB(220, 180, 200),
            ToggleEnabled = Color3.fromRGB(180, 140, 255),
            Dropdown = Color3.fromRGB(230, 190, 210),
            ScrollBar = Color3.fromRGB(200, 160, 190),
            Shadow = Color3.fromRGB(150, 120, 150)
        }
    },
    Terminal = {
        DefaultColors = {
            Background = Color3.fromRGB(0, 0, 0),
            BackgroundSecondary = Color3.fromRGB(10, 10, 10),
            Title = Color3.fromRGB(0, 0, 0),
            Button = Color3.fromRGB(20, 20, 20),
            ButtonHover = Color3.fromRGB(30, 30, 30),
            ButtonPressed = Color3.fromRGB(10, 10, 10),
            ButtonEnabled = Color3.fromRGB(0, 255, 0),
            ButtonDisabled = Color3.fromRGB(120, 0, 0),
            Text = Color3.fromRGB(0, 255, 0),
            TextDimmed = Color3.fromRGB(0, 120, 0),
            Accent = Color3.fromRGB(0, 255, 0),
            AccentDark = Color3.fromRGB(0, 180, 0),
            Slider = Color3.fromRGB(20, 20, 20),
            SliderFill = Color3.fromRGB(0, 255, 0),
            Toggle = Color3.fromRGB(10, 10, 10),
            ToggleEnabled = Color3.fromRGB(0, 255, 0),
            Dropdown = Color3.fromRGB(20, 20, 20),
            ScrollBar = Color3.fromRGB(40, 40, 40),
            Shadow = Color3.fromRGB(0, 0, 0)
        }
    },
    Solar = {
        DefaultColors = {
            Background = Color3.fromRGB(255, 252, 240),
            BackgroundSecondary = Color3.fromRGB(255, 247, 230),
            Title = Color3.fromRGB(255, 236, 200),
            Button = Color3.fromRGB(255, 220, 180),
            ButtonHover = Color3.fromRGB(255, 230, 190),
            ButtonPressed = Color3.fromRGB(245, 210, 170),
            ButtonEnabled = Color3.fromRGB(100, 200, 150),
            ButtonDisabled = Color3.fromRGB(240, 100, 100),
            Text = Color3.fromRGB(40, 30, 20),
            TextDimmed = Color3.fromRGB(100, 80, 60),
            Accent = Color3.fromRGB(255, 160, 70),
            AccentDark = Color3.fromRGB(240, 140, 50),
            Slider = Color3.fromRGB(255, 230, 190),
            SliderFill = Color3.fromRGB(255, 160, 70),
            Toggle = Color3.fromRGB(255, 220, 180),
            ToggleEnabled = Color3.fromRGB(255, 160, 70),
            Dropdown = Color3.fromRGB(250, 215, 170),
            ScrollBar = Color3.fromRGB(220, 190, 140),
            Shadow = Color3.fromRGB(200, 180, 120)
        }
    }
}

return GuiLib

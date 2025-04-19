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
    EasingDirection = Enum.EasingDirection.Out,
    TweenDuration = {
        Short = 0.15,
        Medium = 0.25,
        Long = 0.4
    },
    Spring = {
        Damping = 0.8,
        Frequency = 3,
        Initial = 0,
        Velocity = 0
    }
}

-- Enhanced tweening utility functions
local TweenService = game:GetService("TweenService")
local function TweenElement(element, properties, duration, easingStyle, easingDirection, delay)
    local tweenInfo = TweenInfo.new(
        duration or GuiLib.Settings.TweenDuration.Medium,
        easingStyle or GuiLib.Settings.Easing,
        easingDirection or GuiLib.Settings.EasingDirection,
        0, -- RepeatCount
        false, -- Reverses
        delay or 0 -- DelayTime
    )
    
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

local function SpringTween(element, properties, dampingRatio, frequency, delay)
    local tweenInfo = TweenInfo.new(
        GuiLib.Settings.TweenDuration.Medium,
        Enum.EasingStyle.Spring,
        Enum.EasingDirection.Out,
        0, -- RepeatCount
        false, -- Reverses
        delay or 0, -- DelayTime
        dampingRatio or GuiLib.Settings.Spring.Damping,
        frequency or GuiLib.Settings.Spring.Frequency
    )
    
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

local function BounceIn(element, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or GuiLib.Settings.TweenDuration.Medium,
        Enum.EasingStyle.Bounce,
        Enum.EasingDirection.Out,
        0, -- RepeatCount
        false, -- Reverses
        0 -- DelayTime
    )
    
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

local function ElasticOut(element, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or GuiLib.Settings.TweenDuration.Medium,
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out,
        0, -- RepeatCount
        false, -- Reverses
        0 -- DelayTime
    )
    
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

local function SequenceTween(element, properties, durations)
    local tweens = {}
    for i, propertySet in ipairs(properties) do
        local duration = durations[i] or GuiLib.Settings.TweenDuration.Medium
        local tween = TweenElement(element, propertySet, duration)
        table.insert(tweens, tween)
    end
    
    -- Chain the tweens
    for i = 1, #tweens - 1 do
        tweens[i].Completed:Connect(function()
            tweens[i + 1]:Play()
        end)
    end
    
    -- Play the first tween
    tweens[1]:Play()
    return tweens
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

    -- Modified for horizontal layout
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 650, 0, 300) -- Wider for horizontal layout
    mainFrame.Position = position or UDim2.new(0.5, -325, 0.5, -150)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui

    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Settings.CornerRadius
    corner.Parent = mainFrame
    
    -- Add shadow with improved appearance
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = self.Settings.DefaultColors.Shadow
    shadow.ImageTransparency = self.Settings.ShadowTransparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame

    -- Title bar (now horizontal along the top)
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
    
    -- Title icon
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
    
    -- Close button with improved animation
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
    
    -- Horizontal layout with sidebar and main content area
    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Name = "SidebarFrame"
    sidebarFrame.Size = UDim2.new(0, 170, 1, -46)
    sidebarFrame.Position = UDim2.new(0, 8, 0, 38)
    sidebarFrame.BackgroundColor3 = self.Settings.DefaultColors.BackgroundSecondary
    sidebarFrame.BackgroundTransparency = 0.25
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = self.Settings.CornerRadius
    sidebarCorner.Parent = sidebarFrame
    
    local sidebarScrollingFrame = Instance.new("ScrollingFrame")
    sidebarScrollingFrame.Name = "SidebarContainer"
    sidebarScrollingFrame.Size = UDim2.new(1, -12, 1, -12)
    sidebarScrollingFrame.Position = UDim2.new(0, 6, 0, 6)
    sidebarScrollingFrame.BackgroundTransparency = 1
    sidebarScrollingFrame.BorderSizePixel = 0
    sidebarScrollingFrame.ScrollBarThickness = 3
    sidebarScrollingFrame.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    sidebarScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScrollingFrame.Parent = sidebarFrame
    
    -- Content area (main panel)
    local containerBorder = Instance.new("Frame")
    containerBorder.Name = "ContainerBorder"
    containerBorder.Size = UDim2.new(1, -194, 1, -46) -- Width adjusted to accommodate sidebar
    containerBorder.Position = UDim2.new(0, 186, 0, 38) -- Positioned to the right of sidebar
    containerBorder.BackgroundColor3 = self.Settings.DefaultColors.BackgroundSecondary
    containerBorder.BackgroundTransparency = 0.25
    containerBorder.BorderSizePixel = 0
    containerBorder.Parent = mainFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = self.Settings.CornerRadius
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
    
    -- Auto layout for sidebar
    local sidebarListLayout = Instance.new("UIListLayout")
    sidebarListLayout.Padding = UDim.new(0, 8)
    sidebarListLayout.FillDirection = Enum.FillDirection.Vertical
    sidebarListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarListLayout.Parent = sidebarScrollingFrame
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 6)
    sidebarPadding.PaddingBottom = UDim.new(0, 6)
    sidebarPadding.PaddingLeft = UDim.new(0, 2)
    sidebarPadding.PaddingRight = UDim.new(0, 2)
    sidebarPadding.Parent = sidebarScrollingFrame
    
    -- Auto layout for main container
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

    -- Enhanced dragging with spring effects for both PC and Mobile
    local isDragging = false
    local dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        SpringTween(mainFrame, {
            Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        }, 0.7, 4) -- Slightly bouncy feel
    }

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            -- Add a subtle scale effect when grabbed
            TweenElement(mainFrame, {Size = UDim2.new(
                mainFrame.Size.X.Scale, mainFrame.Size.X.Offset * 0.99,
                mainFrame.Size.Y.Scale, mainFrame.Size.Y.Offset * 0.99
            )}, 0.2)
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            
            -- Restore original size with a bounce effect
            ElasticOut(mainFrame, {Size = UDim2.new(
                mainFrame.Size.X.Scale, mainFrame.Size.X.Offset / 0.99,
                mainFrame.Size.Y.Scale, mainFrame.Size.Y.Offset / 0.99
            )}, 0.3)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)

    -- Auto-update container sizes
    sidebarListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebarScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, sidebarListLayout.AbsoluteContentSize.Y + 12)
    end)
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    end)

    -- Button animations with spring
    closeButton.MouseEnter:Connect(function()
        SpringTween(closeButton, {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(1, -33, 0, 5)
        }, 0.8, 4)
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenElement(closeButton, {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 26, 0, 26),
            Position = UDim2.new(1, -32, 0, 6)
        }, 0.2)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        -- Fancy close animation
        TweenElement(mainFrame, {BackgroundTransparency = 1}, 0.3)
        TweenElement(titleBar, {BackgroundTransparency = 1}, 0.25)
        TweenElement(containerBorder, {BackgroundTransparency = 1}, 0.2)
        TweenElement(sidebarFrame, {BackgroundTransparency = 1}, 0.2)
        TweenElement(shadow, {ImageTransparency = 1}, 0.4)
        
        ElasticOut(mainFrame, {
            Size = UDim2.new(0, mainFrame.Size.X.Offset * 0.7, 0, 0),
            Position = UDim2.new(
                mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + mainFrame.Size.X.Offset * 0.15, 
                mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + mainFrame.Size.Y.Offset * 0.5
            )
        }, 0.5)
        
        -- Delete after animation finishes
        task.delay(0.5, function()
            gui:Destroy()
        end)
    end)

    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame
    window.sidebar = sidebarScrollingFrame

    -- Window toggle with advanced animation
    function window:ToggleState(visible)
        if type(visible) ~= "boolean" then
            error("ToggleState requires a boolean parameter (true or false)")
            return
        end
        
        if visible then
            mainFrame.Visible = true
            TweenElement(mainFrame, {BackgroundTransparency = self.Settings.DefaultTransparency}, 0.3)
            SpringTween(mainFrame, {
                Size = UDim2.new(0, 650, 0, 300)
            }, 0.7, 3.5)
        else
            SequenceTween(mainFrame, 
                {
                    {BackgroundTransparency = 1},
                    {Size = UDim2.new(0, 650, 0, 0)}
                },
                {0.3, 0.2}
            )
            task.delay(0.5, function()
                mainFrame.Visible = false
            end)
        end
        
        return self
    end

    -- Add section with smooth enter animation
    function window:AddSection(title)
        local section = Instance.new("Frame")
        section.Name = "Section"
        section.Size = UDim2.new(1, -4, 0, 36)
        section.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        section.BackgroundTransparency = 1 -- Start fully transparent for animation
        section.BorderSizePixel = 0
        section.Parent = self.container
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        sectionCorner.Parent = section
        
        local sectionAccent = Instance.new("Frame")
        sectionAccent.Name = "Accent"
        sectionAccent.Size = UDim2.new(0, 0, 0, 18) -- Start with 0 width for animation
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
        sectionTitle.TextTransparency = 1 -- Start fully transparent for animation
        sectionTitle.TextSize = 14
        sectionTitle.Font = GuiLib.Settings.FontSemibold
        sectionTitle.Text = title or "Section"
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        -- Animation sequence
        TweenElement(section, {BackgroundTransparency = 0.35}, 0.3)
        task.delay(0.1, function()
            TweenElement(sectionAccent, {Size = UDim2.new(0, 4, 0, 18)}, 0.4, Enum.EasingStyle.Back)
            TweenElement(sectionTitle, {TextTransparency = 0}, 0.3)
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
        labelInstance.TextTransparency = 1 -- Start transparent for animation
        labelInstance.Parent = self.container
        
        -- Animate in
        TweenElement(labelInstance, {TextTransparency = 0}, 0.3)
        
        -- Create a wrapper object
        local label = {
            Instance = labelInstance,
            SetText = function(self, newText)
                TweenElement(labelInstance, {TextTransparency = 0.5}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out).Completed:Connect(function()
                    labelInstance.Text = newText
                    TweenElement(labelInstance, {TextTransparency = 0}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
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
        button.BackgroundTransparency = 1 -- Start transparent for animation
        button.TextTransparency = 1 -- Start transparent for animation
        button.Parent = self.container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
        buttonCorner.Parent = button
        
        -- Add a glow effect
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = GuiLib.Settings.DefaultColors.Accent
        buttonStroke.Transparency = 1 -- Start transparent for animation
        buttonStroke.Thickness = 1.5
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = button
        
        -- Animate in
        TweenElement(button, {BackgroundTransparency = 0, TextTransparency = 0}, 0.3)
        TweenElement(buttonStroke, {Transparency = 0.9}, 0.4)
        
        -- Enhanced animation effects
        button.MouseEnter:Connect(function()
            SpringTween(button, {
                BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover,
                Size = UDim2.new(1, -4, 0, 36)
            }, 0.8, 4)
            TweenElement(buttonStroke, {Transparency = 0.7}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            SpringTween(button, {
                BackgroundColor3 = GuiLib.Settings.DefaultColors.Button,
                Size = UDim2.new(1, -8, 0, 36)
            }, 0.8, 3)
            TweenElement(buttonStroke, {Transparency = 0.9}, 0.2)
        end)
        
        button.MouseButton1Down:Connect(function()
            SpringTween(button, {
                BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonPressed,
                Size = UDim2.new(1, -12, 0, 36)
            }, 0.9, 3)
            TweenElement(buttonStroke, {Transparency = 0.6}, 0.1)
        end)
        
        button.MouseButton1Up:Connect(function()
            SpringTween(button, {
                BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover,
                Size = UDim2.new(1, -4, 0, 36)
            }, 0.7, 3)
            TweenElement(buttonStroke, {Transparency = 0.7}, 0.2)
        end)
        
        if callback then
            button.MouseButton1Click:Connect(function()
                -- Add a ripple effect
                local ripple = Instance.new("Frame")
                ripple.Name = "Ripple"
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.7
                ripple.BorderSizePixel = 0
                ripple.ZIndex = button.ZIndex + 1
                ripple.Parent = button
                
                local rippleCorner = Instance.new("UICorner")
                rippleCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                rippleCorner.Parent = ripple
                
                -- Position ripple at click position
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.Position = UDim2.new(0, mouse.X - button.AbsolutePosition.X, 0, mouse.Y - button.AbsolutePosition.Y)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                
                -- Animate ripple
                TweenElement(ripple, {
                    Size = UDim2.new(0, size, 0, size),
                    BackgroundTransparency = 1
                }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out).Completed:Connect(function()
                    ripple:Destroy()
                end)
                
                callback()
            end)
        end
        
        return button
    end

    function window:AddToggle(text, default, callback)
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Name = "ToggleContainer"
        toggleContainer.Size = UDim2.new(1, -8, 0, 36)
        toggleContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        toggleContainer.BackgroundTransparency = 1 -- Start transparent for animation
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
        label.TextTransparency = 1 -- Start transparent for animation
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
        toggleButton.BackgroundTransparency = 1 -- Start transparent for animation
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
        toggleIndicator.BackgroundTransparency = 1 -- Start transparent for animation
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
        
        -- Animate in
        TweenElement(toggleContainer, {BackgroundTransparency = 0.4}, 0.3)
        TweenElement(label, {TextTransparency = 0}, 0.4)
        TweenElement(toggleButton, {BackgroundTransparency = 0}, 0.3)
        TweenElement(toggleIndicator, {BackgroundTransparency = 0}, 0.4)
        
        local isEnabled = default or false
        
        local function updateVisuals()
            if isEnabled then
                SpringTween(toggleButton, {
                    BackgroundColor3 = GuiLib.Settings.DefaultColors.ToggleEnabled
                }, 0.8, 4)
                
                SpringTween(toggleIndicator, {
                    Position = UDim2.new(0, 23, 0.5, -9)
                }, 0.7, 3.5)
            else
                TweenElement(toggleButton, {
                    BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle
                }, 0.3)
                
                SpringTween(toggleIndicator, {
                    Position = UDim2.new(0, 3, 0.5, -9)
                }, 0.7, 3.5)
            end
        end
        
        updateVisuals()
        
        -- Hover effect
        clickArea.MouseEnter:Connect(function()
            TweenElement(toggleContainer, {BackgroundTransparency = 0.2}, 0.2)
            SpringTween(toggleIndicator, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(
                toggleIndicator.Position.X.Scale,
                toggleIndicator.Position.X.Offset,
                0.5, -10
            )}, 0.8, 4)
        end)
        
        clickArea.MouseLeave:Connect(function()
            TweenElement(toggleContainer, {BackgroundTransparency = 0.4}, 0.2)
            SpringTween(toggleIndicator, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(
                toggleIndicator.Position.X.Scale, 
                toggleIndicator.Position.X.Offset,
                0.5, -9
            )}, 0.8, 4)
        end)
        
        clickArea.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            updateVisuals()
            
            -- Add a pulse effect on click
            local pulse = toggleIndicator:Clone()
            pulse.Size = UDim2.new(0, 18, 0, 18)
            pulse.Position = toggleIndicator.Position
            pulse.BackgroundTransparency = 0.7
            pulse.ZIndex = toggleIndicator.ZIndex - 1
            pulse.Parent = toggleButton
            
            TweenElement(pulse, {
                Size = UDim2.new(0, 30, 0, 30),
                BackgroundTransparency = 1,
                Position = UDim2.new(
                    pulse.Position.X.Scale,
                    pulse.Position.X.Offset - 5,
                    0.5, -15
                )
            }, 0.3).Completed:Connect(function()
                pulse:Destroy()
            end)
            
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
        sliderContainer.BackgroundTransparency = 1 -- Start transparent for animation
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
        label.TextTransparency = 1 -- Start transparent for animation
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
        valueDisplay.TextTransparency = 1 -- Start transparent for animation
        valueDisplay.Text = tostring(default)
        valueDisplay.TextSize = 14
        valueDisplay.Font = GuiLib.Settings.FontSemibold
        valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        valueDisplay.Parent = sliderContainer
        
        -- Change to TextButton to capture input on mobile
        local sliderBarContainer = Instance.new("Frame")
        sliderBarContainer.Name = "SliderBarContainer"
        sliderBarContainer.Size = UDim2.new(1, -32, 0, 8)
        sliderBarContainer.Position = UDim2.new(0, 16, 0, 34)
        sliderBarContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Slider
        sliderBarContainer.BackgroundTransparency = 1 -- Start transparent for animation
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
        sliderFill.Size = UDim2.new(0, 0, 1, 0) -- Start with 0 width for animation
        sliderFill.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderFill.BackgroundTransparency = 1 -- Start transparent for animation
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBarContainer
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Size = UDim2.new(0, 0, 0, 0) -- Start at 0 size for animation
        sliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
        sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderButton.BackgroundTransparency = 1 -- Start transparent for animation
        sliderButton.Text = ""
        sliderButton.Parent = sliderBarContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0)
        buttonCorner.Parent = sliderButton
        
        -- Add a glow effect to the button
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonStroke.Transparency = 1 -- Start transparent for animation
        buttonStroke.Thickness = 1.5
        buttonStroke.Parent = sliderButton
        
        -- Animate in with sequence
        TweenElement(sliderContainer, {BackgroundTransparency = 0.4}, 0.3)
        task.delay(0.1, function()
            TweenElement(label, {TextTransparency = 0}, 0.3)
            TweenElement(valueDisplay, {TextTransparency = 0}, 0.3)
        end)
        task.delay(0.2, function()
            TweenElement(sliderBarContainer, {BackgroundTransparency = 0}, 0.3)
            TweenElement(sliderFill, {BackgroundTransparency = 0}, 0.3)
        end)
        task.delay(0.3, function()
            SpringTween(sliderButton, {
                Size = UDim2.new(0, 18, 0, 18),
                BackgroundTransparency = 0
            }, 0.7, 4)
            TweenElement(buttonStroke, {Transparency = 0.7}, 0.3)
            
            -- Set initial fill width properly
            TweenElement(sliderFill, {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
        
        local function updateSlider(value)
            local newValue = math.clamp(value, min, max)
            if precision then
                newValue = math.floor(newValue / precision) * precision
            end
            
            local percent = (newValue - min) / (max - min)
            
            SpringTween(sliderFill, {
                Size = UDim2.new(percent, 0, 1, 0)
            }, 0.8, 4)
            
            SpringTween(sliderButton, {
                Position = UDim2.new(percent, 0, 0.5, 0)
            }, 0.7, 4)
            
            -- Animate the value change
            local currentNum = tonumber(valueDisplay.Text) or default
            SequenceTween(valueDisplay, 
                {
                    {TextTransparency = 0.5}, 
                    {TextTransparency = 0}
                },
                {0.15, 0.15}
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
        
        -- Function to calculate value from position
        local function calculateValueFromPosition(inputPosition)
            local barPos = sliderBarContainer.AbsolutePosition.X
            local barWidth = sliderBarContainer.AbsoluteSize.X
            local percent = math.clamp((inputPosition.X - barPos) / barWidth, 0, 1)
            return min + (max - min) * percent
        end
        
        -- Enhanced hover and pressed effects
        sliderButton.MouseEnter:Connect(function()
            SpringTween(sliderButton, {
                Size = UDim2.new(0, 22, 0, 22)
            }, 0.8, 4)
            TweenElement(buttonStroke, {Transparency = 0.4}, 0.2)
        end)
        
        sliderButton.MouseLeave:Connect(function()
            if not dragging then
                SpringTween(sliderButton, {
                    Size = UDim2.new(0, 18, 0, 18)
                }, 0.8, 4)
                TweenElement(buttonStroke, {Transparency = 0.7}, 0.2)
            end
        end)
        
        -- Handle initial press (both mouse and touch)
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                -- Pulse effect on click
                SpringTween(sliderButton, {
                    Size = UDim2.new(0, 24, 0, 24)
                }, 0.9, 4.5)
                TweenElement(buttonStroke, {Transparency = 0.2}, 0.1)
                
                -- Add a pulse effect
                local pulse = sliderButton:Clone()
                pulse.Size = UDim2.new(0, 18, 0, 18)
                pulse.BackgroundTransparency = 0.7
                pulse.ZIndex = sliderButton.ZIndex - 1
                pulse.Parent = sliderBarContainer
                
                TweenElement(pulse, {
                    Size = UDim2.new(0, 30, 0, 30),
                    BackgroundTransparency = 1
                }, 0.4).Completed:Connect(function()
                    pulse:Destroy()
                end)
            end
        end)
        
        -- Handle bar click/tap (both mouse and touch)
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                SpringTween(sliderButton, {
                    Size = UDim2.new(0, 24, 0, 24)
                }, 0.9, 4.5)
                TweenElement(buttonStroke, {Transparency = 0.2}, 0.1)
                
                currentValue = updateSlider(calculateValueFromPosition(input.Position))
            end
        end)
        
        -- Handle input ending (both mouse and touch)
        userInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                input.UserInputType == Enum.UserInputType.Touch) and dragging then
                dragging = false
                
                SpringTween(sliderButton, {
                    Size = UDim2.new(0, 18, 0, 18)
                }, 0.8, 4)
                TweenElement(buttonStroke, {Transparency = 0.7}, 0.2)
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
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, -8, 0, 66)
        dropdownContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        dropdownContainer.BackgroundTransparency = 1 -- Start transparent for animation
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
        label.TextTransparency = 1 -- Start transparent for animation
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
        dropButton.BackgroundTransparency = 1 -- Start transparent for animation
        dropButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        dropButton.TextTransparency = 1 -- Start transparent for animation
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
        icon.TextTransparency = 1 -- Start transparent for animation
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
        
        -- Animate in with sequence
        TweenElement(dropdownContainer, {BackgroundTransparency = 0.4}, 0.3)
        task.delay(0.1, function()
            TweenElement(label, {TextTransparency = 0}, 0.25)
        end)
        task.delay(0.2, function()
            TweenElement(dropButton, {BackgroundTransparency = 0, TextTransparency = 0}, 0.25)
            TweenElement(icon, {TextTransparency = 0}, 0.25)
        end)
        
        local isOpen = false
        local selectedOption = default or (options and options[1]) or "Select"
        
        -- Add a button glow effect
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Name = "ButtonStroke"
        buttonStroke.Color = GuiLib.Settings.DefaultColors.Accent
        buttonStroke.Transparency = 1 -- Start transparent for animation
        buttonStroke.Thickness = 1.5
        buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonStroke.Parent = dropButton
        
        task.delay(0.3, function()
            TweenElement(buttonStroke, {Transparency = 0.9}, 0.3)
        end)
        
        -- Hover effects with spring animation
        dropButton.MouseEnter:Connect(function()
            TweenElement(buttonStroke, {Transparency = 0.7}, 0.2)
            SpringTween(dropButton, {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 10, 255),
                    math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 10, 255),
                    math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 10, 255)
                ),
                Size = UDim2.new(1, -28, 0, 36)
            }, 0.8, 4)
        end)
        
        dropButton.MouseLeave:Connect(function()
            TweenElement(buttonStroke, {Transparency = 0.9}, 0.2)
            SpringTween(dropButton, {
                BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown,
                Size = UDim2.new(1, -32, 0, 36)
            }, 0.8, 4)
        end)
        
        local function toggleDropdown()
            isOpen = not isOpen
            
            if isOpen then
                icon.Text = "▲"
                ElasticOut(icon, {
                    Position = UDim2.new(1, -25, 0.5, -12),
                    TextColor3 = GuiLib.Settings.DefaultColors.Accent
                }, 0.3)
                dropFrame.Visible = true
                
                local optionsHeight = #options * 34 + (#options - 1) * 4
                optionsHeight = math.min(optionsHeight, 150) -- Max height
                
                -- Expand the container with spring effect
                SpringTween(dropdownContainer, {
                    Size = UDim2.new(1, -8, 0, 66 + optionsHeight)
                }, 0.7, 3.5)
                
                -- Expand the dropdown panel with spring effect
                SpringTween(dropFrame, {
                    Size = UDim2.new(1, 0, 0, optionsHeight)
                }, 0.8, 3)
                
                optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 34 + (#options - 1) * 4)
                
                -- Add a subtle pulse glow to indicate action
                local pulse = buttonStroke:Clone()
                pulse.Parent = dropButton
                pulse.Transparency = 0.5
                
                TweenElement(pulse, {Transparency = 1}, 0.5).Completed:Connect(function()
                    pulse:Destroy()
                end)
            else
                ElasticOut(icon, {
                    Position = UDim2.new(1, -25, 0.5, -10),
                    TextColor3 = GuiLib.Settings.DefaultColors.Accent
                }, 0.3)
                icon.Text = "▼"
                
                -- Collapse with spring effect
                SpringTween(dropdownContainer, {
                    Size = UDim2.new(1, -8, 0, 66)
                }, 0.7, 3.5)
                
                TweenElement(dropFrame, {
                    Size = UDim2.new(1, 0, 0, 0)
                }, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Connect(function()
                    dropFrame.Visible = false
                end)
            end
        end
        
        dropButton.MouseButton1Click:Connect(toggleDropdown)
        
        -- Create option buttons with animated appearance
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
                
                -- Enhanced option hover effect
                optionButton.MouseEnter:Connect(function()
                    TweenElement(optionButton, {
                        BackgroundTransparency = 0,
                        BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover,
                        TextSize = 15 -- Subtle text size increase
                    }, 0.2)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenElement(optionButton, {
                        BackgroundTransparency = 0.2,
                        BackgroundColor3 = GuiLib.Settings.DefaultColors.Button,
                        TextSize = 14 -- Restore text size
                    }, 0.2)
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    -- Ripple effect when selecting
                    local ripple = Instance.new("Frame")
                    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ripple.BackgroundTransparency = 0.7
                    ripple.BorderSizePixel = 0
                    ripple.ZIndex = optionButton.ZIndex - 1
                    ripple.Size = UDim2.new(0, 0, 0, 0)
                    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                    
                    local rippleCorner = Instance.new("UICorner")
                    rippleCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                    rippleCorner.Parent = ripple
                    
                    ripple.Parent = optionButton
                    
                    TweenElement(ripple, {
                        Size = UDim2.new(1, 30, 1, 30),
                        BackgroundTransparency = 1
                    }, 0.3).Completed:Connect(function()
                        ripple:Destroy()
                    end)
                    
                    selectedOption = option
                    
                    -- Animate text change with fade
                    TweenElement(dropButton, {TextTransparency = 1}, 0.1).Completed:Connect(function()
                        dropButton.Text = option
                        TweenElement(dropButton, {TextTransparency = 0}, 0.1)
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
            
            -- Create new option buttons with animation
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = "Option_" .. option
                optionButton.Size = UDim2.new(1, -8, 0, 30)
                optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
                optionButton.BackgroundTransparency = 1 -- Start transparent
                optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
                optionButton.TextTransparency = 1 -- Start transparent
                optionButton.Text = option
                optionButton.TextSize = 14
                optionButton.Font = GuiLib.Settings.FontRegular
                optionButton.ZIndex = 7
                optionButton.AutoButtonColor = false
                optionButton.Parent = optionList
                
                -- Animate in with delay based on index
                task.delay(i * 0.03, function()
                    TweenElement(optionButton, {
                        BackgroundTransparency = 0.2,
                        TextTransparency = 0
                    }, 0.25)
                end)
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                optionCorner.Parent = optionButton
                
                -- Enhanced option hover effect
                optionButton.MouseEnter:Connect(function()
                    TweenElement(optionButton, {
                        BackgroundTransparency = 0,
                        BackgroundColor3 = GuiLib.Settings.DefaultColors.ButtonHover,
                        TextSize = 15
                    }, 0.2)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenElement(optionButton, {
                        BackgroundTransparency = 0.2,
                        BackgroundColor3 = GuiLib.Settings.DefaultColors.Button,
                        TextSize = 14
                    }, 0.2)
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    -- Ripple effect
                    local ripple = Instance.new("Frame")
                    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ripple.BackgroundTransparency = 0.7
                    ripple.BorderSizePixel = 0
                    ripple.ZIndex = optionButton.ZIndex - 1
                    ripple.Size = UDim2.new(0, 0, 0, 0)
                    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                    
                    local rippleCorner = Instance.new("UICorner")
                    rippleCorner.CornerRadius = GuiLib.Settings.ElementCornerRadius
                    rippleCorner.Parent = ripple
                    
                    ripple.Parent = optionButton
                    
                    TweenElement(ripple, {
                        Size = UDim2.new(1, 30, 1, 30),
                        BackgroundTransparency = 1
                    }, 0.3).Completed:Connect(function()
                        ripple:Destroy()
                    end)
                    
                    selectedOption = option
                    
                    -- Animate text change
                    TweenElement(dropButton, {TextTransparency = 1}, 0.1).Completed:Connect(function()
                        dropButton.Text = option
                        TweenElement(dropButton, {TextTransparency = 0}, 0.1)
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
        colorPickerContainer.BackgroundTransparency = 1 -- Start transparent for animation
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
        label.TextTransparency = 1 -- Start transparent for animation
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
        colorDisplay.BackgroundTransparency = 1 -- Start transparent for animation
        colorDisplay.BorderSizePixel = 0
        colorDisplay.Parent = colorPickerContainer
        
        local displayCorner = Instance.new("UICorner")
        displayCorner.CornerRadius = UDim.new(0, 4)
        displayCorner.Parent = colorDisplay
        
        -- Add a stroke to the color display
        local displayStroke = Instance.new("UIStroke")
        displayStroke.Name = "DisplayStroke"
        displayStroke.Color = Color3.fromRGB(255, 255, 255)
        displayStroke.Transparency = 1 -- Start transparent for animation
        displayStroke.Thickness = 1
        displayStroke.Parent = colorDisplay
        
        local clickButton = Instance.new("TextButton")
        clickButton.Name = "ClickButton"
        clickButton.Size = UDim2.new(1, 0, 1, 0)
        clickButton.BackgroundTransparency = 1
        clickButton.Text = ""
        clickButton.Parent = colorDisplay
        
        -- Animate in with sequence
        TweenElement(colorPickerContainer, {BackgroundTransparency = 0.4}, 0.3)
        task.delay(0.1, function()
            TweenElement(label, {TextTransparency = 0}, 0.3)
        end)
        task.delay(0.2, function()
            TweenElement(colorDisplay, {BackgroundTransparency = 0}, 0.3)
            TweenElement(displayStroke, {Transparency = 0.8}, 0.3)
        end)
        
        -- Color picker functionality
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
        
        -- Add a drop shadow to the picker panel
        local pickerShadow = Instance.new("ImageLabel")
        pickerShadow.Name = "PickerShadow"
        pickerShadow.Size = UDim2.new(1, 40, 1, 40)
        pickerShadow.Position = UDim2.new(0, -20, 0, -20)
        pickerShadow.BackgroundTransparency = 1
        pickerShadow.Image = "rbxassetid://5554236805"
        pickerShadow.ImageColor3 = GuiLib.Settings.DefaultColors.Shadow
        pickerShadow.ImageTransparency = 0.6
        pickerShadow.ScaleType = Enum.ScaleType.Slice
        pickerShadow.SliceCenter = Rect.new(23, 23, 277, 277)
        pickerShadow.ZIndex = 9
        pickerShadow.Parent = pickerFrame
        
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
        
        -- Enhanced hover effect for color display
        clickButton.MouseEnter:Connect(function()
            SpringTween(colorDisplay, {
                Size = UDim2.new(0, 40, 0, 28),
                Position = UDim2.new(1, -48, 0.5, -14)
            }, 0.8, 4)
            TweenElement(displayStroke, {Transparency = 0.4}, 0.2)
            TweenElement(colorPickerContainer, {BackgroundTransparency = 0.2}, 0.2)
        end)
        
        clickButton.MouseLeave:Connect(function()
            SpringTween(colorDisplay, {
                Size = UDim2.new(0, 36, 0, 26),
                Position = UDim2.new(1, -46, 0.5, -13)
            }, 0.8, 4)
            TweenElement(displayStroke, {Transparency = 0.8}, 0.2)
            TweenElement(colorPickerContainer, {BackgroundTransparency = 0.4}, 0.2)
        end)
        
        -- Logic and functionality
        local pickerOpen = false
        local selectedColor = default
        local hue, saturation, value = 0, 0, 1
        
        local function updateColor()
            local hsv = Color3.fromHSV(hue, saturation, value)
            
            -- Animate color changes
            TweenElement(colorDisplay, {BackgroundColor3 = hsv}, 0.2)
            TweenElement(currentColorDisplay, {BackgroundColor3 = hsv}, 0.2)
            TweenElement(colorField, {BackgroundColor3 = Color3.fromHSV(hue, 1, 1)}, 0.2)
            
            if callback then
                callback(hsv)
            end
            
            return hsv
        end
        
        local function updateSelectors()
            -- Update hue selector position with spring animation
            SpringTween(hueSelector, {
                Position = UDim2.new(hue, -3, 0, -3)
            }, 0.7, 3.5)
            
            -- Update color selector position with spring animation
            SpringTween(colorSelector, {
                Position = UDim2.new(saturation, 0, 1 - value, 0)
            }, 0.7, 3.5)
            
            -- Update the color
            selectedColor = updateColor()
        }
        
        local function togglePicker()
            pickerOpen = not pickerOpen
            
            if pickerOpen then
                pickerFrame.Visible = true
                pickerFrame.Size = UDim2.new(0, 0, 0, 0)
                pickerFrame.BackgroundTransparency = 1
                pickerShadow.ImageTransparency = 1
                
                -- Animate opening
                SpringTween(pickerFrame, {
                    Size = UDim2.new(0, 220, 0, 240),
                    BackgroundTransparency = 0.1
                }, 0.7, 3)
                
                TweenElement(pickerShadow, {ImageTransparency = 0.6}, 0.4)
            else
                -- Animate closing
                TweenElement(pickerFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                }, 0.3).Completed:Connect(function()
                    pickerFrame.Visible = false
                end)
                
                TweenElement(pickerShadow, {ImageTransparency = 1}, 0.2)
            }
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
        
        -- Event handlers with enhanced feedback
        clickButton.MouseButton1Click:Connect(function()
            -- Add a pulse effect
            local pulse = colorDisplay:Clone()
            pulse.Size = colorDisplay.Size
            pulse.Position = colorDisplay.Position
            pulse.BackgroundTransparency = 0.7
            pulse.ZIndex = colorDisplay.ZIndex - 1
            pulse.Parent = colorPickerContainer
            
            TweenElement(pulse, {
                Size = UDim2.new(0, pulse.Size.X.Offset + 16, 0, pulse.Size.Y.Offset + 16),
                Position = UDim2.new(
                    pulse.Position.X.Scale,
                    pulse.Position.X.Offset - 8, 
                    pulse.Position.Y.Scale,
                    pulse.Position.Y.Offset - 8
                ),
                BackgroundTransparency = 1
            }, 0.3).Completed:Connect(function()
                pulse:Destroy()
            end)
            
            togglePicker()
        end)
        
        -- Enhanced hue interaction with feedback
        hueFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local absoluteX = input.Position.X - hueFrame.AbsolutePosition.X
                local huePercent = math.clamp(absoluteX / hueFrame.AbsoluteSize.X, 0, 1)
                hue = huePercent
                updateSelectors()
                
                -- Add a highlight effect
                SpringTween(hueSelector, {
                    Size = UDim2.new(0, 8, 1, 8)
                }, 0.8, 4)
                TweenElement(hueSelector, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)
        
        hueFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Return to normal size
                SpringTween(hueSelector, {
                    Size = UDim2.new(0, 6, 1, 6)
                }, 0.8, 4)
                TweenElement(hueSelector, {BackgroundTransparency = 0.7}, 0.2)
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
        
        -- Enhanced color field interaction
        colorField.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local absoluteX = input.Position.X - colorField.AbsolutePosition.X
                local absoluteY = input.Position.Y - colorField.AbsolutePosition.Y
                saturation = math.clamp(absoluteX / colorField.AbsoluteSize.X, 0, 1)
                value = 1 - math.clamp(absoluteY / colorField.AbsoluteSize.Y, 0, 1)
                updateSelectors()
                
                -- Add a highlight effect
                SpringTween(colorSelector, {
                    BorderSizePixel = 3
                }, 0.8, 4)
                SpringTween(selectorInner, {
                    Size = UDim2.new(0, 8, 0, 8),
                    Position = UDim2.new(0.5, -4, 0.5, -4)
                }, 0.8, 4)
            end
        end)
        
        colorField.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Return to normal size
                SpringTween(colorSelector, {
                    BorderSizePixel = 2
                }, 0.8, 4)
                SpringTween(selectorInner, {
                    Size = UDim2.new(0, 6, 0, 6),
                    Position = UDim2.new(0.5, -3, 0.5, -3)
                }, 0.8, 4)
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
        textBoxContainer.BackgroundTransparency = 1 -- Start transparent for animation
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
        label.TextTransparency = 1 -- Start transparent for animation
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
        inputBox.BackgroundTransparency = 1 -- Start transparent for animation
        inputBox.TextColor3 = GuiLib.Settings.DefaultColors.Text
        inputBox.TextTransparency = 1 -- Start transparent for animation
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
        
        -- Add a glow effect
        local boxStroke = Instance.new("UIStroke")
        boxStroke.Name = "BoxStroke"
        boxStroke.Color = GuiLib.Settings.DefaultColors.Accent
        boxStroke.Transparency = 1 -- Start transparent for animation
        boxStroke.Thickness = 1.5
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxStroke.Parent = inputBox
        
        -- Animate in with sequence
        TweenElement(textBoxContainer, {BackgroundTransparency = 0.4}, 0.3)
        task.delay(0.1, function()
            TweenElement(label, {TextTransparency = 0}, 0.25)
        end)
        task.delay(0.2, function()
            TweenElement(inputBox, {BackgroundTransparency = 0, TextTransparency = 0}, 0.25)
            TweenElement(boxStroke, {Transparency = 0.9}, 0.25)
        end)
        
        -- Enhanced focus effects
        inputBox.Focused:Connect(function()
            -- Spring animation for focusing
            SpringTween(inputBox, {
                Size = UDim2.new(1, -24, 0, 36),
                Position = UDim2.new(0, 12, 0, 30),
                BackgroundColor3 = Color3.fromRGB(
                    math.min(GuiLib.Settings.DefaultColors.Dropdown.R * 255 + 15, 255),
                    math.min(GuiLib.Settings.DefaultColors.Dropdown.G * 255 + 15, 255),
                    math.min(GuiLib.Settings.DefaultColors.Dropdown.B * 255 + 15, 255)
                )
            }, 0.8, 4)
            TweenElement(boxStroke, {Transparency = 0.4}, 0.2)
            
            -- Also highlight the container
            TweenElement(textBoxContainer, {BackgroundTransparency = 0.2}, 0.2)
        end)
        
        inputBox.FocusLost:Connect(function(enterPressed)
            -- Spring animation for unfocusing
            SpringTween(inputBox, {
                Size = UDim2.new(1, -32, 0, 36),
                Position = UDim2.new(0, 16, 0, 30),
                BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
            }, 0.8, 4)
            TweenElement(boxStroke, {Transparency = 0.9}, 0.2)
            TweenElement(textBoxContainer, {BackgroundTransparency = 0.4}, 0.2)
            
            if enterPressed and callback then
                -- Add a flash effect to show submission
                local flash = inputBox:Clone()
                flash.Name = "SubmitFlash"
                flash.Size = inputBox.Size
                flash.Position = inputBox.Position
                flash.BackgroundColor3 = GuiLib.Settings.DefaultColors.Accent
                flash.BackgroundTransparency = 0.8
                flash.Text = ""
                flash.ZIndex = inputBox.ZIndex - 1
                flash.Parent = textBoxContainer
                
                TweenElement(flash, {BackgroundTransparency = 1}, 0.5).Completed:Connect(function()
                    flash:Destroy()
                end)
                
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
            -- Animate text change
            TweenElement(inputBox, {TextTransparency = 1}, 0.15).Completed:Connect(function()
                inputBox.Text = text or ""
                TweenElement(inputBox, {TextTransparency = 0}, 0.15)
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

-- Predefined themes
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


-- GuiLib - Fixed Version
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
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- Cache CoreGui service

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
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = name or "GuiLibWindow"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Handle protection
    local parentSuccess = pcall(function()
        gui.Parent = CoreGui
    end)

    -- Fallback for HttpGet / Synapse protection
    if not parentSuccess or not gui.Parent then
        parentSuccess = pcall(function()
            if syn and syn.protect_gui then -- Check if syn and protect_gui exist
                 syn.protect_gui(gui)
                 gui.Parent = CoreGui
            else
                 gui.Parent = playerGui -- Fallback if syn is not available
            end
        end)

        if not parentSuccess or not gui.Parent then
             -- Final fallback
             gui.Parent = playerGui
        end
    end


    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 650, 0, 300) -- Wider for horizontal layout
    mainFrame.Position = position or UDim2.new(0.5, -325, 0.5, -150)
    mainFrame.BackgroundColor3 = self.Settings.DefaultColors.Background
    mainFrame.BackgroundTransparency = self.Settings.DefaultTransparency -- Initial transparency set here
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
    shadow.Image = "rbxassetid://5554236805" -- Common shadow asset
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
        Debris:AddItem(gui, 0.3) -- Use Debris service for cleanup
    end)

    -- Main content area (scrolling horizontally now)
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -210, 1, -20) -- Leave room for the sidebar
    contentArea.Position = UDim2.new(0, 205, 0, 10)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame

    -- Scrolling container (horizontal) for sections
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Container"
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None -- No vertical scrollbar needed here
    scrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X -- Explicitly set horizontal scrolling
    scrollingFrame.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Start with zero canvas size
    scrollingFrame.Parent = contentArea

    -- Auto layout for section content (Horizontal Grid)
    local listLayout = Instance.new("UIGridLayout")
    listLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    listLayout.CellSize = UDim2.new(0, 200, 1, -20) -- Use relative height for cells
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
    navContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar -- Vertical scroll here
    navContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    navContainer.ScrollingDirection = Enum.ScrollingDirection.Y -- Explicitly set vertical scrolling
    navContainer.ScrollBarImageColor3 = self.Settings.DefaultColors.ScrollBar
    navContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Start with zero canvas size
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
            input:StopPropagation() -- Prevent clicks going through to things behind the title bar
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then -- Only stop if we were actually dragging
                 isDragging = false
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)

    -- Auto-update container size based on UIGridLayout's content size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, listLayout.AbsoluteContentSize.X + paddingFrame.PaddingLeft.Offset + paddingFrame.PaddingRight.Offset, 0, 0) -- Only update X
    end)

    -- Auto-update nav container size based on UIListLayout's content size
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 10) -- Only update Y
    end)

    -- The object returned for this window instance
    local window = {}
    window.gui = gui
    window.mainFrame = mainFrame
    window.container = scrollingFrame -- Main horizontal container for sections
    window.navContainer = navContainer
    window.mainLayout = listLayout -- Store layout for calculations

    -- Add entry animation
    mainFrame.BackgroundTransparency = 1
    titleBar.BackgroundTransparency = 1

    tweenProperty(mainFrame, "BackgroundTransparency", self.Settings.DefaultTransparency, 0.5)
    tweenProperty(titleBar, "BackgroundTransparency", self.Settings.DefaultTransparency - 0.1, 0.5)

    -- Toggle window visibility
    function window:ToggleState(visible)
        if type(visible) ~= "boolean" then
            error("ToggleState requires a boolean parameter (true or false)", 2) -- Added error level
            return self -- Return self even on error
        end

        local mainFrameRef = window.gui:FindFirstChild("MainFrame") -- Use local ref
        if not mainFrameRef then
            warn("MainFrame not found in ToggleState")
            return self
        end

        if visible then
            mainFrameRef.Visible = true
            -- FIXED: Access Settings through GuiLib, not self (window)
            tweenProperty(mainFrameRef, "BackgroundTransparency", GuiLib.Settings.DefaultTransparency, 0.3)
            -- Also tween title bar back if needed
            local titleBarRef = mainFrameRef:FindFirstChild("TitleBar")
            if titleBarRef then
                 tweenProperty(titleBarRef, "BackgroundTransparency", GuiLib.Settings.DefaultTransparency - 0.1, 0.3)
            end
        else
            tweenProperty(mainFrameRef, "BackgroundTransparency", 1, 0.3)
             -- Also tween title bar
            local titleBarRef = mainFrameRef:FindFirstChild("TitleBar")
            if titleBarRef then
                 tweenProperty(titleBarRef, "BackgroundTransparency", 1, 0.3)
            end
            -- Use task.delay for better timing accuracy if available, otherwise use delay
            local delayFunc = task and task.delay or delay
            delayFunc(0.3, function()
                 if mainFrameRef and mainFrameRef.Parent then -- Check if still valid
                      mainFrameRef.Visible = false
                 end
            end)
        end

        return self -- Allow chaining
    end

    -- Create section (card-based design)
    function window:AddSection(title)
        local section = Instance.new("Frame")
        section.Name = "Section_" .. (title or "Untitled")
        section.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        section.BorderSizePixel = 0
        -- Let UIGridLayout handle size and position initially
        section.Parent = self.container -- Parent to the main horizontal scrolling frame

        -- Initial animation state (start transparent and slightly smaller, tween in)
        section.BackgroundTransparency = 1
        -- UIGridLayout controls the final size, so we just tween transparency
        tweenProperty(section, "BackgroundTransparency", GuiLib.Settings.DefaultTransparency - 0.1, 0.3)

        -- Add inner shadow/glow effect (Subtle)
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

        -- Header within the section card
        local headerContainer = Instance.new("Frame")
        headerContainer.Name = "HeaderContainer"
        headerContainer.Size = UDim2.new(1, 0, 0, 30)
        headerContainer.BackgroundTransparency = 0.7
        headerContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Title
        headerContainer.BorderSizePixel = 0
        headerContainer.Parent = section

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = GuiLib.Settings.CornerRadius -- Apply corner to header too
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

        -- Content container (Vertical Scrolling inside the section card)
        local contentContainer = Instance.new("ScrollingFrame")
        contentContainer.Name = "ContentContainer"
        contentContainer.Size = UDim2.new(1, -10, 1, -40) -- Fill space below header
        contentContainer.Position = UDim2.new(0, 5, 0, 35) -- Position below header
        contentContainer.BackgroundTransparency = 1
        contentContainer.BorderSizePixel = 0
        contentContainer.ScrollBarThickness = 4
        contentContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar -- Vertical scroll here
        contentContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.None
        contentContainer.ScrollingDirection = Enum.ScrollingDirection.Y -- Vertical scroll
        contentContainer.ScrollBarImageColor3 = GuiLib.Settings.DefaultColors.ScrollBar
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Start with zero canvas size
        contentContainer.Parent = section

        -- Auto layout for elements within this section (Vertical List)
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.FillDirection = Enum.FillDirection.Vertical
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = contentContainer

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 5)
        contentPadding.PaddingBottom = UDim.new(0, 5)
        contentPadding.PaddingLeft = UDim.new(0, 5) -- Padding for content inside section
        contentPadding.PaddingRight = UDim.new(0, 5)
        contentPadding.Parent = contentContainer

        -- Auto-update this section's content container size
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + contentPadding.PaddingTop.Offset + contentPadding.PaddingBottom.Offset) -- Only update Y
        end)

        -- Add navigation button to the sidebar
        local navButton = Instance.new("TextButton")
        navButton.Name = "NavButton_" .. (title or "Untitled")
        navButton.Size = UDim2.new(1, -20, 0, 30)
        navButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        navButton.BackgroundTransparency = 0.5
        navButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        navButton.Text = title or "Section"
        navButton.TextSize = 14
        navButton.Font = GuiLib.Settings.FontRegular
        navButton.Parent = self.navContainer -- Parent to the sidebar nav area

        local navCorner = Instance.new("UICorner")
        navCorner.CornerRadius = GuiLib.Settings.CornerRadius
        navCorner.Parent = navButton

        -- Hover and click effects for nav button
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

        -- Click nav button to scroll main container to the section
        navButton.MouseButton1Click:Connect(function()
            -- Find the section's position in the container
            local layoutItems = {}
            for _, child in ipairs(self.container:GetChildren()) do
                if child:IsA("Frame") and child.Name:match("^Section_") then
                    table.insert(layoutItems, child)
                end
            end

            -- Sort by LayoutOrder to ensure correct index
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
                 -- FIXED: Calculate width dynamically from the main layout
                 local cellWidth = self.mainLayout.CellSize.X.Offset + self.mainLayout.CellPadding.X.Offset
                 local targetPosition = Vector2.new((index - 1) * cellWidth, self.container.CanvasPosition.Y) -- Keep current Y

                 -- Tween the scroll position for smoothness
                 tweenProperty(self.container, "CanvasPosition", targetPosition, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            end

            -- Highlight effect on the section card itself
            local originalColor = section.BackgroundColor3
            local highlightColor = GuiLib.Settings.DefaultColors.Accent
            tweenProperty(section, "BackgroundColor3", highlightColor, 0.2)
             -- Use task.delay or delay to revert color
            local delayFunc = task and task.delay or delay
            delayFunc(0.3, function()
                 if section and section.Parent then -- Check if still valid
                      tweenProperty(section, "BackgroundColor3", originalColor, 0.5)
                 end
            end)
        end)

        -- Return the container WHERE ELEMENTS SHOULD BE ADDED
        return contentContainer
    end

    -- FIXED: Added parentContainer argument to all Add<Element> functions
    -- Elements will now be parented to the container returned by AddSection

    function window:AddLabel(parentContainer, text)
        if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddLabel: Invalid parentContainer provided.")
             return nil
        end
        local labelInstance = Instance.new("TextLabel")
        labelInstance.Name = "Label"
        labelInstance.Size = UDim2.new(1, 0, 0, 25) -- Use full width of parent by default
        labelInstance.BackgroundTransparency = 1
        labelInstance.TextColor3 = GuiLib.Settings.DefaultColors.Text
        labelInstance.Text = text or "Label"
        labelInstance.TextSize = 14
        labelInstance.Font = GuiLib.Settings.FontRegular
        labelInstance.TextXAlignment = Enum.TextXAlignment.Left -- Align left within its container
        labelInstance.Parent = parentContainer -- FIXED: Parent to provided container

        -- Create a wrapper object to return
        local label = {
            Instance = labelInstance,
            SetText = function(self, newText)
                labelInstance.Text = newText or ""
            end,
            Destroy = function(self)
                labelInstance:Destroy()
            end
        }

        return label
    end

    function window:AddButton(parentContainer, text, callback)
         if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddButton: Invalid parentContainer provided.")
             return nil
         end
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 32) -- Use full width of parent by default
        button.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        button.TextColor3 = GuiLib.Settings.DefaultColors.Text
        button.Text = text or "Button"
        button.TextSize = 14
        button.Font = GuiLib.Settings.FontBold
        button.Parent = parentContainer -- FIXED: Parent to provided container

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
            tweenProperty(button, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button:Lerp(Color3.new(1,1,1), 0.15), 0.2, Enum.EasingStyle.Quad) -- Lighten slightly
            tweenProperty(button, "Size", UDim2.new(1, 0, 0, 34), 0.2) -- Slightly taller
        end)

        button.MouseLeave:Connect(function()
            tweenProperty(button, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.2)
            tweenProperty(button, "Size", UDim2.new(1, 0, 0, 32), 0.2)
        end)

        button.MouseButton1Down:Connect(function()
            tweenProperty(button, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button:Lerp(Color3.new(0,0,0), 0.15), 0.1) -- Darken slightly
            tweenProperty(button, "Size", UDim2.new(1, 0, 0, 30), 0.1) -- Slightly shorter
        end)

        button.MouseButton1Up:Connect(function()
             -- Go back to hover state color/size if mouse is still over, else normal state
             local mousePos = UserInputService:GetMouseLocation()
             local absPos = button.AbsolutePosition
             local absSize = button.AbsoluteSize
             if mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y then
                 tweenProperty(button, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button:Lerp(Color3.new(1,1,1), 0.15), 0.1)
                 tweenProperty(button, "Size", UDim2.new(1, 0, 0, 34), 0.1)
             else
                 tweenProperty(button, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.1)
                 tweenProperty(button, "Size", UDim2.new(1, 0, 0, 32), 0.1)
             end
        end)

        if callback and type(callback) == "function" then
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
                ripple.ZIndex = button.ZIndex + 1 -- Ensure ripple is above button
                ripple.Parent = button

                local rippleCorner = Instance.new("UICorner")
                rippleCorner.CornerRadius = UDim.new(1, 0) -- Circular ripple
                rippleCorner.Parent = ripple

                tweenProperty(ripple, "Size", UDim2.new(2, 0, 2, 0), 0.5) -- Expand outwards
                tweenProperty(ripple, "BackgroundTransparency", 1, 0.5) -- Fade out

                Debris:AddItem(ripple, 0.5) -- Clean up ripple

                -- Safely call the callback
                local success, err = pcall(callback)
                if not success then
                    warn("GuiLib Button callback error:", err)
                end
            end)
        end

        -- Return the button instance directly, or a wrapper if more methods are needed
        return button
    end

    function window:AddToggle(parentContainer, text, default, callback)
         if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddToggle: Invalid parentContainer provided.")
             return nil
         end
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Name = "Toggle"
        toggleContainer.Size = UDim2.new(1, 0, 0, 30) -- Full width of parent
        toggleContainer.BackgroundTransparency = 1
        toggleContainer.Parent = parentContainer -- FIXED: Parent to provided container

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -50, 1, 0) -- Leave space for the toggle switch
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
        toggleButton.Position = UDim2.new(1, -44, 0.5, -11) -- Position on the right
        toggleButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Toggle
        toggleButton.Parent = toggleContainer

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0) -- Pill shape
        toggleCorner.Parent = toggleButton

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 18, 0, 18) -- Circle indicator
        indicator.Position = UDim2.new(0, 2, 0.5, -9) -- Initial position (left)
        indicator.BackgroundColor3 = GuiLib.Settings.DefaultColors.Text
        indicator.Parent = toggleButton

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0) -- Make it a circle
        indicatorCorner.Parent = indicator

        -- Use a TextButton for better input handling across platforms
        local clickArea = Instance.new("TextButton")
        clickArea.Name = "ClickArea"
        clickArea.Size = UDim2.new(1, 0, 1, 0) -- Cover the whole toggle container
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""
        clickArea.Parent = toggleContainer

        local isEnabled = default or false

        local function updateVisuals(animate)
             local duration = animate and 0.2 or 0 -- Conditional animation
             if isEnabled then
                 tweenProperty(toggleButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.ToggleEnabled, duration)
                 tweenProperty(indicator, "Position", UDim2.new(1, -20, 0.5, -9), duration) -- Position right (1 - indicator width - margin)
             else
                 tweenProperty(toggleButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.Toggle, duration)
                 tweenProperty(indicator, "Position", UDim2.new(0, 2, 0.5, -9), duration) -- Position left
             end
        end

        updateVisuals(false) -- Set initial state without animation

        clickArea.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            updateVisuals(true) -- Animate the change
            if callback and type(callback) == "function" then
                 -- Safely call the callback
                 local success, err = pcall(callback, isEnabled)
                 if not success then
                     warn("GuiLib Toggle callback error:", err)
                 end
            end
        end)

        local toggleFunctions = {}

        function toggleFunctions:Set(value, triggerCallback)
            if type(value) == "boolean" and value ~= isEnabled then
                isEnabled = value
                updateVisuals(true) -- Animate the change via Set
                if triggerCallback ~= false and callback and type(callback) == "function" then -- Trigger callback unless explicitly told not to
                     pcall(callback, isEnabled)
                end
            end
        end

        function toggleFunctions:Get()
            return isEnabled
        end

        function toggleFunctions:Destroy()
             toggleContainer:Destroy()
        end

        return toggleFunctions
    end

    function window:AddSlider(parentContainer, text, min, max, default, precision, callback)
         if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddSlider: Invalid parentContainer provided.")
             return nil
         end
        min = tonumber(min) or 0
        max = tonumber(max) or 100
        default = math.clamp(tonumber(default) or min, min, max)
        precision = tonumber(precision) or 1

        if min >= max then warn("AddSlider: Min value is greater than or equal to Max value.") max = min + 1 end

        local slider = Instance.new("Frame")
        slider.Name = "Slider"
        slider.Size = UDim2.new(1, 0, 0, 50) -- Full width, fixed height
        slider.BackgroundTransparency = 1
        slider.Parent = parentContainer -- FIXED: Parent to provided container

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -60, 0, 20) -- Leave space for value display
        label.Position = UDim2.new(0, 0, 0, 0)
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
        valueDisplay.Position = UDim2.new(1, -50, 0, 0) -- Position on the right
        valueDisplay.BackgroundTransparency = 1
        valueDisplay.TextColor3 = GuiLib.Settings.DefaultColors.Text
        valueDisplay.Text = tostring(default)
        valueDisplay.TextSize = 14
        valueDisplay.Font = GuiLib.Settings.FontBold
        valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        valueDisplay.Parent = slider

        -- Use TextButton for the bar to capture input easily
        local sliderBar = Instance.new("TextButton")
        sliderBar.Name = "SliderBar"
        sliderBar.Size = UDim2.new(1, 0, 0, 8) -- Thinner bar
        sliderBar.Position = UDim2.new(0, 0, 1, -18) -- Position below labels, anchored to bottom
        sliderBar.BackgroundColor3 = GuiLib.Settings.DefaultColors.Slider
        sliderBar.BorderSizePixel = 0
        sliderBar.Text = ""
        sliderBar.AutoButtonColor = false -- Disable default button color changes
        sliderBar.Parent = slider

        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0) -- Rounded bar
        sliderCorner.Parent = sliderBar

        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = GuiLib.Settings.DefaultColors.SliderFill
        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = sliderBar.ZIndex + 1 -- Ensure fill is above bar background
        sliderFill.Parent = sliderBar

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill

        -- Use TextButton for the handle for input capture
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Size = UDim2.new(0, 18, 0, 18)
        sliderButton.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor center for positioning
        sliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0) -- Position along the bar center
        sliderButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Text
        sliderButton.Text = ""
        sliderButton.AutoButtonColor = false
        sliderButton.ZIndex = sliderBar.ZIndex + 2 -- Ensure handle is above fill
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
        buttonShadow.ZIndex = sliderButton.ZIndex - 1 -- Behind the button itself
        buttonShadow.Parent = sliderButton

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0) -- Circular handle
        buttonCorner.Parent = sliderButton

        local currentValue = default

        local function formatValue(val)
            -- Format based on precision to avoid floating point issues
            local factor = 1 / precision
            local formattedVal = math.floor(val * factor + 0.5) / factor -- Round to nearest precision step
            -- Optional: Remove trailing zeros if precision allows decimals
            -- return string.format("%." .. math.max(0, -math.floor(math.log10(precision))) .. "f", formattedVal)
            return tostring(formattedVal)
        end

        local function updateSlider(value, animate)
            local newValue = math.clamp(value, min, max)
            -- Apply precision step
            if precision > 0 then
                 newValue = math.floor(newValue / precision + 0.5) * precision
            end

            local percent = (newValue - min) / (max - min)
            local duration = animate and 0.1 or 0

            tweenProperty(sliderFill, "Size", UDim2.new(percent, 0, 1, 0), duration, Enum.EasingStyle.Linear)
            tweenProperty(sliderButton, "Position", UDim2.new(percent, 0, 0.5, 0), duration, Enum.EasingStyle.Linear) -- Use anchor point
            valueDisplay.Text = formatValue(newValue)

            -- Trigger callback only if value actually changed
            if newValue ~= currentValue then
                 currentValue = newValue -- Update internal state *after* check
                 if callback and type(callback) == "function" then
                      local success, err = pcall(callback, newValue)
                      if not success then warn("GuiLib Slider callback error:", err) end
                 end
            else
                 currentValue = newValue -- Still update internal state
            end
            return newValue
        end

        updateSlider(currentValue, false) -- Set initial state

        local dragging = false

        -- Function to calculate value from input position
        local function calculateValueFromPosition(inputPosition)
            local barAbsPos = sliderBar.AbsolutePosition
            local barAbsSize = sliderBar.AbsoluteSize
            if barAbsSize.X == 0 then return currentValue end -- Avoid division by zero if bar not rendered yet
            local relativeX = inputPosition.X - barAbsPos.X
            local percent = math.clamp(relativeX / barAbsSize.X, 0, 1)
            return min + (max - min) * percent
        end

        -- Handle initial press on the handle
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                tweenProperty(sliderButton, "Size", UDim2.new(0, 22, 0, 22), 0.15) -- Grow when dragging
                input:StopPropagation()
            end
        end)

        -- Handle click/tap on the bar itself
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true -- Allow dragging even if starting on the bar
                tweenProperty(sliderButton, "Size", UDim2.new(0, 22, 0, 22), 0.15)
                local newValue = calculateValueFromPosition(input.Position)
                updateSlider(newValue, true) -- Update slider immediately and animate
                input:StopPropagation()
            end
        end)

        -- Handle input ending anywhere (catches mouse button / touch release)
        local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                dragging = false
                tweenProperty(sliderButton, "Size", UDim2.new(0, 18, 0, 18), 0.15) -- Return to normal size
            end
        end)

        -- Handle drag movement anywhere (catches mouse move / touch move)
        local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local newValue = calculateValueFromPosition(input.Position)
                updateSlider(newValue, false) -- Update slider without animation during drag for responsiveness
            end
        end)

        local sliderFunctions = {}

        function sliderFunctions:Set(value, triggerCallback)
             local clampedValue = math.clamp(tonumber(value) or currentValue, min, max)
             updateSlider(clampedValue, true) -- Animate the change from Set
             -- Manually trigger callback if requested and value changed
             if triggerCallback ~= false and clampedValue ~= currentValue and callback and type(callback) == "function" then
                  -- Update currentValue before callback call in Set context
                  local previousValue = currentValue
                  currentValue = clampedValue
                  pcall(callback, currentValue)
                  currentValue = previousValue -- Restore temporarily if needed, though updateSlider handles the final set
                  updateSlider(clampedValue, true) -- Ensure visual consistency
             end
        end

        function sliderFunctions:Get()
            return currentValue
        end

        function sliderFunctions:Destroy()
             -- Disconnect connections to prevent memory leaks
             if inputEndedConn then inputEndedConn:Disconnect() inputEndedConn = nil end
             if inputChangedConn then inputChangedConn:Disconnect() inputChangedConn = nil end
             slider:Destroy()
        end

        return sliderFunctions
    end

    function window:AddDropdown(parentContainer, text, options, default, callback)
         if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddDropdown: Invalid parentContainer provided.")
             return nil
         end
        options = options or {}
        local currentSelection = default or (options[1]) or "Select"

        local dropdown = Instance.new("Frame")
        dropdown.Name = "Dropdown"
        dropdown.Size = UDim2.new(1, 0, 0, 60) -- Full width, fixed height
        dropdown.BackgroundTransparency = 1
        dropdown.ZIndex = 2 -- Default ZIndex for dropdown container
        dropdown.Parent = parentContainer -- FIXED: Parent to provided container

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0,0,0,0)
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
        dropButton.Position = UDim2.new(0, 0, 1, -36) -- Anchor bottom
        dropButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        dropButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
        dropButton.Text = tostring(currentSelection) -- Ensure string
        dropButton.TextSize = 14
        dropButton.Font = GuiLib.Settings.FontRegular
        dropButton.TextXAlignment = Enum.TextXAlignment.Left
        dropButton.TextTruncate = Enum.TextTruncate.AtEnd
        dropButton.PaddingLeft = UDim.new(0, 10)
        dropButton.PaddingRight = UDim.new(0, 30) -- Make space for icon
        dropButton.ZIndex = dropdown.ZIndex + 1
        dropButton.Parent = dropdown

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = GuiLib.Settings.CornerRadius
        buttonCorner.Parent = dropButton

        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 1, 0) -- Use full height of button
        icon.Position = UDim2.new(1, -25, 0, 0) -- Position on the right
        icon.BackgroundTransparency = 1
        icon.TextColor3 = GuiLib.Settings.DefaultColors.Text
        icon.Text = "▼" -- Down arrow
        icon.TextSize = 14
        icon.Font = GuiLib.Settings.FontBold
        icon.TextScaled = true -- Scale text to fit
        icon.ZIndex = dropButton.ZIndex + 1
        icon.Parent = dropButton

        local dropFrame = Instance.new("Frame")
        dropFrame.Name = "DropFrame"
        dropFrame.Size = UDim2.new(1, 0, 0, 0) -- Start closed (height 0)
        dropFrame.Position = UDim2.new(0, 0, 1, 0) -- Position below the button
        dropFrame.BackgroundColor3 = GuiLib.Settings.DefaultColors.Dropdown
        dropFrame.BorderSizePixel = 1
        dropFrame.BorderColor3 = GuiLib.Settings.DefaultColors.Accent
        dropFrame.ClipsDescendants = true
        dropFrame.Visible = false -- Start invisible
        dropFrame.ZIndex = dropdown.ZIndex + 10 -- Ensure dropdown is above everything else
        dropFrame.Parent = dropButton -- Parent to button for positioning

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = GuiLib.Settings.CornerRadius
        frameCorner.Parent = dropFrame

        local optionList = Instance.new("ScrollingFrame")
        optionList.Name = "OptionList"
        optionList.Size = UDim2.new(1, -4, 1, -4) -- Padding inside dropFrame
        optionList.Position = UDim2.new(0, 2, 0, 2)
        optionList.BackgroundTransparency = 1
        optionList.BorderSizePixel = 0
        optionList.ScrollBarThickness = 4
        optionList.ScrollBarImageColor3 = GuiLib.Settings.DefaultColors.ScrollBar
        optionList.CanvasSize = UDim2.new(0,0,0,0)
        optionList.ScrollingDirection = Enum.ScrollingDirection.Y
        optionList.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        optionList.ZIndex = dropFrame.ZIndex + 1
        optionList.Parent = dropFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = optionList

        local isOpen = false
        local OPTION_HEIGHT = 30
        local MAX_DROPDOWN_HEIGHT = 150 -- Limit max height

        local function updateDropdownVisuals(animate)
            local duration = animate and 0.2 or 0
            if isOpen then
                 icon.Text = "▲" -- Up arrow
                 dropFrame.Visible = true
                 local totalOptionsHeight = #options * OPTION_HEIGHT + math.max(0, #options - 1) * listLayout.Padding.Offset
                 local targetHeight = math.min(totalOptionsHeight + 4, MAX_DROPDOWN_HEIGHT) -- +4 for padding

                 tweenProperty(dropFrame, "Size", UDim2.new(1, 0, 0, targetHeight), duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                 optionList.CanvasSize = UDim2.new(0, 0, 0, totalOptionsHeight)
            else
                 icon.Text = "▼" -- Down arrow
                 tweenProperty(dropFrame, "Size", UDim2.new(1, 0, 0, 0), duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                 -- Use task.delay or delay to hide after animation
                 local delayFunc = task and task.delay or delay
                 delayFunc(duration, function()
                      if not isOpen and dropFrame and dropFrame.Parent then -- Check if still closed and valid
                           dropFrame.Visible = false
                      end
                 end)
            end
        end

        local function toggleDropdown()
            isOpen = not isOpen
            updateDropdownVisuals(true)
        end

        dropButton.MouseButton1Click:Connect(toggleDropdown)

        -- Hover effect for main button
        dropButton.MouseEnter:Connect(function()
            tweenProperty(dropButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button:Lerp(Color3.new(1,1,1), 0.1), 0.2)
        end)
        dropButton.MouseLeave:Connect(function()
            tweenProperty(dropButton, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.2)
        end)

        -- Function to create a single option button
        local function createOptionButton(optionText)
             local optionButton = Instance.new("TextButton")
             optionButton.Name = "Option_" .. tostring(optionText)
             optionButton.Size = UDim2.new(1, 0, 0, OPTION_HEIGHT)
             optionButton.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
             optionButton.BackgroundTransparency = 0.5
             optionButton.TextColor3 = GuiLib.Settings.DefaultColors.Text
             optionButton.Text = tostring(optionText)
             optionButton.TextSize = 14
             optionButton.Font = GuiLib.Settings.FontRegular
             optionButton.ZIndex = optionList.ZIndex + 1
             optionButton.Parent = optionList

             local optionCorner = Instance.new("UICorner")
             optionCorner.CornerRadius = GuiLib.Settings.CornerRadius
             optionCorner.Parent = optionButton

             -- Option hover effect
             optionButton.MouseEnter:Connect(function()
                 tweenProperty(optionButton, "BackgroundTransparency", 0.3, 0.15)
             end)
             optionButton.MouseLeave:Connect(function()
                 tweenProperty(optionButton, "BackgroundTransparency", 0.5, 0.15)
             end)

             optionButton.MouseButton1Click:Connect(function()
                 if currentSelection ~= optionText then -- Only update if selection changed
                      currentSelection = optionText
                      dropButton.Text = tostring(currentSelection)
                      if callback and type(callback) == "function" then
                           local success, err = pcall(callback, currentSelection)
                           if not success then warn("GuiLib Dropdown callback error:", err) end
                      end
                 end
                 if isOpen then toggleDropdown() end -- Close dropdown after selection
             end)
             return optionButton
        end

        -- Function to populate options
        local function populateOptions(opts)
             -- Clear existing options
             for _, child in ipairs(optionList:GetChildren()) do
                 if child:IsA("TextButton") or child:IsA("UICorner") or child:IsA("UIListLayout") then
                     if not child:IsA("UIListLayout") then -- Don't destroy the layout itself
                          child:Destroy()
                     end
                 end
             end
             -- Add new options
             for _, optionValue in ipairs(opts) do
                 createOptionButton(optionValue)
             end
             -- Update canvas size after adding options
             local totalOptionsHeight = #opts * OPTION_HEIGHT + math.max(0, #opts - 1) * listLayout.Padding.Offset
             optionList.CanvasSize = UDim2.new(0, 0, 0, totalOptionsHeight)
             -- Adjust dropdown frame height if open
             if isOpen then updateDropdownVisuals(false) end
        end

        populateOptions(options) -- Initial population

        -- Close dropdown when clicking outside
        local inputBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end -- Don't process if already handled by core scripts

            if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                 -- Check if the click was outside the dropdown button AND the dropdown frame
                 local mousePos = input.Position
                 local buttonAbsPos = dropButton.AbsolutePosition
                 local buttonAbsSize = dropButton.AbsoluteSize
                 local frameAbsPos = dropFrame.AbsolutePosition
                 local frameAbsSize = dropFrame.AbsoluteSize

                 local clickedButton = mousePos.X >= buttonAbsPos.X and mousePos.X <= buttonAbsPos.X + buttonAbsSize.X and
                                      mousePos.Y >= buttonAbsPos.Y and mousePos.Y <= buttonAbsPos.Y + buttonAbsSize.Y
                 local clickedFrame = mousePos.X >= frameAbsPos.X and mousePos.X <= frameAbsPos.X + frameAbsSize.X and
                                      mousePos.Y >= frameAbsPos.Y and mousePos.Y <= frameAbsPos.Y + frameAbsSize.Y

                 if not clickedButton and not clickedFrame then
                      toggleDropdown()
                 end
            end
        end)

        local dropdownFunctions = {}

        function dropdownFunctions:Set(optionValue, triggerCallback)
             local found = false
             for _, opt in ipairs(options) do
                 if opt == optionValue then
                     found = true
                     break
                 end
             end

             if found and optionValue ~= currentSelection then
                 currentSelection = optionValue
                 dropButton.Text = tostring(currentSelection)
                 if triggerCallback ~= false and callback and type(callback) == "function" then
                      pcall(callback, currentSelection)
                 end
             elseif not found then
                 warn("Dropdown:Set - Provided option not found in current options:", optionValue)
             end
        end

        function dropdownFunctions:Get()
            return currentSelection
        end

        function dropdownFunctions:Refresh(newOptions, keepSelection)
            options = newOptions or {} -- Update internal options list
            populateOptions(options)

            local selectionStillValid = false
            if keepSelection then
                 for _, opt in ipairs(options) do
                      if opt == currentSelection then
                           selectionStillValid = true
                           break
                      end
                 end
            end

            if not selectionStillValid then
                 currentSelection = options[1] or "Select" -- Reset to first or default
                 dropButton.Text = tostring(currentSelection)
                 -- Optionally trigger callback on reset? Decide based on desired behavior.
                 -- if callback then pcall(callback, currentSelection) end
            end
        end

        function dropdownFunctions:Destroy()
             if inputBeganConn then inputBeganConn:Disconnect() inputBeganConn = nil end
             dropdown:Destroy()
        end

        return dropdownFunctions
    end

    function window:AddColorPicker(parentContainer, text, default, callback)
         if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddColorPicker: Invalid parentContainer provided.")
             return nil
         end
        default = default or Color3.fromRGB(255, 255, 255)
        if typeof(default) ~= "Color3" then default = Color3.fromRGB(255,255,255) end

        local colorPicker = Instance.new("Frame")
        colorPicker.Name = "ColorPicker"
        colorPicker.Size = UDim2.new(1, 0, 0, 35) -- Full width, fixed height
        colorPicker.BackgroundTransparency = 1
        colorPicker.Parent = parentContainer -- FIXED: Parent to provided container

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -50, 1, 0) -- Leave space for color display
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Color Picker"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = colorPicker

        local colorDisplayButton = Instance.new("TextButton") -- Use button for click
        colorDisplayButton.Name = "ColorDisplay"
        colorDisplayButton.Size = UDim2.new(0, 35, 1, 0) -- Square on the right
        colorDisplayButton.Position = UDim2.new(1, -35, 0, 0)
        colorDisplayButton.BackgroundColor3 = default
        colorDisplayButton.Text = ""
        colorDisplayButton.AutoButtonColor = false
        colorDisplayButton.Parent = colorPicker

        local displayCorner = Instance.new("UICorner")
        displayCorner.CornerRadius = GuiLib.Settings.CornerRadius
        displayCorner.Parent = colorDisplayButton

        -- Add border to display for better visibility
        local displayBorder = Instance.new("UIStroke")
        displayBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        displayBorder.Color = GuiLib.Settings.DefaultColors.Text
        displayBorder.Thickness = 1
        displayBorder.Transparency = 0.5
        displayBorder.Parent = colorDisplayButton

        -- Color picker popup frame
        local pickerFrame = Instance.new("Frame")
        pickerFrame.Name = "PickerFrame"
        pickerFrame.Size = UDim2.new(0, 240, 0, 0) -- Start closed
        pickerFrame.Position = UDim2.new(0, 0, 1, 5) -- Position below the display button
        pickerFrame.BackgroundColor3 = GuiLib.Settings.DefaultColors.Background
        pickerFrame.BackgroundTransparency = 1 -- Start transparent
        pickerFrame.BorderSizePixel = 1
        pickerFrame.BorderColor3 = GuiLib.Settings.DefaultColors.Accent
        pickerFrame.ClipsDescendants = true
        pickerFrame.Visible = false
        pickerFrame.ZIndex = 100 -- High ZIndex
        pickerFrame.Parent = colorDisplayButton -- Parent to button for positioning

        local pickerCorner = Instance.new("UICorner")
        pickerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        pickerCorner.Parent = pickerFrame

        -- Shadow for picker frame (optional, can add visual clutter)
        --[[ local pickerShadow = Instance.new("ImageLabel") ... ]]

        -- Color saturation/value picker field (Main square)
        local colorField = Instance.new("Frame")
        colorField.Name = "ColorField"
        colorField.Size = UDim2.new(1, -20, 1, -50) -- Leave space for hue/alpha/etc.
        colorField.Position = UDim2.new(0, 10, 0, 10)
        colorField.BackgroundColor3 = Color3.fromHSV(0, 1, 1) -- Start at pure red
        colorField.BorderSizePixel = 0
        colorField.ZIndex = pickerFrame.ZIndex + 1
        colorField.Parent = pickerFrame

        local colorFieldCorner = Instance.new("UICorner")
        colorFieldCorner.CornerRadius = UDim.new(0, 4)
        colorFieldCorner.Parent = colorField

        -- Saturation Gradient (White to Transparent Left-to-Right)
        local saturationGradient = Instance.new("UIGradient")
        saturationGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), -- White
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))  -- White
        })
        saturationGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0), -- Opaque white
            NumberSequenceKeypoint.new(1, 1)  -- Transparent white
        })
        saturationGradient.Rotation = 0 -- Horizontal
        saturationGradient.Parent = colorField

        -- Value/Brightness Gradient (Transparent to Black Top-to-Bottom)
        local valueGradient = Instance.new("UIGradient")
        valueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), -- Black
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))  -- Black
        })
        valueGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), -- Transparent black
            NumberSequenceKeypoint.new(1, 0)  -- Opaque black
        })
        valueGradient.Rotation = 90 -- Vertical
        valueGradient.Parent = colorField

        -- Selector/Cursor for the main color field
        local colorSelector = Instance.new("Frame")
        colorSelector.Name = "ColorSelector"
        colorSelector.Size = UDim2.new(0, 10, 0, 10)
        colorSelector.AnchorPoint = Vector2.new(0.5, 0.5)
        colorSelector.BackgroundColor3 = Color3.new(1, 1, 1) -- White selector initially
        colorSelector.BorderSizePixel = 0
        colorSelector.ZIndex = colorField.ZIndex + 1
        colorSelector.Parent = colorField

        local selectorCorner = Instance.new("UICorner")
        selectorCorner.CornerRadius = UDim.new(1, 0) -- Circular selector
        selectorCorner.Parent = colorSelector
        local selectorStroke = Instance.new("UIStroke") -- Add outline
        selectorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        selectorStroke.Color = Color3.new(0,0,0)
        selectorStroke.Thickness = 1
        selectorStroke.Parent = colorSelector


        -- Hue selector bar
        local hueFrame = Instance.new("Frame")
        hueFrame.Name = "HueFrame"
        hueFrame.Size = UDim2.new(1, -20, 0, 20)
        hueFrame.Position = UDim2.new(0, 10, 1, -30) -- Below color field
        hueFrame.ZIndex = pickerFrame.ZIndex + 1
        hueFrame.Parent = pickerFrame

        local hueGradient = Instance.new("UIGradient")
        hueGradient.Color = ColorSequence.new({ -- Standard Hue Rainbow
            ColorSequenceKeypoint.new(0/6, Color3.fromRGB(255, 0, 0)), -- Red
            ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)), -- Yellow
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)), -- Green
            ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)), -- Cyan
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)), -- Blue
            ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)), -- Magenta
            ColorSequenceKeypoint.new(6/6, Color3.fromRGB(255, 0, 0))  -- Red (Wrap)
        })
        hueGradient.Rotation = 0 -- Horizontal
        hueGradient.Parent = hueFrame

        local hueCorner = Instance.new("UICorner")
        hueCorner.CornerRadius = UDim.new(0, 4)
        hueCorner.Parent = hueFrame

        -- Hue selector/cursor
        local hueSelector = Instance.new("Frame")
        hueSelector.Name = "HueSelector"
        hueSelector.Size = UDim2.new(0, 6, 1, 4) -- Taller than bar
        hueSelector.Position = UDim2.new(0, -3, 0, -2) -- Initial position (left)
        hueSelector.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor
        hueSelector.BackgroundColor3 = Color3.new(1,1,1)
        hueSelector.BorderSizePixel = 1
        hueSelector.BorderColor3 = Color3.new(0,0,0)
        hueSelector.ZIndex = hueFrame.ZIndex + 1
        hueSelector.Parent = hueFrame

        -- Logic and functionality
        local pickerOpen = false
        local selectedColor = default
        local currentHue, currentSat, currentVal = Color3.toHSV(default)

        local function updatePickerVisuals()
            local hsvColor = Color3.fromHSV(currentHue, currentSat, currentVal)
            tweenProperty(colorDisplayButton, "BackgroundColor3", hsvColor, 0.1)

            -- Update main field background color based on hue
            colorField.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)

            -- Update color selector position and border color
            colorSelector.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
             -- Set selector border color to contrast with background
            selectorStroke.Color = (currentVal > 0.5) and Color3.new(0,0,0) or Color3.new(1,1,1)


            -- Update hue selector position
            hueSelector.Position = UDim2.new(currentHue, 0, 0.5, 0)

            if callback and type(callback) == "function" then
                 -- Only call callback if color actually changed meaningfully
                 -- Compare RGB values as HSV can be tricky with precision
                 local roundedNew = Color3.fromRGB(math.floor(hsvColor.R*255+0.5), math.floor(hsvColor.G*255+0.5), math.floor(hsvColor.B*255+0.5))
                 local roundedOld = Color3.fromRGB(math.floor(selectedColor.R*255+0.5), math.floor(selectedColor.G*255+0.5), math.floor(selectedColor.B*255+0.5))
                 if roundedNew ~= roundedOld then
                      selectedColor = hsvColor -- Update selected color state
                      pcall(callback, selectedColor)
                 end
            else
                 selectedColor = hsvColor -- Update selected color state even without callback
            end
        end

        updatePickerVisuals() -- Set initial state

        local function togglePicker()
            pickerOpen = not pickerOpen
            local targetHeight = 240 -- Full height

            if pickerOpen then
                pickerFrame.Visible = true
                tweenProperty(pickerFrame, "BackgroundTransparency", GuiLib.Settings.DefaultTransparency - 0.1, 0.2)
                tweenProperty(pickerFrame, "Size", UDim2.new(0, 240, 0, targetHeight), 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            else
                tweenProperty(pickerFrame, "BackgroundTransparency", 1, 0.2)
                tweenProperty(pickerFrame, "Size", UDim2.new(0, 240, 0, 0), 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local delayFunc = task and task.delay or delay
                delayFunc(0.2, function()
                    if not pickerOpen and pickerFrame and pickerFrame.Parent then
                        pickerFrame.Visible = false
                    end
                end)
            end
        end

        colorDisplayButton.MouseButton1Click:Connect(togglePicker)

        -- Input handling for color field (Saturation/Value)
        local fieldDragging = false
        colorField.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                fieldDragging = true
                local relPos = input.Position - colorField.AbsolutePosition
                local size = colorField.AbsoluteSize
                if size.X == 0 or size.Y == 0 then return end
                currentSat = math.clamp(relPos.X / size.X, 0, 1)
                currentVal = math.clamp(1 - (relPos.Y / size.Y), 0, 1)
                updatePickerVisuals()
                input:StopPropagation()
            end
        end)
        colorField.InputChanged:Connect(function(input)
            if fieldDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relPos = input.Position - colorField.AbsolutePosition
                local size = colorField.AbsoluteSize
                 if size.X == 0 or size.Y == 0 then return end
                currentSat = math.clamp(relPos.X / size.X, 0, 1)
                currentVal = math.clamp(1 - (relPos.Y / size.Y), 0, 1)
                updatePickerVisuals()
            end
        end)
        colorField.InputEnded:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                  fieldDragging = false
             end
        end)


        -- Input handling for hue slider
        local hueDragging = false
        hueFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = true
                local relX = input.Position.X - hueFrame.AbsolutePosition.X
                local sizeX = hueFrame.AbsoluteSize.X
                 if sizeX == 0 then return end
                currentHue = math.clamp(relX / sizeX, 0, 1)
                updatePickerVisuals()
                input:StopPropagation()
            end
        end)
        hueFrame.InputChanged:Connect(function(input)
            if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relX = input.Position.X - hueFrame.AbsolutePosition.X
                local sizeX = hueFrame.AbsoluteSize.X
                 if sizeX == 0 then return end
                currentHue = math.clamp(relX / sizeX, 0, 1)
                updatePickerVisuals()
            end
        end)
         hueFrame.InputEnded:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                  hueDragging = false
             end
        end)


        -- Close picker when clicking outside
        local inputBeganConnPicker = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and pickerOpen then
                local mousePos = input.Position
                local pickerAbsPos = pickerFrame.AbsolutePosition
                local pickerAbsSize = pickerFrame.AbsoluteSize
                local buttonAbsPos = colorDisplayButton.AbsolutePosition
                local buttonAbsSize = colorDisplayButton.AbsoluteSize

                 local clickedPicker = mousePos.X >= pickerAbsPos.X and mousePos.X <= pickerAbsPos.X + pickerAbsSize.X and
                                       mousePos.Y >= pickerAbsPos.Y and mousePos.Y <= pickerAbsPos.Y + pickerAbsSize.Y
                 local clickedButton = mousePos.X >= buttonAbsPos.X and mousePos.X <= buttonAbsPos.X + buttonAbsSize.X and
                                       mousePos.Y >= buttonAbsPos.Y and mousePos.Y <= buttonAbsPos.Y + buttonAbsSize.Y

                if not clickedPicker and not clickedButton then
                    togglePicker()
                end
            end
        end)

        local colorFunctions = {}

        function colorFunctions:Set(colorValue, triggerCallback)
            if typeof(colorValue) == "Color3" then
                 local h, s, v = Color3.toHSV(colorValue)
                 local oldH, oldS, oldV = currentHue, currentSat, currentVal

                 currentHue, currentSat, currentVal = h, s, v
                 updatePickerVisuals() -- Update visuals based on new HSV

                 -- Manually trigger callback if requested and color changed
                 if triggerCallback ~= false and (h~=oldH or s~=oldS or v~=oldV) and callback and type(callback) == "function" then
                      pcall(callback, selectedColor)
                 end
            end
        end

        function colorFunctions:Get()
            return selectedColor
        end

        function colorFunctions:Destroy()
            if inputBeganConnPicker then inputBeganConnPicker:Disconnect() inputBeganConnPicker = nil end
             -- Potentially disconnect field/hue input ended connections too if needed
            colorPicker:Destroy()
        end

        return colorFunctions
    end

    function window:AddTextBox(parentContainer, text, placeholder, defaultText, callback)
         if not parentContainer or not parentContainer:IsA("GuiObject") then
             warn("AddTextBox: Invalid parentContainer provided.")
             return nil
         end
        local textBox = Instance.new("Frame")
        textBox.Name = "TextBox"
        textBox.Size = UDim2.new(1, 0, 0, 55) -- Full width, fixed height
        textBox.BackgroundTransparency = 1
        textBox.Parent = parentContainer -- FIXED: Parent to provided container

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0,0,0,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GuiLib.Settings.DefaultColors.Text
        label.Text = text or "Text Input"
        label.TextSize = 14
        label.Font = GuiLib.Settings.FontRegular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textBox

        -- Container for the actual input box for styling
        local inputContainer = Instance.new("Frame")
        inputContainer.Name = "InputContainer"
        inputContainer.Size = UDim2.new(1, 0, 0, 35)
        inputContainer.Position = UDim2.new(0, 0, 1, -35) -- Position below label
        inputContainer.BackgroundColor3 = GuiLib.Settings.DefaultColors.Button
        inputContainer.BackgroundTransparency = 0.2
        inputContainer.Parent = textBox

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = GuiLib.Settings.CornerRadius
        containerCorner.Parent = inputContainer
        local containerStroke = Instance.new("UIStroke") -- Add border
        containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        containerStroke.Color = GuiLib.Settings.DefaultColors.Accent
        containerStroke.Thickness = 1
        containerStroke.Transparency = 0.8 -- Subtle border initially
        containerStroke.Parent = inputContainer


        local inputBox = Instance.new("TextBox")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(1, -16, 1, -8) -- Padding inside container
        inputBox.Position = UDim2.new(0, 8, 0, 4)
        inputBox.BackgroundTransparency = 1
        inputBox.TextColor3 = GuiLib.Settings.DefaultColors.Text
        inputBox.PlaceholderText = placeholder or "Enter text here..."
        inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        inputBox.Text = defaultText or ""
        inputBox.TextSize = 14
        inputBox.Font = GuiLib.Settings.FontRegular
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.ClearTextOnFocus = false -- Usually better not to clear
        inputBox.ClipsDescendants = true
        inputBox.ZIndex = inputContainer.ZIndex + 1
        inputBox.Parent = inputContainer

        -- Focused effect
        inputBox.Focused:Connect(function()
            tweenProperty(inputContainer, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button:Lerp(Color3.new(1,1,1), 0.05), 0.2)
            tweenProperty(inputContainer, "BackgroundTransparency", 0.1, 0.2)
            tweenProperty(containerStroke, "Transparency", 0.2, 0.2) -- Highlight border
        end)

        inputBox.FocusLost:Connect(function(enterPressed)
            tweenProperty(inputContainer, "BackgroundColor3", GuiLib.Settings.DefaultColors.Button, 0.2)
            tweenProperty(inputContainer, "BackgroundTransparency", 0.2, 0.2)
            tweenProperty(containerStroke, "Transparency", 0.8, 0.2) -- Dim border

            -- Trigger callback on Enter press or focus lost (if needed)
             -- Usually callback triggers on Changed, but Enter press is common for submission
            if enterPressed and callback and type(callback) == "function" then
                -- Optionally check if text actually changed before calling
                pcall(callback, inputBox.Text, true) -- Pass true to indicate Enter press
            end
        end)

        -- Callback on text change
        local lastText = inputBox.Text
        if callback and type(callback) == "function" then
            inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                 if inputBox.Text ~= lastText then -- Check if text actually changed
                      lastText = inputBox.Text
                      local success, err = pcall(callback, inputBox.Text, false) -- Pass false for non-Enter change
                      if not success then warn("GuiLib TextBox callback error:", err) end
                 end
            end)
        end

        local textBoxFunctions = {}

        function textBoxFunctions:Set(newText, triggerCallback)
            local textStr = tostring(newText or "")
            if textStr ~= inputBox.Text then
                 inputBox.Text = textStr
                 lastText = textStr -- Update internal tracker
                 if triggerCallback ~= false and callback and type(callback) == "function" then
                     pcall(callback, textStr, false)
                 end
            end
        end

        function textBoxFunctions:Get()
            return inputBox.Text
        end

        function textBoxFunctions:Destroy()
             textBox:Destroy()
        end

        return textBoxFunctions
    end


    -- Return the main window object with all its methods
    return window
end

-- Theme management
function GuiLib:SetTheme(theme)
    if theme and typeof(theme) == "table" then
        for category, settings in pairs(theme) do
            if self.Settings[category] and typeof(settings) == "table" then
                for key, value in pairs(settings) do
                    if self.Settings[category][key] then
                        -- Basic type check before assigning
                        if typeof(value) == typeof(self.Settings[category][key]) then
                             self.Settings[category][key] = value
                        else
                             warn(string.format("SetTheme: Type mismatch for %s.%s. Expected %s, got %s.",
                                  category, key, typeof(self.Settings[category][key]), typeof(value)))
                        end
                    end
                end
            end
        end
        -- Potentially add a way to force-refresh existing UI elements with the new theme here
    end
end

-- Predefined themes (Unchanged)
GuiLib.Themes = {
    Dark = { DefaultColors = { Background = Color3.fromRGB(30, 30, 30), Title = Color3.fromRGB(50, 50, 50), Button = Color3.fromRGB(50, 50, 50), ButtonEnabled = Color3.fromRGB(50, 150, 50), ButtonDisabled = Color3.fromRGB(150, 50, 50), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(100, 100, 100), SliderFill = Color3.fromRGB(0, 162, 255), Toggle = Color3.fromRGB(70, 70, 70), ToggleEnabled = Color3.fromRGB(0, 162, 255), Dropdown = Color3.fromRGB(40, 40, 40), ScrollBar = Color3.fromRGB(60, 60, 60), Accent = Color3.fromRGB(0, 162, 255) } },
    Light = { DefaultColors = { Background = Color3.fromRGB(230, 230, 230), Title = Color3.fromRGB(200, 200, 200), Button = Color3.fromRGB(200, 200, 200), ButtonEnabled = Color3.fromRGB(100, 200, 100), ButtonDisabled = Color3.fromRGB(200, 100, 100), Text = Color3.fromRGB(50, 50, 50), Slider = Color3.fromRGB(180, 180, 180), SliderFill = Color3.fromRGB(0, 122, 215), Toggle = Color3.fromRGB(170, 170, 170), ToggleEnabled = Color3.fromRGB(0, 122, 215), Dropdown = Color3.fromRGB(210, 210, 210), ScrollBar = Color3.fromRGB(180, 180, 180), Accent = Color3.fromRGB(0, 122, 215) } },
    BlueTheme = { DefaultColors = { Background = Color3.fromRGB(20, 30, 50), Title = Color3.fromRGB(30, 40, 60), Button = Color3.fromRGB(40, 50, 70), ButtonEnabled = Color3.fromRGB(50, 150, 220), ButtonDisabled = Color3.fromRGB(150, 50, 50), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(50, 60, 80), SliderFill = Color3.fromRGB(50, 150, 220), Toggle = Color3.fromRGB(40, 50, 70), ToggleEnabled = Color3.fromRGB(50, 150, 220), Dropdown = Color3.fromRGB(30, 40, 60), ScrollBar = Color3.fromRGB(50, 60, 80), Accent = Color3.fromRGB(50, 150, 220) } },
    RedTheme = { DefaultColors = { Background = Color3.fromRGB(50, 25, 25), Title = Color3.fromRGB(70, 35, 35), Button = Color3.fromRGB(80, 40, 40), ButtonEnabled = Color3.fromRGB(150, 50, 50), ButtonDisabled = Color3.fromRGB(50, 50, 150), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(90, 45, 45), SliderFill = Color3.fromRGB(200, 50, 50), Toggle = Color3.fromRGB(80, 40, 40), ToggleEnabled = Color3.fromRGB(200, 50, 50), Dropdown = Color3.fromRGB(70, 35, 35), ScrollBar = Color3.fromRGB(90, 45, 45), Accent = Color3.fromRGB(200, 50, 50) } },
    GreenTheme = { DefaultColors = { Background = Color3.fromRGB(25, 50, 25), Title = Color3.fromRGB(35, 70, 35), Button = Color3.fromRGB(40, 80, 40), ButtonEnabled = Color3.fromRGB(50, 150, 50), ButtonDisabled = Color3.fromRGB(150, 50, 50), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(45, 90, 45), SliderFill = Color3.fromRGB(50, 200, 50), Toggle = Color3.fromRGB(40, 80, 40), ToggleEnabled = Color3.fromRGB(50, 200, 50), Dropdown = Color3.fromRGB(35, 70, 35), ScrollBar = Color3.fromRGB(45, 90, 45), Accent = Color3.fromRGB(50, 200, 50) } }
}

-- Safe initialization / Return the library
-- No pcall needed here as module scripts handle errors gracefully during require
return GuiLib

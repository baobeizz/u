-- VenyX Mobile UI Library for Delta Executor
-- Optimized for mobile touch controls

local VenyxLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- สร้าง ScreenGui
local function CreateScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VenyxMobileUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- ตรวจสอบว่าใช้ Delta หรือไม่
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    return ScreenGui
end

-- ฟังก์ชัน Tween
local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- สร้าง UI Effect
local function CreateRipple(parent, x, y)
    local Ripple = Instance.new("Frame")
    Ripple.Name = "Ripple"
    Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Ripple.BackgroundTransparency = 0.5
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0, x, 0, y)
    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    Ripple.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Ripple
    
    Tween(Ripple, {Size = UDim2.new(0, 100, 0, 100), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        Ripple:Destroy()
    end)
end

-- สร้าง Window
function VenyxLib:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "VenyX Mobile"
    local Theme = config.Theme or "Dark"
    
    local ScreenGui = CreateScreenGui()
    
    -- สี Theme
    local Colors = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 25),
            Secondary = Color3.fromRGB(25, 25, 30),
            Accent = Color3.fromRGB(138, 43, 226),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(180, 180, 180)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 245),
            Secondary = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(138, 43, 226),
            Text = Color3.fromRGB(20, 20, 25),
            SubText = Color3.fromRGB(100, 100, 100)
        }
    }
    
    local CurrentTheme = Colors[Theme] or Colors.Dark
    
    -- Toggle Button (ปุ่มเปิด/ปิด UI)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(0, 10, 0.5, -30)
    ToggleButton.BackgroundColor3 = CurrentTheme.Accent
    ToggleButton.Text = "☰"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 28
    ToggleButton.Parent = ScreenGui
    ToggleButton.ZIndex = 1000
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleShadow = Instance.new("ImageLabel")
    ToggleShadow.Name = "Shadow"
    ToggleShadow.BackgroundTransparency = 1
    ToggleShadow.Position = UDim2.new(0, -5, 0, -5)
    ToggleShadow.Size = UDim2.new(1, 10, 1, 10)
    ToggleShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    ToggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ToggleShadow.ImageTransparency = 0.7
    ToggleShadow.ZIndex = 999
    ToggleShadow.Parent = ToggleButton
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 600)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = CurrentTheme.Secondary
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 16)
    HeaderFix.Position = UDim2.new(0, 0, 1, -16)
    HeaderFix.BackgroundColor3 = CurrentTheme.Secondary
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 24
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -70)
    TabContainer.Position = UDim2.new(0, 10, 0, 65)
    TabContainer.BackgroundColor3 = CurrentTheme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -145, 1, -70)
    ContentContainer.Position = UDim2.new(0, 135, 0, 65)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- ระบบ Toggle UI
    local UIVisible = false
    
    local function ToggleUI()
        UIVisible = not UIVisible
        MainFrame.Visible = UIVisible
        
        if UIVisible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            Tween(MainFrame, {Size = UDim2.new(0, 450, 0, 600)}, 0.4)
            Tween(ToggleButton, {Rotation = 90}, 0.3)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            Tween(ToggleButton, {Rotation = 0}, 0.3)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(ToggleUI)
    CloseButton.MouseButton1Click:Connect(ToggleUI)
    
    -- Window Object
    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }
    
    -- สร้าง Tab
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.BackgroundColor3 = CurrentTheme.Background
        TabButton.Text = tabName
        TabButton.TextColor3 = CurrentTheme.SubText
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = CurrentTheme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        -- Auto resize content
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            -- ซ่อน Tab อื่น
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = CurrentTheme.Background
                tab.Button.TextColor3 = CurrentTheme.SubText
                tab.Content.Visible = false
            end
            
            -- แสดง Tab ปัจจุบัน
            TabButton.BackgroundColor3 = CurrentTheme.Accent
            TabButton.TextColor3 = CurrentTheme.Text
            TabContent.Visible = true
            Window.CurrentTab = tabName
            
            -- Ripple Effect
            local absPos = TabButton.AbsolutePosition
            local absSize = TabButton.AbsoluteSize
            CreateRipple(TabButton, absSize.X / 2, absSize.Y / 2)
        end)
        
        -- Tab Object
        local Tab = {
            Button = TabButton,
            Content = TabContent
        }
        
        Window.Tabs[tabName] = Tab
        
        -- เปิด Tab แรกอัตโนมัติ
        if not Window.CurrentTab then
            TabButton.BackgroundColor3 = CurrentTheme.Accent
            TabButton.TextColor3 = CurrentTheme.Text
            TabContent.Visible = true
            Window.CurrentTab = tabName
        end
        
        -- สร้าง Button
        function Tab:CreateButton(buttonConfig)
            buttonConfig = buttonConfig or {}
            local ButtonText = buttonConfig.Text or "Button"
            local Callback = buttonConfig.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 0, 50)
            Button.BackgroundColor3 = CurrentTheme.Secondary
            Button.Text = ButtonText
            Button.TextColor3 = CurrentTheme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 15
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 10)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                CreateRipple(Button, Button.AbsoluteSize.X / 2, Button.AbsoluteSize.Y / 2)
                Callback()
            end)
            
            return Button
        end
        
        -- สร้าง Toggle
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local ToggleText = toggleConfig.Text or "Toggle"
            local Default = toggleConfig.Default or false
            local Callback = toggleConfig.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
            ToggleFrame.BackgroundColor3 = CurrentTheme.Secondary
            ToggleFrame.Parent = TabContent
            
            local ToggleFrameCorner = Instance.new("UICorner")
            ToggleFrameCorner.CornerRadius = UDim.new(0, 10)
            ToggleFrameCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = ToggleText
            ToggleLabel.TextColor3 = CurrentTheme.Text
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 15
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 30)
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -15)
            ToggleButton.BackgroundColor3 = Default and CurrentTheme.Accent or Color3.fromRGB(60, 60, 65)
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
            ToggleCircle.Position = Default and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 4, 0.5, -11)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local Toggled = Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                
                Tween(ToggleButton, {BackgroundColor3 = Toggled and CurrentTheme.Accent or Color3.fromRGB(60, 60, 65)}, 0.3)
                Tween(ToggleCircle, {Position = Toggled and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 4, 0.5, -11)}, 0.3)
                
                Callback(Toggled)
            end)
            
            return ToggleFrame
        end
        
        -- สร้าง Slider
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local SliderText = sliderConfig.Text or "Slider"
            local Min = sliderConfig.Min or 0
            local Max = sliderConfig.Max or 100
            local Default = sliderConfig.Default or Min
            local Callback = sliderConfig.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 70)
            SliderFrame.BackgroundColor3 = CurrentTheme.Secondary
            SliderFrame.Parent = TabContent
            
            local SliderFrameCorner = Instance.new("UICorner")
            SliderFrameCorner.CornerRadius = UDim.new(0, 10)
            SliderFrameCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 25)
            SliderLabel.Position = UDim2.new(0, 15, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = SliderText
            SliderLabel.TextColor3 = CurrentTheme.Text
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextSize = 15
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 25)
            SliderValue.Position = UDim2.new(1, -65, 0, 8)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(Default)
            SliderValue.TextColor3 = CurrentTheme.Accent
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 15
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 6)
            SliderBar.Position = UDim2.new(0, 15, 1, -20)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local Dragging = false
            
            local function UpdateSlider(input)
                local pos = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                pos = math.clamp(pos, 0, 1)
                
                local value = math.floor(Min + (Max - Min) * pos)
                SliderValue.Text = tostring(value)
                
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                
                Callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            return SliderFrame
        end
        
        -- สร้าง TextBox
        function Tab:CreateTextBox(textboxConfig)
            textboxConfig = textboxConfig or {}
            local TextBoxText = textboxConfig.Text or "TextBox"
            local Placeholder = textboxConfig.Placeholder or "Enter text..."
            local Callback = textboxConfig.Callback or function() end
            
            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Name = "TextBox"
            TextBoxFrame.Size = UDim2.new(1, 0, 0, 80)
            TextBoxFrame.BackgroundColor3 = CurrentTheme.Secondary
            TextBoxFrame.Parent = TabContent
            
            local TextBoxFrameCorner = Instance.new("UICorner")
            TextBoxFrameCorner.CornerRadius = UDim.new(0, 10)
            TextBoxFrameCorner.Parent = TextBoxFrame
            
            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Size = UDim2.new(1, -20, 0, 25)
            TextBoxLabel.Position = UDim2.new(0, 15, 0, 8)
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Text = TextBoxText
            TextBoxLabel.TextColor3 = CurrentTheme.Text
            TextBoxLabel.Font = Enum.Font.GothamSemibold
            TextBoxLabel.TextSize = 15
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxLabel.Parent = TextBoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -30, 0, 35)
            TextBox.Position = UDim2.new(0, 15, 0, 38)
            TextBox.BackgroundColor3 = CurrentTheme.Background
            TextBox.Text = ""
            TextBox.PlaceholderText = Placeholder
            TextBox.TextColor3 = CurrentTheme.Text
            TextBox.PlaceholderColor3 = CurrentTheme.SubText
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 14
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = TextBoxFrame
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 8)
            TextBoxCorner.Parent = TextBox
            
            local TextBoxPadding = Instance.new("UIPadding")
            TextBoxPadding.PaddingLeft = UDim.new(0, 10)
            TextBoxPadding.PaddingRight = UDim.new(0, 10)
            TextBoxPadding.Parent = TextBox
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Callback(TextBox.Text)
                end
            end)
            
            return TextBoxFrame
        end
        
        -- สร้าง Label
        function Tab:CreateLabel(labelText)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, 40)
            Label.BackgroundColor3 = CurrentTheme.Secondary
            Label.Text = labelText
            Label.TextColor3 = CurrentTheme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextWrapped = true
            Label.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 10)
            LabelCorner.Parent = Label
            
            return Label
        end
        
        return Tab
    end
    
    return Window
end

return VenyxLib

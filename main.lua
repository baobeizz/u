local NothingLibrary = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua'))()

-- Roblox Notify Function
local StarterGui = game:GetService("StarterGui")

local function RobloxNotify(title, text, time)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Icon = "rbxassetid://109287544326306",
			Duration = time or 5
		})
	end)
end

RobloxNotify("BaoBei Hub", "Started !", 3)

-- UI Window
local Windows = NothingLibrary.new({
	Title = "BaoBei Hub",
	Description = "By BaoBeiZz",
	Keybind = Enum.KeyCode.LeftControl,
	Logo = "http://www.roblox.com/asset/?id=109287544326306"
})

-- Tab
local TabFrame = Windows:NewTab({
	Title = "Main",
	Description = "Main Features",
	Icon = "rbxassetid://7733960981"
})

-- Sections
local Section = TabFrame:NewSection({
	Title = "Features",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})

local InfoSection = TabFrame:NewSection({
	Title = "Information",
	Icon = "rbxassetid://7733964719",
	Position = "Right"
})


-- ตัวแปรสถานะ ESP
local espActive = false

-- ฟังก์ชันเปิด ESP
function enableESP()
    -- เช็คว่ามี Highlight อยู่แล้วหรือยัง
    if game.Workspace.Titans:FindFirstChild("TitanHighlight") then
        return
    end
    
    -- สร้าง Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "TitanHighlight"
    highlight.Parent = game.Workspace.Titans
    highlight.OutlineTransparency = 0.1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.9
    highlight.Adornee = game.Workspace.Titans
    
    -- เปิด Header ทุกตัว
    for _, titan in pairs(game.Workspace.Titans:GetChildren()) do
        if titan:IsA("Model") then
            local head = titan:FindFirstChild("Fake")
            if head then
                local headPart = head:FindFirstChild("Head")
                if headPart then
                    local header = headPart:FindFirstChild("Header")
                    if header then
                        header.Enabled = true
                    end
                end
            end
        end
    end
    
    espActive = true
    print("ESP: ON")
end

-- ฟังก์ชันปิด ESP
function disableESP()
    -- ลบ Highlight
    for _, highlight in pairs(game.Workspace.Titans:GetChildren()) do
        if highlight:IsA("Highlight") and highlight.Name == "TitanHighlight" then
            highlight:Destroy()
        end
    end
    
    -- ปิด Header ทุกตัว
    for _, titan in pairs(game.Workspace.Titans:GetChildren()) do
        if titan:IsA("Model") then
            local head = titan:FindFirstChild("Fake")
            if head then
                local headPart = head:FindFirstChild("Head")
                if headPart then
                    local header = headPart:FindFirstChild("Header")
                    if header then
                        header.Enabled = false
                    end
                end
            end
        end
    end
    
    espActive = false
    print("ESP: OFF")
end

-- Toggle ESP
Section:NewToggle({
    Title = "Titan ESP",
    Default = false,
    Callback = function(tr)
        RobloxNotify("ESP", tr and "ON" or "OFF", 3)
        
        if tr then
            enableESP()
        else
            disableESP()
        end
    end,
})

-- Toggle Auto Farm
Section:NewToggle({
	Title = "Auto Farm",
	Default = false,
	Callback = function(tr)
		RobloxNotify("Auto Farm", tr and "Enabled" or "Disabled", 3)
		print("Auto Farm:", tr)
	end,
})

-- Button Kill All
Section:NewButton({
	Title = "Kill All Titans",
	Callback = function()
		RobloxNotify("Kill All", "Attacking Titans...", 3)
		print("Kill All activated")
	end,
})

-- Button Teleport
Section:NewButton({
	Title = "Teleport to Spawn",
	Callback = function()
		RobloxNotify("Teleport", "Teleporting...", 3)
		print("Teleporting")
	end,
})

-- Slider WalkSpeed
Section:NewSlider({
	Title = "WalkSpeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Callback = function(value)
		RobloxNotify("WalkSpeed", "Set to "..value, 2)
		
		local player = game.Players.LocalPlayer
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = value
		end
	end,
})

-- Slider FOV
Section:NewSlider({
	Title = "Field of View",
	Min = 70,
	Max = 120,
	Default = 70,
	Callback = function(value)
		RobloxNotify("FOV", "Set to "..value, 2)
		
		local camera = game.Workspace.CurrentCamera
		camera.FieldOfView = value
	end,
})

-- Keybind Toggle UI
Section:NewKeybind({
	Title = "Toggle UI",
	Default = Enum.KeyCode.RightControl,
	Callback = function(key)
		RobloxNotify("Keybind", "Pressed "..key.Name, 2)
		print("Toggle UI key:", key.Name)
	end,
})

-- Dropdown Select Titan
Section:NewDropdown({
	Title = "Target Titan",
	Data = {"Nearest", "Strongest", "Weakest"},
	Default = "Nearest",
	Callback = function(selected)
		RobloxNotify("Target", "Mode: "..selected, 2)
		print("Target mode:", selected)
	end,
})

-- Info Section
InfoSection:NewTitle("BaoBei Hub v1.0")

InfoSection:NewButton({
	Title = "Discord Server",
	Callback = function()
		RobloxNotify("Discord", "discord.gg/BH6pE7jesa", 5)
		setclipboard("discord.gg/BH6pE7jesa")
		print("Discord link copied!")
	end,
})

InfoSection:NewButton({
	Title = "Creator",
	Callback = function()
		RobloxNotify("Info", "Made by BaoBeiZz", 3)
		print("Script by BaoBeiZz")
	end,
})

InfoSection:NewToggle({
	Title = "Auto Update",
	Default = true,
	Callback = function(tr)
		RobloxNotify("Auto Update", tr and "Enabled" or "Disabled", 2)
		print("Auto Update:", tr)
	end,
})

print("BaoBei Hub loaded successfully!")


-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- PLAYER
local player = Players.LocalPlayer
local AutoFarmEnabled = true
local Reloading = true

-- SETTINGS
local ExtendMultiplier = 2.5
local ExtendVisible = true

-- GET CHARACTER
local function GetCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- EXTEND NAPE
local function ExtendNape()
    local titans = Workspace:FindFirstChild("Titans")
    if not titans then return end

    for _, titan in ipairs(titans:GetChildren()) do
        if titan:IsA("Model") then
            local hitboxes = titan:FindFirstChild("Hitboxes")
            local hit = hitboxes and hitboxes:FindFirstChild("Hit")
            local nape = hit and hit:FindFirstChild("Nape")

            if nape and nape:IsA("BasePart") then
                nape.Size = Vector3.new(60,60,60) * ExtendMultiplier
                nape.Material = Enum.Material.Neon
                nape.Color = Color3.fromRGB(255,255,255)
                nape.Transparency = ExtendVisible and 0.95 or 1
            end
        end
    end
end

-- AUTO BLADE RELOAD
local function AutoReloadBlade()
    if Reloading then return end

    local char = GetCharacter()
    if char:GetAttribute("IFrames") ~= nil then return end

    local rig = char:FindFirstChild("Rig_" .. player.Name)
    local left = rig and rig:FindFirstChild("LeftHand")
    local blade = left and left:FindFirstChild("Blade_1")
    if not blade or blade.Transparency ~= 1 then return end

    local assets = ReplicatedStorage:FindFirstChild("Assets")
    local remotes = assets and assets:FindFirstChild("Remotes")
    local GET = remotes and remotes:FindFirstChild("GET")
    if not GET then return end

    Reloading = true

    for i = 1, 6 do
        if blade.Transparency ~= 1 then break end
        task.wait(0.6)
        pcall(function()
            GET:InvokeServer("Blades", "Reload")
        end)
    end

    Reloading = false
end

-- FIND NEAREST TITAN
local function GetNearestNape()
    local char = GetCharacter()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local titans = Workspace:FindFirstChild("Titans")
    if not titans then return nil end

    local nearest = nil
    local dist = math.huge

    for _, titan in ipairs(titans:GetChildren()) do
        local hum = titan:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 then
            local hitboxes = titan:FindFirstChild("Hitboxes")
            local hit = hitboxes and hitboxes:FindFirstChild("Hit")
            local nape = hit and hit:FindFirstChild("Nape")

            if nape then
                local d = (nape.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = nape
                end
            end
        end
    end

    return nearest
end

-- ATTACK
local function Attack(nape)
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    local remotes = assets and assets:FindFirstChild("Remotes")
    if not remotes then return end

    local POST = remotes:FindFirstChild("POST")
    local GET = remotes:FindFirstChild("GET")

    if POST then
        POST:FireServer("Attacks", "Slash", true)
    end

    if GET then
        pcall(function()
            GET:InvokeServer("Hitboxes","Register",nape,220,50)
        end)
    end
end

-- MAIN LOOP
task.spawn(function()
    print("Auto Farm Started")
    ExtendNape()

    while AutoFarmEnabled do
        task.wait(0.15)

        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local nape = GetNearestNape()
                if nape then
                    local pos = nape.Position + Vector3.new(0,60,0)
                    if (pos - root.Position).Magnitude > 100 then
                        root.CFrame = CFrame.new(pos)
                    end

                    if (root.Position - nape.Position).Magnitude <= 180 then
                        Attack(nape)
                        AutoReloadBlade()
                    end
                end
            end
        end
    end
end)

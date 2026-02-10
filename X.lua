
pcall(function()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local autoFarmEnabled = true
local currentTween = nil

-- ===============================
-- Auto Blade Refill
-- ===============================
local Settings = {
    bladeEnabled = true -- เปิด/ปิดระบบเติมดาบอัตโนมัติ
}

local function autoBladeRefill()
    -- ใส่โค้ดเติมดาบจริง ๆ ตรงนี้ เช่นเรียก Remote หรือ Event
    StarterGui:SetCore("SendNotification", {
        Title = "Blade Refill",
        Text = "Auto blade refill triggered!"
    })
end

if Settings.bladeEnabled then
    local blade = player.Character:WaitForChild("Rig_" .. player.Name)
        :WaitForChild("LeftHand")
        :WaitForChild("Blade_1")

    blade:GetPropertyChangedSignal("Transparency"):Connect(function()
        autoBladeRefill()
    end)
end

-- ===============================
-- FUNCTION: EXTEND NAPE
-- ===============================
local function extendNape(multiplier, visible, erenExtendEnabled)
    local titans = Workspace:WaitForChild("Titans", 5)
    if not titans then return end

    for _, titan in ipairs(titans:GetChildren()) do
        if titan:IsA("Model") then
            if not erenExtendEnabled and titan.Name == "Attack_Titan" then
                continue
            end

            local hitboxes = titan:FindFirstChild("Hitboxes")
            if not hitboxes then continue end

            local hit = hitboxes:FindFirstChild("Hit")
            if not hit then continue end

            local nape = hit:FindFirstChild("Nape")
            if not nape then continue end

            nape.Size = Vector3.new(60, 60, 60) * multiplier
            nape.Material = Enum.Material.Neon
            nape.Color = Color3.fromRGB(255,255,255)
            nape.Transparency = visible and 0.96 or 1
        end
    end
end

-- FIND NEAREST TITAN
local function findNearestTitan()
    local char = player.Character
    if not char then return nil end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local titans = Workspace:FindFirstChild("Titans")
    if not titans then return nil end

    local nearest, nearestDist = nil, math.huge

    for _, titan in ipairs(titans:GetChildren()) do
        local hum = titan:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 then
            local nape = titan:FindFirstChild("Hitboxes")
                and titan.Hitboxes:FindFirstChild("Hit")
                and titan.Hitboxes.Hit:FindFirstChild("Nape")

            if nape then
                local dist = (nape.Position - root.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = nape
                end
            end
        end
    end

    return nearest
end

-- ATTACK
local function attack(nape)
    if not nape then return end

    local remotes = ReplicatedStorage:FindFirstChild("Assets")
        and ReplicatedStorage.Assets:FindFirstChild("Remotes")

    if not remotes then return end

    local POST = remotes:FindFirstChild("POST")
    local GET = remotes:FindFirstChild("GET")

    if POST and GET then
        POST:FireServer("Attacks", "Slash", true)
        GET:InvokeServer(
            "Hitboxes",
            "Register",
            nape,
            math.random(215,230),
            math.random(10,100)
        )
    end
end

-- MAIN LOOP
task.spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm",
        Text = "Started + Extend Nape"
    })

    -- เรียกขยาย Nape (ปรับค่าได้)
    extendNape(
        2.5,    -- multiplier (ยิ่งมากยิ่งใหญ่)
        true,   -- visible
        false   -- ขยาย Eren (Attack_Titan) หรือไม่
    )

    while autoFarmEnabled do
        task.wait(0.15)

        local char = player.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local nape = findNearestTitan()
        if not nape then continue end

        local targetPos = nape.Position + Vector3.new(0, 70, 0)
        local distance = (targetPos - root.Position).Magnitude

        if distance > 120 then
            if currentTween then
                currentTween:Cancel()
            end

            currentTween = TweenService:Create(
                root,
                TweenInfo.new(distance / 220, Enum.EasingStyle.Linear),
                {CFrame = CFrame.new(targetPos)}
            )
            currentTween:Play()
            currentTween.Completed:Wait()
        end

        if (root.Position - nape.Position).Magnitude <= 180 then
            attack(nape)
        end
    end
end)

end) -- ปิด function ของ pcall


-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- PLAYER
local player = Players.LocalPlayer
local AutoFarmEnabled = true
local Reloading = false

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
            if hitboxes then
                local hit = hitboxes:FindFirstChild("Hit")
                if hit then
                    local nape = hit:FindFirstChild("Nape")
                    if nape and nape:IsA("BasePart") then
                        nape.Size = Vector3.new(60, 60, 60) * ExtendMultiplier
                        nape.Material = Enum.Material.Neon
                        nape.Color = Color3.fromRGB(255, 255, 255)
                        nape.Transparency = ExtendVisible and 0.95 or 1
                    end
                end
            end
        end
    end
end

-- AUTO BLADE RELOAD
local function AutoReloadBlade()
    if Reloading then return end

    local char = GetCharacter()
    if not char then return end
    if char:GetAttribute("IFrames") then return end

    local rigName = "Rig_" .. tostring(player.Name)
    local rig = char:FindFirstChild(rigName)
    if not rig then return end
    
    local leftHand = rig:FindFirstChild("LeftHand")
    if not leftHand then return end
    
    local blade = leftHand:FindFirstChild("Blade_1")
    if not blade or blade.Transparency ~= 1 then return end

    local assets = ReplicatedStorage:FindFirstChild("Assets")
    if not assets then return end
    
    local remotes = assets:FindFirstChild("Remotes")
    if not remotes then return end
    
    local GET = remotes:FindFirstChild("GET")
    if not GET then return end

    Reloading = true

    for i = 1, 6 do
        if not blade or blade.Transparency ~= 1 then break end
        task.wait(0.6)
        local success = pcall(function()
            GET:InvokeServer("Blades", "Reload")
        end)
    end

    Reloading = false
end

-- FIND NEAREST TITAN NAPE
local function GetNearestNape()
    local char = GetCharacter()
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local titans = Workspace:FindFirstChild("Titans")
    if not titans then return nil end

    local nearestNape = nil
    local shortestDistance = math.huge

    for _, titan in ipairs(titans:GetChildren()) do
        if titan:IsA("Model") then
            local humanoid = titan:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local hitboxes = titan:FindFirstChild("Hitboxes")
                if hitboxes then
                    local hit = hitboxes:FindFirstChild("Hit")
                    if hit then
                        local nape = hit:FindFirstChild("Nape")
                        if nape and nape:IsA("BasePart") then
                            local distance = (nape.Position - root.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestNape = nape
                            end
                        end
                    end
                end
            end
        end
    end

    return nearestNape
end

-- ATTACK FUNCTION
local function Attack(targetNape)
    if not targetNape then return end
    
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    if not assets then return end
    
    local remotes = assets:FindFirstChild("Remotes")
    if not remotes then return end

    local POST = remotes:FindFirstChild("POST")
    local GET = remotes:FindFirstChild("GET")

    if POST then
        pcall(function()
            POST:FireServer("Attacks", "Slash", true)
        end)
    end

    if GET then
        pcall(function()
            GET:InvokeServer("Hitboxes", "Register", targetNape, 220, 50)
        end)
    end
end

-- ===============================
-- CHECK IF PLAYER IS DEAD
-- ===============================
local function IsPlayerDead()
    local character = player.Character
    if not character then return true end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return true end
    
    if humanoid.Health <= 0 then
        return true
    end
    
    return false
end

-- ===============================
-- AUTO RETRY MISSION
-- ===============================
local function AutoRetry()
    task.spawn(function()
        while AutoFarmEnabled do
            task.wait(1)
            
            local success, err = pcall(function()
                local retryButton = player.PlayerGui:FindFirstChild("Interface")
                if not retryButton then return end
                
                retryButton = retryButton:FindFirstChild("Rewards")
                if not retryButton then return end
                
                retryButton = retryButton:FindFirstChild("Main")
                if not retryButton then return end
                
                retryButton = retryButton:FindFirstChild("Info")
                if not retryButton then return end
                
                retryButton = retryButton:FindFirstChild("Main")
                if not retryButton then return end
                
                retryButton = retryButton:FindFirstChild("Buttons")
                if not retryButton then return end
                
                retryButton = retryButton:FindFirstChild("Retry")
                if not retryButton then return end
                
                local title = retryButton:FindFirstChild("Title")
                if not title then return end
                
                local remoteGet = ReplicatedStorage:FindFirstChild("Assets")
                if not remoteGet then return end
                
                remoteGet = remoteGet:FindFirstChild("Remotes")
                if not remoteGet then return end
                
                remoteGet = remoteGet:FindFirstChild("GET")
                if not remoteGet then return end
                
                -- ตรวจสอบว่าไม่ใช่ (0/0)
                if not string.find(title.Text, "(0/0)") then
                    remoteGet:InvokeServer("Functions", "Retry", "Add")
                    
                    repeat
                        task.wait(0.1)
                        if not string.find(title.Text, "STARTING") then
                            remoteGet:InvokeServer("Functions", "Retry", "Add")
                        else
                            break
                        end
                    until not AutoFarmEnabled
                end
            end)
            
            if not success then
                warn("Auto Retry Error:", err)
            end
        end
    end)
end

-- ===============================
-- DEATH DETECTION
-- ===============================
local function MonitorPlayerDeath()
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoid.Died:Connect(function()
            print("Player died! Stopping Auto Farm...")
            AutoFarmEnabled = false
        end)
    end)
    
    -- ตรวจสอบ character ปัจจุบันด้วย
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                print("Player died! Stopping Auto Farm...")
                AutoFarmEnabled = false
            end)
        end
    end
end

-- เริ่มต้น Death Monitor
MonitorPlayerDeath()

-- MAIN AUTO FARM LOOP
task.spawn(function()
    print("Auto Farm Started")
    ExtendNape()

    while AutoFarmEnabled do
        task.wait(0.15)
        
        -- ตรวจสอบว่าตายหรือไม่
        if IsPlayerDead() then
            print("Player is dead! Stopping Auto Farm...")
            AutoFarmEnabled = false
            break
        end

        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local targetNape = GetNearestNape()
                if targetNape then
                    local targetPosition = targetNape.Position + Vector3.new(0, 60, 0)
                    local distanceToTarget = (targetPosition - rootPart.Position).Magnitude
                    
                    if distanceToTarget > 100 then
                        rootPart.CFrame = CFrame.new(targetPosition)
                    end

                    local distanceToNape = (rootPart.Position - targetNape.Position).Magnitude
                    if distanceToNape <= 180 then
                        Attack(targetNape)
                        AutoReloadBlade()
                    end
                end
            end
        end
    end
    
    print("Auto Farm Stopped")
end)

-- CONTINUOUSLY EXTEND NAPES
task.spawn(function()
    while AutoFarmEnabled do
        task.wait(2)
        ExtendNape()
    end
end)

-- START AUTO RETRY
AutoRetry()

print("Script loaded successfully!")

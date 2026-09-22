local VERSION = "v6"
local START_TIME = tick()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Features
local Features = {
    -- Combat (20 funciones)
    RedirectSpike = false,
    AutoCorner = false,
    CornerMode = "Auto",
    CornerDepth = 10,
    SanjuTilt = false,
    MaxCharge = false,
    FakeSpike = false,
    Hitbox = false,
    HitboxSize = 10,
    HitboxColor = Color3.fromRGB(0, 255, 100),
    PerfectSpike = false,
    DirectionalHit = false,
    AutoStrongServe = false,
    ServePower = 1,
    MaxServe = false,
    SilentSpike = false,
    AutoCounter = false,
    BlockAssist = false,
    SetAssist = false,
    ReceiveAssist = false,
    InstantCharge = false,
    NoCooldown = false,
    AutoSpike = false,
    AutoBlock = false,
    AutoSet = false,
    AutoReceive = false,
    MagnetBall = false,
    MagnetStrength = 10,
    
    -- Movement (20 funciones)
    AirMovement = false,
    AirSpeed = 32,
    AutoShiftLock = false,
    AimbotCorner = false,
    Desync = false,
    KisukiDive = false,
    DiveCharge = 1,
    AkariDash = false,
    LeadFeet = false,
    SpeedHack = false,
    SpeedValue = 16,
    JumpBoost = false,
    JumpPower = 50,
    Fly = false,
    FlySpeed = 50,
    InfiniteJump = false,
    NoClip = false,
    AutoRotate = false,
    AutoDodge = false,
    DodgeDistance = 10,
    TeleportToBall = false,
    AutoFollowBall = false,
    
    -- Visuals (30 funciones)
    JumpESP = false,
    JumpESPColor = Color3.fromRGB(255, 0, 0),
    BallESP = false,
    BallESPColor = Color3.fromRGB(0, 255, 255),
    PlayerESP = false,
    PlayerESPColor = Color3.fromRGB(255, 255, 0),
    Tracers = false,
    Chams = false,
    BoxESP = false,
    NameESP = false,
    DistanceESP = false,
    HealthESP = false,
    BallPrediction = false,
    Trajectory = false,
    HitboxVisualizer = false,
    ScoreEffectEnabled = false,
    ScoreEffect = "Supernova",
    CustomSkybox = false,
    FullBright = false,
    NoFog = false,
    NoShadows = false,
    CustomFOV = false,
    FOVValue = 70,
    FreeCamera = false,
    SpectatorMode = false,
    BallTrail = false,
    BallTrailColor = Color3.fromRGB(255, 0, 255),
    CourtChanger = false,
    CourtColor = Color3.fromRGB(255, 255, 255),
    
    -- Misc (25 funciones)
    AutoSpinStyle = false,
    AutoSpinAbility = false,
    SpinType = "Normal",
    SpinSlot = 1,
    SpinSpeed = 0.35,
    ShopEnabled = false,
    RewardsEnabled = false,
    AntiLag = false,
    Protection = false,
    PlayerCard = "Default",
    TitleChanger = false,
    Title = "Default",
    BallSkin = "Default",
    Jersey = "Default",
    EmoteSpammer = false,
    EmoteSpeed = 1,
    AnimationChanger = false,
    WalkSpeed = 16,
    AutoClick = false,
    AutoRejoin = false,
    AutoFarm = false,
    AutoCollect = false,
    AutoClaimRewards = false,
    AntiAFK = false,
    UnlockAll = false,
    GodMode = false,
    InstantWin = false,
}

-- State
local State = {
    running = true,
    ESP = {},
    Hitboxes = {},
    Connections = {},
    lastSpike = 0,
    lastEmote = 0,
    originalWalkSpeed = 16,
    originalJumpPower = 50,
    scoreEffectConnection = nil,
}

-- UI Obsidian
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library:SetNotifySide("Right")

local function notify(msg, time)
    Library:Notify({Title = "KingsHub", Description = msg, Time = time or 5})
end

-- Window
local Window = Library:CreateWindow({
    Title = "KingsHub",
    Footer = VERSION .. " | 100+ Features",
    Icon = 76037421850699,
    AutoShow = true,
    Resizable = true,
})

local Tabs = {
    Combat = Window:AddTab("Combat", "sword"),
    Movement = Window:AddTab("Movement", "move"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Misc = Window:AddTab("Misc", "zap"),
    Game = Window:AddTab("Game", "play"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- Remotes
local Remotes = {}
task.spawn(function()
    local success, knit = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services")
    end)
    
    if success and knit then
        Remotes.BallInteract = knit:FindFirstChild("BallService") and knit.BallService:FindFirstChild("RF") and knit.BallService.RF:FindFirstChild("Interact")
        Remotes.Serve = knit:FindFirstChild("GameService") and knit.GameService:FindFirstChild("RF") and knit.GameService.RF:FindFirstChild("Serve")
        Remotes.StyleRoll = knit:FindFirstChild("StyleService") and knit.StyleService:FindFirstChild("RF") and knit.StyleService.RF:FindFirstChild("Roll")
        Remotes.AbilityRoll = knit:FindFirstChild("AbilityService") and knit.AbilityService:FindFirstChild("RF") and knit.AbilityService.RF:FindFirstChild("Roll")
        Remotes.PartyTeleport = knit:FindFirstChild("PartyService") and knit.PartyService:FindFirstChild("RF") and knit.PartyService.RF:FindFirstChild("RequestTeleport")
        Remotes.ClaimLevel = knit:FindFirstChild("LevelService") and knit.LevelService:FindFirstChild("RF") and knit.LevelService.RF:FindFirstChild("ClaimLevelRewards")
        Remotes.OpenPack = knit:FindFirstChild("PackService") and knit.PackService:FindFirstChild("RF") and knit.PackService.RF:FindFirstChild("Open")
        Remotes.DataReset = knit:FindFirstChild("SettingsService") and knit.SettingsService:FindFirstChild("RF") and knit.SettingsService.RF:FindFirstChild("Reset")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- SCORE EFFECT SYSTEM ARREGLADO
-- ═══════════════════════════════════════════════════════════
local ScoreEffectSystem = {}
ScoreEffectSystem.effects = {
    Supernova = {
        Color = Color3.fromRGB(255, 215, 0),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Explosion = {
        Color = Color3.fromRGB(255, 100, 0),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Lightning = {
        Color = Color3.fromRGB(150, 200, 255),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Fire = {
        Color = Color3.fromRGB(255, 100, 0),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Rainbow = {
        Color = Color3.fromRGB(255, 0, 255),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Galaxy = {
        Color = Color3.fromRGB(150, 0, 255),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Crystal = {
        Color = Color3.fromRGB(200, 255, 255),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Neon = {
        Color = Color3.fromRGB(0, 255, 100),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Gold = {
        Color = Color3.fromRGB(255, 215, 0),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    },
    Diamond = {
        Color = Color3.fromRGB(200, 255, 255),
        Particle = "rbxassetid://13409107147",
        Sound = "rbxassetid://9114488953"
    }
}

function ScoreEffectSystem:apply(effectName)
    local effect = self.effects[effectName]
    if not effect then return end
    
    -- Método 1: Modificar GUI existente
    pcall(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local interface = playerGui:WaitForChild("Interface")
        local gameGui = interface:WaitForChild("Game")
        
        -- Buscar el contenedor de efectos de punto
        local scoreContainer = gameGui:FindFirstChild("Score") or gameGui:FindFirstChild("PointEffect")
        if scoreContainer then
            for _, child in ipairs(scoreContainer:GetDescendants()) do
                if child:IsA("ParticleEmitter") then
                    child.Color = ColorSequence.new(effect.Color)
                    child.Texture = effect.Particle
                    child.Size = NumberSequence.new(8)
                    child.Rate = 150
                    child.Lifetime = NumberRange.new(1.5, 2.5)
                    child.Speed = NumberRange.new(15, 25)
                    child.Acceleration = Vector3.new(0, 10, 0)
                end
                if child:IsA("Sound") then
                    child.SoundId = effect.Sound
                    child.Volume = 0.8
                end
            end
        end
    end)
    
    -- Método 2: Crear efecto propio
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Crear partículas alrededor del personaje
                for i = 1, 5 do
                    local attachment = Instance.new("Attachment")
                    attachment.Position = Vector3.new(math.random(-5, 5), math.random(0, 10), math.random(-5, 5))
                    attachment.Parent = hrp
                    
                    local emitter = Instance.new("ParticleEmitter")
                    emitter.Color = ColorSequence.new(effect.Color)
                    emitter.Texture = effect.Particle
                    emitter.Size = NumberSequence.new(5)
                    emitter.Rate = 50
                    emitter.Lifetime = NumberRange.new(1, 2)
                    emitter.Speed = NumberRange.new(10, 20)
                    emitter.Parent = attachment
                    
                    game:GetService("Debris"):AddItem(attachment, 3)
                end
            end
        end
    end)
    
    -- Método 3: Intentar modificar InventoryController
    pcall(function()
        local Knit = require(ReplicatedStorage.Packages.Knit)
        local controller = Knit.GetController("InventoryController")
        if controller and controller.SetEquipped then
            controller:SetEquipped("ScoreEffect", effectName)
        end
    end)
    
    notify("Score Effect Applied: " .. effectName, 3)
end

-- ═══════════════════════════════════════════════════════════
-- HOOK METAMETHOD UNIFICADO
-- ═══════════════════════════════════════════════════════════
local OriginalNamecall
OriginalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method ~= "InvokeServer" and method ~= "FireServer" then
        return OriginalNamecall(self, unpack(args))
    end
    
    local name = ""
    pcall(function() name = tostring(self.Name) end)
    
    if type(args[1]) == "table" then
        local data = args[1]
        local action = tostring(data.Action or data.Move or "")
        
        -- No Cooldown
        if Features.NoCooldown then
            data.Cooldown = 0
            data.LastUsed = 0
        end
        
        -- Instant Charge
        if Features.InstantCharge then
            data.Charge = 1
            data.ChargeTime = 0
        end
        
        -- Combat hooks
        if Features.RedirectSpike and name == "Interact" and action == "Spike" then
            local cam = Camera
            if cam then
                local look = cam.CFrame.LookVector
                local y = (typeof(data.LookVector) == "Vector3") and data.LookVector.Y or 0
                data.LookVector = Vector3.new(look.X, y, look.Z).Unit
                if data.Direction then data.Direction = data.LookVector end
            end
        end
        
        if Features.AutoCorner and name == "Interact" and action == "Spike" then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local target = getCornerTarget(hrp.Position)
                if target then
                    local dir = (target - hrp.Position).Unit
                    data.LookVector = Vector3.new(dir.X, -0.3, dir.Z).Unit
                    if data.Direction then data.Direction = data.LookVector end
                end
            end
        end
        
        if Features.SanjuTilt and name == "Interact" and action == "Spike" and data.TiltDirection then
            local tilt = data.TiltDirection
            if typeof(tilt) == "Vector3" and (math.abs(tilt.X) > 0.01 or math.abs(tilt.Z) > 0.01) then
                local look = data.LookVector or Vector3.new(0,0,0)
                data.LookVector = Vector3.new(look.X + tilt.X * 0.3, look.Y, look.Z + tilt.Z * 0.3).Unit
                data.TiltDirection = Vector3.new(tilt.X * 1.35, tilt.Y, tilt.Z * 1.35)
            end
        end
        
        if Features.MaxCharge and name == "Interact" and action == "Spike" then
            data.Charge = 1
            data.SpecialCharge = 1
        end
        
        if Features.PerfectSpike and name == "Interact" and action == "Spike" then
            data.Charge = 1
            if not data.SpecialCharge or data.SpecialCharge < 0.000001 then
                data.SpecialCharge = 0.000001
            end
        end
        
        if Features.DirectionalHit and name == "Interact" then
            local cam = Camera
            if cam and data.LookVector then
                data.LookVector = cam.CFrame.LookVector
            end
        end
        
        if Features.BlockAssist and name == "Interact" and action == "Block" then
            data.Charge = 1
        end
        
        if Features.SetAssist and name == "Interact" and action == "Set" then
            data.Charge = 1
        end
        
        if Features.ReceiveAssist and name == "Interact" and action == "Receive" then
            data.Charge = 1
        end
        
        -- Auto actions
        if Features.AutoSpike and name == "Interact" and action == "Spike" then
            data.Charge = 1
            data.SpecialCharge = 0.000001
        end
        
        if Features.AutoBlock and name == "Interact" and action == "Block" then
            data.Charge = 1
            data.Timing = 1
        end
    end
    
    if Features.MaxServe and name == "Serve" and args[2] then
        args[2] = 5
    end
    
    if Features.AutoStrongServe and name == "Serve" and args[2] then
        args[2] = Features.ServePower
    end
    
    return OriginalNamecall(self, unpack(args))
end))

-- ═══════════════════════════════════════════════════════════
-- FUNCIONES AUXILIARES
-- ═══════════════════════════════════════════════════════════
function getCornerTarget(playerPos)
    local bounds = {minX = -25, maxX = 25, minZ = -40, maxZ = 40}
    local left = Vector3.new(bounds.minX + 5, playerPos.Y, bounds.maxZ - 5)
    local right = Vector3.new(bounds.maxX - 5, playerPos.Y, bounds.maxZ - 5)
    
    if Features.CornerMode == "Left" then return left end
    if Features.CornerMode == "Right" then return right end
    
    local nearest, dist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - playerPos).Magnitude
                if d < dist then dist, nearest = d, plr end
            end
        end
    end
    
    if nearest then
        local ep = nearest.Character.HumanoidRootPart.Position
        return ((left - ep).Magnitude > (right - ep).Magnitude) and left or right
    end
    return (playerPos.X < 0) and right or left
end

function getBall()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:match("^CLIENT_BALL_%d+$") then
            return v:FindFirstChildWhichIsA("BasePart")
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- SISTEMAS DE COMBATE
-- ═══════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    -- Hitbox
    if Features.Hitbox then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v.Name:match("^CLIENT_BALL_%d+$") then
                local ball = v:FindFirstChildWhichIsA("BasePart")
                if ball then
                    local hitbox = v:FindFirstChild("KingsHub_HITBOX")
                    if not hitbox then
                        hitbox = Instance.new("Part")
                        hitbox.Name = "KingsHub_HITBOX"
                        hitbox.Shape = Enum.PartType.Ball
                        hitbox.Size = Vector3.new(Features.HitboxSize, Features.HitboxSize, Features.HitboxSize)
                        hitbox.Anchored = true
                        hitbox.CanCollide = false
                        hitbox.Transparency = 0.7
                        hitbox.Color = Features.HitboxColor
                        hitbox.Material = Enum.Material.ForceField
                        hitbox.Parent = v
                        
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = ball
                        weld.Part1 = hitbox
                        weld.Parent = hitbox
                    else
                        hitbox.Size = Vector3.new(Features.HitboxSize, Features.HitboxSize, Features.HitboxSize)
                        hitbox.CFrame = ball.CFrame
                    end
                end
            end
        end
    end
    
    -- Magnet Ball
    if Features.MagnetBall then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local ball = getBall()
        if hrp and ball then
            local dist = (hrp.Position - ball.Position).Magnitude
            if dist <= Features.MagnetStrength * 2 then
                local dir = (hrp.Position - ball.Position).Unit
                ball.AssemblyLinearVelocity = ball.AssemblyLinearVelocity + dir * Features.MagnetStrength
            end
        end
    end
    
    -- Silent Spike
    if Features.SilentSpike then
        local now = tick()
        if now - State.lastSpike > 0.3 then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name:match("^CLIENT_BALL_%d+$") then
                        local hitbox = v:FindFirstChild("KingsHub_HITBOX")
                        if hitbox then
                            local dist = (hrp.Position - hitbox.Position).Magnitude
                            if dist <= (2 + hitbox.Size.X / 2) then
                                State.lastSpike = now
                                local remote = Remotes.BallInteract
                                if remote then
                                    pcall(function()
                                        remote:InvokeServer({
                                            Action = "Spike",
                                            Charge = 1,
                                            LookVector = Camera.CFrame.LookVector,
                                            TiltDirection = Vector3.new(0, 0, -1),
                                            MoveDirection = Vector3.new(0, 0, -1),
                                            From = "Client",
                                            SpecialCharge = 0.000001,
                                        })
                                    end)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Auto Counter
    if Features.AutoCounter then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name:match("^CLIENT_BALL_%d+$") then
                    local ball = v:FindFirstChildWhichIsA("BasePart")
                    if ball then
                        local dist = (hrp.Position - ball.Position).Magnitude
                        if dist < 8 and ball.Position.Y > hrp.Position.Y then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(0.05)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end
                    end
                end
            end
        end
    end
    
    -- Auto Block
    if Features.AutoBlock then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ball = getBall()
            if ball then
                local dist = (hrp.Position - ball.Position).Magnitude
                if dist < 12 and ball.Position.Y > hrp.Position.Y + 5 then
                    local remote = Remotes.BallInteract
                    if remote then
                        pcall(function()
                            remote:InvokeServer({
                                Action = "Block",
                                Charge = 1,
                                From = "Client"
                            })
                        end)
                    end
                end
            end
        end
    end
    
    -- Auto Set
    if Features.AutoSet then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ball = getBall()
            if ball then
                local dist = (hrp.Position - ball.Position).Magnitude
                if dist < 10 and ball.Position.Y > hrp.Position.Y then
                    local remote = Remotes.BallInteract
                    if remote then
                        pcall(function()
                            remote:InvokeServer({
                                Action = "Set",
                                Charge = 1,
                                From = "Client"
                            })
                        end)
                    end
                end
            end
        end
    end
    
    -- Auto Receive
    if Features.AutoReceive then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ball = getBall()
            if ball then
                local dist = (hrp.Position - ball.Position).Magnitude
                if dist < 8 and ball.Position.Y < hrp.Position.Y + 3 then
                    local remote = Remotes.BallInteract
                    if remote then
                        pcall(function()
                            remote:InvokeServer({
                                Action = "Receive",
                                Charge = 1,
                                From = "Client"
                            })
                        end)
                    end
                end
            end
        end
    end

-- No Clip
    if Features.NoClip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
    
    -- Fly
    if Features.Fly then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local velocity = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, 1, 0)
            end
            
            if velocity.Magnitude > 0 then
                velocity = velocity.Unit * Features.FlySpeed
            end
            
            hrp.AssemblyLinearVelocity = velocity
        end
    end
    
    -- Auto Rotate
    if Features.AutoRotate then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ball = getBall()
            if ball then
                local dir = (ball.Position - hrp.Position).Unit
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + Vector3.new(dir.X, 0, dir.Z))
            end
        end
    end
    
    -- Speed/Jump
    if Features.SpeedHack or Features.JumpBoost then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if Features.SpeedHack then
                hum.WalkSpeed = Features.SpeedValue
            end
            if Features.JumpBoost then
                hum.JumpPower = Features.JumpPower
            end
        end
    end
    
    -- Custom FOV
    if Features.CustomFOV then
        Camera.FieldOfView = Features.FOVValue
    end
    
    -- Free Camera
    if Features.FreeCamera then
        Camera.CameraType = Enum.CameraType.Scriptable
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
    
    -- Teleport to Ball
    if Features.TeleportToBall then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local ball = getBall()
        if hrp and ball then
            local dist = (hrp.Position - ball.Position).Magnitude
            if dist > 10 then
                hrp.CFrame = CFrame.new(ball.Position + Vector3.new(0, 5, 0))
            end
        end
    end
    
    -- Auto Follow Ball
    if Features.AutoFollowBall then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local ball = getBall()
        if hrp and ball then
            local dist = (hrp.Position - ball.Position).Magnitude
            if dist > 5 then
                local dir = (ball.Position - hrp.Position).Unit
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * Features.SpeedValue, hrp.AssemblyLinearVelocity.Y, dir.Z * Features.SpeedValue)
            end
        end
    end

-- Air Movement
RunService.RenderStepped:Connect(function()
    if Features.AirMovement then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
                    local move = hum.MoveDirection
                    if move.Magnitude > 0.05 then
                        local vel = Vector3.new(move.X, 0, move.Z).Unit * Features.AirSpeed
                        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, hrp.AssemblyLinearVelocity.Y, vel.Z)
                    end
                end
            end
        end
    end
    
    -- Auto Shift Lock
    if Features.AutoShiftLock then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and (hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall) then
                local cam = Camera
                if cam then
                    local look = cam.CFrame.LookVector
                    local flat = Vector3.new(look.X, 0, look.Z)
                    if flat.Magnitude > 0 then
                        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat.Unit)
                    end
                end
            end
        end
    end
    
    -- Lead Feet
    if Features.LeadFeet then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -100, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end
end)

-- Infinite Jump
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if Features.InfiniteJump and input.KeyCode == Enum.KeyCode.Space then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    
    -- Kisuki Dive
    if Features.KisukiDive and input.KeyCode == Enum.KeyCode.Q then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 50 + Vector3.new(0, -30, 0)
        end
    end
    
    -- Akari Dash
    if Features.AkariDash and input.KeyCode == Enum.KeyCode.LeftShift then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ball = getBall()
            if ball then
                local dir = (ball.Position - hrp.Position).Unit
                hrp.AssemblyLinearVelocity = dir * 80
            end
        end
    end
end)

-- Jump Request
UserInputService.JumpRequest:Connect(function()
    if Features.AimbotCorner then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local target = getCornerTarget(hrp.Position)
            local dir = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
            if dir.Magnitude > 0.5 then
                local cur = hrp.CFrame.LookVector
                local flat = Vector3.new(cur.X, 0, cur.Z)
                if flat.Magnitude > 0.1 then flat = flat.Unit else flat = dir.Unit end
                local blend = (flat * 0.15 + dir.Unit * 0.85).Unit
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + blend)
            end
        end
    end
end)

-- SISTEMAS VISUALES

RunService.RenderStepped:Connect(function()
    -- Jump ESP
    if Features.JumpESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                local char = plr.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and (hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall) then
                        if not State.ESP[plr] then
                            local hl = Instance.new("Highlight")
                            hl.Name = "KingsHub_ESP"
                            hl.FillColor = Features.JumpESPColor
                            hl.OutlineColor = Features.JumpESPColor
                            hl.FillTransparency = 0.5
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Adornee = char
                            hl.Parent = char
                            State.ESP[plr] = hl
                        end
                    else
                        if State.ESP[plr] then
                            State.ESP[plr]:Destroy()
                            State.ESP[plr] = nil
                        end
                    end
                end
            end
        end
    else
        for plr, obj in pairs(State.ESP) do
            if obj then obj:Destroy() end
            State.ESP[plr] = nil
        end
    end
    
    -- Ball ESP
    if Features.BallESP then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v.Name:match("^CLIENT_BALL_%d+$") then
                local ball = v:FindFirstChildWhichIsA("BasePart")
                if ball and not ball:FindFirstChild("BallESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "BallESP"
                    hl.FillColor = Features.BallESPColor
                    hl.OutlineColor = Features.BallESPColor
                    hl.FillTransparency = 0.3
                    hl.Adornee = v
                    hl.Parent = ball
                end
            end
        end
    end
    
    -- Ball Trail
    if Features.BallTrail then
        local ball = getBall()
        if ball then
            if not ball:FindFirstChild("Trail") then
                local attachment0 = Instance.new("Attachment")
                attachment0.Position = Vector3.new(0, 0.5, 0)
                attachment0.Parent = ball
                
                local attachment1 = Instance.new("Attachment")
                attachment1.Position = Vector3.new(0, -0.5, 0)
                attachment1.Parent = ball
                
                local trail = Instance.new("Trail")
                trail.Color = ColorSequence.new(Features.BallTrailColor)
                trail.Lifetime = 0.5
                trail.Attachment0 = attachment0
                trail.Attachment1 = attachment1
                trail.Parent = ball
            end
        end
    end
    
    -- Player ESP
    if Features.PlayerESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("PlayerESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "PlayerESP"
                hl.FillColor = Features.PlayerESPColor
                hl.OutlineColor = Features.PlayerESPColor
                hl.FillTransparency = 0.5
                hl.Adornee = plr.Character
                hl.Parent = plr.Character
            end
        end
    end
    
    -- Full Bright
    if Features.FullBright then
        Lighting.Brightness = 10
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end
    
    -- No Fog
    if Features.NoFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.fromRGB(255, 255, 255)
    end
    
    -- No Shadows
    if Features.NoShadows then
        Lighting.GlobalShadows = false
    end
    
    -- Court Changer
    if Features.CourtChanger then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("court") or v.Name:lower():find("floor") then
                v.Color = Features.CourtColor
                v.Material = Enum.Material.Neon
            end
        end
    end
end)

-- TAB: COMBAT

local CombatLeft = Tabs.Combat:AddLeftGroupbox("Spike Mods")
local CombatRight = Tabs.Combat:AddRightGroupbox("Hit Mods")
local CombatExtra = Tabs.Combat:AddRightGroupbox("Auto Actions")

CombatLeft:AddToggle("RedirectSpike", {Text = "Redirect Spike", Default = false, Callback = function(v) Features.RedirectSpike = v end})
CombatLeft:AddToggle("AutoCorner", {Text = "Auto Corner", Default = false, Callback = function(v) Features.AutoCorner = v end})
CombatLeft:AddDropdown("CornerMode", {Text = "Corner Mode", Values = {"Auto", "Left", "Right"}, Default = "Auto", Callback = function(v) Features.CornerMode = v end})
CombatLeft:AddSlider("CornerDepth", {Text = "Corner Depth", Default = 10, Min = 5, Max = 20, Callback = function(v) Features.CornerDepth = v end})
CombatLeft:AddToggle("SanjuTilt", {Text = "Sanju Tilt", Default = false, Callback = function(v) Features.SanjuTilt = v end})
CombatLeft:AddToggle("MaxCharge", {Text = "Max Charge", Default = false, Callback = function(v) Features.MaxCharge = v end})
CombatLeft:AddToggle("PerfectSpike", {Text = "Perfect Spike", Default = false, Callback = function(v) Features.PerfectSpike = v end})
CombatLeft:AddToggle("FakeSpike", {Text = "Fake Spike", Default = false, Callback = function(v) Features.FakeSpike = v end})
CombatLeft:AddToggle("SilentSpike", {Text = "Silent Spike", Default = false, Callback = function(v) Features.SilentSpike = v end})
CombatLeft:AddToggle("InstantCharge", {Text = "Instant Charge", Default = false, Callback = function(v) Features.InstantCharge = v end})
CombatLeft:AddToggle("NoCooldown", {Text = "No Cooldown", Default = false, Callback = function(v) Features.NoCooldown = v end})

CombatRight:AddToggle("Hitbox", {Text = "Hitbox Expand", Default = false, Callback = function(v) Features.Hitbox = v end})
CombatRight:AddSlider("HitboxSize", {Text = "Hitbox Size", Default = 10, Min = 0, Max = 50, Callback = function(v) Features.HitboxSize = v end})
CombatRight:AddLabel("Hitbox Color"):AddColorPicker("HitboxColor", {Default = Features.HitboxColor, Callback = function(v) Features.HitboxColor = v end})
CombatRight:AddToggle("DirectionalHit", {Text = "Directional Hit", Default = false, Callback = function(v) Features.DirectionalHit = v end})
CombatRight:AddToggle("AutoCounter", {Text = "Auto Counter", Default = false, Callback = function(v) Features.AutoCounter = v end})
CombatRight:AddToggle("BlockAssist", {Text = "Block Assist", Default = false, Callback = function(v) Features.BlockAssist = v end})
CombatRight:AddToggle("SetAssist", {Text = "Set Assist", Default = false, Callback = function(v) Features.SetAssist = v end})
CombatRight:AddToggle("ReceiveAssist", {Text = "Receive Assist", Default = false, Callback = function(v) Features.ReceiveAssist = v end})
CombatRight:AddToggle("MaxServe", {Text = "Max Serve", Default = false, Callback = function(v) Features.MaxServe = v end})
CombatRight:AddToggle("AutoStrongServe", {Text = "Auto Strong Serve", Default = false, Callback = function(v) Features.AutoStrongServe = v end})
CombatRight:AddSlider("ServePower", {Text = "Serve Power", Default = 100, Min = 50, Max = 150, Callback = function(v) Features.ServePower = v / 100 end})
CombatRight:AddToggle("MagnetBall", {Text = "Magnet Ball", Default = false, Callback = function(v) Features.MagnetBall = v end})
CombatRight:AddSlider("MagnetStrength", {Text = "Magnet Strength", Default = 10, Min = 1, Max = 50, Callback = function(v) Features.MagnetStrength = v end})

CombatExtra:AddToggle("AutoSpike", {Text = "Auto Spike", Default = false, Callback = function(v) Features.AutoSpike = v end})
CombatExtra:AddToggle("AutoBlock", {Text = "Auto Block", Default = false, Callback = function(v) Features.AutoBlock = v end})
CombatExtra:AddToggle("AutoSet", {Text = "Auto Set", Default = false, Callback = function(v) Features.AutoSet = v end})
CombatExtra:AddToggle("AutoReceive", {Text = "Auto Receive", Default = false, Callback = function(v) Features.AutoReceive = v end})

-- TAB: MOVEMENT

local MoveLeft = Tabs.Movement:AddLeftGroupbox("Air & Movement")
local MoveRight = Tabs.Movement:AddRightGroupbox("Advanced Extras")
local MoveExtra = Tabs.Movement:AddRightGroupbox("Teleport & Follow")

MoveLeft:AddToggle("AirMovement", {Text = "Air Movement", Default = false, Callback = function(v) Features.AirMovement = v end})
MoveLeft:AddSlider("AirSpeed", {Text = "Air Speed", Default = 32, Min = 5, Max = 100, Callback = function(v) Features.AirSpeed = v end})
MoveLeft:AddToggle("AutoShiftLock", {Text = "Auto Shift Lock", Default = false, Callback = function(v) Features.AutoShiftLock = v end})
MoveLeft:AddToggle("AimbotCorner", {Text = "Aimbot Corner", Default = false, Callback = function(v) Features.AimbotCorner = v end})
MoveLeft:AddToggle("SpeedHack", {Text = "Speed Hack", Default = false, Callback = function(v) Features.SpeedHack = v end})
MoveLeft:AddSlider("SpeedValue", {Text = "Speed Value", Default = 16, Min = 16, Max = 100, Callback = function(v) Features.SpeedValue = v end})
MoveLeft:AddToggle("JumpBoost", {Text = "Jump Boost", Default = false, Callback = function(v) Features.JumpBoost = v end})
MoveLeft:AddSlider("JumpPower", {Text = "Jump Power", Default = 50, Min = 50, Max = 150, Callback = function(v) Features.JumpPower = v end})
MoveLeft:AddToggle("InfiniteJump", {Text = "Infinite Jump", Default = false, Callback = function(v) Features.InfiniteJump = v end})
MoveLeft:AddToggle("Fly", {Text = "Fly", Default = false, Callback = function(v) Features.Fly = v end})
MoveLeft:AddSlider("FlySpeed", {Text = "Fly Speed", Default = 50, Min = 10, Max = 200, Callback = function(v) Features.FlySpeed = v end})

MoveRight:AddToggle("Desync", {Text = "Desync", Default = false, Callback = function(v) Features.Desync = v end})
MoveRight:AddToggle("KisukiDive", {Text = "Kisuki Dive (Q)", Default = false, Callback = function(v) Features.KisukiDive = v end})
MoveRight:AddSlider("DiveCharge", {Text = "Dive Charge", Default = 1, Min = 0, Max = 1, Rounding = 2, Callback = function(v) Features.DiveCharge = v end})
MoveRight:AddToggle("AkariDash", {Text = "Akari Dash (Shift)", Default = false, Callback = function(v) Features.AkariDash = v end})
MoveRight:AddToggle("LeadFeet", {Text = "Lead Feet", Default = false, Callback = function(v) Features.LeadFeet = v end})
MoveRight:AddToggle("NoClip", {Text = "No Clip", Default = false, Callback = function(v) Features.NoClip = v end})
MoveRight:AddToggle("AutoRotate", {Text = "Auto Rotate to Ball", Default = false, Callback = function(v) Features.AutoRotate = v end})

MoveExtra:AddToggle("TeleportToBall", {Text = "Teleport to Ball", Default = false, Callback = function(v) Features.TeleportToBall = v end})
MoveExtra:AddToggle("AutoFollowBall", {Text = "Auto Follow Ball", Default = false, Callback = function(v) Features.AutoFollowBall = v end})

-- TAB: VISUALS

local VisLeft = Tabs.Visuals:AddLeftGroupbox("ESP")
local VisCenter = Tabs.Visuals:AddLeftGroupbox("World")
local VisRight = Tabs.Visuals:AddRightGroupbox("Score Effect")

VisLeft:AddToggle("JumpESP", {Text = "Jump ESP", Default = false, Callback = function(v) Features.JumpESP = v end})
VisLeft:AddLabel("Jump Color"):AddColorPicker("JumpESPColor", {Default = Features.JumpESPColor, Callback = function(v) Features.JumpESPColor = v end})
VisLeft:AddToggle("BallESP", {Text = "Ball ESP", Default = false, Callback = function(v) Features.BallESP = v end})
VisLeft:AddLabel("Ball Color"):AddColorPicker("BallESPColor", {Default = Features.BallESPColor, Callback = function(v) Features.BallESPColor = v end})
VisLeft:AddToggle("PlayerESP", {Text = "Player ESP", Default = false, Callback = function(v) Features.PlayerESP = v end})
VisLeft:AddLabel("Player Color"):AddColorPicker("PlayerESPColor", {Default = Features.PlayerESPColor, Callback = function(v) Features.PlayerESPColor = v end})
VisLeft:AddToggle("Tracers", {Text = "Tracers", Default = false, Callback = function(v) Features.Tracers = v end})
VisLeft:AddToggle("Chams", {Text = "Chams", Default = false, Callback = function(v) Features.Chams = v end})
VisLeft:AddToggle("BoxESP", {Text = "Box ESP", Default = false, Callback = function(v) Features.BoxESP = v end})
VisLeft:AddToggle("NameESP", {Text = "Name ESP", Default = false, Callback = function(v) Features.NameESP = v end})
VisLeft:AddToggle("DistanceESP", {Text = "Distance ESP", Default = false, Callback = function(v) Features.DistanceESP = v end})
VisLeft:AddToggle("HealthESP", {Text = "Health ESP", Default = false, Callback = function(v) Features.HealthESP = v end})

VisCenter:AddToggle("BallPrediction", {Text = "Ball Prediction", Default = false, Callback = function(v) Features.BallPrediction = v end})
VisCenter:AddToggle("Trajectory", {Text = "Trajectory", Default = false, Callback = function(v) Features.Trajectory = v end})
VisCenter:AddToggle("HitboxVisualizer", {Text = "Hitbox Visualizer", Default = false, Callback = function(v) Features.HitboxVisualizer = v end})
VisCenter:AddToggle("BallTrail", {Text = "Ball Trail", Default = false, Callback = function(v) Features.BallTrail = v end})
VisCenter:AddLabel("Trail Color"):AddColorPicker("BallTrailColor", {Default = Features.BallTrailColor, Callback = function(v) Features.BallTrailColor = v end})
VisCenter:AddToggle("CustomSkybox", {Text = "Custom Skybox", Default = false, Callback = function(v) Features.CustomSkybox = v end})
VisCenter:AddToggle("FullBright", {Text = "Full Bright", Default = false, Callback = function(v) Features.FullBright = v end})
VisCenter:AddToggle("NoFog", {Text = "No Fog", Default = false, Callback = function(v) Features.NoFog = v end})
VisCenter:AddToggle("NoShadows", {Text = "No Shadows", Default = false, Callback = function(v) Features.NoShadows = v end})
VisCenter:AddToggle("CustomFOV", {Text = "Custom FOV", Default = false, Callback = function(v) Features.CustomFOV = v end})
VisCenter:AddSlider("FOVValue", {Text = "FOV", Default = 70, Min = 30, Max = 120, Callback = function(v) Features.FOVValue = v end})
VisCenter:AddToggle("FreeCamera", {Text = "Free Camera", Default = false, Callback = function(v) Features.FreeCamera = v end})
VisCenter:AddToggle("SpectatorMode", {Text = "Spectator Mode", Default = false, Callback = function(v) Features.SpectatorMode = v end})
VisCenter:AddToggle("CourtChanger", {Text = "Court Changer", Default = false, Callback = function(v) Features.CourtChanger = v end})
VisCenter:AddLabel("Court Color"):AddColorPicker("CourtColor", {Default = Features.CourtColor, Callback = function(v) Features.CourtColor = v end})

-- Score Effect ARREGLADO
VisRight:AddToggle("ScoreEffectEnabled", {Text = "Enable Score Effect", Default = false, Callback = function(v) Features.ScoreEffectEnabled = v end})
VisRight:AddDropdown("ScoreEffect", {
    Text = "Score Effect",
    Values = {"Supernova", "Explosion", "Lightning", "Fire", "Rainbow", "Galaxy", "Crystal", "Neon", "Gold", "Diamond"},
    Default = "Supernova",
    Callback = function(v) Features.ScoreEffect = v end
})
VisRight:AddButton("Apply Score Effect", function() 
    ScoreEffectSystem:apply(Features.ScoreEffect) 
end)
VisRight:AddLabel("Available Effects:")
VisRight:AddLabel("• Supernova - Golden explosion")
VisRight:AddLabel("• Explosion - Fire burst")
VisRight:AddLabel("• Lightning - Electric strike")
VisRight:AddLabel("• Fire - Flaming effect")
VisRight:AddLabel("• Rainbow - Multi-color")
VisRight:AddLabel("• Galaxy - Purple cosmic")
VisRight:AddLabel("• Crystal - Ice shards")
VisRight:AddLabel("• Neon - Green glow")
VisRight:AddLabel("• Gold - Rich golden")
VisRight:AddLabel("• Diamond - Crystal clear")

-- TAB: MISC

local MiscLeft = Tabs.Misc:AddLeftGroupbox("Auto & Spin")
local MiscRight = Tabs.Misc:AddRightGroupbox("Cosmetics & Utils")
local MiscExtra = Tabs.Misc:AddRightGroupbox("Farm & Collect")

MiscLeft:AddToggle("AutoSpinStyle", {Text = "Auto Spin Style", Default = false, Callback = function(v) Features.AutoSpinStyle = v end})
MiscLeft:AddToggle("AutoSpinAbility", {Text = "Auto Spin Ability", Default = false, Callback = function(v) Features.AutoSpinAbility = v end})
MiscLeft:AddDropdown("SpinType", {Text = "Spin Type", Values = {"Normal", "Lucky"}, Default = "Normal", Callback = function(v) Features.SpinType = v end})
MiscLeft:AddSlider("SpinSlot", {Text = "Slot", Default = 1, Min = 1, Max = 3, Callback = function(v) Features.SpinSlot = v end})
MiscLeft:AddSlider("SpinSpeed", {Text = "Spin Speed", Default = 35, Min = 10, Max = 100, Callback = function(v) Features.SpinSpeed = v / 100 end})
MiscLeft:AddToggle("AutoClick", {Text = "Auto Click", Default = false, Callback = function(v) Features.AutoClick = v end})
MiscLeft:AddToggle("AutoRejoin", {Text = "Auto Rejoin", Default = false, Callback = function(v) Features.AutoRejoin = v end})
MiscLeft:AddToggle("AntiLag", {Text = "Anti Lag", Default = false, Callback = function(v) Features.AntiLag = v if v then settings().Rendering.QualityLevel = 1 end end})
MiscLeft:AddToggle("Protection", {Text = "Protection Mode", Default = false, Callback = function(v) Features.Protection = v end})
MiscLeft:AddToggle("AntiAFK", {Text = "Anti AFK", Default = false, Callback = function(v) Features.AntiAFK = v end})

MiscRight:AddInput("PlayerCard", {Text = "Player Card", Default = "", Callback = function(v) Features.PlayerCard = v end})
MiscRight:AddToggle("TitleChanger", {Text = "Title Changer", Default = false, Callback = function(v) Features.TitleChanger = v end})
MiscRight:AddInput("Title", {Text = "Title", Default = "", Callback = function(v) Features.Title = v end})
MiscRight:AddInput("BallSkin", {Text = "Ball Skin", Default = "", Callback = function(v) Features.BallSkin = v end})
MiscRight:AddInput("Jersey", {Text = "Jersey", Default = "", Callback = function(v) Features.Jersey = v end})
MiscRight:AddToggle("EmoteSpammer", {Text = "Emote Spammer", Default = false, Callback = function(v) Features.EmoteSpammer = v end})
MiscRight:AddSlider("EmoteSpeed", {Text = "Emote Speed", Default = 1, Min = 0.1, Max = 5, Callback = function(v) Features.EmoteSpeed = v end})
MiscRight:AddToggle("AnimationChanger", {Text = "Animation Changer", Default = false, Callback = function(v) Features.AnimationChanger = v end})
MiscRight:AddSlider("WalkSpeed", {Text = "Walk Speed", Default = 16, Min = 16, Max = 100, Callback = function(v) Features.WalkSpeed = v end})

MiscExtra:AddToggle("AutoFarm", {Text = "Auto Farm", Default = false, Callback = function(v) Features.AutoFarm = v end})
MiscExtra:AddToggle("AutoCollect", {Text = "Auto Collect", Default = false, Callback = function(v) Features.AutoCollect = v end})
MiscExtra:AddToggle("AutoClaimRewards", {Text = "Auto Claim Rewards", Default = false, Callback = function(v) Features.AutoClaimRewards = v end})
MiscExtra:AddToggle("UnlockAll", {Text = "Unlock All", Default = false, Callback = function(v) Features.UnlockAll = v end})

-- TAB: GAME

local GameLeft = Tabs.Game:AddLeftGroupbox("Game Modes")
local GameRight = Tabs.Game:AddRightGroupbox("Data & Reset")

local modes = {
    {"Chaos Mode", "ChaosMode"},
    {"1v1 Mini", "OnesMini"},
    {"2v2 Ranked", "Twos"},
    {"3v3 Ranked", "Threes"},
    {"4v4 Ranked", "Fours"},
    {"6v6 Ranked", "Sixes"},
    {"Training", "Training"},
    {"Ranked Queue", "RankedQueue"},
    {"Casual Queue", "CasualQueue"},
}

for _, mode in ipairs(modes) do
    GameLeft:AddButton("Join " .. mode[1], function()
        local remote = Remotes.PartyTeleport
        if remote then
            pcall(function() remote:InvokeServer(mode[2]) end)
            notify("Joining " .. mode[1])
        end
    end)
end

-- DATA ROLLBACK SECTION
GameRight:AddButton("Data Rollback", function()
    task.spawn(function()
        notify("Sending rollback payload...", 4)
        
        pcall(function()
            if Remotes.DataReset then
                Remotes.DataReset:InvokeServer()
                notify("Rollback sent!", 3)
            else
                -- Buscar manualmente
                local knit = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit
                local services = knit.Services
                local settingsService = services:FindFirstChild("SettingsService")
                if settingsService then
                    local rf = settingsService:FindFirstChild("RF")
                    if rf then
                        local reset = rf:FindFirstChild("Reset") or rf:FindFirstChild("Rollback")
                        if reset then
                            reset:InvokeServer()
                            notify("Rollback executed!", 3)
                        end
                    end
                end
            end
        end)
        
        task.wait(4)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

GameRight:AddLabel("Resets data and rejoins")
GameRight:AddLabel("same server")

-- TAB: SETTINGS

local SetLeft = Tabs.Settings:AddLeftGroupbox("UI Settings")
local SetRight = Tabs.Settings:AddRightGroupbox("Info")

SetLeft:AddToggle("KeybindMenu", {Text = "Show Keybinds", Default = false, Callback = function(v) Library.KeybindFrame.Visible = v end})
SetLeft:AddDropdown("NotifySide", {Text = "Notify Side", Values = {"Left", "Right"}, Default = "Right", Callback = function(v) Library:SetNotifySide(v) end})

SetRight:AddLabel("KingsHub " .. VERSION)
SetRight:AddLabel("Autor: Thiagxjzu3")
SetRight:AddLabel("THANKS FOR ALL")
SetRight:AddLabel("Youtube: SOON")
SetRight:AddLabel("Kick: SOON")
SetRight:AddLabel("TIKTOK: BLACK.JOS")
SetRight:AddLabel("Discord: https://discord.gg/Cbrx5ZTqK")
SetRight:AddDivider()
SetRight:AddButton("Unload Script", function()
    State.running = false
    Library:Unload()
end)

-- INICIALIZACIÓN

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("KingsHub")
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("KingsHub")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- Auto Spin loops
task.spawn(function()
    while State.running do
        if Features.AutoSpinStyle then
            local remote = Remotes.StyleRoll
            if remote then
                pcall(function() remote:InvokeServer(Features.SpinSlot, Features.SpinType == "Lucky") end)
            end
            task.wait(Features.SpinSpeed)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while State.running do
        if Features.AutoSpinAbility then
            local remote = Remotes.AbilityRoll
            if remote then
                pcall(function() remote:InvokeServer(Features.SpinSlot, Features.SpinType == "Lucky") end)
            end
            task.wait(Features.SpinSpeed)
        else
            task.wait(0.1)
        end
    end
end)

-- Emote Spammer
task.spawn(function()
    while State.running do
        if Features.EmoteSpammer then
            pcall(function()
                local remote = Remotes.OpenPack
                if remote then
                    remote:InvokeServer("Emote1")
                end
            end)
            task.wait(Features.EmoteSpeed)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Click
task.spawn(function()
    while State.running do
        if Features.AutoClick then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(0.1)
    end
end)

-- Anti AFK
task.spawn(function()
    while State.running do
        if Features.AntiAFK then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
        task.wait(300) -- Cada 5 minutos
    end
end)

-- Auto Farm
task.spawn(function()
    while State.running do
        if Features.AutoFarm then
            pcall(function()
                -- Farm de puntos automático
                local remote = Remotes.BallInteract
                if remote then
                    remote:InvokeServer({
                        Action = "Spike",
                        Charge = 1,
                        LookVector = Vector3.new(0, -1, 0),
                        From = "Client"
                    })
                end
            end)
        end
        task.wait(1)
    end
end)

-- Auto Collect
task.spawn(function()
    while State.running do
        if Features.AutoCollect then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower():find("coin") or v.Name:lower():find("reward") or v.Name:lower():find("collect") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            firetouchinterest(hrp, v, 0)
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- Auto Claim Rewards
task.spawn(function()
    while State.running do
        if Features.AutoClaimRewards then
            local remote = Remotes.ClaimLevel
            if remote then
                pcall(function() remote:InvokeServer() end)
            end
        end
        task.wait(60) -- Cada minuto
    end
end)

-- Auto Rejoin
LocalPlayer.CharacterRemoving:Connect(function()
    if Features.AutoRejoin and State.running then
        task.delay(3, function()
            TeleportService:Teleport(game.PlaceId)
        end)
    end
end)

-- Notificación final
task.delay(1, function()
    notify("KingsHub MADE BY THIAGXJZU3")
end)

print("¡MADE BY THIAGXJZU3 ENJOY!")

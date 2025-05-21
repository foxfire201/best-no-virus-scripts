repeat task.wait() until game:IsLoaded()

_G.autofarm = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local function medicalstate(p)
    return (p and p.Character
            and p.Character:FindFirstChild("HumanoidRootPart")
            and p.Character:FindFirstChild("Humanoid")
    and p.Character.Humanoid.Health > 0)
end

local entity = setmetatable({}, {
    __index = function(_, v)
        local isalive = medicalstate(Player)
        return ({
            alive = isalive;
            character = {
                HumanoidRootPart = isalive and Player.Character.HumanoidRootPart or nil;
                Humanoid = isalive and Player.Character.Humanoid or nil;
            }
        })[v]
    end
})

local function invecs(p, pos1, pos2)
    local mpos = Vector3.new(math.min(pos1.X, pos2.X), math.min(pos1.Y, pos2.Y), math.min(pos1.Z, pos2.Z))
    local mxpos = Vector3.new(math.max(pos1.X, pos2.X), math.max(pos1.Y, pos2.Y), math.max(pos1.Z, pos2.Z))
    return p.Position.X >= mpos.X and p.Position.X <= mxpos.X and p.Position.Y >= mpos.Y and p.Position.Y <= mxpos.Y and p.Position.Z >= mpos.Z and p.Position.Z <= mxpos.Z
end

local function entityfunction(func)
    if entity.alive then
        func(entity.character.HumanoidRootPart, entity.character.Humanoid)
    end
end

local function insafety(cs)
    if cs then
        return medicalstate(cs) and invecs(cs.Character.HumanoidRootPart, Vector3.new(-99, 323, 32), Vector3.new(109, 292, -33))
    else
        return entity.alive and invecs(entity.character.HumanoidRootPart, Vector3.new(-99, 323, 32), Vector3.new(109, 292, -33))
    end
end

local function canattack(p)
    if medicalstate(p) then
        if insafety() then return false end
        if insafety(p) then return false end
        if p.Character:FindFirstChild("Butter") then return false end
        if p.Character['Right Arm']:FindFirstChildOfClass('SelectionBox') then return false end
        if (p:FindFirstChild('leaderstats') and p:FindFirstChild('leaderstats')
            :FindFirstChild('Ability') and p:FindFirstChild('leaderstats')
            :FindFirstChild('Ability').Value == 'Spectator')
        then
            return false
        end
        return true
    else
        return false
    end
end

local function getcharacter(mag)
    for i, v in pairs(Players:GetPlayers()) do
        if (not medicalstate(v)) or (not entity.alive) or (v == Player) then continue end; 
        if (entity.character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude <= mag and canattack(v) then
            return v
        end
    end
end

local function bloodgodshere()
    for i, v in Workspace:GetChildren() do
        if v.Name == "Blood God Dimension" then
            if (v.Floor.Position - entity.character.HumanoidRootPart.Position).magnitude <= 200 then
                return true
            end
        end
    end
end

repeat
    if insafety() then
        entity.character.HumanoidRootPart.CFrame = Workspace.Portals["Arena Frame"].Portal.CFrame
    end
    if bloodgodshere() and medicalstate() then
        Player.Character:BreakJoints()
    end
    local target = getcharacter(300)
    if target then
        Camera.CameraSubject = target.Character
        entityfunction(function (root)
            local teleporttick = tick()
            while tick() - teleporttick < 2.5 and medicalstate(target) and (entity.character.HumanoidRootPart.Position - Vector3.new(40, 7, 4)).magnitude < 300 do
                root.CFrame = target.Character.HumanoidRootPart.CFrame - Vector3.new(0, 8, 0)
                root.Velocity = Vector3.zero
                Vim:SendMouseButtonEvent(Camera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2, 0, true, nil, 0)
                Vim:SendMouseButtonEvent(Camera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2, 0, false, nil, 0)
                target.Character.HumanoidRootPart.Size = Vector3.new(20, 20, 20)
                task.wait()
            end
        end)
    end
    task.wait()
until not _G.autofarm
Camera.CameraSubject = Player.Character

Player.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        queue_on_teleport("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/foxfire201/best-no-virus-scripts/refs/heads/main/abilitywarautofarmy.lua\"))()")
    end
end)

-- script is open source dont skid yea if you want it give credit
local player = game.Players.LocalPlayer
local noclipEnabled = false
local ownerUserId = 4539739448
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local function sendNotification(title, text, duration)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4
        })
    end)
end

if player.UserId == ownerUserId then
    sendNotification("Welcome Owner", "Welcome " .. player.Name, 5)
end

local function toggleNoclip(state)
    noclipEnabled = state or not noclipEnabled
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclipEnabled
        end
    end
end

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local success, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
end)

if not success or not library then
    sendNotification("Error", "Failed to load  Library", 5)
    return
end

local window = library:CreateWindow("DEAD RAILS")

window:AddButton({
    text = "Bypass To End",
    callback = function()
        sendNotification("Spam Button If Not Teleported", "Keep clicking if teleport fails", 4)
        wait(1)
        player.Character:PivotTo(CFrame.new(-346, -69, -49060))
    end
})

window:AddButton({
    text = "Toggle NoClip",
    callback = function()
        toggleNoclip()
        sendNotification("NoClip Status", "NoClip is now " .. (noclipEnabled and "Enabled" or "Disabled"), 4)
    end
})

window:AddLabel({ text = "Credits: TOUKA", type = "label" })
library:Init()

local function createTimerUI()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)

    local timerFrame = Instance.new("Frame", screenGui)
    timerFrame.Size = UDim2.new(0, 220, 0, 60)
    timerFrame.Position = UDim2.new(0.5, -110, 0, 10)
    timerFrame.AnchorPoint = Vector2.new(0.5, 0)
    timerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    timerFrame.BorderSizePixel = 2
    timerFrame.BorderColor3 = Color3.fromRGB(255, 85, 85)

    local timerLabel = Instance.new("TextLabel", timerFrame)
    timerLabel.Size = UDim2.new(1, 0, 1, 0)
    timerLabel.Text = "10:00"
    timerLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
    timerLabel.Font = Enum.Font.GothamBlack
    timerLabel.TextSize = 32
    timerLabel.BackgroundTransparency = 1

    return timerLabel
end

local timerLabel = createTimerUI()

local function startTimer(duration)
    local endTime = tick() + duration
    while tick() < endTime do
        local remaining = endTime - tick()
        timerLabel.Text = string.format("%02d:%02d", math.floor(remaining / 60), math.floor(remaining % 60))
        wait(0.1)
    end
    timerLabel.Text = "00:00"
end

startTimer(600)

local function handleCommand(command)
    local args = {}
    for arg in command:gmatch("%S+") do table.insert(args, arg) end

    if player.UserId == ownerUserId then
        if args[1] == "!kick" and args[2] then
            local targetPlayer = game.Players:FindFirstChild(args[2])
            if targetPlayer then
                targetPlayer:Kick("Kicked by Owner")
            else
                sendNotification("Error", "Player not found: " .. args[2], 5)
            end
        elseif args[1] == "!notify" then
            local message = table.concat(args, " ", 2)
            for _, plr in pairs(game.Players:GetPlayers()) do
                sendNotification("Notification", message, 5)
            end
        elseif args[1] == "!say" then
            local message = table.concat(args, " ", 2)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Slash, false, game)
            wait(0.1)
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end
    end
end

player.Chatted:Connect(handleCommand)

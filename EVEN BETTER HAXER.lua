-- CLEAN GUI | Speed | No Stun | Fling | Teleport | Fly (ZQSD)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "UltimateMenu"
gui.ResetOnSpawn = false

local function applyRound(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = object
end

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 460, 0, 420)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
applyRound(mainFrame)

local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
applyRound(tabBar)

local tabs = {}
local tabButtons = {}

local tabNames = { "Speed", "No Stun", "Fling", "Teleport", "Fly" }
for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(0, 90, 1, 0)
	btn.Position = UDim2.new(0, (i - 1) * 90, 0, 0)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	applyRound(btn)
	tabButtons[name] = btn

	local frame = Instance.new("Frame", mainFrame)
	frame.Size = UDim2.new(1, 0, 1, -35)
	frame.Position = UDim2.new(0, 0, 0, 35)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.Visible = false
	applyRound(frame)
	tabs[name] = frame
end

tabs["Speed"].Visible = true

local function showTab(tabName)
	for _, frame in pairs(tabs) do frame.Visible = false end
	tabs[tabName].Visible = true
end

for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function() showTab(name) end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.L then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- SPEED TOGGLE
local speedToggle = Instance.new("TextButton", tabs["Speed"])
speedToggle.Size = UDim2.new(0, 240, 0, 45)
speedToggle.Position = UDim2.new(0.5, -120, 0, 40)
speedToggle.Text = "Speed: OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 20
speedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
applyRound(speedToggle)

local speedOn = false
RunService.RenderStepped:Connect(function()
	if speedOn then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
		if hum then hum.WalkSpeed = 30 end
	end
end)
speedToggle.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedToggle.Text = "Speed: " .. (speedOn and "ON" or "OFF")
end)
-- NO STUN TOGGLE
local stunToggle = Instance.new("TextButton", tabs["No Stun"])
stunToggle.Size = UDim2.new(0, 240, 0, 45)
stunToggle.Position = UDim2.new(0.5, -120, 0, 40)
stunToggle.Text = "No Stun: OFF"
stunToggle.Font = Enum.Font.GothamBold
stunToggle.TextSize = 20
stunToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
stunToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
applyRound(stunToggle)

local stunOn = false
RunService.RenderStepped:Connect(function()
	if stunOn then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildWhichIsA("Humanoid")
		if hum then
			hum.PlatformStand = false
			local animator = hum:FindFirstChild("Animator")
			if animator then
				for _, anim in pairs(animator:GetPlayingAnimationTracks()) do
					if anim.Name:lower():find("stun") or anim.Name:lower():find("hit") then
						anim:Stop()
					end
				end
			end
		end
	end
end)
stunToggle.MouseButton1Click:Connect(function()
	stunOn = not stunOn
	stunToggle.Text = "No Stun: " .. (stunOn and "ON" or "OFF")
end)

-- FLING TAB
local flingScroll = Instance.new("ScrollingFrame", tabs["Fling"])
flingScroll.Size = UDim2.new(0, 260, 0, 160)
flingScroll.Position = UDim2.new(0.5, -130, 0, 10)
flingScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
flingScroll.ScrollBarThickness = 6
flingScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
flingScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
applyRound(flingScroll)

local flingLayout = Instance.new("UIListLayout", flingScroll)
flingLayout.Padding = UDim.new(0, 4)

local selectedPlayer = nil
local function refreshFlingList()
	for _, child in pairs(flingScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local b = Instance.new("TextButton", flingScroll)
			b.Size = UDim2.new(1, 0, 0, 24)
			b.Text = plr.Name
			b.Font = Enum.Font.Gotham
			b.TextSize = 16
			b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			b.TextColor3 = Color3.new(1, 1, 1)
			applyRound(b)
			b.MouseButton1Click:Connect(function()
				selectedPlayer = plr
			end)
		end
	end
end
refreshFlingList()
Players.PlayerAdded:Connect(refreshFlingList)
Players.PlayerRemoving:Connect(refreshFlingList)

local flingConn
local bp
local flingBtn = Instance.new("TextButton", tabs["Fling"])
flingBtn.Size = UDim2.new(0, 200, 0, 40)
flingBtn.Position = UDim2.new(0.5, -100, 0, 185)
flingBtn.Text = "FLING"
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 20
flingBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
flingBtn.TextColor3 = Color3.new(1, 1, 1)
applyRound(flingBtn)

flingBtn.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	if flingConn then flingConn:Disconnect() end
	if bp then bp:Destroy() end

	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not target then return end

	hrp.Anchored = false
	bp = Instance.new("BodyAngularVelocity", hrp)
	bp.AngularVelocity = Vector3.new(99999, 99999, 99999)
	bp.MaxTorque = Vector3.new(1e13, 1e13, 1e13)
	bp.P = 1e13

	flingConn = RunService.Heartbeat:Connect(function()
		pcall(function()
			hrp.CFrame = target.CFrame + Vector3.new(0, 1.5, 0)
		end)
	end)
end)

local stopBtn = Instance.new("TextButton", tabs["Fling"])
stopBtn.Size = UDim2.new(0, 200, 0, 40)
stopBtn.Position = UDim2.new(0.5, -100, 0, 230)
stopBtn.Text = "STOP & RESPAWN"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 20
stopBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
applyRound(stopBtn)

stopBtn.MouseButton1Click:Connect(function()
	if flingConn then flingConn:Disconnect() end
	if bp then bp:Destroy() end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then hum.Health = 0 end
end)

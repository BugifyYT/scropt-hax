local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI SETUP
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "UltimateMenu"
gui.ResetOnSpawn = false

local function applyRound(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = object
end

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 320, 0, 360)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
applyRound(mainFrame)

-- TAB BAR
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
applyRound(tabBar)

local function createTabButton(name, position)
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, position, 0, 0)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	applyRound(btn)
	return btn
end

local speedTab = createTabButton("Speed", 0)
local stunTab = createTabButton("No Stun", 100)
local flingTab = createTabButton("Fling", 200)

-- TAB CONTAINERS
local tabs = {}
for _, name in ipairs({ "Speed", "Stun", "Fling" }) do
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
	for _, f in pairs(tabs) do f.Visible = false end
	tabs[tabName].Visible = true
end

speedTab.MouseButton1Click:Connect(function() showTab("Speed") end)
stunTab.MouseButton1Click:Connect(function() showTab("Stun") end)
flingTab.MouseButton1Click:Connect(function() showTab("Fling") end)

-- TOGGLE GUI WITH L
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.L then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- SPEED TOGGLE BUTTON
local speedToggle = Instance.new("TextButton", tabs.Speed)
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
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 30 end
	end
end)
speedToggle.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedToggle.Text = "Speed: " .. (speedOn and "ON" or "OFF")
end)
-- NO STUN TOGGLE BUTTON
local stunToggle = Instance.new("TextButton", tabs.Stun)
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

-- ============== FLING TAB ==============
local dropdown = Instance.new("ScrollingFrame", tabs.Fling)
dropdown.Size = UDim2.new(0, 260, 0, 160)
dropdown.Position = UDim2.new(0.5, -130, 0, 10)
dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dropdown.ScrollBarThickness = 6
dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
dropdown.ClipsDescendants = true
applyRound(dropdown)

local list = Instance.new("UIListLayout", dropdown)
list.Padding = UDim.new(0, 4)
list.SortOrder = Enum.SortOrder.LayoutOrder

local selectedPlayer = nil
local function refreshList()
	for _, child in pairs(dropdown:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local b = Instance.new("TextButton", dropdown)
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
refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

local flingConn
local bp

local flingBtn = Instance.new("TextButton", tabs.Fling)
flingBtn.Size = UDim2.new(0, 200, 0, 40)
flingBtn.Position = UDim2.new(0.5, -100, 0, 180)
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

local stopBtn = Instance.new("TextButton", tabs.Fling)
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
	if hum then
		hum.Health = 0
	end
end)
-- 🆕 TELEPORT TAB
local tpTab = Instance.new("TextButton", tabBar)
tpTab.Size = UDim2.new(0, 100, 1, 0)
tpTab.Position = UDim2.new(0, 300, 0, 0)
tpTab.Text = "Teleport"
tpTab.Font = Enum.Font.GothamBold
tpTab.TextSize = 16
tpTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tpTab.TextColor3 = Color3.fromRGB(240, 240, 240)
applyRound(tpTab)

-- create Teleport tab frame
local tpFrame = Instance.new("Frame", mainFrame)
tpFrame.Size = UDim2.new(1, 0, 1, -35)
tpFrame.Position = UDim2.new(0, 0, 0, 35)
tpFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tpFrame.Visible = false
applyRound(tpFrame)
tabs["Teleport"] = tpFrame

tpTab.MouseButton1Click:Connect(function() showTab("Teleport") end)

-- TELEPORT PLAYER LIST
local tpList = Instance.new("ScrollingFrame", tpFrame)
tpList.Size = UDim2.new(0, 260, 0, 160)
tpList.Position = UDim2.new(0.5, -130, 0, 10)
tpList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tpList.ScrollBarThickness = 6
tpList.CanvasSize = UDim2.new(0, 0, 0, 0)
tpList.AutomaticCanvasSize = Enum.AutomaticSize.Y
tpList.ClipsDescendants = true
applyRound(tpList)

local tpLayout = Instance.new("UIListLayout", tpList)
tpLayout.Padding = UDim.new(0, 4)

-- Refresh teleport list
local function refreshTPList()
	for _, child in pairs(tpList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local b = Instance.new("TextButton", tpList)
			b.Size = UDim2.new(1, 0, 0, 24)
			b.Text = "Teleport to: " .. plr.Name
			b.Font = Enum.Font.Gotham
			b.TextSize = 16
			b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			b.TextColor3 = Color3.new(1, 1, 1)
			applyRound(b)
			b.MouseButton1Click:Connect(function()
				local char = LocalPlayer.Character
				local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if char and targetHRP then
					local hrp = char:FindFirstChild("HumanoidRootPart")
					if hrp then
						hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 2, 0)
					end
				end
			end)
		end
	end
end
refreshTPList()
Players.PlayerAdded:Connect(refreshTPList)
Players.PlayerRemoving:Connect(refreshTPList)

-- FLY TOGGLE
local flying = false
local flyBtn = Instance.new("TextButton", tpFrame)
flyBtn.Size = UDim2.new(0, 200, 0, 40)
flyBtn.Position = UDim2.new(0.5, -100, 0, 185)
flyBtn.Text = "Fly: OFF"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 20
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
applyRound(flyBtn)

local flyVelocity, flyGyro
RunService.RenderStepped:Connect(function()
	if flying then
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local moveDir = LocalPlayer:GetMouse().Hit.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
		flyVelocity.Velocity = moveDir * 50
	end
end)

flyBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if not flying then
		flyVelocity = Instance.new("BodyVelocity", hrp)
		flyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)

		flyGyro = Instance.new("BodyGyro", hrp)
		flyGyro.CFrame = hrp.CFrame
		flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		flyGyro.P = 10000

		flying = true
		flyBtn.Text = "Fly: ON"
	else
		flying = false
		flyBtn.Text = "Fly: OFF"
		if flyVelocity then flyVelocity:Destroy() end
		if flyGyro then flyGyro:Destroy() end
	end
end)

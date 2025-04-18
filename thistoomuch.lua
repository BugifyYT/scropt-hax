local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "CleanHubUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function roundify(obj, radius)
	local uic = Instance.new("UICorner")
	uic.CornerRadius = UDim.new(0, radius or 8)
	uic.Parent = obj
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 460)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0
roundify(mainFrame)
mainFrame.Parent = gui

-- Header
local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 42)
header.Position = UDim2.new(0, 0, 0, 0)
header.Text = "💻  CLEAN HUB MENU"
header.Font = Enum.Font.GothamBold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BorderSizePixel = 0
roundify(header)

-- Tab Bar
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 36)
tabBar.Position = UDim2.new(0, 0, 0, 42)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBar.BorderSizePixel = 0
roundify(tabBar)

-- Tab Content Area
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Size = UDim2.new(1, 0, 1, -78)
contentHolder.Position = UDim2.new(0, 0, 0, 78)
contentHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentHolder.BorderSizePixel = 0
roundify(contentHolder)

-- Tabs Storage
local tabs = {}
local tabButtons = {}
local tabNames = { "Speed", "No Stun", "Fling", "Teleport", "Fly" }

for i, name in ipairs(tabNames) do
	-- Tab Button
	local tabBtn = Instance.new("TextButton", tabBar)
	tabBtn.Size = UDim2.new(0, 100, 1, 0)
	tabBtn.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
	tabBtn.Text = name
	tabBtn.Font = Enum.Font.Gotham
	tabBtn.TextSize = 14
	tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	tabBtn.BorderSizePixel = 0
	tabBtn.AutoButtonColor = false
	roundify(tabBtn)

	tabButtons[name] = tabBtn

	-- Content Frame
	local tabFrame = Instance.new("Frame", contentHolder)
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.Position = UDim2.new(0, 0, 0, 0)
	tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabFrame.Visible = false
	tabFrame.BorderSizePixel = 0
	roundify(tabFrame)

	tabs[name] = tabFrame
end

-- TAB SWITCH FUNCTION
local function showTab(tabName)
	for name, frame in pairs(tabs) do
		frame.Visible = false
		tabButtons[name].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
	if tabs[tabName] then
		tabs[tabName].Visible = true
		tabButtons[tabName].BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- electric blue
	end
end

-- Connect Buttons
for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		showTab(name)
	end)
end

-- Show default tab
showTab("Speed")

-- Toggle GUI with L
UserInputService.InputBegan:Connect(function(input, g)
	if not g and input.KeyCode == Enum.KeyCode.L then
		mainFrame.Visible = not mainFrame.Visible
	end
end)
-- 🔁 SPEED TOGGLE
local speedToggle = Instance.new("TextButton", tabs["Speed"])
speedToggle.Size = UDim2.new(0, 260, 0, 45)
speedToggle.Position = UDim2.new(0.5, -130, 0, 40)
speedToggle.Text = "Speed: OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 20
speedToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedToggle.TextColor3 = Color3.new(1, 1, 1)
speedToggle.AutoButtonColor = false
roundify(speedToggle)

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

	-- smooth fade animation
	local goal = {}
	goal.BackgroundColor3 = speedOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 45)
	game:GetService("TweenService"):Create(speedToggle, TweenInfo.new(0.3), goal):Play()
end)

-- 🚫 NO STUN TOGGLE
local stunToggle = Instance.new("TextButton", tabs["No Stun"])
stunToggle.Size = UDim2.new(0, 260, 0, 45)
stunToggle.Position = UDim2.new(0.5, -130, 0, 40)
stunToggle.Text = "No Stun: OFF"
stunToggle.Font = Enum.Font.GothamBold
stunToggle.TextSize = 20
stunToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
stunToggle.TextColor3 = Color3.new(1, 1, 1)
stunToggle.AutoButtonColor = false
roundify(stunToggle)

local stunOn = false
task.spawn(function()
	while true do
		if stunOn then
			pcall(function()
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.PlatformStand = false
					if hum:FindFirstChild("Animator") then
						for _, anim in pairs(hum.Animator:GetPlayingAnimationTracks()) do
							if anim.Name:lower():find("stun") or anim.Name:lower():find("hit") then
								anim:Stop()
							end
						end
					end
				end
			end)
		end
		task.wait(0.1)
	end
end)

stunToggle.MouseButton1Click:Connect(function()
	stunOn = not stunOn
	stunToggle.Text = "No Stun: " .. (stunOn and "ON" or "OFF")

	local goal = {}
	goal.BackgroundColor3 = stunOn and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(45, 45, 45)
	game:GetService("TweenService"):Create(stunToggle, TweenInfo.new(0.3), goal):Play()
end)
-- 🌀 PLAYER SCROLL LIST
local flingScroll = Instance.new("ScrollingFrame", tabs["Fling"])
flingScroll.Size = UDim2.new(0, 280, 0, 180)
flingScroll.Position = UDim2.new(0.5, -140, 0, 20)
flingScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flingScroll.ScrollBarThickness = 5
flingScroll.BorderSizePixel = 0
flingScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
flingScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
roundify(flingScroll)

local flingLayout = Instance.new("UIListLayout", flingScroll)
flingLayout.Padding = UDim.new(0, 4)

local selectedFlingPlayer = nil
local function refreshFlingList()
	for _, c in pairs(flingScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton", flingScroll)
			btn.Size = UDim2.new(1, 0, 0, 28)
			btn.Text = plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.AutoButtonColor = false
			roundify(btn)

			btn.MouseButton1Click:Connect(function()
				selectedFlingPlayer = plr
			end)
		end
	end
end

refreshFlingList()
Players.PlayerAdded:Connect(refreshFlingList)
Players.PlayerRemoving:Connect(refreshFlingList)

-- 🔴 FLING BUTTON
local flingBtn = Instance.new("TextButton", tabs["Fling"])
flingBtn.Size = UDim2.new(0, 220, 0, 42)
flingBtn.Position = UDim2.new(0.5, -110, 0, 210)
flingBtn.Text = "FLING"
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 20
flingBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
flingBtn.TextColor3 = Color3.new(1, 1, 1)
roundify(flingBtn)

local flingConn
local bp
flingBtn.MouseButton1Click:Connect(function()
	if not selectedFlingPlayer then return end
	if flingConn then flingConn:Disconnect() end
	if bp then bp:Destroy() end

	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local target = selectedFlingPlayer.Character and selectedFlingPlayer.Character:FindFirstChild("HumanoidRootPart")
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

-- ⛔ STOP & RESPAWN BUTTON
local stopBtn = Instance.new("TextButton", tabs["Fling"])
stopBtn.Size = UDim2.new(0, 220, 0, 38)
stopBtn.Position = UDim2.new(0.5, -110, 0, 260)
stopBtn.Text = "STOP & RESPAWN"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 18
stopBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
roundify(stopBtn)

stopBtn.MouseButton1Click:Connect(function()
	if flingConn then flingConn:Disconnect() end
	if bp then bp:Destroy() end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Health = 0 end
end)
-- 📍 TELEPORT SCROLL LIST
local tpScroll = Instance.new("ScrollingFrame", tabs["Teleport"])
tpScroll.Size = UDim2.new(0, 280, 0, 180)
tpScroll.Position = UDim2.new(0.5, -140, 0, 20)
tpScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpScroll.ScrollBarThickness = 5
tpScroll.BorderSizePixel = 0
tpScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
roundify(tpScroll)

local tpLayout = Instance.new("UIListLayout", tpScroll)
tpLayout.Padding = UDim.new(0, 4)

local function refreshTPList()
	for _, c in pairs(tpScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton", tpScroll)
			btn.Size = UDim2.new(1, 0, 0, 28)
			btn.Text = "TP to: " .. plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.AutoButtonColor = false
			roundify(btn)

			btn.MouseButton1Click:Connect(function()
				local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and targetHRP then
					local old = hrp.Anchored
					hrp.Anchored = true
					task.wait(0.1)
					hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
					task.wait(0.1)
					hrp.Anchored = old
				end
			end)
		end
	end
end

refreshTPList()
Players.PlayerAdded:Connect(refreshTPList)
Players.PlayerRemoving:Connect(refreshTPList)
-- 🛩️ FLY TOGGLE (ZQSD, Styled & Animated)
local flyToggle = Instance.new("TextButton", tabs["Fly"])
flyToggle.Size = UDim2.new(0, 260, 0, 45)
flyToggle.Position = UDim2.new(0.5, -130, 0, 40)
flyToggle.Text = "Fly: OFF"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 20
flyToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
flyToggle.TextColor3 = Color3.new(1, 1, 1)
flyToggle.AutoButtonColor = false
roundify(flyToggle)

local flying = false
local flyBV, flyBG

RunService.RenderStepped:Connect(function()
	if flying and flyBV and flyBG then
		local cam = workspace.CurrentCamera
		local dir = Vector3.new()

		-- REAL ZQSD (AZERTY)
		if UserInputService:IsKeyDown(Enum.KeyCode.Z) then dir += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then dir -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end

		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * 50 or Vector3.zero
			flyBG.CFrame = cam.CFrame
		end
	end
end)

flyToggle.MouseButton1Click:Connect(function()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if not flying then
		flying = true
		flyToggle.Text = "Fly: ON"

		local goal = { BackgroundColor3 = Color3.fromRGB(0, 150, 255) }
		game:GetService("TweenService"):Create(flyToggle, TweenInfo.new(0.3), goal):Play()

		flyBV = Instance.new("BodyVelocity", hrp)
		flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		flyBV.Velocity = Vector3.zero

		flyBG = Instance.new("BodyGyro", hrp)
		flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		flyBG.P = 1e4
		flyBG.CFrame = workspace.CurrentCamera.CFrame
	else
		flying = false
		flyToggle.Text = "Fly: OFF"

		local goal = { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }
		game:GetService("TweenService"):Create(flyToggle, TweenInfo.new(0.3), goal):Play()

		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
	end
end)
-- 🌟 FADE-IN ANIMATION WHEN GUI OPENS
mainFrame.BackgroundTransparency = 1
header.BackgroundTransparency = 1
tabBar.BackgroundTransparency = 1
contentHolder.BackgroundTransparency = 1

for _, tab in pairs(tabs) do
	tab.BackgroundTransparency = 1
end

task.wait(0.1)

local fadeIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenService = game:GetService("TweenService")

local function fadeInPart(part)
	tweenService:Create(part, fadeIn, { BackgroundTransparency = 0 }):Play()
end

fadeInPart(mainFrame)
fadeInPart(header)
fadeInPart(tabBar)
fadeInPart(contentHolder)

for _, tab in pairs(tabs) do
	fadeInPart(tab)
end

-- 📝 OPTIONAL CREDIT LABEL
local credit = Instance.new("TextLabel", gui)
credit.Text = "made by u 😎"
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(100, 100, 100)
credit.Position = UDim2.new(0, 10, 1, -30)
credit.Size = UDim2.new(0, 200, 0, 24)
credit.ZIndex = 20

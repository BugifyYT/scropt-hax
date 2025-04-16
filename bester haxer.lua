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
-- TAB SYSTEM FIXED (INCLUDES TELEPORT + FLY TABS CORRECTLY)

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

tabs["Speed"].Visible = true -- default tab

local function showTab(tabName)
	for _, frame in pairs(tabs) do frame.Visible = false end
	if tabs[tabName] then
		tabs[tabName].Visible = true
	end
end

for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		showTab(name)
	end)
end
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
-- TELEPORT TAB
local tpScroll = Instance.new("ScrollingFrame", tabs["Teleport"])
tpScroll.Size = UDim2.new(0, 260, 0, 160)
tpScroll.Position = UDim2.new(0.5, -130, 0, 10)
tpScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tpScroll.ScrollBarThickness = 6
tpScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
applyRound(tpScroll)

local tpLayout = Instance.new("UIListLayout", tpScroll)
tpLayout.Padding = UDim.new(0, 4)

local function refreshTPList()
	for _, child in pairs(tpScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local b = Instance.new("TextButton", tpScroll)
			b.Size = UDim2.new(1, 0, 0, 24)
			b.Text = "Teleport to: " .. plr.Name
			b.Font = Enum.Font.Gotham
			b.TextSize = 16
			b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			b.TextColor3 = Color3.new(1, 1, 1)
			applyRound(b)
			b.MouseButton1Click:Connect(function()
				local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and target then
					hrp.CFrame = target.CFrame + Vector3.new(0, 2, 0)
				end
			end)
		end
	end
end
refreshTPList()
Players.PlayerAdded:Connect(refreshTPList)
Players.PlayerRemoving:Connect(refreshTPList)

-- FLY TAB (ZQSD)
local flyToggle = Instance.new("TextButton", tabs["Fly"])
flyToggle.Size = UDim2.new(0, 240, 0, 45)
flyToggle.Position = UDim2.new(0.5, -120, 0, 40)
flyToggle.Text = "Fly: OFF"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 20
flyToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
flyToggle.TextColor3 = Color3.new(1, 1, 1)
applyRound(flyToggle)

local flying = false
local flyBV, flyBG
local moveVector = Vector3.zero

RunService.RenderStepped:Connect(function()
	if flying and flyBV and flyBG then
		local camCF = workspace.CurrentCamera.CFrame
		local dir = Vector3.new()

		if UserInputService:IsKeyDown(Enum.KeyCode.Z) then dir = dir + camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then dir = dir - camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

		flyBV.Velocity = dir.Unit * 50
		if dir.Magnitude == 0 then
			flyBV.Velocity = Vector3.zero
		end

		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			flyBG.CFrame = camCF
		end
	end
end)

flyToggle.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if not flying then
		flying = true
		flyToggle.Text = "Fly: ON"

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
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
	end
end)

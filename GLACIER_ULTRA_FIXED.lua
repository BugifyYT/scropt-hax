local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- GUI Container

-- UI SOUND FX SETUP
local function makeSound(id)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. tostring(id)
	s.Volume = 0.3
	s.Name = "UISFX"
	s.PlayOnRemove = true
	return s
end

local beepSound = makeSound(911882310)
local stopSound = makeSound(138087018)
local navSound = makeSound(203691822)

local function playSFX(sound)
	local s = sound:Clone()
	s.Parent = workspace
	s:Destroy()
end



local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "GlacierStyleHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 720, 0, 460)
main.Position = UDim2.new(0.5, -360, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
sidebar.BorderSizePixel = 0

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Title
local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, -20, 0, 60)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "  Glacier UI"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

-- Tabs + Icons
local tabButtons = {}
local tabs = {}
local tabNames = {
	{ name = "Main", icon = "🏠" },
	{ name = "Speed", icon = "⚡" },
	{ name = "No Stun", icon = "🚫" },
	{ name = "Fling", icon = "🎯" },
	{ name = "Teleport", icon = "🧍" },
	{ name = "Fly", icon = "🛩️" },
	{ name = "Credits", icon = "💎" }
}

local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, -180, 1, 0)
contentHolder.Position = UDim2.new(0, 180, 0, 0)
contentHolder.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
contentHolder.BorderSizePixel = 0

for _, tabInfo in ipairs(tabNames) do
	local name = tabInfo.name
	local icon = tabInfo.icon

	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
	btn.Text = icon .. "  " .. name
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 16
	btn.TextColor3 = Color3.fromRGB(160, 160, 160)
	btn.BorderSizePixel = 0

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	local tabFrame = Instance.new("Frame", contentHolder)
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabFrame.BorderSizePixel = 0
	tabFrame.Visible = false

	local tabCorner = Instance.new("UICorner", tabFrame)
	tabCorner.CornerRadius = UDim.new(0, 10)

	tabButtons[name] = btn
	tabs[name] = tabFrame
end

-- Active tab logic
local function switchTab(tabName)
	for name, frame in pairs(tabs) do
		frame.Visible = false
		tabButtons[name].BackgroundColor3 = Color3.fromRGB(34, 34, 34)
		tabButtons[name].TextColor3 = Color3.fromRGB(160, 160, 160)
	end

	if tabs[tabName] then
		tabs[tabName].Visible = true
		tabButtons[tabName].BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		tabButtons[tabName].TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end

for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
end

-- Default tab
switchTab("Main")

-- Toggle with L
UserInputService.InputBegan:Connect(function(input, g)
	if not g and input.KeyCode == Enum.KeyCode.L then
		main.Visible = not main.Visible
	end
end)
local function createCard(tab, titleText, descriptionText)
	local card = Instance.new("Frame", tab)
	card.Size = UDim2.new(1, -40, 0, 60)
	card.Position = UDim2.new(0, 20, 0, 0)
	card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	card.BorderSizePixel = 0
	card.Name = titleText:gsub(" ", "") .. "Card"

	local uicorner = Instance.new("UICorner", card)
	uicorner.CornerRadius = UDim.new(0, 8)

	local title = Instance.new("TextLabel", card)
	title.Text = titleText
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextColor3 = Color3.fromRGB(240, 240, 240)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 10, 0, 6)
	title.Size = UDim2.new(1, -20, 0, 20)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local desc = Instance.new("TextLabel", card)
	desc.Text = descriptionText
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 14
	desc.TextColor3 = Color3.fromRGB(180, 180, 180)
	desc.BackgroundTransparency = 1
	desc.Position = UDim2.new(0, 10, 0, 28)
	desc.Size = UDim2.new(1, -20, 0, 20)
	desc.TextXAlignment = Enum.TextXAlignment.Left

	return card
end

-- Example usage for "Main" tab:
createCard(tabs["Main"], "Welcome to Glacier Hub", "This UI was made cleaner than your keyboard.")
createCard(tabs["Main"], "Click a tab", "Pick a feature from the sidebar.")
-- createToggle function (drop 3 base)
local function createToggle(card, defaultState, onToggle)
	local toggle = Instance.new("TextButton", card)
	toggle.Size = UDim2.new(0, 60, 0, 28)
	toggle.Position = UDim2.new(1, -70, 0.5, -14)
	toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)
	toggle.Text = ""
	toggle.AutoButtonColor = false
	toggle.BorderSizePixel = 0

	local corner = Instance.new("UICorner", toggle)
	corner.CornerRadius = UDim.new(1, 0)

	local state = defaultState

	toggle.MouseButton1Click:Connect(function()
		state = not state
		local tweenGoal = {
			BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)
		}
		game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), tweenGoal):Play()

		onToggle(state)
	end)

	return toggle
end
-- SPEED TOGGLE
local speedOn = false
createToggle(createCard(tabs["Speed"], "Speed", "Run fast like Sonic."), false, function(enabled)
	speedOn = enabled
end)

RunService.RenderStepped:Connect(function()
	if speedOn then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
		if hum then hum.WalkSpeed = 30 end
	end
end)

-- NO STUN TOGGLE
local stunOn = false
createToggle(createCard(tabs["No Stun"], "No Stun", "Block ragdolls, hits, stuns."), false, function(enabled)
	stunOn = enabled
end)

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
local function createScrollList(tab)
	local scroll = Instance.new("ScrollingFrame", tab)
	scroll.Size = UDim2.new(1, -40, 1, -20)
	scroll.Position = UDim2.new(0, 20, 0, 10)
	scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local corner = Instance.new("UICorner", scroll)
	corner.CornerRadius = UDim.new(0, 8)

	return scroll
end
local tpScroll = createScrollList(tabs["Teleport"])

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		local card = Instance.new("TextButton", tpScroll)
		card.Size = UDim2.new(1, 0, 0, 50)
		card.Text = "Teleport to: " .. plr.Name
		card.Font = Enum.Font.Gotham
		card.TextSize = 16
		card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		card.TextColor3 = Color3.new(1, 1, 1)
		card.BorderSizePixel = 0
		card.AutoButtonColor = false
		roundify(card)

		card.MouseButton1Click:Connect(function()
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

Players.PlayerAdded:Connect(function()
	tabs["Teleport"]:ClearAllChildren()
	tpScroll = createScrollList(tabs["Teleport"])
	-- re-add all players again here if needed
end)
local flingScroll = createScrollList(tabs["Fling"])
local selectedFlingTarget = nil
local flingConn, bp

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		local card = Instance.new("TextButton", flingScroll)
		card.Size = UDim2.new(1, 0, 0, 50)
		card.Text = "Target: " .. plr.Name
		card.Font = Enum.Font.Gotham
		card.TextSize = 16
		card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		card.TextColor3 = Color3.new(1, 1, 1)
		card.BorderSizePixel = 0
		card.AutoButtonColor = false
		roundify(card)

		card.MouseButton1Click:Connect(function()
			selectedFlingTarget = plr
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if not hrp or not target then return end

			if flingConn then flingConn:Disconnect() end
			if bp then bp:Destroy() end

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
	end
end

-- Optional Stop Button
local stopBtn = Instance.new("TextButton", tabs["Fling"])
stopBtn.Size = UDim2.new(0, 220, 0, 38)
stopBtn.Position = UDim2.new(0.5, -110, 1, -48)
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
-- Create FLY Card
local flyCard = createCard(tabs["Fly"], "Fly Mode", "Move with ZQSD / Space / Ctrl")

-- Vars
local flyOn = false
local bv, bg
local keys = {Z = false, Q = false, S = false, D = false, Space = false, Ctrl = false}

-- Glacier toggle
createToggle(flyCard, false, function(state)
	flyOn = state
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if flyOn then
		bv = Instance.new("BodyVelocity", hrp)
		bv.Velocity = Vector3.zero
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

		bg = Instance.new("BodyGyro", hrp)
		bg.CFrame = workspace.CurrentCamera.CFrame
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bg.P = 1e4
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- Key input listeners
UserInputService.InputBegan:Connect(function(input, g)
	if g then return end
	if input.KeyCode == Enum.KeyCode.Z then keys.Z = true end
	if input.KeyCode == Enum.KeyCode.Q then keys.Q = true end
	if input.KeyCode == Enum.KeyCode.S then keys.S = true end
	if input.KeyCode == Enum.KeyCode.D then keys.D = true end
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
	if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Z then keys.Z = false end
	if input.KeyCode == Enum.KeyCode.Q then keys.Q = false end
	if input.KeyCode == Enum.KeyCode.S then keys.S = false end
	if input.KeyCode == Enum.KeyCode.D then keys.D = false end
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
	if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = false end
end)

-- Movement loop
RunService.RenderStepped:Connect(function()
	if not flyOn then return end
	local cam = workspace.CurrentCamera
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp or not bv or not bg then return end

	local move = Vector3.new()
	if keys.Z then move += cam.CFrame.LookVector end
	if keys.S then move -= cam.CFrame.LookVector end
	if keys.Q then move -= cam.CFrame.RightVector end
	if keys.D then move += cam.CFrame.RightVector end
	if keys.Space then move += Vector3.new(0, 1, 0) end
	if keys.Ctrl then move -= Vector3.new(0, 1, 0) end

	if move.Magnitude > 0 then
		bv.Velocity = move.Unit * 50
	else
		bv.Velocity = Vector3.zero
	end

	bg.CFrame = cam.CFrame
end)
-- Create FLY Card
local flyCard = createCard(tabs["Fly"], "Fly Mode", "Move with ZQSD / Space / Ctrl")

-- Vars
local flyOn = false
local bv, bg
local keys = {Z = false, Q = false, S = false, D = false, Space = false, Ctrl = false}

-- Glacier toggle
createToggle(flyCard, false, function(state)
	flyOn = state
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if flyOn then
		bv = Instance.new("BodyVelocity", hrp)
		bv.Velocity = Vector3.zero
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

		bg = Instance.new("BodyGyro", hrp)
		bg.CFrame = workspace.CurrentCamera.CFrame
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bg.P = 1e4
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- Key input listeners
UserInputService.InputBegan:Connect(function(input, g)
	if g then return end
	if input.KeyCode == Enum.KeyCode.Z then keys.Z = true end
	if input.KeyCode == Enum.KeyCode.Q then keys.Q = true end
	if input.KeyCode == Enum.KeyCode.S then keys.S = true end
	if input.KeyCode == Enum.KeyCode.D then keys.D = true end
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
	if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Z then keys.Z = false end
	if input.KeyCode == Enum.KeyCode.Q then keys.Q = false end
	if input.KeyCode == Enum.KeyCode.S then keys.S = false end
	if input.KeyCode == Enum.KeyCode.D then keys.D = false end
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
	if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = false end
end)

-- Movement loop
RunService.RenderStepped:Connect(function()
	-- [Fly movement logic continues here]
	-- Removed duplicate.
end)

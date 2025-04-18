-- GLACIER ULTRA V2 ✅ FINAL BUILD
-- Includes: UI Framework, Tabs, Toggles, Fling, TP, Fly (ZQSD), SFX

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 🔊 UI Sound Setup
local function makeSound(id)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. tostring(id)
	s.Volume = 0.3
	s.Name = "UISFX"
	s.PlayOnRemove = true
	return s
end

local sfx_beep = makeSound(911882310)
local sfx_tab = makeSound(203691822)
local sfx_stop = makeSound(138087018)

local function playSFX(sound)
	local s = sound:Clone()
	s.Parent = workspace
	s:Destroy()
end
-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "GlacierHubV2"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 720, 0, 460)
main.Position = UDim2.new(0.5, -360, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)
sidebar.BorderSizePixel = 0
sidebar.Position = UDim2.new(0, 0, 0, 0)

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, -20, 0, 60)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "  GLACIER V2 ❄️"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -180, 1, 0)
content.Position = UDim2.new(0, 180, 0, 0)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
content.BorderSizePixel = 0
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)
-- UI Fade In
main.BackgroundTransparency = 1
sidebar.BackgroundTransparency = 1
content.BackgroundTransparency = 1
title.TextTransparency = 1

task.wait(0.2)
local fade = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(main, fade, {BackgroundTransparency = 0}):Play()
TweenService:Create(sidebar, fade, {BackgroundTransparency = 0}):Play()
TweenService:Create(content, fade, {BackgroundTransparency = 0}):Play()
TweenService:Create(title, fade, {TextTransparency = 0}):Play()
main.Visible = true

-- Toggle Keybind
UserInputService.InputBegan:Connect(function(input, g)
	if not g and input.KeyCode == Enum.KeyCode.L then
		main.Visible = not main.Visible
	end
end)
-- SPEED TOGGLE FUNCTIONALITY
local speedOn = false

local function createCard(tab, titleText, descText)
	local card = Instance.new("Frame", tab)
	card.Size = UDim2.new(1, -40, 0, 60)
	card.Position = UDim2.new(0, 20, 0, #tab:GetChildren() * 70)
	card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	card.BorderSizePixel = 0
	card.Name = titleText:gsub(" ", "") .. "Card"

	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

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
	desc.Text = descText
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 14
	desc.TextColor3 = Color3.fromRGB(180, 180, 180)
	desc.BackgroundTransparency = 1
	desc.Position = UDim2.new(0, 10, 0, 28)
	desc.Size = UDim2.new(1, -20, 0, 20)
	desc.TextXAlignment = Enum.TextXAlignment.Left

	return card
end

local function createToggle(card, defaultState, onToggle)
	local toggle = Instance.new("TextButton", card)
	toggle.Size = UDim2.new(0, 60, 0, 28)
	toggle.Position = UDim2.new(1, -70, 0.5, -14)
	toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)
	toggle.Text = ""
	toggle.AutoButtonColor = false
	toggle.BorderSizePixel = 0
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local state = defaultState

	toggle.MouseButton1Click:Connect(function()
		state = not state
		local goal = {
			BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)
		}
		TweenService:Create(toggle, TweenInfo.new(0.2), goal):Play()
		onToggle(state)
		playSFX(sfx_beep)
	end)
end

-- Create Speed Toggle
createToggle(createCard(tabs["Speed"], "Speed", "Set WalkSpeed to 30"), false, function(enabled)
	speedOn = enabled
end)

RunService.RenderStepped:Connect(function()
	if speedOn then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
		if hum then hum.WalkSpeed = 30 end
	end
end)
-- NO STUN TOGGLE FUNCTIONALITY
local stunOn = false

-- Create No Stun Toggle
createToggle(createCard(tabs["No Stun"], "No Stun", "Prevents ragdoll + stun animations"), false, function(enabled)
	stunOn = enabled
end)

-- Loop that prevents ragdoll/stun
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
-- TELEPORT TAB – Player Scroll List
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

	Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
	return scroll
end

-- TELEPORT FUNCTIONALITY
local tpScroll = createScrollList(tabs["Teleport"])

local function refreshTP()
	tpScroll:ClearAllChildren()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local card = Instance.new("TextButton", tpScroll)
			card.Size = UDim2.new(1, 0, 0, 50)
			card.Text = "Teleport to: " .. plr.Name
			card.Font = Enum.Font.Gotham
			card.TextSize = 16
			card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			card.TextColor3 = Color3.new(1, 1, 1)
			card.BorderSizePixel = 0
			card.AutoButtonColor = false
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

			card.MouseButton1Click:Connect(function()
				local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and targetHRP then
					playSFX(sfx_beep)
					hrp.Anchored = true
					task.wait(0.1)
					hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
					task.wait(0.1)
					hrp.Anchored = false
				end
			end)
		end
	end
end

Players.PlayerAdded:Connect(refreshTP)
Players.PlayerRemoving:Connect(refreshTP)
refreshTP()
-- FLING TAB – Player Scroll List + Fling System
local flingScroll = createScrollList(tabs["Fling"])
local flingConn, bp

local function refreshFling()
	flingScroll:ClearAllChildren()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local card = Instance.new("TextButton", flingScroll)
			card.Size = UDim2.new(1, 0, 0, 50)
			card.Text = "Fling: " .. plr.Name
			card.Font = Enum.Font.Gotham
			card.TextSize = 16
			card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			card.TextColor3 = Color3.new(1, 1, 1)
			card.BorderSizePixel = 0
			card.AutoButtonColor = false
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

			card.MouseButton1Click:Connect(function()
				local char = LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if not hrp or not targetHRP then return end

				if flingConn then flingConn:Disconnect() end
				if bp then bp:Destroy() end

				hrp.Anchored = false
				bp = Instance.new("BodyAngularVelocity", hrp)
				bp.AngularVelocity = Vector3.new(99999, 99999, 99999)
				bp.MaxTorque = Vector3.new(1e13, 1e13, 1e13)
				bp.P = 1e13

				flingConn = RunService.Heartbeat:Connect(function()
					pcall(function()
						hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 1.5, 0)
					end)
				end)

				playSFX(sfx_beep)
			end)
		end
	end
end

Players.PlayerAdded:Connect(refreshFling)
Players.PlayerRemoving:Connect(refreshFling)
refreshFling()
-- STOP BUTTON FOR FLING
local stopBtn = Instance.new("TextButton", tabs["Fling"])
stopBtn.Size = UDim2.new(0, 200, 0, 38)
stopBtn.Position = UDim2.new(0.5, -100, 1, -48)
stopBtn.Text = "STOP FLING"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 18
stopBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

stopBtn.MouseButton1Click:Connect(function()
	if flingConn then flingConn:Disconnect() end
	if bp then bp:Destroy() end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Health = 0 end
	playSFX(sfx_stop)
end)
-- FLY TAB – Infinite Yield Style (ZQSD, Space, Ctrl)
local flyCard = createCard(tabs["Fly"], "Fly Mode", "ZQSD + Space/Ctrl | Camera Based")

local flyOn = false
local flyBV, flyBG
local flyKeys = {
	Z = false, Q = false, S = false, D = false,
	Space = false, Ctrl = false
}

createToggle(flyCard, false, function(state)
	flyOn = state
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if flyOn then
		flyBV = Instance.new("BodyVelocity", hrp)
		flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		flyBV.Velocity = Vector3.zero

		flyBG = Instance.new("BodyGyro", hrp)
		flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		flyBG.P = 1e4
		flyBG.CFrame = workspace.CurrentCamera.CFrame
	else
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
	end

	playSFX(sfx_beep)
end)
UserInputService.InputBegan:Connect(function(input, g)
	if g then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.Z then flyKeys.Z = true end
	if key == Enum.KeyCode.Q then flyKeys.Q = true end
	if key == Enum.KeyCode.S then flyKeys.S = true end
	if key == Enum.KeyCode.D then flyKeys.D = true end
	if key == Enum.KeyCode.Space then flyKeys.Space = true end
	if key == Enum.KeyCode.LeftControl then flyKeys.Ctrl = true end
end)

UserInputService.InputEnded:Connect(function(input)
	local key = input.KeyCode
	if key == Enum.KeyCode.Z then flyKeys.Z = false end
	if key == Enum.KeyCode.Q then flyKeys.Q = false end
	if key == Enum.KeyCode.S then flyKeys.S = false end
	if key == Enum.KeyCode.D then flyKeys.D = false end
	if key == Enum.KeyCode.Space then flyKeys.Space = false end
	if key == Enum.KeyCode.LeftControl then flyKeys.Ctrl = false end
end)
RunService.RenderStepped:Connect(function()
	if not flyOn then return end

	local cam = workspace.CurrentCamera
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp or not flyBV or not flyBG then return end

	local move = Vector3.new()
	if flyKeys.Z then move += cam.CFrame.LookVector end
	if flyKeys.S then move -= cam.CFrame.LookVector end
	if flyKeys.Q then move -= cam.CFrame.RightVector end
	if flyKeys.D then move += cam.CFrame.RightVector end
	if flyKeys.Space then move += Vector3.new(0, 1, 0) end
	if flyKeys.Ctrl then move -= Vector3.new(0, 1, 0) end

	flyBV.Velocity = move.Magnitude > 0 and move.Unit * 50 or Vector3.zero
	flyBG.CFrame = cam.CFrame
end)

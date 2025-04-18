local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- MAIN GUI CONTAINER
local gui = Instance.new("ScreenGui")
gui.Name = "HolyHaxMinimal"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Rounded helper
local function applyRound(obj, r)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, r or 8)
	corner.Parent = obj
end

-- MAIN FRAME (Center, Flat Dark, Shadow Style)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 470)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -235)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
applyRound(mainFrame)
mainFrame.Parent = gui

-- TAB BAR BASE (Top Strip)
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, 42)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
tabBar.BorderSizePixel = 0
applyRound(tabBar)

-- MAIN CONTENT HOLDER
local tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Name = "TabContent"
tabHolder.Position = UDim2.new(0, 0, 0, 42)
tabHolder.Size = UDim2.new(1, 0, 1, -42)
tabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabHolder.BorderSizePixel = 0
applyRound(tabHolder)

-- TOGGLE GUI KEY: L
UserInputService.InputBegan:Connect(function(input, g)
	if not g and input.KeyCode == Enum.KeyCode.L then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- PREP TABS TABLES FOR NEXT DROPS
local tabs = {}
local tabButtons = {}
-- TAB NAMES (edit/add more if needed)
local tabNames = { "Speed", "No Stun", "Fling", "Teleport", "Fly" }

-- GENERATE TABS + BUTTONS
for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", tabBar)
	btn.Name = name .. "TabButton"
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
	btn.Text = name
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 15
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.AutoButtonColor = false
	applyRound(btn, 6)

	-- hover glow effect
	btn.MouseEnter:Connect(function()
		if not tabs[name] or not tabs[name].Visible then
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end
	end)

	btn.MouseLeave:Connect(function()
		if not tabs[name] or not tabs[name].Visible then
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		end
	end)

	-- content frame
	local frame = Instance.new("Frame", tabHolder)
	frame.Name = name .. "Tab"
	frame.Visible = false
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	applyRound(frame, 8)

	tabs[name] = frame
	tabButtons[name] = btn
end

-- DEFAULT TAB
local function showTab(tabName)
	for name, frame in pairs(tabs) do
		frame.Visible = false
		tabButtons[name].BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		tabButtons[name].TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	if tabs[tabName] then
		tabs[tabName].Visible = true
		tabButtons[tabName].BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- electric blue
		tabButtons[tabName].TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end

for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		showTab(name)
	end)
end

-- default to first tab
showTab(tabNames[1])
-- 🏃 SPEED TOGGLE (Electric Blue = ON)
local speedToggle = Instance.new("TextButton", tabs["Speed"])
speedToggle.Size = UDim2.new(0, 260, 0, 45)
speedToggle.Position = UDim2.new(0.5, -130, 0, 40)
speedToggle.Text = "Speed: OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 20
speedToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedToggle.TextColor3 = Color3.new(1, 1, 1)
speedToggle.AutoButtonColor = false
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
	speedToggle.BackgroundColor3 = speedOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 45)
end)

-- 🚫 NO STUN TOGGLE (Crimson Red = ON)
local stunToggle = Instance.new("TextButton", tabs["No Stun"])
stunToggle.Size = UDim2.new(0, 260, 0, 45)
stunToggle.Position = UDim2.new(0.5, -130, 0, 40)
stunToggle.Text = "No Stun: OFF"
stunToggle.Font = Enum.Font.GothamBold
stunToggle.TextSize = 20
stunToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
stunToggle.TextColor3 = Color3.new(1, 1, 1)
stunToggle.AutoButtonColor = false
applyRound(stunToggle)

local stunOn = false
task.spawn(function()
	while true do
		if stunOn then
			pcall(function()
				local char = Players.LocalPlayer.Character
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
	stunToggle.BackgroundColor3 = stunOn and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(45, 45, 45)
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
applyRound(tpScroll)

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
			applyRound(btn)

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
-- 🛩️ FLY TOGGLE (REAL ZQSD)
local flyToggle = Instance.new("TextButton", tabs["Fly"])
flyToggle.Size = UDim2.new(0, 260, 0, 45)
flyToggle.Position = UDim2.new(0.5, -130, 0, 40)
flyToggle.Text = "Fly: OFF"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 20
flyToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
flyToggle.TextColor3 = Color3.new(1, 1, 1)
flyToggle.AutoButtonColor = false
applyRound(flyToggle)

local flying = false
local flyBV, flyBG

RunService.RenderStepped:Connect(function()
	if flying and flyBV and flyBG then
		local cam = workspace.CurrentCamera
		local dir = Vector3.new()

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
		flyToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

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
		flyToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
	end
end)
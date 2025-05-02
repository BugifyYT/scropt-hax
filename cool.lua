local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espBoxes = {}
local murdererHighlights = {}
local gunHighlights = {}

-- === UTIL: Lobby detection ===
local function isInLobby()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return LocalPlayer.Character.HumanoidRootPart.Position.Y > 100
	end
	return true
end

-- === Create Box ESP ===
local function createBox(player)
	if espBoxes[player] then return end
	local box = Drawing.new("Square")
	box.Color = Color3.fromRGB(255, 255, 255)
	box.Thickness = 2
	box.Transparency = 1
	box.Filled = false
	espBoxes[player] = box
end

local function removeBox(player)
	if espBoxes[player] then
		espBoxes[player]:Remove()
		espBoxes[player] = nil
	end
end

-- === Create RED Highlight (murderer) ===
local function createMurderHighlight(player)
	if murdererHighlights[player] or not player.Character then return end
	local hl = Instance.new("Highlight")
	hl.Name = "MurderESP"
	hl.Adornee = player.Character
	hl.FillColor = Color3.fromRGB(255, 0, 0)
	hl.OutlineColor = Color3.fromRGB(150, 0, 0)
	hl.FillTransparency = 0.25
	hl.OutlineTransparency = 0
	hl.Parent = player.Character
	murdererHighlights[player] = hl
end

-- === Create BLUE Highlight (gun) ===
local function createGunHighlight(player)
	for plr, old in pairs(gunHighlights) do
		if plr ~= player then
			old:Destroy()
			gunHighlights[plr] = nil
		end
	end
	if gunHighlights[player] or not player.Character then return end
	local hl = Instance.new("Highlight")
	hl.Name = "GunESP"
	hl.Adornee = player.Character
	hl.FillColor = Color3.fromRGB(0, 150, 255)
	hl.OutlineColor = Color3.fromRGB(0, 100, 255)
	hl.FillTransparency = 0.25
	hl.OutlineTransparency = 0
	hl.Parent = player.Character
	gunHighlights[player] = hl
end

-- === MAIN LOOP ===
RunService.RenderStepped:Connect(function()
	if isInLobby() then
		for _, box in pairs(espBoxes) do box.Visible = false end
		return
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local char = player.Character
			local hrp = char.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

			-- BOX ESP
			createBox(player)
			local box = espBoxes[player]
			if onScreen then
				box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
				box.Size = Vector2.new(50, 80)
				box.Visible = true
			else
				box.Visible = false
			end

			-- RED: Knife detection (once)
			local hasKnife = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
			if hasKnife and not murdererHighlights[player] then
				createMurderHighlight(player)
			end

			-- BLUE: Gun detection (updates live)
			local hasGun = char:FindFirstChild("Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun"))
			if hasGun then
				if not gunHighlights[player] then
					createGunHighlight(player)
				end
			elseif gunHighlights[player] then
				gunHighlights[player]:Destroy()
				gunHighlights[player] = nil
			end
		else
			removeBox(player)
		end
	end
end)

-- === CLEANUP ON LEAVE ===
Players.PlayerRemoving:Connect(function(player)
	removeBox(player)
	if murdererHighlights[player] then
		murdererHighlights[player]:Destroy()
		murdererHighlights[player] = nil
	end
	if gunHighlights[player] then
		gunHighlights[player]:Destroy()
		gunHighlights[player] = nil
	end
end)

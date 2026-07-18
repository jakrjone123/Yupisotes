local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local runtime = (getgenv and getgenv()) or _G
runtime.YupisotesGeneration = (runtime.YupisotesGeneration or 0) + 1
local autoPlantGeneration = runtime.YupisotesGeneration

local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local playerGui = player:WaitForChild("PlayerGui")

local function getParent()
	local ok, ui = pcall(function()
		if gethui then
			return gethui()
		end
	end)
	if ok and ui then
		return ui
	end

	local coreOk, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if coreOk and coreGui then
		return coreGui
	end

	return playerGui
end

local guiParent = getParent()
for _, name in ipairs({"YupisotesUI", "WisHubGardenUI", "MaruHubPremiumCleanSidebar"}) do
	local existing = guiParent:FindFirstChild(name)
	if existing then
		existing:Destroy()
	end
end

local function rgb(r, g, b)
	return Color3.fromRGB(r, g, b)
end

local palette = {
	bg = rgb(5, 8, 8),
	bg2 = rgb(10, 13, 12),
	side = rgb(13, 16, 16),
	card = rgb(17, 20, 26),
	card2 = rgb(20, 24, 31),
	cardHover = rgb(29, 35, 45),
	stroke = rgb(43, 22, 58),
	stroke2 = rgb(88, 24, 135),
	accent = rgb(176, 51, 255),
	accent2 = rgb(124, 34, 189),
	text = rgb(245, 245, 247),
	muted = rgb(138, 139, 146),
	dim = rgb(92, 93, 100),
	green = rgb(95, 255, 145),
}

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Transparency = transparency or 0
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function padding(parent, l, t, r, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 0)
	p.PaddingTop = UDim.new(0, t or 0)
	p.PaddingRight = UDim.new(0, r or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	p.Parent = parent
	return p
end

local function label(parent, text, size, color, bold)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	t.Text = text
	t.TextSize = size
	t.TextColor3 = color or palette.text
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextYAlignment = Enum.TextYAlignment.Center
	t.TextTruncate = Enum.TextTruncate.AtEnd
	t.Parent = parent
	return t
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YupisotesUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = guiParent

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(580, 380)
main.BackgroundColor3 = palette.bg
main.BackgroundTransparency = 0.06
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 4)
stroke(main, palette.stroke2, 0.2, 1)

local fade = Instance.new("UIGradient")
fade.Rotation = 0
fade.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, rgb(9, 8, 12)),
	ColorSequenceKeypoint.new(0.55, rgb(3, 10, 7)),
	ColorSequenceKeypoint.new(1, rgb(3, 7, 6)),
})
fade.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.55, 0.08),
	NumberSequenceKeypoint.new(1, 0.15),
})
fade.Parent = main

local top = Instance.new("Frame")
top.Name = "TopBar"
top.BackgroundColor3 = rgb(3, 6, 5)
top.BackgroundTransparency = 0.18
top.BorderSizePixel = 0
top.Size = UDim2.new(1, 0, 0, 44)
top.Parent = main

local topLine = Instance.new("Frame")
topLine.BackgroundColor3 = palette.accent2
topLine.BackgroundTransparency = 0.2
topLine.BorderSizePixel = 0
topLine.Position = UDim2.new(0, 0, 1, -1)
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.Parent = top

local logo = label(top, "W", 24, palette.accent, true)
logo.Position = UDim2.fromOffset(20, 0)
logo.Size = UDim2.fromOffset(24, 44)

local discordPill = Instance.new("Frame")
discordPill.BackgroundColor3 = rgb(23, 18, 34)
discordPill.BorderSizePixel = 0
discordPill.Position = UDim2.fromOffset(52, 12)
discordPill.Size = UDim2.fromOffset(166, 25)
discordPill.Parent = top
corner(discordPill, 12)
stroke(discordPill, palette.accent, 0.25, 1)

local discordIcon = label(discordPill, "dc", 11, rgb(181, 185, 255), true)
discordIcon.Position = UDim2.fromOffset(12, 0)
discordIcon.Size = UDim2.fromOffset(24, 25)

local discordText = label(discordPill, "Yupisotes", 13, palette.text, true)
discordText.Position = UDim2.fromOffset(37, 0)
discordText.Size = UDim2.new(1, -45, 1, 0)

local minimize = Instance.new("TextButton")
minimize.BackgroundTransparency = 1
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = palette.text
minimize.Position = UDim2.new(1, -58, 0, 9)
minimize.Size = UDim2.fromOffset(24, 24)
minimize.Parent = top

local close = Instance.new("TextButton")
close.BackgroundTransparency = 1
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 15
close.TextColor3 = palette.text
close.Position = UDim2.new(1, -30, 0, 9)
close.Size = UDim2.fromOffset(24, 24)
close.Parent = top
close.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local body = Instance.new("Frame")
body.BackgroundTransparency = 1
body.Position = UDim2.fromOffset(12, 56)
body.Size = UDim2.new(1, -24, 1, -68)
body.Parent = main

local sidebar = Instance.new("Frame")
sidebar.BackgroundTransparency = 1
sidebar.Size = UDim2.fromOffset(134, 312)
sidebar.Parent = body

local search = Instance.new("Frame")
search.BackgroundColor3 = rgb(18, 19, 28)
search.BorderSizePixel = 0
search.Position = UDim2.fromOffset(0, 0)
search.Size = UDim2.fromOffset(126, 28)
search.Parent = sidebar
corner(search, 5)
stroke(search, rgb(68, 52, 92), 0.15, 1)

local searchText = label(search, "Q Search", 12, rgb(159, 160, 170), true)
searchText.Position = UDim2.fromOffset(11, 0)
searchText.Size = UDim2.new(1, -18, 1, 0)

local menu = Instance.new("Frame")
menu.BackgroundTransparency = 1
menu.Position = UDim2.fromOffset(0, 35)
menu.Size = UDim2.fromOffset(126, 260)
menu.Parent = sidebar

local menuLayout = Instance.new("UIListLayout")
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0, 4)
menuLayout.Parent = menu

local tabs = {
	{"Info", "i", true},
	{"Farm", ">", false},
	{"Shop", "#", false},
	{"Pet", "*", false},
	{"Misc", "+", false},
	{"Visual", "o", false},
	{"Exclusive", "%", false},
	{"Config", "@", false},
}

local tabRefs = {}

local function makeTab(index, name, icon, active)
	local tab = Instance.new("TextButton")
	tab.Name = name .. "Tab"
	tab.AutoButtonColor = false
	tab.Text = ""
	tab.BackgroundColor3 = active and rgb(50, 20, 73) or palette.side
	tab.BackgroundTransparency = active and 0 or 1
	tab.BorderSizePixel = 0
	tab.Size = UDim2.fromOffset(126, 30)
	tab.LayoutOrder = index
	tab.Parent = menu
	corner(tab, 4)

	local bar = Instance.new("Frame")
	bar.BackgroundColor3 = palette.accent
	bar.BorderSizePixel = 0
	bar.Position = UDim2.fromOffset(0, 6)
	bar.Size = UDim2.fromOffset(5, 18)
	bar.Visible = active
	bar.Parent = tab
	corner(bar, 3)

	local iconLabel = label(tab, icon, 15, active and rgb(221, 154, 255) or rgb(110, 111, 119), true)
	iconLabel.Position = UDim2.fromOffset(14, 0)
	iconLabel.Size = UDim2.fromOffset(18, 30)
	iconLabel.TextXAlignment = Enum.TextXAlignment.Center

	local tabLabel = label(tab, name, 13, active and palette.text or rgb(188, 188, 195), true)
	tabLabel.Position = UDim2.fromOffset(40, 0)
	tabLabel.Size = UDim2.new(1, -44, 1, 0)

	tab.MouseEnter:Connect(function()
		if not tab:GetAttribute("Active") then
			TweenService:Create(tab, TweenInfo.new(0.12), {BackgroundTransparency = 0.25, BackgroundColor3 = rgb(22, 24, 30)}):Play()
		end
	end)
	tab.MouseLeave:Connect(function()
		if not tab:GetAttribute("Active") then
			TweenService:Create(tab, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
		end
	end)

	tab:SetAttribute("Active", active)
	tabRefs[name] = {
		button = tab,
		bar = bar,
		icon = iconLabel,
		text = tabLabel,
	}
end

for index, item in ipairs(tabs) do
	makeTab(index, item[1], item[2], item[3])
end

local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(146, 0)
content.Size = UDim2.new(1, -146, 1, 0)
content.Parent = body

local title = label(content, "Info", 22, palette.text, true)
title.Position = UDim2.fromOffset(0, 1)
title.Size = UDim2.new(1, 0, 0, 30)

local section = Instance.new("TextButton")
section.Name = "AutoPlantHeader"
section.AutoButtonColor = false
section.Text = ""
section.BackgroundColor3 = palette.card
section.BorderSizePixel = 0
section.Position = UDim2.fromOffset(0, 34)
section.Size = UDim2.new(1, -2, 0, 31)
section.Parent = content
corner(section, 4)

local sectionText = label(section, "Information", 13, palette.text, true)
sectionText.Position = UDim2.fromOffset(10, 0)
sectionText.Size = UDim2.new(1, -40, 1, 0)

local arrow = label(section, "v", 14, rgb(210, 210, 216), true)
arrow.Position = UDim2.new(1, -28, 0, 0)
arrow.Size = UDim2.fromOffset(20, 31)
arrow.TextXAlignment = Enum.TextXAlignment.Center

local accentLine = Instance.new("Frame")
accentLine.BackgroundColor3 = palette.accent
accentLine.BorderSizePixel = 0
accentLine.Position = UDim2.fromOffset(0, 65)
accentLine.Size = UDim2.new(1, -2, 0, 2)
accentLine.Parent = content

local farmSectionAccent = Instance.new("Frame")
farmSectionAccent.BackgroundColor3 = palette.accent
farmSectionAccent.BorderSizePixel = 0
farmSectionAccent.Position = UDim2.new(0, 0, 1, -2)
farmSectionAccent.Size = UDim2.new(1, 0, 0, 2)
farmSectionAccent.Visible = false
farmSectionAccent.Parent = section

local list = Instance.new("ScrollingFrame")
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.fromOffset(0, 0)
list.ScrollBarImageColor3 = palette.accent
list.ScrollBarImageTransparency = 0.2
list.ScrollBarThickness = 3
list.ScrollingDirection = Enum.ScrollingDirection.Y
list.Position = UDim2.fromOffset(0, 73)
list.Size = UDim2.new(1, -2, 1, -74)
list.Parent = content

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 7)
listLayout.Parent = list

local function card(order, height, mainText, subText, buttonText)
	local c = Instance.new("Frame")
	c.BackgroundColor3 = palette.card
	c.BorderSizePixel = 0
	c.Size = UDim2.new(1, 0, 0, height)
	c.LayoutOrder = order
	c.Parent = list
	corner(c, 4)

	local topText = label(c, mainText, 13, palette.text, true)
	topText.Position = UDim2.fromOffset(10, subText and 7 or 0)
	topText.Size = UDim2.new(1, -20, 0, subText and 17 or height)

	if subText then
		local bottom = label(c, subText, 12, palette.muted, false)
		bottom.Position = UDim2.fromOffset(10, 22)
		bottom.Size = UDim2.new(1, -20, 0, 16)
	end

	if buttonText then
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.Text = buttonText
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.TextColor3 = palette.text
		btn.BackgroundColor3 = rgb(58, 62, 54)
		btn.BackgroundTransparency = 0.18
		btn.BorderSizePixel = 0
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.Parent = c
		corner(btn, 4)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = rgb(82, 86, 75)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = rgb(58, 62, 54)}):Play()
		end)
	end
end

local currentPage = "Info"
local selectedPlant = "All Seeds"
local selectedRarity = "None"
local selectedMethod = "Center Position"
local plantSpeed = 0
local autoPlantEnabled = false
local selectedHarvestPlant = "All Plant"
local harvestDelay = 1
local autoHarvestEnabled = false
local advancedHarvestEnabled = false
local selectedHarvestRarities = {}
local selectedHarvestMutations = {}
local harvestKg = 0
local harvestKgDirection = "Up"
local sellingMethod = "Timer (Min)"
local sellingInput = 1
local autoSellEnabled = false
local autoSellRunId = 0
local dailyDealMode = "Full Inventory"
local dailyDealCount = 100
local useDailyDeal = false
local dropdownOpen = false
local sectionConnection

local function clearList()
	for _, child in ipairs(list:GetChildren()) do
		if not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end
end

local function setActiveTab(name)
	for tabName, ref in pairs(tabRefs) do
		local active = tabName == name
		ref.button:SetAttribute("Active", active)
		ref.button.BackgroundColor3 = active and rgb(50, 20, 73) or palette.side
		ref.button.BackgroundTransparency = active and 0 or 1
		ref.bar.Visible = active
		ref.icon.TextColor3 = active and rgb(221, 154, 255) or rgb(110, 111, 119)
		ref.text.TextColor3 = active and palette.text or rgb(188, 188, 195)
	end
end

local function disconnectSection()
	if sectionConnection then
		sectionConnection:Disconnect()
		sectionConnection = nil
	end
end

local function showInfo()
	currentPage = "Info"
	dropdownOpen = false
	disconnectSection()
	section.Parent = content
	section.Position = UDim2.fromOffset(0, 34)
	section.Size = UDim2.new(1, -2, 0, 31)
	farmSectionAccent.Visible = false
	accentLine.Visible = true
	list.Position = UDim2.fromOffset(0, 73)
	list.Size = UDim2.new(1, -2, 1, -74)
	list.CanvasPosition = Vector2.new(0, 0)
	setActiveTab("Info")
	title.Text = "Info"
	sectionText.Text = "Information"
	arrow.Text = "v"
	arrow.Rotation = 0
	clearList()
	card(1, 44, "Yupisotes", "V 1.0")
	card(2, 44, "Yupisotes Community", "Support, updates and announcements.")
	card(3, 29, "", nil, "Copy Invite")
	card(4, 44, "Grow a Garden 2", "Easy farming, planting, shop buying and wild pet taming.")
end

local plantOptions = {
	"All Seeds",
	"Acorn",
	"Apple",
	"Baby Cactus",
	"Bamboo",
	"Banana",
	"Blueberry",
	"Briar Rose",
	"Cactus",
	"Carrot",
	"Cherry",
	"Coconut",
	"Corn",
	"Dragon Fruit",
	"Dragon's Breath",
	"Eclipse Bloom",
	"Fire Fern",
	"Ghost Pepper",
	"Glow Mushroom",
	"Gold",
	"Grape",
	"Green Bean",
	"Horned Melon",
	"Hypno Bloom",
	"Mango",
	"Mega",
	"Moon Bloom",
	"Mushroom",
	"Pineapple",
	"Poison Apple",
	"Poison Ivy",
	"Pomegranate",
	"Rainbow",
	"Rocket Pop",
	"Romanesco",
	"Star Fruit",
	"Strawberry",
	"Sun Bloom",
	"Sunflower",
	"Tomato",
	"Tulip",
	"Venom Spitter",
	"Venus Fly Trap",
}

local harvestPlantOptions = {"All Plant"}
for index = 2, #plantOptions do
	table.insert(harvestPlantOptions, plantOptions[index])
end

local rarityOptions = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Super",
	"Secret",
}

local methodOptions = {
	"Center Position",
	"Standing Position",
	"Random Position",
	"Follow Player",
}

local harvestMutationOptions = {
	"Normal",
	"Gold",
	"Rainbow",
	"Electric",
	"Frozen",
	"Bloodlit",
	"Chained",
	"Starstruck",
	"Aurora",
	"Ignited",
	"Glow",
	"Eclipsed",
}

local networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"))
local seedData = require(ReplicatedStorage.SharedModules:WaitForChild("SeedData"))
local seedRarities = {}
for _, data in pairs(seedData) do
	if type(data) == "table" and type(data.SeedName) == "string" then
		seedRarities[data.SeedName] = data.Rarity
	end
end

local autoPlantStep = 0
local autoPlantToolIndex = 0
local autoPlantRunId = 0
local autoPlantOrigin

local function getPlayerPlot()
	local gardens = workspace:FindFirstChild("Gardens")
	local plotId = player:GetAttribute("PlotId")
	return gardens and plotId and gardens:FindFirstChild("Plot" .. tostring(plotId)) or nil
end

local function getPlantAreas(plot)
	local areas = {}
	for _, area in ipairs(CollectionService:GetTagged("PlantArea")) do
		if area:IsA("BasePart") and area:IsDescendantOf(plot) then
			table.insert(areas, area)
		end
	end
	table.sort(areas, function(a, b)
		return a.Size.X * a.Size.Z > b.Size.X * b.Size.Z
	end)
	return areas
end

local function getMatchingSeedTools()
	local tools = {}
	local function scan(container)
		if not container then
			return
		end
		for _, item in ipairs(container:GetChildren()) do
			local seedName = item:GetAttribute("SeedTool")
			local count = item:GetAttribute("Count")
			if seedName and (not count or count > 0) then
				local matches = selectedRarity ~= "None"
					and seedRarities[seedName] == selectedRarity
					or selectedRarity == "None" and (selectedPlant == "All Seeds" or seedName == selectedPlant)
				if matches then
					table.insert(tools, item)
				end
			end
		end
	end
	scan(player:FindFirstChildOfClass("Backpack"))
	scan(player.Character)
	table.sort(tools, function(a, b)
		return tostring(a:GetAttribute("SeedTool")) < tostring(b:GetAttribute("SeedTool"))
	end)
	return tools
end

local function getPartPosition(item)
	if item:IsA("BasePart") then
		return item.Position
	end
	if item:IsA("Model") then
		return item:GetPivot().Position
	end
	local part = item:FindFirstChildWhichIsA("BasePart", true)
	return part and part.Position or nil
end

local function positionIsFree(plot, position)
	local plants = plot:FindFirstChild("Plants")
	if not plants then
		return true
	end
	for _, plant in ipairs(plants:GetChildren()) do
		local plantPosition = getPartPosition(plant)
		if plantPosition then
			local delta = Vector2.new(plantPosition.X - position.X, plantPosition.Z - position.Z)
			if delta.Magnitude < 2.4 then
				return false
			end
		end
	end
	return true
end

local function pointOnArea(area, worldPoint, offsetIndex)
	local localPoint = area.CFrame:PointToObjectSpace(worldPoint)
	local ring = math.floor(math.sqrt(offsetIndex))
	local angle = offsetIndex * 2.399963
	local radius = ring * 2.8
	localPoint += Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
	localPoint = Vector3.new(
		math.clamp(localPoint.X, -area.Size.X * 0.5 + 1, area.Size.X * 0.5 - 1),
		area.Size.Y * 0.5,
		math.clamp(localPoint.Z, -area.Size.Z * 0.5 + 1, area.Size.Z * 0.5 - 1)
	)
	return area.CFrame:PointToWorldSpace(localPoint)
end

local function nearestArea(areas, point)
	local nearest = areas[1]
	local nearestDistance = math.huge
	for _, area in ipairs(areas) do
		local localPoint = area.CFrame:PointToObjectSpace(point)
		local dx = math.max(math.abs(localPoint.X) - area.Size.X * 0.5, 0)
		local dz = math.max(math.abs(localPoint.Z) - area.Size.Z * 0.5, 0)
		local distance = dx * dx + dz * dz
		if distance < nearestDistance then
			nearest = area
			nearestDistance = distance
		end
	end
	return nearest
end

local function choosePlantPosition(plot, areas)
	for attempt = 1, 32 do
		autoPlantStep += 1
		local area
		local target
		if selectedMethod == "Random Position" then
			area = areas[math.random(1, math.min(#areas, 2))]
			local x = (math.random() - 0.5) * math.max(area.Size.X - 2, 1)
			local z = (math.random() - 0.5) * math.max(area.Size.Z - 2, 1)
			target = area.CFrame:PointToWorldSpace(Vector3.new(x, area.Size.Y * 0.5, z))
		elseif selectedMethod == "Standing Position" then
			target = autoPlantOrigin or (player.Character and player.Character:GetPivot().Position) or areas[1].Position
			area = nearestArea(areas, target)
			target = pointOnArea(area, target, autoPlantStep)
		elseif selectedMethod == "Follow Player" then
			target = (player.Character and player.Character:GetPivot().Position) or areas[1].Position
			area = nearestArea(areas, target)
			target = pointOnArea(area, target, attempt - 1)
		else
			area = areas[(autoPlantStep % math.min(#areas, 2)) + 1]
			target = pointOnArea(area, area.Position, autoPlantStep)
		end
		if target and positionIsFree(plot, target) then
			return target
		end
	end
	return nil
end

local function runAutoPlant(runId)
	local myGeneration = autoPlantGeneration
	task.spawn(function()
		while autoPlantEnabled and autoPlantRunId == runId and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
			local plot = getPlayerPlot()
			local areas = plot and getPlantAreas(plot) or {}
			local tools = getMatchingSeedTools()
			if plot and #areas > 0 and #tools > 0 then
				autoPlantToolIndex = autoPlantToolIndex % #tools + 1
				local tool = tools[autoPlantToolIndex]
				local seedName = tool:GetAttribute("SeedTool")
				local position = choosePlantPosition(plot, areas)
				local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if position and humanoid and seedName then
					humanoid:EquipTool(tool)
					task.wait(0.06)
					networking.Plant.PlantSeed:Fire(position, seedName, tool)
					screenGui:SetAttribute("LastPlantedSeed", seedName)
					screenGui:SetAttribute("LastPlantPosition", tostring(position))
				end
			else
				screenGui:SetAttribute("AutoPlantStatus", #tools == 0 and "No matching seeds" or "Plot unavailable")
			end
			task.wait(math.max(0.08, plantSpeed * 0.1))
		end
	end)
end

local autoHarvestRunId = 0

local function getHarvestSeedName(model)
	local current = model
	while current and current ~= workspace do
		local seedName = current:GetAttribute("SeedName")
		if type(seedName) == "string" then
			return seedName
		end
		current = current.Parent
	end
	return nil
end

local fruitBaseWeights = {}
local function getHarvestWeight(model, seedName)
	local coreName = model:GetAttribute("CorePartName") or seedName
	if not coreName and not seedName then
		return 0
	end
	local cacheKey = tostring(coreName) .. ":" .. tostring(seedName)
	local baseWeight = fruitBaseWeights[cacheKey]
	if baseWeight == nil then
		baseWeight = 0
		local generationModules = ReplicatedStorage:FindFirstChild("PlantGenerationModules")
		local candidates = {
			{"Fruits", coreName},
			{"Fruits", seedName},
			{"Plants", seedName},
			{"Plants", coreName},
		}
		for _, candidate in ipairs(candidates) do
			local folder = generationModules and generationModules:FindFirstChild(candidate[1])
			local module = folder and candidate[2] and folder:FindFirstChild(candidate[2])
			if module and module:IsA("ModuleScript") then
				local ok, data = pcall(require, module)
				local weight = ok and type(data) == "table" and data.GrowData
					and tonumber(data.GrowData.BaseWeight)
				if weight then
					baseWeight = weight
					break
				end
			end
		end
		fruitBaseWeights[cacheKey] = baseWeight
	end
	return baseWeight * (tonumber(model:GetAttribute("SizeMulti")) or 1)
end

local function selectionCount(selection)
	local count = 0
	for _, selected in pairs(selection) do
		if selected then
			count += 1
		end
	end
	return count
end

local function mutationMatchesFilter(mutationText)
	if selectionCount(selectedHarvestMutations) == 0 then
		return true
	end
	if type(mutationText) ~= "string" or mutationText == "" then
		return selectedHarvestMutations.Normal == true
	end
	for mutation in string.gmatch(mutationText, "[^%+%,]+") do
		mutation = string.gsub(mutation, "^%s*(.-)%s*$", "%1")
		if selectedHarvestMutations[mutation] then
			return true
		end
	end
	return false
end

local function getHarvestTargets(plot)
	local targets = {}
	local seen = {}
	for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
		if prompt:IsDescendantOf(plot) then
			local model = prompt:FindFirstAncestorWhichIsA("Model")
			local plantId = model and model:GetAttribute("PlantId")
			local fruitId = model and model:GetAttribute("FruitId") or ""
			local seedName = model and getHarvestSeedName(model)
			local allowed = selectedHarvestPlant == "All Plant" or seedName == selectedHarvestPlant
			if allowed and advancedHarvestEnabled and model then
				local rarity = seedRarities[seedName] or "Common"
				local weight = getHarvestWeight(model, seedName)
				local rarityAllowed = selectionCount(selectedHarvestRarities) == 0 or selectedHarvestRarities[rarity] == true
				local mutationAllowed = mutationMatchesFilter(model:GetAttribute("Mutation"))
				local weightAllowed
				if harvestKgDirection == "Up" then
					weightAllowed = weight >= harvestKg
				else
					weightAllowed = weight < harvestKg
				end
				allowed = rarityAllowed and mutationAllowed and weightAllowed
			end
			local key = plantId and (tostring(plantId) .. ":" .. tostring(fruitId)) or nil
			if key and allowed and not seen[key] then
				seen[key] = true
				table.insert(targets, {
					plantId = plantId,
					fruitId = fruitId,
					seedName = seedName or "Unknown",
					weight = model and getHarvestWeight(model, seedName) or 0,
				})
			end
		end
	end
	return targets
end

local function runAutoHarvest(runId)
	local myGeneration = autoPlantGeneration
	task.spawn(function()
		while autoHarvestEnabled and autoHarvestRunId == runId and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
			local plot = getPlayerPlot()
			local targets = plot and getHarvestTargets(plot) or {}
			local harvested = 0
			for _, target in ipairs(targets) do
				if not autoHarvestEnabled or autoHarvestRunId ~= runId then
					break
				end
				networking.Garden.CollectFruit:Fire(target.plantId, target.fruitId)
				harvested += 1
				screenGui:SetAttribute("LastHarvestedPlant", target.seedName)
				task.wait(0.03)
			end
			if not autoHarvestEnabled or autoHarvestRunId ~= runId then
				break
			end
			screenGui:SetAttribute("LastHarvestCount", harvested)
			screenGui:SetAttribute("AutoHarvestStatus", #targets > 0 and "Running" or "Waiting for ready crops")
			task.wait(math.max(0.08, harvestDelay))
		end
	end)
end

local function previewSellInventory()
	local ok, result = pcall(function()
		return networking.NPCS.PreviewSellAll:Fire()
	end)
	if not ok or type(result) ~= "table" then
		return 0, nil
	end
	return tonumber(result.FruitCount) or 0, result
end

local function sellInventory()
	local fruitCount = previewSellInventory()
	if fruitCount <= 0 then
		screenGui:SetAttribute("AutoSellStatus", "Backpack empty")
		return false
	end
	local ok, result = pcall(function()
		return networking.NPCS.SellAll:Fire()
	end)
	local success = ok and type(result) == "table" and result.Success == true
	screenGui:SetAttribute("LastAutoSellCount", success and fruitCount or 0)
	screenGui:SetAttribute("AutoSellStatus", success and "Sold" or "Sale failed")
	return success
end

local function checkDailyDeal()
	local ok, result = pcall(function()
		return networking.NPCS.CheckDailyDeal:Fire()
	end)
	if not ok or type(result) ~= "table" then
		return false, nil
	end
	screenGui:SetAttribute("DailyDealTimeRemaining", tonumber(result.TimeRemaining) or 0)
	return result.Available == true, result
end

local function sellDailyDeal(fruitCount)
	local ok, result = pcall(function()
		return networking.NPCS.UseDailyDealAll:Fire()
	end)
	local success = ok and type(result) == "table" and result.Success == true
	screenGui:SetAttribute("LastDailyDealCount", success and (tonumber(result.SoldCount) or fruitCount) or 0)
	screenGui:SetAttribute("LastDailyDealPrice", success and (tonumber(result.SellPrice) or 0) or 0)
	screenGui:SetAttribute("DailyDealStatus", success and "Daily deal sold" or "Daily deal failed")
	return success
end

local function runAutoSell(runId)
	local myGeneration = autoPlantGeneration
	local lastSaleAt = os.clock()
	task.spawn(function()
		while autoSellEnabled and autoSellRunId == runId
			and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
			local shouldSell = false
			local dailyDealAvailable = false
			local fruitCount = 0
			if useDailyDeal then
				dailyDealAvailable = checkDailyDeal()
			end

			if useDailyDeal and dailyDealAvailable then
				fruitCount = previewSellInventory()
				local requiredCount = dailyDealMode == "Full Inventory"
					and (tonumber(player:GetAttribute("MaxFruitCapacity")) or 100) or dailyDealCount
				screenGui:SetAttribute("DailyDealBackpackCount", fruitCount)
				screenGui:SetAttribute("DailyDealRequiredCount", requiredCount)
				if fruitCount >= requiredCount then
					if sellDailyDeal(fruitCount) then
						lastSaleAt = os.clock()
					end
				else
					screenGui:SetAttribute("DailyDealStatus", "Waiting for " .. tostring(requiredCount) .. " fruits")
				end
			else
				if useDailyDeal then
					screenGui:SetAttribute("DailyDealStatus", "Cooldown")
				end
				if sellingMethod == "Timer (Min)" then
					shouldSell = os.clock() - lastSaleAt >= sellingInput * 60
				elseif sellingMethod == "Timer (Sec)" then
					shouldSell = os.clock() - lastSaleAt >= sellingInput
				else
					fruitCount = previewSellInventory()
					shouldSell = fruitCount >= sellingInput
					screenGui:SetAttribute("AutoSellBackpackCount", fruitCount)
				end
			end

			if shouldSell then
				sellInventory()
				lastSaleAt = os.clock()
			end
			task.wait(1)
		end
	end)
end

local function showFarm()
	currentPage = "Farm"
	dropdownOpen = false
	disconnectSection()
	setActiveTab("Farm")
	title.Text = "Farm"
	sectionText.Text = "Auto Plant"
	arrow.Text = "v"
	arrow.Rotation = 0
	section.Parent = content
	clearList()
	accentLine.Visible = false
	farmSectionAccent.Visible = true
	list.Position = UDim2.fromOffset(0, 34)
	list.Size = UDim2.new(1, -2, 1, -35)
	list.CanvasPosition = Vector2.new(0, 0)
	section.Parent = list
	section.Position = UDim2.fromOffset(0, 0)
	section.Size = UDim2.new(1, 0, 0, 31)
	section.LayoutOrder = 0

	local categoryContent = Instance.new("Frame")
	categoryContent.Name = "AutoPlantContent"
	categoryContent.BackgroundTransparency = 1
	categoryContent.BorderSizePixel = 0
	categoryContent.ClipsDescendants = true
	categoryContent.Size = UDim2.new(1, 0, 0, 0)
	categoryContent.LayoutOrder = 1
	categoryContent.Parent = list

	local seedRow = Instance.new("Frame")
	seedRow.Name = "SeedSelectedRow"
	seedRow.BackgroundColor3 = palette.card
	seedRow.BorderSizePixel = 0
	seedRow.Size = UDim2.new(1, 0, 0, 48)
	seedRow.Parent = categoryContent
	corner(seedRow, 4)

	local seedTitle = label(seedRow, "Seed Selected", 12, palette.text, true)
	seedTitle.Position = UDim2.fromOffset(10, 5)
	seedTitle.Size = UDim2.new(0.56, -10, 0, 18)

	local seedDescription = label(seedRow, "Choose which seed to plant.", 11, palette.muted, false)
	seedDescription.Position = UDim2.fromOffset(10, 22)
	seedDescription.Size = UDim2.new(0.58, -10, 0, 17)

	local selectButton = Instance.new("TextButton")
	selectButton.Name = "SeedSelectButton"
	selectButton.AutoButtonColor = false
	selectButton.Text = selectedPlant == "All Seeds" and "Select Options" or selectedPlant
	selectButton.Font = Enum.Font.GothamMedium
	selectButton.TextSize = 11
	selectButton.TextColor3 = selectedPlant == "All Seeds" and palette.muted or palette.text
	selectButton.TextXAlignment = Enum.TextXAlignment.Left
	selectButton.BackgroundColor3 = rgb(35, 27, 48)
	selectButton.BorderSizePixel = 0
	selectButton.Position = UDim2.new(0.62, 0, 0, 7)
	selectButton.Size = UDim2.new(0.38, -7, 0, 34)
	selectButton.Parent = seedRow
	corner(selectButton, 4)

	local selectPadding = Instance.new("UIPadding")
	selectPadding.PaddingLeft = UDim.new(0, 10)
	selectPadding.PaddingRight = UDim.new(0, 30)
	selectPadding.Parent = selectButton

	local selectArrow = label(selectButton, "v", 13, rgb(210, 210, 216), true)
	selectArrow.Position = UDim2.new(1, 3, 0, 0)
	selectArrow.Size = UDim2.fromOffset(20, 34)
	selectArrow.TextXAlignment = Enum.TextXAlignment.Center

	local rarityRow = Instance.new("Frame")
	rarityRow.Name = "PlantByRarityRow"
	rarityRow.BackgroundColor3 = palette.card
	rarityRow.BorderSizePixel = 0
	rarityRow.Position = UDim2.fromOffset(0, 54)
	rarityRow.Size = UDim2.new(1, 0, 0, 58)
	rarityRow.Parent = categoryContent
	corner(rarityRow, 4)

	local rarityTitle = label(rarityRow, "Plant By Rarity (Dont use Seed Selected if use this)", 11, palette.text, true)
	rarityTitle.Position = UDim2.fromOffset(10, 4)
	rarityTitle.Size = UDim2.new(0.61, -10, 0, 28)
	rarityTitle.TextWrapped = true
	rarityTitle.TextYAlignment = Enum.TextYAlignment.Top

	local rarityDescription = label(rarityRow, "Plant seeds from these rarities instead of one seed name.", 10, palette.muted, false)
	rarityDescription.Position = UDim2.fromOffset(10, 34)
	rarityDescription.Size = UDim2.new(0.61, -10, 0, 18)

	local rarityButton = Instance.new("TextButton")
	rarityButton.Name = "RaritySelectButton"
	rarityButton.AutoButtonColor = false
	rarityButton.Text = selectedRarity == "None" and "Select Options" or selectedRarity
	rarityButton.Font = Enum.Font.GothamMedium
	rarityButton.TextSize = 11
	rarityButton.TextColor3 = selectedRarity == "None" and palette.muted or palette.text
	rarityButton.TextXAlignment = Enum.TextXAlignment.Left
	rarityButton.BackgroundColor3 = rgb(35, 27, 48)
	rarityButton.BorderSizePixel = 0
	rarityButton.Position = UDim2.new(0.62, 0, 0, 12)
	rarityButton.Size = UDim2.new(0.38, -7, 0, 34)
	rarityButton.Parent = rarityRow
	corner(rarityButton, 4)

	local rarityPadding = Instance.new("UIPadding")
	rarityPadding.PaddingLeft = UDim.new(0, 10)
	rarityPadding.PaddingRight = UDim.new(0, 30)
	rarityPadding.Parent = rarityButton

	local rarityArrow = label(rarityButton, "v", 13, rgb(210, 210, 216), true)
	rarityArrow.Position = UDim2.new(1, 3, 0, 0)
	rarityArrow.Size = UDim2.fromOffset(20, 34)
	rarityArrow.TextXAlignment = Enum.TextXAlignment.Center

	local methodRow = Instance.new("Frame")
	methodRow.Name = "PlantMethodRow"
	methodRow.BackgroundColor3 = palette.card
	methodRow.BorderSizePixel = 0
	methodRow.Position = UDim2.fromOffset(0, 118)
	methodRow.Size = UDim2.new(1, 0, 0, 48)
	methodRow.Parent = categoryContent
	corner(methodRow, 4)

	local methodTitle = label(methodRow, "Plant Method", 12, palette.text, true)
	methodTitle.Position = UDim2.fromOffset(10, 5)
	methodTitle.Size = UDim2.new(0.61, -10, 0, 18)

	local methodDescription = label(methodRow, "Choose where each seed will be planted.", 10, palette.muted, false)
	methodDescription.Position = UDim2.fromOffset(10, 22)
	methodDescription.Size = UDim2.new(0.61, -10, 0, 17)

	local methodButton = Instance.new("TextButton")
	methodButton.Name = "PlantMethodButton"
	methodButton.AutoButtonColor = false
	methodButton.Text = selectedMethod
	methodButton.Font = Enum.Font.GothamMedium
	methodButton.TextSize = 11
	methodButton.TextColor3 = palette.text
	methodButton.TextXAlignment = Enum.TextXAlignment.Left
	methodButton.BackgroundColor3 = rgb(35, 27, 48)
	methodButton.BorderSizePixel = 0
	methodButton.Position = UDim2.new(0.62, 0, 0, 7)
	methodButton.Size = UDim2.new(0.38, -7, 0, 34)
	methodButton.Parent = methodRow
	corner(methodButton, 4)

	local methodPadding = Instance.new("UIPadding")
	methodPadding.PaddingLeft = UDim.new(0, 10)
	methodPadding.PaddingRight = UDim.new(0, 30)
	methodPadding.Parent = methodButton

	local methodArrow = label(methodButton, "v", 13, rgb(210, 210, 216), true)
	methodArrow.Position = UDim2.new(1, 3, 0, 0)
	methodArrow.Size = UDim2.fromOffset(20, 34)
	methodArrow.TextXAlignment = Enum.TextXAlignment.Center

	local speedRow = Instance.new("Frame")
	speedRow.Name = "PlantSpeedRow"
	speedRow.BackgroundColor3 = palette.card
	speedRow.BorderSizePixel = 0
	speedRow.Position = UDim2.fromOffset(0, 172)
	speedRow.Size = UDim2.new(1, 0, 0, 42)
	speedRow.Parent = categoryContent
	corner(speedRow, 4)

	local speedTitle = label(speedRow, "Plant Speed", 12, palette.text, true)
	speedTitle.Position = UDim2.fromOffset(10, 3)
	speedTitle.Size = UDim2.new(0.61, -10, 0, 18)

	local speedDescription = label(speedRow, "Set 0 for turbo speed (no extra delay).", 10, palette.muted, false)
	speedDescription.Position = UDim2.fromOffset(10, 20)
	speedDescription.Size = UDim2.new(0.61, -10, 0, 16)

	local speedValue = label(speedRow, tostring(plantSpeed), 11, palette.text, true)
	speedValue.Name = "PlantSpeedValue"
	speedValue.BackgroundColor3 = rgb(35, 27, 48)
	speedValue.BackgroundTransparency = 0
	speedValue.BorderSizePixel = 0
	speedValue.Position = UDim2.new(0.62, 0, 0, 11)
	speedValue.Size = UDim2.fromOffset(32, 20)
	speedValue.TextXAlignment = Enum.TextXAlignment.Center
	corner(speedValue, 4)
	stroke(speedValue, palette.accent, 0.05, 1)

	local speedTrack = Instance.new("Frame")
	speedTrack.Name = "PlantSpeedSlider"
	speedTrack.Active = true
	speedTrack.BackgroundColor3 = rgb(62, 63, 72)
	speedTrack.BorderSizePixel = 0
	speedTrack.Position = UDim2.new(0.62, 40, 0, 19)
	speedTrack.Size = UDim2.new(0.38, -55, 0, 4)
	speedTrack.Parent = speedRow
	corner(speedTrack, 3)

	local speedFill = Instance.new("Frame")
	speedFill.BackgroundColor3 = palette.accent
	speedFill.BorderSizePixel = 0
	speedFill.Size = UDim2.new(plantSpeed / 10, 0, 1, 0)
	speedFill.Parent = speedTrack
	corner(speedFill, 3)

	local speedKnob = Instance.new("Frame")
	speedKnob.BackgroundColor3 = palette.accent
	speedKnob.BorderSizePixel = 0
	speedKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	speedKnob.Position = UDim2.new(plantSpeed / 10, 0, 0.5, 0)
	speedKnob.Size = UDim2.fromOffset(10, 10)
	speedKnob.Parent = speedTrack
	corner(speedKnob, 5)

	local startRow = Instance.new("Frame")
	startRow.Name = "StartPlantRow"
	startRow.BackgroundColor3 = palette.card
	startRow.BorderSizePixel = 0
	startRow.Position = UDim2.fromOffset(0, 220)
	startRow.Size = UDim2.new(1, 0, 0, 48)
	startRow.Parent = categoryContent
	corner(startRow, 4)

	local startTitle = label(startRow, "Start Plant", 12, palette.text, true)
	startTitle.Position = UDim2.fromOffset(10, 5)
	startTitle.Size = UDim2.new(0.75, -10, 0, 18)

	local startDescription = label(startRow, "Automatically plants your selected seeds.", 10, palette.muted, false)
	startDescription.Position = UDim2.fromOffset(10, 22)
	startDescription.Size = UDim2.new(0.75, -10, 0, 17)

	local startToggle = Instance.new("TextButton")
	startToggle.Name = "StartPlantToggle"
	startToggle.AutoButtonColor = false
	startToggle.Text = ""
	startToggle.BackgroundColor3 = autoPlantEnabled and palette.accent or rgb(48, 46, 58)
	startToggle.BorderSizePixel = 0
	startToggle.Position = UDim2.new(1, -50, 0.5, -11)
	startToggle.Size = UDim2.fromOffset(38, 22)
	startToggle.Parent = startRow
	corner(startToggle, 11)
	stroke(startToggle, rgb(116, 70, 152), autoPlantEnabled and 0.15 or 0.45, 1)

	local toggleKnob = Instance.new("Frame")
	toggleKnob.BackgroundColor3 = rgb(239, 239, 243)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.Position = autoPlantEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
	toggleKnob.Size = UDim2.fromOffset(16, 16)
	toggleKnob.Parent = startToggle
	corner(toggleKnob, 8)

	local optionsPanel = Instance.new("ScrollingFrame")
	optionsPanel.Name = "SeedOptionsDropdown"
	optionsPanel.BackgroundColor3 = palette.card
	optionsPanel.BorderSizePixel = 0
	optionsPanel.ClipsDescendants = true
	optionsPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
	optionsPanel.CanvasSize = UDim2.fromOffset(0, 0)
	optionsPanel.ScrollBarImageColor3 = palette.accent
	optionsPanel.ScrollBarImageTransparency = 0.15
	optionsPanel.ScrollBarThickness = 3
	optionsPanel.ScrollingDirection = Enum.ScrollingDirection.Y
	optionsPanel.ZIndex = 20
	optionsPanel.Position = UDim2.new(0.62, 0, 0, 45)
	optionsPanel.Size = UDim2.new(0.38, -7, 0, 0)
	optionsPanel.Parent = categoryContent
	corner(optionsPanel, 4)
	stroke(optionsPanel, rgb(68, 52, 92), 0.25, 1)

	local optionLayout = Instance.new("UIListLayout")
	optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
	optionLayout.Padding = UDim.new(0, 2)
	optionLayout.Parent = optionsPanel

	local rarityPanel = Instance.new("Frame")
	rarityPanel.Name = "RarityOptionsDropdown"
	rarityPanel.BackgroundColor3 = palette.card
	rarityPanel.BorderSizePixel = 0
	rarityPanel.ClipsDescendants = true
	rarityPanel.Position = UDim2.new(0.62, 0, 0, 99)
	rarityPanel.Size = UDim2.new(0.38, -7, 0, 0)
	rarityPanel.ZIndex = 30
	rarityPanel.Parent = categoryContent
	corner(rarityPanel, 4)
	stroke(rarityPanel, rgb(68, 52, 92), 0.25, 1)

	local raritySearch = Instance.new("TextBox")
	raritySearch.Name = "RaritySearch"
	raritySearch.ClearTextOnFocus = false
	raritySearch.PlaceholderText = "Search"
	raritySearch.Text = ""
	raritySearch.Font = Enum.Font.GothamMedium
	raritySearch.TextSize = 11
	raritySearch.TextColor3 = palette.text
	raritySearch.PlaceholderColor3 = palette.muted
	raritySearch.BackgroundColor3 = rgb(35, 27, 48)
	raritySearch.BorderSizePixel = 0
	raritySearch.Position = UDim2.fromOffset(4, 4)
	raritySearch.Size = UDim2.new(1, -8, 0, 26)
	raritySearch.ZIndex = 31
	raritySearch.Parent = rarityPanel
	corner(raritySearch, 3)

	local rarityList = Instance.new("ScrollingFrame")
	rarityList.Name = "RarityList"
	rarityList.BackgroundTransparency = 1
	rarityList.BorderSizePixel = 0
	rarityList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	rarityList.CanvasSize = UDim2.fromOffset(0, 0)
	rarityList.ScrollBarImageColor3 = palette.accent
	rarityList.ScrollBarImageTransparency = 0.15
	rarityList.ScrollBarThickness = 3
	rarityList.ScrollingDirection = Enum.ScrollingDirection.Y
	rarityList.Position = UDim2.fromOffset(4, 34)
	rarityList.Size = UDim2.new(1, -8, 1, -38)
	rarityList.ZIndex = 31
	rarityList.Parent = rarityPanel

	local rarityLayout = Instance.new("UIListLayout")
	rarityLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rarityLayout.Padding = UDim.new(0, 2)
	rarityLayout.Parent = rarityList

	local methodPanel = Instance.new("Frame")
	methodPanel.Name = "PlantMethodDropdown"
	methodPanel.BackgroundColor3 = palette.card
	methodPanel.BorderSizePixel = 0
	methodPanel.ClipsDescendants = true
	methodPanel.Position = UDim2.new(0.62, 0, 0, 159)
	methodPanel.Size = UDim2.new(0.38, -7, 0, 0)
	methodPanel.ZIndex = 40
	methodPanel.Parent = categoryContent
	corner(methodPanel, 4)
	stroke(methodPanel, rgb(68, 52, 92), 0.2, 1)

	local methodSearch = Instance.new("TextBox")
	methodSearch.Name = "MethodSearch"
	methodSearch.ClearTextOnFocus = false
	methodSearch.PlaceholderText = "Search"
	methodSearch.Text = ""
	methodSearch.Font = Enum.Font.GothamMedium
	methodSearch.TextSize = 11
	methodSearch.TextColor3 = palette.text
	methodSearch.PlaceholderColor3 = palette.muted
	methodSearch.BackgroundColor3 = rgb(35, 27, 48)
	methodSearch.BorderSizePixel = 0
	methodSearch.Position = UDim2.fromOffset(4, 4)
	methodSearch.Size = UDim2.new(1, -8, 0, 26)
	methodSearch.ZIndex = 41
	methodSearch.Parent = methodPanel
	corner(methodSearch, 3)

	local methodList = Instance.new("ScrollingFrame")
	methodList.Name = "MethodList"
	methodList.BackgroundTransparency = 1
	methodList.BorderSizePixel = 0
	methodList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	methodList.CanvasSize = UDim2.fromOffset(0, 0)
	methodList.ScrollBarImageColor3 = palette.accent
	methodList.ScrollBarImageTransparency = 0.15
	methodList.ScrollBarThickness = 3
	methodList.ScrollingDirection = Enum.ScrollingDirection.Y
	methodList.Position = UDim2.fromOffset(4, 34)
	methodList.Size = UDim2.new(1, -8, 1, -38)
	methodList.ZIndex = 41
	methodList.Parent = methodPanel

	local methodLayout = Instance.new("UIListLayout")
	methodLayout.SortOrder = Enum.SortOrder.LayoutOrder
	methodLayout.Padding = UDim.new(0, 2)
	methodLayout.Parent = methodList

	local optionsOpen = false
	local rarityOpen = false
	local methodOpen = false
	local categoryBaseHeight = 268
	local fullOptionsHeight = #plantOptions * 28 + (#plantOptions - 1) * 2
	local optionsHeight = math.min(fullOptionsHeight, 178)
	local rarityPanelHeight = 140
	local methodPanelHeight = 148
	local setRarityOpen
	local setMethodOpen
	local function setOptionsOpen(open)
		if open and rarityOpen and setRarityOpen then
			setRarityOpen(false)
		end
		if open and methodOpen and setMethodOpen then
			setMethodOpen(false)
		end
		optionsOpen = open
		TweenService:Create(optionsPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and optionsHeight or 0),
		}):Play()
		TweenService:Create(categoryContent, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, open and math.max(categoryBaseHeight, optionsHeight + 45) or categoryBaseHeight),
		}):Play()
		TweenService:Create(selectArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
	end

	setRarityOpen = function(open)
		if open and optionsOpen then
			setOptionsOpen(false)
		end
		if open and methodOpen and setMethodOpen then
			setMethodOpen(false)
		end
		rarityOpen = open
		TweenService:Create(rarityPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and rarityPanelHeight or 0),
		}):Play()
		TweenService:Create(categoryContent, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, open and math.max(categoryBaseHeight, rarityPanelHeight + 99) or categoryBaseHeight),
		}):Play()
		TweenService:Create(rarityArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
		if open then
			task.defer(function()
				raritySearch:CaptureFocus()
			end)
		end
	end

	setMethodOpen = function(open)
		if open and optionsOpen then
			setOptionsOpen(false)
		end
		if open and rarityOpen then
			setRarityOpen(false)
		end
		methodOpen = open
		TweenService:Create(methodPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and methodPanelHeight or 0),
		}):Play()
		TweenService:Create(categoryContent, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, open and math.max(categoryBaseHeight, methodPanelHeight + 159) or categoryBaseHeight),
		}):Play()
		TweenService:Create(methodArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
		if open then
			task.defer(function()
				methodSearch:CaptureFocus()
			end)
		end
	end

	local rarityButtons = {}
	for index, plantName in ipairs(plantOptions) do
		local option = Instance.new("TextButton")
		option.Name = plantName:gsub("%s+", "") .. "Option"
		option.AutoButtonColor = false
		option.Text = plantName
		option.Font = Enum.Font.GothamMedium
		option.TextSize = 12
		option.TextColor3 = plantName == selectedPlant and rgb(221, 154, 255) or palette.text
		option.TextXAlignment = Enum.TextXAlignment.Left
		option.BackgroundColor3 = plantName == selectedPlant and rgb(48, 28, 64) or rgb(17, 18, 24)
		option.BackgroundTransparency = plantName == selectedPlant and 0.1 or 0.35
		option.BorderSizePixel = 0
		option.Size = UDim2.new(1, 0, 0, 28)
		option.LayoutOrder = index
		option.ZIndex = 21
		option.Parent = optionsPanel
		corner(option, 3)

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 12)
		padding.Parent = option

		option.MouseButton1Click:Connect(function()
			selectedPlant = plantName
			selectedRarity = "None"
			selectButton.Text = plantName
			selectButton.TextColor3 = palette.text
			rarityButton.Text = "Select Options"
			rarityButton.TextColor3 = palette.muted
			for _, rarityOption in ipairs(rarityButtons) do
				rarityOption.TextColor3 = palette.text
				rarityOption.BackgroundColor3 = rgb(17, 18, 24)
				rarityOption.BackgroundTransparency = 0.35
			end
			for _, sibling in ipairs(optionsPanel:GetChildren()) do
				if sibling:IsA("TextButton") then
					local selected = sibling == option
					sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
					sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
					sibling.BackgroundTransparency = selected and 0.1 or 0.35
				end
			end
			setOptionsOpen(false)
		end)
	end

	for index, rarityName in ipairs(rarityOptions) do
		local rarityOption = Instance.new("TextButton")
		rarityOption.Name = rarityName .. "RarityOption"
		rarityOption.AutoButtonColor = false
		rarityOption.Text = rarityName
		rarityOption.Font = Enum.Font.GothamMedium
		rarityOption.TextSize = 11
		rarityOption.TextColor3 = rarityName == selectedRarity and rgb(221, 154, 255) or palette.text
		rarityOption.TextXAlignment = Enum.TextXAlignment.Left
		rarityOption.BackgroundColor3 = rarityName == selectedRarity and rgb(48, 28, 64) or rgb(17, 18, 24)
		rarityOption.BackgroundTransparency = rarityName == selectedRarity and 0.1 or 0.35
		rarityOption.BorderSizePixel = 0
		rarityOption.Size = UDim2.new(1, 0, 0, 26)
		rarityOption.LayoutOrder = index
		rarityOption.ZIndex = 32
		rarityOption.Parent = rarityList
		corner(rarityOption, 3)

		local rarityOptionPadding = Instance.new("UIPadding")
		rarityOptionPadding.PaddingLeft = UDim.new(0, 10)
		rarityOptionPadding.Parent = rarityOption

		table.insert(rarityButtons, rarityOption)
		rarityOption.MouseButton1Click:Connect(function()
			selectedRarity = rarityName
			selectedPlant = "All Seeds"
			rarityButton.Text = rarityName
			rarityButton.TextColor3 = palette.text
			selectButton.Text = "Select Options"
			selectButton.TextColor3 = palette.muted
			for _, plantOption in ipairs(optionsPanel:GetChildren()) do
				if plantOption:IsA("TextButton") then
					local selected = plantOption.Text == "All Seeds"
					plantOption.TextColor3 = selected and rgb(221, 154, 255) or palette.text
					plantOption.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
					plantOption.BackgroundTransparency = selected and 0.1 or 0.35
				end
			end
			for _, sibling in ipairs(rarityButtons) do
				local selected = sibling == rarityOption
				sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				sibling.BackgroundTransparency = selected and 0.1 or 0.35
			end
			setRarityOpen(false)
		end)
	end

	raritySearch:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(raritySearch.Text)
		for _, rarityOption in ipairs(rarityButtons) do
			rarityOption.Visible = query == "" or string.find(string.lower(rarityOption.Text), query, 1, true) ~= nil
		end
	end)

	local methodButtons = {}
	for index, methodName in ipairs(methodOptions) do
		local methodOption = Instance.new("TextButton")
		methodOption.Name = methodName:gsub("%s+", "") .. "MethodOption"
		methodOption.AutoButtonColor = false
		methodOption.Text = methodName
		methodOption.Font = Enum.Font.GothamMedium
		methodOption.TextSize = 11
		methodOption.TextColor3 = methodName == selectedMethod and rgb(221, 154, 255) or palette.text
		methodOption.TextXAlignment = Enum.TextXAlignment.Left
		methodOption.BackgroundColor3 = methodName == selectedMethod and rgb(48, 28, 64) or rgb(17, 18, 24)
		methodOption.BackgroundTransparency = methodName == selectedMethod and 0.1 or 0.35
		methodOption.BorderSizePixel = 0
		methodOption.Size = UDim2.new(1, 0, 0, 26)
		methodOption.LayoutOrder = index
		methodOption.ZIndex = 42
		methodOption.Parent = methodList
		corner(methodOption, 3)

		local methodOptionPadding = Instance.new("UIPadding")
		methodOptionPadding.PaddingLeft = UDim.new(0, 10)
		methodOptionPadding.Parent = methodOption

		table.insert(methodButtons, methodOption)
		methodOption.MouseButton1Click:Connect(function()
			selectedMethod = methodName
			methodButton.Text = methodName
			for _, sibling in ipairs(methodButtons) do
				local selected = sibling == methodOption
				sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				sibling.BackgroundTransparency = selected and 0.1 or 0.35
			end
			setMethodOpen(false)
		end)
	end

	methodSearch:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(methodSearch.Text)
		for _, methodOption in ipairs(methodButtons) do
			methodOption.Visible = query == "" or string.find(string.lower(methodOption.Text), query, 1, true) ~= nil
		end
	end)

	local sliderDragging = false
	local function updatePlantSpeed(screenX)
		if speedTrack.AbsoluteSize.X <= 0 then
			return
		end
		local alpha = math.clamp((screenX - speedTrack.AbsolutePosition.X) / speedTrack.AbsoluteSize.X, 0, 1)
		plantSpeed = math.floor(alpha * 10 + 0.5)
		local snappedAlpha = plantSpeed / 10
		speedValue.Text = tostring(plantSpeed)
		speedFill.Size = UDim2.new(snappedAlpha, 0, 1, 0)
		speedKnob.Position = UDim2.new(snappedAlpha, 0, 0.5, 0)
		screenGui:SetAttribute("PlantSpeed", plantSpeed)
	end

	speedTrack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliderDragging = true
			updatePlantSpeed(input.Position.X)
		end
	end)

	local sliderInputConnection
	sliderInputConnection = UserInputService.InputChanged:Connect(function(input)
		if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updatePlantSpeed(input.Position.X)
		end
	end)

	local sliderEndedConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliderDragging = false
		end
	end)

	categoryContent.AncestryChanged:Connect(function(_, parent)
		if not parent and sliderInputConnection then
			sliderInputConnection:Disconnect()
			sliderInputConnection = nil
			if sliderEndedConnection then
				sliderEndedConnection:Disconnect()
				sliderEndedConnection = nil
			end
		end
	end)

	local function syncAutoPlantAttributes()
		screenGui:SetAttribute("AutoPlantEnabled", autoPlantEnabled)
		screenGui:SetAttribute("SelectedPlant", selectedPlant)
		screenGui:SetAttribute("SelectedRarity", selectedRarity)
		screenGui:SetAttribute("PlantMethod", selectedMethod)
		screenGui:SetAttribute("PlantSpeed", plantSpeed)
	end

	startToggle.MouseButton1Click:Connect(function()
		autoPlantEnabled = not autoPlantEnabled
		autoPlantRunId += 1
		if autoPlantEnabled then
			autoPlantOrigin = player.Character and player.Character:GetPivot().Position or nil
			screenGui:SetAttribute("AutoPlantStatus", "Running")
			runAutoPlant(autoPlantRunId)
		else
			screenGui:SetAttribute("AutoPlantStatus", "Stopped")
		end
		syncAutoPlantAttributes()
		TweenService:Create(startToggle, TweenInfo.new(0.18), {
			BackgroundColor3 = autoPlantEnabled and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(toggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = autoPlantEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end)

	syncAutoPlantAttributes()

	local harvestHeader = Instance.new("TextButton")
	harvestHeader.Name = "AutoHarvestHeader"
	harvestHeader.AutoButtonColor = false
	harvestHeader.Text = ""
	harvestHeader.BackgroundColor3 = palette.card
	harvestHeader.BorderSizePixel = 0
	harvestHeader.Size = UDim2.new(1, 0, 0, 31)
	harvestHeader.LayoutOrder = 2
	harvestHeader.Parent = list
	corner(harvestHeader, 4)

	local harvestHeaderText = label(harvestHeader, "Auto Harvest", 13, palette.text, true)
	harvestHeaderText.Position = UDim2.fromOffset(10, 0)
	harvestHeaderText.Size = UDim2.new(1, -40, 1, 0)

	local harvestArrow = label(harvestHeader, "v", 14, rgb(210, 210, 216), true)
	harvestArrow.Position = UDim2.new(1, -28, 0, 0)
	harvestArrow.Size = UDim2.fromOffset(20, 31)
	harvestArrow.TextXAlignment = Enum.TextXAlignment.Center

	local harvestAccent = Instance.new("Frame")
	harvestAccent.BackgroundColor3 = palette.accent
	harvestAccent.BorderSizePixel = 0
	harvestAccent.Position = UDim2.new(0, 0, 1, -2)
	harvestAccent.Size = UDim2.new(1, 0, 0, 2)
	harvestAccent.Parent = harvestHeader

	local harvestContent = Instance.new("Frame")
	harvestContent.Name = "AutoHarvestContent"
	harvestContent.BackgroundTransparency = 1
	harvestContent.BorderSizePixel = 0
	harvestContent.ClipsDescendants = true
	harvestContent.Size = UDim2.new(1, 0, 0, 0)
	harvestContent.LayoutOrder = 3
	harvestContent.Parent = list

	local harvestSeedRow = Instance.new("Frame")
	harvestSeedRow.Name = "HarvestSeedSelectedRow"
	harvestSeedRow.BackgroundColor3 = palette.card
	harvestSeedRow.BorderSizePixel = 0
	harvestSeedRow.Size = UDim2.new(1, 0, 0, 58)
	harvestSeedRow.Parent = harvestContent
	corner(harvestSeedRow, 4)

	local harvestSeedTitle = label(harvestSeedRow, "Harvest Seed Selected", 12, palette.text, true)
	harvestSeedTitle.Position = UDim2.fromOffset(10, 5)
	harvestSeedTitle.Size = UDim2.new(0.61, -10, 0, 18)

	local harvestSeedDescription = label(harvestSeedRow, "Choose which crops the harvester is allowed to pick.", 10, palette.muted, false)
	harvestSeedDescription.Position = UDim2.fromOffset(10, 23)
	harvestSeedDescription.Size = UDim2.new(0.61, -10, 0, 28)
	harvestSeedDescription.TextWrapped = true

	local harvestSelectButton = Instance.new("TextButton")
	harvestSelectButton.Name = "HarvestPlantSelectButton"
	harvestSelectButton.AutoButtonColor = false
	harvestSelectButton.Text = selectedHarvestPlant
	harvestSelectButton.Font = Enum.Font.GothamMedium
	harvestSelectButton.TextSize = 11
	harvestSelectButton.TextColor3 = palette.text
	harvestSelectButton.TextXAlignment = Enum.TextXAlignment.Left
	harvestSelectButton.BackgroundColor3 = rgb(35, 27, 48)
	harvestSelectButton.BorderSizePixel = 0
	harvestSelectButton.Position = UDim2.new(0.62, 0, 0, 12)
	harvestSelectButton.Size = UDim2.new(0.38, -7, 0, 34)
	harvestSelectButton.Parent = harvestSeedRow
	corner(harvestSelectButton, 4)

	local harvestSelectPadding = Instance.new("UIPadding")
	harvestSelectPadding.PaddingLeft = UDim.new(0, 10)
	harvestSelectPadding.PaddingRight = UDim.new(0, 30)
	harvestSelectPadding.Parent = harvestSelectButton

	local harvestSelectArrow = label(harvestSelectButton, "v", 13, rgb(210, 210, 216), true)
	harvestSelectArrow.Position = UDim2.new(1, 3, 0, 0)
	harvestSelectArrow.Size = UDim2.fromOffset(20, 34)
	harvestSelectArrow.TextXAlignment = Enum.TextXAlignment.Center

	local harvestDelayRow = Instance.new("Frame")
	harvestDelayRow.Name = "HarvestDelayRow"
	harvestDelayRow.BackgroundColor3 = palette.card
	harvestDelayRow.BorderSizePixel = 0
	harvestDelayRow.Position = UDim2.fromOffset(0, 64)
	harvestDelayRow.Size = UDim2.new(1, 0, 0, 42)
	harvestDelayRow.Parent = harvestContent
	corner(harvestDelayRow, 4)

	local harvestDelayTitle = label(harvestDelayRow, "Harvest Delay", 12, palette.text, true)
	harvestDelayTitle.Position = UDim2.fromOffset(10, 3)
	harvestDelayTitle.Size = UDim2.new(0.61, -10, 0, 18)

	local harvestDelayDescription = label(harvestDelayRow, "Wait time between each harvest sweep.", 10, palette.muted, false)
	harvestDelayDescription.Position = UDim2.fromOffset(10, 20)
	harvestDelayDescription.Size = UDim2.new(0.61, -10, 0, 16)

	local harvestDelayValue = label(harvestDelayRow, tostring(harvestDelay), 11, palette.text, true)
	harvestDelayValue.Name = "HarvestDelayValue"
	harvestDelayValue.BackgroundColor3 = rgb(35, 27, 48)
	harvestDelayValue.BackgroundTransparency = 0
	harvestDelayValue.BorderSizePixel = 0
	harvestDelayValue.Position = UDim2.new(0.62, 0, 0, 11)
	harvestDelayValue.Size = UDim2.fromOffset(32, 20)
	harvestDelayValue.TextXAlignment = Enum.TextXAlignment.Center
	corner(harvestDelayValue, 4)
	stroke(harvestDelayValue, palette.accent, 0.05, 1)

	local harvestDelayTrack = Instance.new("Frame")
	harvestDelayTrack.Name = "HarvestDelaySlider"
	harvestDelayTrack.Active = true
	harvestDelayTrack.BackgroundColor3 = rgb(62, 63, 72)
	harvestDelayTrack.BorderSizePixel = 0
	harvestDelayTrack.Position = UDim2.new(0.62, 40, 0, 19)
	harvestDelayTrack.Size = UDim2.new(0.38, -55, 0, 4)
	harvestDelayTrack.Parent = harvestDelayRow
	corner(harvestDelayTrack, 3)

	local harvestDelayFill = Instance.new("Frame")
	harvestDelayFill.BackgroundColor3 = palette.accent
	harvestDelayFill.BorderSizePixel = 0
	harvestDelayFill.Size = UDim2.new(harvestDelay / 10, 0, 1, 0)
	harvestDelayFill.Parent = harvestDelayTrack
	corner(harvestDelayFill, 3)

	local harvestDelayKnob = Instance.new("Frame")
	harvestDelayKnob.BackgroundColor3 = palette.accent
	harvestDelayKnob.BorderSizePixel = 0
	harvestDelayKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	harvestDelayKnob.Position = UDim2.new(harvestDelay / 10, 0, 0.5, 0)
	harvestDelayKnob.Size = UDim2.fromOffset(10, 10)
	harvestDelayKnob.Parent = harvestDelayTrack
	corner(harvestDelayKnob, 5)

	local startHarvestRow = Instance.new("Frame")
	startHarvestRow.Name = "StartHarvestRow"
	startHarvestRow.BackgroundColor3 = palette.card
	startHarvestRow.BorderSizePixel = 0
	startHarvestRow.Position = UDim2.fromOffset(0, 112)
	startHarvestRow.Size = UDim2.new(1, 0, 0, 48)
	startHarvestRow.Parent = harvestContent
	corner(startHarvestRow, 4)

	local startHarvestTitle = label(startHarvestRow, "Start Harvest", 12, palette.text, true)
	startHarvestTitle.Position = UDim2.fromOffset(10, 5)
	startHarvestTitle.Size = UDim2.new(0.75, -10, 0, 18)

	local startHarvestDescription = label(startHarvestRow, "Automatically picks ready crops for you.", 10, palette.muted, false)
	startHarvestDescription.Position = UDim2.fromOffset(10, 22)
	startHarvestDescription.Size = UDim2.new(0.75, -10, 0, 17)

	local startHarvestToggle = Instance.new("TextButton")
	startHarvestToggle.Name = "StartHarvestToggle"
	startHarvestToggle.AutoButtonColor = false
	startHarvestToggle.Text = ""
	startHarvestToggle.BackgroundColor3 = autoHarvestEnabled and palette.accent or rgb(48, 46, 58)
	startHarvestToggle.BorderSizePixel = 0
	startHarvestToggle.Position = UDim2.new(1, -50, 0.5, -11)
	startHarvestToggle.Size = UDim2.fromOffset(38, 22)
	startHarvestToggle.Parent = startHarvestRow
	corner(startHarvestToggle, 11)
	stroke(startHarvestToggle, rgb(116, 70, 152), autoHarvestEnabled and 0.15 or 0.45, 1)

	local harvestToggleKnob = Instance.new("Frame")
	harvestToggleKnob.BackgroundColor3 = rgb(239, 239, 243)
	harvestToggleKnob.BorderSizePixel = 0
	harvestToggleKnob.Position = autoHarvestEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
	harvestToggleKnob.Size = UDim2.fromOffset(16, 16)
	harvestToggleKnob.Parent = startHarvestToggle
	corner(harvestToggleKnob, 8)

	local advancedHeader = Instance.new("Frame")
	advancedHeader.Name = "AdvancedHarvestHeader"
	advancedHeader.BackgroundColor3 = rgb(29, 22, 40)
	advancedHeader.BorderSizePixel = 0
	advancedHeader.Position = UDim2.fromOffset(0, 166)
	advancedHeader.Size = UDim2.new(1, 0, 0, 31)
	advancedHeader.Parent = harvestContent
	corner(advancedHeader, 3)

	local advancedHeaderText = label(advancedHeader, "- [ Advanced Harvest Controller ] -", 11, palette.text, true)
	advancedHeaderText.Position = UDim2.fromOffset(10, 0)
	advancedHeaderText.Size = UDim2.new(1, -20, 1, 0)

	local function advancedRow(name, y, height, titleText, descriptionText)
		local row = Instance.new("Frame")
		row.Name = name
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, height)
		row.Parent = harvestContent
		corner(row, 4)

		local rowTitle = label(row, titleText, 12, palette.text, true)
		rowTitle.Position = UDim2.fromOffset(10, 4)
		rowTitle.Size = UDim2.new(0.61, -10, 0, 18)

		local rowDescription = label(row, descriptionText, 10, palette.muted, false)
		rowDescription.Position = UDim2.fromOffset(10, 21)
		rowDescription.Size = UDim2.new(0.61, -10, 0, height - 24)
		rowDescription.TextWrapped = true
		rowDescription.TextYAlignment = Enum.TextYAlignment.Top
		return row
	end

	local advancedToggleRow = advancedRow(
		"AdvancedHarvestToggleRow",
		203,
		48,
		"Use Advanced Harvest Filter",
		"Only picks crops that match the filters below."
	)

	local advancedToggle = Instance.new("TextButton")
	advancedToggle.Name = "AdvancedHarvestToggle"
	advancedToggle.AutoButtonColor = false
	advancedToggle.Text = ""
	advancedToggle.BackgroundColor3 = advancedHarvestEnabled and palette.accent or rgb(48, 46, 58)
	advancedToggle.BorderSizePixel = 0
	advancedToggle.Position = UDim2.new(1, -50, 0.5, -11)
	advancedToggle.Size = UDim2.fromOffset(38, 22)
	advancedToggle.Parent = advancedToggleRow
	corner(advancedToggle, 11)
	stroke(advancedToggle, rgb(116, 70, 152), advancedHarvestEnabled and 0.15 or 0.45, 1)

	local advancedToggleKnob = Instance.new("Frame")
	advancedToggleKnob.BackgroundColor3 = rgb(239, 239, 243)
	advancedToggleKnob.BorderSizePixel = 0
	advancedToggleKnob.Position = advancedHarvestEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
	advancedToggleKnob.Size = UDim2.fromOffset(16, 16)
	advancedToggleKnob.Parent = advancedToggle
	corner(advancedToggleKnob, 8)

	local advancedRarityRow = advancedRow(
		"HarvestRarityRow",
		257,
		58,
		"Only Harvest Plant Rarity",
		"Pick crops only from the selected rarities."
	)

	local advancedRarityButton = Instance.new("TextButton")
	advancedRarityButton.Name = "HarvestRarityButton"
	advancedRarityButton.AutoButtonColor = false
	advancedRarityButton.Text = "Select Options"
	advancedRarityButton.Font = Enum.Font.GothamMedium
	advancedRarityButton.TextSize = 11
	advancedRarityButton.TextColor3 = palette.muted
	advancedRarityButton.TextXAlignment = Enum.TextXAlignment.Left
	advancedRarityButton.BackgroundColor3 = rgb(35, 27, 48)
	advancedRarityButton.BorderSizePixel = 0
	advancedRarityButton.Position = UDim2.new(0.62, 0, 0, 12)
	advancedRarityButton.Size = UDim2.new(0.38, -7, 0, 34)
	advancedRarityButton.Parent = advancedRarityRow
	corner(advancedRarityButton, 4)
	padding(advancedRarityButton, 10, 0, 30, 0)

	local advancedRarityArrow = label(advancedRarityButton, "v", 13, rgb(210, 210, 216), true)
	advancedRarityArrow.Position = UDim2.new(1, 3, 0, 0)
	advancedRarityArrow.Size = UDim2.fromOffset(20, 34)
	advancedRarityArrow.TextXAlignment = Enum.TextXAlignment.Center

	local advancedMutationRow = advancedRow(
		"HarvestMutationRow",
		321,
		64,
		"Only Harvest Plant Mutation",
		"Pick crops only when they match these mutations. Choose Normal for non-mutated crops."
	)

	local advancedMutationButton = Instance.new("TextButton")
	advancedMutationButton.Name = "HarvestMutationButton"
	advancedMutationButton.AutoButtonColor = false
	advancedMutationButton.Text = "Select Options"
	advancedMutationButton.Font = Enum.Font.GothamMedium
	advancedMutationButton.TextSize = 11
	advancedMutationButton.TextColor3 = palette.muted
	advancedMutationButton.TextXAlignment = Enum.TextXAlignment.Left
	advancedMutationButton.BackgroundColor3 = rgb(35, 27, 48)
	advancedMutationButton.BorderSizePixel = 0
	advancedMutationButton.Position = UDim2.new(0.62, 0, 0, 15)
	advancedMutationButton.Size = UDim2.new(0.38, -7, 0, 34)
	advancedMutationButton.Parent = advancedMutationRow
	corner(advancedMutationButton, 4)
	padding(advancedMutationButton, 10, 0, 30, 0)

	local advancedMutationArrow = label(advancedMutationButton, "v", 13, rgb(210, 210, 216), true)
	advancedMutationArrow.Position = UDim2.new(1, 3, 0, 0)
	advancedMutationArrow.Size = UDim2.fromOffset(20, 34)
	advancedMutationArrow.TextXAlignment = Enum.TextXAlignment.Center

	local advancedKgRow = advancedRow(
		"HarvestKgRow",
		391,
		48,
		"Input Your Kg",
		"Set the KG number for this filter."
	)

	local kgInput = Instance.new("TextBox")
	kgInput.Name = "HarvestKgInput"
	kgInput.ClearTextOnFocus = false
	kgInput.Text = tostring(harvestKg)
	kgInput.Font = Enum.Font.GothamMedium
	kgInput.TextSize = 11
	kgInput.TextColor3 = palette.text
	kgInput.TextXAlignment = Enum.TextXAlignment.Left
	kgInput.BackgroundColor3 = rgb(35, 27, 48)
	kgInput.BorderSizePixel = 0
	kgInput.Position = UDim2.new(0.62, 0, 0, 9)
	kgInput.Size = UDim2.new(0.38, -7, 0, 30)
	kgInput.Parent = advancedKgRow
	corner(kgInput, 4)
	stroke(kgInput, rgb(116, 70, 152), 0.25, 1)
	padding(kgInput, 8, 0, 8, 0)

	local advancedDirectionRow = advancedRow(
		"HarvestKgDirectionRow",
		445,
		48,
		"KG Direction",
		"Up means this KG and higher. Below means lower than this KG."
	)

	local kgDirectionButton = Instance.new("TextButton")
	kgDirectionButton.Name = "HarvestKgDirectionButton"
	kgDirectionButton.AutoButtonColor = false
	kgDirectionButton.Text = harvestKgDirection
	kgDirectionButton.Font = Enum.Font.GothamMedium
	kgDirectionButton.TextSize = 11
	kgDirectionButton.TextColor3 = palette.text
	kgDirectionButton.TextXAlignment = Enum.TextXAlignment.Left
	kgDirectionButton.BackgroundColor3 = rgb(35, 27, 48)
	kgDirectionButton.BorderSizePixel = 0
	kgDirectionButton.Position = UDim2.new(0.62, 0, 0, 7)
	kgDirectionButton.Size = UDim2.new(0.38, -7, 0, 34)
	kgDirectionButton.Parent = advancedDirectionRow
	corner(kgDirectionButton, 4)
	padding(kgDirectionButton, 10, 0, 30, 0)

	local kgDirectionArrow = label(kgDirectionButton, "v", 13, rgb(210, 210, 216), true)
	kgDirectionArrow.Position = UDim2.new(1, 3, 0, 0)
	kgDirectionArrow.Size = UDim2.fromOffset(20, 34)
	kgDirectionArrow.TextXAlignment = Enum.TextXAlignment.Center

	local harvestOptionsPanel = Instance.new("Frame")
	harvestOptionsPanel.Name = "HarvestPlantDropdown"
	harvestOptionsPanel.BackgroundColor3 = palette.card
	harvestOptionsPanel.BorderSizePixel = 0
	harvestOptionsPanel.ClipsDescendants = true
	harvestOptionsPanel.Position = UDim2.new(0.62, 0, 0, 45)
	harvestOptionsPanel.Size = UDim2.new(0.38, -7, 0, 0)
	harvestOptionsPanel.ZIndex = 60
	harvestOptionsPanel.Parent = harvestContent
	corner(harvestOptionsPanel, 4)
	stroke(harvestOptionsPanel, rgb(68, 52, 92), 0.2, 1)

	local harvestSearch = Instance.new("TextBox")
	harvestSearch.Name = "HarvestPlantSearch"
	harvestSearch.ClearTextOnFocus = false
	harvestSearch.PlaceholderText = "Search"
	harvestSearch.Text = ""
	harvestSearch.Font = Enum.Font.GothamMedium
	harvestSearch.TextSize = 11
	harvestSearch.TextColor3 = palette.text
	harvestSearch.PlaceholderColor3 = palette.muted
	harvestSearch.BackgroundColor3 = rgb(35, 27, 48)
	harvestSearch.BorderSizePixel = 0
	harvestSearch.Position = UDim2.fromOffset(4, 4)
	harvestSearch.Size = UDim2.new(1, -8, 0, 26)
	harvestSearch.ZIndex = 61
	harvestSearch.Parent = harvestOptionsPanel
	corner(harvestSearch, 3)

	local harvestOptionsList = Instance.new("ScrollingFrame")
	harvestOptionsList.Name = "HarvestPlantList"
	harvestOptionsList.BackgroundTransparency = 1
	harvestOptionsList.BorderSizePixel = 0
	harvestOptionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	harvestOptionsList.CanvasSize = UDim2.fromOffset(0, 0)
	harvestOptionsList.ScrollBarImageColor3 = palette.accent
	harvestOptionsList.ScrollBarImageTransparency = 0.15
	harvestOptionsList.ScrollBarThickness = 3
	harvestOptionsList.ScrollingDirection = Enum.ScrollingDirection.Y
	harvestOptionsList.Position = UDim2.fromOffset(4, 34)
	harvestOptionsList.Size = UDim2.new(1, -8, 1, -38)
	harvestOptionsList.ZIndex = 61
	harvestOptionsList.Parent = harvestOptionsPanel

	local harvestOptionsLayout = Instance.new("UIListLayout")
	harvestOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	harvestOptionsLayout.Padding = UDim.new(0, 2)
	harvestOptionsLayout.Parent = harvestOptionsList

	local harvestOptionButtons = {}
	for index, plantName in ipairs(harvestPlantOptions) do
		local harvestOption = Instance.new("TextButton")
		harvestOption.Name = plantName:gsub("%s+", "") .. "HarvestOption"
		harvestOption.AutoButtonColor = false
		harvestOption.Text = plantName
		harvestOption.Font = Enum.Font.GothamMedium
		harvestOption.TextSize = 11
		harvestOption.TextColor3 = plantName == selectedHarvestPlant and rgb(221, 154, 255) or palette.text
		harvestOption.TextXAlignment = Enum.TextXAlignment.Left
		harvestOption.BackgroundColor3 = plantName == selectedHarvestPlant and rgb(48, 28, 64) or rgb(17, 18, 24)
		harvestOption.BackgroundTransparency = plantName == selectedHarvestPlant and 0.1 or 0.35
		harvestOption.BorderSizePixel = 0
		harvestOption.Size = UDim2.new(1, 0, 0, 26)
		harvestOption.LayoutOrder = index
		harvestOption.ZIndex = 62
		harvestOption.Parent = harvestOptionsList
		corner(harvestOption, 3)

		local harvestOptionPadding = Instance.new("UIPadding")
		harvestOptionPadding.PaddingLeft = UDim.new(0, 10)
		harvestOptionPadding.Parent = harvestOption
		table.insert(harvestOptionButtons, harvestOption)
	end

	local function createMultiSelectPanel(name, y, zIndex, choices, selectedValues)
		local panel = Instance.new("Frame")
		panel.Name = name
		panel.BackgroundColor3 = palette.card
		panel.BorderSizePixel = 0
		panel.ClipsDescendants = true
		panel.Position = UDim2.new(0.62, 0, 0, y)
		panel.Size = UDim2.new(0.38, -7, 0, 0)
		panel.ZIndex = zIndex
		panel.Parent = harvestContent
		corner(panel, 4)
		stroke(panel, rgb(68, 52, 92), 0.2, 1)

		local searchBox = Instance.new("TextBox")
		searchBox.ClearTextOnFocus = false
		searchBox.PlaceholderText = "Search"
		searchBox.Text = ""
		searchBox.Font = Enum.Font.GothamMedium
		searchBox.TextSize = 11
		searchBox.TextColor3 = palette.text
		searchBox.PlaceholderColor3 = palette.muted
		searchBox.BackgroundColor3 = rgb(35, 27, 48)
		searchBox.BorderSizePixel = 0
		searchBox.Position = UDim2.fromOffset(4, 4)
		searchBox.Size = UDim2.new(1, -8, 0, 26)
		searchBox.ZIndex = zIndex + 1
		searchBox.Parent = panel
		corner(searchBox, 3)

		local optionsList = Instance.new("ScrollingFrame")
		optionsList.BackgroundTransparency = 1
		optionsList.BorderSizePixel = 0
		optionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
		optionsList.CanvasSize = UDim2.fromOffset(0, 0)
		optionsList.ScrollBarImageColor3 = palette.accent
		optionsList.ScrollBarImageTransparency = 0.15
		optionsList.ScrollBarThickness = 3
		optionsList.ScrollingDirection = Enum.ScrollingDirection.Y
		optionsList.Position = UDim2.fromOffset(4, 34)
		optionsList.Size = UDim2.new(1, -8, 1, -38)
		optionsList.ZIndex = zIndex + 1
		optionsList.Parent = panel

		local optionsLayout = Instance.new("UIListLayout")
		optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		optionsLayout.Padding = UDim.new(0, 2)
		optionsLayout.Parent = optionsList

		local buttons = {}
		for index, choice in ipairs(choices) do
			local option = Instance.new("TextButton")
			option.AutoButtonColor = false
			option.Text = choice
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextColor3 = selectedValues[choice] and rgb(221, 154, 255) or palette.text
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.BackgroundColor3 = selectedValues[choice] and rgb(48, 28, 64) or rgb(17, 18, 24)
			option.BackgroundTransparency = selectedValues[choice] and 0.1 or 0.35
			option.BorderSizePixel = 0
			option.Size = UDim2.new(1, 0, 0, 26)
			option.LayoutOrder = index
			option.ZIndex = zIndex + 2
			option.Parent = optionsList
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			table.insert(buttons, option)
		end

		local function updateOptionsCanvas()
			local visibleCount = 0
			for _, option in ipairs(buttons) do
				if option.Visible then
					visibleCount += 1
				end
			end
			optionsList.CanvasSize = UDim2.fromOffset(0, math.max(0, visibleCount * 28 - 2))
		end
		updateOptionsCanvas()

		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local query = string.lower(searchBox.Text)
			for _, option in ipairs(buttons) do
				option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
			end
			optionsList.CanvasPosition = Vector2.zero
			updateOptionsCanvas()
		end)

		return panel, searchBox, buttons
	end

	local advancedRarityPanel, advancedRaritySearch, advancedRarityButtons = createMultiSelectPanel(
		"AdvancedRarityDropdown",
		298,
		70,
		rarityOptions,
		selectedHarvestRarities
	)
	local advancedMutationPanel, advancedMutationSearch, advancedMutationButtons = createMultiSelectPanel(
		"AdvancedMutationDropdown",
		362,
		80,
		harvestMutationOptions,
		selectedHarvestMutations
	)

	local directionPanel = Instance.new("Frame")
	directionPanel.Name = "HarvestKgDirectionDropdown"
	directionPanel.BackgroundColor3 = palette.card
	directionPanel.BorderSizePixel = 0
	directionPanel.ClipsDescendants = true
	directionPanel.Position = UDim2.new(0.62, 0, 0, 486)
	directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
	directionPanel.ZIndex = 90
	directionPanel.Parent = harvestContent
	corner(directionPanel, 4)
	stroke(directionPanel, rgb(68, 52, 92), 0.2, 1)

	local directionLayout = Instance.new("UIListLayout")
	directionLayout.SortOrder = Enum.SortOrder.LayoutOrder
	directionLayout.Padding = UDim.new(0, 2)
	directionLayout.Parent = directionPanel

	local directionButtons = {}
	for index, directionName in ipairs({"Up", "Below"}) do
		local directionOption = Instance.new("TextButton")
		directionOption.AutoButtonColor = false
		directionOption.Text = directionName
		directionOption.Font = Enum.Font.GothamMedium
		directionOption.TextSize = 11
		directionOption.TextColor3 = directionName == harvestKgDirection and rgb(221, 154, 255) or palette.text
		directionOption.TextXAlignment = Enum.TextXAlignment.Left
		directionOption.BackgroundColor3 = directionName == harvestKgDirection and rgb(48, 28, 64) or rgb(17, 18, 24)
		directionOption.BackgroundTransparency = directionName == harvestKgDirection and 0.1 or 0.35
		directionOption.BorderSizePixel = 0
		directionOption.Size = UDim2.new(1, 0, 0, 28)
		directionOption.LayoutOrder = index
		directionOption.ZIndex = 91
		directionOption.Parent = directionPanel
		corner(directionOption, 3)
		padding(directionOption, 10, 0, 0, 0)
		table.insert(directionButtons, directionOption)
	end

	local harvestCategoryOpen = false
	local harvestOptionsOpen = false
	local advancedRarityOpen = false
	local advancedMutationOpen = false
	local directionOpen = false
	local harvestBaseHeight = 493
	local harvestOptionsHeight = 178
	local function setAdvancedLayout(mode)
		local moveTween = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

		TweenService:Create(advancedMutationRow, moveTween, {
			Position = UDim2.fromOffset(0, 321),
		}):Play()
		TweenService:Create(advancedKgRow, moveTween, {
			Position = UDim2.fromOffset(0, 391),
		}):Play()
		TweenService:Create(advancedDirectionRow, moveTween, {
			Position = UDim2.fromOffset(0, 445),
		}):Play()
		TweenService:Create(advancedMutationPanel, moveTween, {
			Position = UDim2.new(0.62, 0, 0, 362),
		}):Play()
		TweenService:Create(directionPanel, moveTween, {
			Position = UDim2.new(0.62, 0, 0, 486),
		}):Play()
		TweenService:Create(harvestContent, moveTween, {
			Size = UDim2.new(1, 0, 0, mode == "mutation" and 540 or harvestBaseHeight),
		}):Play()
	end

	local function setHarvestOptionsOpen(open)
		if open then
			advancedRarityOpen = false
			advancedMutationOpen = false
			directionOpen = false
			advancedRarityPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedMutationPanel.Size = UDim2.new(0.38, -7, 0, 0)
			directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedRarityArrow.Rotation = 0
			advancedMutationArrow.Rotation = 0
			kgDirectionArrow.Rotation = 0
			setAdvancedLayout(nil)
		end
		harvestOptionsOpen = open
		TweenService:Create(harvestOptionsPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and harvestOptionsHeight or 0),
		}):Play()
		TweenService:Create(harvestContent, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, open and math.max(harvestBaseHeight, harvestOptionsHeight + 45) or harvestBaseHeight),
		}):Play()
		TweenService:Create(harvestSelectArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
		if open then
			task.defer(function()
				harvestSearch:CaptureFocus()
			end)
		end
	end

	local function setAdvancedRarityOpen(open)
		advancedRarityOpen = open
		if open then
			setHarvestOptionsOpen(false)
			advancedMutationOpen = false
			directionOpen = false
			advancedMutationPanel.Size = UDim2.new(0.38, -7, 0, 0)
			directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedMutationArrow.Rotation = 0
			kgDirectionArrow.Rotation = 0
			setAdvancedLayout(nil)
		end
		TweenService:Create(advancedRarityPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and 140 or 0),
		}):Play()
		TweenService:Create(advancedRarityArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
		setAdvancedLayout(open and "rarity" or nil)
		if open then
			task.defer(function() advancedRaritySearch:CaptureFocus() end)
		end
	end

	local function setAdvancedMutationOpen(open)
		advancedMutationOpen = open
		if open then
			setHarvestOptionsOpen(false)
			advancedRarityOpen = false
			directionOpen = false
			advancedRarityPanel.Size = UDim2.new(0.38, -7, 0, 0)
			directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedRarityArrow.Rotation = 0
			kgDirectionArrow.Rotation = 0
		end
		TweenService:Create(advancedMutationPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and 178 or 0),
		}):Play()
		TweenService:Create(advancedMutationArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
		setAdvancedLayout(open and "mutation" or nil)
		if open then
			task.defer(function() advancedMutationSearch:CaptureFocus() end)
		end
	end

	local function setDirectionOpen(open)
		directionOpen = open
		if open then
			setHarvestOptionsOpen(false)
			advancedRarityOpen = false
			advancedMutationOpen = false
			advancedRarityPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedMutationPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedRarityArrow.Rotation = 0
			advancedMutationArrow.Rotation = 0
			setAdvancedLayout(nil)
		end
		TweenService:Create(directionPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and 58 or 0),
		}):Play()
		TweenService:Create(kgDirectionArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
		TweenService:Create(harvestContent, TweenInfo.new(0.22), {
			Size = UDim2.new(1, 0, 0, open and 544 or harvestBaseHeight),
		}):Play()
	end

	for _, harvestOption in ipairs(harvestOptionButtons) do
		harvestOption.MouseButton1Click:Connect(function()
			selectedHarvestPlant = harvestOption.Text
			harvestSelectButton.Text = selectedHarvestPlant
			for _, sibling in ipairs(harvestOptionButtons) do
				local selected = sibling == harvestOption
				sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				sibling.BackgroundTransparency = selected and 0.1 or 0.35
			end
			screenGui:SetAttribute("HarvestPlantSelected", selectedHarvestPlant)
			setHarvestOptionsOpen(false)
		end)
	end

	harvestSearch:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(harvestSearch.Text)
		for _, harvestOption in ipairs(harvestOptionButtons) do
			harvestOption.Visible = query == "" or string.find(string.lower(harvestOption.Text), query, 1, true) ~= nil
		end
	end)

	local function updateMultiButton(button, selectedValues)
		local names = {}
		for name, selected in pairs(selectedValues) do
			if selected then
				table.insert(names, name)
			end
		end
		table.sort(names)
		if #names == 0 then
			button.Text = "Select Options"
			button.TextColor3 = palette.muted
		elseif #names == 1 then
			button.Text = names[1]
			button.TextColor3 = palette.text
		else
			button.Text = tostring(#names) .. " Selected"
			button.TextColor3 = palette.text
		end
		return table.concat(names, ",")
	end

	for _, option in ipairs(advancedRarityButtons) do
		option.MouseButton1Click:Connect(function()
			selectedHarvestRarities[option.Text] = not selectedHarvestRarities[option.Text] or nil
			local selected = selectedHarvestRarities[option.Text] == true
			option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
			option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
			option.BackgroundTransparency = selected and 0.1 or 0.35
			screenGui:SetAttribute("HarvestRarities", updateMultiButton(advancedRarityButton, selectedHarvestRarities))
		end)
	end

	for _, option in ipairs(advancedMutationButtons) do
		option.MouseButton1Click:Connect(function()
			selectedHarvestMutations[option.Text] = not selectedHarvestMutations[option.Text] or nil
			local selected = selectedHarvestMutations[option.Text] == true
			option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
			option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
			option.BackgroundTransparency = selected and 0.1 or 0.35
			screenGui:SetAttribute("HarvestMutations", updateMultiButton(advancedMutationButton, selectedHarvestMutations))
		end)
	end

	advancedRarityButton.MouseButton1Click:Connect(function()
		if harvestCategoryOpen then
			setAdvancedRarityOpen(not advancedRarityOpen)
		end
	end)

	advancedMutationButton.MouseButton1Click:Connect(function()
		if harvestCategoryOpen then
			setAdvancedMutationOpen(not advancedMutationOpen)
		end
	end)

	advancedToggle.MouseButton1Click:Connect(function()
		advancedHarvestEnabled = not advancedHarvestEnabled
		screenGui:SetAttribute("AdvancedHarvestEnabled", advancedHarvestEnabled)
		TweenService:Create(advancedToggle, TweenInfo.new(0.18), {
			BackgroundColor3 = advancedHarvestEnabled and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(advancedToggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = advancedHarvestEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end)

	local function commitHarvestKg()
		local normalizedText = string.gsub(kgInput.Text, ",", ".")
		local value = tonumber(normalizedText)
		harvestKg = math.max(0, value or 0)
		kgInput.Text = tostring(harvestKg)
		screenGui:SetAttribute("HarvestKg", harvestKg)
	end

	kgInput.FocusLost:Connect(commitHarvestKg)

	kgDirectionButton.MouseButton1Click:Connect(function()
		if harvestCategoryOpen then
			setDirectionOpen(not directionOpen)
		end
	end)

	for _, option in ipairs(directionButtons) do
		option.MouseButton1Click:Connect(function()
			harvestKgDirection = option.Text
			kgDirectionButton.Text = harvestKgDirection
			for _, sibling in ipairs(directionButtons) do
				local selected = sibling == option
				sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				sibling.BackgroundTransparency = selected and 0.1 or 0.35
			end
			screenGui:SetAttribute("HarvestKgDirection", harvestKgDirection)
			setDirectionOpen(false)
		end)
	end

	updateMultiButton(advancedRarityButton, selectedHarvestRarities)
	updateMultiButton(advancedMutationButton, selectedHarvestMutations)

	harvestHeader.MouseButton1Click:Connect(function()
		harvestCategoryOpen = not harvestCategoryOpen
		if not harvestCategoryOpen then
			harvestOptionsOpen = false
			advancedRarityOpen = false
			advancedMutationOpen = false
			directionOpen = false
			harvestOptionsPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedRarityPanel.Size = UDim2.new(0.38, -7, 0, 0)
			advancedMutationPanel.Size = UDim2.new(0.38, -7, 0, 0)
			directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
			harvestSelectArrow.Rotation = 0
			advancedRarityArrow.Rotation = 0
			advancedMutationArrow.Rotation = 0
			kgDirectionArrow.Rotation = 0
			setAdvancedLayout(nil)
		end
		TweenService:Create(harvestContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, harvestCategoryOpen and harvestBaseHeight or 0),
		}):Play()
		TweenService:Create(harvestArrow, TweenInfo.new(0.18), {Rotation = harvestCategoryOpen and 180 or 0}):Play()
	end)

	harvestSelectButton.MouseButton1Click:Connect(function()
		if harvestCategoryOpen then
			setHarvestOptionsOpen(not harvestOptionsOpen)
		end
	end)

	local harvestSliderDragging = false
	local function updateHarvestDelay(screenX)
		if harvestDelayTrack.AbsoluteSize.X <= 0 then
			return
		end
		local alpha = math.clamp((screenX - harvestDelayTrack.AbsolutePosition.X) / harvestDelayTrack.AbsoluteSize.X, 0, 1)
		harvestDelay = math.floor(alpha * 10 + 0.5)
		local snappedAlpha = harvestDelay / 10
		harvestDelayValue.Text = tostring(harvestDelay)
		harvestDelayFill.Size = UDim2.new(snappedAlpha, 0, 1, 0)
		harvestDelayKnob.Position = UDim2.new(snappedAlpha, 0, 0.5, 0)
		screenGui:SetAttribute("HarvestDelay", harvestDelay)
	end

	harvestDelayTrack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			harvestSliderDragging = true
			updateHarvestDelay(input.Position.X)
		end
	end)

	local harvestSliderInputConnection
	harvestSliderInputConnection = UserInputService.InputChanged:Connect(function(input)
		if harvestSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateHarvestDelay(input.Position.X)
		end
	end)

	local harvestSliderEndedConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			harvestSliderDragging = false
		end
	end)

	harvestContent.AncestryChanged:Connect(function(_, parent)
		if not parent then
			if harvestSliderInputConnection then
				harvestSliderInputConnection:Disconnect()
				harvestSliderInputConnection = nil
			end
			if harvestSliderEndedConnection then
				harvestSliderEndedConnection:Disconnect()
				harvestSliderEndedConnection = nil
			end
		end
	end)

	local function syncAutoHarvestAttributes()
		screenGui:SetAttribute("AutoHarvestEnabled", autoHarvestEnabled)
		screenGui:SetAttribute("HarvestPlantSelected", selectedHarvestPlant)
		screenGui:SetAttribute("HarvestDelay", harvestDelay)
		screenGui:SetAttribute("AdvancedHarvestEnabled", advancedHarvestEnabled)
		screenGui:SetAttribute("HarvestKg", harvestKg)
		screenGui:SetAttribute("HarvestKgDirection", harvestKgDirection)
	end

	startHarvestToggle.MouseButton1Click:Connect(function()
		commitHarvestKg()
		autoHarvestEnabled = not autoHarvestEnabled
		autoHarvestRunId += 1
		if autoHarvestEnabled then
			screenGui:SetAttribute("AutoHarvestStatus", "Running")
			runAutoHarvest(autoHarvestRunId)
		else
			screenGui:SetAttribute("AutoHarvestStatus", "Stopped")
		end
		syncAutoHarvestAttributes()
		TweenService:Create(startHarvestToggle, TweenInfo.new(0.18), {
			BackgroundColor3 = autoHarvestEnabled and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(harvestToggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = autoHarvestEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end)

	syncAutoHarvestAttributes()

	local sellHeader = Instance.new("TextButton")
	sellHeader.Name = "AutoSellHeader"
	sellHeader.AutoButtonColor = false
	sellHeader.Text = ""
	sellHeader.BackgroundColor3 = palette.card
	sellHeader.BorderSizePixel = 0
	sellHeader.Size = UDim2.new(1, 0, 0, 31)
	sellHeader.LayoutOrder = 4
	sellHeader.Parent = list
	corner(sellHeader, 4)

	local sellHeaderText = label(sellHeader, "Auto Sell", 13, palette.text, true)
	sellHeaderText.Position = UDim2.fromOffset(10, 0)
	sellHeaderText.Size = UDim2.new(1, -40, 1, 0)

	local sellArrow = label(sellHeader, "v", 14, rgb(210, 210, 216), true)
	sellArrow.Position = UDim2.new(1, -28, 0, 0)
	sellArrow.Size = UDim2.fromOffset(20, 31)
	sellArrow.TextXAlignment = Enum.TextXAlignment.Center

	local sellAccent = Instance.new("Frame")
	sellAccent.BackgroundColor3 = palette.accent
	sellAccent.BorderSizePixel = 0
	sellAccent.Position = UDim2.new(0, 0, 1, -2)
	sellAccent.Size = UDim2.new(1, 0, 0, 2)
	sellAccent.Parent = sellHeader

	local sellContent = Instance.new("Frame")
	sellContent.Name = "AutoSellContent"
	sellContent.BackgroundTransparency = 1
	sellContent.BorderSizePixel = 0
	sellContent.ClipsDescendants = true
	sellContent.Size = UDim2.new(1, 0, 0, 0)
	sellContent.LayoutOrder = 5
	sellContent.Parent = list

	local sellMethodRow = Instance.new("Frame")
	sellMethodRow.Name = "SellingMethodRow"
	sellMethodRow.BackgroundColor3 = palette.card
	sellMethodRow.BorderSizePixel = 0
	sellMethodRow.Position = UDim2.fromOffset(0, 0)
	sellMethodRow.Size = UDim2.new(1, 0, 0, 48)
	sellMethodRow.Parent = sellContent
	corner(sellMethodRow, 4)

	local sellMethodTitle = label(sellMethodRow, "Selling Method", 12, palette.text, true)
	sellMethodTitle.Position = UDim2.fromOffset(10, 5)
	sellMethodTitle.Size = UDim2.new(0.58, -10, 0, 18)

	local sellMethodDescription = label(sellMethodRow, "Choose when your backpack should be sold.", 10, palette.muted, false)
	sellMethodDescription.Position = UDim2.fromOffset(10, 22)
	sellMethodDescription.Size = UDim2.new(0.62, -10, 0, 17)

	local sellMethodButton = Instance.new("TextButton")
	sellMethodButton.Name = "SellingMethodButton"
	sellMethodButton.AutoButtonColor = false
	sellMethodButton.Text = sellingMethod
	sellMethodButton.Font = Enum.Font.GothamMedium
	sellMethodButton.TextSize = 11
	sellMethodButton.TextColor3 = palette.text
	sellMethodButton.TextXAlignment = Enum.TextXAlignment.Left
	sellMethodButton.BackgroundColor3 = rgb(35, 27, 48)
	sellMethodButton.BorderSizePixel = 0
	sellMethodButton.Position = UDim2.new(0.62, 0, 0, 7)
	sellMethodButton.Size = UDim2.new(0.38, -7, 0, 34)
	sellMethodButton.Parent = sellMethodRow
	corner(sellMethodButton, 4)
	padding(sellMethodButton, 10, 0, 30, 0)

	local sellMethodArrow = label(sellMethodButton, "v", 13, rgb(210, 210, 216), true)
	sellMethodArrow.Position = UDim2.new(1, 3, 0, 0)
	sellMethodArrow.Size = UDim2.fromOffset(20, 34)
	sellMethodArrow.TextXAlignment = Enum.TextXAlignment.Center

	local sellInputRow = Instance.new("Frame")
	sellInputRow.Name = "SellingInputRow"
	sellInputRow.BackgroundColor3 = palette.card
	sellInputRow.BorderSizePixel = 0
	sellInputRow.Position = UDim2.fromOffset(0, 54)
	sellInputRow.Size = UDim2.new(1, 0, 0, 48)
	sellInputRow.Parent = sellContent
	corner(sellInputRow, 4)

	local sellInputTitle = label(sellInputRow, "Input Selling", 12, palette.text, true)
	sellInputTitle.Position = UDim2.fromOffset(10, 5)
	sellInputTitle.Size = UDim2.new(0.58, -10, 0, 18)

	local sellInputDescription = label(sellInputRow, "Set the timer or backpack count for selling.", 10, palette.muted, false)
	sellInputDescription.Position = UDim2.fromOffset(10, 22)
	sellInputDescription.Size = UDim2.new(0.62, -10, 0, 17)

	local sellInput = Instance.new("TextBox")
	sellInput.Name = "SellingInput"
	sellInput.ClearTextOnFocus = false
	sellInput.Text = tostring(sellingInput)
	sellInput.Font = Enum.Font.GothamMedium
	sellInput.TextSize = 11
	sellInput.TextColor3 = palette.text
	sellInput.TextXAlignment = Enum.TextXAlignment.Left
	sellInput.BackgroundColor3 = rgb(35, 27, 48)
	sellInput.BorderSizePixel = 0
	sellInput.Position = UDim2.new(0.62, 0, 0, 7)
	sellInput.Size = UDim2.new(0.38, -7, 0, 34)
	sellInput.Parent = sellInputRow
	corner(sellInput, 4)
	stroke(sellInput, rgb(116, 70, 152), 0.25, 1)
	padding(sellInput, 10, 0, 8, 0)

	local startSellingRow = Instance.new("Frame")
	startSellingRow.Name = "StartSellingRow"
	startSellingRow.BackgroundColor3 = palette.card
	startSellingRow.BorderSizePixel = 0
	startSellingRow.Position = UDim2.fromOffset(0, 108)
	startSellingRow.Size = UDim2.new(1, 0, 0, 48)
	startSellingRow.Parent = sellContent
	corner(startSellingRow, 4)

	local startSellingTitle = label(startSellingRow, "Start Selling", 12, palette.text, true)
	startSellingTitle.Position = UDim2.fromOffset(10, 5)
	startSellingTitle.Size = UDim2.new(0.75, -10, 0, 18)

	local startSellingDescription = label(startSellingRow, "Automatically sells when your rule is met.", 10, palette.muted, false)
	startSellingDescription.Position = UDim2.fromOffset(10, 22)
	startSellingDescription.Size = UDim2.new(0.75, -10, 0, 17)

	local startSellingToggle = Instance.new("TextButton")
	startSellingToggle.Name = "StartSellingToggle"
	startSellingToggle.AutoButtonColor = false
	startSellingToggle.Text = ""
	startSellingToggle.BackgroundColor3 = autoSellEnabled and palette.accent or rgb(48, 46, 58)
	startSellingToggle.BorderSizePixel = 0
	startSellingToggle.Position = UDim2.new(1, -50, 0.5, -11)
	startSellingToggle.Size = UDim2.fromOffset(38, 22)
	startSellingToggle.Parent = startSellingRow
	corner(startSellingToggle, 11)
	stroke(startSellingToggle, rgb(116, 70, 152), autoSellEnabled and 0.15 or 0.45, 1)

	local sellingToggleKnob = Instance.new("Frame")
	sellingToggleKnob.BackgroundColor3 = rgb(239, 239, 243)
	sellingToggleKnob.BorderSizePixel = 0
	sellingToggleKnob.Position = autoSellEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
	sellingToggleKnob.Size = UDim2.fromOffset(16, 16)
	sellingToggleKnob.Parent = startSellingToggle
	corner(sellingToggleKnob, 8)

	local sellMethodPanel = Instance.new("Frame")
	sellMethodPanel.Name = "SellingMethodDropdown"
	sellMethodPanel.BackgroundColor3 = palette.card
	sellMethodPanel.BorderSizePixel = 0
	sellMethodPanel.ClipsDescendants = true
	sellMethodPanel.Position = UDim2.new(0.62, 0, 0, 44)
	sellMethodPanel.Size = UDim2.new(0.38, -7, 0, 0)
	sellMethodPanel.ZIndex = 100
	sellMethodPanel.Parent = sellContent
	corner(sellMethodPanel, 4)
	stroke(sellMethodPanel, rgb(68, 52, 92), 0.2, 1)

	local sellMethodLayout = Instance.new("UIListLayout")
	sellMethodLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sellMethodLayout.Padding = UDim.new(0, 2)
	sellMethodLayout.Parent = sellMethodPanel

	local sellingMethodOptions = {"Timer (Min)", "Timer (Sec)", "Backpack Count"}
	local sellingMethodButtons = {}
	for index, methodName in ipairs(sellingMethodOptions) do
		local option = Instance.new("TextButton")
		option.AutoButtonColor = false
		option.Text = methodName
		option.Font = Enum.Font.GothamMedium
		option.TextSize = 11
		option.TextColor3 = methodName == sellingMethod and rgb(221, 154, 255) or palette.text
		option.TextXAlignment = Enum.TextXAlignment.Left
		option.BackgroundColor3 = methodName == sellingMethod and rgb(48, 28, 64) or rgb(17, 18, 24)
		option.BackgroundTransparency = methodName == sellingMethod and 0.1 or 0.35
		option.BorderSizePixel = 0
		option.Size = UDim2.new(1, 0, 0, 28)
		option.LayoutOrder = index
		option.ZIndex = 101
		option.Parent = sellMethodPanel
		corner(option, 3)
		padding(option, 10, 0, 0, 0)
		table.insert(sellingMethodButtons, option)
	end

	local sellCategoryOpen = false
	local sellMethodOpen = false
	local sellBaseHeight = 156

	local function commitSellingInput()
		local normalizedText = string.gsub(sellInput.Text, ",", ".")
		local value = tonumber(normalizedText) or 1
		if sellingMethod == "Backpack Count" then
			sellingInput = math.max(1, math.floor(value))
		else
			sellingInput = math.max(0.1, value)
		end
		sellInput.Text = tostring(sellingInput)
		screenGui:SetAttribute("SellingInput", sellingInput)
	end

	local function setSellMethodOpen(open)
		sellMethodOpen = open
		TweenService:Create(sellMethodPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and 88 or 0),
		}):Play()
		TweenService:Create(sellMethodArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
	end

	sellMethodButton.MouseButton1Click:Connect(function()
		if sellCategoryOpen then
			setSellMethodOpen(not sellMethodOpen)
		end
	end)

	for _, option in ipairs(sellingMethodButtons) do
		option.MouseButton1Click:Connect(function()
			sellingMethod = option.Text
			sellMethodButton.Text = sellingMethod
			for _, sibling in ipairs(sellingMethodButtons) do
				local selected = sibling == option
				sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				sibling.BackgroundTransparency = selected and 0.1 or 0.35
			end
			commitSellingInput()
			screenGui:SetAttribute("SellingMethod", sellingMethod)
			setSellMethodOpen(false)
		end)
	end

	sellInput.FocusLost:Connect(commitSellingInput)

	startSellingToggle.MouseButton1Click:Connect(function()
		commitSellingInput()
		autoSellEnabled = not autoSellEnabled
		autoSellRunId += 1
		if autoSellEnabled then
			screenGui:SetAttribute("AutoSellStatus", "Waiting for rule")
			runAutoSell(autoSellRunId)
		else
			screenGui:SetAttribute("AutoSellStatus", "Stopped")
		end
		screenGui:SetAttribute("AutoSellEnabled", autoSellEnabled)
		screenGui:SetAttribute("SellingMethod", sellingMethod)
		TweenService:Create(startSellingToggle, TweenInfo.new(0.18), {
			BackgroundColor3 = autoSellEnabled and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(sellingToggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = autoSellEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end)

	sellHeader.MouseButton1Click:Connect(function()
		sellCategoryOpen = not sellCategoryOpen
		if not sellCategoryOpen then
			setSellMethodOpen(false)
		end
		TweenService:Create(sellContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, sellCategoryOpen and sellBaseHeight or 0),
		}):Play()
		TweenService:Create(sellArrow, TweenInfo.new(0.18), {Rotation = sellCategoryOpen and 180 or 0}):Play()
	end)

	screenGui:SetAttribute("AutoSellEnabled", autoSellEnabled)
	screenGui:SetAttribute("SellingMethod", sellingMethod)
	screenGui:SetAttribute("SellingInput", sellingInput)

	local dailyHeader = Instance.new("TextButton")
	dailyHeader.Name = "DailyDealHeader"
	dailyHeader.AutoButtonColor = false
	dailyHeader.Text = ""
	dailyHeader.BackgroundColor3 = palette.card
	dailyHeader.BorderSizePixel = 0
	dailyHeader.Size = UDim2.new(1, 0, 0, 31)
	dailyHeader.LayoutOrder = 6
	dailyHeader.Parent = list
	corner(dailyHeader, 4)

	local dailyHeaderText = label(dailyHeader, "Daily Deal", 13, palette.text, true)
	dailyHeaderText.Position = UDim2.fromOffset(10, 0)
	dailyHeaderText.Size = UDim2.new(1, -40, 1, 0)

	local dailyArrow = label(dailyHeader, "v", 14, rgb(210, 210, 216), true)
	dailyArrow.Position = UDim2.new(1, -28, 0, 0)
	dailyArrow.Size = UDim2.fromOffset(20, 31)
	dailyArrow.TextXAlignment = Enum.TextXAlignment.Center

	local dailyAccent = Instance.new("Frame")
	dailyAccent.BackgroundColor3 = palette.accent
	dailyAccent.BorderSizePixel = 0
	dailyAccent.Position = UDim2.new(0, 0, 1, -2)
	dailyAccent.Size = UDim2.new(1, 0, 0, 2)
	dailyAccent.Parent = dailyHeader

	local dailyContent = Instance.new("Frame")
	dailyContent.Name = "DailyDealContent"
	dailyContent.BackgroundTransparency = 1
	dailyContent.BorderSizePixel = 0
	dailyContent.ClipsDescendants = true
	dailyContent.Size = UDim2.new(1, 0, 0, 0)
	dailyContent.LayoutOrder = 7
	dailyContent.Parent = list

	local dailyHelpRow = Instance.new("Frame")
	dailyHelpRow.Name = "DailyDealHelpRow"
	dailyHelpRow.BackgroundColor3 = palette.card
	dailyHelpRow.BorderSizePixel = 0
	dailyHelpRow.Position = UDim2.fromOffset(0, 0)
	dailyHelpRow.Size = UDim2.new(1, 0, 0, 98)
	dailyHelpRow.Parent = dailyContent
	corner(dailyHelpRow, 4)

	local dailyHelpTitle = label(dailyHelpRow, "How to Use", 12, palette.text, true)
	dailyHelpTitle.Position = UDim2.fromOffset(10, 5)
	dailyHelpTitle.Size = UDim2.new(1, -20, 0, 18)

	local dailyHelpFirst = label(dailyHelpRow, "Turn on 'Start Selling' in Auto Sell first, or this does nothing.", 10, palette.muted, false)
	dailyHelpFirst.Position = UDim2.fromOffset(10, 23)
	dailyHelpFirst.Size = UDim2.new(1, -20, 0, 18)
	dailyHelpFirst.TextWrapped = true
	dailyHelpFirst.TextYAlignment = Enum.TextYAlignment.Top

	local dailyHelpSecond = label(dailyHelpRow, "When Daily Deal is ready, your backpack is sold with Daily Deal instead of a normal sell. While Daily Deal is on cooldown, Auto Sell keeps selling normally.", 10, palette.muted, false)
	dailyHelpSecond.Position = UDim2.fromOffset(10, 47)
	dailyHelpSecond.Size = UDim2.new(1, -20, 0, 43)
	dailyHelpSecond.TextWrapped = true
	dailyHelpSecond.TextYAlignment = Enum.TextYAlignment.Top

	local dailyModeRow = Instance.new("Frame")
	dailyModeRow.Name = "DailyDealModeRow"
	dailyModeRow.BackgroundColor3 = palette.card
	dailyModeRow.BorderSizePixel = 0
	dailyModeRow.Position = UDim2.fromOffset(0, 104)
	dailyModeRow.Size = UDim2.new(1, 0, 0, 70)
	dailyModeRow.Parent = dailyContent
	corner(dailyModeRow, 4)

	local dailyModeTitle = label(dailyModeRow, "Daily Deal Mode", 12, palette.text, true)
	dailyModeTitle.Position = UDim2.fromOffset(10, 5)
	dailyModeTitle.Size = UDim2.new(0.62, -10, 0, 18)

	local dailyModeDescription = label(dailyModeRow, "Full Inventory waits until your backpack is full. Count waits until you reach the fruit count below.", 10, palette.muted, false)
	dailyModeDescription.Position = UDim2.fromOffset(10, 23)
	dailyModeDescription.Size = UDim2.new(0.62, -14, 0, 40)
	dailyModeDescription.TextWrapped = true
	dailyModeDescription.TextYAlignment = Enum.TextYAlignment.Top

	local dailyModeButton = Instance.new("TextButton")
	dailyModeButton.Name = "DailyDealModeButton"
	dailyModeButton.AutoButtonColor = false
	dailyModeButton.Text = dailyDealMode
	dailyModeButton.Font = Enum.Font.GothamMedium
	dailyModeButton.TextSize = 11
	dailyModeButton.TextColor3 = palette.text
	dailyModeButton.TextXAlignment = Enum.TextXAlignment.Left
	dailyModeButton.BackgroundColor3 = rgb(35, 27, 48)
	dailyModeButton.BorderSizePixel = 0
	dailyModeButton.Position = UDim2.new(0.62, 0, 0, 11)
	dailyModeButton.Size = UDim2.new(0.38, -7, 0, 34)
	dailyModeButton.Parent = dailyModeRow
	corner(dailyModeButton, 4)
	padding(dailyModeButton, 10, 0, 30, 0)

	local dailyModeArrow = label(dailyModeButton, "v", 13, rgb(210, 210, 216), true)
	dailyModeArrow.Position = UDim2.new(1, 3, 0, 0)
	dailyModeArrow.Size = UDim2.fromOffset(20, 34)
	dailyModeArrow.TextXAlignment = Enum.TextXAlignment.Center

	local dailyCountRow = Instance.new("Frame")
	dailyCountRow.Name = "DailyDealCountRow"
	dailyCountRow.BackgroundColor3 = palette.card
	dailyCountRow.BorderSizePixel = 0
	dailyCountRow.Position = UDim2.fromOffset(0, 180)
	dailyCountRow.Size = UDim2.new(1, 0, 0, 54)
	dailyCountRow.Parent = dailyContent
	corner(dailyCountRow, 4)

	local dailyCountTitle = label(dailyCountRow, "Daily Deal Count", 12, palette.text, true)
	dailyCountTitle.Position = UDim2.fromOffset(10, 5)
	dailyCountTitle.Size = UDim2.new(0.62, -10, 0, 18)

	local dailyCountDescription = label(dailyCountRow, "Only used in Count mode. Waits until you have this many fruits before selling.", 10, palette.muted, false)
	dailyCountDescription.Position = UDim2.fromOffset(10, 23)
	dailyCountDescription.Size = UDim2.new(0.62, -14, 0, 26)
	dailyCountDescription.TextWrapped = true
	dailyCountDescription.TextYAlignment = Enum.TextYAlignment.Top

	local dailyCountInput = Instance.new("TextBox")
	dailyCountInput.Name = "DailyDealCountInput"
	dailyCountInput.ClearTextOnFocus = false
	dailyCountInput.Text = tostring(dailyDealCount)
	dailyCountInput.Font = Enum.Font.GothamMedium
	dailyCountInput.TextSize = 11
	dailyCountInput.TextColor3 = palette.text
	dailyCountInput.TextXAlignment = Enum.TextXAlignment.Left
	dailyCountInput.BackgroundColor3 = rgb(35, 27, 48)
	dailyCountInput.BorderSizePixel = 0
	dailyCountInput.Position = UDim2.new(0.62, 0, 0, 10)
	dailyCountInput.Size = UDim2.new(0.38, -7, 0, 34)
	dailyCountInput.Parent = dailyCountRow
	corner(dailyCountInput, 4)
	stroke(dailyCountInput, rgb(116, 70, 152), 0.25, 1)
	padding(dailyCountInput, 10, 0, 8, 0)

	local useDailyRow = Instance.new("Frame")
	useDailyRow.Name = "UseDailyDealRow"
	useDailyRow.BackgroundColor3 = palette.card
	useDailyRow.BorderSizePixel = 0
	useDailyRow.Position = UDim2.fromOffset(0, 240)
	useDailyRow.Size = UDim2.new(1, 0, 0, 48)
	useDailyRow.Parent = dailyContent
	corner(useDailyRow, 4)

	local useDailyTitle = label(useDailyRow, "Use Daily Deal", 12, palette.text, true)
	useDailyTitle.Position = UDim2.fromOffset(10, 5)
	useDailyTitle.Size = UDim2.new(0.75, -10, 0, 18)

	local useDailyDescription = label(useDailyRow, "Sell with Daily Deal when it is ready. Needs Start Selling to be on.", 10, palette.muted, false)
	useDailyDescription.Position = UDim2.fromOffset(10, 22)
	useDailyDescription.Size = UDim2.new(0.75, -10, 0, 17)

	local useDailyToggle = Instance.new("TextButton")
	useDailyToggle.Name = "UseDailyDealToggle"
	useDailyToggle.AutoButtonColor = false
	useDailyToggle.Text = ""
	useDailyToggle.BackgroundColor3 = useDailyDeal and palette.accent or rgb(48, 46, 58)
	useDailyToggle.BorderSizePixel = 0
	useDailyToggle.Position = UDim2.new(1, -50, 0.5, -11)
	useDailyToggle.Size = UDim2.fromOffset(38, 22)
	useDailyToggle.Parent = useDailyRow
	corner(useDailyToggle, 11)
	stroke(useDailyToggle, rgb(116, 70, 152), useDailyDeal and 0.15 or 0.45, 1)

	local useDailyKnob = Instance.new("Frame")
	useDailyKnob.BackgroundColor3 = rgb(239, 239, 243)
	useDailyKnob.BorderSizePixel = 0
	useDailyKnob.Position = useDailyDeal and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
	useDailyKnob.Size = UDim2.fromOffset(16, 16)
	useDailyKnob.Parent = useDailyToggle
	corner(useDailyKnob, 8)

	local dailyModePanel = Instance.new("Frame")
	dailyModePanel.Name = "DailyDealModeDropdown"
	dailyModePanel.BackgroundColor3 = palette.card
	dailyModePanel.BorderSizePixel = 0
	dailyModePanel.ClipsDescendants = true
	dailyModePanel.Position = UDim2.new(0.62, 0, 0, 147)
	dailyModePanel.Size = UDim2.new(0.38, -7, 0, 0)
	dailyModePanel.ZIndex = 110
	dailyModePanel.Parent = dailyContent
	corner(dailyModePanel, 4)
	stroke(dailyModePanel, rgb(68, 52, 92), 0.2, 1)

	local dailyModeLayout = Instance.new("UIListLayout")
	dailyModeLayout.SortOrder = Enum.SortOrder.LayoutOrder
	dailyModeLayout.Padding = UDim.new(0, 2)
	dailyModeLayout.Parent = dailyModePanel

	local dailyModeButtons = {}
	for index, modeName in ipairs({"Full Inventory", "Count"}) do
		local option = Instance.new("TextButton")
		option.AutoButtonColor = false
		option.Text = modeName
		option.Font = Enum.Font.GothamMedium
		option.TextSize = 11
		option.TextColor3 = modeName == dailyDealMode and rgb(221, 154, 255) or palette.text
		option.TextXAlignment = Enum.TextXAlignment.Left
		option.BackgroundColor3 = modeName == dailyDealMode and rgb(48, 28, 64) or rgb(17, 18, 24)
		option.BackgroundTransparency = modeName == dailyDealMode and 0.1 or 0.35
		option.BorderSizePixel = 0
		option.Size = UDim2.new(1, 0, 0, 28)
		option.LayoutOrder = index
		option.ZIndex = 111
		option.Parent = dailyModePanel
		corner(option, 3)
		padding(option, 10, 0, 0, 0)
		table.insert(dailyModeButtons, option)
	end

	local dailyCategoryOpen = false
	local dailyModeOpen = false
	local dailyBaseHeight = 288

	local function commitDailyCount()
		local normalizedText = string.gsub(dailyCountInput.Text, ",", ".")
		dailyDealCount = math.max(1, math.floor(tonumber(normalizedText) or 100))
		dailyCountInput.Text = tostring(dailyDealCount)
		screenGui:SetAttribute("DailyDealCount", dailyDealCount)
	end

	local function setDailyModeOpen(open)
		dailyModeOpen = open
		TweenService:Create(dailyModePanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.38, -7, 0, open and 58 or 0),
		}):Play()
		TweenService:Create(dailyModeArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
	end

	dailyModeButton.MouseButton1Click:Connect(function()
		if dailyCategoryOpen then
			setDailyModeOpen(not dailyModeOpen)
		end
	end)

	for _, option in ipairs(dailyModeButtons) do
		option.MouseButton1Click:Connect(function()
			dailyDealMode = option.Text
			dailyModeButton.Text = dailyDealMode
			for _, sibling in ipairs(dailyModeButtons) do
				local selected = sibling == option
				sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				sibling.BackgroundTransparency = selected and 0.1 or 0.35
			end
			screenGui:SetAttribute("DailyDealMode", dailyDealMode)
			setDailyModeOpen(false)
		end)
	end

	dailyCountInput.FocusLost:Connect(commitDailyCount)

	useDailyToggle.MouseButton1Click:Connect(function()
		commitDailyCount()
		useDailyDeal = not useDailyDeal
		screenGui:SetAttribute("UseDailyDeal", useDailyDeal)
		screenGui:SetAttribute("DailyDealStatus", useDailyDeal
			and (autoSellEnabled and "Checking" or "Waiting for Start Selling") or "Disabled")
		TweenService:Create(useDailyToggle, TweenInfo.new(0.18), {
			BackgroundColor3 = useDailyDeal and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(useDailyKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = useDailyDeal and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end)

	dailyHeader.MouseButton1Click:Connect(function()
		dailyCategoryOpen = not dailyCategoryOpen
		if not dailyCategoryOpen then
			setDailyModeOpen(false)
		end
		TweenService:Create(dailyContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, dailyCategoryOpen and dailyBaseHeight or 0),
		}):Play()
		TweenService:Create(dailyArrow, TweenInfo.new(0.18), {Rotation = dailyCategoryOpen and 180 or 0}):Play()
	end)

	screenGui:SetAttribute("UseDailyDeal", useDailyDeal)
	screenGui:SetAttribute("DailyDealMode", dailyDealMode)
	screenGui:SetAttribute("DailyDealCount", dailyDealCount)

	selectButton.MouseButton1Click:Connect(function()
		if dropdownOpen then
			setOptionsOpen(not optionsOpen)
		end
	end)

	rarityButton.MouseButton1Click:Connect(function()
		if dropdownOpen then
			setRarityOpen(not rarityOpen)
		end
	end)

	methodButton.MouseButton1Click:Connect(function()
		if dropdownOpen then
			setMethodOpen(not methodOpen)
		end
	end)

	sectionConnection = section.MouseButton1Click:Connect(function()
		dropdownOpen = not dropdownOpen
		if not dropdownOpen then
			optionsOpen = false
			rarityOpen = false
			methodOpen = false
			optionsPanel.Size = UDim2.new(0.38, -7, 0, 0)
			rarityPanel.Size = UDim2.new(0.38, -7, 0, 0)
			methodPanel.Size = UDim2.new(0.38, -7, 0, 0)
			selectArrow.Rotation = 0
			rarityArrow.Rotation = 0
			methodArrow.Rotation = 0
		end
		local targetHeight = dropdownOpen and categoryBaseHeight or 0
		TweenService:Create(categoryContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
		TweenService:Create(arrow, TweenInfo.new(0.18), {Rotation = dropdownOpen and 180 or 0}):Play()
	end)
end

for tabName, ref in pairs(tabRefs) do
	ref.button.MouseButton1Click:Connect(function()
		if tabName == "Info" then
			showInfo()
		elseif tabName == "Farm" then
			showFarm()
		end
	end)
end

showInfo()

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

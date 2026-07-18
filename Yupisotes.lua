local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local runtime = (getgenv and getgenv()) or _G
runtime.YupisotesGeneration = (runtime.YupisotesGeneration or 0) + 1
if runtime.YupisotesToggleDragChanged then runtime.YupisotesToggleDragChanged:Disconnect() end
if runtime.YupisotesToggleDragEnded then runtime.YupisotesToggleDragEnded:Disconnect() end
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
main.BackgroundTransparency = 0.03
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 12)
runtime.YupisotesUIToggle = Instance.new("ImageButton")
runtime.YupisotesUIToggle.Name = "CatUIToggle"
runtime.YupisotesUIToggle.AutoButtonColor = false
runtime.YupisotesUIToggle.Image = "rbxthumb://type=Asset&id=7111868109&w=150&h=150"
runtime.YupisotesUIToggle.ScaleType = Enum.ScaleType.Crop
runtime.YupisotesUIToggle.BackgroundColor3 = rgb(13, 16, 16)
runtime.YupisotesUIToggle.BorderSizePixel = 0
runtime.YupisotesUIToggle.AnchorPoint = Vector2.new(0, 0.5)
runtime.YupisotesTogglePosition = runtime.YupisotesTogglePosition or UDim2.new(0, 16, 0.5, 0)
runtime.YupisotesUIToggle.Position = runtime.YupisotesTogglePosition
runtime.YupisotesUIToggle.Size = UDim2.fromOffset(56, 56)
runtime.YupisotesUIToggle.ZIndex = 500
runtime.YupisotesUIToggle.Parent = screenGui
corner(runtime.YupisotesUIToggle, 16)
stroke(runtime.YupisotesUIToggle, palette.accent, 0.05, 2)
runtime.YupisotesUIToggleScale = Instance.new("UIScale")
runtime.YupisotesUIToggleScale.Scale = 1
runtime.YupisotesUIToggleScale.Parent = runtime.YupisotesUIToggle
runtime.YupisotesToggleDrag = {dragging = false, moved = false}
runtime.YupisotesUIToggle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
runtime.YupisotesToggleDrag.dragging = true
runtime.YupisotesToggleDrag.moved = false
runtime.YupisotesToggleDrag.input = input
runtime.YupisotesToggleDrag.start = input.Position
runtime.YupisotesToggleDrag.position = runtime.YupisotesUIToggle.Position
end
end)
runtime.YupisotesMoveToggle = function(input)
if not runtime.YupisotesToggleDrag.dragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement and input ~= runtime.YupisotesToggleDrag.input then return end
local delta = input.Position - runtime.YupisotesToggleDrag.start
if delta.Magnitude > 5 then runtime.YupisotesToggleDrag.moved = true end
local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local x = math.clamp(runtime.YupisotesToggleDrag.position.X.Offset + delta.X, 8, math.max(8, viewport.X - 64))
local centerY = viewport.Y * 0.5 + runtime.YupisotesToggleDrag.position.Y.Offset + delta.Y
local y = math.clamp(centerY, 36, math.max(36, viewport.Y - 36)) - viewport.Y * 0.5
runtime.YupisotesTogglePosition = UDim2.new(0, x, 0.5, y)
runtime.YupisotesUIToggle.Position = runtime.YupisotesTogglePosition
end
runtime.YupisotesToggleDragChanged = UserInputService.InputChanged:Connect(runtime.YupisotesMoveToggle)
runtime.YupisotesToggleDragEnded = UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input == runtime.YupisotesToggleDrag.input then
runtime.YupisotesToggleDrag.dragging = false
runtime.YupisotesToggleDrag.input = nil
end
end)
runtime.YupisotesUIToggle.MouseEnter:Connect(function()
TweenService:Create(runtime.YupisotesUIToggleScale, TweenInfo.new(0.12), {Scale = 1.08}):Play()
end)
runtime.YupisotesUIToggle.MouseLeave:Connect(function()
TweenService:Create(runtime.YupisotesUIToggleScale, TweenInfo.new(0.12), {Scale = 1}):Play()
end)
runtime.YupisotesUIToggle.MouseButton1Click:Connect(function()
if runtime.YupisotesToggleDrag.moved then return end
main.Visible = not main.Visible
screenGui:SetAttribute("WindowOpen", main.Visible)
end)
screenGui:SetAttribute("WindowOpen", true)
local top = Instance.new("Frame")
top.Name = "TopBar"
top.BackgroundColor3 = rgb(3, 6, 5)
top.BackgroundTransparency = 0.05
top.BorderSizePixel = 0
top.Size = UDim2.new(1, 0, 0, 44)
top.Parent = main
corner(top, 12)
local topBottomFill = Instance.new("Frame")
topBottomFill.BackgroundColor3 = top.BackgroundColor3
topBottomFill.BackgroundTransparency = top.BackgroundTransparency
topBottomFill.BorderSizePixel = 0
topBottomFill.Position = UDim2.new(0, 0, 1, -12)
topBottomFill.Size = UDim2.new(1, 0, 0, 12)
topBottomFill.Parent = top
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
minimize.BackgroundColor3 = rgb(27, 30, 34)
minimize.BackgroundTransparency = 1
minimize.Position = UDim2.new(1, -58, 0, 9)
minimize.Size = UDim2.fromOffset(24, 24)
minimize.Parent = top
local close = Instance.new("TextButton")
close.BackgroundTransparency = 1
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 15
close.TextColor3 = palette.text
close.BackgroundColor3 = rgb(106, 35, 53)
close.BackgroundTransparency = 1
close.Position = UDim2.new(1, -30, 0, 9)
close.Size = UDim2.fromOffset(24, 24)
close.Parent = top
corner(minimize, 4)
corner(close, 4)
minimize.MouseEnter:Connect(function()
TweenService:Create(minimize, TweenInfo.new(0.12), {BackgroundTransparency = 0.25}):Play()
end)
minimize.MouseLeave:Connect(function()
TweenService:Create(minimize, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
end)
close.MouseEnter:Connect(function()
TweenService:Create(close, TweenInfo.new(0.12), {BackgroundTransparency = 0.12}):Play()
end)
close.MouseLeave:Connect(function()
TweenService:Create(close, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
end)
close.MouseButton1Click:Connect(function()
main.Visible = false
screenGui:SetAttribute("WindowOpen", false)
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
local sidebarDivider = Instance.new("Frame")
sidebarDivider.BackgroundColor3 = rgb(62, 48, 72)
sidebarDivider.BackgroundTransparency = 0.58
sidebarDivider.BorderSizePixel = 0
sidebarDivider.Position = UDim2.new(1, -1, 0, 2)
sidebarDivider.Size = UDim2.new(0, 1, 1, -4)
sidebarDivider.Parent = sidebar
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
title.Position = UDim2.fromOffset(11, 1)
title.Size = UDim2.new(1, -11, 0, 30)
local titleMarker = Instance.new("Frame")
titleMarker.BackgroundColor3 = palette.accent
titleMarker.BorderSizePixel = 0
titleMarker.Position = UDim2.fromOffset(0, 7)
titleMarker.Size = UDim2.fromOffset(4, 17)
titleMarker.Parent = content
corner(titleMarker, 2)
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
local selectedPlantRarities = {}
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
local advancedSellMode = "Above"
local advancedSellTarget = 1.01
local advancedSellEnabled = false
local advancedSellRunId = 0
local doubleTriggerCount = 100
local doubleUseBackpackMax = false
local doubleTargetWins = 1
local doubleEnabled = false
local doubleRunId = 0
local doubleCycleActive = false
local favoriteSelectedRarities = {}
local favoriteExcludedFruits = {}
local favoriteSelectedMutations = {}
local favoriteKg = 0
local favoriteKgDirection = "Up"
local autoFavoriteEnabled = false
local autoFavoriteRunId = 0
local selectedShovelPlants = {}
local selectedShovelRarities = {}
local shovelSpeed = 0
local autoShovelEnabled = false
local autoShovelRunId = 0
local shovelPending = {}
local selectedShovelFruits = {}
local selectedShovelFruitRarities = {}
local shovelFruitKg = 0
local shovelFruitKgDirection = "Up"
local autoShovelFruitEnabled = false
local autoShovelFruitRunId = 0
local shovelFruitPending = {}
local selectedTrowelPlants = {}
local selectedTrowelRarities = {}
local trowelPositionMode = "Random Plot Position"
local savedTrowelPosition = nil
local trowelDelay = 1
local autoTrowelEnabled = false
local autoTrowelRunId = 0
local trowelPending = {}
local collectedSeedSelection = "Server"
local collectedSeedDelay = 0.5
local autoCollectDroppedSeedEnabled = false
local autoCollectDroppedSeedRunId = 0
local droppedSeedPending = {}
local selectedSellPetNames = {}
local selectedSellPetRarities = {}
local blacklistedPetVariants = {Big = true, Huge = true, Rainbow = true, Mega = true}
local sellPetDelay = 0.5
local autoSellPetEnabled = false
local autoSellPetRunId = 0
local sellPetPending = {}
local selectedLeaveWeathers = {}
local autoLeaveWeatherEnabled = false
local autoLeaveWeatherRunId = 0
local dailyDealMode = "Full Inventory"
local dailyDealCount = 100
local useDailyDeal = false
runtime.YupisotesShopState = {
	selectedSeeds = {},
	selectedRarities = {},
	buyAmount = 1,
	limitedEnabled = false,
	alwaysEnabled = false,
	runId = 0,
	purchasedThisRestock = {},
	restockId = nil,
	selectedGear = {},
	gearBuyAmount = 1,
	gearLimitedEnabled = false,
	gearAlwaysEnabled = false,
	gearRunId = 0,
	gearPurchasedThisRestock = {},
	gearRestockId = nil,
	selectedProps = {},
	propsBuyAmount = 1,
	propsLimitedEnabled = false,
	propsAlwaysEnabled = false,
	propsRunId = 0,
	propsPurchasedThisRestock = {},
	propsRestockId = nil,
	auctionSelections = {Seeds = {}, Gear = {}, SeedPacks = {}, Eggs = {}},
	auctionPriceMode = "Below",
	auctionPriceLimit = 0,
	auctionBuyLotCount = 2,
	auctionEnabled = false,
	auctionRunId = 0,
	auctionCycleId = nil,
	auctionBought = {},
	auctionRefreshId = 0,
}
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
section.Visible = true
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
local favoriteFruitOptions = {}
for index = 2, #plantOptions do
table.insert(favoriteFruitOptions, plantOptions[index])
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
local petData = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetData"))
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
local hasRarityFilter = next(selectedPlantRarities) ~= nil
local matches = hasRarityFilter and selectedPlantRarities[seedRarities[seedName]] == true
or not hasRarityFilter and (selectedPlant == "All Seeds" or seedName == selectedPlant)
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
local function getFruitStockEntries()
local ok, snapshot = pcall(function()
return networking.FruitStock.Request:Fire()
end)
if not ok or type(snapshot) ~= "table" or type(snapshot.entries) ~= "table" then
return nil
end
return snapshot.entries
end
local function getAdvancedSellTargets(entries)
local targets = {}
local seen = {}
local function scan(container)
if not container then
return
end
for _, item in ipairs(container:GetChildren()) do
local fruitName = item:GetAttribute("FruitName") or item:GetAttribute("Fruit")
local fruitId = item:GetAttribute("Id") or item:GetAttribute("FruitId")
local stock = type(fruitName) == "string" and entries[fruitName] or nil
local multiplier = type(stock) == "table" and tonumber(stock.multiplier) or nil
local matches = multiplier and (advancedSellMode == "Above"
and multiplier >= advancedSellTarget or multiplier <= advancedSellTarget)
if matches and fruitId and not seen[fruitId] and item:GetAttribute("IsFavorite") ~= true then
seen[fruitId] = true
table.insert(targets, {
id = fruitId,
name = fruitName,
multiplier = multiplier,
})
end
end
end
scan(player:FindFirstChildOfClass("Backpack"))
scan(player.Character)
return targets
end
local function runAdvancedSell(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while advancedSellEnabled and advancedSellRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local entries = getFruitStockEntries()
if not entries then
screenGui:SetAttribute("AdvancedSellStatus", "Price data unavailable")
else
local targets = getAdvancedSellTargets(entries)
local sold = 0
for _, target in ipairs(targets) do
if not advancedSellEnabled or advancedSellRunId ~= runId then
break
end
local ok, result = pcall(function()
return networking.NPCS.SellFruit:Fire(target.id)
end)
if ok and type(result) == "table" and result.Success == true then
sold += 1
screenGui:SetAttribute("LastAdvancedSoldFruit", target.name)
screenGui:SetAttribute("LastAdvancedSoldMultiplier", target.multiplier)
end
task.wait(0.12)
end
screenGui:SetAttribute("LastAdvancedSellCount", sold)
screenGui:SetAttribute("AdvancedSellStatus", sold > 0 and "Sold" or "No matching fruit")
end
task.wait(1)
end
end)
end
local function cashOutDoubleOrNothing(status)
if not doubleCycleActive then
return false
end
local ok, result = pcall(function()
return networking.NPCS.CashOutDoubleOrNothing:Fire()
end)
doubleCycleActive = false
local success = ok and type(result) == "table" and result.Success == true
screenGui:SetAttribute("DoubleOrNothingStatus", success and (status or "Cashed out") or "Cash out failed")
if success then
screenGui:SetAttribute("LastDoubleWins", tonumber(result.Wins) or 0)
screenGui:SetAttribute("LastDoubleSellPrice", tonumber(result.SellPrice) or 0)
screenGui:SetAttribute("LastDoubleSoldCount", tonumber(result.SoldCount) or 0)
end
return success
end
local function stopDoubleOrNothing(status)
doubleEnabled = false
doubleRunId += 1
screenGui:SetAttribute("DoubleOrNothingEnabled", false)
if doubleCycleActive then
cashOutDoubleOrNothing(status or "Stopped and cashed out")
else
screenGui:SetAttribute("DoubleOrNothingStatus", status or "Stopped")
end
end
local function runDoubleOrNothing(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while doubleEnabled and doubleRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local fruitCount = previewSellInventory()
local requiredCount = doubleUseBackpackMax
and (tonumber(player:GetAttribute("MaxFruitCapacity")) or 100) or doubleTriggerCount
screenGui:SetAttribute("DoubleBackpackCount", fruitCount)
screenGui:SetAttribute("DoubleRequiredCount", requiredCount)
if fruitCount <= 0 or fruitCount < requiredCount then
screenGui:SetAttribute("DoubleOrNothingStatus", "Waiting for " .. tostring(requiredCount) .. " fruits")
task.wait(1)
continue
end
local wins = 0
screenGui:SetAttribute("DoubleOrNothingStatus", "Rolling")
repeat
local ok, result = pcall(function()
return networking.NPCS.DoubleOrNothing:Fire()
end)
if not ok or type(result) ~= "table" then
if doubleCycleActive then
cashOutDoubleOrNothing("Error, cashed out")
else
screenGui:SetAttribute("DoubleOrNothingStatus", "Roll failed")
end
break
end
if result.Busted == true then
doubleCycleActive = false
wins = tonumber(result.Wins) or wins
screenGui:SetAttribute("LastDoubleWins", wins)
screenGui:SetAttribute("DoubleOrNothingStatus", "Busted")
break
elseif result.Won == true then
doubleCycleActive = true
wins = tonumber(result.Wins) or (wins + 1)
screenGui:SetAttribute("CurrentDoubleWins", wins)
screenGui:SetAttribute("CurrentDoublePot", tonumber(result.Pot) or 0)
screenGui:SetAttribute("DoubleOrNothingStatus", "Won " .. tostring(wins) .. "/" .. tostring(doubleTargetWins))
if wins >= doubleTargetWins then
cashOutDoubleOrNothing("Target reached, cashed out")
break
end
else
local reason = tostring(result.Reason or "Unavailable")
if doubleCycleActive then
cashOutDoubleOrNothing("Stopped: " .. reason)
else
screenGui:SetAttribute("DoubleOrNothingStatus", reason)
end
break
end
task.wait(0.5)
until not doubleEnabled or doubleRunId ~= runId
if (not doubleEnabled or doubleRunId ~= runId) and doubleCycleActive then
cashOutDoubleOrNothing("Stopped and cashed out")
end
task.wait(1)
end
end)
end
local function favoriteMutationMatches(mutationText)
if selectionCount(favoriteSelectedMutations) == 0 then
return true
end
if type(mutationText) ~= "string" or mutationText == "" then
return favoriteSelectedMutations.Normal == true
end
for mutation in string.gmatch(mutationText, "[^%+%,]+") do
mutation = string.gsub(mutation, "^%s*(.-)%s*$", "%1")
if favoriteSelectedMutations[mutation] then
return true
end
end
return false
end
local function getFavoriteTargets(onlyFavorited)
local targets = {}
local seen = {}
local function scan(container)
if not container then
return
end
for _, item in ipairs(container:GetChildren()) do
local fruitName = item:GetAttribute("FruitName") or item:GetAttribute("Fruit")
local fruitId = item:GetAttribute("Id") or item:GetAttribute("FruitId")
local isFavorite = item:GetAttribute("IsFavorite") == true
if type(fruitName) == "string" and fruitId and not seen[fruitId]
and ((onlyFavorited and isFavorite) or (not onlyFavorited and not isFavorite)) then
local rarity = seedRarities[fruitName] or "Common"
local weight = tonumber(item:GetAttribute("Weight")) or 0
local rarityAllowed = selectionCount(favoriteSelectedRarities) == 0
or favoriteSelectedRarities[rarity] == true
local mutationAllowed = favoriteMutationMatches(item:GetAttribute("Mutation"))
local weightAllowed = favoriteKgDirection == "Up" and weight >= favoriteKg or weight < favoriteKg
local nameAllowed = favoriteExcludedFruits[fruitName] ~= true
if onlyFavorited or (rarityAllowed and mutationAllowed and weightAllowed and nameAllowed) then
seen[fruitId] = true
table.insert(targets, {id = fruitId, tool = item, name = fruitName})
end
end
end
end
scan(player:FindFirstChildOfClass("Backpack"))
scan(player.Character)
return targets
end
local function setFruitFavorite(target, state)
local previous = target.tool:GetAttribute("IsFavorite") == true
target.tool:SetAttribute("IsFavorite", state and true or nil)
local ok, result = pcall(function()
return networking.Backpack.SetFruitFavorite:Fire(target.id, state)
end)
local success = ok and result ~= false
if not success and target.tool.Parent then
target.tool:SetAttribute("IsFavorite", previous and true or nil)
end
return success
end
local function runAutoFavorite(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while autoFavoriteEnabled and autoFavoriteRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local targets = getFavoriteTargets(false)
local favorited = 0
for _, target in ipairs(targets) do
if not autoFavoriteEnabled or autoFavoriteRunId ~= runId then
break
end
if setFruitFavorite(target, true) then
favorited += 1
screenGui:SetAttribute("LastFavoritedFruit", target.name)
end
task.wait(0.08)
end
screenGui:SetAttribute("LastAutoFavoriteCount", favorited)
screenGui:SetAttribute("AutoFavoriteStatus", favorited > 0 and "Favorited" or "Waiting for matching fruit")
task.wait(1)
end
end)
end
local function unfavoriteAllFruit()
autoFavoriteEnabled = false
autoFavoriteRunId += 1
screenGui:SetAttribute("AutoFavoriteEnabled", false)
local targets = getFavoriteTargets(true)
local changed = 0
for _, target in ipairs(targets) do
if setFruitFavorite(target, false) then
changed += 1
end
task.wait(0.08)
end
screenGui:SetAttribute("LastUnfavoriteCount", changed)
screenGui:SetAttribute("AutoFavoriteStatus", "Unfavorited " .. tostring(changed))
return changed
end
local function getShovelTool()
for _, container in ipairs({player.Character, player:FindFirstChildOfClass("Backpack")}) do
if container then
for _, item in ipairs(container:GetChildren()) do
if item:IsA("Tool") and type(item:GetAttribute("Shovel")) == "string" then
return item
end
end
end
end
return nil
end
local function getShovelTargets(plot)
local targets = {}
local plants = plot and plot:FindFirstChild("Plants")
if not plants or selectionCount(selectedShovelPlants) == 0 then
return targets
end
for _, model in ipairs(plants:GetChildren()) do
local plantId = model:GetAttribute("PlantId")
local seedName = model:GetAttribute("SeedName")
local ownerId = tonumber(model:GetAttribute("UserId"))
local rarity = type(seedName) == "string" and (seedRarities[seedName] or "Common") or nil
local rarityAllowed = selectionCount(selectedShovelRarities) == 0
or selectedShovelRarities[rarity] == true
local pendingUntil = plantId and shovelPending[plantId] or nil
if pendingUntil and os.clock() >= pendingUntil then
shovelPending[plantId] = nil
pendingUntil = nil
end
if plantId and seedName and ownerId == player.UserId and selectedShovelPlants[seedName]
and rarityAllowed and not pendingUntil then
table.insert(targets, {id = plantId, name = seedName})
end
end
table.sort(targets, function(a, b)
return a.name < b.name
end)
return targets
end
local function runAutoShovel(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while autoShovelEnabled and autoShovelRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local shovel = getShovelTool()
local plot = getPlayerPlot()
local targets = getShovelTargets(plot)
if not shovel then
screenGui:SetAttribute("AutoShovelStatus", "Shovel unavailable")
elseif #targets == 0 then
screenGui:SetAttribute("AutoShovelStatus", selectionCount(selectedShovelPlants) == 0
and "Select at least one plant" or "Waiting for matching plants")
else
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if humanoid and shovel.Parent ~= player.Character then
humanoid:EquipTool(shovel)
task.wait(0.05)
end
local removed = 0
for _, target in ipairs(targets) do
if not autoShovelEnabled or autoShovelRunId ~= runId then
break
end
if shovel.Parent ~= player.Character and humanoid then
humanoid:EquipTool(shovel)
task.wait(0.03)
end
shovelPending[target.id] = os.clock() + 2
local ok = pcall(function()
networking.Shovel.UseShovel:Fire(target.id, "", shovel:GetAttribute("Shovel"), shovel)
end)
if ok then
removed += 1
screenGui:SetAttribute("LastShoveledPlant", target.name)
end
task.wait(math.max(0.05, shovelSpeed * 0.08))
end
screenGui:SetAttribute("LastAutoShovelCount", removed)
screenGui:SetAttribute("AutoShovelStatus", removed > 0 and "Shoveling" or "Waiting")
end
task.wait(0.25)
end
end)
end
local function getShovelFruitTargets(plot)
local targets = {}
local seen = {}
local plants = plot and plot:FindFirstChild("Plants")
if not plants or selectionCount(selectedShovelFruits) == 0 then
return targets
end
for _, plant in ipairs(plants:GetChildren()) do
if tonumber(plant:GetAttribute("UserId")) == player.UserId then
for _, model in ipairs(plant:GetDescendants()) do
local fruitId = model:GetAttribute("FruitId")
local plantId = model:GetAttribute("PlantId") or plant:GetAttribute("PlantId")
local fruitName = model:GetAttribute("CorePartName") or plant:GetAttribute("SeedName")
local ownerId = tonumber(model:GetAttribute("UserId"))
local pendingUntil = fruitId and shovelFruitPending[fruitId] or nil
if pendingUntil and os.clock() >= pendingUntil then
shovelFruitPending[fruitId] = nil
pendingUntil = nil
end
if fruitId and plantId and fruitName and ownerId == player.UserId and not seen[fruitId]
and selectedShovelFruits[fruitName] and not pendingUntil then
local rarity = seedRarities[fruitName] or "Common"
local rarityAllowed = selectionCount(selectedShovelFruitRarities) == 0
or selectedShovelFruitRarities[rarity] == true
local weight = getHarvestWeight(model, fruitName)
local weightAllowed = shovelFruitKgDirection == "Up"
and weight >= shovelFruitKg or weight < shovelFruitKg
if rarityAllowed and weightAllowed then
seen[fruitId] = true
table.insert(targets, {
plantId = plantId,
fruitId = fruitId,
name = fruitName,
weight = weight,
})
end
end
end
end
end
return targets
end
local function runAutoShovelFruit(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while autoShovelFruitEnabled and autoShovelFruitRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local shovel = getShovelTool()
local targets = getShovelFruitTargets(getPlayerPlot())
if not shovel then
screenGui:SetAttribute("AutoShovelFruitStatus", "Shovel unavailable")
elseif #targets == 0 then
screenGui:SetAttribute("AutoShovelFruitStatus", selectionCount(selectedShovelFruits) == 0
and "Select at least one fruit" or "Waiting for matching fruits")
else
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if humanoid and shovel.Parent ~= player.Character then
humanoid:EquipTool(shovel)
task.wait(0.08)
end
local removed = 0
for _, target in ipairs(targets) do
if not autoShovelFruitEnabled or autoShovelFruitRunId ~= runId then break end
if shovel.Parent ~= player.Character and humanoid then
humanoid:EquipTool(shovel)
task.wait(0.05)
end
shovelFruitPending[target.fruitId] = os.clock() + 2
local ok = pcall(function()
networking.Shovel.UseShovel:Fire(
target.plantId,
target.fruitId,
shovel:GetAttribute("Shovel"),
shovel
)
end)
if ok then
removed += 1
screenGui:SetAttribute("LastShoveledFruit", target.name)
screenGui:SetAttribute("LastShoveledFruitKg", target.weight)
end
task.wait(math.max(0.08, shovelSpeed * 0.1))
end
screenGui:SetAttribute("LastAutoShovelFruitCount", removed)
screenGui:SetAttribute("AutoShovelFruitStatus", removed > 0 and "Shoveling fruits" or "Waiting")
end
task.wait(0.5)
end
end)
end
local function getTrowelTool()
for _, container in ipairs({player.Character, player:FindFirstChildOfClass("Backpack")}) do
if container then
for _, item in ipairs(container:GetChildren()) do
if item:IsA("Tool") and type(item:GetAttribute("Trowel")) == "string" then
return item
end
end
end
end
return nil
end
local function getTrowelTargets(plot)
local targets = {}
local plants = plot and plot:FindFirstChild("Plants")
if not plants or selectionCount(selectedTrowelPlants) == 0 then
return targets
end
for _, model in ipairs(plants:GetChildren()) do
local seedName = model:GetAttribute("SeedName")
local ownerId = tonumber(model:GetAttribute("UserId"))
local plantId = model:GetAttribute("PlantId") or model.Name
local rarity = type(seedName) == "string" and (seedRarities[seedName] or "Common") or nil
local rarityAllowed = selectionCount(selectedTrowelRarities) == 0
or selectedTrowelRarities[rarity] == true
local pendingUntil = trowelPending[plantId]
if pendingUntil and os.clock() >= pendingUntil then
trowelPending[plantId] = nil
pendingUntil = nil
end
if plantId and seedName and ownerId == player.UserId and selectedTrowelPlants[seedName]
and rarityAllowed and not pendingUntil then
table.insert(targets, {id = plantId, name = seedName, model = model})
end
end
table.sort(targets, function(a, b)
return a.name < b.name
end)
return targets
end
local function getPlotGroundPosition(plot, worldPosition)
local reference = plot and plot:FindFirstChild("PlotSizeReference")
if not reference or not reference:IsA("BasePart") then
return nil
end
local localPoint = reference.CFrame:PointToObjectSpace(worldPosition)
local half = reference.Size / 2
if math.abs(localPoint.X) > half.X or math.abs(localPoint.Z) > half.Z then
return nil
end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Include
params.FilterDescendantsInstances = {plot}
local origin = Vector3.new(worldPosition.X, reference.Position.Y + 500, worldPosition.Z)
local result = workspace:Raycast(origin, Vector3.new(0, -1000, 0), params)
if result and result.Instance:HasTag("PlantArea") then
return result.Position
end
return nil
end
local function getRandomPlotPosition(plot)
local reference = plot and plot:FindFirstChild("PlotSizeReference")
if not reference or not reference:IsA("BasePart") then
return nil
end
for _ = 1, 20 do
local x = (math.random() * 2 - 1) * reference.Size.X * 0.45
local z = (math.random() * 2 - 1) * reference.Size.Z * 0.45
local worldPoint = reference.CFrame:PointToWorldSpace(Vector3.new(x, 0, z))
local ground = getPlotGroundPosition(plot, worldPoint)
if ground then return ground end
end
return nil
end
local function resolveTrowelPosition(plot)
if trowelPositionMode == "Saved Position" then
return savedTrowelPosition and getPlotGroundPosition(plot, savedTrowelPosition) or nil
elseif trowelPositionMode == "Around Player" then
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
for _ = 1, 12 do
local angle = math.random() * math.pi * 2
local radius = 4 + math.random() * 8
local point = root.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
local ground = getPlotGroundPosition(plot, point)
if ground then return ground end
end
return nil
end
return getRandomPlotPosition(plot)
end
local function runAutoTrowel(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while autoTrowelEnabled and autoTrowelRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local plot = getPlayerPlot()
local trowel = getTrowelTool()
local targets = getTrowelTargets(plot)
if not trowel then
screenGui:SetAttribute("AutoTrowelStatus", "Trowel unavailable")
elseif #targets == 0 then
screenGui:SetAttribute("AutoTrowelStatus", selectionCount(selectedTrowelPlants) == 0
and "Select at least one plant" or "Waiting for matching plants")
elseif trowelPositionMode == "Saved Position" and not savedTrowelPosition then
screenGui:SetAttribute("AutoTrowelStatus", "Set a trowel position first")
else
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if humanoid and trowel.Parent ~= player.Character then
humanoid:EquipTool(trowel)
task.wait(0.08)
end
local moved = 0
for _, target in ipairs(targets) do
if not autoTrowelEnabled or autoTrowelRunId ~= runId then break end
local destination = resolveTrowelPosition(plot)
if destination then
local _, rotationY = target.model:GetPivot():ToEulerAnglesYXZ()
trowelPending[target.id] = os.clock() + math.max(2, trowelDelay + 1)
local ok = pcall(function()
networking.Trowel.MovePlant:Fire(target.id, destination, math.deg(rotationY))
end)
if ok then
moved += 1
screenGui:SetAttribute("LastTroweledPlant", target.name)
screenGui:SetAttribute("LastTrowelPosition", tostring(destination))
end
else
screenGui:SetAttribute("AutoTrowelStatus", "No valid plot position")
end
task.wait(math.max(0.05, trowelDelay))
end
screenGui:SetAttribute("LastAutoTrowelCount", moved)
screenGui:SetAttribute("AutoTrowelStatus", moved > 0 and "Moving plants" or "Waiting")
end
task.wait(0.5)
end
end)
end
local function getDroppedSeedName(part)
if part:GetAttribute("RainbowSeed") == true then return "Rainbow Seed" end
if part:GetAttribute("GoldSeed") == true then return "Gold Seed" end
if part:GetAttribute("MegaSeed") == true then return "Mega Seed" end
local seedPack = part:GetAttribute("SeedPack")
if type(seedPack) == "string" and seedPack ~= "" then return seedPack end
return nil
end
local function isSpecialDroppedSeed(part)
return part:GetAttribute("RainbowSeed") == true
or part:GetAttribute("GoldSeed") == true
or part:GetAttribute("MegaSeed") == true
end
local function isUserDroppedSeed(part)
for _, attributeName in ipairs({"UserId", "OwnerUserId", "OwnerId", "PlayerUserId"}) do
local value = part:GetAttribute(attributeName)
if value ~= nil then return tonumber(value) == player.UserId end
end
for _, attributeName in ipairs({"Owner", "PlayerName", "Username"}) do
local value = part:GetAttribute(attributeName)
if value ~= nil then
return tostring(value) == player.Name or tonumber(value) == player.UserId
end
end
local loweredName = string.lower(part.Name)
if string.find(loweredName, tostring(player.UserId), 1, true)
or string.find(loweredName, string.lower(player.Name), 1, true) then
return true
end
-- Some drops omit ownership metadata client-side; the server still validates the claimant.
return true
end
local function getDroppedSeedTargets()
local map = workspace:FindFirstChild("Map")
local folder = map and map:FindFirstChild("SeedPackSpawnServerLocations")
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local targets = {}
if not folder or not root then return targets end
for _, item in ipairs(folder:GetChildren()) do
if item:IsA("BasePart") then
local seedName = getDroppedSeedName(item)
local special = isSpecialDroppedSeed(item)
local matches = (collectedSeedSelection == "Server" and special)
or (collectedSeedSelection == "User" and not special and seedName ~= nil and isUserDroppedSeed(item))
local pendingUntil = droppedSeedPending[item]
if pendingUntil and (not item.Parent or os.clock() >= pendingUntil) then
droppedSeedPending[item] = nil
pendingUntil = nil
end
if matches and not pendingUntil and (item.Position - root.Position).Magnitude <= 250 then
table.insert(targets, {part = item, name = seedName, distance = (item.Position - root.Position).Magnitude})
end
end
end
table.sort(targets, function(a, b) return a.distance < b.distance end)
return targets
end
local function touchDroppedSeed(root, part)
if not root or not root.Parent or not part or not part.Parent then return false end
if firetouchinterest then
local ok = pcall(function()
firetouchinterest(root, part, 0)
task.wait(0.03)
firetouchinterest(root, part, 1)
end)
if ok then return true end
end
local original = root.CFrame
local ok = pcall(function()
root.CFrame = part.CFrame + Vector3.new(0, 2, 0)
task.wait(0.08)
root.CFrame = original
end)
return ok
end
local function runAutoCollectDroppedSeed(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while autoCollectDroppedSeedEnabled and autoCollectDroppedSeedRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local targets = getDroppedSeedTargets()
local collected = 0
if not root then
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", "Character unavailable")
elseif #targets == 0 then
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", "Waiting for nearby dropped seeds")
else
for _, target in ipairs(targets) do
if not autoCollectDroppedSeedEnabled or autoCollectDroppedSeedRunId ~= runId then break end
droppedSeedPending[target.part] = os.clock() + 2
if touchDroppedSeed(root, target.part) then
collected += 1
screenGui:SetAttribute("LastCollectedDroppedSeed", target.name)
end
task.wait(math.max(0.05, collectedSeedDelay))
end
screenGui:SetAttribute("LastCollectedDroppedSeedCount", collected)
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", collected > 0 and "Collecting seeds" or "Waiting")
end
task.wait(math.max(0.1, collectedSeedDelay))
end
end)
end
local function getInventoryPetNames()
local names = {}
for _, container in ipairs({player:FindFirstChildOfClass("Backpack"), player.Character}) do
if container then
for _, item in ipairs(container:GetChildren()) do
local petName = item:IsA("Tool") and item:GetAttribute("Pet") or nil
if type(petName) == "string" and petName ~= "" then names[petName] = true end
end
end
end
-- Keep active filters visible after the last pet of that species is sold.
for name in pairs(selectedSellPetNames) do names[name] = true end
local result = {}
for name in pairs(names) do table.insert(result, name) end
table.sort(result)
return result
end
local function getPetVariant(tool, petName)
for _, attributeName in ipairs({"PetSize", "Size", "Variant", "PetType", "Type"}) do
local value = tool:GetAttribute(attributeName)
if type(value) == "string" then
local lowered = string.lower(value)
if lowered == "big" then return "Big" end
if lowered == "huge" then return "Huge" end
if lowered == "rainbow" then return "Rainbow" end
end
end
local visibleName = string.lower(tool.Name)
if string.find(visibleName, "huge", 1, true) then return "Huge" end
if string.find(visibleName, "big", 1, true) then return "Big" end
if string.find(visibleName, "rainbow", 1, true) then return "Rainbow" end
return "Normal"
end
local function getSellPetTargets()
local targets = {}
if selectionCount(selectedSellPetNames) == 0 and selectionCount(selectedSellPetRarities) == 0 then
return targets
end
for _, container in ipairs({player:FindFirstChildOfClass("Backpack"), player.Character}) do
if container then
for _, tool in ipairs(container:GetChildren()) do
local petName = tool:IsA("Tool") and tool:GetAttribute("Pet") or nil
local petId = tool:IsA("Tool") and tool:GetAttribute("PetId") or nil
if type(petName) == "string" and type(petId) == "string" and petId ~= "" then
local rarity = type(petData[petName]) == "table" and petData[petName].Rarity or "Common"
local variant = getPetVariant(tool, petName)
local nameAllowed = selectionCount(selectedSellPetNames) == 0 or selectedSellPetNames[petName] == true
local rarityAllowed = selectionCount(selectedSellPetRarities) == 0 or selectedSellPetRarities[rarity] == true
local pendingUntil = sellPetPending[petId]
if pendingUntil and os.clock() >= pendingUntil then
sellPetPending[petId] = nil
pendingUntil = nil
end
if nameAllowed and rarityAllowed and not blacklistedPetVariants[variant] and not pendingUntil then
table.insert(targets, {
id = petId,
name = petName,
rarity = rarity,
variant = variant,
tool = tool,
})
end
end
end
end
end
table.sort(targets, function(a, b)
if a.name == b.name then return a.id < b.id end
return a.name < b.name
end)
return targets
end
local function runAutoSellPet(runId)
local myGeneration = autoPlantGeneration
task.spawn(function()
while autoSellPetEnabled and autoSellPetRunId == runId
and runtime.YupisotesGeneration == myGeneration and screenGui.Parent do
local targets = getSellPetTargets()
if #targets == 0 then
local noFilter = selectionCount(selectedSellPetNames) == 0 and selectionCount(selectedSellPetRarities) == 0
screenGui:SetAttribute("AutoSellPetStatus", noFilter and "Select a pet name or rarity" or "Waiting for matching pets")
else
local sold = 0
for _, target in ipairs(targets) do
if not autoSellPetEnabled or autoSellPetRunId ~= runId then break end
sellPetPending[target.id] = os.clock() + 5
local ok, response = pcall(function()
return networking.NPCS.SellPet:Fire(target.id)
end)
if ok and type(response) == "table" and response.Success then
sold += 1
screenGui:SetAttribute("LastSoldPet", target.name)
screenGui:SetAttribute("LastSoldPetId", target.id)
screenGui:SetAttribute("LastSoldPetPrice", tonumber(response.SellPrice) or 0)
else
sellPetPending[target.id] = nil
end
task.wait(math.max(0.05, sellPetDelay))
end
screenGui:SetAttribute("LastAutoSellPetCount", sold)
screenGui:SetAttribute("AutoSellPetStatus", sold > 0 and "Selling pets" or "Sale rejected")
end
task.wait(math.max(0.2, sellPetDelay))
end
end)
end
local function showFarm()
currentPage = "Farm"
dropdownOpen = false
disconnectSection()
section.Visible = true
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
rarityButton.Text = next(selectedPlantRarities) == nil and "Select Options" or table.concat((function()
local values = {}
for _, rarityName in ipairs(rarityOptions) do
if selectedPlantRarities[rarityName] then table.insert(values, rarityName) end
end
return values
end)(), ", ")
rarityButton.Font = Enum.Font.GothamMedium
rarityButton.TextSize = 11
rarityButton.TextColor3 = next(selectedPlantRarities) == nil and palette.muted or palette.text
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
table.clear(selectedPlantRarities)
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
rarityOption.TextColor3 = selectedPlantRarities[rarityName] and rgb(221, 154, 255) or palette.text
rarityOption.TextXAlignment = Enum.TextXAlignment.Left
rarityOption.BackgroundColor3 = selectedPlantRarities[rarityName] and rgb(48, 28, 64) or rgb(17, 18, 24)
rarityOption.BackgroundTransparency = selectedPlantRarities[rarityName] and 0.1 or 0.35
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
selectedPlantRarities[rarityName] = not selectedPlantRarities[rarityName] and true or nil
local selectedValues = {}
for _, orderedRarity in ipairs(rarityOptions) do
if selectedPlantRarities[orderedRarity] then table.insert(selectedValues, orderedRarity) end
end
local hasSelection = #selectedValues > 0
if hasSelection then
selectedPlant = "All Seeds"
selectButton.Text = "Select Options"
selectButton.TextColor3 = palette.muted
else
selectButton.Text = selectedPlant
selectButton.TextColor3 = palette.text
end
rarityButton.Text = hasSelection and table.concat(selectedValues, ", ") or "Select Options"
rarityButton.TextColor3 = hasSelection and palette.text or palette.muted
for _, plantOption in ipairs(optionsPanel:GetChildren()) do
if plantOption:IsA("TextButton") then
local selected = hasSelection and plantOption.Text == "All Seeds"
or not hasSelection and plantOption.Text == selectedPlant
plantOption.TextColor3 = selected and rgb(221, 154, 255) or palette.text
plantOption.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
plantOption.BackgroundTransparency = selected and 0.1 or 0.35
end
end
for siblingIndex, sibling in ipairs(rarityButtons) do
local selected = selectedPlantRarities[rarityOptions[siblingIndex]] == true
sibling.TextColor3 = selected and rgb(221, 154, 255) or palette.text
sibling.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
sibling.BackgroundTransparency = selected and 0.1 or 0.35
end
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
local selectedRarityValues = {}
for _, rarityName in ipairs(rarityOptions) do
if selectedPlantRarities[rarityName] then table.insert(selectedRarityValues, rarityName) end
end
screenGui:SetAttribute("SelectedRarity", table.concat(selectedRarityValues, ","))
screenGui:SetAttribute("SelectedRarityCount", #selectedRarityValues)
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
advancedRarityButton.TextTruncate = Enum.TextTruncate.AtEnd
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
advancedMutationButton.TextTruncate = Enum.TextTruncate.AtEnd
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
local function updateMultiButton(button, selectedValues, orderedChoices)
local names = {}
if orderedChoices then
for _, name in ipairs(orderedChoices) do
if selectedValues[name] then table.insert(names, name) end
end
else
for name, selected in pairs(selectedValues) do
if selected then table.insert(names, name) end
end
table.sort(names)
end
if #names == 0 then
button.Text = "Select Options"
button.TextColor3 = palette.muted
else
button.Text = table.concat(names, ", ")
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
screenGui:SetAttribute("HarvestRarities", updateMultiButton(advancedRarityButton, selectedHarvestRarities, rarityOptions))
end)
end
for _, option in ipairs(advancedMutationButtons) do
option.MouseButton1Click:Connect(function()
selectedHarvestMutations[option.Text] = not selectedHarvestMutations[option.Text] or nil
local selected = selectedHarvestMutations[option.Text] == true
option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
option.BackgroundTransparency = selected and 0.1 or 0.35
screenGui:SetAttribute("HarvestMutations", updateMultiButton(advancedMutationButton, selectedHarvestMutations, harvestMutationOptions))
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
updateMultiButton(advancedRarityButton, selectedHarvestRarities, rarityOptions)
updateMultiButton(advancedMutationButton, selectedHarvestMutations, harvestMutationOptions)
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
advancedSellEnabled = false
advancedSellRunId += 1
stopDoubleOrNothing("Stopped by Auto Sell")
screenGui:SetAttribute("AdvancedSellEnabled", false)
screenGui:SetAttribute("AdvancedSellStatus", "Stopped by Auto Sell")
local advancedToggleRef = screenGui:FindFirstChild("StartAutoSellAdvancedToggle", true)
if advancedToggleRef then
advancedToggleRef.BackgroundColor3 = rgb(48, 46, 58)
local knob = advancedToggleRef:FindFirstChildWhichIsA("Frame")
if knob then
knob.Position = UDim2.fromOffset(3, 3)
end
end
local doubleToggleRef = screenGui:FindFirstChild("StartDoubleOrNothingToggle", true)
if doubleToggleRef then
doubleToggleRef.BackgroundColor3 = rgb(48, 46, 58)
local knob = doubleToggleRef:FindFirstChildWhichIsA("Frame")
if knob then
knob.Position = UDim2.fromOffset(3, 3)
end
end
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
do
local advancedSellHeader = Instance.new("TextButton")
advancedSellHeader.Name = "AutoSellAdvancedHeader"
advancedSellHeader.AutoButtonColor = false
advancedSellHeader.Text = ""
advancedSellHeader.BackgroundColor3 = palette.card
advancedSellHeader.BorderSizePixel = 0
advancedSellHeader.Size = UDim2.new(1, 0, 0, 31)
advancedSellHeader.LayoutOrder = 6
advancedSellHeader.Parent = list
corner(advancedSellHeader, 4)
local advancedSellHeaderText = label(advancedSellHeader, "Auto Sell Advanced", 13, palette.text, true)
advancedSellHeaderText.Position = UDim2.fromOffset(10, 0)
advancedSellHeaderText.Size = UDim2.new(1, -40, 1, 0)
local advancedSellArrow = label(advancedSellHeader, "v", 14, rgb(210, 210, 216), true)
advancedSellArrow.Position = UDim2.new(1, -28, 0, 0)
advancedSellArrow.Size = UDim2.fromOffset(20, 31)
advancedSellArrow.TextXAlignment = Enum.TextXAlignment.Center
local advancedSellAccent = Instance.new("Frame")
advancedSellAccent.BackgroundColor3 = palette.accent
advancedSellAccent.BorderSizePixel = 0
advancedSellAccent.Position = UDim2.new(0, 0, 1, -2)
advancedSellAccent.Size = UDim2.new(1, 0, 0, 2)
advancedSellAccent.Parent = advancedSellHeader
local advancedSellContent = Instance.new("Frame")
advancedSellContent.Name = "AutoSellAdvancedContent"
advancedSellContent.BackgroundTransparency = 1
advancedSellContent.BorderSizePixel = 0
advancedSellContent.ClipsDescendants = true
advancedSellContent.Size = UDim2.new(1, 0, 0, 0)
advancedSellContent.LayoutOrder = 7
advancedSellContent.Parent = list
local advancedModeRow = Instance.new("Frame")
advancedModeRow.BackgroundColor3 = palette.card
advancedModeRow.BorderSizePixel = 0
advancedModeRow.Position = UDim2.fromOffset(0, 0)
advancedModeRow.Size = UDim2.new(1, 0, 0, 58)
advancedModeRow.Parent = advancedSellContent
corner(advancedModeRow, 4)
local advancedModeTitle = label(advancedModeRow, "Multiplier Mode", 12, palette.text, true)
advancedModeTitle.Position = UDim2.fromOffset(10, 5)
advancedModeTitle.Size = UDim2.new(0.62, -10, 0, 18)
local advancedModeDescription = label(advancedModeRow, "Fruit that matches this target will be sold. Other fruit is kept.", 10, palette.muted, false)
advancedModeDescription.Position = UDim2.fromOffset(10, 22)
advancedModeDescription.Size = UDim2.new(0.62, -10, 0, 31)
advancedModeDescription.TextWrapped = true
advancedModeDescription.TextYAlignment = Enum.TextYAlignment.Top
local advancedModeButton = Instance.new("TextButton")
advancedModeButton.AutoButtonColor = false
advancedModeButton.Text = advancedSellMode
advancedModeButton.Font = Enum.Font.GothamBold
advancedModeButton.TextSize = 11
advancedModeButton.TextColor3 = palette.text
advancedModeButton.TextXAlignment = Enum.TextXAlignment.Left
advancedModeButton.BackgroundColor3 = rgb(31, 26, 43)
advancedModeButton.BorderSizePixel = 0
advancedModeButton.Position = UDim2.new(0.64, 0, 0, 8)
advancedModeButton.Size = UDim2.new(0.36, -7, 0, 32)
advancedModeButton.Parent = advancedModeRow
corner(advancedModeButton, 4)
stroke(advancedModeButton, rgb(72, 48, 96), 0.45, 1)
local advancedModeChevron = label(advancedModeButton, "v", 13, rgb(210, 210, 216), true)
advancedModeChevron.Position = UDim2.new(1, -24, 0, 0)
advancedModeChevron.Size = UDim2.fromOffset(20, 32)
advancedModeChevron.TextXAlignment = Enum.TextXAlignment.Center
local advancedTargetRow = Instance.new("Frame")
advancedTargetRow.BackgroundColor3 = palette.card
advancedTargetRow.BorderSizePixel = 0
advancedTargetRow.Position = UDim2.fromOffset(0, 64)
advancedTargetRow.Size = UDim2.new(1, 0, 0, 40)
advancedTargetRow.Parent = advancedSellContent
corner(advancedTargetRow, 4)
local advancedTargetTitle = label(advancedTargetRow, "Target Multiplier", 12, palette.text, true)
advancedTargetTitle.Position = UDim2.fromOffset(10, 0)
advancedTargetTitle.Size = UDim2.new(0.64, -10, 1, 0)
local advancedTargetInput = Instance.new("TextBox")
advancedTargetInput.ClearTextOnFocus = false
advancedTargetInput.Text = tostring(advancedSellTarget)
advancedTargetInput.PlaceholderText = "1.01"
advancedTargetInput.Font = Enum.Font.GothamMedium
advancedTargetInput.TextSize = 11
advancedTargetInput.TextColor3 = palette.text
advancedTargetInput.TextXAlignment = Enum.TextXAlignment.Left
advancedTargetInput.BackgroundColor3 = rgb(31, 26, 43)
advancedTargetInput.BorderSizePixel = 0
advancedTargetInput.Position = UDim2.new(0.64, 0, 0, 5)
advancedTargetInput.Size = UDim2.new(0.36, -7, 0, 30)
advancedTargetInput.Parent = advancedTargetRow
corner(advancedTargetInput, 4)
stroke(advancedTargetInput, rgb(125, 49, 166), 0.2, 1)
local advancedTargetPadding = Instance.new("UIPadding")
advancedTargetPadding.PaddingLeft = UDim.new(0, 8)
advancedTargetPadding.PaddingRight = UDim.new(0, 8)
advancedTargetPadding.Parent = advancedTargetInput
local advancedToggleRow = Instance.new("Frame")
advancedToggleRow.BackgroundColor3 = palette.card
advancedToggleRow.BorderSizePixel = 0
advancedToggleRow.Position = UDim2.fromOffset(0, 110)
advancedToggleRow.Size = UDim2.new(1, 0, 0, 40)
advancedToggleRow.Parent = advancedSellContent
corner(advancedToggleRow, 4)
local advancedToggleTitle = label(advancedToggleRow, "Start Auto Sell Advanced", 12, palette.text, true)
advancedToggleTitle.Position = UDim2.fromOffset(10, 0)
advancedToggleTitle.Size = UDim2.new(0.78, -10, 1, 0)
local advancedToggle = Instance.new("TextButton")
advancedToggle.Name = "StartAutoSellAdvancedToggle"
advancedToggle.AutoButtonColor = false
advancedToggle.Text = ""
advancedToggle.BackgroundColor3 = advancedSellEnabled and palette.accent or rgb(48, 46, 58)
advancedToggle.BorderSizePixel = 0
advancedToggle.Position = UDim2.new(1, -50, 0.5, -11)
advancedToggle.Size = UDim2.fromOffset(38, 22)
advancedToggle.Parent = advancedToggleRow
corner(advancedToggle, 11)
stroke(advancedToggle, rgb(116, 70, 152), advancedSellEnabled and 0.15 or 0.45, 1)
local advancedToggleKnob = Instance.new("Frame")
advancedToggleKnob.BackgroundColor3 = rgb(239, 239, 243)
advancedToggleKnob.BorderSizePixel = 0
advancedToggleKnob.Position = advancedSellEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
advancedToggleKnob.Size = UDim2.fromOffset(16, 16)
advancedToggleKnob.Parent = advancedToggle
corner(advancedToggleKnob, 8)
local advancedModePanel = Instance.new("Frame")
advancedModePanel.BackgroundColor3 = rgb(18, 18, 25)
advancedModePanel.BorderSizePixel = 0
advancedModePanel.ClipsDescendants = true
advancedModePanel.Position = UDim2.new(0.64, 0, 0, 44)
advancedModePanel.Size = UDim2.new(0.36, -7, 0, 0)
advancedModePanel.ZIndex = 120
advancedModePanel.Parent = advancedSellContent
corner(advancedModePanel, 4)
stroke(advancedModePanel, rgb(91, 39, 124), 0.1, 1)
local advancedModeLayout = Instance.new("UIListLayout")
advancedModeLayout.SortOrder = Enum.SortOrder.LayoutOrder
advancedModeLayout.Padding = UDim.new(0, 2)
advancedModeLayout.Parent = advancedModePanel
local advancedCategoryOpen = false
local advancedModeOpen = false
local advancedBaseHeight = 150
local function setAdvancedModeOpen(open)
advancedModeOpen = open
advancedModeChevron.Rotation = open and 180 or 0
advancedModePanel.Size = UDim2.new(0.36, -7, 0, open and 58 or 0)
end
for index, modeName in ipairs({"Above", "Below"}) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = modeName
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = modeName == advancedSellMode and rgb(59, 24, 83) or rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, 0, 0, 28)
option.LayoutOrder = index
option.ZIndex = 121
option.Parent = advancedModePanel
local optionPadding = Instance.new("UIPadding")
optionPadding.PaddingLeft = UDim.new(0, 10)
optionPadding.Parent = option
option.MouseButton1Click:Connect(function()
advancedSellMode = modeName
advancedModeButton.Text = modeName
screenGui:SetAttribute("AdvancedSellMode", modeName)
setAdvancedModeOpen(false)
end)
end
local function commitAdvancedTarget()
local normalizedText = string.gsub(advancedTargetInput.Text, ",", ".")
local value = tonumber(normalizedText) or 1.01
advancedSellTarget = math.max(0, value)
advancedTargetInput.Text = tostring(advancedSellTarget)
screenGui:SetAttribute("AdvancedSellTarget", advancedSellTarget)
end
advancedTargetInput.FocusLost:Connect(commitAdvancedTarget)
advancedModeButton.MouseButton1Click:Connect(function()
setAdvancedModeOpen(not advancedModeOpen)
end)
advancedToggle.MouseButton1Click:Connect(function()
commitAdvancedTarget()
advancedSellEnabled = not advancedSellEnabled
advancedSellRunId += 1
if advancedSellEnabled then
autoSellEnabled = false
autoSellRunId += 1
stopDoubleOrNothing("Stopped by Advanced Sell")
screenGui:SetAttribute("AutoSellEnabled", false)
screenGui:SetAttribute("AutoSellStatus", "Stopped by Advanced Sell")
startSellingToggle.BackgroundColor3 = rgb(48, 46, 58)
sellingToggleKnob.Position = UDim2.fromOffset(3, 3)
screenGui:SetAttribute("AdvancedSellStatus", "Checking prices")
runAdvancedSell(advancedSellRunId)
else
screenGui:SetAttribute("AdvancedSellStatus", "Stopped")
end
screenGui:SetAttribute("AdvancedSellEnabled", advancedSellEnabled)
TweenService:Create(advancedToggle, TweenInfo.new(0.18), {
BackgroundColor3 = advancedSellEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(advancedToggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = advancedSellEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
advancedSellHeader.MouseButton1Click:Connect(function()
advancedCategoryOpen = not advancedCategoryOpen
if not advancedCategoryOpen then
setAdvancedModeOpen(false)
end
TweenService:Create(advancedSellContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, advancedCategoryOpen and advancedBaseHeight or 0),
}):Play()
TweenService:Create(advancedSellArrow, TweenInfo.new(0.18), {
Rotation = advancedCategoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("AdvancedSellEnabled", advancedSellEnabled)
screenGui:SetAttribute("AdvancedSellMode", advancedSellMode)
screenGui:SetAttribute("AdvancedSellTarget", advancedSellTarget)
end
do
local doubleHeader = Instance.new("TextButton")
doubleHeader.Name = "AutoDoubleOrNothingHeader"
doubleHeader.AutoButtonColor = false
doubleHeader.Text = ""
doubleHeader.BackgroundColor3 = palette.card
doubleHeader.BorderSizePixel = 0
doubleHeader.Size = UDim2.new(1, 0, 0, 31)
doubleHeader.LayoutOrder = 10
doubleHeader.Parent = list
corner(doubleHeader, 4)
local doubleHeaderText = label(doubleHeader, "Auto Double or Nothing", 13, palette.text, true)
doubleHeaderText.Position = UDim2.fromOffset(10, 0)
doubleHeaderText.Size = UDim2.new(1, -40, 1, 0)
local doubleArrow = label(doubleHeader, "v", 14, rgb(210, 210, 216), true)
doubleArrow.Position = UDim2.new(1, -28, 0, 0)
doubleArrow.Size = UDim2.fromOffset(20, 31)
doubleArrow.TextXAlignment = Enum.TextXAlignment.Center
local doubleAccent = Instance.new("Frame")
doubleAccent.BackgroundColor3 = palette.accent
doubleAccent.BorderSizePixel = 0
doubleAccent.Position = UDim2.new(0, 0, 1, -2)
doubleAccent.Size = UDim2.new(1, 0, 0, 2)
doubleAccent.Parent = doubleHeader
local doubleContent = Instance.new("Frame")
doubleContent.Name = "AutoDoubleOrNothingContent"
doubleContent.BackgroundTransparency = 1
doubleContent.BorderSizePixel = 0
doubleContent.ClipsDescendants = true
doubleContent.Size = UDim2.new(1, 0, 0, 0)
doubleContent.LayoutOrder = 11
doubleContent.Parent = list
local reachRow = Instance.new("Frame")
reachRow.BackgroundColor3 = palette.card
reachRow.BorderSizePixel = 0
reachRow.Position = UDim2.fromOffset(0, 0)
reachRow.Size = UDim2.new(1, 0, 0, 58)
reachRow.Parent = doubleContent
corner(reachRow, 4)
local reachTitle = label(reachRow, "When Backpack Reach Fruit", 12, palette.text, true)
reachTitle.Position = UDim2.fromOffset(10, 5)
reachTitle.Size = UDim2.new(0.64, -10, 0, 18)
local reachDescription = label(reachRow, "Start Double or Nothing when fruit inventory reaches this amount.", 10, palette.muted, false)
reachDescription.Position = UDim2.fromOffset(10, 22)
reachDescription.Size = UDim2.new(0.64, -10, 0, 31)
reachDescription.TextWrapped = true
reachDescription.TextYAlignment = Enum.TextYAlignment.Top
local reachInput = Instance.new("TextBox")
reachInput.Name = "DoubleReachInput"
reachInput.ClearTextOnFocus = false
reachInput.Text = tostring(doubleTriggerCount)
reachInput.Font = Enum.Font.GothamMedium
reachInput.TextSize = 11
reachInput.TextColor3 = palette.text
reachInput.TextXAlignment = Enum.TextXAlignment.Left
reachInput.BackgroundColor3 = rgb(31, 26, 43)
reachInput.BorderSizePixel = 0
reachInput.Position = UDim2.new(0.64, 0, 0, 8)
reachInput.Size = UDim2.new(0.36, -7, 0, 32)
reachInput.Parent = reachRow
corner(reachInput, 4)
stroke(reachInput, rgb(125, 49, 166), 0.2, 1)
padding(reachInput, 8, 0, 8, 0)
local maxRow = Instance.new("Frame")
maxRow.BackgroundColor3 = palette.card
maxRow.BorderSizePixel = 0
maxRow.Position = UDim2.fromOffset(0, 64)
maxRow.Size = UDim2.new(1, 0, 0, 58)
maxRow.Parent = doubleContent
corner(maxRow, 4)
local maxTitle = label(maxRow, "When Backpack Max", 12, palette.text, true)
maxTitle.Position = UDim2.fromOffset(10, 5)
maxTitle.Size = UDim2.new(0.76, -10, 0, 18)
local maxDescription = label(maxRow, "Ignore the amount input and start only when the fruit backpack is full.", 10, palette.muted, false)
maxDescription.Position = UDim2.fromOffset(10, 22)
maxDescription.Size = UDim2.new(0.76, -10, 0, 31)
maxDescription.TextWrapped = true
maxDescription.TextYAlignment = Enum.TextYAlignment.Top
local maxToggle = Instance.new("TextButton")
maxToggle.Name = "DoubleBackpackMaxToggle"
maxToggle.AutoButtonColor = false
maxToggle.Text = ""
maxToggle.BackgroundColor3 = doubleUseBackpackMax and palette.accent or rgb(48, 46, 58)
maxToggle.BorderSizePixel = 0
maxToggle.Position = UDim2.new(1, -50, 0.5, -11)
maxToggle.Size = UDim2.fromOffset(38, 22)
maxToggle.Parent = maxRow
corner(maxToggle, 11)
stroke(maxToggle, rgb(116, 70, 152), doubleUseBackpackMax and 0.15 or 0.45, 1)
local maxKnob = Instance.new("Frame")
maxKnob.BackgroundColor3 = rgb(239, 239, 243)
maxKnob.BorderSizePixel = 0
maxKnob.Position = doubleUseBackpackMax and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
maxKnob.Size = UDim2.fromOffset(16, 16)
maxKnob.Parent = maxToggle
corner(maxKnob, 8)
local countRow = Instance.new("Frame")
countRow.BackgroundColor3 = palette.card
countRow.BorderSizePixel = 0
countRow.Position = UDim2.fromOffset(0, 128)
countRow.Size = UDim2.new(1, 0, 0, 48)
countRow.Parent = doubleContent
corner(countRow, 4)
local countTitle = label(countRow, "Double or Nothing Count", 12, palette.text, true)
countTitle.Position = UDim2.fromOffset(10, 5)
countTitle.Size = UDim2.new(0.64, -10, 0, 18)
local countDescription = label(countRow, "How many successful doubles to chase before cashing out.", 10, palette.muted, false)
countDescription.Position = UDim2.fromOffset(10, 22)
countDescription.Size = UDim2.new(0.64, -10, 0, 21)
countDescription.TextWrapped = true
local countInput = Instance.new("TextBox")
countInput.Name = "DoubleCountInput"
countInput.ClearTextOnFocus = false
countInput.Text = tostring(doubleTargetWins)
countInput.Font = Enum.Font.GothamMedium
countInput.TextSize = 11
countInput.TextColor3 = palette.text
countInput.TextXAlignment = Enum.TextXAlignment.Left
countInput.BackgroundColor3 = rgb(31, 26, 43)
countInput.BorderSizePixel = 0
countInput.Position = UDim2.new(0.64, 0, 0, 7)
countInput.Size = UDim2.new(0.36, -7, 0, 32)
countInput.Parent = countRow
corner(countInput, 4)
stroke(countInput, rgb(125, 49, 166), 0.2, 1)
padding(countInput, 8, 0, 8, 0)
local startDoubleRow = Instance.new("Frame")
startDoubleRow.BackgroundColor3 = palette.card
startDoubleRow.BorderSizePixel = 0
startDoubleRow.Position = UDim2.fromOffset(0, 182)
startDoubleRow.Size = UDim2.new(1, 0, 0, 58)
startDoubleRow.Parent = doubleContent
corner(startDoubleRow, 4)
local startDoubleTitle = label(startDoubleRow, "Start Double or Nothing", 12, palette.text, true)
startDoubleTitle.Position = UDim2.fromOffset(10, 5)
startDoubleTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDoubleDescription = label(startDoubleRow, "Auto rolls until the target win count is reached, then cashes out. A bust stops the cycle.", 10, palette.muted, false)
startDoubleDescription.Position = UDim2.fromOffset(10, 22)
startDoubleDescription.Size = UDim2.new(0.76, -10, 0, 31)
startDoubleDescription.TextWrapped = true
startDoubleDescription.TextYAlignment = Enum.TextYAlignment.Top
local startDoubleToggle = Instance.new("TextButton")
startDoubleToggle.Name = "StartDoubleOrNothingToggle"
startDoubleToggle.AutoButtonColor = false
startDoubleToggle.Text = ""
startDoubleToggle.BackgroundColor3 = doubleEnabled and palette.accent or rgb(48, 46, 58)
startDoubleToggle.BorderSizePixel = 0
startDoubleToggle.Position = UDim2.new(1, -50, 0.5, -11)
startDoubleToggle.Size = UDim2.fromOffset(38, 22)
startDoubleToggle.Parent = startDoubleRow
corner(startDoubleToggle, 11)
stroke(startDoubleToggle, rgb(116, 70, 152), doubleEnabled and 0.15 or 0.45, 1)
local startDoubleKnob = Instance.new("Frame")
startDoubleKnob.BackgroundColor3 = rgb(239, 239, 243)
startDoubleKnob.BorderSizePixel = 0
startDoubleKnob.Position = doubleEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
startDoubleKnob.Size = UDim2.fromOffset(16, 16)
startDoubleKnob.Parent = startDoubleToggle
corner(startDoubleKnob, 8)
local doubleCategoryOpen = false
local doubleBaseHeight = 240
local function commitDoubleInputs()
doubleTriggerCount = math.max(1, math.floor(tonumber(reachInput.Text) or 100))
doubleTargetWins = math.max(1, math.floor(tonumber(countInput.Text) or 1))
reachInput.Text = tostring(doubleTriggerCount)
countInput.Text = tostring(doubleTargetWins)
screenGui:SetAttribute("DoubleTriggerCount", doubleTriggerCount)
screenGui:SetAttribute("DoubleTargetWins", doubleTargetWins)
end
reachInput.FocusLost:Connect(commitDoubleInputs)
countInput.FocusLost:Connect(commitDoubleInputs)
maxToggle.MouseButton1Click:Connect(function()
doubleUseBackpackMax = not doubleUseBackpackMax
screenGui:SetAttribute("DoubleUseBackpackMax", doubleUseBackpackMax)
TweenService:Create(maxToggle, TweenInfo.new(0.18), {
BackgroundColor3 = doubleUseBackpackMax and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(maxKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = doubleUseBackpackMax and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
startDoubleToggle.MouseButton1Click:Connect(function()
commitDoubleInputs()
if doubleEnabled then
stopDoubleOrNothing("Stopped and cashed out")
else
autoSellEnabled = false
autoSellRunId += 1
advancedSellEnabled = false
advancedSellRunId += 1
screenGui:SetAttribute("AutoSellEnabled", false)
screenGui:SetAttribute("AdvancedSellEnabled", false)
startSellingToggle.BackgroundColor3 = rgb(48, 46, 58)
sellingToggleKnob.Position = UDim2.fromOffset(3, 3)
local advancedToggleRef = screenGui:FindFirstChild("StartAutoSellAdvancedToggle", true)
if advancedToggleRef then
advancedToggleRef.BackgroundColor3 = rgb(48, 46, 58)
local knob = advancedToggleRef:FindFirstChildWhichIsA("Frame")
if knob then
knob.Position = UDim2.fromOffset(3, 3)
end
end
doubleEnabled = true
doubleRunId += 1
screenGui:SetAttribute("DoubleOrNothingEnabled", true)
screenGui:SetAttribute("DoubleOrNothingStatus", "Waiting for inventory")
runDoubleOrNothing(doubleRunId)
end
TweenService:Create(startDoubleToggle, TweenInfo.new(0.18), {
BackgroundColor3 = doubleEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(startDoubleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = doubleEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
doubleHeader.MouseButton1Click:Connect(function()
doubleCategoryOpen = not doubleCategoryOpen
TweenService:Create(doubleContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, doubleCategoryOpen and doubleBaseHeight or 0),
}):Play()
TweenService:Create(doubleArrow, TweenInfo.new(0.18), {
Rotation = doubleCategoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("DoubleTriggerCount", doubleTriggerCount)
screenGui:SetAttribute("DoubleUseBackpackMax", doubleUseBackpackMax)
screenGui:SetAttribute("DoubleTargetWins", doubleTargetWins)
screenGui:SetAttribute("DoubleOrNothingEnabled", doubleEnabled)
end
local dailyHeader = Instance.new("TextButton")
dailyHeader.Name = "DailyDealHeader"
dailyHeader.AutoButtonColor = false
dailyHeader.Text = ""
dailyHeader.BackgroundColor3 = palette.card
dailyHeader.BorderSizePixel = 0
dailyHeader.Size = UDim2.new(1, 0, 0, 31)
dailyHeader.LayoutOrder = 8
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
dailyContent.LayoutOrder = 9
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
do
local function createAutoFavoriteSection()
local favoriteHeader = Instance.new("TextButton")
favoriteHeader.Name = "AutoFavoriteHeader"
favoriteHeader.AutoButtonColor = false
favoriteHeader.Text = ""
favoriteHeader.BackgroundColor3 = palette.card
favoriteHeader.BorderSizePixel = 0
favoriteHeader.Size = UDim2.new(1, 0, 0, 31)
favoriteHeader.LayoutOrder = 12
favoriteHeader.Parent = list
corner(favoriteHeader, 4)
local favoriteHeaderText = label(favoriteHeader, "Auto Favorite", 13, palette.text, true)
favoriteHeaderText.Position = UDim2.fromOffset(10, 0)
favoriteHeaderText.Size = UDim2.new(1, -40, 1, 0)
local favoriteArrow = label(favoriteHeader, "v", 14, rgb(210, 210, 216), true)
favoriteArrow.Position = UDim2.new(1, -28, 0, 0)
favoriteArrow.Size = UDim2.fromOffset(20, 31)
favoriteArrow.TextXAlignment = Enum.TextXAlignment.Center
local favoriteAccent = Instance.new("Frame")
favoriteAccent.BackgroundColor3 = palette.accent
favoriteAccent.BorderSizePixel = 0
favoriteAccent.Position = UDim2.new(0, 0, 1, -2)
favoriteAccent.Size = UDim2.new(1, 0, 0, 2)
favoriteAccent.Parent = favoriteHeader
local favoriteContent = Instance.new("Frame")
favoriteContent.Name = "AutoFavoriteContent"
favoriteContent.BackgroundTransparency = 1
favoriteContent.BorderSizePixel = 0
favoriteContent.ClipsDescendants = true
favoriteContent.Size = UDim2.new(1, 0, 0, 0)
favoriteContent.LayoutOrder = 13
favoriteContent.Parent = list
local filters = {}
local function makeFavoriteFilter(name, titleText, descriptionText, y, choices, selection, zIndex)
local entry = {open = false}
local row = Instance.new("Frame")
row.Name = name .. "Row"
row.BackgroundColor3 = palette.card
row.BorderSizePixel = 0
row.Position = UDim2.fromOffset(0, y)
row.Size = UDim2.new(1, 0, 0, 48)
row.Parent = favoriteContent
corner(row, 4)
local titleLabel = label(row, titleText, 12, palette.text, true)
titleLabel.Position = UDim2.fromOffset(10, 4)
titleLabel.Size = UDim2.new(0.62, -10, 0, 18)
local descriptionLabel = label(row, descriptionText, 10, palette.muted, false)
descriptionLabel.Position = UDim2.fromOffset(10, 21)
descriptionLabel.Size = UDim2.new(0.62, -10, 0, 20)
descriptionLabel.TextWrapped = true
local button = Instance.new("TextButton")
button.Name = name .. "Button"
button.AutoButtonColor = false
button.Text = "Select Options"
button.Font = Enum.Font.GothamBold
button.TextSize = 11
button.TextColor3 = palette.muted
button.TextXAlignment = Enum.TextXAlignment.Left
button.TextTruncate = Enum.TextTruncate.AtEnd
button.BackgroundColor3 = rgb(31, 26, 43)
button.BorderSizePixel = 0
button.Position = UDim2.new(0.62, 0, 0, 8)
button.Size = UDim2.new(0.38, -7, 0, 32)
button.Parent = row
corner(button, 4)
stroke(button, rgb(72, 48, 96), 0.45, 1)
padding(button, 10, 0, 30, 0)
local buttonArrow = label(button, "v", 13, rgb(210, 210, 216), true)
buttonArrow.Position = UDim2.new(1, -30, 0, 0)
buttonArrow.Size = UDim2.fromOffset(20, 32)
buttonArrow.TextXAlignment = Enum.TextXAlignment.Center
local panel = Instance.new("Frame")
panel.Name = name .. "Dropdown"
panel.BackgroundColor3 = rgb(18, 18, 25)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Position = UDim2.new(0.62, 0, 0, y + 44)
panel.Size = UDim2.new(0.38, -7, 0, 0)
panel.ZIndex = zIndex
panel.Parent = favoriteContent
corner(panel, 4)
stroke(panel, rgb(91, 39, 124), 0.1, 1)
local search = Instance.new("TextBox")
search.Name = name .. "Search"
search.ClearTextOnFocus = false
search.PlaceholderText = "Search"
search.Text = ""
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = palette.text
search.PlaceholderColor3 = palette.muted
search.BackgroundColor3 = rgb(35, 27, 48)
search.BorderSizePixel = 0
search.Position = UDim2.fromOffset(4, 4)
search.Size = UDim2.new(1, -8, 0, 26)
search.ZIndex = zIndex + 1
search.Parent = panel
corner(search, 3)
local optionsList = Instance.new("ScrollingFrame")
optionsList.BackgroundTransparency = 1
optionsList.BorderSizePixel = 0
optionsList.CanvasSize = UDim2.fromOffset(0, 0)
optionsList.ScrollBarImageColor3 = palette.accent
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
local optionButtons = {}
local function refreshSummary()
local selectedNames = {}
for _, choice in ipairs(choices) do
if selection[choice] then table.insert(selectedNames, choice) end
end
button.Text = #selectedNames > 0 and table.concat(selectedNames, ", ") or "Select Options"
button.TextColor3 = #selectedNames > 0 and palette.text or palette.muted
end
local function updateCanvas()
local visible = 0
for _, option in ipairs(optionButtons) do
if option.Visible then
visible += 1
end
end
optionsList.CanvasSize = UDim2.fromOffset(0, math.max(0, visible * 28 - 2))
end
for index, choice in ipairs(choices) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = choice
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextXAlignment = Enum.TextXAlignment.Left
option.BorderSizePixel = 0
option.Size = UDim2.new(1, 0, 0, 26)
option.LayoutOrder = index
option.ZIndex = zIndex + 2
option.Parent = optionsList
corner(option, 3)
padding(option, 10, 0, 0, 0)
local function renderSelected()
local selected = selection[choice] == true
option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
option.BackgroundTransparency = selected and 0.1 or 0.35
end
renderSelected()
option.MouseButton1Click:Connect(function()
selection[choice] = not selection[choice] or nil
renderSelected()
refreshSummary()
end)
table.insert(optionButtons, option)
end
refreshSummary()
updateCanvas()
search:GetPropertyChangedSignal("Text"):Connect(function()
local query = string.lower(search.Text)
for _, option in ipairs(optionButtons) do
option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
end
optionsList.CanvasPosition = Vector2.zero
updateCanvas()
end)
function entry.setOpen(open)
entry.open = open
panel.Size = UDim2.new(0.38, -7, 0, open and 178 or 0)
buttonArrow.Rotation = open and 180 or 0
end
button.MouseButton1Click:Connect(function()
for _, other in ipairs(filters) do
if other ~= entry then
other.setOpen(false)
end
end
entry.setOpen(not entry.open)
end)
table.insert(filters, entry)
return entry
end
makeFavoriteFilter("FavoriteRarity", "Favorite If Fruit Rarity", "Favorite fruits from these rarities.", 0, rarityOptions, favoriteSelectedRarities, 130)
makeFavoriteFilter("FavoriteExcludeFruit", "Exclude Favorite If Fruit Name", "Skip these fruit names when favoriting.", 54, favoriteFruitOptions, favoriteExcludedFruits, 140)
makeFavoriteFilter("FavoriteMutation", "Favorite If Fruit Mutation", "Favorite fruits with these mutations.", 108, harvestMutationOptions, favoriteSelectedMutations, 150)
local kgRow = Instance.new("Frame")
kgRow.BackgroundColor3 = palette.card
kgRow.BorderSizePixel = 0
kgRow.Position = UDim2.fromOffset(0, 162)
kgRow.Size = UDim2.new(1, 0, 0, 48)
kgRow.Parent = favoriteContent
corner(kgRow, 4)
local kgTitle = label(kgRow, "Input Your Kg", 12, palette.text, true)
kgTitle.Position = UDim2.fromOffset(10, 4)
kgTitle.Size = UDim2.new(0.62, -10, 0, 18)
local kgDescription = label(kgRow, "Set the KG number for this filter.", 10, palette.muted, false)
kgDescription.Position = UDim2.fromOffset(10, 21)
kgDescription.Size = UDim2.new(0.62, -10, 0, 20)
local kgInput = Instance.new("TextBox")
kgInput.Name = "FavoriteKgInput"
kgInput.ClearTextOnFocus = false
kgInput.Text = tostring(favoriteKg)
kgInput.Font = Enum.Font.GothamMedium
kgInput.TextSize = 11
kgInput.TextColor3 = palette.text
kgInput.TextXAlignment = Enum.TextXAlignment.Left
kgInput.BackgroundColor3 = rgb(31, 26, 43)
kgInput.BorderSizePixel = 0
kgInput.Position = UDim2.new(0.62, 0, 0, 8)
kgInput.Size = UDim2.new(0.38, -7, 0, 32)
kgInput.Parent = kgRow
corner(kgInput, 4)
stroke(kgInput, rgb(125, 49, 166), 0.2, 1)
padding(kgInput, 8, 0, 8, 0)
local directionRow = Instance.new("Frame")
directionRow.BackgroundColor3 = palette.card
directionRow.BorderSizePixel = 0
directionRow.Position = UDim2.fromOffset(0, 216)
directionRow.Size = UDim2.new(1, 0, 0, 48)
directionRow.Parent = favoriteContent
corner(directionRow, 4)
local directionTitle = label(directionRow, "KG Direction", 12, palette.text, true)
directionTitle.Position = UDim2.fromOffset(10, 4)
directionTitle.Size = UDim2.new(0.62, -10, 0, 18)
local directionDescription = label(directionRow, "Up means this KG and higher. Below means lower than this KG.", 10, palette.muted, false)
directionDescription.Position = UDim2.fromOffset(10, 21)
directionDescription.Size = UDim2.new(0.62, -10, 0, 22)
directionDescription.TextWrapped = true
local directionButton = Instance.new("TextButton")
directionButton.Name = "FavoriteKgDirectionButton"
directionButton.AutoButtonColor = false
directionButton.Text = favoriteKgDirection
directionButton.Font = Enum.Font.GothamBold
directionButton.TextSize = 11
directionButton.TextColor3 = palette.text
directionButton.TextXAlignment = Enum.TextXAlignment.Left
directionButton.BackgroundColor3 = rgb(31, 26, 43)
directionButton.BorderSizePixel = 0
directionButton.Position = UDim2.new(0.62, 0, 0, 8)
directionButton.Size = UDim2.new(0.38, -7, 0, 32)
directionButton.Parent = directionRow
corner(directionButton, 4)
stroke(directionButton, rgb(72, 48, 96), 0.45, 1)
padding(directionButton, 10, 0, 30, 0)
local directionArrow = label(directionButton, "v", 13, rgb(210, 210, 216), true)
directionArrow.Position = UDim2.new(1, -30, 0, 0)
directionArrow.Size = UDim2.fromOffset(20, 32)
directionArrow.TextXAlignment = Enum.TextXAlignment.Center
local directionPanel = Instance.new("Frame")
directionPanel.Name = "FavoriteKgDirectionDropdown"
directionPanel.BackgroundColor3 = rgb(18, 18, 25)
directionPanel.BorderSizePixel = 0
directionPanel.ClipsDescendants = true
directionPanel.Position = UDim2.new(0.62, 0, 0, 260)
directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
directionPanel.ZIndex = 160
directionPanel.Parent = favoriteContent
corner(directionPanel, 4)
stroke(directionPanel, rgb(91, 39, 124), 0.1, 1)
local directionLayout = Instance.new("UIListLayout")
directionLayout.SortOrder = Enum.SortOrder.LayoutOrder
directionLayout.Padding = UDim.new(0, 2)
directionLayout.Parent = directionPanel
local directionOpen = false
for index, directionName in ipairs({"Up", "Below"}) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = directionName
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, 0, 0, 28)
option.LayoutOrder = index
option.ZIndex = 161
option.Parent = directionPanel
padding(option, 10, 0, 0, 0)
option.MouseButton1Click:Connect(function()
favoriteKgDirection = directionName
directionButton.Text = directionName
directionOpen = false
directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
directionArrow.Rotation = 0
screenGui:SetAttribute("FavoriteKgDirection", directionName)
end)
end
directionButton.MouseButton1Click:Connect(function()
for _, filter in ipairs(filters) do
filter.setOpen(false)
end
directionOpen = not directionOpen
directionPanel.Size = UDim2.new(0.38, -7, 0, directionOpen and 58 or 0)
directionArrow.Rotation = directionOpen and 180 or 0
end)
local startRow = Instance.new("Frame")
startRow.BackgroundColor3 = palette.card
startRow.BorderSizePixel = 0
startRow.Position = UDim2.fromOffset(0, 270)
startRow.Size = UDim2.new(1, 0, 0, 48)
startRow.Parent = favoriteContent
corner(startRow, 4)
local startTitle = label(startRow, "Start Favorite Fruit", 12, palette.text, true)
startTitle.Position = UDim2.fromOffset(10, 4)
startTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDescription = label(startRow, "Automatically favorites matching fruits in your inventory.", 10, palette.muted, false)
startDescription.Position = UDim2.fromOffset(10, 21)
startDescription.Size = UDim2.new(0.76, -10, 0, 20)
local startFavoriteToggle = Instance.new("TextButton")
startFavoriteToggle.Name = "StartFavoriteFruitToggle"
startFavoriteToggle.AutoButtonColor = false
startFavoriteToggle.Text = ""
startFavoriteToggle.BackgroundColor3 = autoFavoriteEnabled and palette.accent or rgb(48, 46, 58)
startFavoriteToggle.BorderSizePixel = 0
startFavoriteToggle.Position = UDim2.new(1, -50, 0.5, -11)
startFavoriteToggle.Size = UDim2.fromOffset(38, 22)
startFavoriteToggle.Parent = startRow
corner(startFavoriteToggle, 11)
stroke(startFavoriteToggle, rgb(116, 70, 152), autoFavoriteEnabled and 0.15 or 0.45, 1)
local favoriteKnob = Instance.new("Frame")
favoriteKnob.BackgroundColor3 = rgb(239, 239, 243)
favoriteKnob.BorderSizePixel = 0
favoriteKnob.Position = autoFavoriteEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
favoriteKnob.Size = UDim2.fromOffset(16, 16)
favoriteKnob.Parent = startFavoriteToggle
corner(favoriteKnob, 8)
local unfavoriteButton = Instance.new("TextButton")
unfavoriteButton.Name = "UnfavoriteAllFruitButton"
unfavoriteButton.AutoButtonColor = false
unfavoriteButton.Text = "Unfavorite All Fruit"
unfavoriteButton.Font = Enum.Font.GothamBold
unfavoriteButton.TextSize = 11
unfavoriteButton.TextColor3 = palette.text
unfavoriteButton.BackgroundColor3 = rgb(28, 33, 28)
unfavoriteButton.BorderSizePixel = 0
unfavoriteButton.Position = UDim2.fromOffset(0, 324)
unfavoriteButton.Size = UDim2.new(1, 0, 0, 40)
unfavoriteButton.Parent = favoriteContent
corner(unfavoriteButton, 4)
local favoriteCategoryOpen = false
local favoriteBaseHeight = 364
local function commitFavoriteKg()
local normalizedText = string.gsub(kgInput.Text, ",", ".")
favoriteKg = math.max(0, tonumber(normalizedText) or 0)
kgInput.Text = tostring(favoriteKg)
screenGui:SetAttribute("FavoriteKg", favoriteKg)
end
kgInput.FocusLost:Connect(commitFavoriteKg)
startFavoriteToggle.MouseButton1Click:Connect(function()
commitFavoriteKg()
autoFavoriteEnabled = not autoFavoriteEnabled
autoFavoriteRunId += 1
if autoFavoriteEnabled then
screenGui:SetAttribute("AutoFavoriteStatus", "Checking inventory")
runAutoFavorite(autoFavoriteRunId)
else
screenGui:SetAttribute("AutoFavoriteStatus", "Stopped")
end
screenGui:SetAttribute("AutoFavoriteEnabled", autoFavoriteEnabled)
TweenService:Create(startFavoriteToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoFavoriteEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(favoriteKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoFavoriteEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
unfavoriteButton.MouseButton1Click:Connect(function()
task.spawn(function()
unfavoriteAllFruit()
startFavoriteToggle.BackgroundColor3 = rgb(48, 46, 58)
favoriteKnob.Position = UDim2.fromOffset(3, 3)
end)
end)
favoriteHeader.MouseButton1Click:Connect(function()
favoriteCategoryOpen = not favoriteCategoryOpen
if not favoriteCategoryOpen then
for _, filter in ipairs(filters) do
filter.setOpen(false)
end
directionOpen = false
directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
directionArrow.Rotation = 0
end
TweenService:Create(favoriteContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, favoriteCategoryOpen and favoriteBaseHeight or 0),
}):Play()
TweenService:Create(favoriteArrow, TweenInfo.new(0.18), {
Rotation = favoriteCategoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("FavoriteKg", favoriteKg)
screenGui:SetAttribute("FavoriteKgDirection", favoriteKgDirection)
screenGui:SetAttribute("AutoFavoriteEnabled", autoFavoriteEnabled)
end
createAutoFavoriteSection()
end
do
local function createAutoShovelSection()
local shovelHeader = Instance.new("TextButton")
shovelHeader.Name = "AutoShovelHeader"
shovelHeader.AutoButtonColor = false
shovelHeader.Text = ""
shovelHeader.BackgroundColor3 = palette.card
shovelHeader.BorderSizePixel = 0
shovelHeader.Size = UDim2.new(1, 0, 0, 31)
shovelHeader.LayoutOrder = 14
shovelHeader.Parent = list
corner(shovelHeader, 4)
local headerText = label(shovelHeader, "Auto Shovel", 13, palette.text, true)
headerText.Position = UDim2.fromOffset(10, 0)
headerText.Size = UDim2.new(1, -40, 1, 0)
local headerArrow = label(shovelHeader, "v", 14, rgb(210, 210, 216), true)
headerArrow.Position = UDim2.new(1, -28, 0, 0)
headerArrow.Size = UDim2.fromOffset(20, 31)
headerArrow.TextXAlignment = Enum.TextXAlignment.Center
local headerAccent = Instance.new("Frame")
headerAccent.BackgroundColor3 = palette.accent
headerAccent.BorderSizePixel = 0
headerAccent.Position = UDim2.new(0, 0, 1, -2)
headerAccent.Size = UDim2.new(1, 0, 0, 2)
headerAccent.Parent = shovelHeader
local shovelContent = Instance.new("Frame")
shovelContent.Name = "AutoShovelContent"
shovelContent.BackgroundTransparency = 1
shovelContent.BorderSizePixel = 0
shovelContent.ClipsDescendants = true
shovelContent.Size = UDim2.new(1, 0, 0, 0)
shovelContent.LayoutOrder = 15
shovelContent.Parent = list
local shovelFilters = {}
local function makeShovelFilter(name, titleText, descriptionText, y, choices, selectedValues, zIndex)
local entry = {open = false}
local row = Instance.new("Frame")
row.BackgroundColor3 = palette.card
row.BorderSizePixel = 0
row.Position = UDim2.fromOffset(0, y)
row.Size = UDim2.new(1, 0, 0, 48)
row.Parent = shovelContent
corner(row, 4)
local rowTitle = label(row, titleText, 12, palette.text, true)
rowTitle.Position = UDim2.fromOffset(10, 4)
rowTitle.Size = UDim2.new(0.62, -10, 0, 18)
local rowDescription = label(row, descriptionText, 10, palette.muted, false)
rowDescription.Position = UDim2.fromOffset(10, 21)
rowDescription.Size = UDim2.new(0.62, -10, 0, 20)
local button = Instance.new("TextButton")
button.Name = name .. "Button"
button.AutoButtonColor = false
button.Font = Enum.Font.GothamBold
button.TextSize = 11
button.TextColor3 = palette.text
button.TextXAlignment = Enum.TextXAlignment.Left
button.TextTruncate = Enum.TextTruncate.AtEnd
button.BackgroundColor3 = rgb(31, 26, 43)
button.BorderSizePixel = 0
button.Position = UDim2.new(0.62, 0, 0, 8)
button.Size = UDim2.new(0.38, -7, 0, 32)
button.Parent = row
corner(button, 4)
stroke(button, rgb(72, 48, 96), 0.45, 1)
padding(button, 10, 0, 30, 0)
local buttonArrow = label(button, "v", 13, rgb(210, 210, 216), true)
buttonArrow.Position = UDim2.new(1, -30, 0, 0)
buttonArrow.Size = UDim2.fromOffset(20, 32)
buttonArrow.TextXAlignment = Enum.TextXAlignment.Center
local panel = Instance.new("Frame")
panel.Name = name .. "Dropdown"
panel.BackgroundColor3 = rgb(18, 18, 25)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Position = UDim2.new(0.62, 0, 0, y + 44)
panel.Size = UDim2.new(0.38, -7, 0, 0)
panel.ZIndex = zIndex
panel.Parent = shovelContent
corner(panel, 4)
stroke(panel, rgb(91, 39, 124), 0.1, 1)
local search = Instance.new("TextBox")
search.Name = name .. "Search"
search.ClearTextOnFocus = false
search.PlaceholderText = "Search"
search.Text = ""
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = palette.text
search.PlaceholderColor3 = palette.muted
search.BackgroundColor3 = rgb(35, 27, 48)
search.BorderSizePixel = 0
search.Position = UDim2.fromOffset(4, 4)
search.Size = UDim2.new(1, -8, 0, 26)
search.ZIndex = zIndex + 1
search.Parent = panel
corner(search, 3)
local optionsList = Instance.new("ScrollingFrame")
optionsList.BackgroundTransparency = 1
optionsList.BorderSizePixel = 0
optionsList.CanvasSize = UDim2.fromOffset(0, 0)
optionsList.ScrollBarImageColor3 = palette.accent
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
local optionButtons = {}
local function refreshSummary()
local names = {}
for _, choice in ipairs(choices) do
if selectedValues[choice] then
table.insert(names, choice)
end
end
if #names == 0 then
button.Text = "Select Options"
button.TextColor3 = palette.muted
else
button.Text = table.concat(names, ", ")
button.TextColor3 = palette.text
end
end
local function updateCanvas()
local visible = 0
for _, option in ipairs(optionButtons) do
if option.Visible then visible += 1 end
end
optionsList.CanvasSize = UDim2.fromOffset(0, math.max(0, visible * 28 - 2))
end
for index, choice in ipairs(choices) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = choice
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextXAlignment = Enum.TextXAlignment.Left
option.BorderSizePixel = 0
option.Size = UDim2.new(1, 0, 0, 26)
option.LayoutOrder = index
option.ZIndex = zIndex + 2
option.Parent = optionsList
corner(option, 3)
padding(option, 10, 0, 0, 0)
local function render()
local selected = selectedValues[choice] == true
option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
option.BackgroundTransparency = selected and 0.1 or 0.35
end
render()
option.MouseButton1Click:Connect(function()
selectedValues[choice] = not selectedValues[choice] or nil
render()
refreshSummary()
end)
table.insert(optionButtons, option)
end
refreshSummary()
updateCanvas()
search:GetPropertyChangedSignal("Text"):Connect(function()
local query = string.lower(search.Text)
for _, option in ipairs(optionButtons) do
option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
end
optionsList.CanvasPosition = Vector2.zero
updateCanvas()
end)
function entry.setOpen(open)
entry.open = open
panel.Size = UDim2.new(0.38, -7, 0, open and (y >= 247 and 160 or 178) or 0)
buttonArrow.Rotation = open and 180 or 0
end
button.MouseButton1Click:Connect(function()
for _, other in ipairs(shovelFilters) do
if other ~= entry then other.setOpen(false) end
end
entry.setOpen(not entry.open)
end)
table.insert(shovelFilters, entry)
end
makeShovelFilter("ShovelPlantName", "Shovel Plant Name", "Choose plants the shovel can remove.", 0, favoriteFruitOptions, selectedShovelPlants, 170)
makeShovelFilter("ShovelPlantRarity", "Shovel Plant Rarity", "Remove plants from these rarities.", 54, rarityOptions, selectedShovelRarities, 180)
local speedRow = Instance.new("Frame")
speedRow.BackgroundColor3 = palette.card
speedRow.BorderSizePixel = 0
speedRow.Position = UDim2.fromOffset(0, 108)
speedRow.Size = UDim2.new(1, 0, 0, 42)
speedRow.Parent = shovelContent
corner(speedRow, 4)
local speedTitle = label(speedRow, "Shovel Speed", 12, palette.text, true)
speedTitle.Position = UDim2.fromOffset(10, 3)
speedTitle.Size = UDim2.new(0.61, -10, 0, 18)
local speedDescription = label(speedRow, "Set 0 for turbo speed (no extra delay).", 10, palette.muted, false)
speedDescription.Position = UDim2.fromOffset(10, 20)
speedDescription.Size = UDim2.new(0.61, -10, 0, 16)
local speedValue = label(speedRow, tostring(shovelSpeed), 11, palette.text, true)
speedValue.Name = "ShovelSpeedValue"
speedValue.BackgroundColor3 = rgb(35, 27, 48)
speedValue.BackgroundTransparency = 0
speedValue.BorderSizePixel = 0
speedValue.Position = UDim2.new(0.62, 0, 0, 11)
speedValue.Size = UDim2.fromOffset(32, 20)
speedValue.TextXAlignment = Enum.TextXAlignment.Center
corner(speedValue, 4)
stroke(speedValue, palette.accent, 0.05, 1)
local speedTrack = Instance.new("Frame")
speedTrack.Name = "ShovelSpeedSlider"
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
speedFill.Size = UDim2.new(shovelSpeed / 10, 0, 1, 0)
speedFill.Parent = speedTrack
corner(speedFill, 3)
local speedKnob = Instance.new("Frame")
speedKnob.BackgroundColor3 = palette.accent
speedKnob.BorderSizePixel = 0
speedKnob.AnchorPoint = Vector2.new(0.5, 0.5)
speedKnob.Position = UDim2.new(shovelSpeed / 10, 0, 0.5, 0)
speedKnob.Size = UDim2.fromOffset(10, 10)
speedKnob.Parent = speedTrack
corner(speedKnob, 5)
local draggingSpeed = false
local function updateSpeed(screenX)
if speedTrack.AbsoluteSize.X <= 0 then return end
local alpha = math.clamp((screenX - speedTrack.AbsolutePosition.X) / speedTrack.AbsoluteSize.X, 0, 1)
shovelSpeed = math.floor(alpha * 10 + 0.5)
local snapped = shovelSpeed / 10
speedValue.Text = tostring(shovelSpeed)
speedFill.Size = UDim2.new(snapped, 0, 1, 0)
speedKnob.Position = UDim2.new(snapped, 0, 0.5, 0)
screenGui:SetAttribute("ShovelSpeed", shovelSpeed)
end
speedTrack.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
draggingSpeed = true
updateSpeed(input.Position.X)
end
end)
speedTrack.InputChanged:Connect(function(input)
if draggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
updateSpeed(input.Position.X)
end
end)
speedTrack.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
draggingSpeed = false
end
end)
local startRow = Instance.new("Frame")
startRow.BackgroundColor3 = palette.card
startRow.BorderSizePixel = 0
startRow.Position = UDim2.fromOffset(0, 156)
startRow.Size = UDim2.new(1, 0, 0, 48)
startRow.Parent = shovelContent
corner(startRow, 4)
local startTitle = label(startRow, "Start Shovel Plant", 12, palette.text, true)
startTitle.Position = UDim2.fromOffset(10, 4)
startTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDescription = label(startRow, "Automatically shovels matching plants.", 10, palette.muted, false)
startDescription.Position = UDim2.fromOffset(10, 21)
startDescription.Size = UDim2.new(0.76, -10, 0, 20)
local startToggle = Instance.new("TextButton")
startToggle.Name = "StartShovelPlantToggle"
startToggle.AutoButtonColor = false
startToggle.Text = ""
startToggle.BackgroundColor3 = autoShovelEnabled and palette.accent or rgb(48, 46, 58)
startToggle.BorderSizePixel = 0
startToggle.Position = UDim2.new(1, -50, 0.5, -11)
startToggle.Size = UDim2.fromOffset(38, 22)
startToggle.Parent = startRow
corner(startToggle, 11)
stroke(startToggle, rgb(116, 70, 152), autoShovelEnabled and 0.15 or 0.45, 1)
local startKnob = Instance.new("Frame")
startKnob.BackgroundColor3 = rgb(239, 239, 243)
startKnob.BorderSizePixel = 0
startKnob.Position = autoShovelEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
startKnob.Size = UDim2.fromOffset(16, 16)
startKnob.Parent = startToggle
corner(startKnob, 8)
local controllerRow = Instance.new("Frame")
controllerRow.Name = "ShovelFruitControllerHeader"
controllerRow.BackgroundColor3 = rgb(28, 20, 35)
controllerRow.BorderSizePixel = 0
controllerRow.Position = UDim2.fromOffset(0, 210)
controllerRow.Size = UDim2.new(1, 0, 0, 31)
controllerRow.Parent = shovelContent
corner(controllerRow, 3)
local controllerText = label(controllerRow, "- [ Shovel Fruit Controller ] -", 11, palette.text, true)
controllerText.Position = UDim2.fromOffset(10, 0)
controllerText.Size = UDim2.new(1, -20, 1, 0)
local function createShovelFruitController()
makeShovelFilter("ShovelFruitName", "Shovel Fruit Name", "Choose fruit names the shovel can remove.", 247, favoriteFruitOptions, selectedShovelFruits, 190)
makeShovelFilter("ShovelFruitRarity", "Shovel Fruit Rarity", "Remove fruits from these rarities.", 301, rarityOptions, selectedShovelFruitRarities, 200)
local kgRow = Instance.new("Frame")
kgRow.BackgroundColor3 = palette.card
kgRow.BorderSizePixel = 0
kgRow.Position = UDim2.fromOffset(0, 355)
kgRow.Size = UDim2.new(1, 0, 0, 48)
kgRow.Parent = shovelContent
corner(kgRow, 4)
local kgTitle = label(kgRow, "Input Your Kg", 12, palette.text, true)
kgTitle.Position = UDim2.fromOffset(10, 4)
kgTitle.Size = UDim2.new(0.62, -10, 0, 18)
local kgDescription = label(kgRow, "Set the KG number for this filter.", 10, palette.muted, false)
kgDescription.Position = UDim2.fromOffset(10, 21)
kgDescription.Size = UDim2.new(0.62, -10, 0, 20)
local kgInput = Instance.new("TextBox")
kgInput.Name = "ShovelFruitKgInput"
kgInput.ClearTextOnFocus = false
kgInput.Text = tostring(shovelFruitKg)
kgInput.Font = Enum.Font.GothamMedium
kgInput.TextSize = 11
kgInput.TextColor3 = palette.text
kgInput.TextXAlignment = Enum.TextXAlignment.Left
kgInput.BackgroundColor3 = rgb(31, 26, 43)
kgInput.BorderSizePixel = 0
kgInput.Position = UDim2.new(0.62, 0, 0, 8)
kgInput.Size = UDim2.new(0.38, -7, 0, 32)
kgInput.Parent = kgRow
corner(kgInput, 4)
stroke(kgInput, rgb(125, 49, 166), 0.2, 1)
padding(kgInput, 8, 0, 8, 0)
local directionRow = Instance.new("Frame")
directionRow.BackgroundColor3 = palette.card
directionRow.BorderSizePixel = 0
directionRow.Position = UDim2.fromOffset(0, 409)
directionRow.Size = UDim2.new(1, 0, 0, 48)
directionRow.Parent = shovelContent
corner(directionRow, 4)
local directionTitle = label(directionRow, "KG Direction", 12, palette.text, true)
directionTitle.Position = UDim2.fromOffset(10, 4)
directionTitle.Size = UDim2.new(0.62, -10, 0, 18)
local directionDescription = label(directionRow, "Up means this KG and higher. Below means lower than this KG.", 10, palette.muted, false)
directionDescription.Position = UDim2.fromOffset(10, 21)
directionDescription.Size = UDim2.new(0.62, -10, 0, 22)
directionDescription.TextWrapped = true
local directionButton = Instance.new("TextButton")
directionButton.Name = "ShovelFruitKgDirectionButton"
directionButton.AutoButtonColor = false
directionButton.Text = shovelFruitKgDirection
directionButton.Font = Enum.Font.GothamBold
directionButton.TextSize = 11
directionButton.TextColor3 = palette.text
directionButton.TextXAlignment = Enum.TextXAlignment.Left
directionButton.BackgroundColor3 = rgb(31, 26, 43)
directionButton.BorderSizePixel = 0
directionButton.Position = UDim2.new(0.62, 0, 0, 8)
directionButton.Size = UDim2.new(0.38, -7, 0, 32)
directionButton.Parent = directionRow
corner(directionButton, 4)
stroke(directionButton, rgb(72, 48, 96), 0.45, 1)
padding(directionButton, 10, 0, 30, 0)
local directionArrow = label(directionButton, "v", 13, rgb(210, 210, 216), true)
directionArrow.Position = UDim2.new(1, -30, 0, 0)
directionArrow.Size = UDim2.fromOffset(20, 32)
directionArrow.TextXAlignment = Enum.TextXAlignment.Center
local directionPanel = Instance.new("Frame")
directionPanel.Name = "ShovelFruitKgDirectionDropdown"
directionPanel.BackgroundColor3 = rgb(18, 18, 25)
directionPanel.BorderSizePixel = 0
directionPanel.ClipsDescendants = true
directionPanel.Position = UDim2.new(0.62, 0, 0, 453)
directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
directionPanel.ZIndex = 210
directionPanel.Parent = shovelContent
corner(directionPanel, 4)
stroke(directionPanel, rgb(91, 39, 124), 0.1, 1)
local directionLayout = Instance.new("UIListLayout")
directionLayout.SortOrder = Enum.SortOrder.LayoutOrder
directionLayout.Padding = UDim.new(0, 2)
directionLayout.Parent = directionPanel
local directionOpen = false
for index, directionName in ipairs({"Up", "Below"}) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = directionName
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, 0, 0, 28)
option.LayoutOrder = index
option.ZIndex = 211
option.Parent = directionPanel
padding(option, 10, 0, 0, 0)
option.MouseButton1Click:Connect(function()
shovelFruitKgDirection = directionName
directionButton.Text = directionName
directionOpen = false
directionPanel.Size = UDim2.new(0.38, -7, 0, 0)
directionArrow.Rotation = 0
screenGui:SetAttribute("ShovelFruitKgDirection", directionName)
end)
end
directionButton.MouseButton1Click:Connect(function()
for _, filter in ipairs(shovelFilters) do filter.setOpen(false) end
directionOpen = not directionOpen
directionPanel.Size = UDim2.new(0.38, -7, 0, directionOpen and 58 or 0)
directionArrow.Rotation = directionOpen and 180 or 0
end)
local fruitStartRow = Instance.new("Frame")
fruitStartRow.BackgroundColor3 = palette.card
fruitStartRow.BorderSizePixel = 0
fruitStartRow.Position = UDim2.fromOffset(0, 463)
fruitStartRow.Size = UDim2.new(1, 0, 0, 48)
fruitStartRow.Parent = shovelContent
corner(fruitStartRow, 4)
local fruitStartTitle = label(fruitStartRow, "Start Shovel Fruit", 12, palette.text, true)
fruitStartTitle.Position = UDim2.fromOffset(10, 4)
fruitStartTitle.Size = UDim2.new(0.76, -10, 0, 18)
local fruitStartDescription = label(fruitStartRow, "Automatically shovels matching fruits.", 10, palette.muted, false)
fruitStartDescription.Position = UDim2.fromOffset(10, 21)
fruitStartDescription.Size = UDim2.new(0.76, -10, 0, 20)
local fruitStartToggle = Instance.new("TextButton")
fruitStartToggle.Name = "StartShovelFruitToggle"
fruitStartToggle.AutoButtonColor = false
fruitStartToggle.Text = ""
fruitStartToggle.BackgroundColor3 = autoShovelFruitEnabled and palette.accent or rgb(48, 46, 58)
fruitStartToggle.BorderSizePixel = 0
fruitStartToggle.Position = UDim2.new(1, -50, 0.5, -11)
fruitStartToggle.Size = UDim2.fromOffset(38, 22)
fruitStartToggle.Parent = fruitStartRow
corner(fruitStartToggle, 11)
stroke(fruitStartToggle, rgb(116, 70, 152), autoShovelFruitEnabled and 0.15 or 0.45, 1)
local fruitStartKnob = Instance.new("Frame")
fruitStartKnob.BackgroundColor3 = rgb(239, 239, 243)
fruitStartKnob.BorderSizePixel = 0
fruitStartKnob.Position = autoShovelFruitEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
fruitStartKnob.Size = UDim2.fromOffset(16, 16)
fruitStartKnob.Parent = fruitStartToggle
corner(fruitStartKnob, 8)
local function commitFruitKg()
local normalizedText = string.gsub(kgInput.Text, ",", ".")
shovelFruitKg = math.max(0, tonumber(normalizedText) or 0)
kgInput.Text = tostring(shovelFruitKg)
screenGui:SetAttribute("ShovelFruitKg", shovelFruitKg)
end
kgInput.FocusLost:Connect(commitFruitKg)
fruitStartToggle.MouseButton1Click:Connect(function()
commitFruitKg()
autoShovelFruitEnabled = not autoShovelFruitEnabled
autoShovelFruitRunId += 1
if autoShovelFruitEnabled then
autoShovelEnabled = false
autoShovelRunId += 1
screenGui:SetAttribute("AutoShovelEnabled", false)
startToggle.BackgroundColor3 = rgb(48, 46, 58)
startKnob.Position = UDim2.fromOffset(3, 3)
screenGui:SetAttribute("AutoShovelFruitStatus", "Checking fruits")
runAutoShovelFruit(autoShovelFruitRunId)
else
screenGui:SetAttribute("AutoShovelFruitStatus", "Stopped")
end
screenGui:SetAttribute("AutoShovelFruitEnabled", autoShovelFruitEnabled)
TweenService:Create(fruitStartToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoShovelFruitEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(fruitStartKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoShovelFruitEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
screenGui:SetAttribute("ShovelFruitKg", shovelFruitKg)
screenGui:SetAttribute("ShovelFruitKgDirection", shovelFruitKgDirection)
screenGui:SetAttribute("AutoShovelFruitEnabled", autoShovelFruitEnabled)
end
createShovelFruitController()
local categoryOpen = false
local baseHeight = 511
startToggle.MouseButton1Click:Connect(function()
autoShovelEnabled = not autoShovelEnabled
autoShovelRunId += 1
if autoShovelEnabled then
autoShovelFruitEnabled = false
autoShovelFruitRunId += 1
screenGui:SetAttribute("AutoShovelFruitEnabled", false)
local fruitToggle = screenGui:FindFirstChild("StartShovelFruitToggle", true)
if fruitToggle then
fruitToggle.BackgroundColor3 = rgb(48, 46, 58)
local knob = fruitToggle:FindFirstChildWhichIsA("Frame")
if knob then knob.Position = UDim2.fromOffset(3, 3) end
end
screenGui:SetAttribute("AutoShovelStatus", "Checking plants")
runAutoShovel(autoShovelRunId)
else
screenGui:SetAttribute("AutoShovelStatus", "Stopped")
end
screenGui:SetAttribute("AutoShovelEnabled", autoShovelEnabled)
TweenService:Create(startToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoShovelEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(startKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoShovelEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
shovelHeader.MouseButton1Click:Connect(function()
categoryOpen = not categoryOpen
if not categoryOpen then
for _, filter in ipairs(shovelFilters) do filter.setOpen(false) end
end
TweenService:Create(shovelContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, categoryOpen and baseHeight or 0),
}):Play()
TweenService:Create(headerArrow, TweenInfo.new(0.18), {
Rotation = categoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("ShovelSpeed", shovelSpeed)
screenGui:SetAttribute("AutoShovelEnabled", autoShovelEnabled)
end
createAutoShovelSection()
end
do
local function createAutoTrowelSection()
local trowelHeader = Instance.new("TextButton")
trowelHeader.Name = "AutoTrowelHeader"
trowelHeader.AutoButtonColor = false
trowelHeader.Text = ""
trowelHeader.BackgroundColor3 = palette.card
trowelHeader.BorderSizePixel = 0
trowelHeader.Size = UDim2.new(1, 0, 0, 31)
trowelHeader.LayoutOrder = 16
trowelHeader.Parent = list
corner(trowelHeader, 4)
local headerText = label(trowelHeader, "Auto Trowel", 13, palette.text, true)
headerText.Position = UDim2.fromOffset(10, 0)
headerText.Size = UDim2.new(1, -40, 1, 0)
local headerArrow = label(trowelHeader, "v", 14, rgb(210, 210, 216), true)
headerArrow.Position = UDim2.new(1, -28, 0, 0)
headerArrow.Size = UDim2.fromOffset(20, 31)
headerArrow.TextXAlignment = Enum.TextXAlignment.Center
local headerAccent = Instance.new("Frame")
headerAccent.BackgroundColor3 = palette.accent
headerAccent.BorderSizePixel = 0
headerAccent.Position = UDim2.new(0, 0, 1, -2)
headerAccent.Size = UDim2.new(1, 0, 0, 2)
headerAccent.Parent = trowelHeader
local trowelContent = Instance.new("Frame")
trowelContent.Name = "AutoTrowelContent"
trowelContent.BackgroundTransparency = 1
trowelContent.BorderSizePixel = 0
trowelContent.ClipsDescendants = true
trowelContent.Size = UDim2.new(1, 0, 0, 0)
trowelContent.LayoutOrder = 17
trowelContent.Parent = list
local dropdowns = {}
local function closeDropdowns(except)
for _, dropdown in ipairs(dropdowns) do
if dropdown ~= except then dropdown.setOpen(false) end
end
end
local function makeMultiFilter(name, titleText, descriptionText, y, choices, selected, zIndex)
local entry = {open = false}
local row = Instance.new("Frame")
row.BackgroundColor3 = palette.card
row.BorderSizePixel = 0
row.Position = UDim2.fromOffset(0, y)
row.Size = UDim2.new(1, 0, 0, 48)
row.Parent = trowelContent
corner(row, 4)
local rowTitle = label(row, titleText, 12, palette.text, true)
rowTitle.Position = UDim2.fromOffset(10, 4)
rowTitle.Size = UDim2.new(0.62, -10, 0, 18)
local rowDescription = label(row, descriptionText, 10, palette.muted, false)
rowDescription.Position = UDim2.fromOffset(10, 21)
rowDescription.Size = UDim2.new(0.62, -10, 0, 20)
local button = Instance.new("TextButton")
button.Name = name .. "Button"
button.AutoButtonColor = false
button.Font = Enum.Font.GothamBold
button.TextSize = 11
button.TextColor3 = palette.text
button.TextXAlignment = Enum.TextXAlignment.Left
button.TextTruncate = Enum.TextTruncate.AtEnd
button.BackgroundColor3 = rgb(31, 26, 43)
button.BorderSizePixel = 0
button.Position = UDim2.new(0.62, 0, 0, 8)
button.Size = UDim2.new(0.38, -7, 0, 32)
button.Parent = row
corner(button, 4)
stroke(button, rgb(72, 48, 96), 0.45, 1)
padding(button, 10, 0, 30, 0)
local buttonArrow = label(button, "v", 13, rgb(210, 210, 216), true)
buttonArrow.Position = UDim2.new(1, -30, 0, 0)
buttonArrow.Size = UDim2.fromOffset(20, 32)
buttonArrow.TextXAlignment = Enum.TextXAlignment.Center
local panel = Instance.new("Frame")
panel.Name = name .. "Dropdown"
panel.BackgroundColor3 = rgb(18, 18, 25)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Position = UDim2.new(0.62, 0, 0, y + 44)
panel.Size = UDim2.new(0.38, -7, 0, 0)
panel.ZIndex = zIndex
panel.Parent = trowelContent
corner(panel, 4)
stroke(panel, rgb(91, 39, 124), 0.1, 1)
local search = Instance.new("TextBox")
search.ClearTextOnFocus = false
search.PlaceholderText = "Search"
search.Text = ""
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = palette.text
search.PlaceholderColor3 = palette.muted
search.BackgroundColor3 = rgb(35, 27, 48)
search.BorderSizePixel = 0
search.Position = UDim2.fromOffset(4, 4)
search.Size = UDim2.new(1, -8, 0, 26)
search.ZIndex = zIndex + 1
search.Parent = panel
corner(search, 3)
local optionList = Instance.new("ScrollingFrame")
optionList.BackgroundTransparency = 1
optionList.BorderSizePixel = 0
optionList.CanvasSize = UDim2.fromOffset(0, 0)
optionList.ScrollBarImageColor3 = palette.accent
optionList.ScrollBarThickness = 3
optionList.Position = UDim2.fromOffset(4, 34)
optionList.Size = UDim2.new(1, -8, 1, -38)
optionList.ZIndex = zIndex + 1
optionList.Parent = panel
local optionLayout = Instance.new("UIListLayout")
optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
optionLayout.Padding = UDim.new(0, 2)
optionLayout.Parent = optionList
local optionButtons = {}
local function refreshButton()
local names = {}
for _, choice in ipairs(choices) do
if selected[choice] then
table.insert(names, choice)
end
end
button.Text = #names == 0 and "Select Options" or table.concat(names, ", ")
button.TextColor3 = #names == 0 and palette.muted or palette.text
end
for index, choice in ipairs(choices) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = choice
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = selected[choice] and rgb(57, 22, 78) or rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, -3, 0, 27)
option.LayoutOrder = index
option.ZIndex = zIndex + 2
option.Parent = optionList
padding(option, 10, 0, 4, 0)
option.MouseButton1Click:Connect(function()
selected[choice] = not selected[choice] and true or nil
option.BackgroundColor3 = selected[choice] and rgb(57, 22, 78) or rgb(18, 18, 25)
refreshButton()
end)
table.insert(optionButtons, {button = option, choice = choice})
end
local function updateCanvas()
optionList.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
end
optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
search:GetPropertyChangedSignal("Text"):Connect(function()
local query = string.lower(search.Text)
for _, ref in ipairs(optionButtons) do
ref.button.Visible = query == "" or string.find(string.lower(ref.choice), query, 1, true) ~= nil
end
updateCanvas()
end)
function entry.setOpen(open)
entry.open = open
panel.Size = UDim2.new(0.38, -7, 0, open and 160 or 0)
buttonArrow.Rotation = open and 180 or 0
end
button.MouseButton1Click:Connect(function()
closeDropdowns(entry)
entry.setOpen(not entry.open)
end)
refreshButton()
table.insert(dropdowns, entry)
end
makeMultiFilter("TrowelPlantName", "Trowel Plant Name", "Choose which plants should be moved.", 0, favoriteFruitOptions, selectedTrowelPlants, 220)
makeMultiFilter("TrowelPlantRarity", "Trowel Plant Rarity", "Move plants from these rarities.", 54, rarityOptions, selectedTrowelRarities, 230)
local modeRow = Instance.new("Frame")
modeRow.BackgroundColor3 = palette.card
modeRow.BorderSizePixel = 0
modeRow.Position = UDim2.fromOffset(0, 108)
modeRow.Size = UDim2.new(1, 0, 0, 48)
modeRow.Parent = trowelContent
corner(modeRow, 4)
local modeTitle = label(modeRow, "Trowel Position Mode", 12, palette.text, true)
modeTitle.Position = UDim2.fromOffset(10, 4)
modeTitle.Size = UDim2.new(0.62, -10, 0, 18)
local modeDescription = label(modeRow, "Choose where selected plants should be moved.", 10, palette.muted, false)
modeDescription.Position = UDim2.fromOffset(10, 21)
modeDescription.Size = UDim2.new(0.62, -10, 0, 20)
local modeButton = Instance.new("TextButton")
modeButton.Name = "TrowelPositionModeButton"
modeButton.AutoButtonColor = false
modeButton.Text = trowelPositionMode
modeButton.Font = Enum.Font.GothamBold
modeButton.TextSize = 11
modeButton.TextColor3 = palette.text
modeButton.TextXAlignment = Enum.TextXAlignment.Left
modeButton.TextTruncate = Enum.TextTruncate.AtEnd
modeButton.BackgroundColor3 = rgb(31, 26, 43)
modeButton.BorderSizePixel = 0
modeButton.Position = UDim2.new(0.62, 0, 0, 8)
modeButton.Size = UDim2.new(0.38, -7, 0, 32)
modeButton.Parent = modeRow
corner(modeButton, 4)
stroke(modeButton, rgb(72, 48, 96), 0.45, 1)
padding(modeButton, 10, 0, 30, 0)
local modeArrow = label(modeButton, "v", 13, rgb(210, 210, 216), true)
modeArrow.Position = UDim2.new(1, -30, 0, 0)
modeArrow.Size = UDim2.fromOffset(20, 32)
modeArrow.TextXAlignment = Enum.TextXAlignment.Center
local modePanel = Instance.new("Frame")
modePanel.Name = "TrowelPositionModeDropdown"
modePanel.BackgroundColor3 = rgb(18, 18, 25)
modePanel.BorderSizePixel = 0
modePanel.ClipsDescendants = true
modePanel.Position = UDim2.new(0.62, 0, 0, 152)
modePanel.Size = UDim2.new(0.38, -7, 0, 0)
modePanel.ZIndex = 240
modePanel.Parent = trowelContent
corner(modePanel, 4)
stroke(modePanel, rgb(91, 39, 124), 0.1, 1)
local modeLayout = Instance.new("UIListLayout")
modeLayout.SortOrder = Enum.SortOrder.LayoutOrder
modeLayout.Padding = UDim.new(0, 2)
modeLayout.Parent = modePanel
local modeOpen = false
for index, modeName in ipairs({"Random Plot Position", "Saved Position", "Around Player"}) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = modeName
option.Font = Enum.Font.GothamMedium
option.TextSize = 10
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, 0, 0, 28)
option.LayoutOrder = index
option.ZIndex = 241
option.Parent = modePanel
padding(option, 8, 0, 2, 0)
option.MouseButton1Click:Connect(function()
trowelPositionMode = modeName
modeButton.Text = modeName
modeOpen = false
modePanel.Size = UDim2.new(0.38, -7, 0, 0)
modeArrow.Rotation = 0
screenGui:SetAttribute("TrowelPositionMode", modeName)
end)
end
modeButton.MouseButton1Click:Connect(function()
closeDropdowns()
modeOpen = not modeOpen
modePanel.Size = UDim2.new(0.38, -7, 0, modeOpen and 88 or 0)
modeArrow.Rotation = modeOpen and 180 or 0
end)
local setPositionButton = Instance.new("TextButton")
setPositionButton.Name = "SetTrowelPositionButton"
setPositionButton.AutoButtonColor = false
setPositionButton.Text = "Set Trowel Position"
setPositionButton.Font = Enum.Font.GothamBold
setPositionButton.TextSize = 11
setPositionButton.TextColor3 = palette.text
setPositionButton.BackgroundColor3 = rgb(28, 33, 28)
setPositionButton.BorderSizePixel = 0
setPositionButton.Position = UDim2.fromOffset(0, 162)
setPositionButton.Size = UDim2.new(1, 0, 0, 40)
setPositionButton.Parent = trowelContent
corner(setPositionButton, 4)
setPositionButton.MouseButton1Click:Connect(function()
local plot = getPlayerPlot()
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local position = root and getPlotGroundPosition(plot, root.Position) or nil
if position then
savedTrowelPosition = position
trowelPositionMode = "Saved Position"
modeButton.Text = trowelPositionMode
setPositionButton.Text = "Position Saved"
screenGui:SetAttribute("TrowelPositionMode", trowelPositionMode)
screenGui:SetAttribute("SavedTrowelPosition", tostring(position))
task.delay(1.2, function()
if setPositionButton.Parent then setPositionButton.Text = "Set Trowel Position" end
end)
else
setPositionButton.Text = "Stand Inside Your Plot"
task.delay(1.2, function()
if setPositionButton.Parent then setPositionButton.Text = "Set Trowel Position" end
end)
end
end)
local delayRow = Instance.new("Frame")
delayRow.BackgroundColor3 = palette.card
delayRow.BorderSizePixel = 0
delayRow.Position = UDim2.fromOffset(0, 208)
delayRow.Size = UDim2.new(1, 0, 0, 48)
delayRow.Parent = trowelContent
corner(delayRow, 4)
local delayTitle = label(delayRow, "Trowel Delay", 12, palette.text, true)
delayTitle.Position = UDim2.fromOffset(10, 4)
delayTitle.Size = UDim2.new(0.62, -10, 0, 18)
local delayDescription = label(delayRow, "Wait time between each plant move.", 10, palette.muted, false)
delayDescription.Position = UDim2.fromOffset(10, 21)
delayDescription.Size = UDim2.new(0.62, -10, 0, 20)
local delayInput = Instance.new("TextBox")
delayInput.Name = "TrowelDelayInput"
delayInput.ClearTextOnFocus = false
delayInput.Text = tostring(trowelDelay)
delayInput.Font = Enum.Font.GothamMedium
delayInput.TextSize = 11
delayInput.TextColor3 = palette.text
delayInput.TextXAlignment = Enum.TextXAlignment.Left
delayInput.BackgroundColor3 = rgb(31, 26, 43)
delayInput.BorderSizePixel = 0
delayInput.Position = UDim2.new(0.62, 0, 0, 8)
delayInput.Size = UDim2.new(0.38, -7, 0, 32)
delayInput.Parent = delayRow
corner(delayInput, 4)
stroke(delayInput, rgb(125, 49, 166), 0.2, 1)
padding(delayInput, 8, 0, 8, 0)
local function commitDelay()
local normalized = string.gsub(delayInput.Text, ",", ".")
trowelDelay = math.clamp(tonumber(normalized) or 1, 0, 60)
delayInput.Text = tostring(trowelDelay)
screenGui:SetAttribute("TrowelDelay", trowelDelay)
end
delayInput.FocusLost:Connect(commitDelay)
local startRow = Instance.new("Frame")
startRow.BackgroundColor3 = palette.card
startRow.BorderSizePixel = 0
startRow.Position = UDim2.fromOffset(0, 262)
startRow.Size = UDim2.new(1, 0, 0, 48)
startRow.Parent = trowelContent
corner(startRow, 4)
local startTitle = label(startRow, "Start Auto Trowel", 12, palette.text, true)
startTitle.Position = UDim2.fromOffset(10, 4)
startTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDescription = label(startRow, "Automatically moves selected plants with your trowel.", 10, palette.muted, false)
startDescription.Position = UDim2.fromOffset(10, 21)
startDescription.Size = UDim2.new(0.76, -10, 0, 20)
local startToggle = Instance.new("TextButton")
startToggle.Name = "StartAutoTrowelToggle"
startToggle.AutoButtonColor = false
startToggle.Text = ""
startToggle.BackgroundColor3 = autoTrowelEnabled and palette.accent or rgb(48, 46, 58)
startToggle.BorderSizePixel = 0
startToggle.Position = UDim2.new(1, -50, 0.5, -11)
startToggle.Size = UDim2.fromOffset(38, 22)
startToggle.Parent = startRow
corner(startToggle, 11)
stroke(startToggle, rgb(116, 70, 152), autoTrowelEnabled and 0.15 or 0.45, 1)
local startKnob = Instance.new("Frame")
startKnob.BackgroundColor3 = rgb(239, 239, 243)
startKnob.BorderSizePixel = 0
startKnob.Position = autoTrowelEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
startKnob.Size = UDim2.fromOffset(16, 16)
startKnob.Parent = startToggle
corner(startKnob, 8)
startToggle.MouseButton1Click:Connect(function()
commitDelay()
autoTrowelEnabled = not autoTrowelEnabled
autoTrowelRunId += 1
if autoTrowelEnabled then
screenGui:SetAttribute("AutoTrowelStatus", "Checking plants")
runAutoTrowel(autoTrowelRunId)
else
screenGui:SetAttribute("AutoTrowelStatus", "Stopped")
end
screenGui:SetAttribute("AutoTrowelEnabled", autoTrowelEnabled)
TweenService:Create(startToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoTrowelEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(startKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoTrowelEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
local categoryOpen = false
trowelHeader.MouseButton1Click:Connect(function()
categoryOpen = not categoryOpen
if not categoryOpen then
closeDropdowns()
modeOpen = false
modePanel.Size = UDim2.new(0.38, -7, 0, 0)
modeArrow.Rotation = 0
end
TweenService:Create(trowelContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, categoryOpen and 310 or 0),
}):Play()
TweenService:Create(headerArrow, TweenInfo.new(0.18), {
Rotation = categoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("TrowelPositionMode", trowelPositionMode)
screenGui:SetAttribute("TrowelDelay", trowelDelay)
screenGui:SetAttribute("AutoTrowelEnabled", autoTrowelEnabled)
end
createAutoTrowelSection()
end
do
local function createAutoCollectDroppedSeedSection()
local collectHeader = Instance.new("TextButton")
collectHeader.Name = "AutoCollectDroppedSeedHeader"
collectHeader.AutoButtonColor = false
collectHeader.Text = ""
collectHeader.BackgroundColor3 = palette.card
collectHeader.BorderSizePixel = 0
collectHeader.Size = UDim2.new(1, 0, 0, 31)
collectHeader.LayoutOrder = 18
collectHeader.Parent = list
corner(collectHeader, 4)
local headerText = label(collectHeader, "Auto Collect Dropped Seed", 13, palette.text, true)
headerText.Position = UDim2.fromOffset(10, 0)
headerText.Size = UDim2.new(1, -40, 1, 0)
local headerArrow = label(collectHeader, "v", 14, rgb(210, 210, 216), true)
headerArrow.Position = UDim2.new(1, -28, 0, 0)
headerArrow.Size = UDim2.fromOffset(20, 31)
headerArrow.TextXAlignment = Enum.TextXAlignment.Center
local headerAccent = Instance.new("Frame")
headerAccent.BackgroundColor3 = palette.accent
headerAccent.BorderSizePixel = 0
headerAccent.Position = UDim2.new(0, 0, 1, -2)
headerAccent.Size = UDim2.new(1, 0, 0, 2)
headerAccent.Parent = collectHeader
local collectContent = Instance.new("Frame")
collectContent.Name = "AutoCollectDroppedSeedContent"
collectContent.BackgroundTransparency = 1
collectContent.BorderSizePixel = 0
collectContent.ClipsDescendants = true
collectContent.Size = UDim2.new(1, 0, 0, 0)
collectContent.LayoutOrder = 19
collectContent.Parent = list
local selectRow = Instance.new("Frame")
selectRow.BackgroundColor3 = palette.card
selectRow.BorderSizePixel = 0
selectRow.Position = UDim2.fromOffset(0, 0)
selectRow.Size = UDim2.new(1, 0, 0, 48)
selectRow.Parent = collectContent
corner(selectRow, 4)
local selectTitle = label(selectRow, "Select Collected Seed", 12, palette.text, true)
selectTitle.Position = UDim2.fromOffset(10, 4)
selectTitle.Size = UDim2.new(0.62, -10, 0, 18)
local selectDescription = label(selectRow, "Server: event seeds. User: all your normal seeds.", 10, palette.muted, false)
selectDescription.Position = UDim2.fromOffset(10, 21)
selectDescription.Size = UDim2.new(0.62, -10, 0, 20)
local selectButton = Instance.new("TextButton")
selectButton.Name = "CollectedSeedSelectionButton"
selectButton.AutoButtonColor = false
selectButton.Text = collectedSeedSelection
selectButton.Font = Enum.Font.GothamBold
selectButton.TextSize = 11
selectButton.TextColor3 = palette.text
selectButton.TextXAlignment = Enum.TextXAlignment.Left
selectButton.TextTruncate = Enum.TextTruncate.AtEnd
selectButton.BackgroundColor3 = rgb(31, 26, 43)
selectButton.BorderSizePixel = 0
selectButton.Position = UDim2.new(0.62, 0, 0, 8)
selectButton.Size = UDim2.new(0.38, -7, 0, 32)
selectButton.Parent = selectRow
corner(selectButton, 4)
stroke(selectButton, rgb(72, 48, 96), 0.45, 1)
padding(selectButton, 10, 0, 30, 0)
local selectArrow = label(selectButton, "v", 13, rgb(210, 210, 216), true)
selectArrow.Position = UDim2.new(1, -30, 0, 0)
selectArrow.Size = UDim2.fromOffset(20, 32)
selectArrow.TextXAlignment = Enum.TextXAlignment.Center
local selectPanel = Instance.new("Frame")
selectPanel.Name = "CollectedSeedSelectionDropdown"
selectPanel.BackgroundColor3 = rgb(18, 18, 25)
selectPanel.BorderSizePixel = 0
selectPanel.ClipsDescendants = true
selectPanel.Position = UDim2.new(0.62, 0, 0, 44)
selectPanel.Size = UDim2.new(0.38, -7, 0, 0)
selectPanel.ZIndex = 250
selectPanel.Parent = collectContent
corner(selectPanel, 4)
stroke(selectPanel, rgb(91, 39, 124), 0.1, 1)
local optionList = Instance.new("ScrollingFrame")
optionList.BackgroundTransparency = 1
optionList.BorderSizePixel = 0
optionList.CanvasSize = UDim2.fromOffset(0, 0)
optionList.ScrollBarImageColor3 = palette.accent
optionList.ScrollBarThickness = 3
optionList.Size = UDim2.new(1, 0, 1, 0)
optionList.ZIndex = 251
optionList.Parent = selectPanel
local optionLayout = Instance.new("UIListLayout")
optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
optionLayout.Padding = UDim.new(0, 2)
optionLayout.Parent = optionList
local collectOptions = {"Server", "User"}
local selectionOpen = false
for index, optionName in ipairs(collectOptions) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = optionName
option.Font = Enum.Font.GothamMedium
option.TextSize = 10
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = optionName == collectedSeedSelection and rgb(57, 22, 78) or rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, -3, 0, 27)
option.LayoutOrder = index
option.ZIndex = 252
option.Parent = optionList
padding(option, 10, 0, 3, 0)
option.MouseButton1Click:Connect(function()
collectedSeedSelection = optionName
selectButton.Text = optionName
selectionOpen = false
selectPanel.Size = UDim2.new(0.38, -7, 0, 0)
selectArrow.Rotation = 0
for _, other in ipairs(optionList:GetChildren()) do
if other:IsA("TextButton") then
other.BackgroundColor3 = other == option and rgb(57, 22, 78) or rgb(18, 18, 25)
end
end
screenGui:SetAttribute("CollectedSeedSelection", optionName)
end)
end
optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
optionList.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
end)
selectButton.MouseButton1Click:Connect(function()
selectionOpen = not selectionOpen
selectPanel.Size = UDim2.new(0.38, -7, 0, selectionOpen and 106 or 0)
selectArrow.Rotation = selectionOpen and 180 or 0
end)
local delayRow = Instance.new("Frame")
delayRow.BackgroundColor3 = palette.card
delayRow.BorderSizePixel = 0
delayRow.Position = UDim2.fromOffset(0, 54)
delayRow.Size = UDim2.new(1, 0, 0, 48)
delayRow.Parent = collectContent
corner(delayRow, 4)
local delayTitle = label(delayRow, "Collected Delay", 12, palette.text, true)
delayTitle.Position = UDim2.fromOffset(10, 4)
delayTitle.Size = UDim2.new(0.62, -10, 0, 18)
local delayDescription = label(delayRow, "Wait time between pickup checks.", 10, palette.muted, false)
delayDescription.Position = UDim2.fromOffset(10, 21)
delayDescription.Size = UDim2.new(0.62, -10, 0, 20)
local delayInput = Instance.new("TextBox")
delayInput.Name = "CollectedSeedDelayInput"
delayInput.ClearTextOnFocus = false
delayInput.Text = tostring(collectedSeedDelay)
delayInput.Font = Enum.Font.GothamMedium
delayInput.TextSize = 11
delayInput.TextColor3 = palette.text
delayInput.TextXAlignment = Enum.TextXAlignment.Left
delayInput.BackgroundColor3 = rgb(31, 26, 43)
delayInput.BorderSizePixel = 0
delayInput.Position = UDim2.new(0.62, 0, 0, 8)
delayInput.Size = UDim2.new(0.38, -7, 0, 32)
delayInput.Parent = delayRow
corner(delayInput, 4)
stroke(delayInput, rgb(125, 49, 166), 0.2, 1)
padding(delayInput, 8, 0, 8, 0)
local function commitDelay()
local normalized = string.gsub(delayInput.Text, ",", ".")
collectedSeedDelay = math.clamp(tonumber(normalized) or 0.5, 0.05, 60)
delayInput.Text = tostring(collectedSeedDelay)
screenGui:SetAttribute("CollectedSeedDelay", collectedSeedDelay)
end
delayInput.FocusLost:Connect(commitDelay)
local startRow = Instance.new("Frame")
startRow.BackgroundColor3 = palette.card
startRow.BorderSizePixel = 0
startRow.Position = UDim2.fromOffset(0, 108)
startRow.Size = UDim2.new(1, 0, 0, 48)
startRow.Parent = collectContent
corner(startRow, 4)
local startTitle = label(startRow, "Start Collect Dropped Seed", 12, palette.text, true)
startTitle.Position = UDim2.fromOffset(10, 4)
startTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDescription = label(startRow, "Automatically collects selected dropped seeds nearby.", 10, palette.muted, false)
startDescription.Position = UDim2.fromOffset(10, 21)
startDescription.Size = UDim2.new(0.76, -10, 0, 20)
local startToggle = Instance.new("TextButton")
startToggle.Name = "StartCollectDroppedSeedToggle"
startToggle.AutoButtonColor = false
startToggle.Text = ""
startToggle.BackgroundColor3 = autoCollectDroppedSeedEnabled and palette.accent or rgb(48, 46, 58)
startToggle.BorderSizePixel = 0
startToggle.Position = UDim2.new(1, -50, 0.5, -11)
startToggle.Size = UDim2.fromOffset(38, 22)
startToggle.Parent = startRow
corner(startToggle, 11)
stroke(startToggle, rgb(116, 70, 152), autoCollectDroppedSeedEnabled and 0.15 or 0.45, 1)
local startKnob = Instance.new("Frame")
startKnob.BackgroundColor3 = rgb(239, 239, 243)
startKnob.BorderSizePixel = 0
startKnob.Position = autoCollectDroppedSeedEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
startKnob.Size = UDim2.fromOffset(16, 16)
startKnob.Parent = startToggle
corner(startKnob, 8)
startToggle.MouseButton1Click:Connect(function()
commitDelay()
autoCollectDroppedSeedEnabled = not autoCollectDroppedSeedEnabled
autoCollectDroppedSeedRunId += 1
if autoCollectDroppedSeedEnabled then
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", "Checking nearby seeds")
runAutoCollectDroppedSeed(autoCollectDroppedSeedRunId)
else
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", "Stopped")
end
screenGui:SetAttribute("AutoCollectDroppedSeedEnabled", autoCollectDroppedSeedEnabled)
TweenService:Create(startToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoCollectDroppedSeedEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(startKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoCollectDroppedSeedEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
local categoryOpen = false
collectHeader.MouseButton1Click:Connect(function()
categoryOpen = not categoryOpen
if not categoryOpen then
selectionOpen = false
selectPanel.Size = UDim2.new(0.38, -7, 0, 0)
selectArrow.Rotation = 0
end
TweenService:Create(collectContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, categoryOpen and 156 or 0),
}):Play()
TweenService:Create(headerArrow, TweenInfo.new(0.18), {
Rotation = categoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("CollectedSeedSelection", collectedSeedSelection)
screenGui:SetAttribute("CollectedSeedDelay", collectedSeedDelay)
screenGui:SetAttribute("AutoCollectDroppedSeedEnabled", autoCollectDroppedSeedEnabled)
end
createAutoCollectDroppedSeedSection()
end
do
local function createAutoSellPetSection()
local petHeader = Instance.new("TextButton")
petHeader.Name = "AutoSellPetHeader"
petHeader.AutoButtonColor = false
petHeader.Text = ""
petHeader.BackgroundColor3 = palette.card
petHeader.BorderSizePixel = 0
petHeader.Size = UDim2.new(1, 0, 0, 31)
petHeader.LayoutOrder = 20
petHeader.Parent = list
corner(petHeader, 4)
local headerText = label(petHeader, "Auto Sell Pet", 13, palette.text, true)
headerText.Position = UDim2.fromOffset(10, 0)
headerText.Size = UDim2.new(1, -40, 1, 0)
local headerArrow = label(petHeader, "v", 14, rgb(210, 210, 216), true)
headerArrow.Position = UDim2.new(1, -28, 0, 0)
headerArrow.Size = UDim2.fromOffset(20, 31)
headerArrow.TextXAlignment = Enum.TextXAlignment.Center
local headerAccent = Instance.new("Frame")
headerAccent.BackgroundColor3 = palette.accent
headerAccent.BorderSizePixel = 0
headerAccent.Position = UDim2.new(0, 0, 1, -2)
headerAccent.Size = UDim2.new(1, 0, 0, 2)
headerAccent.Parent = petHeader
local petContent = Instance.new("Frame")
petContent.Name = "AutoSellPetContent"
petContent.BackgroundTransparency = 1
petContent.BorderSizePixel = 0
petContent.ClipsDescendants = true
petContent.Size = UDim2.new(1, 0, 0, 0)
petContent.LayoutOrder = 21
petContent.Parent = list
local filters = {}
local function closeFilters(except)
for _, filter in ipairs(filters) do
if filter ~= except then filter.setOpen(false) end
end
end
local function makePetFilter(name, titleText, descriptionText, y, selected, zIndex)
local entry = {open = false}
local row = Instance.new("Frame")
row.BackgroundColor3 = palette.card
row.BorderSizePixel = 0
row.Position = UDim2.fromOffset(0, y)
row.Size = UDim2.new(1, 0, 0, 48)
row.Parent = petContent
corner(row, 4)
local rowTitle = label(row, titleText, 12, palette.text, true)
rowTitle.Position = UDim2.fromOffset(10, 4)
rowTitle.Size = UDim2.new(0.62, -10, 0, 18)
local rowDescription = label(row, descriptionText, 10, palette.muted, false)
rowDescription.Position = UDim2.fromOffset(10, 21)
rowDescription.Size = UDim2.new(0.62, -10, 0, 20)
local button = Instance.new("TextButton")
button.Name = name .. "Button"
button.AutoButtonColor = false
button.Font = Enum.Font.GothamBold
button.TextSize = 11
button.TextColor3 = palette.text
button.TextXAlignment = Enum.TextXAlignment.Left
button.TextTruncate = Enum.TextTruncate.AtEnd
button.BackgroundColor3 = rgb(31, 26, 43)
button.BorderSizePixel = 0
button.Position = UDim2.new(0.62, 0, 0, 8)
button.Size = UDim2.new(0.38, -7, 0, 32)
button.Parent = row
corner(button, 4)
stroke(button, rgb(72, 48, 96), 0.45, 1)
padding(button, 10, 0, 30, 0)
local buttonArrow = label(button, "v", 13, rgb(210, 210, 216), true)
buttonArrow.Position = UDim2.new(1, -30, 0, 0)
buttonArrow.Size = UDim2.fromOffset(20, 32)
buttonArrow.TextXAlignment = Enum.TextXAlignment.Center
local panel = Instance.new("Frame")
panel.Name = name .. "Dropdown"
panel.BackgroundColor3 = rgb(18, 18, 25)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Position = UDim2.new(0.62, 0, 0, y + 44)
panel.Size = UDim2.new(0.38, -7, 0, 0)
panel.ZIndex = zIndex
panel.Parent = petContent
corner(panel, 4)
stroke(panel, rgb(91, 39, 124), 0.1, 1)
local search = Instance.new("TextBox")
search.ClearTextOnFocus = false
search.PlaceholderText = "Search"
search.Text = ""
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = palette.text
search.PlaceholderColor3 = palette.muted
search.BackgroundColor3 = rgb(35, 27, 48)
search.BorderSizePixel = 0
search.Position = UDim2.fromOffset(4, 4)
search.Size = UDim2.new(1, -8, 0, 26)
search.ZIndex = zIndex + 1
search.Parent = panel
corner(search, 3)
local optionList = Instance.new("ScrollingFrame")
optionList.BackgroundTransparency = 1
optionList.BorderSizePixel = 0
optionList.CanvasSize = UDim2.fromOffset(0, 0)
optionList.ScrollBarImageColor3 = palette.accent
optionList.ScrollBarThickness = 3
optionList.Position = UDim2.fromOffset(4, 34)
optionList.Size = UDim2.new(1, -8, 1, -38)
optionList.ZIndex = zIndex + 1
optionList.Parent = panel
local optionLayout = Instance.new("UIListLayout")
optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
optionLayout.Padding = UDim.new(0, 2)
optionLayout.Parent = optionList
local optionRefs = {}
local currentChoices = {}
local function refreshButton()
local count = selectionCount(selected)
if (name == "SellPetNames" or name == "SellPetRarity") and count > 0 then
local visible = {}
for _, choice in ipairs(currentChoices) do
if selected[choice] then table.insert(visible, choice) end
end
button.Text = table.concat(visible, ", ")
elseif name == "BlacklistPetVariant" and count > 0 then
local visible = {}
for _, choice in ipairs(currentChoices) do
if selected[choice] then table.insert(visible, choice) end
end
button.Text = #visible > 2 and (visible[1] .. ", " .. visible[2] .. ",...") or table.concat(visible, ", ")
else
button.Text = count == 0 and "Select Options" or (count == 1 and next(selected) or tostring(count) .. " Selected")
end
end
local function updateCanvas()
optionList.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
end
function entry.rebuild(choices)
currentChoices = choices
for _, ref in ipairs(optionRefs) do ref.button:Destroy() end
table.clear(optionRefs)
for index, choice in ipairs(choices) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = choice
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextColor3 = palette.text
option.TextXAlignment = Enum.TextXAlignment.Left
option.BackgroundColor3 = selected[choice] and rgb(57, 22, 78) or rgb(18, 18, 25)
option.BorderSizePixel = 0
option.Size = UDim2.new(1, -3, 0, 27)
option.LayoutOrder = index
option.ZIndex = zIndex + 2
option.Parent = optionList
padding(option, 10, 0, 4, 0)
option.MouseButton1Click:Connect(function()
selected[choice] = not selected[choice] and true or nil
option.BackgroundColor3 = selected[choice] and rgb(57, 22, 78) or rgb(18, 18, 25)
refreshButton()
end)
table.insert(optionRefs, {button = option, choice = choice})
end
refreshButton()
updateCanvas()
end
search:GetPropertyChangedSignal("Text"):Connect(function()
local query = string.lower(search.Text)
for _, ref in ipairs(optionRefs) do
ref.button.Visible = query == "" or string.find(string.lower(ref.choice), query, 1, true) ~= nil
end
updateCanvas()
end)
optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
function entry.setOpen(open)
entry.open = open
panel.Size = UDim2.new(0.38, -7, 0, open and 160 or 0)
buttonArrow.Rotation = open and 180 or 0
end
button.MouseButton1Click:Connect(function()
closeFilters(entry)
entry.setOpen(not entry.open)
end)
refreshButton()
table.insert(filters, entry)
return entry
end
local namesFilter = makePetFilter("SellPetNames", "Sell Pet Names", "Choose pet names to sell from your inventory.", 0, selectedSellPetNames, 260)
local rarityFilter = makePetFilter("SellPetRarity", "Sell Pet Rarity", "Sell pets from these rarities.", 54, selectedSellPetRarities, 270)
namesFilter.rebuild(getInventoryPetNames())
rarityFilter.rebuild(rarityOptions)
local refreshButton = Instance.new("TextButton")
refreshButton.Name = "RefreshPetNamesButton"
refreshButton.AutoButtonColor = false
refreshButton.Text = "Refresh Pet Names"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 11
refreshButton.TextColor3 = palette.text
refreshButton.BackgroundColor3 = rgb(28, 33, 28)
refreshButton.BorderSizePixel = 0
refreshButton.Position = UDim2.fromOffset(0, 108)
refreshButton.Size = UDim2.new(1, 0, 0, 40)
refreshButton.Parent = petContent
corner(refreshButton, 4)
refreshButton.MouseButton1Click:Connect(function()
namesFilter.rebuild(getInventoryPetNames())
refreshButton.Text = "Pet Names Refreshed"
task.delay(1, function()
if refreshButton.Parent then refreshButton.Text = "Refresh Pet Names" end
end)
end)
local advancedRow = Instance.new("Frame")
advancedRow.BackgroundColor3 = rgb(28, 20, 35)
advancedRow.BorderSizePixel = 0
advancedRow.Position = UDim2.fromOffset(0, 154)
advancedRow.Size = UDim2.new(1, 0, 0, 31)
advancedRow.Parent = petContent
corner(advancedRow, 3)
local advancedText = label(advancedRow, "- [ Advanced Filter ] -", 11, palette.text, true)
advancedText.Position = UDim2.fromOffset(10, 0)
advancedText.Size = UDim2.new(1, -20, 1, 0)
local variantFilter = makePetFilter("BlacklistPetVariant", "Blacklist Variant (Never Sell)", "Pets with these variants are never sold. Keep all selected for safety.", 191, blacklistedPetVariants, 280)
variantFilter.rebuild({"Big", "Huge", "Rainbow", "Mega"})
local delayRow = Instance.new("Frame")
delayRow.BackgroundColor3 = palette.card
delayRow.BorderSizePixel = 0
delayRow.Position = UDim2.fromOffset(0, 245)
delayRow.Size = UDim2.new(1, 0, 0, 48)
delayRow.Parent = petContent
corner(delayRow, 4)
local delayTitle = label(delayRow, "Sell Pet Delay", 12, palette.text, true)
delayTitle.Position = UDim2.fromOffset(10, 4)
delayTitle.Size = UDim2.new(0.62, -10, 0, 18)
local delayDescription = label(delayRow, "Wait time between each pet sale.", 10, palette.muted, false)
delayDescription.Position = UDim2.fromOffset(10, 21)
delayDescription.Size = UDim2.new(0.62, -10, 0, 20)
local delayInput = Instance.new("TextBox")
delayInput.Name = "SellPetDelayInput"
delayInput.ClearTextOnFocus = false
delayInput.Text = tostring(sellPetDelay)
delayInput.Font = Enum.Font.GothamMedium
delayInput.TextSize = 11
delayInput.TextColor3 = palette.text
delayInput.TextXAlignment = Enum.TextXAlignment.Left
delayInput.BackgroundColor3 = rgb(31, 26, 43)
delayInput.BorderSizePixel = 0
delayInput.Position = UDim2.new(0.62, 0, 0, 8)
delayInput.Size = UDim2.new(0.38, -7, 0, 32)
delayInput.Parent = delayRow
corner(delayInput, 4)
stroke(delayInput, rgb(125, 49, 166), 0.2, 1)
padding(delayInput, 8, 0, 8, 0)
local function commitDelay()
local normalized = string.gsub(delayInput.Text, ",", ".")
sellPetDelay = math.clamp(tonumber(normalized) or 0.5, 0.05, 60)
delayInput.Text = tostring(sellPetDelay)
screenGui:SetAttribute("SellPetDelay", sellPetDelay)
end
delayInput.FocusLost:Connect(commitDelay)
local startRow = Instance.new("Frame")
startRow.BackgroundColor3 = palette.card
startRow.BorderSizePixel = 0
startRow.Position = UDim2.fromOffset(0, 299)
startRow.Size = UDim2.new(1, 0, 0, 48)
startRow.Parent = petContent
corner(startRow, 4)
local startTitle = label(startRow, "Start Sell Pet", 12, palette.text, true)
startTitle.Position = UDim2.fromOffset(10, 4)
startTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDescription = label(startRow, "Sells matching pets. Blacklisted variants are always kept.", 10, palette.muted, false)
startDescription.Position = UDim2.fromOffset(10, 21)
startDescription.Size = UDim2.new(0.76, -10, 0, 20)
local startToggle = Instance.new("TextButton")
startToggle.Name = "StartSellPetToggle"
startToggle.AutoButtonColor = false
startToggle.Text = ""
startToggle.BackgroundColor3 = autoSellPetEnabled and palette.accent or rgb(48, 46, 58)
startToggle.BorderSizePixel = 0
startToggle.Position = UDim2.new(1, -50, 0.5, -11)
startToggle.Size = UDim2.fromOffset(38, 22)
startToggle.Parent = startRow
corner(startToggle, 11)
stroke(startToggle, rgb(116, 70, 152), autoSellPetEnabled and 0.15 or 0.45, 1)
local startKnob = Instance.new("Frame")
startKnob.BackgroundColor3 = rgb(239, 239, 243)
startKnob.BorderSizePixel = 0
startKnob.Position = autoSellPetEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
startKnob.Size = UDim2.fromOffset(16, 16)
startKnob.Parent = startToggle
corner(startKnob, 8)
startToggle.MouseButton1Click:Connect(function()
commitDelay()
autoSellPetEnabled = not autoSellPetEnabled
autoSellPetRunId += 1
if autoSellPetEnabled then
screenGui:SetAttribute("AutoSellPetStatus", "Checking inventory")
runAutoSellPet(autoSellPetRunId)
else
screenGui:SetAttribute("AutoSellPetStatus", "Stopped")
end
screenGui:SetAttribute("AutoSellPetEnabled", autoSellPetEnabled)
TweenService:Create(startToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoSellPetEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(startKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoSellPetEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
end)
local categoryOpen = false
petHeader.MouseButton1Click:Connect(function()
categoryOpen = not categoryOpen
if not categoryOpen then closeFilters() end
TweenService:Create(petContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, categoryOpen and 403 or 0),
}):Play()
TweenService:Create(headerArrow, TweenInfo.new(0.18), {
Rotation = categoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("SellPetDelay", sellPetDelay)
screenGui:SetAttribute("AutoSellPetEnabled", autoSellPetEnabled)
screenGui:SetAttribute("BlacklistedPetVariants", "Big,Huge,Rainbow,Mega")
end
createAutoSellPetSection()
end
do
local function createAutoLeaveWeatherSection()
local weatherOptions = {"Rain", "Lightning", "Rainbow", "Snowfall", "Starfall", "Aurora", "Sunburst", "Eclipse"}
local weatherValues = ReplicatedStorage:FindFirstChild("WeatherValues")
local weatherHeader = Instance.new("TextButton")
weatherHeader.Name = "AutoLeaveWeatherHeader"
weatherHeader.AutoButtonColor = false
weatherHeader.Text = ""
weatherHeader.BackgroundColor3 = palette.card
weatherHeader.BorderSizePixel = 0
weatherHeader.Size = UDim2.new(1, 0, 0, 31)
weatherHeader.LayoutOrder = 22
weatherHeader.Parent = list
corner(weatherHeader, 4)
local headerText = label(weatherHeader, "Auto Leave Weather", 13, palette.text, true)
headerText.Position = UDim2.fromOffset(10, 0)
headerText.Size = UDim2.new(1, -40, 1, 0)
local headerArrow = label(weatherHeader, "v", 14, rgb(210, 210, 216), true)
headerArrow.Position = UDim2.new(1, -28, 0, 0)
headerArrow.Size = UDim2.fromOffset(20, 31)
headerArrow.TextXAlignment = Enum.TextXAlignment.Center
local headerAccent = Instance.new("Frame")
headerAccent.BackgroundColor3 = palette.accent
headerAccent.BorderSizePixel = 0
headerAccent.Position = UDim2.new(0, 0, 1, -2)
headerAccent.Size = UDim2.new(1, 0, 0, 2)
headerAccent.Parent = weatherHeader
local weatherContent = Instance.new("Frame")
weatherContent.Name = "AutoLeaveWeatherContent"
weatherContent.BackgroundTransparency = 1
weatherContent.BorderSizePixel = 0
weatherContent.ClipsDescendants = true
weatherContent.Size = UDim2.new(1, 0, 0, 0)
weatherContent.LayoutOrder = 23
weatherContent.Parent = list
local selectRow = Instance.new("Frame")
selectRow.BackgroundColor3 = palette.card
selectRow.BorderSizePixel = 0
selectRow.Position = UDim2.fromOffset(0, 0)
selectRow.Size = UDim2.new(1, 0, 0, 58)
selectRow.Parent = weatherContent
corner(selectRow, 4)
local selectTitle = label(selectRow, "Leave If Weather", 12, palette.text, true)
selectTitle.Position = UDim2.fromOffset(10, 4)
selectTitle.Size = UDim2.new(0.62, -10, 0, 18)
local selectDescription = label(selectRow, "If one of these weathers is running, you get kicked with a Yupisotes alert message.", 10, palette.muted, false)
selectDescription.Position = UDim2.fromOffset(10, 21)
selectDescription.Size = UDim2.new(0.62, -10, 0, 31)
selectDescription.TextWrapped = true
local selectButton = Instance.new("TextButton")
selectButton.Name = "LeaveWeatherSelectButton"
selectButton.AutoButtonColor = false
selectButton.Font = Enum.Font.GothamBold
selectButton.TextSize = 11
selectButton.TextColor3 = palette.muted
selectButton.TextXAlignment = Enum.TextXAlignment.Left
selectButton.TextTruncate = Enum.TextTruncate.AtEnd
selectButton.BackgroundColor3 = rgb(31, 26, 43)
selectButton.BorderSizePixel = 0
selectButton.Position = UDim2.new(0.62, 0, 0, 10)
selectButton.Size = UDim2.new(0.38, -7, 0, 32)
selectButton.Parent = selectRow
corner(selectButton, 4)
stroke(selectButton, rgb(72, 48, 96), 0.45, 1)
padding(selectButton, 10, 0, 30, 0)
local selectArrow = label(selectButton, "v", 13, rgb(210, 210, 216), true)
selectArrow.Position = UDim2.new(1, -30, 0, 0)
selectArrow.Size = UDim2.fromOffset(20, 32)
selectArrow.TextXAlignment = Enum.TextXAlignment.Center
local selectPanel = Instance.new("Frame")
selectPanel.Name = "LeaveWeatherDropdown"
selectPanel.BackgroundColor3 = rgb(18, 18, 25)
selectPanel.BorderSizePixel = 0
selectPanel.ClipsDescendants = true
selectPanel.Position = UDim2.new(0.62, 0, 0, 54)
selectPanel.Size = UDim2.new(0.38, -7, 0, 0)
selectPanel.ZIndex = 300
selectPanel.Parent = weatherContent
corner(selectPanel, 4)
stroke(selectPanel, rgb(91, 39, 124), 0.1, 1)
local search = Instance.new("TextBox")
search.Name = "LeaveWeatherSearch"
search.ClearTextOnFocus = false
search.PlaceholderText = "Search"
search.Text = ""
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextColor3 = palette.text
search.PlaceholderColor3 = palette.muted
search.BackgroundColor3 = rgb(35, 27, 48)
search.BorderSizePixel = 0
search.Position = UDim2.fromOffset(4, 4)
search.Size = UDim2.new(1, -8, 0, 26)
search.ZIndex = 301
search.Parent = selectPanel
corner(search, 3)
local optionList = Instance.new("ScrollingFrame")
optionList.BackgroundTransparency = 1
optionList.BorderSizePixel = 0
optionList.CanvasSize = UDim2.fromOffset(0, 0)
optionList.ScrollBarImageColor3 = palette.accent
optionList.ScrollBarThickness = 3
optionList.Position = UDim2.fromOffset(4, 34)
optionList.Size = UDim2.new(1, -8, 1, -38)
optionList.ZIndex = 301
optionList.Parent = selectPanel
local optionLayout = Instance.new("UIListLayout")
optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
optionLayout.Padding = UDim.new(0, 2)
optionLayout.Parent = optionList
local optionButtons = {}
local function selectedWeatherText()
local names = {}
for _, weatherName in ipairs(weatherOptions) do
if selectedLeaveWeathers[weatherName] then table.insert(names, weatherName) end
end
return names
end
local function refreshSummary()
local names = selectedWeatherText()
selectButton.Text = #names == 0 and "Select Options" or table.concat(names, ", ")
selectButton.TextColor3 = #names == 0 and palette.muted or palette.text
screenGui:SetAttribute("SelectedLeaveWeathers", table.concat(names, ","))
end
local function updateCanvas()
optionList.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
end
for index, weatherName in ipairs(weatherOptions) do
local option = Instance.new("TextButton")
option.AutoButtonColor = false
option.Text = weatherName
option.Font = Enum.Font.GothamMedium
option.TextSize = 11
option.TextXAlignment = Enum.TextXAlignment.Left
option.BorderSizePixel = 0
option.Size = UDim2.new(1, -3, 0, 27)
option.LayoutOrder = index
option.ZIndex = 302
option.Parent = optionList
corner(option, 3)
padding(option, 10, 0, 0, 0)
local function renderOption()
local selected = selectedLeaveWeathers[weatherName] == true
option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
option.BackgroundTransparency = selected and 0.1 or 0.35
end
renderOption()
option.MouseButton1Click:Connect(function()
selectedLeaveWeathers[weatherName] = not selectedLeaveWeathers[weatherName] and true or nil
renderOption()
refreshSummary()
end)
table.insert(optionButtons, option)
end
refreshSummary()
updateCanvas()
optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
search:GetPropertyChangedSignal("Text"):Connect(function()
local query = string.lower(search.Text)
for _, option in ipairs(optionButtons) do
option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
end
optionList.CanvasPosition = Vector2.zero
updateCanvas()
end)
local startRow = Instance.new("Frame")
startRow.BackgroundColor3 = palette.card
startRow.BorderSizePixel = 0
startRow.Position = UDim2.fromOffset(0, 64)
startRow.Size = UDim2.new(1, 0, 0, 48)
startRow.Parent = weatherContent
corner(startRow, 4)
local startTitle = label(startRow, "Start Auto Leave Weather", 12, palette.text, true)
startTitle.Position = UDim2.fromOffset(10, 4)
startTitle.Size = UDim2.new(0.76, -10, 0, 18)
local startDescription = label(startRow, "Checks the running weather and leaves the server when it matches.", 10, palette.muted, false)
startDescription.Position = UDim2.fromOffset(10, 21)
startDescription.Size = UDim2.new(0.76, -10, 0, 20)
local startToggle = Instance.new("TextButton")
startToggle.Name = "StartAutoLeaveWeatherToggle"
startToggle.AutoButtonColor = false
startToggle.Text = ""
startToggle.BackgroundColor3 = rgb(48, 46, 58)
startToggle.BorderSizePixel = 0
startToggle.Position = UDim2.new(1, -50, 0.5, -11)
startToggle.Size = UDim2.fromOffset(38, 22)
startToggle.Parent = startRow
corner(startToggle, 11)
stroke(startToggle, rgb(116, 70, 152), 0.45, 1)
local startKnob = Instance.new("Frame")
startKnob.BackgroundColor3 = rgb(239, 239, 243)
startKnob.BorderSizePixel = 0
startKnob.Position = UDim2.fromOffset(3, 3)
startKnob.Size = UDim2.fromOffset(16, 16)
startKnob.Parent = startToggle
corner(startKnob, 8)
local function activeSelectedWeather()
weatherValues = weatherValues or ReplicatedStorage:FindFirstChild("WeatherValues")
if not weatherValues then return nil end
for _, weatherName in ipairs(weatherOptions) do
if selectedLeaveWeathers[weatherName] and weatherValues:GetAttribute(weatherName .. "_Playing") == true then
return weatherName
end
end
return nil
end
local function runAutoLeaveWeather(runId)
local generation = autoPlantGeneration
task.spawn(function()
while autoLeaveWeatherEnabled and autoLeaveWeatherRunId == runId
and runtime.YupisotesGeneration == generation and screenGui.Parent do
local weatherName = activeSelectedWeather()
if weatherName then
screenGui:SetAttribute("AutoLeaveWeatherStatus", "Leaving: " .. weatherName)
task.wait(0.15)
player:Kick("[Yupisotes] Auto Leave Weather: " .. weatherName .. " is active.")
return
end
screenGui:SetAttribute("AutoLeaveWeatherStatus", "Watching selected weather")
task.wait(0.5)
end
end)
end
startToggle.MouseButton1Click:Connect(function()
if not autoLeaveWeatherEnabled and #selectedWeatherText() == 0 then
screenGui:SetAttribute("AutoLeaveWeatherStatus", "Select at least one weather")
return
end
autoLeaveWeatherEnabled = not autoLeaveWeatherEnabled
autoLeaveWeatherRunId += 1
screenGui:SetAttribute("AutoLeaveWeatherEnabled", autoLeaveWeatherEnabled)
TweenService:Create(startToggle, TweenInfo.new(0.18), {
BackgroundColor3 = autoLeaveWeatherEnabled and palette.accent or rgb(48, 46, 58),
}):Play()
TweenService:Create(startKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Position = autoLeaveWeatherEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
}):Play()
if autoLeaveWeatherEnabled then
runAutoLeaveWeather(autoLeaveWeatherRunId)
else
screenGui:SetAttribute("AutoLeaveWeatherStatus", "Stopped")
end
end)
local categoryOpen = false
local dropdownOpen = false
selectButton.MouseButton1Click:Connect(function()
dropdownOpen = not dropdownOpen
selectPanel.Size = UDim2.new(0.38, -7, 0, dropdownOpen and 160 or 0)
selectArrow.Rotation = dropdownOpen and 180 or 0
end)
weatherHeader.MouseButton1Click:Connect(function()
categoryOpen = not categoryOpen
if not categoryOpen then
dropdownOpen = false
selectPanel.Size = UDim2.new(0.38, -7, 0, 0)
selectArrow.Rotation = 0
end
TweenService:Create(weatherContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, categoryOpen and 220 or 0),
}):Play()
TweenService:Create(headerArrow, TweenInfo.new(0.18), {
Rotation = categoryOpen and 180 or 0,
}):Play()
end)
screenGui:SetAttribute("AutoLeaveWeatherEnabled", autoLeaveWeatherEnabled)
screenGui:SetAttribute("AutoLeaveWeatherStatus", "Stopped")
end
createAutoLeaveWeatherSection()
end
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
runtime.YupisotesShowShop = function()
	currentPage = "Shop"
	dropdownOpen = false
	disconnectSection()
	section.Visible = false
	setActiveTab("Shop")
	title.Text = "Shop"
	section.Parent = content
	clearList()
	accentLine.Visible = false
	farmSectionAccent.Visible = false
	list.Position = UDim2.fromOffset(0, 34)
	list.Size = UDim2.new(1, -2, 1, -35)
	list.CanvasPosition = Vector2.zero

	local state = runtime.YupisotesShopState
	local stockShop = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop")
	local stockItems = stockShop:WaitForChild("Items")
	local restockValue = stockShop:WaitForChild("UnixLastRestock")
	local entriesByName = {}
	for _, data in pairs(seedData) do
		if type(data) == "table" and type(data.SeedName) == "string" then
			entriesByName[data.SeedName] = data
		end
	end
	local shopSeeds = {}
	for _, value in ipairs(stockItems:GetChildren()) do
		if value:IsA("NumberValue") then table.insert(shopSeeds, value.Name) end
	end
	table.sort(shopSeeds, function(a, b)
		local aOrder = entriesByName[a] and entriesByName[a].SeedShopDisplayOrder or math.huge
		local bOrder = entriesByName[b] and entriesByName[b].SeedShopDisplayOrder or math.huge
		if aOrder == bOrder then return a < b end
		return aOrder < bOrder
	end)

	local function selectedTargets()
		local targets = {}
		local useRarity = selectionCount(state.selectedRarities) > 0
		for _, seedName in ipairs(shopSeeds) do
			local selected = useRarity and state.selectedRarities[seedRarities[seedName]] or state.selectedSeeds[seedName]
			if selected then table.insert(targets, seedName) end
		end
		return targets
	end

	local function ensureBuyLoop()
		state.runId += 1
		local runId = state.runId
		local generation = autoPlantGeneration
		task.spawn(function()
			while (state.limitedEnabled or state.alwaysEnabled) and state.runId == runId
				and runtime.YupisotesGeneration == generation and screenGui.Parent do
				local currentRestock = restockValue.Value
				if state.restockId ~= currentRestock then
					state.restockId = currentRestock
					state.purchasedThisRestock = {}
				end
				local targets = selectedTargets()
				if #targets == 0 then
					screenGui:SetAttribute("AutoBuySeedsStatus", "Select a seed or rarity")
					task.wait(0.5)
					continue
				end
				local attempted = false
				for _, seedName in ipairs(targets) do
					if state.runId ~= runId or not (state.limitedEnabled or state.alwaysEnabled) then break end
					local stockValue = stockItems:FindFirstChild(seedName)
					local stock = stockValue and stockValue.Value or 0
					local bought = state.purchasedThisRestock[seedName] or 0
					local shouldBuy = stock > 0 and (state.alwaysEnabled or bought < state.buyAmount)
					if shouldBuy then
						attempted = true
						local ok = pcall(function()
							networking.SeedShop.PurchaseSeed:Fire(seedName)
						end)
						if ok and state.limitedEnabled then
							state.purchasedThisRestock[seedName] = bought + 1
						end
						screenGui:SetAttribute("LastAutoBoughtSeed", seedName)
						screenGui:SetAttribute("AutoBuySeedsStatus", ok and ("Buying " .. seedName) or "Purchase failed")
						task.wait(0.16)
					end
				end
				if not attempted then
					screenGui:SetAttribute("AutoBuySeedsStatus", "Waiting for restock")
				end
				task.wait(0.35)
			end
		end)
	end

	local shopHeader = Instance.new("TextButton")
	shopHeader.Name = "AutoBuySeedsHeader"
	shopHeader.AutoButtonColor = false
	shopHeader.Text = ""
	shopHeader.BackgroundColor3 = palette.card
	shopHeader.BorderSizePixel = 0
	shopHeader.Size = UDim2.new(1, 0, 0, 31)
	shopHeader.LayoutOrder = 0
	shopHeader.Parent = list
	corner(shopHeader, 4)
	local headerText = label(shopHeader, "Auto Buy Seeds", 13, palette.text, true)
	headerText.Position = UDim2.fromOffset(10, 0)
	headerText.Size = UDim2.new(1, -40, 1, 0)
	local headerArrow = label(shopHeader, "v", 14, rgb(210, 210, 216), true)
	headerArrow.Position = UDim2.new(1, -28, 0, 0)
	headerArrow.Size = UDim2.fromOffset(20, 31)
	headerArrow.TextXAlignment = Enum.TextXAlignment.Center
	local headerAccent = Instance.new("Frame")
	headerAccent.BackgroundColor3 = palette.accent
	headerAccent.BorderSizePixel = 0
	headerAccent.Position = UDim2.new(0, 0, 1, -2)
	headerAccent.Size = UDim2.new(1, 0, 0, 2)
	headerAccent.Parent = shopHeader

	local shopContent = Instance.new("Frame")
	shopContent.Name = "AutoBuySeedsContent"
	shopContent.BackgroundTransparency = 1
	shopContent.BorderSizePixel = 0
	shopContent.ClipsDescendants = true
	shopContent.Size = UDim2.new(1, 0, 0, 0)
	shopContent.LayoutOrder = 1
	shopContent.Parent = list

	local filters = {}
	local function closeFilters(except)
		for _, filter in ipairs(filters) do
			if filter ~= except then filter.setOpen(false) end
		end
	end
	local function makeFilter(name, titleText, descriptionText, y, height, choices, selected, zIndex)
		local entry = {open = false}
		local row = Instance.new("Frame")
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, height)
		row.Parent = shopContent
		corner(row, 4)
		local rowTitle = label(row, titleText, 12, palette.text, true)
		rowTitle.Position = UDim2.fromOffset(10, 4)
		rowTitle.Size = UDim2.new(0.62, -10, 0, titleText == "Seed List" and 18 or 30)
		rowTitle.TextWrapped = true
		rowTitle.TextYAlignment = Enum.TextYAlignment.Top
		local rowDescription = label(row, descriptionText, 10, palette.muted, false)
		rowDescription.Position = UDim2.fromOffset(10, titleText == "Seed List" and 22 or 34)
		rowDescription.Size = UDim2.new(0.62, -10, 0, 20)
		rowDescription.TextWrapped = true

		local button = Instance.new("TextButton")
		button.Name = name .. "Button"
		button.AutoButtonColor = false
		button.Font = Enum.Font.GothamBold
		button.TextSize = 11
		button.TextColor3 = palette.muted
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.TextTruncate = Enum.TextTruncate.AtEnd
		button.BackgroundColor3 = rgb(31, 26, 43)
		button.BorderSizePixel = 0
		button.Position = UDim2.new(0.62, 0, 0, math.floor((height - 32) / 2))
		button.Size = UDim2.new(0.38, -7, 0, 32)
		button.Parent = row
		corner(button, 4)
		stroke(button, rgb(72, 48, 96), 0.45, 1)
		padding(button, 10, 0, 30, 0)
		local buttonArrow = label(button, "v", 13, rgb(210, 210, 216), true)
		buttonArrow.Position = UDim2.new(1, -30, 0, 0)
		buttonArrow.Size = UDim2.fromOffset(20, 32)
		buttonArrow.TextXAlignment = Enum.TextXAlignment.Center

		local panel = Instance.new("Frame")
		panel.Name = name .. "Dropdown"
		panel.BackgroundColor3 = rgb(18, 18, 25)
		panel.BorderSizePixel = 0
		panel.ClipsDescendants = true
		panel.Position = UDim2.new(0.62, 0, 0, y + height - 4)
		panel.Size = UDim2.new(0.38, -7, 0, 0)
		panel.ZIndex = zIndex
		panel.Parent = shopContent
		corner(panel, 4)
		stroke(panel, rgb(91, 39, 124), 0.1, 1)
		local searchBox = Instance.new("TextBox")
		searchBox.Name = name .. "Search"
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
		local optionList = Instance.new("ScrollingFrame")
		optionList.BackgroundTransparency = 1
		optionList.BorderSizePixel = 0
		optionList.CanvasSize = UDim2.fromOffset(0, 0)
		optionList.ScrollBarImageColor3 = palette.accent
		optionList.ScrollBarThickness = 3
		optionList.Position = UDim2.fromOffset(4, 34)
		optionList.Size = UDim2.new(1, -8, 1, -38)
		optionList.ZIndex = zIndex + 1
		optionList.Parent = panel
		local optionLayout = Instance.new("UIListLayout")
		optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
		optionLayout.Padding = UDim.new(0, 2)
		optionLayout.Parent = optionList
		local optionButtons = {}
		local function refreshSummary()
			local names = {}
			for _, choice in ipairs(choices) do
				if selected[choice] then table.insert(names, choice) end
			end
			button.Text = #names == 0 and "Select Options" or table.concat(names, ", ")
			button.TextColor3 = #names == 0 and palette.muted or palette.text
		end
		local function updateCanvas()
			optionList.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
		end
		for index, choice in ipairs(choices) do
			local option = Instance.new("TextButton")
			option.AutoButtonColor = false
			option.Text = choice
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.BorderSizePixel = 0
			option.Size = UDim2.new(1, -3, 0, 27)
			option.LayoutOrder = index
			option.ZIndex = zIndex + 2
			option.Parent = optionList
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			local function render()
				local isSelected = selected[choice] == true
				option.TextColor3 = isSelected and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = isSelected and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = isSelected and 0.1 or 0.35
			end
			render()
			option.MouseButton1Click:Connect(function()
				selected[choice] = not selected[choice] and true or nil
				render()
				refreshSummary()
			end)
			table.insert(optionButtons, option)
		end
		refreshSummary()
		updateCanvas()
		optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local query = string.lower(searchBox.Text)
			for _, option in ipairs(optionButtons) do
				option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
			end
			optionList.CanvasPosition = Vector2.zero
			updateCanvas()
		end)
		function entry.setOpen(open)
			entry.open = open
			panel.Size = UDim2.new(0.38, -7, 0, open and 170 or 0)
			buttonArrow.Rotation = open and 180 or 0
		end
		button.MouseButton1Click:Connect(function()
			closeFilters(entry)
			entry.setOpen(not entry.open)
		end)
		table.insert(filters, entry)
		return entry
	end

	makeFilter("ShopSeedList", "Seed List", "Choose which seeds to buy from restock.", 0, 58, shopSeeds, state.selectedSeeds, 320)
	makeFilter("ShopRarityList", "Rarity List (dont select Seed List if use this)", "Buy seeds from these rarities instead of selected names.", 64, 64, rarityOptions, state.selectedRarities, 330)

	local amountRow = Instance.new("Frame")
	amountRow.BackgroundColor3 = palette.card
	amountRow.BorderSizePixel = 0
	amountRow.Position = UDim2.fromOffset(0, 134)
	amountRow.Size = UDim2.new(1, 0, 0, 48)
	amountRow.Parent = shopContent
	corner(amountRow, 4)
	local amountTitle = label(amountRow, "Seeds Buy Amount", 12, palette.text, true)
	amountTitle.Position = UDim2.fromOffset(10, 4)
	amountTitle.Size = UDim2.new(0.62, -10, 0, 18)
	local amountDescription = label(amountRow, "How many seeds to buy from each restock.", 10, palette.muted, false)
	amountDescription.Position = UDim2.fromOffset(10, 21)
	amountDescription.Size = UDim2.new(0.62, -10, 0, 20)
	local amountInput = Instance.new("TextBox")
	amountInput.Name = "SeedsBuyAmountInput"
	amountInput.ClearTextOnFocus = false
	amountInput.Text = tostring(state.buyAmount)
	amountInput.Font = Enum.Font.GothamBold
	amountInput.TextSize = 11
	amountInput.TextColor3 = palette.text
	amountInput.TextXAlignment = Enum.TextXAlignment.Left
	amountInput.BackgroundColor3 = rgb(31, 26, 43)
	amountInput.BorderSizePixel = 0
	amountInput.Position = UDim2.new(0.62, 0, 0, 8)
	amountInput.Size = UDim2.new(0.38, -7, 0, 32)
	amountInput.Parent = amountRow
	corner(amountInput, 4)
	stroke(amountInput, rgb(91, 39, 124), 0.25, 1)
	padding(amountInput, 8, 0, 8, 0)
	local function commitAmount()
		state.buyAmount = math.clamp(math.floor(tonumber(amountInput.Text) or 1), 1, 999)
		amountInput.Text = tostring(state.buyAmount)
		screenGui:SetAttribute("SeedsBuyAmount", state.buyAmount)
	end
	amountInput.FocusLost:Connect(commitAmount)

	local toggleRefs = {}
	local function createToggle(name, titleText, descriptionText, y, stateKey)
		local row = Instance.new("Frame")
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, 48)
		row.Parent = shopContent
		corner(row, 4)
		local rowTitle = label(row, titleText, 12, palette.text, true)
		rowTitle.Position = UDim2.fromOffset(10, 4)
		rowTitle.Size = UDim2.new(0.78, -10, 0, 18)
		local rowDescription = label(row, descriptionText, 10, palette.muted, false)
		rowDescription.Position = UDim2.fromOffset(10, 21)
		rowDescription.Size = UDim2.new(0.78, -10, 0, 20)
		local toggle = Instance.new("TextButton")
		toggle.Name = name
		toggle.AutoButtonColor = false
		toggle.Text = ""
		toggle.BorderSizePixel = 0
		toggle.Position = UDim2.new(1, -50, 0.5, -11)
		toggle.Size = UDim2.fromOffset(38, 22)
		toggle.Parent = row
		corner(toggle, 11)
		stroke(toggle, rgb(116, 70, 152), 0.45, 1)
		local knob = Instance.new("Frame")
		knob.BackgroundColor3 = rgb(239, 239, 243)
		knob.BorderSizePixel = 0
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = toggle
		corner(knob, 8)
		local function render()
			local enabled = state[stateKey]
			TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundColor3 = enabled and palette.accent or rgb(48, 46, 58),
			}):Play()
			TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = enabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
			}):Play()
		end
		toggleRefs[stateKey] = {render = render}
		toggle.MouseButton1Click:Connect(function()
			commitAmount()
			state[stateKey] = not state[stateKey]
			if state[stateKey] then
				local otherKey = stateKey == "limitedEnabled" and "alwaysEnabled" or "limitedEnabled"
				state[otherKey] = false
			end
			for _, ref in pairs(toggleRefs) do ref.render() end
			screenGui:SetAttribute("BuySeedsIfRestockEnabled", state.limitedEnabled)
			screenGui:SetAttribute("AlwaysBuySeedsIfRestockEnabled", state.alwaysEnabled)
			if state.limitedEnabled or state.alwaysEnabled then
				state.restockId = nil
				ensureBuyLoop()
			else
				state.runId += 1
				screenGui:SetAttribute("AutoBuySeedsStatus", "Stopped")
			end
		end)
		render()
	end

	createToggle("AlwaysBuySeedsIfRestockToggle", "Always Buy Seeds If Restock", "Keeps buying your selected seeds while stock is available.", 188, "alwaysEnabled")

	local categoryOpen = false
	shopHeader.MouseButton1Click:Connect(function()
		categoryOpen = not categoryOpen
		if not categoryOpen then closeFilters() end
		TweenService:Create(shopContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, categoryOpen and 251 or 0),
		}):Play()
		TweenService:Create(headerArrow, TweenInfo.new(0.18), {
			Rotation = categoryOpen and 180 or 0,
		}):Play()
	end)

	screenGui:SetAttribute("SeedsBuyAmount", state.buyAmount)
	screenGui:SetAttribute("BuySeedsIfRestockEnabled", state.limitedEnabled)
	screenGui:SetAttribute("AlwaysBuySeedsIfRestockEnabled", state.alwaysEnabled)
	screenGui:SetAttribute("AutoBuySeedsStatus", "Stopped")

	local function createGearSection()
		local gearShop = ReplicatedStorage.StockValues:WaitForChild("GearShop")
		local gearItems = gearShop:WaitForChild("Items")
		local gearRestockValue = gearShop:WaitForChild("UnixLastRestock")
		local gearData = require(ReplicatedStorage.SharedModules:WaitForChild("GearShopData")).Data
		local gearNames = {}
		local oneTimeGear = {}
		for _, data in ipairs(gearData) do
			local gearName = data.Name or data.GearName or data.ItemName
			if type(gearName) == "string" and gearItems:FindFirstChild(gearName) then
				table.insert(gearNames, gearName)
				if data.EquippableGear == true then oneTimeGear[gearName] = true end
			end
		end

		local function getOwnedGear()
			local ok, result = pcall(function()
				return networking.GearShop.RequestEquippableState:Fire()
			end)
			if ok and type(result) == "table" and type(result.OwnedEquippableGears) == "table" then
				return result.OwnedEquippableGears
			end
			return {}
		end

		local function selectedGearTargets()
			local targets = {}
			for _, gearName in ipairs(gearNames) do
				if state.selectedGear[gearName] then table.insert(targets, gearName) end
			end
			return targets
		end

		local function ensureGearLoop()
			state.gearRunId += 1
			local runId = state.gearRunId
			local generation = autoPlantGeneration
			task.spawn(function()
				while (state.gearLimitedEnabled or state.gearAlwaysEnabled) and state.gearRunId == runId
					and runtime.YupisotesGeneration == generation and screenGui.Parent do
					local currentRestock = gearRestockValue.Value
					if state.gearRestockId ~= currentRestock then
						state.gearRestockId = currentRestock
						state.gearPurchasedThisRestock = {}
					end
					local targets = selectedGearTargets()
					if #targets == 0 then
						screenGui:SetAttribute("AutoBuyGearStatus", "Select at least one gear")
						task.wait(0.5)
						continue
					end
					local attempted = false
					local ownedFound = false
					for _, gearName in ipairs(targets) do
						if state.gearRunId ~= runId or not (state.gearLimitedEnabled or state.gearAlwaysEnabled) then break end
						local stockValue = gearItems:FindFirstChild(gearName)
						local stock = stockValue and stockValue.Value or 0
						local bought = state.gearPurchasedThisRestock[gearName] or 0
						local isOneTime = oneTimeGear[gearName] == true
						local ownedBefore = isOneTime and getOwnedGear()[gearName] == true
						local shouldBuy = (isOneTime and not ownedBefore)
							or (not isOneTime and stock > 0 and (state.gearAlwaysEnabled or bought < state.gearBuyAmount))
						if shouldBuy then
							attempted = true
							local leaderstats = player:FindFirstChild("leaderstats")
							local sheckles = leaderstats and leaderstats:FindFirstChild("Sheckles")
							local balanceBefore = sheckles and sheckles.Value
							local ok = pcall(function()
								networking.GearShop.PurchaseGear:Fire(gearName)
							end)
							-- The server ignores purchase requests sent too close together. Give it
							-- time to process and only count purchases confirmed by the balance.
							task.wait(0.4)
							local purchased = ok and ((isOneTime and getOwnedGear()[gearName] == true)
								or (not isOneTime and (not sheckles or sheckles.Value < balanceBefore)))
							if purchased and state.gearLimitedEnabled and not isOneTime then
								state.gearPurchasedThisRestock[gearName] = bought + 1
							end
							if purchased then
								screenGui:SetAttribute("LastAutoBoughtGear", gearName)
								screenGui:SetAttribute("AutoBuyGearStatus", "Bought " .. gearName)
							else
								screenGui:SetAttribute("AutoBuyGearStatus", "Retrying " .. gearName)
							end
						elseif ownedBefore then
							ownedFound = true
							screenGui:SetAttribute("AutoBuyGearStatus", "Already owned: " .. gearName)
						end
					end
					if not attempted and not ownedFound then screenGui:SetAttribute("AutoBuyGearStatus", "Waiting for restock") end
					task.wait(0.35)
				end
			end)
		end

		local gearHeader = Instance.new("TextButton")
		gearHeader.Name = "AutoBuyGearHeader"
		gearHeader.AutoButtonColor = false
		gearHeader.Text = ""
		gearHeader.BackgroundColor3 = palette.card
		gearHeader.BorderSizePixel = 0
		gearHeader.Size = UDim2.new(1, 0, 0, 31)
		gearHeader.LayoutOrder = 2
		gearHeader.Parent = list
		corner(gearHeader, 4)
		local headerText = label(gearHeader, "Auto Buy Gear", 13, palette.text, true)
		headerText.Position = UDim2.fromOffset(10, 0)
		headerText.Size = UDim2.new(1, -40, 1, 0)
		local headerArrow = label(gearHeader, "v", 14, rgb(210, 210, 216), true)
		headerArrow.Position = UDim2.new(1, -28, 0, 0)
		headerArrow.Size = UDim2.fromOffset(20, 31)
		headerArrow.TextXAlignment = Enum.TextXAlignment.Center
		local headerAccent = Instance.new("Frame")
		headerAccent.BackgroundColor3 = palette.accent
		headerAccent.BorderSizePixel = 0
		headerAccent.Position = UDim2.new(0, 0, 1, -2)
		headerAccent.Size = UDim2.new(1, 0, 0, 2)
		headerAccent.Parent = gearHeader

		local gearContent = Instance.new("Frame")
		gearContent.Name = "AutoBuyGearContent"
		gearContent.BackgroundTransparency = 1
		gearContent.BorderSizePixel = 0
		gearContent.ClipsDescendants = true
		gearContent.Size = UDim2.new(1, 0, 0, 0)
		gearContent.LayoutOrder = 3
		gearContent.Parent = list

		local gearRow = Instance.new("Frame")
		gearRow.BackgroundColor3 = palette.card
		gearRow.BorderSizePixel = 0
		gearRow.Position = UDim2.fromOffset(0, 0)
		gearRow.Size = UDim2.new(1, 0, 0, 58)
		gearRow.Parent = gearContent
		corner(gearRow, 4)
		local gearTitle = label(gearRow, "Gear List", 12, palette.text, true)
		gearTitle.Position = UDim2.fromOffset(10, 4)
		gearTitle.Size = UDim2.new(0.62, -10, 0, 18)
		local gearDescription = label(gearRow, "Choose which gear to buy from restock.", 10, palette.muted, false)
		gearDescription.Position = UDim2.fromOffset(10, 22)
		gearDescription.Size = UDim2.new(0.62, -10, 0, 20)

		local gearButton = Instance.new("TextButton")
		gearButton.Name = "ShopGearListButton"
		gearButton.AutoButtonColor = false
		gearButton.Font = Enum.Font.GothamBold
		gearButton.TextSize = 11
		gearButton.TextColor3 = palette.muted
		gearButton.TextXAlignment = Enum.TextXAlignment.Left
		gearButton.TextTruncate = Enum.TextTruncate.AtEnd
		gearButton.Text = "Select Options"
		gearButton.BackgroundColor3 = rgb(31, 26, 43)
		gearButton.BorderSizePixel = 0
		gearButton.Position = UDim2.new(0.62, 0, 0, 13)
		gearButton.Size = UDim2.new(0.38, -7, 0, 32)
		gearButton.Parent = gearRow
		corner(gearButton, 4)
		stroke(gearButton, rgb(72, 48, 96), 0.45, 1)
		padding(gearButton, 10, 0, 30, 0)
		local gearArrow = label(gearButton, "v", 13, rgb(210, 210, 216), true)
		gearArrow.Position = UDim2.new(1, -30, 0, 0)
		gearArrow.Size = UDim2.fromOffset(20, 32)
		gearArrow.TextXAlignment = Enum.TextXAlignment.Center

		local gearPanel = Instance.new("Frame")
		gearPanel.Name = "ShopGearListDropdown"
		gearPanel.BackgroundColor3 = rgb(18, 18, 25)
		gearPanel.BorderSizePixel = 0
		gearPanel.ClipsDescendants = true
		gearPanel.Position = UDim2.new(0.62, 0, 0, 54)
		gearPanel.Size = UDim2.new(0.38, -7, 0, 0)
		gearPanel.ZIndex = 340
		gearPanel.Parent = gearContent
		corner(gearPanel, 4)
		stroke(gearPanel, rgb(91, 39, 124), 0.1, 1)
		local searchBox = Instance.new("TextBox")
		searchBox.Name = "ShopGearListSearch"
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
		searchBox.ZIndex = 341
		searchBox.Parent = gearPanel
		corner(searchBox, 3)
		local optionList = Instance.new("ScrollingFrame")
		optionList.BackgroundTransparency = 1
		optionList.BorderSizePixel = 0
		optionList.CanvasSize = UDim2.fromOffset(0, 0)
		optionList.ScrollBarImageColor3 = palette.accent
		optionList.ScrollBarThickness = 3
		optionList.Position = UDim2.fromOffset(4, 34)
		optionList.Size = UDim2.new(1, -8, 1, -38)
		optionList.ZIndex = 341
		optionList.Parent = gearPanel
		local optionLayout = Instance.new("UIListLayout")
		optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
		optionLayout.Padding = UDim.new(0, 2)
		optionLayout.Parent = optionList
		local optionButtons = {}
		local function refreshGearSummary()
			local names = selectedGearTargets()
			gearButton.Text = #names == 0 and "Select Options" or table.concat(names, ", ")
			gearButton.TextColor3 = #names == 0 and palette.muted or palette.text
		end
		local function updateCanvas()
			optionList.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
		end
		for index, gearName in ipairs(gearNames) do
			local option = Instance.new("TextButton")
			option.AutoButtonColor = false
			option.Text = gearName
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.BorderSizePixel = 0
			option.Size = UDim2.new(1, -3, 0, 27)
			option.LayoutOrder = index
			option.ZIndex = 342
			option.Parent = optionList
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			local function render()
				local selected = state.selectedGear[gearName] == true
				option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = selected and 0.1 or 0.35
			end
			render()
			option.MouseButton1Click:Connect(function()
				state.selectedGear[gearName] = not state.selectedGear[gearName] and true or nil
				render()
				refreshGearSummary()
			end)
			table.insert(optionButtons, option)
		end
		refreshGearSummary()
		updateCanvas()
		optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local query = string.lower(searchBox.Text)
			for _, option in ipairs(optionButtons) do
				option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
			end
			optionList.CanvasPosition = Vector2.zero
			updateCanvas()
		end)

		local amountRow = Instance.new("Frame")
		amountRow.BackgroundColor3 = palette.card
		amountRow.BorderSizePixel = 0
		amountRow.Position = UDim2.fromOffset(0, 64)
		amountRow.Size = UDim2.new(1, 0, 0, 48)
		amountRow.Parent = gearContent
		corner(amountRow, 4)
		local amountTitle = label(amountRow, "Gear Buy Amount", 12, palette.text, true)
		amountTitle.Position = UDim2.fromOffset(10, 4)
		amountTitle.Size = UDim2.new(0.62, -10, 0, 18)
		local amountDescription = label(amountRow, "How many gear to buy from each restock.", 10, palette.muted, false)
		amountDescription.Position = UDim2.fromOffset(10, 21)
		amountDescription.Size = UDim2.new(0.62, -10, 0, 20)
		local amountInput = Instance.new("TextBox")
		amountInput.Name = "GearBuyAmountInput"
		amountInput.ClearTextOnFocus = false
		amountInput.Text = tostring(state.gearBuyAmount)
		amountInput.Font = Enum.Font.GothamBold
		amountInput.TextSize = 11
		amountInput.TextColor3 = palette.text
		amountInput.TextXAlignment = Enum.TextXAlignment.Left
		amountInput.BackgroundColor3 = rgb(31, 26, 43)
		amountInput.BorderSizePixel = 0
		amountInput.Position = UDim2.new(0.62, 0, 0, 8)
		amountInput.Size = UDim2.new(0.38, -7, 0, 32)
		amountInput.Parent = amountRow
		corner(amountInput, 4)
		stroke(amountInput, rgb(91, 39, 124), 0.25, 1)
		padding(amountInput, 8, 0, 8, 0)
		local function commitAmount()
			state.gearBuyAmount = math.clamp(math.floor(tonumber(amountInput.Text) or 1), 1, 999)
			amountInput.Text = tostring(state.gearBuyAmount)
			screenGui:SetAttribute("GearBuyAmount", state.gearBuyAmount)
		end
		amountInput.FocusLost:Connect(commitAmount)

		local toggleRefs = {}
		local function createToggle(name, titleText, descriptionText, y, key)
			local row = Instance.new("Frame")
			row.BackgroundColor3 = palette.card
			row.BorderSizePixel = 0
			row.Position = UDim2.fromOffset(0, y)
			row.Size = UDim2.new(1, 0, 0, 48)
			row.Parent = gearContent
			corner(row, 4)
			local rowTitle = label(row, titleText, 12, palette.text, true)
			rowTitle.Position = UDim2.fromOffset(10, 4)
			rowTitle.Size = UDim2.new(0.78, -10, 0, 18)
			local rowDescription = label(row, descriptionText, 10, palette.muted, false)
			rowDescription.Position = UDim2.fromOffset(10, 21)
			rowDescription.Size = UDim2.new(0.78, -10, 0, 20)
			local toggle = Instance.new("TextButton")
			toggle.Name = name
			toggle.AutoButtonColor = false
			toggle.Text = ""
			toggle.BorderSizePixel = 0
			toggle.Position = UDim2.new(1, -50, 0.5, -11)
			toggle.Size = UDim2.fromOffset(38, 22)
			toggle.Parent = row
			corner(toggle, 11)
			stroke(toggle, rgb(116, 70, 152), 0.45, 1)
			local knob = Instance.new("Frame")
			knob.BackgroundColor3 = rgb(239, 239, 243)
			knob.BorderSizePixel = 0
			knob.Size = UDim2.fromOffset(16, 16)
			knob.Parent = toggle
			corner(knob, 8)
			local function render()
				local enabled = state[key]
				TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					BackgroundColor3 = enabled and palette.accent or rgb(48, 46, 58),
				}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = enabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
				}):Play()
			end
			toggleRefs[key] = {render = render}
			toggle.MouseButton1Click:Connect(function()
				commitAmount()
				state[key] = not state[key]
				if state[key] then
					local otherKey = key == "gearLimitedEnabled" and "gearAlwaysEnabled" or "gearLimitedEnabled"
					state[otherKey] = false
				end
				for _, ref in pairs(toggleRefs) do ref.render() end
				screenGui:SetAttribute("BuyGearIfRestockEnabled", state.gearLimitedEnabled)
				screenGui:SetAttribute("AlwaysBuyGearIfRestockEnabled", state.gearAlwaysEnabled)
				if state.gearLimitedEnabled or state.gearAlwaysEnabled then
					state.gearRestockId = nil
					ensureGearLoop()
				else
					state.gearRunId += 1
					screenGui:SetAttribute("AutoBuyGearStatus", "Stopped")
				end
			end)
			render()
		end

		createToggle("AlwaysBuyGearIfRestockToggle", "Always Buy Gear If Restock", "Buys all available gear stock while you can afford it.", 118, "gearAlwaysEnabled")

		local categoryOpen = false
		local dropdownOpen = false
		gearButton.MouseButton1Click:Connect(function()
			dropdownOpen = not dropdownOpen
			gearPanel.Size = UDim2.new(0.38, -7, 0, dropdownOpen and 160 or 0)
			gearArrow.Rotation = dropdownOpen and 180 or 0
		end)
		gearHeader.MouseButton1Click:Connect(function()
			categoryOpen = not categoryOpen
			if not categoryOpen then
				dropdownOpen = false
				gearPanel.Size = UDim2.new(0.38, -7, 0, 0)
				gearArrow.Rotation = 0
			end
			TweenService:Create(gearContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, categoryOpen and 166 or 0),
			}):Play()
			TweenService:Create(headerArrow, TweenInfo.new(0.18), {
				Rotation = categoryOpen and 180 or 0,
			}):Play()
		end)

		screenGui:SetAttribute("GearBuyAmount", state.gearBuyAmount)
		screenGui:SetAttribute("BuyGearIfRestockEnabled", state.gearLimitedEnabled)
		screenGui:SetAttribute("AlwaysBuyGearIfRestockEnabled", state.gearAlwaysEnabled)
		screenGui:SetAttribute("AutoBuyGearStatus", "Stopped")
	end
	createGearSection()

	local function createPropertySection()
		local crateShop = ReplicatedStorage.StockValues:WaitForChild("CrateShop")
		local crateItems = crateShop:WaitForChild("Items")
		local crateRestockValue = crateShop:WaitForChild("UnixLastRestock")
		local propertyNames = {}
		for _, value in ipairs(crateItems:GetChildren()) do
			if value:IsA("NumberValue") then table.insert(propertyNames, value.Name) end
		end
		table.sort(propertyNames)

		local function selectedPropertyTargets()
			local targets = {}
			for _, propertyName in ipairs(propertyNames) do
				if state.selectedProps[propertyName] then table.insert(targets, propertyName) end
			end
			return targets
		end

		local function ensurePropertyLoop()
			state.propsRunId += 1
			local runId = state.propsRunId
			local generation = autoPlantGeneration
			task.spawn(function()
				while (state.propsLimitedEnabled or state.propsAlwaysEnabled) and state.propsRunId == runId
					and runtime.YupisotesGeneration == generation and screenGui.Parent do
					local currentRestock = crateRestockValue.Value
					if state.propsRestockId ~= currentRestock then
						state.propsRestockId = currentRestock
						state.propsPurchasedThisRestock = {}
					end
					local targets = selectedPropertyTargets()
					if #targets == 0 then
						screenGui:SetAttribute("AutoBuyPropertyStatus", "Select at least one property")
						task.wait(0.5)
						continue
					end
					local attempted = false
					for _, propertyName in ipairs(targets) do
						if state.propsRunId ~= runId or not (state.propsLimitedEnabled or state.propsAlwaysEnabled) then break end
						local stockValue = crateItems:FindFirstChild(propertyName)
						local stock = stockValue and stockValue.Value or 0
						local bought = state.propsPurchasedThisRestock[propertyName] or 0
						local shouldBuy = stock > 0 and (state.propsAlwaysEnabled or bought < state.propsBuyAmount)
						if shouldBuy then
							attempted = true
							local leaderstats = player:FindFirstChild("leaderstats")
							local sheckles = leaderstats and leaderstats:FindFirstChild("Sheckles")
							local balanceBefore = sheckles and sheckles.Value
							local ok = pcall(function()
								networking.CrateShop.PurchaseCrate:Fire(propertyName)
							end)
							task.wait(0.4)
							local purchased = ok and (not sheckles or sheckles.Value < balanceBefore)
							if purchased and state.propsLimitedEnabled then
								state.propsPurchasedThisRestock[propertyName] = bought + 1
							end
							if purchased then
								screenGui:SetAttribute("LastAutoBoughtProperty", propertyName)
								screenGui:SetAttribute("AutoBuyPropertyStatus", "Bought " .. propertyName)
							else
								screenGui:SetAttribute("AutoBuyPropertyStatus", "Retrying " .. propertyName)
							end
						end
					end
					if not attempted then screenGui:SetAttribute("AutoBuyPropertyStatus", "Waiting for restock") end
					task.wait(0.35)
				end
			end)
		end

		local propertyHeader = Instance.new("TextButton")
		propertyHeader.Name = "AutoBuyPropertyHeader"
		propertyHeader.AutoButtonColor = false
		propertyHeader.Text = ""
		propertyHeader.BackgroundColor3 = palette.card
		propertyHeader.BorderSizePixel = 0
		propertyHeader.Size = UDim2.new(1, 0, 0, 31)
		propertyHeader.LayoutOrder = 4
		propertyHeader.Parent = list
		corner(propertyHeader, 4)
		local propertyHeaderText = label(propertyHeader, "Auto Buy Property / Crate", 13, palette.text, true)
		propertyHeaderText.Position = UDim2.fromOffset(10, 0)
		propertyHeaderText.Size = UDim2.new(1, -40, 1, 0)
		local propertyHeaderArrow = label(propertyHeader, "v", 14, rgb(210, 210, 216), true)
		propertyHeaderArrow.Position = UDim2.new(1, -28, 0, 0)
		propertyHeaderArrow.Size = UDim2.fromOffset(20, 31)
		propertyHeaderArrow.TextXAlignment = Enum.TextXAlignment.Center
		local propertyAccent = Instance.new("Frame")
		propertyAccent.BackgroundColor3 = palette.accent
		propertyAccent.BorderSizePixel = 0
		propertyAccent.Position = UDim2.new(0, 0, 1, -2)
		propertyAccent.Size = UDim2.new(1, 0, 0, 2)
		propertyAccent.Parent = propertyHeader

		local propertyContent = Instance.new("Frame")
		propertyContent.Name = "AutoBuyPropertyContent"
		propertyContent.BackgroundTransparency = 1
		propertyContent.BorderSizePixel = 0
		propertyContent.ClipsDescendants = true
		propertyContent.Size = UDim2.new(1, 0, 0, 0)
		propertyContent.LayoutOrder = 5
		propertyContent.Parent = list

		local function makePropertyRow(titleText, descriptionText, y, height)
			local row = Instance.new("Frame")
			row.BackgroundColor3 = palette.card
			row.BorderSizePixel = 0
			row.Position = UDim2.fromOffset(0, y)
			row.Size = UDim2.new(1, 0, 0, height)
			row.Parent = propertyContent
			corner(row, 4)
			local rowTitle = label(row, titleText, 12, palette.text, true)
			rowTitle.Position = UDim2.fromOffset(10, 4)
			rowTitle.Size = UDim2.new(0.62, -10, 0, 18)
			local rowDescription = label(row, descriptionText, 10, palette.muted, false)
			rowDescription.Position = UDim2.fromOffset(10, 21)
			rowDescription.Size = UDim2.new(0.72, -10, 0, height - 24)
			return row
		end

		local propertyRow = makePropertyRow("Property List", "Choose which props or crates to buy from restock.", 0, 58)
		local propertyButton = Instance.new("TextButton")
		propertyButton.Name = "ShopPropertyListButton"
		propertyButton.AutoButtonColor = false
		propertyButton.Font = Enum.Font.GothamBold
		propertyButton.TextSize = 11
		propertyButton.TextColor3 = palette.muted
		propertyButton.TextXAlignment = Enum.TextXAlignment.Left
		propertyButton.TextTruncate = Enum.TextTruncate.AtEnd
		propertyButton.Text = "Select Options"
		propertyButton.BackgroundColor3 = rgb(31, 26, 43)
		propertyButton.BorderSizePixel = 0
		propertyButton.Position = UDim2.new(0.62, 0, 0, 13)
		propertyButton.Size = UDim2.new(0.38, -7, 0, 32)
		propertyButton.Parent = propertyRow
		corner(propertyButton, 4)
		stroke(propertyButton, rgb(72, 48, 96), 0.45, 1)
		padding(propertyButton, 10, 0, 30, 0)
		local propertyArrow = label(propertyButton, "v", 13, rgb(210, 210, 216), true)
		propertyArrow.Position = UDim2.new(1, -30, 0, 0)
		propertyArrow.Size = UDim2.fromOffset(20, 32)
		propertyArrow.TextXAlignment = Enum.TextXAlignment.Center

		local propertyPanel = Instance.new("Frame")
		propertyPanel.Name = "ShopPropertyListDropdown"
		propertyPanel.BackgroundColor3 = rgb(18, 18, 25)
		propertyPanel.BorderSizePixel = 0
		propertyPanel.ClipsDescendants = true
		propertyPanel.Position = UDim2.new(0.62, 0, 0, 54)
		propertyPanel.Size = UDim2.new(0.38, -7, 0, 0)
		propertyPanel.ZIndex = 360
		propertyPanel.Parent = propertyContent
		corner(propertyPanel, 4)
		stroke(propertyPanel, rgb(91, 39, 124), 0.1, 1)
		local propertySearch = Instance.new("TextBox")
		propertySearch.Name = "ShopPropertyListSearch"
		propertySearch.ClearTextOnFocus = false
		propertySearch.PlaceholderText = "Search"
		propertySearch.Text = ""
		propertySearch.Font = Enum.Font.GothamMedium
		propertySearch.TextSize = 11
		propertySearch.TextColor3 = palette.text
		propertySearch.PlaceholderColor3 = palette.muted
		propertySearch.BackgroundColor3 = rgb(35, 27, 48)
		propertySearch.BorderSizePixel = 0
		propertySearch.Position = UDim2.fromOffset(4, 4)
		propertySearch.Size = UDim2.new(1, -8, 0, 26)
		propertySearch.ZIndex = 361
		propertySearch.Parent = propertyPanel
		corner(propertySearch, 3)
		local propertyOptions = Instance.new("ScrollingFrame")
		propertyOptions.BackgroundTransparency = 1
		propertyOptions.BorderSizePixel = 0
		propertyOptions.CanvasSize = UDim2.fromOffset(0, 0)
		propertyOptions.ScrollBarImageColor3 = palette.accent
		propertyOptions.ScrollBarThickness = 3
		propertyOptions.Position = UDim2.fromOffset(4, 34)
		propertyOptions.Size = UDim2.new(1, -8, 1, -38)
		propertyOptions.ZIndex = 361
		propertyOptions.Parent = propertyPanel
		local propertyOptionLayout = Instance.new("UIListLayout")
		propertyOptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
		propertyOptionLayout.Padding = UDim.new(0, 2)
		propertyOptionLayout.Parent = propertyOptions
		local propertyOptionButtons = {}
		local function refreshPropertySummary()
			local names = selectedPropertyTargets()
			propertyButton.Text = #names == 0 and "Select Options" or table.concat(names, ", ")
			propertyButton.TextColor3 = #names == 0 and palette.muted or palette.text
		end
		local function updatePropertyCanvas()
			propertyOptions.CanvasSize = UDim2.fromOffset(0, propertyOptionLayout.AbsoluteContentSize.Y)
		end
		for index, propertyName in ipairs(propertyNames) do
			local option = Instance.new("TextButton")
			option.AutoButtonColor = false
			option.Text = propertyName
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.BorderSizePixel = 0
			option.Size = UDim2.new(1, -3, 0, 27)
			option.LayoutOrder = index
			option.ZIndex = 362
			option.Parent = propertyOptions
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			local function render()
				local selected = state.selectedProps[propertyName] == true
				option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = selected and 0.1 or 0.35
			end
			render()
			option.MouseButton1Click:Connect(function()
				state.selectedProps[propertyName] = not state.selectedProps[propertyName] and true or nil
				render()
				refreshPropertySummary()
			end)
			table.insert(propertyOptionButtons, option)
		end
		refreshPropertySummary()
		updatePropertyCanvas()
		propertyOptionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatePropertyCanvas)
		propertySearch:GetPropertyChangedSignal("Text"):Connect(function()
			local query = string.lower(propertySearch.Text)
			for _, option in ipairs(propertyOptionButtons) do
				option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
			end
			propertyOptions.CanvasPosition = Vector2.zero
			updatePropertyCanvas()
		end)

		local propertyAmountRow = makePropertyRow("Props Buy Amount", "How many props to buy from each restock.", 64, 48)
		local propertyAmountInput = Instance.new("TextBox")
		propertyAmountInput.Name = "PropsBuyAmountInput"
		propertyAmountInput.ClearTextOnFocus = false
		propertyAmountInput.Text = tostring(state.propsBuyAmount)
		propertyAmountInput.Font = Enum.Font.GothamBold
		propertyAmountInput.TextSize = 11
		propertyAmountInput.TextColor3 = palette.text
		propertyAmountInput.TextXAlignment = Enum.TextXAlignment.Left
		propertyAmountInput.BackgroundColor3 = rgb(31, 26, 43)
		propertyAmountInput.BorderSizePixel = 0
		propertyAmountInput.Position = UDim2.new(0.62, 0, 0, 8)
		propertyAmountInput.Size = UDim2.new(0.38, -7, 0, 32)
		propertyAmountInput.Parent = propertyAmountRow
		corner(propertyAmountInput, 4)
		stroke(propertyAmountInput, rgb(91, 39, 124), 0.25, 1)
		padding(propertyAmountInput, 8, 0, 8, 0)
		local function commitPropertyAmount()
			state.propsBuyAmount = math.clamp(math.floor(tonumber(propertyAmountInput.Text) or 1), 1, 999)
			propertyAmountInput.Text = tostring(state.propsBuyAmount)
			screenGui:SetAttribute("PropsBuyAmount", state.propsBuyAmount)
		end
		propertyAmountInput.FocusLost:Connect(commitPropertyAmount)

		local propertyToggleRefs = {}
		local function makePropertyToggle(name, titleText, descriptionText, y, key)
			local row = makePropertyRow(titleText, descriptionText, y, 48)
			local toggle = Instance.new("TextButton")
			toggle.Name = name
			toggle.AutoButtonColor = false
			toggle.Text = ""
			toggle.BorderSizePixel = 0
			toggle.Position = UDim2.new(1, -50, 0.5, -11)
			toggle.Size = UDim2.fromOffset(38, 22)
			toggle.Parent = row
			corner(toggle, 11)
			stroke(toggle, rgb(116, 70, 152), 0.45, 1)
			local knob = Instance.new("Frame")
			knob.BackgroundColor3 = rgb(239, 239, 243)
			knob.BorderSizePixel = 0
			knob.Size = UDim2.fromOffset(16, 16)
			knob.Parent = toggle
			corner(knob, 8)
			local function render()
				local enabled = state[key]
				TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					BackgroundColor3 = enabled and palette.accent or rgb(48, 46, 58),
				}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = enabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
				}):Play()
			end
			propertyToggleRefs[key] = {render = render}
			toggle.MouseButton1Click:Connect(function()
				commitPropertyAmount()
				state[key] = not state[key]
				if state[key] then
					local otherKey = key == "propsLimitedEnabled" and "propsAlwaysEnabled" or "propsLimitedEnabled"
					state[otherKey] = false
				end
				for _, ref in pairs(propertyToggleRefs) do ref.render() end
				screenGui:SetAttribute("BuyPropsIfRestockEnabled", state.propsLimitedEnabled)
				screenGui:SetAttribute("AlwaysBuyPropsIfRestockEnabled", state.propsAlwaysEnabled)
				if state.propsLimitedEnabled or state.propsAlwaysEnabled then
					state.propsRestockId = nil
					ensurePropertyLoop()
				else
					state.propsRunId += 1
					screenGui:SetAttribute("AutoBuyPropertyStatus", "Stopped")
				end
			end)
			render()
		end

		makePropertyToggle("AlwaysBuyPropsIfRestockToggle", "Always Buy Props If Restock", "Buys all available props stock while you can afford it.", 118, "propsAlwaysEnabled")

		local categoryOpen = false
		local propertyDropdownOpen = false
		propertyButton.MouseButton1Click:Connect(function()
			propertyDropdownOpen = not propertyDropdownOpen
			propertyPanel.Size = UDim2.new(0.38, -7, 0, propertyDropdownOpen and 160 or 0)
			propertyArrow.Rotation = propertyDropdownOpen and 180 or 0
		end)
		propertyHeader.MouseButton1Click:Connect(function()
			categoryOpen = not categoryOpen
			if not categoryOpen then
				propertyDropdownOpen = false
				propertyPanel.Size = UDim2.new(0.38, -7, 0, 0)
				propertyArrow.Rotation = 0
			end
			TweenService:Create(propertyContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, categoryOpen and 166 or 0),
			}):Play()
			TweenService:Create(propertyHeaderArrow, TweenInfo.new(0.18), {
				Rotation = categoryOpen and 180 or 0,
			}):Play()
		end)

		screenGui:SetAttribute("PropsBuyAmount", state.propsBuyAmount)
		screenGui:SetAttribute("BuyPropsIfRestockEnabled", state.propsLimitedEnabled)
		screenGui:SetAttribute("AlwaysBuyPropsIfRestockEnabled", state.propsAlwaysEnabled)
		screenGui:SetAttribute("AutoBuyPropertyStatus", "Stopped")
	end
	createPropertySection()

	local function createAuctionSection()
		local auctioneer = require(ReplicatedStorage.SharedModules:WaitForChild("Auctioneer"))
		local auctionChoices = {Seeds = {}, Gear = {}, SeedPacks = {}, Eggs = {}}
		for _, name in ipairs(shopSeeds) do table.insert(auctionChoices.Seeds, name) end
		for _, entry in ipairs(require(ReplicatedStorage.SharedModules:WaitForChild("GearShopData")).Data) do
			local name = entry.Name or entry.GearName or entry.ItemName
			if type(name) == "string" then table.insert(auctionChoices.Gear, name) end
		end
		for key, entry in pairs(require(ReplicatedStorage.SharedModules:WaitForChild("SeedPackData")).Data or {}) do
			local name = type(entry) == "table" and (entry.PackName or entry.SeedPackName or entry.Name) or nil
			if type(name) ~= "string" and type(key) == "string" then name = key end
			if type(name) == "string" then table.insert(auctionChoices.SeedPacks, name) end
		end
		for key, entry in pairs(require(ReplicatedStorage.SharedModules:WaitForChild("EggData")).Data or {}) do
			local name = type(entry) == "table" and (entry.EggName or entry.Name) or nil
			if type(name) ~= "string" and type(key) == "string" then name = key end
			if type(name) == "string" and name ~= "Test Egg" then table.insert(auctionChoices.Eggs, name) end
		end
		for _, choices in pairs(auctionChoices) do table.sort(choices) end

		local pendingResults = {}
		local retryAt = {}
		if runtime.YupisotesAuctionResultConnection then runtime.YupisotesAuctionResultConnection:Disconnect() end
		runtime.YupisotesAuctionResultConnection = networking.Auctioneer.PurchaseResult.OnClientEvent:Connect(function(lotId, success, message)
			pendingResults[lotId] = {success = success == true, message = tostring(message or "")}
		end)

		local function requestSnapshot()
			local ok, snapshot = pcall(function()
				return networking.Auctioneer.RequestSnapshot:Fire()
			end)
			if ok and type(snapshot) == "table" then return snapshot end
			-- Once the game controller has consumed the remote response, some servers
			-- return nil here. Reuse the controller's current lot and stock snapshot.
			local event = networking.Auctioneer.Snapshot.OnClientEvent
			local node = type(event) == "table" and event.Next or nil
			for _ = 1, 12 do
				if type(node) ~= "table" or node == event then break end
				local callback = node.Function
				if type(callback) == "function" then
					local upvalues = debug.getupvalues(callback)
					local lots = upvalues[1]
					if type(lots) == "table" and type(lots[1]) == "table" and type(lots[1].lotId) == "string" then
						return {
							manifest = {lots = lots, rollWindowUnix = upvalues[4]},
							stock = type(upvalues[2]) == "table" and upvalues[2] or {},
							rollWindowUnix = upvalues[4],
						}
					end
				end
				node = node.Next
			end
			return nil
		end

		local function selectedLotKey(lot)
			if type(lot) ~= "table" or type(lot.item) ~= "string" then return nil end
			for _, category in ipairs({"Seeds", "Gear", "SeedPacks", "Eggs"}) do
				if state.auctionSelections[category][lot.item] then return category .. "|" .. lot.item end
			end
			return nil
		end

		local function selectedAuctionCount()
			local count = 0
			for _, selected in pairs(state.auctionSelections) do
				for _, enabled in pairs(selected) do if enabled then count += 1 end end
			end
			return count
		end

		local function ensureAuctionLoop()
			state.auctionRunId += 1
			local runId = state.auctionRunId
			local generation = autoPlantGeneration
			task.spawn(function()
				while state.auctionEnabled and state.auctionRunId == runId
					and runtime.YupisotesGeneration == generation and screenGui.Parent do
					if selectedAuctionCount() == 0 then
						screenGui:SetAttribute("AutoBuyAuctionStatus", "Select at least one item")
						task.wait(0.6)
						continue
					end
					local snapshot = requestSnapshot()
					local manifest = snapshot and snapshot.manifest
					local lots = manifest and manifest.lots
					if type(lots) ~= "table" then
						screenGui:SetAttribute("AutoBuyAuctionStatus", "Auction unavailable")
						task.wait(1)
						continue
					end
					local cycleId = snapshot.rollWindowUnix or manifest.rollWindowUnix
					if cycleId ~= nil and state.auctionCycleId ~= cycleId then
						state.auctionCycleId = cycleId
						state.auctionBought = {}
						retryAt = {}
					end
					local now = workspace:GetServerTimeNow()
					local matched = false
					for _, lot in ipairs(lots) do
						if not state.auctionEnabled or state.auctionRunId ~= runId then break end
						local key = selectedLotKey(lot)
						local stock = snapshot.stock and snapshot.stock[lot.lotId]
						if type(stock) ~= "number" then stock = lot.stockQuantity end
						local active = type(lot.lotId) == "string" and lot.robuxPrice == nil
							and type(lot.expiresAt) == "number" and lot.expiresAt > now
							and (stock == nil or stock > 0)
						if key and active then
							local currentPrice = auctioneer.CurrentPrice(lot, now)
							local priceMatches = (state.auctionPriceMode == "Above" and currentPrice >= state.auctionPriceLimit)
								or (state.auctionPriceMode == "Below" and currentPrice <= state.auctionPriceLimit)
							local bought = state.auctionBought[key] or 0
							if priceMatches and bought < state.auctionBuyLotCount and os.clock() >= (retryAt[lot.lotId] or 0) then
								matched = true
								local leaderstats = player:FindFirstChild("leaderstats")
								local sheckles = leaderstats and leaderstats:FindFirstChild("Sheckles")
								local balanceBefore = sheckles and sheckles.Value
								pendingResults[lot.lotId] = "pending"
								local ok = pcall(function()
									networking.Auctioneer.PurchaseLot:Fire(lot.lotId, currentPrice)
								end)
								local deadline = os.clock() + 2
								while pendingResults[lot.lotId] == "pending" and os.clock() < deadline do task.wait(0.05) end
								local result = pendingResults[lot.lotId]
								pendingResults[lot.lotId] = nil
								local purchased = ok and ((type(result) == "table" and result.success)
									or (sheckles and sheckles.Value < balanceBefore))
								retryAt[lot.lotId] = os.clock() + (purchased and 10 or 2)
								if purchased then
									state.auctionBought[key] = bought + 1
									screenGui:SetAttribute("LastAutoBoughtAuctionItem", lot.item)
									screenGui:SetAttribute("AutoBuyAuctionStatus", "Bought " .. lot.item)
								else
									local message = type(result) == "table" and result.message or "No confirmation"
									screenGui:SetAttribute("AutoBuyAuctionStatus", "Retrying: " .. message)
								end
							end
						end
					end
					if not matched then screenGui:SetAttribute("AutoBuyAuctionStatus", "Waiting for matching lot") end
					task.wait(0.6)
				end
			end)
		end

		local auctionHeader = Instance.new("TextButton")
		auctionHeader.Name = "ShopAuctionHeader"
		auctionHeader.AutoButtonColor = false
		auctionHeader.Text = ""
		auctionHeader.BackgroundColor3 = palette.card
		auctionHeader.BorderSizePixel = 0
		auctionHeader.Size = UDim2.new(1, 0, 0, 31)
		auctionHeader.LayoutOrder = 6
		auctionHeader.Parent = list
		corner(auctionHeader, 4)
		local auctionHeaderText = label(auctionHeader, "Shop Auction", 13, palette.text, true)
		auctionHeaderText.Position = UDim2.fromOffset(10, 0)
		auctionHeaderText.Size = UDim2.new(1, -40, 1, 0)
		local auctionHeaderArrow = label(auctionHeader, "v", 14, rgb(210, 210, 216), true)
		auctionHeaderArrow.Position = UDim2.new(1, -28, 0, 0)
		auctionHeaderArrow.Size = UDim2.fromOffset(20, 31)
		auctionHeaderArrow.TextXAlignment = Enum.TextXAlignment.Center
		local auctionAccent = Instance.new("Frame")
		auctionAccent.BackgroundColor3 = palette.accent
		auctionAccent.BorderSizePixel = 0
		auctionAccent.Position = UDim2.new(0, 0, 1, -2)
		auctionAccent.Size = UDim2.new(1, 0, 0, 2)
		auctionAccent.Parent = auctionHeader

		local auctionContent = Instance.new("Frame")
		auctionContent.Name = "ShopAuctionContent"
		auctionContent.BackgroundTransparency = 1
		auctionContent.BorderSizePixel = 0
		auctionContent.ClipsDescendants = true
		auctionContent.Size = UDim2.new(1, 0, 0, 0)
		auctionContent.LayoutOrder = 7
		auctionContent.Parent = list
		local openDropdown

		local function makeAuctionRow(titleText, y, height)
			local row = Instance.new("Frame")
			row.BackgroundColor3 = palette.card
			row.BorderSizePixel = 0
			row.Position = UDim2.fromOffset(0, y)
			row.Size = UDim2.new(1, 0, 0, height)
			row.Parent = auctionContent
			corner(row, 4)
			local rowTitle = label(row, titleText, 12, palette.text, true)
			rowTitle.Position = UDim2.fromOffset(10, 0)
			rowTitle.Size = UDim2.new(0.62, -10, 1, 0)
			return row, rowTitle
		end

		local function makeAuctionSelect(category, titleText, y, zIndex)
			local row = makeAuctionRow(titleText, y, 40)
			local button = Instance.new("TextButton")
			button.Name = "Auction" .. category .. "Button"
			button.AutoButtonColor = false
			button.Font = Enum.Font.GothamBold
			button.TextSize = 11
			button.TextColor3 = palette.muted
			button.TextXAlignment = Enum.TextXAlignment.Left
			button.TextTruncate = Enum.TextTruncate.AtEnd
			button.BackgroundColor3 = rgb(31, 26, 43)
			button.BorderSizePixel = 0
			button.Position = UDim2.new(0.62, 0, 0, 4)
			button.Size = UDim2.new(0.38, -7, 0, 32)
			button.Parent = row
			corner(button, 4)
			stroke(button, rgb(72, 48, 96), 0.45, 1)
			padding(button, 10, 0, 30, 0)
			local arrow = label(button, "v", 13, rgb(210, 210, 216), true)
			arrow.Position = UDim2.new(1, -30, 0, 0)
			arrow.Size = UDim2.fromOffset(20, 32)
			arrow.TextXAlignment = Enum.TextXAlignment.Center
			local panel = Instance.new("Frame")
			panel.Name = "Auction" .. category .. "Dropdown"
			panel.BackgroundColor3 = rgb(18, 18, 25)
			panel.BorderSizePixel = 0
			panel.ClipsDescendants = true
			panel.Position = UDim2.new(0.62, 0, 0, y + 38)
			panel.Size = UDim2.new(0.38, -7, 0, 0)
			panel.ZIndex = zIndex
			panel.Parent = auctionContent
			corner(panel, 4)
			stroke(panel, rgb(91, 39, 124), 0.1, 1)
			local search = Instance.new("TextBox")
			search.ClearTextOnFocus = false
			search.PlaceholderText = "Search"
			search.Text = ""
			search.Font = Enum.Font.GothamMedium
			search.TextSize = 11
			search.TextColor3 = palette.text
			search.PlaceholderColor3 = palette.muted
			search.BackgroundColor3 = rgb(35, 27, 48)
			search.BorderSizePixel = 0
			search.Position = UDim2.fromOffset(4, 4)
			search.Size = UDim2.new(1, -8, 0, 26)
			search.ZIndex = zIndex + 1
			search.Parent = panel
			corner(search, 3)
			local options = Instance.new("ScrollingFrame")
			options.BackgroundTransparency = 1
			options.BorderSizePixel = 0
			options.CanvasSize = UDim2.fromOffset(0, 0)
			options.ScrollBarImageColor3 = palette.accent
			options.ScrollBarThickness = 3
			options.Position = UDim2.fromOffset(4, 34)
			options.Size = UDim2.new(1, -8, 1, -38)
			options.ZIndex = zIndex + 1
			options.Parent = panel
			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 2)
			layout.Parent = options
			local optionButtons = {}
			local function refresh()
				local names = {}
				for _, name in ipairs(auctionChoices[category]) do
					if state.auctionSelections[category][name] then table.insert(names, name) end
				end
				button.Text = #names == 0 and "Select Options" or table.concat(names, ", ")
				button.TextColor3 = #names == 0 and palette.muted or palette.text
			end
			for index, name in ipairs(auctionChoices[category]) do
				local option = Instance.new("TextButton")
				option.AutoButtonColor = false
				option.Text = name
				option.Font = Enum.Font.GothamMedium
				option.TextSize = 11
				option.TextXAlignment = Enum.TextXAlignment.Left
				option.BorderSizePixel = 0
				option.Size = UDim2.new(1, -3, 0, 27)
				option.LayoutOrder = index
				option.ZIndex = zIndex + 2
				option.Parent = options
				corner(option, 3)
				padding(option, 10, 0, 0, 0)
				local function render()
					local selected = state.auctionSelections[category][name] == true
					option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
					option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
					option.BackgroundTransparency = selected and 0.1 or 0.35
				end
				render()
				option.MouseButton1Click:Connect(function()
					state.auctionSelections[category][name] = not state.auctionSelections[category][name] and true or nil
					render()
					refresh()
				end)
				table.insert(optionButtons, option)
			end
			local function updateCanvas() options.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y) end
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
			search:GetPropertyChangedSignal("Text"):Connect(function()
				local query = string.lower(search.Text)
				for _, option in ipairs(optionButtons) do
					option.Visible = query == "" or string.find(string.lower(option.Text), query, 1, true) ~= nil
				end
				options.CanvasPosition = Vector2.zero
				updateCanvas()
			end)
			button.MouseButton1Click:Connect(function()
				if openDropdown and openDropdown.panel ~= panel then
					openDropdown.panel.Size = UDim2.new(0.38, -7, 0, 0)
					openDropdown.arrow.Rotation = 0
				end
				local opening = panel.Size.Y.Offset == 0
				panel.Size = UDim2.new(0.38, -7, 0, opening and 160 or 0)
				arrow.Rotation = opening and 180 or 0
				openDropdown = opening and {panel = panel, arrow = arrow} or nil
			end)
			refresh()
			updateCanvas()
		end

		makeAuctionSelect("Seeds", "Seeds", 0, 430)
		makeAuctionSelect("Gear", "Gear", 46, 420)
		makeAuctionSelect("SeedPacks", "Seed Packs", 92, 410)
		makeAuctionSelect("Eggs", "Eggs", 138, 400)

		local priceModeRow = makeAuctionRow("Price Mode", 184, 40)
		local priceModeButton = Instance.new("TextButton")
		priceModeButton.Name = "AuctionPriceModeButton"
		priceModeButton.AutoButtonColor = false
		priceModeButton.Font = Enum.Font.GothamBold
		priceModeButton.TextSize = 11
		priceModeButton.TextColor3 = palette.text
		priceModeButton.TextXAlignment = Enum.TextXAlignment.Left
		priceModeButton.Text = state.auctionPriceMode
		priceModeButton.BackgroundColor3 = rgb(31, 26, 43)
		priceModeButton.BorderSizePixel = 0
		priceModeButton.Position = UDim2.new(0.62, 0, 0, 4)
		priceModeButton.Size = UDim2.new(0.38, -7, 0, 32)
		priceModeButton.Parent = priceModeRow
		corner(priceModeButton, 4)
		stroke(priceModeButton, rgb(72, 48, 96), 0.45, 1)
		padding(priceModeButton, 10, 0, 30, 0)
		local priceModeArrow = label(priceModeButton, "v", 13, rgb(210, 210, 216), true)
		priceModeArrow.Position = UDim2.new(1, -30, 0, 0)
		priceModeArrow.Size = UDim2.fromOffset(20, 32)
		priceModeArrow.TextXAlignment = Enum.TextXAlignment.Center
		local priceModePanel = Instance.new("Frame")
		priceModePanel.Name = "AuctionPriceModeDropdown"
		priceModePanel.BackgroundColor3 = rgb(18, 18, 25)
		priceModePanel.BorderSizePixel = 0
		priceModePanel.ClipsDescendants = true
		priceModePanel.Position = UDim2.new(0.62, 0, 0, 222)
		priceModePanel.Size = UDim2.new(0.38, -7, 0, 0)
		priceModePanel.ZIndex = 390
		priceModePanel.Parent = auctionContent
		corner(priceModePanel, 4)
		stroke(priceModePanel, rgb(91, 39, 124), 0.1, 1)
		local priceModeOptions = {}
		local function renderPriceModes()
			for mode, option in pairs(priceModeOptions) do
				local selected = state.auctionPriceMode == mode
				option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = selected and 0.1 or 0.35
			end
		end
		for index, mode in ipairs({"Below", "Above"}) do
			local option = Instance.new("TextButton")
			option.AutoButtonColor = false
			option.Text = mode
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.BorderSizePixel = 0
			option.Position = UDim2.fromOffset(4, 4 + ((index - 1) * 29))
			option.Size = UDim2.new(1, -8, 0, 27)
			option.ZIndex = 391
			option.Parent = priceModePanel
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			priceModeOptions[mode] = option
			option.MouseButton1Click:Connect(function()
				state.auctionPriceMode = mode
				priceModeButton.Text = mode
				screenGui:SetAttribute("AuctionPriceMode", mode)
				renderPriceModes()
				priceModePanel.Size = UDim2.new(0.38, -7, 0, 0)
				priceModeArrow.Rotation = 0
				openDropdown = nil
			end)
		end
		renderPriceModes()
		priceModeButton.MouseButton1Click:Connect(function()
			if openDropdown and openDropdown.panel ~= priceModePanel then
				openDropdown.panel.Size = UDim2.new(0.38, -7, 0, 0)
				openDropdown.arrow.Rotation = 0
			end
			local opening = priceModePanel.Size.Y.Offset == 0
			priceModePanel.Size = UDim2.new(0.38, -7, 0, opening and 64 or 0)
			priceModeArrow.Rotation = opening and 180 or 0
			openDropdown = opening and {panel = priceModePanel, arrow = priceModeArrow} or nil
		end)

		local function makeAuctionInput(name, titleText, descriptionText, y, value, commit)
			local row, rowTitle = makeAuctionRow(titleText, y, 58)
			rowTitle.Size = UDim2.new(0.62, -10, 0, 19)
			local description = label(row, descriptionText, 10, palette.muted, false)
			description.Position = UDim2.fromOffset(10, 21)
			description.Size = UDim2.new(0.62, -10, 0, 32)
			local input = Instance.new("TextBox")
			input.Name = name
			input.ClearTextOnFocus = false
			input.Text = tostring(value)
			input.Font = Enum.Font.GothamBold
			input.TextSize = 11
			input.TextColor3 = palette.text
			input.TextXAlignment = Enum.TextXAlignment.Left
			input.BackgroundColor3 = rgb(31, 26, 43)
			input.BorderSizePixel = 0
			input.Position = UDim2.new(0.62, 0, 0, 8)
			input.Size = UDim2.new(0.38, -7, 0, 32)
			input.Parent = row
			corner(input, 4)
			stroke(input, rgb(91, 39, 124), 0.25, 1)
			padding(input, 8, 0, 8, 0)
			input.FocusLost:Connect(function() input.Text = tostring(commit(input.Text)) end)
			return input
		end
		local priceLimitInput = makeAuctionInput("AuctionPriceLimitInput", "Price Limit", "Maximum or minimum price accepted by Price Mode.", 230, state.auctionPriceLimit, function(text)
			state.auctionPriceLimit = math.max(0, math.floor(tonumber(text) or 0))
			screenGui:SetAttribute("AuctionPriceLimit", state.auctionPriceLimit)
			return state.auctionPriceLimit
		end)
		local buyLotInput = makeAuctionInput("AuctionBuyLotCountInput", "Buy Lot Count", "How many times to buy each selected item per restock cycle.", 294, state.auctionBuyLotCount, function(text)
			state.auctionBuyLotCount = math.clamp(math.floor(tonumber(text) or 1), 1, 999)
			screenGui:SetAttribute("AuctionBuyLotCount", state.auctionBuyLotCount)
			return state.auctionBuyLotCount
		end)

		local refreshButton = Instance.new("TextButton")
		refreshButton.Name = "AuctionRefreshOptionsButton"
		refreshButton.AutoButtonColor = true
		refreshButton.Text = "Refresh Options"
		refreshButton.Font = Enum.Font.GothamBold
		refreshButton.TextSize = 11
		refreshButton.TextColor3 = palette.text
		refreshButton.BackgroundColor3 = rgb(31, 30, 29)
		refreshButton.BorderSizePixel = 0
		refreshButton.Position = UDim2.fromOffset(0, 358)
		refreshButton.Size = UDim2.new(1, 0, 0, 34)
		refreshButton.Parent = auctionContent
		corner(refreshButton, 4)
		refreshButton.MouseButton1Click:Connect(function()
			state.auctionRefreshId += 1
			local snapshot = requestSnapshot()
			local lots = snapshot and snapshot.manifest and snapshot.manifest.lots
			screenGui:SetAttribute("AutoBuyAuctionStatus", type(lots) == "table" and ("Refreshed " .. #lots .. " lots") or "Auction unavailable")
		end)

		local toggleRow = makeAuctionRow("Start Auto Buy Auction", 398, 48)
		local toggle = Instance.new("TextButton")
		toggle.Name = "StartAutoBuyAuctionToggle"
		toggle.AutoButtonColor = false
		toggle.Text = ""
		toggle.BorderSizePixel = 0
		toggle.Position = UDim2.new(1, -50, 0.5, -11)
		toggle.Size = UDim2.fromOffset(38, 22)
		toggle.Parent = toggleRow
		corner(toggle, 11)
		stroke(toggle, rgb(116, 70, 152), 0.45, 1)
		local knob = Instance.new("Frame")
		knob.BackgroundColor3 = rgb(239, 239, 243)
		knob.BorderSizePixel = 0
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = toggle
		corner(knob, 8)
		local function renderToggle()
			TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundColor3 = state.auctionEnabled and palette.accent or rgb(48, 46, 58),
			}):Play()
			TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = state.auctionEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
			}):Play()
		end
		toggle.MouseButton1Click:Connect(function()
			priceLimitInput:ReleaseFocus()
			buyLotInput:ReleaseFocus()
			state.auctionEnabled = not state.auctionEnabled
			screenGui:SetAttribute("StartAutoBuyAuctionEnabled", state.auctionEnabled)
			renderToggle()
			if state.auctionEnabled then
				ensureAuctionLoop()
			else
				state.auctionRunId += 1
				screenGui:SetAttribute("AutoBuyAuctionStatus", "Stopped")
			end
		end)
		renderToggle()

		local categoryOpen = false
		auctionHeader.MouseButton1Click:Connect(function()
			categoryOpen = not categoryOpen
			if not categoryOpen and openDropdown then
				openDropdown.panel.Size = UDim2.new(0.38, -7, 0, 0)
				openDropdown.arrow.Rotation = 0
				openDropdown = nil
			end
			TweenService:Create(auctionContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, categoryOpen and 446 or 0),
			}):Play()
			TweenService:Create(auctionHeaderArrow, TweenInfo.new(0.18), {
				Rotation = categoryOpen and 180 or 0,
			}):Play()
		end)

		screenGui:SetAttribute("AuctionPriceMode", state.auctionPriceMode)
		screenGui:SetAttribute("AuctionPriceLimit", state.auctionPriceLimit)
		screenGui:SetAttribute("AuctionBuyLotCount", state.auctionBuyLotCount)
		screenGui:SetAttribute("StartAutoBuyAuctionEnabled", state.auctionEnabled)
		screenGui:SetAttribute("AutoBuyAuctionStatus", "Stopped")
	end
	createAuctionSection()
end
for tabName, ref in pairs(tabRefs) do
ref.button.MouseButton1Click:Connect(function()
if tabName == "Info" then
showInfo()
elseif tabName == "Farm" then
showFarm()
	elseif tabName == "Shop" then
		runtime.YupisotesShowShop()
end
end)
end
showInfo()
local dragState = {dragging = false}
top.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragState.dragging = true
dragState.start = input.Position
dragState.position = main.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragState.dragging = false
end
end)
end
end)
UserInputService.InputChanged:Connect(function(input)
if dragState.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragState.start
local startPosition = dragState.position
main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end
end)

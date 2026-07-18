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
local guiParent = playerGui
local cleanupRoots = {playerGui}
pcall(function()
if gethui then
local executorGui = gethui()
if executorGui and executorGui ~= playerGui then table.insert(cleanupRoots, executorGui) end
end
end)
pcall(function()
local coreGui = game:GetService("CoreGui")
if coreGui ~= playerGui and not table.find(cleanupRoots, coreGui) then table.insert(cleanupRoots, coreGui) end
end)
for _, root in ipairs(cleanupRoots) do
pcall(function()
for _, existing in ipairs(root:GetChildren()) do
local remove = table.find({"YupisotesUI", "WisHubGardenUI", "MaruHubPremiumCleanSidebar"}, existing.Name) ~= nil
if existing:IsA("ScreenGui") and not remove then
remove = existing:GetAttribute("YupisotesRoot") == true
if not remove then
for _, descendant in ipairs(existing:GetDescendants()) do
if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and descendant.Text == "Yupisotes" then
remove = true
break
end
end
end
end
if remove then existing:Destroy() end
end
end)
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
screenGui:SetAttribute("YupisotesRoot", true)
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
{"Info", true},
{"Farm", false},
{"Shop", false},
{"Pet", false},
{"Misc", false},
{"Visual", false},
{"Config", false},
}
local tabRefs = {}
local function makeTab(index, name, active)
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
local iconColor = active and rgb(221, 154, 255) or rgb(110, 111, 119)
local iconHolder = Instance.new("Frame")
iconHolder.Name = name .. "Icon"
iconHolder.BackgroundTransparency = 1
iconHolder.Position = UDim2.fromOffset(14, 0)
iconHolder.Size = UDim2.fromOffset(18, 30)
iconHolder.Parent = tab
local iconRoot = Instance.new("Frame")
iconRoot.Name = "Drawing"
iconRoot.BackgroundTransparency = 1
iconRoot.Position = UDim2.fromOffset(1, 7)
iconRoot.Size = UDim2.fromOffset(16, 16)
iconRoot.Parent = iconHolder
local function iconPart(x, y, width, height, radius, rotation)
local part = Instance.new("Frame")
part.BackgroundColor3 = iconColor
part.BorderSizePixel = 0
part.Position = UDim2.fromOffset(x, y)
part.Size = UDim2.fromOffset(width, height)
part.Rotation = rotation or 0
part.Parent = iconRoot
if radius then corner(part, radius) end
return part
end
local function iconOutline(x, y, width, height, radius)
local outline = iconPart(x, y, width, height, radius)
outline.BackgroundTransparency = 1
stroke(outline, iconColor, 0, 1.2)
return outline
end
if name == "Info" then
iconOutline(2, 1, 12, 14, 7)
iconPart(7, 4, 2, 2, 1)
iconPart(7, 7, 2, 6, 1)
elseif name == "Farm" then
iconPart(7, 6, 2, 9, 1)
iconPart(2, 4, 7, 4, 3, 32)
iconPart(8, 2, 6, 4, 3, -32)
iconPart(4, 14, 8, 2, 1)
elseif name == "Shop" then
iconPart(2, 6, 12, 9, 2)
local handle = iconOutline(5, 2, 6, 7, 4)
handle.ZIndex = 2
iconPart(5, 9, 6, 1, 1)
elseif name == "Pet" then
iconPart(4, 8, 8, 7, 4)
iconPart(1, 5, 4, 4, 2)
iconPart(4, 2, 4, 4, 2)
iconPart(8, 2, 4, 4, 2)
iconPart(11, 5, 4, 4, 2)
elseif name == "Misc" then
iconOutline(4, 1, 8, 9, 5)
iconPart(6, 9, 4, 4, 1)
iconPart(5, 13, 6, 2, 1)
iconPart(1, 5, 2, 2, 1)
iconPart(13, 5, 2, 2, 1)
elseif name == "Visual" then
iconOutline(1, 4, 14, 9, 6)
iconPart(6, 6, 4, 4, 2)
elseif name == "Config" then
iconOutline(4, 4, 8, 8, 4)
iconPart(7, 0, 2, 5, 1)
iconPart(7, 11, 2, 5, 1)
iconPart(0, 7, 5, 2, 1)
iconPart(11, 7, 5, 2, 1)
iconPart(2, 2, 3, 3, 1, 45)
iconPart(11, 11, 3, 3, 1, 45)
end
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
icon = iconHolder,
text = tabLabel,
}
end
for index, item in ipairs(tabs) do
makeTab(index, item[1], item[2])
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
runtime.YupisotesWildPetCategoryOpen = false
runtime.YupisotesPetState = {
	categoryOpen = false,
	selectedNames = {},
	selectedRarities = {},
	enabled = false,
	runId = 0,
	pending = {},
	eggEnabled = false,
	eggRunId = 0,
	eggPending = {},
}
for _, instance in ipairs(playerGui:GetDescendants()) do
	if instance.Name == "YupisotesFruitValue" then instance:Destroy() end
end
runtime.YupisotesVisualState = {
	inventoryFruitEnabled = false,
	gardenFruitEnabled = false,
	gardenValueEnabled = false,
	selectedFruitValueEnabled = false,
	selectedValueSeeds = {},
	highestFruitValueOnly = false,
	categoryOpen = false,
	fruitValueCategoryOpen = false,
	runId = 0,
	inventoryLabels = {},
	gardenLabels = {},
	valuePanel = nil,
	valuePanelPosition = UDim2.new(1, -292, 0, 86),
	valuePanelBeginConnection = nil,
	valuePanelMoveConnection = nil,
	baseWeights = {},
}
local previousMiscState = runtime.YupisotesMiscState
if previousMiscState then
	for _, connectionName in ipairs({"fpsConnection", "fpsLightingConnection", "hidePlantConnection", "protectionConnection"}) do
		local connection = previousMiscState[connectionName]
		if connection then pcall(function() connection:Disconnect() end) end
	end
	if type(previousMiscState.reconnectConnections) == "table" then
		for _, connection in ipairs(previousMiscState.reconnectConnections) do pcall(function() connection:Disconnect() end) end
	end
	if type(previousMiscState.webhookConnections) == "table" then
		for _, connection in ipairs(previousMiscState.webhookConnections) do pcall(function() connection:Disconnect() end) end
	end
	if type(previousMiscState.utilityWebhookConnections) == "table" then
		for _, connection in ipairs(previousMiscState.utilityWebhookConnections) do pcall(function() connection:Disconnect() end) end
	end
	for _, bucketName in ipairs({"fpsOverrides", "plantOverrides", "protectionOverrides"}) do
		local bucket = previousMiscState[bucketName]
		if type(bucket) == "table" then
			for instance, properties in pairs(bucket) do
				if typeof(instance) == "Instance" and instance.Parent and type(properties) == "table" then
					for property, value in pairs(properties) do pcall(function() instance[property] = value end) end
				end
			end
		end
	end
	if previousMiscState.originalQualityLevel then pcall(function() settings().Rendering.QualityLevel = previousMiscState.originalQualityLevel end) end
end
runtime.YupisotesMiscState = {
	owner = "My Plot",
	sprinkler = "All Sprinkler",
	wateringCan = "All Watering Can",
	plantNames = {},
	plantRarities = {},
	placeMode = "Best Weight",
	actionDelay = 1,
	wateringLimit = 0,
	enabled = false,
	runId = 0,
	giftUsername = "",
	giftType = "Seed",
	giftRarities = {},
	giftItems = {},
	giftAmount = 1,
	giftDelay = 0.2,
	giftEnabled = false,
	giftRunId = 0,
	autoAcceptGift = false,
	giftCategoryOpen = false,
	mailReceiver = "",
	mailCategory = "Pets",
	mailItems = {},
	mailRarities = {},
	mailAmount = 1,
	mailNote = "Gift from Yupisotes",
	mailDelay = 21,
	mailSelectedEnabled = false,
	mailAllEnabled = false,
	mailClaimEnabled = false,
	mailSelectedRunId = 0,
	mailAllRunId = 0,
	mailClaimRunId = 0,
	mailCategoryOpen = false,
	autoReconnect = false,
	autoExecCategoryOpen = false,
	reconnectInProgress = false,
	boostFps = false,
	hidePlantScope = "Own",
	hidePlants = false,
	hidePlantRunId = 0,
	performanceCategoryOpen = false,
	boostRunId = 0,
	fpsOverrides = {},
	plantOverrides = {},
	antiFlingMethod = "Freeze",
	protectionEnabled = false,
	protectionRunId = 0,
	autoProtectCategoryOpen = false,
	protectionOverrides = {},
	webhookTagType = "None",
	webhookTagId = "",
	webhookUrl = "",
	webhookItems = {Seed = true, Gear = true, Crate = true},
	webhookStockEnabled = false,
	webhookDebounce = 0,
	webhookCategoryOpen = false,
	utilityTagType = "None",
	utilityTagId = "",
	utilityWebhookUrl = "",
	utilityItemTypes = {Pet = true},
	utilityItems = {},
	utilityRarities = {},
	utilityWebhookEnabled = false,
	utilityWebhookDebounce = 0,
	utilityWebhookCategoryOpen = false,
}
runtime.YupisotesConfigFolder = "Yupisotes/Configs"
runtime.YupisotesAutoLoadFile = "Yupisotes/AutoLoad.txt"
runtime.YupisotesConfigState = {name = "Default", selected = "Default", autoLoad = false, categoryOpen = true}
runtime.YupisotesConfigExcluded = {
	enabled = true, runId = true, pending = true, connections = true, connection = true,
	overrides = true, panel = true, labels = true, debounce = true, generation = true,
	bought = true, purchased = true, cycle = true, inProgress = true, restockId = true,
}
runtime.YupisotesConfigClone = function(value, keyName, seen)
	local valueType = typeof(value)
	if valueType == "number" or valueType == "string" or valueType == "boolean" then return value end
	if valueType ~= "table" then return nil end
	seen = seen or {}
	if seen[value] then return nil end
	seen[value] = true
	local output = {}
	for key, item in pairs(value) do
		local lowered = string.lower(tostring(key))
		local blocked = false
		for token in pairs(runtime.YupisotesConfigExcluded) do
			if string.find(lowered, string.lower(token), 1, true) then blocked = true; break end
		end
		if not blocked then
			local cloned = runtime.YupisotesConfigClone(item, tostring(key), seen)
			if cloned ~= nil then output[key] = cloned end
		end
	end
	seen[value] = nil
	return output
end
runtime.YupisotesMergeConfig = function(target, saved)
	if type(target) ~= "table" or type(saved) ~= "table" then return end
	for key, value in pairs(saved) do
		if type(value) == "table" and type(target[key]) == "table" then
			runtime.YupisotesMergeConfig(target[key], value)
		elseif typeof(value) == "number" or typeof(value) == "string" or typeof(value) == "boolean" then
			target[key] = value
		elseif type(value) == "table" then
			target[key] = runtime.YupisotesConfigClone(value)
		end
	end
end
runtime.YupisotesSanitizeConfigName = function(name)
	name = tostring(name or "Default"):match("^%s*(.-)%s*$") or "Default"
	name = name:gsub("[^%w%-%_ ]", ""):sub(1, 40)
	return name ~= "" and name or "Default"
end
runtime.YupisotesEnsureConfigFolders = function()
	if type(makefolder) ~= "function" or type(isfolder) ~= "function" then return false end
	pcall(function() if not isfolder("Yupisotes") then makefolder("Yupisotes") end end)
	pcall(function() if not isfolder(runtime.YupisotesConfigFolder) then makefolder(runtime.YupisotesConfigFolder) end end)
	return true
end
runtime.YupisotesExportConfig = function()
	return {
		version = 3,
		farm = {
			selectedPlant = selectedPlant, selectedPlantRarities = runtime.YupisotesConfigClone(selectedPlantRarities), selectedMethod = selectedMethod, plantSpeed = plantSpeed,
			selectedHarvestPlant = selectedHarvestPlant, harvestDelay = harvestDelay, advancedHarvestEnabled = advancedHarvestEnabled,
			selectedHarvestRarities = runtime.YupisotesConfigClone(selectedHarvestRarities), selectedHarvestMutations = runtime.YupisotesConfigClone(selectedHarvestMutations),
			harvestKg = harvestKg, harvestKgDirection = harvestKgDirection, sellingMethod = sellingMethod, sellingInput = sellingInput,
			advancedSellMode = advancedSellMode, advancedSellTarget = advancedSellTarget, doubleTriggerCount = doubleTriggerCount,
			doubleUseBackpackMax = doubleUseBackpackMax, doubleTargetWins = doubleTargetWins, dailyDealMode = dailyDealMode, dailyDealCount = dailyDealCount,
			favoriteSelectedRarities = runtime.YupisotesConfigClone(favoriteSelectedRarities), favoriteExcludedFruits = runtime.YupisotesConfigClone(favoriteExcludedFruits),
			favoriteSelectedMutations = runtime.YupisotesConfigClone(favoriteSelectedMutations), favoriteKg = favoriteKg, favoriteKgDirection = favoriteKgDirection,
			selectedShovelPlants = runtime.YupisotesConfigClone(selectedShovelPlants), selectedShovelRarities = runtime.YupisotesConfigClone(selectedShovelRarities), shovelSpeed = shovelSpeed,
			selectedShovelFruits = runtime.YupisotesConfigClone(selectedShovelFruits), selectedShovelFruitRarities = runtime.YupisotesConfigClone(selectedShovelFruitRarities),
			shovelFruitKg = shovelFruitKg, shovelFruitKgDirection = shovelFruitKgDirection,
			selectedTrowelPlants = runtime.YupisotesConfigClone(selectedTrowelPlants), selectedTrowelRarities = runtime.YupisotesConfigClone(selectedTrowelRarities),
			trowelPositionMode = trowelPositionMode, trowelDelay = trowelDelay, collectedSeedSelection = collectedSeedSelection, collectedSeedDelay = collectedSeedDelay,
			selectedSellPetNames = runtime.YupisotesConfigClone(selectedSellPetNames), selectedSellPetRarities = runtime.YupisotesConfigClone(selectedSellPetRarities),
			blacklistedPetVariants = runtime.YupisotesConfigClone(blacklistedPetVariants), sellPetDelay = sellPetDelay,
			selectedLeaveWeathers = runtime.YupisotesConfigClone(selectedLeaveWeathers), useDailyDeal = useDailyDeal,
		},
		shop = runtime.YupisotesConfigClone(runtime.YupisotesShopState),
		pet = runtime.YupisotesConfigClone(runtime.YupisotesPetState),
		misc = runtime.YupisotesConfigClone(runtime.YupisotesMiscState),
		visual = runtime.YupisotesConfigClone(runtime.YupisotesVisualState),
		visualEnabled = {
			selectedFruitValueEnabled = runtime.YupisotesVisualState.selectedFruitValueEnabled == true,
		},
		selections = {
			shop = {
				selectedSeeds = runtime.YupisotesConfigClone(runtime.YupisotesShopState.selectedSeeds),
				selectedRarities = runtime.YupisotesConfigClone(runtime.YupisotesShopState.selectedRarities),
				buyAmount = runtime.YupisotesShopState.buyAmount,
				selectedGear = runtime.YupisotesConfigClone(runtime.YupisotesShopState.selectedGear),
				gearBuyAmount = runtime.YupisotesShopState.gearBuyAmount,
				selectedProps = runtime.YupisotesConfigClone(runtime.YupisotesShopState.selectedProps),
				propsBuyAmount = runtime.YupisotesShopState.propsBuyAmount,
				auctionSelections = runtime.YupisotesConfigClone(runtime.YupisotesShopState.auctionSelections),
				auctionPriceMode = runtime.YupisotesShopState.auctionPriceMode,
				auctionPriceLimit = runtime.YupisotesShopState.auctionPriceLimit,
				auctionBuyLotCount = runtime.YupisotesShopState.auctionBuyLotCount,
			},
			pet = {
				selectedNames = runtime.YupisotesConfigClone(runtime.YupisotesPetState.selectedNames),
				selectedRarities = runtime.YupisotesConfigClone(runtime.YupisotesPetState.selectedRarities),
			},
			misc = {
				owner = runtime.YupisotesMiscState.owner,
				sprinkler = runtime.YupisotesMiscState.sprinkler,
				wateringCan = runtime.YupisotesMiscState.wateringCan,
				plantNames = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.plantNames),
				plantRarities = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.plantRarities),
				placeMode = runtime.YupisotesMiscState.placeMode,
				actionDelay = runtime.YupisotesMiscState.actionDelay,
				wateringLimit = runtime.YupisotesMiscState.wateringLimit,
				giftUsername = runtime.YupisotesMiscState.giftUsername,
				giftType = runtime.YupisotesMiscState.giftType,
				giftRarities = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.giftRarities),
				giftItems = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.giftItems),
				giftAmount = runtime.YupisotesMiscState.giftAmount,
				giftDelay = runtime.YupisotesMiscState.giftDelay,
				mailReceiver = runtime.YupisotesMiscState.mailReceiver,
				mailCategory = runtime.YupisotesMiscState.mailCategory,
				mailItems = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.mailItems),
				mailRarities = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.mailRarities),
				mailAmount = runtime.YupisotesMiscState.mailAmount,
				mailNote = runtime.YupisotesMiscState.mailNote,
				mailDelay = runtime.YupisotesMiscState.mailDelay,
				hidePlantScope = runtime.YupisotesMiscState.hidePlantScope,
				antiFlingMethod = runtime.YupisotesMiscState.antiFlingMethod,
				webhookTagType = runtime.YupisotesMiscState.webhookTagType,
				webhookTagId = runtime.YupisotesMiscState.webhookTagId,
				webhookUrl = runtime.YupisotesMiscState.webhookUrl,
				webhookItems = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.webhookItems),
				utilityTagType = runtime.YupisotesMiscState.utilityTagType,
				utilityTagId = runtime.YupisotesMiscState.utilityTagId,
				utilityWebhookUrl = runtime.YupisotesMiscState.utilityWebhookUrl,
				utilityItemTypes = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.utilityItemTypes),
				utilityItems = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.utilityItems),
				utilityRarities = runtime.YupisotesConfigClone(runtime.YupisotesMiscState.utilityRarities),
			},
			visual = {
				selectedValueSeeds = runtime.YupisotesConfigClone(runtime.YupisotesVisualState.selectedValueSeeds),
				highestFruitValueOnly = runtime.YupisotesVisualState.highestFruitValueOnly,
			},
		},
		toggles = {
			farm = {
				autoPlant = autoPlantEnabled, autoHarvest = autoHarvestEnabled, autoSell = autoSellEnabled,
				advancedSell = advancedSellEnabled, doubleOrNothing = doubleEnabled, autoFavorite = autoFavoriteEnabled,
				autoShovel = autoShovelEnabled, autoShovelFruit = autoShovelFruitEnabled, autoTrowel = autoTrowelEnabled,
				autoCollectSeed = autoCollectDroppedSeedEnabled, autoSellPet = autoSellPetEnabled, autoLeaveWeather = autoLeaveWeatherEnabled,
			},
			shop = {
				buySeedsLimited = runtime.YupisotesShopState.limitedEnabled, buySeedsAlways = runtime.YupisotesShopState.alwaysEnabled,
				buyGearLimited = runtime.YupisotesShopState.gearLimitedEnabled, buyGearAlways = runtime.YupisotesShopState.gearAlwaysEnabled,
				buyPropsLimited = runtime.YupisotesShopState.propsLimitedEnabled, buyPropsAlways = runtime.YupisotesShopState.propsAlwaysEnabled,
				auction = runtime.YupisotesShopState.auctionEnabled,
			},
			pet = {wildPet = runtime.YupisotesPetState.enabled, dragonEgg = runtime.YupisotesPetState.eggEnabled},
			misc = {
				watering = runtime.YupisotesMiscState.enabled, autoGift = runtime.YupisotesMiscState.giftEnabled,
				autoAcceptGift = runtime.YupisotesMiscState.autoAcceptGift, mailSelected = runtime.YupisotesMiscState.mailSelectedEnabled,
				mailAll = runtime.YupisotesMiscState.mailAllEnabled, mailClaim = runtime.YupisotesMiscState.mailClaimEnabled,
				autoReconnect = runtime.YupisotesMiscState.autoReconnect, boostFps = runtime.YupisotesMiscState.boostFps,
				hidePlants = runtime.YupisotesMiscState.hidePlants, protection = runtime.YupisotesMiscState.protectionEnabled,
				webhookStock = runtime.YupisotesMiscState.webhookStockEnabled, webhookUtility = runtime.YupisotesMiscState.utilityWebhookEnabled,
			},
			visual = {
				inventoryFruit = runtime.YupisotesVisualState.inventoryFruitEnabled,
				gardenFruit = runtime.YupisotesVisualState.gardenFruitEnabled,
				gardenValue = runtime.YupisotesVisualState.gardenValueEnabled,
				selectedFruitValue = runtime.YupisotesVisualState.selectedFruitValueEnabled,
			},
		},
	}
end
runtime.YupisotesImportConfig = function(data)
	if type(data) ~= "table" then return false end
	local farm = type(data.farm) == "table" and data.farm or {}
	selectedPlant = farm.selectedPlant or selectedPlant
	selectedPlantRarities = type(farm.selectedPlantRarities) == "table" and farm.selectedPlantRarities or selectedPlantRarities
	selectedMethod = farm.selectedMethod or selectedMethod
	plantSpeed = tonumber(farm.plantSpeed) or plantSpeed
	selectedHarvestPlant = farm.selectedHarvestPlant or selectedHarvestPlant
	harvestDelay = tonumber(farm.harvestDelay) or harvestDelay
	advancedHarvestEnabled = farm.advancedHarvestEnabled == true
	selectedHarvestRarities = type(farm.selectedHarvestRarities) == "table" and farm.selectedHarvestRarities or selectedHarvestRarities
	selectedHarvestMutations = type(farm.selectedHarvestMutations) == "table" and farm.selectedHarvestMutations or selectedHarvestMutations
	harvestKg = tonumber(farm.harvestKg) or harvestKg
	harvestKgDirection = farm.harvestKgDirection or harvestKgDirection
	sellingMethod = farm.sellingMethod or sellingMethod
	sellingInput = tonumber(farm.sellingInput) or sellingInput
	advancedSellMode = farm.advancedSellMode or advancedSellMode
	advancedSellTarget = tonumber(farm.advancedSellTarget) or advancedSellTarget
	doubleTriggerCount = tonumber(farm.doubleTriggerCount) or doubleTriggerCount
	doubleUseBackpackMax = farm.doubleUseBackpackMax == true
	doubleTargetWins = tonumber(farm.doubleTargetWins) or doubleTargetWins
	dailyDealMode = farm.dailyDealMode or dailyDealMode
	dailyDealCount = tonumber(farm.dailyDealCount) or dailyDealCount
	favoriteSelectedRarities = type(farm.favoriteSelectedRarities) == "table" and farm.favoriteSelectedRarities or favoriteSelectedRarities
	favoriteExcludedFruits = type(farm.favoriteExcludedFruits) == "table" and farm.favoriteExcludedFruits or favoriteExcludedFruits
	favoriteSelectedMutations = type(farm.favoriteSelectedMutations) == "table" and farm.favoriteSelectedMutations or favoriteSelectedMutations
	favoriteKg = tonumber(farm.favoriteKg) or favoriteKg
	favoriteKgDirection = farm.favoriteKgDirection or favoriteKgDirection
	selectedShovelPlants = type(farm.selectedShovelPlants) == "table" and farm.selectedShovelPlants or selectedShovelPlants
	selectedShovelRarities = type(farm.selectedShovelRarities) == "table" and farm.selectedShovelRarities or selectedShovelRarities
	shovelSpeed = tonumber(farm.shovelSpeed) or shovelSpeed
	selectedShovelFruits = type(farm.selectedShovelFruits) == "table" and farm.selectedShovelFruits or selectedShovelFruits
	selectedShovelFruitRarities = type(farm.selectedShovelFruitRarities) == "table" and farm.selectedShovelFruitRarities or selectedShovelFruitRarities
	shovelFruitKg = tonumber(farm.shovelFruitKg) or shovelFruitKg
	shovelFruitKgDirection = farm.shovelFruitKgDirection or shovelFruitKgDirection
	selectedTrowelPlants = type(farm.selectedTrowelPlants) == "table" and farm.selectedTrowelPlants or selectedTrowelPlants
	selectedTrowelRarities = type(farm.selectedTrowelRarities) == "table" and farm.selectedTrowelRarities or selectedTrowelRarities
	trowelPositionMode = farm.trowelPositionMode or trowelPositionMode
	trowelDelay = tonumber(farm.trowelDelay) or trowelDelay
	collectedSeedSelection = farm.collectedSeedSelection or collectedSeedSelection
	collectedSeedDelay = tonumber(farm.collectedSeedDelay) or collectedSeedDelay
	selectedSellPetNames = type(farm.selectedSellPetNames) == "table" and farm.selectedSellPetNames or selectedSellPetNames
	selectedSellPetRarities = type(farm.selectedSellPetRarities) == "table" and farm.selectedSellPetRarities or selectedSellPetRarities
	blacklistedPetVariants = type(farm.blacklistedPetVariants) == "table" and farm.blacklistedPetVariants or blacklistedPetVariants
	sellPetDelay = tonumber(farm.sellPetDelay) or sellPetDelay
	selectedLeaveWeathers = type(farm.selectedLeaveWeathers) == "table" and farm.selectedLeaveWeathers or selectedLeaveWeathers
	useDailyDeal = farm.useDailyDeal == true
	runtime.YupisotesMergeConfig(runtime.YupisotesShopState, data.shop)
	runtime.YupisotesMergeConfig(runtime.YupisotesPetState, data.pet)
	runtime.YupisotesMergeConfig(runtime.YupisotesMiscState, data.misc)
	runtime.YupisotesMergeConfig(runtime.YupisotesVisualState, data.visual)
	local selections = type(data.selections) == "table" and data.selections or {}
	local shopSelections = type(selections.shop) == "table" and selections.shop or {}
	if type(shopSelections.selectedSeeds) == "table" then runtime.YupisotesShopState.selectedSeeds = shopSelections.selectedSeeds end
	if type(shopSelections.selectedRarities) == "table" then runtime.YupisotesShopState.selectedRarities = shopSelections.selectedRarities end
	runtime.YupisotesShopState.buyAmount = tonumber(shopSelections.buyAmount) or runtime.YupisotesShopState.buyAmount
	if type(shopSelections.selectedGear) == "table" then runtime.YupisotesShopState.selectedGear = shopSelections.selectedGear end
	runtime.YupisotesShopState.gearBuyAmount = tonumber(shopSelections.gearBuyAmount) or runtime.YupisotesShopState.gearBuyAmount
	if type(shopSelections.selectedProps) == "table" then runtime.YupisotesShopState.selectedProps = shopSelections.selectedProps end
	runtime.YupisotesShopState.propsBuyAmount = tonumber(shopSelections.propsBuyAmount) or runtime.YupisotesShopState.propsBuyAmount
	if type(shopSelections.auctionSelections) == "table" then runtime.YupisotesShopState.auctionSelections = shopSelections.auctionSelections end
	runtime.YupisotesShopState.auctionPriceMode = shopSelections.auctionPriceMode or runtime.YupisotesShopState.auctionPriceMode
	runtime.YupisotesShopState.auctionPriceLimit = tonumber(shopSelections.auctionPriceLimit) or runtime.YupisotesShopState.auctionPriceLimit
	runtime.YupisotesShopState.auctionBuyLotCount = tonumber(shopSelections.auctionBuyLotCount) or runtime.YupisotesShopState.auctionBuyLotCount
	local petSelections = type(selections.pet) == "table" and selections.pet or {}
	if type(petSelections.selectedNames) == "table" then runtime.YupisotesPetState.selectedNames = petSelections.selectedNames end
	if type(petSelections.selectedRarities) == "table" then runtime.YupisotesPetState.selectedRarities = petSelections.selectedRarities end
	local miscSelections = type(selections.misc) == "table" and selections.misc or {}
	runtime.YupisotesMiscState.owner = miscSelections.owner or runtime.YupisotesMiscState.owner
	runtime.YupisotesMiscState.sprinkler = miscSelections.sprinkler or runtime.YupisotesMiscState.sprinkler
	runtime.YupisotesMiscState.wateringCan = miscSelections.wateringCan or runtime.YupisotesMiscState.wateringCan
	if type(miscSelections.plantNames) == "table" then runtime.YupisotesMiscState.plantNames = miscSelections.plantNames end
	if type(miscSelections.plantRarities) == "table" then runtime.YupisotesMiscState.plantRarities = miscSelections.plantRarities end
	runtime.YupisotesMiscState.placeMode = miscSelections.placeMode or runtime.YupisotesMiscState.placeMode
	runtime.YupisotesMiscState.actionDelay = tonumber(miscSelections.actionDelay) or runtime.YupisotesMiscState.actionDelay
	runtime.YupisotesMiscState.wateringLimit = tonumber(miscSelections.wateringLimit) or runtime.YupisotesMiscState.wateringLimit
	runtime.YupisotesMiscState.giftUsername = miscSelections.giftUsername or runtime.YupisotesMiscState.giftUsername
	runtime.YupisotesMiscState.giftType = miscSelections.giftType or runtime.YupisotesMiscState.giftType
	if type(miscSelections.giftRarities) == "table" then runtime.YupisotesMiscState.giftRarities = miscSelections.giftRarities end
	if type(miscSelections.giftItems) == "table" then runtime.YupisotesMiscState.giftItems = miscSelections.giftItems end
	runtime.YupisotesMiscState.giftAmount = tonumber(miscSelections.giftAmount) or runtime.YupisotesMiscState.giftAmount
	runtime.YupisotesMiscState.giftDelay = tonumber(miscSelections.giftDelay) or runtime.YupisotesMiscState.giftDelay
	runtime.YupisotesMiscState.mailReceiver = miscSelections.mailReceiver or runtime.YupisotesMiscState.mailReceiver
	runtime.YupisotesMiscState.mailCategory = miscSelections.mailCategory or runtime.YupisotesMiscState.mailCategory
	if type(miscSelections.mailItems) == "table" then runtime.YupisotesMiscState.mailItems = miscSelections.mailItems end
	if type(miscSelections.mailRarities) == "table" then runtime.YupisotesMiscState.mailRarities = miscSelections.mailRarities end
	runtime.YupisotesMiscState.mailAmount = tonumber(miscSelections.mailAmount) or runtime.YupisotesMiscState.mailAmount
	runtime.YupisotesMiscState.mailNote = miscSelections.mailNote or runtime.YupisotesMiscState.mailNote
	runtime.YupisotesMiscState.mailDelay = tonumber(miscSelections.mailDelay) or runtime.YupisotesMiscState.mailDelay
	runtime.YupisotesMiscState.hidePlantScope = miscSelections.hidePlantScope or runtime.YupisotesMiscState.hidePlantScope
	runtime.YupisotesMiscState.antiFlingMethod = miscSelections.antiFlingMethod or runtime.YupisotesMiscState.antiFlingMethod
	runtime.YupisotesMiscState.webhookTagType = miscSelections.webhookTagType or runtime.YupisotesMiscState.webhookTagType
	runtime.YupisotesMiscState.webhookTagId = miscSelections.webhookTagId or runtime.YupisotesMiscState.webhookTagId
	runtime.YupisotesMiscState.webhookUrl = miscSelections.webhookUrl or runtime.YupisotesMiscState.webhookUrl
	if type(miscSelections.webhookItems) == "table" then runtime.YupisotesMiscState.webhookItems = miscSelections.webhookItems end
	runtime.YupisotesMiscState.utilityTagType = miscSelections.utilityTagType or runtime.YupisotesMiscState.utilityTagType
	runtime.YupisotesMiscState.utilityTagId = miscSelections.utilityTagId or runtime.YupisotesMiscState.utilityTagId
	runtime.YupisotesMiscState.utilityWebhookUrl = miscSelections.utilityWebhookUrl or runtime.YupisotesMiscState.utilityWebhookUrl
	if type(miscSelections.utilityItemTypes) == "table" then runtime.YupisotesMiscState.utilityItemTypes = miscSelections.utilityItemTypes end
	if type(miscSelections.utilityItems) == "table" then runtime.YupisotesMiscState.utilityItems = miscSelections.utilityItems end
	if type(miscSelections.utilityRarities) == "table" then runtime.YupisotesMiscState.utilityRarities = miscSelections.utilityRarities end
	local visualSelections = type(selections.visual) == "table" and selections.visual or {}
	if type(visualSelections.selectedValueSeeds) == "table" then runtime.YupisotesVisualState.selectedValueSeeds = visualSelections.selectedValueSeeds end
	if visualSelections.highestFruitValueOnly ~= nil then runtime.YupisotesVisualState.highestFruitValueOnly = visualSelections.highestFruitValueOnly == true end
	local toggles = type(data.toggles) == "table" and data.toggles or {}
	local farmToggles = type(toggles.farm) == "table" and toggles.farm or {}
	autoPlantEnabled = farmToggles.autoPlant == true
	autoHarvestEnabled = farmToggles.autoHarvest == true
	autoSellEnabled = farmToggles.autoSell == true
	advancedSellEnabled = farmToggles.advancedSell == true
	doubleEnabled = farmToggles.doubleOrNothing == true
	autoFavoriteEnabled = farmToggles.autoFavorite == true
	autoShovelEnabled = farmToggles.autoShovel == true
	autoShovelFruitEnabled = farmToggles.autoShovelFruit == true
	autoTrowelEnabled = farmToggles.autoTrowel == true
	autoCollectDroppedSeedEnabled = farmToggles.autoCollectSeed == true
	autoSellPetEnabled = farmToggles.autoSellPet == true
	autoLeaveWeatherEnabled = farmToggles.autoLeaveWeather == true
	local shopToggles = type(toggles.shop) == "table" and toggles.shop or {}
	runtime.YupisotesShopState.limitedEnabled = shopToggles.buySeedsLimited == true
	runtime.YupisotesShopState.alwaysEnabled = shopToggles.buySeedsAlways == true
	runtime.YupisotesShopState.gearLimitedEnabled = shopToggles.buyGearLimited == true
	runtime.YupisotesShopState.gearAlwaysEnabled = shopToggles.buyGearAlways == true
	runtime.YupisotesShopState.propsLimitedEnabled = shopToggles.buyPropsLimited == true
	runtime.YupisotesShopState.propsAlwaysEnabled = shopToggles.buyPropsAlways == true
	runtime.YupisotesShopState.auctionEnabled = shopToggles.auction == true
	local petToggles = type(toggles.pet) == "table" and toggles.pet or {}
	runtime.YupisotesPetState.enabled = petToggles.wildPet == true
	runtime.YupisotesPetState.eggEnabled = petToggles.dragonEgg == true
	local miscToggles = type(toggles.misc) == "table" and toggles.misc or {}
	runtime.YupisotesMiscState.enabled = miscToggles.watering == true
	runtime.YupisotesMiscState.giftEnabled = miscToggles.autoGift == true
	runtime.YupisotesMiscState.autoAcceptGift = miscToggles.autoAcceptGift == true
	runtime.YupisotesMiscState.mailSelectedEnabled = miscToggles.mailSelected == true
	runtime.YupisotesMiscState.mailAllEnabled = miscToggles.mailAll == true
	runtime.YupisotesMiscState.mailClaimEnabled = miscToggles.mailClaim == true
	runtime.YupisotesMiscState.autoReconnect = miscToggles.autoReconnect == true
	runtime.YupisotesMiscState.boostFps = miscToggles.boostFps == true
	runtime.YupisotesMiscState.hidePlants = miscToggles.hidePlants == true
	runtime.YupisotesMiscState.protectionEnabled = miscToggles.protection == true
	runtime.YupisotesMiscState.webhookStockEnabled = miscToggles.webhookStock == true
	runtime.YupisotesMiscState.utilityWebhookEnabled = miscToggles.webhookUtility == true
	local visualToggles = type(toggles.visual) == "table" and toggles.visual or {}
	runtime.YupisotesVisualState.inventoryFruitEnabled = visualToggles.inventoryFruit == true
	runtime.YupisotesVisualState.gardenFruitEnabled = visualToggles.gardenFruit == true
	runtime.YupisotesVisualState.gardenValueEnabled = visualToggles.gardenValue == true
	runtime.YupisotesVisualState.selectedFruitValueEnabled = visualToggles.selectedFruitValue == true
	if type(data.visualEnabled) == "table" then
		runtime.YupisotesVisualState.selectedFruitValueEnabled = data.visualEnabled.selectedFruitValueEnabled == true
	end
	return true
end
runtime.YupisotesListConfigs = function()
	local names = {}
	runtime.YupisotesEnsureConfigFolders()
	if type(listfiles) == "function" then
		local ok, files = pcall(listfiles, runtime.YupisotesConfigFolder)
		if ok and type(files) == "table" then
			for _, path in ipairs(files) do
				local name = tostring(path):match("([^/\\]+)%.json$")
				if name then table.insert(names, name) end
			end
		end
	end
	if #names == 0 then table.insert(names, "Default") end
	table.sort(names)
	return names
end
runtime.YupisotesSaveConfig = function(name)
	name = runtime.YupisotesSanitizeConfigName(name)
	if type(writefile) ~= "function" or not runtime.YupisotesEnsureConfigFolders() then return false, "File API unavailable" end
	local ok, encoded = pcall(function() return game:GetService("HttpService"):JSONEncode(runtime.YupisotesExportConfig()) end)
	if not ok then return false, "Could not encode config" end
	local wrote, err = pcall(writefile, runtime.YupisotesConfigFolder .. "/" .. name .. ".json", encoded)
	if wrote then
		runtime.YupisotesConfigState.name = name
		runtime.YupisotesConfigState.selected = name
		pcall(writefile, runtime.YupisotesConfigFolder .. "/" .. name .. ".visualflags", runtime.YupisotesVisualState.selectedFruitValueEnabled and "1" or "0")
		if runtime.YupisotesConfigState.autoLoad then pcall(writefile, runtime.YupisotesAutoLoadFile, name) end
	end
	return wrote, wrote and "Saved " .. name or tostring(err)
end
runtime.YupisotesLoadConfig = function(name)
	name = runtime.YupisotesSanitizeConfigName(name)
	local path = runtime.YupisotesConfigFolder .. "/" .. name .. ".json"
	if type(isfile) ~= "function" or type(readfile) ~= "function" or not isfile(path) then return false, "Config not found" end
	local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(path)) end)
	if not ok or type(data) ~= "table" then return false, "Invalid config" end
	runtime.YupisotesImportConfig(data)
	local visualFlagsPath = runtime.YupisotesConfigFolder .. "/" .. name .. ".visualflags"
	if type(isfile) == "function" and type(readfile) == "function" and isfile(visualFlagsPath) then
		runtime.YupisotesVisualState.selectedFruitValueEnabled = readfile(visualFlagsPath) == "1"
	end
	runtime.YupisotesConfigState.name = name
	runtime.YupisotesConfigState.selected = name
	return true, "Loaded " .. name
end
runtime.YupisotesSetAutoLoad = function(name, enabled)
	name = runtime.YupisotesSanitizeConfigName(name)
	runtime.YupisotesEnsureConfigFolders()
	if enabled and type(writefile) == "function" then
		writefile(runtime.YupisotesAutoLoadFile, name)
	elseif not enabled and type(isfile) == "function" and isfile(runtime.YupisotesAutoLoadFile) and type(delfile) == "function" then
		delfile(runtime.YupisotesAutoLoadFile)
	end
	runtime.YupisotesConfigState.autoLoad = enabled
	return true
end
runtime.YupisotesEnsureConfigFolders()
if type(isfile) == "function" and type(readfile) == "function" and isfile(runtime.YupisotesAutoLoadFile) then
	local autoName = runtime.YupisotesSanitizeConfigName(readfile(runtime.YupisotesAutoLoadFile))
	local loaded = runtime.YupisotesLoadConfig(autoName)
	runtime.YupisotesConfigState.autoLoad = loaded == true
end
runtime.YupisotesWildPetCategoryOpen = false
runtime.YupisotesPetState.categoryOpen = false
runtime.YupisotesVisualState.fruitValueCategoryOpen = false
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
local iconColor = active and rgb(221, 154, 255) or rgb(110, 111, 119)
for _, iconObject in ipairs(ref.icon:GetDescendants()) do
if iconObject:IsA("Frame") then
iconObject.BackgroundColor3 = iconColor
elseif iconObject:IsA("UIStroke") then
iconObject.Color = iconColor
end
end
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
runtime.YupisotesGearShopData = require(ReplicatedStorage.SharedModules:WaitForChild("GearShopData"))
runtime.YupisotesCrateData = require(ReplicatedStorage.SharedModules:WaitForChild("CrateData"))
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
local function getDroppedSeedTargets()
local map = workspace:FindFirstChild("Map")
local folder = map and map:FindFirstChild("SeedPackSpawnServerLocations")
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local targets = {}
if not folder or not root then return targets end
for _, item in ipairs(folder:GetDescendants()) do
if item:IsA("BasePart") then
local seedName = getDroppedSeedName(item)
local special = isSpecialDroppedSeed(item)
local matches = (collectedSeedSelection == "Server" and special)
or (collectedSeedSelection == "User" and not special and seedName ~= nil)
local pendingUntil = droppedSeedPending[item]
if pendingUntil and (not item.Parent or os.clock() >= pendingUntil) then
droppedSeedPending[item] = nil
pendingUntil = nil
end
if matches and not pendingUntil then
table.insert(targets, {part = item, name = seedName, distance = (item.Position - root.Position).Magnitude})
end
end
end
table.sort(targets, function(a, b) return a.distance < b.distance end)
return targets
end
local function touchDroppedSeed(root, part)
if not root or not root.Parent or not part or not part.Parent then return false end
local original = root.CFrame
local ok = pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = part.CFrame
task.wait(0.08)
if firetouchinterest and part.Parent then
firetouchinterest(root, part, 0)
task.wait(0.04)
firetouchinterest(root, part, 1)
end
local deadline = os.clock() + 0.85
while part.Parent and os.clock() < deadline do
root.CFrame = part.CFrame
task.wait(0.06)
end
end)
if root.Parent then
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = original
end
return ok and not part.Parent
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
droppedSeedPending[target.part] = os.clock() + 1.5
if touchDroppedSeed(root, target.part) then
collected += 1
screenGui:SetAttribute("LastCollectedDroppedSeed", target.name)
else
droppedSeedPending[target.part] = os.clock() + 0.35
end
task.wait(math.max(0.05, collectedSeedDelay))
end
screenGui:SetAttribute("LastCollectedDroppedSeedCount", collected)
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", collected > 0 and ("Collected " .. collected .. " " .. collectedSeedSelection .. " seed(s)") or "Waiting for claimable seeds")
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
if autoPlantEnabled then
autoPlantRunId += 1
autoPlantOrigin = player.Character and player.Character:GetPivot().Position or nil
screenGui:SetAttribute("AutoPlantStatus", "Running")
runAutoPlant(autoPlantRunId)
end
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
if autoHarvestEnabled then
autoHarvestRunId += 1
screenGui:SetAttribute("AutoHarvestStatus", "Running")
runAutoHarvest(autoHarvestRunId)
end
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
if autoSellEnabled then
autoSellRunId += 1
screenGui:SetAttribute("AutoSellStatus", "Waiting for rule")
runAutoSell(autoSellRunId)
end
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
if advancedSellEnabled then
advancedSellRunId += 1
screenGui:SetAttribute("AdvancedSellStatus", "Checking prices")
runAdvancedSell(advancedSellRunId)
end
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
if doubleEnabled then
doubleRunId += 1
screenGui:SetAttribute("DoubleOrNothingStatus", "Waiting for inventory")
runDoubleOrNothing(doubleRunId)
end
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
if autoFavoriteEnabled then
autoFavoriteRunId += 1
screenGui:SetAttribute("AutoFavoriteStatus", "Checking inventory")
runAutoFavorite(autoFavoriteRunId)
end
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
if autoShovelFruitEnabled then
autoShovelFruitRunId += 1
screenGui:SetAttribute("AutoShovelFruitStatus", "Checking fruits")
runAutoShovelFruit(autoShovelFruitRunId)
end
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
if autoShovelEnabled then
autoShovelRunId += 1
screenGui:SetAttribute("AutoShovelStatus", "Checking plants")
runAutoShovel(autoShovelRunId)
end
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
if autoTrowelEnabled then
autoTrowelRunId += 1
screenGui:SetAttribute("AutoTrowelStatus", "Checking plants")
runAutoTrowel(autoTrowelRunId)
end
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
if autoCollectDroppedSeedEnabled then
autoCollectDroppedSeedRunId += 1
screenGui:SetAttribute("AutoCollectDroppedSeedStatus", "Checking nearby seeds")
runAutoCollectDroppedSeed(autoCollectDroppedSeedRunId)
end
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
if autoSellPetEnabled then
autoSellPetRunId += 1
screenGui:SetAttribute("AutoSellPetStatus", "Checking inventory")
runAutoSellPet(autoSellPetRunId)
end
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
screenGui:SetAttribute("AutoLeaveWeatherStatus", autoLeaveWeatherEnabled and "Watching selected weather" or "Stopped")
if autoLeaveWeatherEnabled then
autoLeaveWeatherRunId += 1
runAutoLeaveWeather(autoLeaveWeatherRunId)
end
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
	screenGui:SetAttribute("AutoBuySeedsStatus", (state.limitedEnabled or state.alwaysEnabled) and "Running" or "Stopped")
	if state.limitedEnabled or state.alwaysEnabled then
		state.restockId = nil
		ensureBuyLoop()
	end

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
		screenGui:SetAttribute("AutoBuyGearStatus", (state.gearLimitedEnabled or state.gearAlwaysEnabled) and "Running" or "Stopped")
		if state.gearLimitedEnabled or state.gearAlwaysEnabled then
			state.gearRestockId = nil
			ensureGearLoop()
		end
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
		screenGui:SetAttribute("AutoBuyPropertyStatus", (state.propsLimitedEnabled or state.propsAlwaysEnabled) and "Running" or "Stopped")
		if state.propsLimitedEnabled or state.propsAlwaysEnabled then
			state.propsRestockId = nil
			ensurePropertyLoop()
		end
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
		screenGui:SetAttribute("AutoBuyAuctionStatus", state.auctionEnabled and "Running" or "Stopped")
		if state.auctionEnabled then ensureAuctionLoop() end
	end
	createAuctionSection()
end
runtime.YupisotesShowPet = function()
	currentPage = "Pet"
	dropdownOpen = false
	disconnectSection()
	section.Visible = false
	setActiveTab("Pet")
	title.Text = "Pet"
	section.Parent = content
	clearList()
	accentLine.Visible = false
	farmSectionAccent.Visible = false
	list.Position = UDim2.fromOffset(0, 34)
	list.Size = UDim2.new(1, -2, 1, -35)
	list.CanvasPosition = Vector2.zero

	local state = runtime.YupisotesPetState
	state.categoryOpen = runtime.YupisotesWildPetCategoryOpen ~= false
	local petData = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetData"))
	local petNames = {}
	local displayToKey = {}
	local petRarities = {}
	local raritySeen = {}
	for key, data in pairs(petData) do
		if type(data) == "table" and type(data.Rarity) == "string" then
			local displayName = data.DisplayName or data.Name or tostring(key)
			displayToKey[displayName] = tostring(key)
			table.insert(petNames, displayName)
			if not raritySeen[data.Rarity] then
				raritySeen[data.Rarity] = true
				table.insert(petRarities, data.Rarity)
			end
		end
	end
	table.sort(petNames)
	local rarityOrder = {Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythic = 6, Super = 7, Secret = 8}
	table.sort(petRarities, function(a, b)
		return (rarityOrder[a] or 99) < (rarityOrder[b] or 99)
	end)

	local header = Instance.new("TextButton")
	header.Name = "WildPetHeader"
	header.AutoButtonColor = false
	header.Text = ""
	header.BackgroundColor3 = palette.card
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, 31)
	header.LayoutOrder = 0
	header.Parent = list
	corner(header, 4)
	local headerText = label(header, "Wild Pet", 13, palette.text, true)
	headerText.Position = UDim2.fromOffset(10, 0)
	headerText.Size = UDim2.new(1, -40, 1, 0)
	local headerArrow = label(header, "v", 14, rgb(210, 210, 216), true)
	headerArrow.Position = UDim2.new(1, -28, 0, 0)
	headerArrow.Size = UDim2.fromOffset(20, 31)
	headerArrow.TextXAlignment = Enum.TextXAlignment.Center
	headerArrow.Rotation = state.categoryOpen and 180 or 0
	local headerAccent = Instance.new("Frame")
	headerAccent.BackgroundColor3 = palette.accent
	headerAccent.BorderSizePixel = 0
	headerAccent.Position = UDim2.new(0, 0, 1, -2)
	headerAccent.Size = UDim2.new(1, 0, 0, 2)
	headerAccent.Parent = header

	local petContent = Instance.new("Frame")
	petContent.Name = "WildPetContent"
	petContent.BackgroundTransparency = 1
	petContent.BorderSizePixel = 0
	petContent.ClipsDescendants = true
	petContent.Size = UDim2.new(1, 0, 0, state.categoryOpen and 166 or 0)
	petContent.Visible = state.categoryOpen
	petContent.LayoutOrder = 1
	petContent.Parent = list

	local filters = {}
	local function closeFilters(except)
		for _, filter in ipairs(filters) do
			if filter ~= except then filter.setOpen(false) end
		end
	end
	local function makeFilter(name, titleText, descriptionText, y, choices, selected, zIndex)
		local entry = {open = false}
		local row = Instance.new("Frame")
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, 52)
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
		button.TextColor3 = palette.muted
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.TextTruncate = Enum.TextTruncate.AtEnd
		button.BackgroundColor3 = rgb(31, 26, 43)
		button.BorderSizePixel = 0
		button.Position = UDim2.new(0.62, 0, 0, 10)
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
		panel.Position = UDim2.new(0.62, 0, 0, y + 48)
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
		local optionLayout = Instance.new("UIListLayout")
		optionLayout.Padding = UDim.new(0, 2)
		optionLayout.Parent = options
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
			options.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
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
			option.Parent = options
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			local function renderOption()
				local active = selected[choice] == true
				option.TextColor3 = active and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = active and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = active and 0.1 or 0.35
			end
			renderOption()
			option.MouseButton1Click:Connect(function()
				selected[choice] = not selected[choice] and true or nil
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
			options.CanvasPosition = Vector2.zero
			updateCanvas()
		end)
		function entry.setOpen(open)
			entry.open = open
			panel.Size = UDim2.new(0.38, -7, 0, open and 152 or 0)
			buttonArrow.Rotation = open and 180 or 0
			TweenService:Create(petContent, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, open and math.max(166, y + 204) or 166),
			}):Play()
		end
		button.MouseButton1Click:Connect(function()
			closeFilters(entry)
			entry.setOpen(not entry.open)
		end)
		table.insert(filters, entry)
	end

	makeFilter("WildPetNames", "Pet Names", "Choose pet names to buy.", 0, petNames, state.selectedNames, 430)
	makeFilter("WildPetRarity", "Pet Rarity", "Choose pet rarities to buy.", 58, petRarities, state.selectedRarities, 440)

	local toggleRow = Instance.new("Frame")
	toggleRow.BackgroundColor3 = palette.card
	toggleRow.BorderSizePixel = 0
	toggleRow.Position = UDim2.fromOffset(0, 116)
	toggleRow.Size = UDim2.new(1, 0, 0, 48)
	toggleRow.Parent = petContent
	corner(toggleRow, 4)
	local toggleTitle = label(toggleRow, "Start Buy Pet", 12, palette.text, true)
	toggleTitle.Position = UDim2.fromOffset(10, 4)
	toggleTitle.Size = UDim2.new(0.78, -10, 0, 18)
	local toggleDescription = label(toggleRow, "Automatically buys matching pets when they appear.", 10, palette.muted, false)
	toggleDescription.Position = UDim2.fromOffset(10, 21)
	toggleDescription.Size = UDim2.new(0.78, -10, 0, 20)
	local toggle = Instance.new("TextButton")
	toggle.Name = "StartBuyPetToggle"
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
			BackgroundColor3 = state.enabled and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = state.enabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end
	local function buyWildPet(model, prompt)
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		local targetPart = prompt.Parent
		if not rootPart or not targetPart or not targetPart:IsA("BasePart") or not model.Parent then
			return false
		end
		local originalCFrame = rootPart.CFrame
		local originalHoldDuration = prompt.HoldDuration
		local success = false
		local ok = pcall(function()
			local focused = UserInputService:GetFocusedTextBox()
			if focused then focused:ReleaseFocus() end
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
			rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, -2)
			task.wait(0.08)
			prompt.HoldDuration = 0
			local virtualInput = game:GetService("VirtualInputManager")
			virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
			task.wait(0.03)
			virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			local deadline = os.clock() + 0.75
			while model.Parent and prompt.Parent and prompt.Enabled and os.clock() < deadline do
				rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, -2)
				task.wait(0.05)
			end
			success = not model.Parent or not prompt.Parent or not prompt.Enabled
		end)
		if prompt.Parent then
			pcall(function() prompt.HoldDuration = originalHoldDuration end)
		end
		if rootPart.Parent then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
			rootPart.CFrame = originalCFrame
		end
		return ok and success
	end
	local function ensureBuyLoop()
		state.runId += 1
		local runId = state.runId
		local generation = autoPlantGeneration
		task.spawn(function()
			while state.enabled and state.runId == runId and runtime.YupisotesGeneration == generation and screenGui.Parent do
				local hasFilter = next(state.selectedNames) ~= nil or next(state.selectedRarities) ~= nil
				local root = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WildPetSpawns")
				local found = false
				if hasFilter and root then
					for _, model in ipairs(root:GetChildren()) do
						local petKey = model:GetAttribute("PetName")
						local data = petKey and petData[petKey]
						local displayName = data and (data.DisplayName or data.Name) or petKey
						local rarity = data and data.Rarity
						local matches = state.selectedNames[displayName] or state.selectedNames[petKey] or state.selectedRarities[rarity]
						local prompt = matches and model:FindFirstChild("BuyPrompt", true)
						local pendingUntil = state.pending[model] or 0
						if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled and os.clock() >= pendingUntil then
							found = true
							state.pending[model] = os.clock() + 2
							screenGui:SetAttribute("AutoBuyWildPetStatus", "Teleporting to " .. tostring(displayName))
							if buyWildPet(model, prompt) then
								screenGui:SetAttribute("LastAutoBoughtWildPet", tostring(displayName))
								screenGui:SetAttribute("AutoBuyWildPetStatus", "Bought " .. tostring(displayName))
							else
								screenGui:SetAttribute("AutoBuyWildPetStatus", "Purchase failed: " .. tostring(displayName))
							end
							task.wait(0.15)
						end
					end
				end
				if not hasFilter then
					screenGui:SetAttribute("AutoBuyWildPetStatus", "Select a pet name or rarity")
				elseif not found then
					screenGui:SetAttribute("AutoBuyWildPetStatus", "Waiting for matching pet")
				end
				task.wait(0.25)
			end
		end)
	end
	toggle.MouseButton1Click:Connect(function()
		state.enabled = not state.enabled
		screenGui:SetAttribute("StartBuyPetEnabled", state.enabled)
		renderToggle()
		if state.enabled then
			ensureBuyLoop()
		else
			state.runId += 1
			screenGui:SetAttribute("AutoBuyWildPetStatus", "Stopped")
		end
	end)
	renderToggle()
	if state.enabled then ensureBuyLoop() end

	header.MouseButton1Click:Connect(function()
		state.categoryOpen = not state.categoryOpen
		runtime.YupisotesWildPetCategoryOpen = state.categoryOpen
		if state.categoryOpen then
			petContent.Visible = true
			petContent.Size = UDim2.new(1, 0, 0, 0)
			TweenService:Create(petContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, 166),
			}):Play()
		else
			closeFilters(nil)
			local collapseTween = TweenService:Create(petContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, 0),
			})
			collapseTween:Play()
			collapseTween.Completed:Once(function()
				if not state.categoryOpen and petContent.Parent then petContent.Visible = false end
			end)
		end
		TweenService:Create(headerArrow, TweenInfo.new(0.18), {Rotation = state.categoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("StartBuyPetEnabled", state.enabled)
	screenGui:SetAttribute("AutoBuyWildPetStatus", state.enabled and "Waiting for matching pet" or "Stopped")

	local eggHeader = Instance.new("TextButton")
	eggHeader.Name = "EggHeader"
	eggHeader.AutoButtonColor = false
	eggHeader.Text = ""
	eggHeader.BackgroundColor3 = palette.card
	eggHeader.BorderSizePixel = 0
	eggHeader.Size = UDim2.new(1, 0, 0, 31)
	eggHeader.LayoutOrder = 2
	eggHeader.Parent = list
	corner(eggHeader, 4)
	local eggHeaderText = label(eggHeader, "Egg", 13, palette.text, true)
	eggHeaderText.Position = UDim2.fromOffset(10, 0)
	eggHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local eggArrow = label(eggHeader, "v", 14, rgb(210, 210, 216), true)
	eggArrow.Position = UDim2.new(1, -28, 0, 0)
	eggArrow.Size = UDim2.fromOffset(20, 31)
	eggArrow.TextXAlignment = Enum.TextXAlignment.Center
	local eggAccent = Instance.new("Frame")
	eggAccent.BackgroundColor3 = palette.accent
	eggAccent.BorderSizePixel = 0
	eggAccent.Position = UDim2.new(0, 0, 1, -2)
	eggAccent.Size = UDim2.new(1, 0, 0, 2)
	eggAccent.Parent = eggHeader

	local eggContent = Instance.new("Frame")
	eggContent.Name = "EggContent"
	eggContent.BackgroundTransparency = 1
	eggContent.BorderSizePixel = 0
	eggContent.ClipsDescendants = true
	eggContent.Size = UDim2.new(1, 0, 0, 0)
	eggContent.LayoutOrder = 3
	eggContent.Parent = list
	local eggRow = Instance.new("Frame")
	eggRow.Name = "AutoHatchDragonEggRow"
	eggRow.BackgroundColor3 = palette.card
	eggRow.BorderSizePixel = 0
	eggRow.Size = UDim2.new(1, 0, 0, 52)
	eggRow.Parent = eggContent
	corner(eggRow, 4)
	local eggTitle = label(eggRow, "Auto Hatch Dragon Egg", 12, palette.text, true)
	eggTitle.Position = UDim2.fromOffset(10, 4)
	eggTitle.Size = UDim2.new(0.78, -10, 0, 18)
	local eggDescription = label(eggRow, "Detects Dragon Eggs in your garden, teleports to each and hatches it.", 10, palette.muted, false)
	eggDescription.Position = UDim2.fromOffset(10, 21)
	eggDescription.Size = UDim2.new(0.78, -10, 0, 27)
	eggDescription.TextWrapped = true

	local eggToggle = Instance.new("TextButton")
	eggToggle.Name = "AutoHatchDragonEggToggle"
	eggToggle.AutoButtonColor = false
	eggToggle.Text = ""
	eggToggle.BorderSizePixel = 0
	eggToggle.Position = UDim2.new(1, -50, 0.5, -11)
	eggToggle.Size = UDim2.fromOffset(38, 22)
	eggToggle.Parent = eggRow
	corner(eggToggle, 11)
	stroke(eggToggle, rgb(116, 70, 152), 0.45, 1)
	local eggKnob = Instance.new("Frame")
	eggKnob.BackgroundColor3 = rgb(239, 239, 243)
	eggKnob.BorderSizePixel = 0
	eggKnob.Size = UDim2.fromOffset(16, 16)
	eggKnob.Parent = eggToggle
	corner(eggKnob, 8)
	local function renderEggToggle()
		TweenService:Create(eggToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundColor3 = state.eggEnabled and palette.accent or rgb(48, 46, 58),
		}):Play()
		TweenService:Create(eggKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = state.eggEnabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3),
		}):Play()
	end
	local function getOwnedDragonEggs()
		local collectionService = game:GetService("CollectionService")
		local eggs = {}
		for _, egg in ipairs(collectionService:GetTagged("DragonEggInstance")) do
			if egg:IsA("Model") and egg.Parent then
				local owner = egg:GetAttribute("DragonEggOwner")
				if owner == nil or tonumber(owner) == player.UserId then
					table.insert(eggs, egg)
				end
			end
		end
		local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			table.sort(eggs, function(a, b)
				return (a:GetPivot().Position - rootPart.Position).Magnitude < (b:GetPivot().Position - rootPart.Position).Magnitude
			end)
		end
		return eggs
	end
	local function hatchDragonEgg(egg)
		local collectionService = game:GetService("CollectionService")
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		local targetPart = egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart", true)
		if not rootPart or not targetPart or not egg.Parent then return false end
		local originalCFrame = rootPart.CFrame
		local success = false
		local ok = pcall(function()
			local focused = UserInputService:GetFocusedTextBox()
			if focused then focused:ReleaseFocus() end
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
			rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, -2)
			task.wait(0.08)
			local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt then
				local originalHold = prompt.HoldDuration
				prompt.HoldDuration = 0
				local virtualInput = game:GetService("VirtualInputManager")
				virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
				task.wait(0.03)
				virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
				if prompt.Parent then prompt.HoldDuration = originalHold end
			else
				local virtualInput = game:GetService("VirtualInputManager")
				virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
				task.wait(0.03)
				virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			end
			local clickDetector = egg:FindFirstChildWhichIsA("ClickDetector", true)
			if clickDetector and fireclickdetector then fireclickdetector(clickDetector) end
			for _, part in ipairs(egg:GetDescendants()) do
				if part:IsA("BasePart") and firetouchinterest then
					firetouchinterest(rootPart, part, 0)
					firetouchinterest(rootPart, part, 1)
				end
			end
			local deadline = os.clock() + 1.5
			while egg.Parent and collectionService:HasTag(egg, "DragonEggInstance") and os.clock() < deadline do
				rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, -2)
				task.wait(0.06)
			end
			success = not egg.Parent or not collectionService:HasTag(egg, "DragonEggInstance")
		end)
		if rootPart.Parent then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
			rootPart.CFrame = originalCFrame
		end
		return ok and success
	end
	local function startEggLoop()
		state.eggRunId += 1
		local runId = state.eggRunId
		local generation = autoPlantGeneration
		task.spawn(function()
			while state.eggEnabled and state.eggRunId == runId and runtime.YupisotesGeneration == generation and screenGui.Parent do
				local eggs = getOwnedDragonEggs()
				local hatched = 0
				for _, egg in ipairs(eggs) do
					if not state.eggEnabled or state.eggRunId ~= runId then break end
					local pendingUntil = state.eggPending[egg] or 0
					if os.clock() >= pendingUntil then
						state.eggPending[egg] = os.clock() + 3
						screenGui:SetAttribute("AutoHatchDragonEggStatus", "Teleporting to Dragon Egg")
						if hatchDragonEgg(egg) then
							hatched += 1
							screenGui:SetAttribute("LastHatchedDragonEgg", os.time())
						else
							screenGui:SetAttribute("AutoHatchDragonEggStatus", "Hatch attempt rejected")
						end
						task.wait(0.15)
					end
				end
				if hatched > 0 then
					screenGui:SetAttribute("AutoHatchDragonEggStatus", "Hatched " .. hatched .. " Dragon Egg(s)")
				elseif #eggs == 0 then
					screenGui:SetAttribute("AutoHatchDragonEggStatus", "Waiting for Dragon Eggs")
				end
				task.wait(0.3)
			end
		end)
	end
	eggToggle.MouseButton1Click:Connect(function()
		state.eggEnabled = not state.eggEnabled
		screenGui:SetAttribute("AutoHatchDragonEggEnabled", state.eggEnabled)
		renderEggToggle()
		if state.eggEnabled then
			startEggLoop()
		else
			state.eggRunId += 1
			screenGui:SetAttribute("AutoHatchDragonEggStatus", "Stopped")
		end
	end)
	renderEggToggle()
	if state.eggEnabled then startEggLoop() end
	local eggOpen = false
	eggHeader.MouseButton1Click:Connect(function()
		eggOpen = not eggOpen
		TweenService:Create(eggContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, eggOpen and 52 or 0),
		}):Play()
		TweenService:Create(eggArrow, TweenInfo.new(0.18), {Rotation = eggOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("AutoHatchDragonEggEnabled", state.eggEnabled)
	screenGui:SetAttribute("AutoHatchDragonEggStatus", state.eggEnabled and "Waiting for Dragon Eggs" or "Stopped")
end
runtime.YupisotesShowMisc = function()
	local state = runtime.YupisotesMiscState
	currentPage = "Misc"
	dropdownOpen = false
	disconnectSection()
	section.Visible = false
	setActiveTab("Misc")
	title.Text = "Misc"
	section.Parent = content
	clearList()
	accentLine.Visible = false
	farmSectionAccent.Visible = false
	list.Position = UDim2.fromOffset(0, 34)
	list.Size = UDim2.new(1, -2, 1, -35)
	list.CanvasPosition = Vector2.zero

	local sprinklerData = require(ReplicatedStorage.SharedModules:WaitForChild("SprinklerData"))
	local wateringData = require(ReplicatedStorage.SharedModules:WaitForChild("WateringcanData"))
	local sprinklerChoices = {"All Sprinkler"}
	local wateringChoices = {"All Watering Can"}
	for _, data in ipairs(sprinklerData) do table.insert(sprinklerChoices, data.SprinklerName) end
	for _, data in ipairs(wateringData) do table.insert(wateringChoices, data.Name) end
	local ownerChoices = {"My Plot"}
	for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
		if other ~= player and other:GetAttribute("PlotId") then table.insert(ownerChoices, other.Name) end
	end
	table.sort(ownerChoices, function(a, b)
		if a == "My Plot" then return true end
		if b == "My Plot" then return false end
		return a < b
	end)
	if state.owner ~= "My Plot" and not game:GetService("Players"):FindFirstChild(state.owner) then state.owner = "My Plot" end

	local header = Instance.new("TextButton")
	header.Name = "AutoWateringHeader"
	header.AutoButtonColor = false
	header.Text = ""
	header.BackgroundColor3 = palette.card
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, 31)
	header.LayoutOrder = 0
	header.Parent = list
	corner(header, 4)
	local headerText = label(header, "Auto Watering Can & Sprinkler", 13, palette.text, true)
	headerText.Position = UDim2.fromOffset(10, 0)
	headerText.Size = UDim2.new(1, -40, 1, 0)
	local headerArrow = label(header, "v", 14, rgb(210, 210, 216), true)
	headerArrow.Position = UDim2.new(1, -28, 0, 0)
	headerArrow.Size = UDim2.fromOffset(20, 31)
	headerArrow.TextXAlignment = Enum.TextXAlignment.Center
	local headerAccent = Instance.new("Frame")
	headerAccent.BackgroundColor3 = palette.accent
	headerAccent.BorderSizePixel = 0
	headerAccent.Position = UDim2.new(0, 0, 1, -2)
	headerAccent.Size = UDim2.new(1, 0, 0, 2)
	headerAccent.Parent = header

	local miscContent = Instance.new("Frame")
	miscContent.Name = "AutoWateringContent"
	miscContent.BackgroundTransparency = 1
	miscContent.BorderSizePixel = 0
	miscContent.ClipsDescendants = true
	miscContent.Size = UDim2.new(1, 0, 0, 0)
	miscContent.LayoutOrder = 1
	miscContent.Parent = list
	local openDropdown
	local function closeDropdown()
		if openDropdown then
			openDropdown.panel.Size = UDim2.new(0.38, -7, 0, 0)
			openDropdown.arrow.Rotation = 0
			openDropdown = nil
		end
	end
	local function makeRow(name, y, height, titleText, descriptionText, rowParent)
		local row = Instance.new("Frame")
		row.Name = name
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, height)
		row.Parent = rowParent or miscContent
		corner(row, 4)
		local rowTitle = label(row, titleText, 12, palette.text, true)
		rowTitle.Position = UDim2.fromOffset(10, 4)
		rowTitle.Size = UDim2.new(0.62, -10, 0, 18)
		if descriptionText then
			local description = label(row, descriptionText, 10, palette.muted, false)
			description.Position = UDim2.fromOffset(10, 21)
			description.Size = UDim2.new(0.62, -10, 0, height - 24)
			description.TextWrapped = true
		end
		return row
	end
	local function makeDropdown(name, y, titleText, descriptionText, choices, selection, multi, zIndex, rowParent, onChanged, choiceFilter)
		local dropdownParent = rowParent or miscContent
		local row = makeRow(name .. "Row", y, 52, titleText, descriptionText, dropdownParent)
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
		button.Position = UDim2.new(0.62, 0, 0, 10)
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
		panel.Name = name .. "Dropdown"
		panel.BackgroundColor3 = rgb(18, 18, 25)
		panel.BorderSizePixel = 0
		panel.ClipsDescendants = true
		panel.Position = UDim2.new(0.62, 0, 0, y + 48)
		panel.Size = UDim2.new(0.38, -7, 0, 0)
		panel.ZIndex = zIndex
		panel.Parent = dropdownParent
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
		local optionLayout = Instance.new("UIListLayout")
		optionLayout.Padding = UDim.new(0, 2)
		optionLayout.Parent = options
		local optionButtons = {}
		local function refreshSummary()
			if multi then
				local values = {}
				for _, choice in ipairs(choices) do if selection[choice] then table.insert(values, choice) end end
				button.Text = #values > 0 and table.concat(values, ", ") or "Select Options"
				button.TextColor3 = #values > 0 and palette.text or palette.muted
			else
				button.Text = selection.get()
			end
		end
		local function renderOptions()
			for choice, option in pairs(optionButtons) do
				local active = multi and selection[choice] == true or not multi and selection.get() == choice
				option.TextColor3 = active and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = active and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = active and 0.1 or 0.35
			end
		end
		local function refreshOptionVisibility()
			local query = string.lower(search.Text)
			for choice, option in pairs(optionButtons) do
				local matchesSearch = query == "" or string.find(string.lower(choice), query, 1, true) ~= nil
				option.Visible = matchesSearch and (not choiceFilter or choiceFilter(choice))
			end
			options.CanvasPosition = Vector2.zero
		end
		local function rebuildOptions(newChoices)
			if newChoices then choices = newChoices end
			for _, option in pairs(optionButtons) do option:Destroy() end
			table.clear(optionButtons)
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
				option.Parent = options
				corner(option, 3)
				padding(option, 10, 0, 0, 0)
				optionButtons[choice] = option
				option.MouseButton1Click:Connect(function()
					if multi then selection[choice] = not selection[choice] and true or nil else selection.set(choice) end
					refreshSummary()
					renderOptions()
					if onChanged then onChanged(choice) end
					if not multi then closeDropdown() end
				end)
			end
			refreshSummary()
			renderOptions()
			refreshOptionVisibility()
		end
		rebuildOptions()
		optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			options.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
		end)
		options.CanvasSize = UDim2.fromOffset(0, optionLayout.AbsoluteContentSize.Y)
		search:GetPropertyChangedSignal("Text"):Connect(function()
			refreshOptionVisibility()
		end)
		refreshOptionVisibility()
		button.MouseButton1Click:Connect(function()
			local opening = not openDropdown or openDropdown.panel ~= panel
			closeDropdown()
			if opening then
				panel.Size = UDim2.new(0.38, -7, 0, math.min(150, 38 + (#choices * 29)))
				arrow.Rotation = 180
				openDropdown = {panel = panel, arrow = arrow}
			end
		end)
		return button, {
			refreshOptions = refreshOptionVisibility,
			refreshSummary = refreshSummary,
			renderOptions = renderOptions,
			setChoices = rebuildOptions,
		}
	end

	local _, ownerDropdown = makeDropdown("WaterOwner", 0, "Select Owner", "Whose garden to farm. My Plot = your own.", ownerChoices, {
		get = function() return state.owner end,
		set = function(value) state.owner = value; screenGui:SetAttribute("WaterFarmOwner", value) end,
	}, false, 500)
	local refreshOwners = Instance.new("TextButton")
	refreshOwners.Name = "RefreshWaterOwnerList"
	refreshOwners.AutoButtonColor = true
	refreshOwners.Text = "Refresh Owner List"
	refreshOwners.Font = Enum.Font.GothamBold
	refreshOwners.TextSize = 11
	refreshOwners.TextColor3 = palette.text
	refreshOwners.BackgroundColor3 = rgb(30, 35, 30)
	refreshOwners.BorderSizePixel = 0
	refreshOwners.Position = UDim2.fromOffset(0, 58)
	refreshOwners.Size = UDim2.new(1, 0, 0, 34)
	refreshOwners.Parent = miscContent
	corner(refreshOwners, 4)
	refreshOwners.MouseButton1Click:Connect(function()
		local refreshedChoices = {"My Plot"}
		for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
			if other ~= player and other:GetAttribute("PlotId") then table.insert(refreshedChoices, other.Name) end
		end
		table.sort(refreshedChoices, function(a, b)
			if a == "My Plot" then return true end
			if b == "My Plot" then return false end
			return a < b
		end)
		if state.owner ~= "My Plot" and not table.find(refreshedChoices, state.owner) then
			state.owner = "My Plot"
			screenGui:SetAttribute("WaterFarmOwner", state.owner)
		end
		ownerDropdown.setChoices(refreshedChoices)
	end)
	makeDropdown("WaterSprinkler", 98, "Select Sprinkler", "Choose which sprinkler to place.", sprinklerChoices, {
		get = function() return state.sprinkler end,
		set = function(value) state.sprinkler = value end,
	}, false, 490)
	makeDropdown("WateringCan", 156, "Select Watering Can", "Choose which watering can to use.", wateringChoices, {
		get = function() return state.wateringCan end,
		set = function(value) state.wateringCan = value end,
	}, false, 480)
	makeDropdown("WaterPlantNames", 214, "Farm Plant Name", "Only target these plants (sprinkler + watering).", favoriteFruitOptions, state.plantNames, true, 470)
	makeDropdown("WaterPlantRarity", 272, "Farm Plant Rarity", "Only target plants from these rarities.", rarityOptions, state.plantRarities, true, 460)
	makeDropdown("WaterPlaceMode", 330, "Farm Type Place", "Choose how Yupisotes picks the plant order.", {"Best Weight", "Nearest", "Oldest", "Random"}, {
		get = function() return state.placeMode end,
		set = function(value) state.placeMode = value end,
	}, false, 450)

	local delayRow = makeRow("WaterActionDelayRow", 388, 48, "Farm Action Delay", "Wait time between each place/water action.")
	local delayInput = Instance.new("TextBox")
	delayInput.Name = "WaterActionDelayInput"
	delayInput.ClearTextOnFocus = false
	delayInput.Text = tostring(state.actionDelay)
	delayInput.Font = Enum.Font.GothamBold
	delayInput.TextSize = 11
	delayInput.TextColor3 = palette.text
	delayInput.BackgroundColor3 = rgb(31, 26, 43)
	delayInput.BorderSizePixel = 0
	delayInput.Position = UDim2.new(0.64, 0, 0, 12)
	delayInput.Size = UDim2.fromOffset(34, 24)
	delayInput.Parent = delayRow
	corner(delayInput, 4)
	stroke(delayInput, rgb(125, 49, 166), 0.2, 1)
	local delayBar = Instance.new("Frame")
	delayBar.BackgroundColor3 = rgb(65, 64, 75)
	delayBar.BorderSizePixel = 0
	delayBar.Position = UDim2.new(0.64, 43, 0.5, -2)
	delayBar.Size = UDim2.new(0.36, -58, 0, 4)
	delayBar.Parent = delayRow
	corner(delayBar, 2)
	local delayFill = Instance.new("Frame")
	delayFill.Name = "WaterActionDelayFill"
	delayFill.BackgroundColor3 = palette.accent
	delayFill.BorderSizePixel = 0
	delayFill.Size = UDim2.new(math.clamp(state.actionDelay / 10, 0, 1), 0, 1, 0)
	delayFill.Parent = delayBar
	corner(delayFill, 2)
	local delayKnob = Instance.new("Frame")
	delayKnob.BackgroundColor3 = palette.accent
	delayKnob.BorderSizePixel = 0
	delayKnob.Size = UDim2.fromOffset(10, 10)
	delayKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	delayKnob.Parent = delayBar
	corner(delayKnob, 5)
	local draggingDelay = false
	local function renderDelay()
		delayInput.Text = tostring(math.floor(state.actionDelay * 10 + 0.5) / 10)
		delayFill.Size = UDim2.new(math.clamp(state.actionDelay / 10, 0, 1), 0, 1, 0)
		delayKnob.Position = UDim2.fromScale(math.clamp(state.actionDelay / 10, 0, 1), 0.5)
		screenGui:SetAttribute("WaterActionDelay", state.actionDelay)
	end
	local function setDelayFromX(x)
		local alpha = math.clamp((x - delayBar.AbsolutePosition.X) / math.max(1, delayBar.AbsoluteSize.X), 0, 1)
		state.actionDelay = math.floor(alpha * 100 + 0.5) / 10
		renderDelay()
	end
	delayBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingDelay = true; setDelayFromX(input.Position.X) end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if draggingDelay and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setDelayFromX(input.Position.X) end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingDelay = false end
	end)
	delayInput.FocusLost:Connect(function()
		state.actionDelay = math.clamp(tonumber((delayInput.Text:gsub(",", "."))) or 1, 0, 10)
		renderDelay()
	end)
	renderDelay()

	local countRow = makeRow("WateringLimitRow", 442, 48, "How Many Watering Can", "Rejoin after this many waters. 0 = no limit.")
	local countInput = Instance.new("TextBox")
	countInput.Name = "WateringLimitInput"
	countInput.ClearTextOnFocus = false
	countInput.Text = tostring(state.wateringLimit)
	countInput.Font = Enum.Font.GothamBold
	countInput.TextSize = 11
	countInput.TextColor3 = palette.text
	countInput.TextXAlignment = Enum.TextXAlignment.Left
	countInput.BackgroundColor3 = rgb(31, 26, 43)
	countInput.BorderSizePixel = 0
	countInput.Position = UDim2.new(0.62, 0, 0, 8)
	countInput.Size = UDim2.new(0.38, -7, 0, 32)
	countInput.Parent = countRow
	corner(countInput, 4)
	stroke(countInput, rgb(91, 39, 124), 0.25, 1)
	padding(countInput, 8, 0, 8, 0)
	local function commitCount()
		state.wateringLimit = math.max(0, math.floor(tonumber(countInput.Text) or 0))
		countInput.Text = tostring(state.wateringLimit)
		screenGui:SetAttribute("WateringActionLimit", state.wateringLimit)
	end
	countInput.FocusLost:Connect(commitCount)

	local startRow = makeRow("StartAutoWateringRow", 496, 54, "Start Auto Sprinkler & Watering", "Places one sprinkler per plot, then waters your plants. Set 'How Many Watering Can' to stop after that many waterings.")
	local toggle = Instance.new("TextButton")
	toggle.Name = "StartAutoWateringToggle"
	toggle.AutoButtonColor = false
	toggle.Text = ""
	toggle.BorderSizePixel = 0
	toggle.Position = UDim2.new(1, -50, 0.5, -11)
	toggle.Size = UDim2.fromOffset(38, 22)
	toggle.Parent = startRow
	corner(toggle, 11)
	stroke(toggle, rgb(116, 70, 152), 0.45, 1)
	local toggleKnob = Instance.new("Frame")
	toggleKnob.BackgroundColor3 = rgb(239, 239, 243)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.Size = UDim2.fromOffset(16, 16)
	toggleKnob.Parent = toggle
	corner(toggleKnob, 8)
	local function renderToggle()
		TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = state.enabled and palette.accent or rgb(48, 46, 58)}):Play()
		TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = state.enabled and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)}):Play()
	end
	local function getOwnerPlayer()
		return state.owner == "My Plot" and player or game:GetService("Players"):FindFirstChild(state.owner)
	end
	local function getPlot()
		local ownerPlayer = getOwnerPlayer()
		local plotId = ownerPlayer and ownerPlayer:GetAttribute("PlotId")
		return plotId and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId)), tonumber(plotId)
	end
	local function getTargets(plot)
		local targets = {}
		local plants = plot and plot:FindFirstChild("Plants")
		if not plants then return targets end
		local useNames = next(state.plantNames) ~= nil
		local useRarities = next(state.plantRarities) ~= nil
		for _, plant in ipairs(plants:GetChildren()) do
			local seedName = plant:GetAttribute("SeedName")
			local rarity = seedName and (seedRarities[seedName] or "Common")
			if (not useNames or state.plantNames[seedName]) and (not useRarities or state.plantRarities[rarity]) then
				table.insert(targets, plant)
			end
		end
		local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if state.placeMode == "Random" then
			for index = #targets, 2, -1 do local swap = math.random(index); targets[index], targets[swap] = targets[swap], targets[index] end
		else
			table.sort(targets, function(a, b)
				if state.placeMode == "Nearest" and rootPart then return (a:GetPivot().Position - rootPart.Position).Magnitude < (b:GetPivot().Position - rootPart.Position).Magnitude end
				if state.placeMode == "Oldest" then return (a:GetAttribute("PlantedAt") or math.huge) < (b:GetAttribute("PlantedAt") or math.huge) end
				local aw = a:GetAttribute("Height") or a:GetAttribute("MaxAge") or 0
				local bw = b:GetAttribute("Height") or b:GetAttribute("MaxAge") or 0
				return aw > bw
			end)
		end
		return targets
	end
	local toolRanks = {Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythic = 6, Super = 7}
	local function findTool(attributeName, selectedName, allName)
		local best, bestRank
		for _, container in ipairs({player:FindFirstChildOfClass("Backpack"), player.Character}) do
			if container then
				for _, tool in ipairs(container:GetChildren()) do
					local toolName = tool:IsA("Tool") and tool:GetAttribute(attributeName)
					if toolName and (tool:GetAttribute("Count") or 1) > 0 and (selectedName == allName or toolName == selectedName) then
						local rank = 0
						for rarity, value in pairs(toolRanks) do if string.find(toolName, rarity, 1, true) then rank = value break end end
						if not best or rank > bestRank then best, bestRank = tool, rank end
					end
				end
			end
		end
		return best
	end
	local function targetPosition(plot, plant)
		local pivot = plant:GetPivot().Position
		local bestArea, bestDistance
		for _, area in ipairs(CollectionService:GetTagged("PlantArea")) do
			if area:IsA("BasePart") and area:IsDescendantOf(plot) then
				local distance = (Vector2.new(area.Position.X, area.Position.Z) - Vector2.new(pivot.X, pivot.Z)).Magnitude
				if not bestDistance or distance < bestDistance then bestArea, bestDistance = area, distance end
			end
		end
		return Vector3.new(pivot.X, bestArea and (bestArea.Position.Y + bestArea.Size.Y / 2) or 142.602, pivot.Z)
	end
	local function hasSprinkler(plot)
		local folder = plot and plot:FindFirstChild("Sprinklers")
		return folder and #folder:GetChildren() > 0
	end
	local function performAt(position, callback)
		local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not rootPart then return false end
		local originalCFrame = rootPart.CFrame
		local ok = pcall(function()
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
			rootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
			task.wait(0.1)
			callback()
			task.wait(0.28)
		end)
		if rootPart.Parent then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
			rootPart.CFrame = originalCFrame
		end
		return ok
	end
	local function startLoop()
		state.runId += 1
		local runId = state.runId
		local generation = autoPlantGeneration
		task.spawn(function()
			local watered = 0
			while state.enabled and state.runId == runId and runtime.YupisotesGeneration == generation and screenGui.Parent do
				local plot, plotId = getPlot()
				local targets = getTargets(plot)
				if not plot then
					screenGui:SetAttribute("AutoWateringStatus", "Selected owner has no plot")
				elseif #targets == 0 then
					screenGui:SetAttribute("AutoWateringStatus", "No matching plants")
				else
					local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
					if not hasSprinkler(plot) then
						local sprinkler = findTool("Sprinkler", state.sprinkler, "All Sprinkler")
						if sprinkler then
							if humanoid and sprinkler.Parent ~= player.Character then humanoid:EquipTool(sprinkler); task.wait(0.05) end
							local position = targetPosition(plot, targets[1])
							local ok = performAt(position, function() networking.Place.PlaceSprinkler:Fire(position, sprinkler:GetAttribute("Sprinkler"), sprinkler, plotId) end)
							screenGui:SetAttribute("AutoWateringStatus", ok and "Placed sprinkler" or "Sprinkler rejected")
							task.wait(math.max(0.1, state.actionDelay))
						else
							screenGui:SetAttribute("AutoWateringStatus", "No matching sprinkler available")
						end
					end
					for _, plant in ipairs(targets) do
						if not state.enabled or state.runId ~= runId then break end
						if state.wateringLimit > 0 and watered >= state.wateringLimit then break end
						local can = findTool("WateringCan", state.wateringCan, "All Watering Can")
						if not can then screenGui:SetAttribute("AutoWateringStatus", "No matching watering can available"); break end
						if humanoid and can.Parent ~= player.Character then humanoid:EquipTool(can); task.wait(0.05) end
						local position = targetPosition(plot, plant) - Vector3.new(0, 0.3, 0)
						local ok = performAt(position, function() networking.WateringCan.UseWateringCan:Fire(position, can:GetAttribute("WateringCan"), can) end)
						if ok then
							watered += 1
							screenGui:SetAttribute("LastWateredPlant", plant:GetAttribute("SeedName"))
							screenGui:SetAttribute("AutoWateringCount", watered)
							screenGui:SetAttribute("AutoWateringStatus", "Watering " .. tostring(plant:GetAttribute("SeedName")))
						end
						task.wait(math.max(0.1, state.actionDelay))
					end
					if state.wateringLimit > 0 and watered >= state.wateringLimit then
						state.enabled = false
						screenGui:SetAttribute("AutoWateringStatus", "Watering limit reached")
						screenGui:SetAttribute("AutoWateringEnabled", false)
						renderToggle()
						break
					end
				end
				task.wait(math.max(0.2, state.actionDelay))
			end
		end)
	end
	toggle.MouseButton1Click:Connect(function()
		commitCount()
		state.enabled = not state.enabled
		screenGui:SetAttribute("AutoWateringEnabled", state.enabled)
		renderToggle()
		if state.enabled then startLoop() else state.runId += 1; screenGui:SetAttribute("AutoWateringStatus", "Stopped") end
	end)
	renderToggle()
	if state.enabled then startLoop() end
	local categoryOpen = false
	header.MouseButton1Click:Connect(function()
		categoryOpen = not categoryOpen
		if not categoryOpen then closeDropdown() end
		TweenService:Create(miscContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, categoryOpen and 550 or 0)}):Play()
		TweenService:Create(headerArrow, TweenInfo.new(0.18), {Rotation = categoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("WaterFarmOwner", state.owner)
	screenGui:SetAttribute("AutoWateringEnabled", state.enabled)
	screenGui:SetAttribute("AutoWateringStatus", state.enabled and "Running" or "Stopped")

	local giftKinds = {
		Seed = {attribute = "SeedTool", remoteType = "Seeds"},
		Fruit = {attribute = "HarvestedFruit", remoteType = "HarvestedFruits"},
		Crate = {attribute = "Crate", remoteType = "Crates"},
		Gnome = {attribute = "Gnome", remoteType = "Gnomes"},
		Mushroom = {attribute = "Mushroom", remoteType = "Mushrooms"},
		Sprinkler = {attribute = "Sprinkler", remoteType = "Sprinklers"},
		["Watering Can"] = {attribute = "WateringCan", remoteType = "WateringCans"},
	}
	local giftTypeChoices = {"Seed", "Fruit", "Crate", "Gnome", "Mushroom", "Sprinkler", "Watering Can"}
	local function giftItemName(tool, kind)
		local value = tool:GetAttribute(kind.attribute)
		if type(value) == "string" and value ~= "" then return value end
		local seedName = tool:GetAttribute("SeedName")
		if type(seedName) == "string" and seedName ~= "" then return seedName end
		return tool.Name
	end
	local function giftItemRarity(tool, itemName)
		local explicit = tool:GetAttribute("Rarity")
		if type(explicit) == "string" and explicit ~= "" then return explicit end
		local seedName = tool:GetAttribute("SeedName")
		if type(seedName) ~= "string" then seedName = itemName:gsub(" Seed$", "") end
		if seedRarities[seedName] then return seedRarities[seedName] end
		for _, rarity in ipairs(rarityOptions) do
			if string.find(string.lower(itemName), string.lower(rarity), 1, true) then return rarity end
		end
		return "Common"
	end
	local function matchingGiftTools(ignoreFilters)
		local kind = giftKinds[state.giftType] or giftKinds.Seed
		local found = {}
		local function scan(parent)
			if not parent then return end
			for _, tool in ipairs(parent:GetChildren()) do
				if tool:IsA("Tool") and tool:GetAttribute(kind.attribute) ~= nil then
					local itemName = giftItemName(tool, kind)
					local hasItemFilter = not ignoreFilters and next(state.giftItems) ~= nil
					local hasRarityFilter = not ignoreFilters and next(state.giftRarities) ~= nil
					local itemMatches = not hasItemFilter or state.giftItems[itemName] == true
					local rarityMatches = not hasRarityFilter or state.giftRarities[giftItemRarity(tool, itemName)] == true
					if itemMatches and rarityMatches then table.insert(found, {tool = tool, name = itemName, kind = kind}) end
				end
			end
		end
		scan(player:FindFirstChildOfClass("Backpack"))
		scan(player.Character)
		table.sort(found, function(a, b) return a.name < b.name end)
		return found
	end
	local function collectGiftItemChoices()
		local choices = {}
		for _, entry in ipairs(matchingGiftTools(true)) do
			if not table.find(choices, entry.name) then table.insert(choices, entry.name) end
		end
		table.sort(choices)
		return choices
	end
	local giftItemChoices = collectGiftItemChoices()
	do
		for selected in pairs(state.giftItems) do
			if not table.find(giftItemChoices, selected) then state.giftItems[selected] = nil end
		end
	end

	local giftHeader = Instance.new("TextButton")
	giftHeader.Name = "AutoGiftHeader"
	giftHeader.AutoButtonColor = false
	giftHeader.Text = ""
	giftHeader.BackgroundColor3 = palette.card
	giftHeader.BorderSizePixel = 0
	giftHeader.Size = UDim2.new(1, 0, 0, 31)
	giftHeader.LayoutOrder = 2
	giftHeader.Parent = list
	corner(giftHeader, 4)
	local giftHeaderText = label(giftHeader, "Auto Gift", 13, palette.text, true)
	giftHeaderText.Position = UDim2.fromOffset(10, 0)
	giftHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local giftArrow = label(giftHeader, "v", 14, rgb(210, 210, 216), true)
	giftArrow.Position = UDim2.new(1, -28, 0, 0)
	giftArrow.Size = UDim2.fromOffset(20, 31)
	giftArrow.TextXAlignment = Enum.TextXAlignment.Center
	giftArrow.Rotation = state.giftCategoryOpen and 180 or 0
	local giftAccent = Instance.new("Frame")
	giftAccent.BackgroundColor3 = palette.accent
	giftAccent.BorderSizePixel = 0
	giftAccent.Position = UDim2.new(0, 0, 1, -2)
	giftAccent.Size = UDim2.new(1, 0, 0, 2)
	giftAccent.Parent = giftHeader

	local giftContent = Instance.new("Frame")
	giftContent.Name = "AutoGiftContent"
	giftContent.BackgroundTransparency = 1
	giftContent.BorderSizePixel = 0
	giftContent.ClipsDescendants = true
	giftContent.Size = UDim2.new(1, 0, 0, state.giftCategoryOpen and 482 or 0)
	giftContent.LayoutOrder = 3
	giftContent.Parent = list

	local usernameRow = makeRow("GiftUsernameRow", 0, 52, "Gift Username", "Player name that will receive the gift.", giftContent)
	local usernameInput = Instance.new("TextBox")
	usernameInput.Name = "GiftUsernameInput"
	usernameInput.ClearTextOnFocus = false
	usernameInput.PlaceholderText = "Input value"
	usernameInput.Text = state.giftUsername
	usernameInput.Font = Enum.Font.GothamBold
	usernameInput.TextSize = 11
	usernameInput.TextColor3 = palette.text
	usernameInput.PlaceholderColor3 = palette.muted
	usernameInput.TextXAlignment = Enum.TextXAlignment.Left
	usernameInput.BackgroundColor3 = rgb(31, 26, 43)
	usernameInput.BorderSizePixel = 0
	usernameInput.Position = UDim2.new(0.62, 0, 0, 10)
	usernameInput.Size = UDim2.new(0.38, -7, 0, 32)
	usernameInput.Parent = usernameRow
	corner(usernameInput, 4)
	stroke(usernameInput, rgb(72, 48, 96), 0.35, 1)
	padding(usernameInput, 10, 0, 8, 0)
	usernameInput.FocusLost:Connect(function() state.giftUsername = usernameInput.Text:match("^%s*(.-)%s*$") or "" end)

	local giftItemDropdown
	local function refreshGiftItemChoices()
		local refreshedChoices = collectGiftItemChoices()
		for selected in pairs(state.giftItems) do
			if not table.find(refreshedChoices, selected) then state.giftItems[selected] = nil end
		end
		if giftItemDropdown then giftItemDropdown.setChoices(refreshedChoices) end
	end
	makeDropdown("GiftType", 58, "Gift Type", "Choose what kind of item to gift.", giftTypeChoices, {
		get = function() return state.giftType end,
		set = function(value)
			if state.giftType ~= value then
				state.giftType = value
				table.clear(state.giftItems)
			end
		end,
	}, false, 430, giftContent, refreshGiftItemChoices)
	makeDropdown("GiftRarity", 116, "Gift Rarity", "Gift items from these rarities.", rarityOptions, state.giftRarities, true, 420, giftContent)
	giftItemDropdown = select(2, makeDropdown("GiftItem", 174, "Gift Item", "Gift these exact item names.", giftItemChoices, state.giftItems, true, 410, giftContent))

	local refreshGift = Instance.new("TextButton")
	refreshGift.Name = "RefreshGiftItem"
	refreshGift.AutoButtonColor = true
	refreshGift.Text = "Refresh Gift Item"
	refreshGift.Font = Enum.Font.GothamBold
	refreshGift.TextSize = 11
	refreshGift.TextColor3 = palette.text
	refreshGift.BackgroundColor3 = rgb(30, 35, 30)
	refreshGift.BorderSizePixel = 0
	refreshGift.Position = UDim2.fromOffset(0, 232)
	refreshGift.Size = UDim2.new(1, 0, 0, 34)
	refreshGift.Parent = giftContent
	corner(refreshGift, 4)
	refreshGift.MouseButton1Click:Connect(function()
		state.giftUsername = usernameInput.Text:match("^%s*(.-)%s*$") or ""
		refreshGiftItemChoices()
	end)

	local function makeGiftInput(name, y, titleText, descriptionText, value, commit)
		local row = makeRow(name .. "Row", y, 48, titleText, descriptionText, giftContent)
		local input = Instance.new("TextBox")
		input.Name = name .. "Input"
		input.ClearTextOnFocus = false
		input.Text = tostring(value)
		input.Font = Enum.Font.GothamBold
		input.TextSize = 11
		input.TextColor3 = palette.text
		input.TextXAlignment = Enum.TextXAlignment.Left
		input.BackgroundColor3 = rgb(31, 26, 43)
		input.BorderSizePixel = 0
		input.Position = UDim2.new(0.64, 0, 0, 9)
		input.Size = UDim2.new(0.36, -7, 0, 30)
		input.Parent = row
		corner(input, 4)
		stroke(input, rgb(72, 48, 96), 0.35, 1)
		padding(input, 8, 0, 8, 0)
		input.FocusLost:Connect(function() input.Text = tostring(commit(input.Text)) end)
		return input
	end
	local amountInput = makeGiftInput("GiftAmount", 272, "Gift Amount", "How many matching items to gift per run.", state.giftAmount, function(text)
		state.giftAmount = math.clamp(math.floor(tonumber(text) or state.giftAmount), 1, 999)
		return state.giftAmount
	end)
	local giftDelayInput = makeGiftInput("GiftDelay", 326, "Gift Delay", "Wait time between gifts.", state.giftDelay, function(text)
		state.giftDelay = math.clamp(tonumber(text) or state.giftDelay, 0.2, 60)
		return state.giftDelay
	end)

	local function makeGiftToggle(name, y, titleText, descriptionText, getValue, setValue, toggleParent)
		local row = makeRow(name .. "Row", y, 48, titleText, descriptionText, toggleParent or giftContent)
		local button = Instance.new("TextButton")
		button.Name = name
		button.AutoButtonColor = false
		button.Text = ""
		button.BackgroundColor3 = rgb(54, 52, 64)
		button.BorderSizePixel = 0
		button.Position = UDim2.new(1, -49, 0.5, -11)
		button.Size = UDim2.fromOffset(40, 22)
		button.Parent = row
		corner(button, 11)
		stroke(button, rgb(113, 55, 149), 0.25, 1)
		local thumb = Instance.new("Frame")
		thumb.BackgroundColor3 = rgb(245, 245, 247)
		thumb.BorderSizePixel = 0
		thumb.Size = UDim2.fromOffset(16, 16)
		thumb.Parent = button
		corner(thumb, 8)
		local function render(animated)
			local active = getValue()
			local properties = {Position = UDim2.fromOffset(active and 21 or 3, 3)}
			button.BackgroundColor3 = active and palette.accent or rgb(54, 52, 64)
			if animated then TweenService:Create(thumb, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play() else thumb.Position = properties.Position end
		end
		button.MouseButton1Click:Connect(function() setValue(not getValue()); render(true) end)
		render(false)
		return button
	end

	local function findGiftTarget()
		local wanted = string.lower(state.giftUsername:match("^%s*(.-)%s*$") or "")
		if wanted == "" then return nil end
		for _, candidate in ipairs(game:GetService("Players"):GetPlayers()) do
			if candidate ~= player and (string.lower(candidate.Name) == wanted or string.lower(candidate.DisplayName) == wanted) then return candidate end
		end
		return nil
	end
	local function commitGiftInputs()
		state.giftUsername = usernameInput.Text:match("^%s*(.-)%s*$") or ""
		state.giftAmount = math.clamp(math.floor(tonumber(amountInput.Text) or state.giftAmount), 1, 999)
		state.giftDelay = math.clamp(tonumber(giftDelayInput.Text) or state.giftDelay, 0.2, 60)
		amountInput.Text = tostring(state.giftAmount)
		giftDelayInput.Text = tostring(state.giftDelay)
	end
	local function startGiftLoop()
		state.giftRunId += 1
		local runId = state.giftRunId
		task.spawn(function()
			while state.giftEnabled and state.giftRunId == runId and autoPlantGeneration == runtime.YupisotesGeneration do
				local target = findGiftTarget()
				if not target then
					screenGui:SetAttribute("AutoGiftStatus", "Player not found")
					task.wait(1)
					continue
				end
				local tools = matchingGiftTools()
				if #tools == 0 then
					screenGui:SetAttribute("AutoGiftStatus", "No matching gift items")
					task.wait(1)
					continue
				end
				local sent = 0
				for _, entry in ipairs(tools) do
					if not state.giftEnabled or state.giftRunId ~= runId or sent >= state.giftAmount then break end
					local character = player.Character
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")
					local root = character and character:FindFirstChild("HumanoidRootPart")
					local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
					if humanoid and root and targetRoot and entry.tool.Parent then
						local original = root.CFrame
						humanoid:EquipTool(entry.tool)
						root.CFrame = targetRoot.CFrame * CFrame.new(2.5, 0, 0)
						task.wait(0.1)
						local id = entry.tool:GetAttribute("Id")
						local rawValue = entry.tool:GetAttribute(entry.kind.attribute)
						local uuid = type(id) == "string" and id or type(rawValue) == "string" and rawValue or entry.tool.Name
						local ok = pcall(function() networking.Gifting.Send:Fire(target.UserId, entry.kind.remoteType, uuid) end)
						root.CFrame = original
						if ok then sent += 1 end
						screenGui:SetAttribute("AutoGiftStatus", ok and ("Sent " .. sent .. " gift(s) to " .. target.Name) or "Gift request failed")
						task.wait(state.giftDelay)
					end
				end
				if sent == 0 then task.wait(0.75) end
			end
		end)
	end
	makeGiftToggle("StartAutoGift", 380, "Start Auto Gift", "Automatically gifts selected items to the player.", function() return state.giftEnabled end, function(value)
		commitGiftInputs()
		state.giftEnabled = value
		screenGui:SetAttribute("AutoGiftEnabled", value)
		if value then startGiftLoop() else state.giftRunId += 1; screenGui:SetAttribute("AutoGiftStatus", "Stopped") end
	end)
	local function setAutoAccept(value)
		state.autoAcceptGift = value
		screenGui:SetAttribute("AutoAcceptGiftEnabled", value)
		if state.giftAcceptConnection then state.giftAcceptConnection:Disconnect(); state.giftAcceptConnection = nil end
		if value then
			local generation = autoPlantGeneration
			state.giftAcceptConnection = networking.Gifting.Prompted.OnClientEvent:Connect(function(sender)
				if not state.autoAcceptGift or generation ~= runtime.YupisotesGeneration then return end
				task.delay(0.1, function()
					local giftingGui = playerGui:FindFirstChild("Gifting")
					local notification = giftingGui and giftingGui:FindFirstChild("Notification")
					local buttons = notification and notification:FindFirstChild("Buttons")
					local accept = buttons and buttons:FindFirstChild("AcceptButton")
					if accept and firesignal then
						firesignal(accept.Activated)
					else
						pcall(function() networking.Gifting.Response:Fire(sender, true) end)
					end
					screenGui:SetAttribute("AutoAcceptGiftStatus", "Accepted gift from " .. sender.Name)
				end)
			end)
		end
	end
	makeGiftToggle("AutoAcceptGift", 434, "Auto Accept Gift", "Automatically accepts incoming gift prompts.", function() return state.autoAcceptGift end, setAutoAccept)
	if state.autoAcceptGift and not state.giftAcceptConnection then setAutoAccept(true) end
	giftHeader.MouseButton1Click:Connect(function()
		state.giftCategoryOpen = not state.giftCategoryOpen
		if not state.giftCategoryOpen then closeDropdown() end
		TweenService:Create(giftContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.giftCategoryOpen and 482 or 0)}):Play()
		TweenService:Create(giftArrow, TweenInfo.new(0.18), {Rotation = state.giftCategoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("AutoGiftEnabled", state.giftEnabled)
	screenGui:SetAttribute("AutoGiftStatus", state.giftEnabled and "Running" or "Stopped")
	screenGui:SetAttribute("AutoAcceptGiftEnabled", state.autoAcceptGift)
	if state.giftEnabled then startGiftLoop() end

	local mailboxCategories = {
		Pets = "Pets",
		Sprinklers = "Sprinklers",
		["Watering Cans"] = "WateringCans",
		Mushrooms = "Mushrooms",
		Gnomes = "Gnomes",
		Raccoons = "Raccoons",
		Crates = "Crates",
		["Seed Packs"] = "SeedPacks",
		Trowels = "Trowels",
		Props = "Props",
		Seeds = "Seeds",
		Fruits = "HarvestedFruits",
		["Empty Pots"] = "EmptyPots",
	}
	local mailboxCategoryChoices = {"Pets", "Sprinklers", "Watering Cans", "Mushrooms", "Gnomes", "Raccoons", "Crates", "Seed Packs", "Trowels", "Props", "Seeds", "Fruits", "Empty Pots"}
	local playerStateClient = require(ReplicatedStorage.ClientModules:WaitForChild("PlayerStateClient"))
	local mailboxCatalog
	pcall(function()
		local controller = player.PlayerScripts.Controllers:WaitForChild("MailboxController")
		mailboxCatalog = require(controller:WaitForChild("MailboxItemCatalog"))
	end)
	local equippedPetIds = {}
	pcall(function()
		local equipped = networking.Pets.GetEquippedPets:Fire()
		if typeof(equipped) == "table" then
			for _, pet in ipairs(equipped) do if typeof(pet) == "table" and typeof(pet.Id) == "string" then equippedPetIds[pet.Id] = true end end
		end
	end)
	local function mailboxInventory()
		local replica = playerStateClient:GetLocalReplica()
		return replica and replica.Data and replica.Data.Inventory or {}
	end
	local function mailboxDisplay(category, itemKey, payload)
		if mailboxCatalog then
			local ok, display = pcall(mailboxCatalog.Resolve, category, itemKey, payload)
			if ok and type(display) == "string" and display ~= "" then return display end
		end
		if category == "Pets" and typeof(payload) == "table" then return tostring(payload.Name or itemKey) end
		if category == "HarvestedFruits" and typeof(payload) == "table" then return tostring(payload.FruitName or payload.Name or itemKey) end
		return tostring(itemKey)
	end
	local function mailboxRarity(category, itemKey, payload, display)
		if category == "Seeds" then return seedRarities[tostring(itemKey):gsub(" Seed$", "")] or "Common" end
		if category == "HarvestedFruits" then
			local fruitName = typeof(payload) == "table" and (payload.FruitName or payload.Name) or itemKey
			return seedRarities[fruitName] or "Common"
		end
		if typeof(payload) == "table" and type(payload.Rarity) == "string" then return payload.Rarity end
		if mailboxCatalog then
			local ok, rarity = pcall(mailboxCatalog.ResolveRarity, category, itemKey)
			if ok and type(rarity) == "string" and rarity ~= "" then return rarity end
		end
		for _, rarity in ipairs(rarityOptions) do
			if string.find(string.lower(display), string.lower(rarity), 1, true) then return rarity end
		end
		return "Common"
	end
	local function mailboxEntries(categoryName)
		local category = mailboxCategories[categoryName] or "Pets"
		local source = mailboxInventory()[category]
		local entries = {}
		if typeof(source) ~= "table" then return entries end
		for itemKey, payload in pairs(source) do
			local available = 0
			if category == "Pets" or category == "HarvestedFruits" then
				local blocked = category == "Pets" and (equippedPetIds[itemKey] or (typeof(payload) == "table" and payload.Equipped == true))
				if typeof(payload) == "table" and payload.Id ~= nil and not blocked then available = 1 end
			elseif type(payload) == "number" and payload > 0 then
				available = payload
			end
			if available > 0 then
				local display = mailboxDisplay(category, itemKey, payload)
				table.insert(entries, {
					category = category,
					itemKey = itemKey,
					payload = payload,
					display = display,
					rarity = mailboxRarity(category, itemKey, payload, display),
					available = available,
				})
			end
		end
		table.sort(entries, function(a, b) return a.display < b.display end)
		return entries
	end
	local function collectMailItemChoices()
		local choices = {}
		for _, entry in ipairs(mailboxEntries(state.mailCategory)) do
			if not table.find(choices, entry.display) then table.insert(choices, entry.display) end
		end
		return choices
	end
	local mailItemChoices = collectMailItemChoices()
	for selected in pairs(state.mailItems) do if not table.find(mailItemChoices, selected) then state.mailItems[selected] = nil end end

	local mailHeader = Instance.new("TextButton")
	mailHeader.Name = "ManualMailboxHeader"
	mailHeader.AutoButtonColor = false
	mailHeader.Text = ""
	mailHeader.BackgroundColor3 = palette.card
	mailHeader.BorderSizePixel = 0
	mailHeader.Size = UDim2.new(1, 0, 0, 31)
	mailHeader.LayoutOrder = 4
	mailHeader.Parent = list
	corner(mailHeader, 4)
	local mailHeaderText = label(mailHeader, "Send Mailbox Manually", 13, palette.text, true)
	mailHeaderText.Position = UDim2.fromOffset(10, 0)
	mailHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local mailArrow = label(mailHeader, "v", 14, rgb(210, 210, 216), true)
	mailArrow.Position = UDim2.new(1, -28, 0, 0)
	mailArrow.Size = UDim2.fromOffset(20, 31)
	mailArrow.TextXAlignment = Enum.TextXAlignment.Center
	mailArrow.Rotation = state.mailCategoryOpen and 180 or 0
	local mailAccent = Instance.new("Frame")
	mailAccent.BackgroundColor3 = palette.accent
	mailAccent.BorderSizePixel = 0
	mailAccent.Position = UDim2.new(0, 0, 1, -2)
	mailAccent.Size = UDim2.new(1, 0, 0, 2)
	mailAccent.Parent = mailHeader
	local mailContent = Instance.new("Frame")
	mailContent.Name = "ManualMailboxContent"
	mailContent.BackgroundTransparency = 1
	mailContent.BorderSizePixel = 0
	mailContent.ClipsDescendants = true
	mailContent.Size = UDim2.new(1, 0, 0, state.mailCategoryOpen and 694 or 0)
	mailContent.LayoutOrder = 5
	mailContent.Parent = list

	makeRow("ManualMailInfo", 0, 58, "Manual Mail", "Use this only when you want to choose exact items. For simpler fruit value sending, use the section above.", mailContent)
	local receiverRow = makeRow("MailReceiverRow", 64, 52, "Receiver Username", "The player who will receive the mailbox gift.", mailContent)
	local receiverInput = Instance.new("TextBox")
	receiverInput.Name = "MailReceiverInput"
	receiverInput.ClearTextOnFocus = false
	receiverInput.PlaceholderText = "Input value"
	receiverInput.Text = state.mailReceiver
	receiverInput.Font = Enum.Font.GothamBold
	receiverInput.TextSize = 11
	receiverInput.TextColor3 = palette.text
	receiverInput.PlaceholderColor3 = palette.muted
	receiverInput.TextXAlignment = Enum.TextXAlignment.Left
	receiverInput.BackgroundColor3 = rgb(31, 26, 43)
	receiverInput.BorderSizePixel = 0
	receiverInput.Position = UDim2.new(0.62, 0, 0, 10)
	receiverInput.Size = UDim2.new(0.38, -7, 0, 32)
	receiverInput.Parent = receiverRow
	corner(receiverInput, 4)
	stroke(receiverInput, rgb(72, 48, 96), 0.35, 1)
	padding(receiverInput, 10, 0, 8, 0)
	receiverInput.FocusLost:Connect(function() state.mailReceiver = receiverInput.Text:match("^%s*(.-)%s*$") or "" end)
	local mailItemsDropdown
	local function refreshMailItemChoices()
		local refreshedChoices = collectMailItemChoices()
		for selected in pairs(state.mailItems) do
			if not table.find(refreshedChoices, selected) then state.mailItems[selected] = nil end
		end
		if mailItemsDropdown then mailItemsDropdown.setChoices(refreshedChoices) end
	end
	makeDropdown("MailCategory", 122, "Select Category", "Pick the type of item you want to send.", mailboxCategoryChoices, {
		get = function() return state.mailCategory end,
		set = function(value)
			if state.mailCategory ~= value then
				state.mailCategory = value
				table.clear(state.mailItems)
			end
		end,
	}, false, 390, mailContent, refreshMailItemChoices)
	mailItemsDropdown = select(2, makeDropdown("MailItems", 180, "Select Items", "Choose exact items from the selected category.", mailItemChoices, state.mailItems, true, 380, mailContent))
	makeDropdown("MailRarity", 238, "Filter by Rarity", "Optional. Leave empty if you do not care about rarity.", rarityOptions, state.mailRarities, true, 370, mailContent)
	local refreshMail = Instance.new("TextButton")
	refreshMail.Name = "RefreshMailboxItems"
	refreshMail.AutoButtonColor = true
	refreshMail.Text = "Refresh Item List"
	refreshMail.Font = Enum.Font.GothamBold
	refreshMail.TextSize = 11
	refreshMail.TextColor3 = palette.text
	refreshMail.BackgroundColor3 = rgb(30, 35, 30)
	refreshMail.BorderSizePixel = 0
	refreshMail.Position = UDim2.fromOffset(0, 296)
	refreshMail.Size = UDim2.new(1, 0, 0, 34)
	refreshMail.Parent = mailContent
	corner(refreshMail, 4)
	refreshMail.MouseButton1Click:Connect(function()
		state.mailReceiver = receiverInput.Text:match("^%s*(.-)%s*$") or ""
		refreshMailItemChoices()
	end)

	local function makeMailInput(name, y, titleText, descriptionText, value, commit)
		local row = makeRow(name .. "Row", y, 48, titleText, descriptionText, mailContent)
		local input = Instance.new("TextBox")
		input.Name = name .. "Input"
		input.ClearTextOnFocus = false
		input.Text = tostring(value)
		input.Font = Enum.Font.GothamBold
		input.TextSize = 11
		input.TextColor3 = palette.text
		input.TextXAlignment = Enum.TextXAlignment.Left
		input.BackgroundColor3 = rgb(31, 26, 43)
		input.BorderSizePixel = 0
		input.Position = UDim2.new(0.64, 0, 0, 9)
		input.Size = UDim2.new(0.36, -7, 0, 30)
		input.Parent = row
		corner(input, 4)
		stroke(input, rgb(72, 48, 96), 0.35, 1)
		padding(input, 8, 0, 8, 0)
		input.FocusLost:Connect(function() input.Text = tostring(commit(input.Text)) end)
		return input
	end
	local mailAmountInput = makeMailInput("MailAmount", 336, "Amount per Item", "How many of each selected item to send.", state.mailAmount, function(text)
		state.mailAmount = math.clamp(math.floor(tonumber(text) or state.mailAmount), 1, 20)
		return state.mailAmount
	end)
	local mailNoteInput = makeMailInput("MailNote", 390, "Mail Note", "Optional message attached to the mail.", state.mailNote, function(text)
		state.mailNote = string.sub(text, 1, 100)
		return state.mailNote
	end)
	local mailDelayInput = makeMailInput("MailDelay", 444, "Send Delay", "Seconds to wait between mailbox batches.", state.mailDelay, function(text)
		state.mailDelay = math.clamp(tonumber(text) or state.mailDelay, 1.5, 3600)
		return state.mailDelay
	end)
	local sendMailButton = Instance.new("TextButton")
	sendMailButton.Name = "SendSelectedMailboxItems"
	sendMailButton.AutoButtonColor = true
	sendMailButton.Text = "Send Selected Items"
	sendMailButton.Font = Enum.Font.GothamBold
	sendMailButton.TextSize = 11
	sendMailButton.TextColor3 = palette.text
	sendMailButton.BackgroundColor3 = rgb(35, 32, 31)
	sendMailButton.BorderSizePixel = 0
	sendMailButton.Position = UDim2.fromOffset(0, 498)
	sendMailButton.Size = UDim2.new(1, 0, 0, 34)
	sendMailButton.Parent = mailContent
	corner(sendMailButton, 4)

	local function commitMailInputs()
		state.mailReceiver = receiverInput.Text:match("^%s*(.-)%s*$") or ""
		state.mailAmount = math.clamp(math.floor(tonumber(mailAmountInput.Text) or state.mailAmount), 1, 20)
		state.mailNote = string.sub(mailNoteInput.Text, 1, 100)
		state.mailDelay = math.clamp(tonumber(mailDelayInput.Text) or state.mailDelay, 1.5, 3600)
		mailAmountInput.Text = tostring(state.mailAmount)
		mailNoteInput.Text = state.mailNote
		mailDelayInput.Text = tostring(state.mailDelay)
	end
	local function resolveMailReceiver()
		local name = state.mailReceiver:match("^%s*(.-)%s*$") or ""
		if name == "" then return nil, "Enter a receiver username" end
		for _, candidate in ipairs(game:GetService("Players"):GetPlayers()) do
			if string.lower(candidate.Name) == string.lower(name) then
				if candidate == player then return nil, "You cannot mail yourself" end
				return candidate.UserId
			end
		end
		local ok, userId = pcall(function() return game:GetService("Players"):GetUserIdFromNameAsync(name) end)
		if not ok or not userId then return nil, "Username not found" end
		if userId == player.UserId then return nil, "You cannot mail yourself" end
		return userId
	end
	local function buildMailboxBatch(sendAll)
		local batch = {}
		local perDisplay = {}
		local total = 0
		local hasItems = next(state.mailItems) ~= nil
		local hasRarities = next(state.mailRarities) ~= nil
		local categoriesToScan = sendAll and mailboxCategoryChoices or {state.mailCategory}
		for _, categoryName in ipairs(categoriesToScan) do
			for _, entry in ipairs(mailboxEntries(categoryName)) do
				local itemMatches = sendAll or (hasItems and state.mailItems[entry.display] == true)
				local rarityMatches = sendAll or not hasRarities or state.mailRarities[entry.rarity] == true
				if itemMatches and rarityMatches then
					local displayKey = entry.category .. ":" .. entry.display
					local used = perDisplay[displayKey] or 0
					local requested = sendAll and entry.available or math.max(0, state.mailAmount - used)
					local count = math.min(entry.available, requested, 20 - total)
					if entry.category == "Pets" or entry.category == "HarvestedFruits" then count = math.min(count, 1) end
					if count > 0 then
						table.insert(batch, {Category = entry.category, ItemKey = entry.itemKey, Count = count})
						perDisplay[displayKey] = used + count
						total += count
					end
				end
				if total >= 20 then break end
			end
			if total >= 20 then break end
		end
		return batch
	end
	local function sendMailboxBatch(sendAll)
		if state.mailSending then return false end
		commitMailInputs()
		local userId, receiverError = resolveMailReceiver()
		if not userId then screenGui:SetAttribute("MailboxStatus", receiverError); return false end
		local batch = buildMailboxBatch(sendAll)
		if #batch == 0 then screenGui:SetAttribute("MailboxStatus", sendAll and "Inventory has no giftable items" or "Select matching items"); return false end
		state.mailSending = true
		local ok, accepted, message = pcall(function() return networking.Mailbox.SendBatch:Fire(userId, batch, state.mailNote) end)
		state.mailSending = false
		if ok and accepted then
			screenGui:SetAttribute("MailboxStatus", (type(message) == "string" and message ~= "") and message or "Mailbox gift sent")
			return true
		end
		screenGui:SetAttribute("MailboxStatus", (ok and type(message) == "string" and message ~= "") and message or "Mailbox send failed")
		return false
	end
	sendMailButton.MouseButton1Click:Connect(function() task.spawn(sendMailboxBatch, false) end)

	local function startMailboxSendLoop(sendAll)
		local enabledKey = sendAll and "mailAllEnabled" or "mailSelectedEnabled"
		local runKey = sendAll and "mailAllRunId" or "mailSelectedRunId"
		state[runKey] += 1
		local runId = state[runKey]
		task.spawn(function()
			while state[enabledKey] and state[runKey] == runId and autoPlantGeneration == runtime.YupisotesGeneration do
				sendMailboxBatch(sendAll)
				task.wait(state.mailDelay)
			end
		end)
	end
	makeGiftToggle("StartSendSelectedItems", 538, "Start Send Selected Items", "Loop selected item sending using the configured delay.", function() return state.mailSelectedEnabled end, function(value)
		commitMailInputs()
		state.mailSelectedEnabled = value
		if value then startMailboxSendLoop(false) else state.mailSelectedRunId += 1 end
		screenGui:SetAttribute("MailboxSelectedEnabled", value)
	end, mailContent)
	makeGiftToggle("StartSendAllInventory", 592, "Start Send All Inventory", "Loop all-inventory sending using the configured delay. Use carefully.", function() return state.mailAllEnabled end, function(value)
		commitMailInputs()
		state.mailAllEnabled = value
		if value then startMailboxSendLoop(true) else state.mailAllRunId += 1 end
		screenGui:SetAttribute("MailboxAllEnabled", value)
	end, mailContent)
	local function claimMailboxOnce()
		local ok, inbox = pcall(function() return networking.Mailbox.OpenInbox:Fire() end)
		if not ok or typeof(inbox) ~= "table" then screenGui:SetAttribute("MailboxClaimStatus", "Could not open inbox"); return 0 end
		local claimed = 0
		for giftId in pairs(inbox) do
			if not state.mailClaimEnabled then break end
			local success, accepted = pcall(function() return networking.Mailbox.Claim:Fire(giftId) end)
			if success and accepted then claimed += 1 end
			task.wait(0.2)
		end
		screenGui:SetAttribute("MailboxClaimStatus", claimed > 0 and ("Claimed " .. claimed .. " mailbox gift(s)") or "No mailbox gifts")
		return claimed
	end
	local function startClaimLoop()
		state.mailClaimRunId += 1
		local runId = state.mailClaimRunId
		task.spawn(function()
			while state.mailClaimEnabled and state.mailClaimRunId == runId and autoPlantGeneration == runtime.YupisotesGeneration do
				claimMailboxOnce()
				task.wait(2)
			end
		end)
	end
	makeGiftToggle("AutoClaimMailbox", 646, "Auto Claim Mailbox", "Automatically claims incoming mailbox gifts.", function() return state.mailClaimEnabled end, function(value)
		state.mailClaimEnabled = value
		if value then startClaimLoop() else state.mailClaimRunId += 1 end
		screenGui:SetAttribute("MailboxClaimEnabled", value)
	end, mailContent)
	mailHeader.MouseButton1Click:Connect(function()
		state.mailCategoryOpen = not state.mailCategoryOpen
		if not state.mailCategoryOpen then closeDropdown() end
		TweenService:Create(mailContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.mailCategoryOpen and 694 or 0)}):Play()
		TweenService:Create(mailArrow, TweenInfo.new(0.18), {Rotation = state.mailCategoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("MailboxSelectedEnabled", state.mailSelectedEnabled)
	screenGui:SetAttribute("MailboxAllEnabled", state.mailAllEnabled)
	screenGui:SetAttribute("MailboxClaimEnabled", state.mailClaimEnabled)
	screenGui:SetAttribute("MailboxStatus", "Ready")
	if state.mailSelectedEnabled then startMailboxSendLoop(false) end
	if state.mailAllEnabled then startMailboxSendLoop(true) end
	if state.mailClaimEnabled then startClaimLoop() end

	local autoExecHeader = Instance.new("TextButton")
	autoExecHeader.Name = "AutoExecHeader"
	autoExecHeader.AutoButtonColor = false
	autoExecHeader.Text = ""
	autoExecHeader.BackgroundColor3 = palette.card
	autoExecHeader.BorderSizePixel = 0
	autoExecHeader.Size = UDim2.new(1, 0, 0, 31)
	autoExecHeader.LayoutOrder = 6
	autoExecHeader.Parent = list
	corner(autoExecHeader, 4)
	local autoExecHeaderText = label(autoExecHeader, "Auto Exec", 13, palette.text, true)
	autoExecHeaderText.Position = UDim2.fromOffset(10, 0)
	autoExecHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local autoExecArrow = label(autoExecHeader, "v", 14, rgb(210, 210, 216), true)
	autoExecArrow.Position = UDim2.new(1, -28, 0, 0)
	autoExecArrow.Size = UDim2.fromOffset(20, 31)
	autoExecArrow.TextXAlignment = Enum.TextXAlignment.Center
	autoExecArrow.Rotation = state.autoExecCategoryOpen and 180 or 0
	local autoExecAccent = Instance.new("Frame")
	autoExecAccent.BackgroundColor3 = palette.accent
	autoExecAccent.BorderSizePixel = 0
	autoExecAccent.Position = UDim2.new(0, 0, 1, -2)
	autoExecAccent.Size = UDim2.new(1, 0, 0, 2)
	autoExecAccent.Parent = autoExecHeader

	local autoExecContent = Instance.new("Frame")
	autoExecContent.Name = "AutoExecContent"
	autoExecContent.BackgroundTransparency = 1
	autoExecContent.BorderSizePixel = 0
	autoExecContent.ClipsDescendants = true
	autoExecContent.Size = UDim2.new(1, 0, 0, state.autoExecCategoryOpen and 96 or 0)
	autoExecContent.LayoutOrder = 7
	autoExecContent.Parent = list

	local teleportService = game:GetService("TeleportService")
	local guiService = game:GetService("GuiService")
	local function rejoinCurrentServer(source)
		if state.reconnectInProgress then return false end
		state.reconnectInProgress = true
		screenGui:SetAttribute("AutoReconnectStatus", source == "disconnect" and "Reconnecting" or "Rejoining")
		local ok = pcall(function()
			if game.JobId ~= "" then
				teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
			else
				teleportService:Teleport(game.PlaceId, player)
			end
		end)
		if not ok then
			state.reconnectInProgress = false
			screenGui:SetAttribute("AutoReconnectStatus", "Rejoin failed")
		end
		return ok
	end
	local function disconnectReconnectListeners()
		if state.reconnectConnections then
			for _, connection in ipairs(state.reconnectConnections) do pcall(function() connection:Disconnect() end) end
		end
		state.reconnectConnections = nil
	end
	local function beginAutoReconnect()
		disconnectReconnectListeners()
		if not state.autoReconnect then return end
		state.reconnectConnections = {}
		local generation = autoPlantGeneration
		local function onDisconnected()
			if not state.autoReconnect or generation ~= runtime.YupisotesGeneration then return end
			task.delay(1, function()
				if state.autoReconnect and generation == runtime.YupisotesGeneration then rejoinCurrentServer("disconnect") end
			end)
		end
		pcall(function()
			table.insert(state.reconnectConnections, guiService.ErrorMessageChanged:Connect(function(message)
				if type(message) == "string" and message ~= "" then onDisconnected() end
			end))
		end)
		pcall(function()
			local coreGui = game:GetService("CoreGui")
			local promptGui = coreGui:WaitForChild("RobloxPromptGui", 3)
			local overlay = promptGui and promptGui:WaitForChild("promptOverlay", 3)
			if overlay then
				table.insert(state.reconnectConnections, overlay.ChildAdded:Connect(function(child)
					if child.Name == "ErrorPrompt" then onDisconnected() end
				end))
			end
		end)
		screenGui:SetAttribute("AutoReconnectStatus", "Watching current server")
	end
	makeGiftToggle("AutoReconnect", 0, "Auto Reconnect", "Rejoin automatically when you get disconnected. (private server only)", function() return state.autoReconnect end, function(value)
		state.autoReconnect = value
		state.reconnectInProgress = false
		screenGui:SetAttribute("AutoReconnectEnabled", value)
		if value then beginAutoReconnect() else disconnectReconnectListeners(); screenGui:SetAttribute("AutoReconnectStatus", "Stopped") end
	end, autoExecContent)
	local rejoinButton = Instance.new("TextButton")
	rejoinButton.Name = "RejoinServer"
	rejoinButton.AutoButtonColor = true
	rejoinButton.Text = "Rejoin Server"
	rejoinButton.Font = Enum.Font.GothamBold
	rejoinButton.TextSize = 11
	rejoinButton.TextColor3 = palette.text
	rejoinButton.BackgroundColor3 = rgb(35, 32, 31)
	rejoinButton.BorderSizePixel = 0
	rejoinButton.Position = UDim2.fromOffset(0, 54)
	rejoinButton.Size = UDim2.new(1, 0, 0, 36)
	rejoinButton.Parent = autoExecContent
	corner(rejoinButton, 4)
	rejoinButton.MouseButton1Click:Connect(function() rejoinCurrentServer("manual") end)
	autoExecHeader.MouseButton1Click:Connect(function()
		state.autoExecCategoryOpen = not state.autoExecCategoryOpen
		if not state.autoExecCategoryOpen then closeDropdown() end
		TweenService:Create(autoExecContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.autoExecCategoryOpen and 96 or 0)}):Play()
		TweenService:Create(autoExecArrow, TweenInfo.new(0.18), {Rotation = state.autoExecCategoryOpen and 180 or 0}):Play()
	end)
	if state.autoReconnect and not state.reconnectConnections then beginAutoReconnect() end
	screenGui:SetAttribute("AutoReconnectEnabled", state.autoReconnect)
	if not state.autoReconnect then screenGui:SetAttribute("AutoReconnectStatus", "Stopped") end

	local function rememberOverride(bucket, instance, property, value)
		if not instance or not instance.Parent then return end
		pcall(function()
			bucket[instance] = bucket[instance] or {}
			if bucket[instance][property] == nil then bucket[instance][property] = instance[property] end
			instance[property] = value
		end)
	end
	local function restoreOverrides(bucket)
		for instance, properties in pairs(bucket) do
			if typeof(instance) == "Instance" and instance.Parent then
				for property, value in pairs(properties) do pcall(function() instance[property] = value end) end
			end
			bucket[instance] = nil
		end
	end
	local function reduceVisual(instance)
		pcall(function()
			if instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Beam") or instance:IsA("Smoke") or instance:IsA("Fire") or instance:IsA("Sparkles") then
				rememberOverride(state.fpsOverrides, instance, "Enabled", false)
			elseif instance:IsA("PostEffect") then
				rememberOverride(state.fpsOverrides, instance, "Enabled", false)
			elseif instance:IsA("Decal") or instance:IsA("Texture") then
				rememberOverride(state.fpsOverrides, instance, "Transparency", 1)
			elseif instance:IsA("SurfaceAppearance") then
				rememberOverride(state.fpsOverrides, instance, "ColorMap", "")
				rememberOverride(state.fpsOverrides, instance, "MetalnessMap", "")
				rememberOverride(state.fpsOverrides, instance, "NormalMap", "")
				rememberOverride(state.fpsOverrides, instance, "RoughnessMap", "")
			elseif instance:IsA("SpecialMesh") then
				rememberOverride(state.fpsOverrides, instance, "TextureId", "")
			elseif instance:IsA("Atmosphere") then
				rememberOverride(state.fpsOverrides, instance, "Density", 0)
				rememberOverride(state.fpsOverrides, instance, "Haze", 0)
				rememberOverride(state.fpsOverrides, instance, "Glare", 0)
			elseif instance:IsA("Clouds") then
				rememberOverride(state.fpsOverrides, instance, "Cover", 0)
				rememberOverride(state.fpsOverrides, instance, "Density", 0)
			elseif instance:IsA("Sky") then
				rememberOverride(state.fpsOverrides, instance, "CelestialBodiesShown", false)
				rememberOverride(state.fpsOverrides, instance, "StarCount", 0)
			end
			if instance:IsA("BasePart") then
				rememberOverride(state.fpsOverrides, instance, "CastShadow", false)
				rememberOverride(state.fpsOverrides, instance, "Material", Enum.Material.SmoothPlastic)
				rememberOverride(state.fpsOverrides, instance, "Reflectance", 0)
			end
			if instance:IsA("MeshPart") then
				rememberOverride(state.fpsOverrides, instance, "TextureID", "")
			end
		end)
	end
	local function setBoostFps(value)
		state.boostFps = value
		state.boostRunId += 1
		if state.fpsConnection then state.fpsConnection:Disconnect(); state.fpsConnection = nil end
		if state.fpsLightingConnection then state.fpsLightingConnection:Disconnect(); state.fpsLightingConnection = nil end
		if value then
			local lighting = game:GetService("Lighting")
			rememberOverride(state.fpsOverrides, lighting, "GlobalShadows", false)
			rememberOverride(state.fpsOverrides, lighting, "EnvironmentDiffuseScale", 0)
			rememberOverride(state.fpsOverrides, lighting, "EnvironmentSpecularScale", 0)
			rememberOverride(state.fpsOverrides, lighting, "ShadowSoftness", 0)
			local terrain = workspace:FindFirstChildOfClass("Terrain")
			if terrain then
				rememberOverride(state.fpsOverrides, terrain, "WaterWaveSize", 0)
				rememberOverride(state.fpsOverrides, terrain, "WaterWaveSpeed", 0)
				rememberOverride(state.fpsOverrides, terrain, "WaterReflectance", 0)
				rememberOverride(state.fpsOverrides, terrain, "WaterTransparency", 1)
				rememberOverride(state.fpsOverrides, terrain, "Decoration", false)
			end
			if not state.originalQualityLevel then state.originalQualityLevel = settings().Rendering.QualityLevel end
			pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
			local generation = autoPlantGeneration
			local runId = state.boostRunId
			state.fpsConnection = workspace.DescendantAdded:Connect(function(instance)
				if state.boostFps and generation == runtime.YupisotesGeneration then reduceVisual(instance) end
			end)
			state.fpsLightingConnection = lighting.DescendantAdded:Connect(function(instance)
				if state.boostFps and generation == runtime.YupisotesGeneration then reduceVisual(instance) end
			end)
			screenGui:SetAttribute("BoostFpsStatus", "Applying ultra low graphics")
			task.spawn(function()
				local instances = workspace:GetDescendants()
				for index, instance in ipairs(instances) do
					if not state.boostFps or state.boostRunId ~= runId or generation ~= runtime.YupisotesGeneration then return end
					reduceVisual(instance)
					if index % 600 == 0 then task.wait() end
				end
				for _, instance in ipairs(lighting:GetDescendants()) do reduceVisual(instance) end
				screenGui:SetAttribute("BoostFpsStatus", "Ultra low graphics enabled")
			end)
		else
			restoreOverrides(state.fpsOverrides)
			if state.originalQualityLevel then pcall(function() settings().Rendering.QualityLevel = state.originalQualityLevel end) end
			state.originalQualityLevel = nil
			screenGui:SetAttribute("BoostFpsStatus", "Normal graphics")
		end
		screenGui:SetAttribute("BoostFpsEnabled", value)
	end
	local function shouldHidePlot(plot)
		local ownPlot = getPlayerPlot()
		if state.hidePlantScope == "All" then return true end
		if state.hidePlantScope == "Own" then return plot == ownPlot end
		return plot ~= ownPlot
	end
	local function hidePlantVisual(instance)
		pcall(function()
			if instance:IsA("BasePart") then
				rememberOverride(state.plantOverrides, instance, "LocalTransparencyModifier", 1)
			elseif instance:IsA("Decal") or instance:IsA("Texture") then
				rememberOverride(state.plantOverrides, instance, "Transparency", 1)
			elseif instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Beam") or instance:IsA("Smoke") or instance:IsA("Fire") or instance:IsA("Sparkles") then
				rememberOverride(state.plantOverrides, instance, "Enabled", false)
			elseif instance:IsA("BillboardGui") or instance:IsA("SurfaceGui") then
				rememberOverride(state.plantOverrides, instance, "Enabled", false)
			end
		end)
	end
	local function applyPlantHiding()
		restoreOverrides(state.plantOverrides)
		if not state.hidePlants then return end
		local gardens = workspace:FindFirstChild("Gardens")
		if not gardens then return end
		for _, plot in ipairs(gardens:GetChildren()) do
			local plants = plot:FindFirstChild("Plants")
			if plants and shouldHidePlot(plot) then
				for _, instance in ipairs(plants:GetDescendants()) do hidePlantVisual(instance) end
			end
		end
	end
	local function startHidePlantLoop()
		state.hidePlantRunId += 1
		if state.hidePlantConnection then state.hidePlantConnection:Disconnect(); state.hidePlantConnection = nil end
		local gardens = workspace:FindFirstChild("Gardens")
		if not gardens then return end
		local generation = autoPlantGeneration
		state.hidePlantConnection = gardens.DescendantAdded:Connect(function(instance)
			if not state.hidePlants or generation ~= runtime.YupisotesGeneration then return end
			local current = instance
			while current and current.Parent ~= gardens do current = current.Parent end
			local plot = current and current.Parent == gardens and current
			local plants = plot and plot:FindFirstChild("Plants")
			if plot and plants and instance:IsDescendantOf(plants) and shouldHidePlot(plot) then hidePlantVisual(instance) end
		end)
	end

	local performanceHeader = Instance.new("TextButton")
	performanceHeader.Name = "PerformanceHeader"
	performanceHeader.AutoButtonColor = false
	performanceHeader.Text = ""
	performanceHeader.BackgroundColor3 = palette.card
	performanceHeader.BorderSizePixel = 0
	performanceHeader.Size = UDim2.new(1, 0, 0, 31)
	performanceHeader.LayoutOrder = 8
	performanceHeader.Parent = list
	corner(performanceHeader, 4)
	local performanceHeaderText = label(performanceHeader, "Performance", 13, palette.text, true)
	performanceHeaderText.Position = UDim2.fromOffset(10, 0)
	performanceHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local performanceArrow = label(performanceHeader, "v", 14, rgb(210, 210, 216), true)
	performanceArrow.Position = UDim2.new(1, -28, 0, 0)
	performanceArrow.Size = UDim2.fromOffset(20, 31)
	performanceArrow.TextXAlignment = Enum.TextXAlignment.Center
	performanceArrow.Rotation = state.performanceCategoryOpen and 180 or 0
	local performanceAccent = Instance.new("Frame")
	performanceAccent.BackgroundColor3 = palette.accent
	performanceAccent.BorderSizePixel = 0
	performanceAccent.Position = UDim2.new(0, 0, 1, -2)
	performanceAccent.Size = UDim2.new(1, 0, 0, 2)
	performanceAccent.Parent = performanceHeader
	local performanceContent = Instance.new("Frame")
	performanceContent.Name = "PerformanceContent"
	performanceContent.BackgroundTransparency = 1
	performanceContent.BorderSizePixel = 0
	performanceContent.ClipsDescendants = true
	performanceContent.Size = UDim2.new(1, 0, 0, state.performanceCategoryOpen and 230 or 0)
	performanceContent.LayoutOrder = 9
	performanceContent.Parent = list
	makeGiftToggle("BoostFPS", 0, "Boost FPS", "Low graphics mode for smoother gameplay.", function() return state.boostFps end, setBoostFps, performanceContent)
	makeDropdown("HidePlantScope", 54, "Hide Plant Scope", "Choose which gardens should have plant visuals hidden.", {"Own", "Other", "All"}, {
		get = function() return state.hidePlantScope end,
		set = function(value) state.hidePlantScope = value; applyPlantHiding(); screenGui:SetAttribute("HidePlantScope", value) end,
	}, false, 350, performanceContent)
	makeGiftToggle("HidePlant", 112, "Hide Plant", "Hide plant visuals only. Proximity prompts stay active.", function() return state.hidePlants end, function(value)
		state.hidePlants = value
		screenGui:SetAttribute("HidePlantEnabled", value)
		if value then
			applyPlantHiding()
			startHidePlantLoop()
		else
			state.hidePlantRunId += 1
			if state.hidePlantConnection then state.hidePlantConnection:Disconnect(); state.hidePlantConnection = nil end
			restoreOverrides(state.plantOverrides)
		end
	end, performanceContent)
	performanceHeader.MouseButton1Click:Connect(function()
		state.performanceCategoryOpen = not state.performanceCategoryOpen
		if not state.performanceCategoryOpen then closeDropdown() end
		TweenService:Create(performanceContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.performanceCategoryOpen and 230 or 0)}):Play()
		TweenService:Create(performanceArrow, TweenInfo.new(0.18), {Rotation = state.performanceCategoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("BoostFpsEnabled", state.boostFps)
	screenGui:SetAttribute("HidePlantScope", state.hidePlantScope)
	screenGui:SetAttribute("HidePlantEnabled", state.hidePlants)
	if state.boostFps then setBoostFps(true) end
	if state.hidePlants then
		applyPlantHiding()
		startHidePlantLoop()
	end

	local runService = game:GetService("RunService")
	local function getProtectionBase()
		local plot = getPlayerPlot()
		if not plot then return nil, 40 end
		local areas = getPlantAreas(plot)
		local area = areas[1]
		if area then
			return area.CFrame * CFrame.new(0, 5, 0), math.max(area.Size.X, area.Size.Z) * 0.7 + 12
		end
		return plot:GetPivot() * CFrame.new(0, 5, 0), 50
	end
	local function clearProtection()
		if state.protectionConnection then state.protectionConnection:Disconnect(); state.protectionConnection = nil end
		restoreOverrides(state.protectionOverrides)
		state.protectionBaseCFrame = nil
	end
	local function applyProtectionMethod()
		clearProtection()
		if not state.protectionEnabled then return end
		state.protectionRunId += 1
		local runId = state.protectionRunId
		local generation = autoPlantGeneration
		state.protectionBaseCFrame, state.protectionRadius = getProtectionBase()
		state.protectionConnection = runService.Heartbeat:Connect(function()
			if not state.protectionEnabled or state.protectionRunId ~= runId or generation ~= runtime.YupisotesGeneration then return end
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not root or not humanoid or humanoid.Health <= 0 then return end
			if state.antiFlingMethod == "Freeze" then
				rememberOverride(state.protectionOverrides, root, "Anchored", true)
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			elseif state.antiFlingMethod == "No Clip" then
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then rememberOverride(state.protectionOverrides, part, "CanCollide", false) end
				end
				if root.AssemblyLinearVelocity.Magnitude > 100 or root.AssemblyAngularVelocity.Magnitude > 100 then
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
				end
			else
				local baseCFrame, radius = getProtectionBase()
				state.protectionBaseCFrame = baseCFrame or state.protectionBaseCFrame
				state.protectionRadius = radius or state.protectionRadius
				if state.protectionBaseCFrame and (root.Position - state.protectionBaseCFrame.Position).Magnitude > (state.protectionRadius or 50) then
					root.CFrame = state.protectionBaseCFrame
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
				end
			end
		end)
		screenGui:SetAttribute("ProtectionStatus", state.antiFlingMethod .. " active")
	end

	local protectHeader = Instance.new("TextButton")
	protectHeader.Name = "AutoProtectHeader"
	protectHeader.AutoButtonColor = false
	protectHeader.Text = ""
	protectHeader.BackgroundColor3 = palette.card
	protectHeader.BorderSizePixel = 0
	protectHeader.Size = UDim2.new(1, 0, 0, 31)
	protectHeader.LayoutOrder = 10
	protectHeader.Parent = list
	corner(protectHeader, 4)
	local protectHeaderText = label(protectHeader, "Auto Protect", 13, palette.text, true)
	protectHeaderText.Position = UDim2.fromOffset(10, 0)
	protectHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local protectArrow = label(protectHeader, "v", 14, rgb(210, 210, 216), true)
	protectArrow.Position = UDim2.new(1, -28, 0, 0)
	protectArrow.Size = UDim2.fromOffset(20, 31)
	protectArrow.TextXAlignment = Enum.TextXAlignment.Center
	protectArrow.Rotation = state.autoProtectCategoryOpen and 180 or 0
	local protectAccent = Instance.new("Frame")
	protectAccent.BackgroundColor3 = palette.accent
	protectAccent.BorderSizePixel = 0
	protectAccent.Position = UDim2.new(0, 0, 1, -2)
	protectAccent.Size = UDim2.new(1, 0, 0, 2)
	protectAccent.Parent = protectHeader
	local protectContent = Instance.new("Frame")
	protectContent.Name = "AutoProtectContent"
	protectContent.BackgroundTransparency = 1
	protectContent.BorderSizePixel = 0
	protectContent.ClipsDescendants = true
	protectContent.Size = UDim2.new(1, 0, 0, state.autoProtectCategoryOpen and 178 or 0)
	protectContent.LayoutOrder = 11
	protectContent.Parent = list
	makeDropdown("AntiFlingMethod", 0, "Anti Fling Method", "Choose how base protection handles push and fling.", {"Freeze", "No Clip", "Stay Base"}, {
		get = function() return state.antiFlingMethod end,
		set = function(value)
			state.antiFlingMethod = value
			screenGui:SetAttribute("AntiFlingMethod", value)
			if state.protectionEnabled then applyProtectionMethod() end
		end,
	}, false, 340, protectContent)
	makeGiftToggle("StartProtectionBase", 58, "Start Protection Base", "Protects your base from push and fling trouble.", function() return state.protectionEnabled end, function(value)
		state.protectionEnabled = value
		screenGui:SetAttribute("ProtectionEnabled", value)
		if value then applyProtectionMethod() else state.protectionRunId += 1; clearProtection(); screenGui:SetAttribute("ProtectionStatus", "Stopped") end
	end, protectContent)
	protectHeader.MouseButton1Click:Connect(function()
		state.autoProtectCategoryOpen = not state.autoProtectCategoryOpen
		if not state.autoProtectCategoryOpen then closeDropdown() end
		TweenService:Create(protectContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.autoProtectCategoryOpen and 178 or 0)}):Play()
		TweenService:Create(protectArrow, TweenInfo.new(0.18), {Rotation = state.autoProtectCategoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("AntiFlingMethod", state.antiFlingMethod)
	screenGui:SetAttribute("ProtectionEnabled", state.protectionEnabled)
	if state.protectionEnabled then
		applyProtectionMethod()
	else
		screenGui:SetAttribute("ProtectionStatus", "Stopped")
	end

	local httpService = game:GetService("HttpService")
	local function getRequestFunction()
		if type(request) == "function" then return request end
		if type(http_request) == "function" then return http_request end
		if type(syn) == "table" and type(syn.request) == "function" then return syn.request end
		if type(http) == "table" and type(http.request) == "function" then return http.request end
		return nil
	end
	local function validWebhookUrl(url)
		return type(url) == "string" and (string.match(url, "^https://discord%.com/api/webhooks/") or string.match(url, "^https://discordapp%.com/api/webhooks/")) ~= nil
	end
	local function webhookMention()
		local id = state.webhookTagId:match("%d+")
		if state.webhookTagType == "Everyone" then return "@everyone" end
		if state.webhookTagType == "Here" then return "@here" end
		if state.webhookTagType == "User" and id then return "<@" .. id .. ">" end
		if state.webhookTagType == "Role" and id then return "<@&" .. id .. ">" end
		return ""
	end
	local function postWebhook(payload)
		if not validWebhookUrl(state.webhookUrl) then screenGui:SetAttribute("WebhookStockStatus", "Enter a valid Discord webhook URL"); return false end
		local requestFunction = getRequestFunction()
		if not requestFunction then screenGui:SetAttribute("WebhookStockStatus", "Executor does not support HTTP requests"); return false end
		local ok, response = pcall(requestFunction, {
			Url = state.webhookUrl,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = httpService:JSONEncode(payload),
		})
		local statusCode = ok and type(response) == "table" and (response.StatusCode or response.Status) or nil
		local accepted = ok and (statusCode == nil or (tonumber(statusCode) and tonumber(statusCode) >= 200 and tonumber(statusCode) < 300))
		screenGui:SetAttribute("WebhookStockStatus", accepted and "Webhook sent" or (statusCode == 429 and "Discord rate limited the webhook" or "Webhook request failed"))
		return accepted
	end
	local stockFolders = {
		Seed = ReplicatedStorage.StockValues:WaitForChild("SeedShop"),
		Gear = ReplicatedStorage.StockValues:WaitForChild("GearShop"),
		Crate = ReplicatedStorage.StockValues:WaitForChild("CrateShop"),
	}
	local function stockField(itemType)
		local folder = stockFolders[itemType]
		local items = folder and folder:FindFirstChild("Items")
		local lines = {}
		if items then
			local stocked = {}
			for _, value in ipairs(items:GetChildren()) do
				if value:IsA("NumberValue") and value.Value > 0 then table.insert(stocked, {name = value.Name, amount = value.Value}) end
			end
			table.sort(stocked, function(a, b)
				if a.amount == b.amount then return a.name < b.name end
				return a.amount > b.amount
			end)
			for _, entry in ipairs(stocked) do
				local line = "• **" .. entry.name .. "** x" .. tostring(entry.amount)
				if #table.concat(lines, "\n") + #line > 950 then table.insert(lines, "• …and more"); break end
				table.insert(lines, line)
			end
		end
		return {name = itemType .. " Stock", value = #lines > 0 and table.concat(lines, "\n") or "Out of stock", inline = false}
	end
	local function sendStockWebhook(testOnly)
		local fields = {}
		for _, itemType in ipairs({"Seed", "Gear", "Crate"}) do if state.webhookItems[itemType] then table.insert(fields, stockField(itemType)) end end
		if #fields == 0 then screenGui:SetAttribute("WebhookStockStatus", "Select at least one stock type"); return false end
		local mention = webhookMention()
		return postWebhook({
			content = mention,
			allowed_mentions = {parse = state.webhookTagType == "Everyone" and {"everyone"} or state.webhookTagType == "Here" and {"everyone"} or {}, users = state.webhookTagType == "User" and {state.webhookTagId:match("%d+")} or {}, roles = state.webhookTagType == "Role" and {state.webhookTagId:match("%d+")} or {}},
			embeds = {{
				title = testOnly and "Yupisotes Webhook Test" or "Yupisotes Stock Update",
				description = testOnly and "Your Discord webhook is configured correctly." or "A shop restock was detected.",
				color = 11141375,
				fields = fields,
				footer = {text = "Yupisotes • " .. player.Name},
				timestamp = DateTime.now():ToIsoDate(),
			}},
		})
	end
	local function stopWebhookMonitor()
		if state.webhookConnections then for _, connection in ipairs(state.webhookConnections) do pcall(function() connection:Disconnect() end) end end
		state.webhookConnections = nil
	end
	local function startWebhookMonitor()
		stopWebhookMonitor()
		if not state.webhookStockEnabled then return end
		state.webhookConnections = {}
		local generation = autoPlantGeneration
		local function scheduleUpdate()
			state.webhookDebounce += 1
			local debounce = state.webhookDebounce
			task.delay(1, function()
				if state.webhookStockEnabled and state.webhookDebounce == debounce and generation == runtime.YupisotesGeneration then sendStockWebhook(false) end
			end)
		end
		for _, folder in pairs(stockFolders) do
			table.insert(state.webhookConnections, folder.UnixLastRestock.Changed:Connect(scheduleUpdate))
		end
		task.spawn(sendStockWebhook, false)
	end

	local webhookHeader = Instance.new("TextButton")
	webhookHeader.Name = "WebhookStockHeader"
	webhookHeader.AutoButtonColor = false
	webhookHeader.Text = ""
	webhookHeader.BackgroundColor3 = palette.card
	webhookHeader.BorderSizePixel = 0
	webhookHeader.Size = UDim2.new(1, 0, 0, 31)
	webhookHeader.LayoutOrder = 12
	webhookHeader.Parent = list
	corner(webhookHeader, 4)
	local webhookHeaderText = label(webhookHeader, "Webhook Stock Controller", 13, palette.text, true)
	webhookHeaderText.Position = UDim2.fromOffset(10, 0)
	webhookHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local webhookArrow = label(webhookHeader, "v", 14, rgb(210, 210, 216), true)
	webhookArrow.Position = UDim2.new(1, -28, 0, 0)
	webhookArrow.Size = UDim2.fromOffset(20, 31)
	webhookArrow.TextXAlignment = Enum.TextXAlignment.Center
	webhookArrow.Rotation = state.webhookCategoryOpen and 180 or 0
	local webhookAccent = Instance.new("Frame")
	webhookAccent.BackgroundColor3 = palette.accent
	webhookAccent.BorderSizePixel = 0
	webhookAccent.Position = UDim2.new(0, 0, 1, -2)
	webhookAccent.Size = UDim2.new(1, 0, 0, 2)
	webhookAccent.Parent = webhookHeader
	local webhookContent = Instance.new("Frame")
	webhookContent.Name = "WebhookStockContent"
	webhookContent.BackgroundTransparency = 1
	webhookContent.BorderSizePixel = 0
	webhookContent.ClipsDescendants = true
	webhookContent.Size = UDim2.new(1, 0, 0, state.webhookCategoryOpen and 344 or 0)
	webhookContent.LayoutOrder = 13
	webhookContent.Parent = list
	makeDropdown("WebhookTagType", 0, "Tag Type", "Choose how the webhook should ping Discord.", {"None", "Everyone", "Here", "User", "Role"}, {
		get = function() return state.webhookTagType end,
		set = function(value) state.webhookTagType = value end,
	}, false, 330, webhookContent)

	local function makeWebhookInput(name, y, titleText, descriptionText, value, placeholder, secret)
		local row = makeRow(name .. "Row", y, 48, titleText, descriptionText, webhookContent)
		local input = Instance.new("TextBox")
		input.Name = name .. "Input"
		input.ClearTextOnFocus = false
		input.PlaceholderText = placeholder
		input.Text = value
		input.Font = Enum.Font.GothamBold
		input.TextSize = 11
		input.TextColor3 = palette.text
		input.PlaceholderColor3 = palette.muted
		input.TextXAlignment = Enum.TextXAlignment.Left
		input.BackgroundColor3 = rgb(31, 26, 43)
		input.BorderSizePixel = 0
		input.Position = UDim2.new(0.64, 0, 0, 9)
		input.Size = UDim2.new(0.36, -7, 0, 30)
		input.Parent = row
		input.TextTruncate = Enum.TextTruncate.AtEnd
		if secret then input.TextEditable = true end
		corner(input, 4)
		stroke(input, rgb(72, 48, 96), 0.35, 1)
		padding(input, 8, 0, 8, 0)
		return input
	end
	local tagIdInput = makeWebhookInput("WebhookTagId", 58, "Tag ID", "Paste the Discord user or role ID to ping.", state.webhookTagId, "Input value", false)
	local webhookUrlInput = makeWebhookInput("WebhookURL", 112, "Webhook URL", "Paste the Discord webhook link.", state.webhookUrl, "Input value", true)
	makeDropdown("WebhookSelectItem", 166, "Select Item", "Choose stock items to report.", {"Seed", "Gear", "Crate"}, state.webhookItems, true, 320, webhookContent)
	local function commitWebhookInputs()
		state.webhookTagId = tagIdInput.Text:match("^%s*(.-)%s*$") or ""
		state.webhookUrl = webhookUrlInput.Text:match("^%s*(.-)%s*$") or ""
	end
	tagIdInput.FocusLost:Connect(commitWebhookInputs)
	webhookUrlInput.FocusLost:Connect(commitWebhookInputs)
	local testWebhook = Instance.new("TextButton")
	testWebhook.Name = "SendWebhookTest"
	testWebhook.AutoButtonColor = true
	testWebhook.Text = "Send Webhook Test"
	testWebhook.Font = Enum.Font.GothamBold
	testWebhook.TextSize = 11
	testWebhook.TextColor3 = palette.text
	testWebhook.BackgroundColor3 = rgb(30, 35, 30)
	testWebhook.BorderSizePixel = 0
	testWebhook.Position = UDim2.fromOffset(0, 224)
	testWebhook.Size = UDim2.new(1, 0, 0, 34)
	testWebhook.Parent = webhookContent
	corner(testWebhook, 4)
	testWebhook.MouseButton1Click:Connect(function() commitWebhookInputs(); task.spawn(sendStockWebhook, true) end)
	makeGiftToggle("StartWebhookStock", 264, "Start Webhook Stock", "Sends stock updates to Discord automatically.", function() return state.webhookStockEnabled end, function(value)
		commitWebhookInputs()
		if value and not validWebhookUrl(state.webhookUrl) then state.webhookStockEnabled = false; screenGui:SetAttribute("WebhookStockStatus", "Enter a valid Discord webhook URL"); return end
		state.webhookStockEnabled = value
		screenGui:SetAttribute("WebhookStockEnabled", value)
		if value then startWebhookMonitor() else stopWebhookMonitor(); screenGui:SetAttribute("WebhookStockStatus", "Stopped") end
	end, webhookContent)
	webhookHeader.MouseButton1Click:Connect(function()
		state.webhookCategoryOpen = not state.webhookCategoryOpen
		if not state.webhookCategoryOpen then closeDropdown() end
		TweenService:Create(webhookContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.webhookCategoryOpen and 344 or 0)}):Play()
		TweenService:Create(webhookArrow, TweenInfo.new(0.18), {Rotation = state.webhookCategoryOpen and 180 or 0}):Play()
	end)
	if state.webhookStockEnabled and not state.webhookConnections then startWebhookMonitor() end
	screenGui:SetAttribute("WebhookStockEnabled", state.webhookStockEnabled)
	if not state.webhookStockEnabled then screenGui:SetAttribute("WebhookStockStatus", "Ready") end

	local utilityCatalog = {}
	local utilityRarityByName = {}
	local gearRarities = {}
	do
		local gearData = runtime.YupisotesGearShopData
		for _, entry in pairs(gearData.Data or gearData) do
			if type(entry) == "table" then
				local name = entry.ItemName or entry.Name or entry.GearName
				if type(name) == "string" then gearRarities[name] = entry.Rarity or "Common" end
			end
		end
	end
	local crateData = runtime.YupisotesCrateData
	for itemType, folder in pairs(stockFolders) do
		for _, stockValue in ipairs(folder.Items:GetChildren()) do
			if stockValue:IsA("NumberValue") then
				local rarity = "Common"
				if itemType == "Seed" then
					rarity = seedRarities[stockValue.Name] or "Common"
				elseif itemType == "Gear" then
					rarity = gearRarities[stockValue.Name] or "Common"
				elseif type(crateData.GetData) == "function" then
					local data = crateData.GetData(stockValue.Name)
					rarity = type(data) == "table" and data.Rarity or "Common"
				end
				table.insert(utilityCatalog, {name = stockValue.Name, itemType = itemType, rarity = rarity, value = stockValue})
				utilityRarityByName[stockValue.Name] = rarity
			end
		end
	end
	for key, data in pairs(petData) do
		if type(data) == "table" and type(data.Rarity) == "string" then
			local displayName = data.DisplayName or data.Name or tostring(key)
			table.insert(utilityCatalog, {name = displayName, itemType = "Pet", rarity = data.Rarity, value = nil})
			utilityRarityByName[displayName] = data.Rarity
		end
	end
	table.sort(utilityCatalog, function(a, b)
		if a.name == b.name then return a.itemType < b.itemType end
		return a.name < b.name
	end)
	local utilityItemChoices = {}
	local utilityTypesByName = {}
	for _, entry in ipairs(utilityCatalog) do
		if not table.find(utilityItemChoices, entry.name) then table.insert(utilityItemChoices, entry.name) end
		utilityTypesByName[entry.name] = utilityTypesByName[entry.name] or {}
		utilityTypesByName[entry.name][entry.itemType] = true
	end
	for selected in pairs(state.utilityItems) do if not table.find(utilityItemChoices, selected) then state.utilityItems[selected] = nil end end
	local function utilityMention()
		local id = state.utilityTagId:match("%d+")
		if state.utilityTagType == "Everyone" then return "@everyone" end
		if state.utilityTagType == "Here" then return "@here" end
		if state.utilityTagType == "User" and id then return "<@" .. id .. ">" end
		if state.utilityTagType == "Role" and id then return "<@&" .. id .. ">" end
		return ""
	end
	local function utilityAllowedMentions()
		local allowed = {parse = {}, users = {}, roles = {}}
		local id = state.utilityTagId:match("%d+")
		if state.utilityTagType == "Everyone" or state.utilityTagType == "Here" then allowed.parse = {"everyone"} end
		if state.utilityTagType == "User" and id then allowed.users = {id} end
		if state.utilityTagType == "Role" and id then allowed.roles = {id} end
		return allowed
	end
	local function utilityMatches(requireStock)
		local matches = {}
		local useRarity = next(state.utilityRarities) ~= nil
		for _, entry in ipairs(utilityCatalog) do
			local selected = useRarity and state.utilityRarities[entry.rarity] == true or not useRarity and state.utilityItems[entry.name] == true
			if state.utilityItemTypes[entry.itemType] and selected and (not requireStock or entry.value == nil or entry.value.Value > 0) then table.insert(matches, entry) end
		end
		return matches
	end
	local function postUtilityWebhook(payload)
		if not validWebhookUrl(state.utilityWebhookUrl) then screenGui:SetAttribute("UtilityWebhookStatus", "Enter a valid Discord webhook URL"); return false end
		local requestFunction = getRequestFunction()
		if not requestFunction then screenGui:SetAttribute("UtilityWebhookStatus", "Executor does not support HTTP requests"); return false end
		local ok, response = pcall(requestFunction, {
			Url = state.utilityWebhookUrl,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = httpService:JSONEncode(payload),
		})
		local statusCode = ok and type(response) == "table" and (response.StatusCode or response.Status) or nil
		local accepted = ok and (statusCode == nil or (tonumber(statusCode) and tonumber(statusCode) >= 200 and tonumber(statusCode) < 300))
		screenGui:SetAttribute("UtilityWebhookStatus", accepted and "Utility webhook sent" or (statusCode == 429 and "Discord rate limited the webhook" or "Utility webhook failed"))
		return accepted
	end
	local function sendUtilityWebhook(testOnly)
		local configured = utilityMatches(false)
		if #configured == 0 then screenGui:SetAttribute("UtilityWebhookStatus", "Select item names or rarities"); return false end
		local matches = utilityMatches(true)
		if not testOnly and #matches == 0 then screenGui:SetAttribute("UtilityWebhookStatus", "No matching utility stock"); return false end
		local grouped = {Pet = {}, Seed = {}, Gear = {}, Crate = {}}
		for _, entry in ipairs(matches) do
			local amountText = entry.value and (" x" .. tostring(entry.value.Value)) or ""
			table.insert(grouped[entry.itemType], "• **" .. entry.name .. "**" .. amountText .. " — " .. entry.rarity)
		end
		local fields = {}
		for _, itemType in ipairs({"Pet", "Seed", "Gear", "Crate"}) do
			if #grouped[itemType] > 0 then table.insert(fields, {name = itemType .. " Utility", value = table.concat(grouped[itemType], "\n"), inline = false}) end
		end
		if #fields == 0 then table.insert(fields, {name = "Configured Utility", value = "No selected utility is currently in stock.", inline = false}) end
		return postUtilityWebhook({
			content = utilityMention(),
			allowed_mentions = utilityAllowedMentions(),
			embeds = {{
				title = testOnly and "Yupisotes Utility Webhook Test" or "Yupisotes Utility Stock Alert",
				description = testOnly and "Your utility webhook is configured correctly." or "A selected item or rarity is available.",
				color = 11141375,
				fields = fields,
				footer = {text = "Yupisotes Utility • " .. player.Name},
				timestamp = DateTime.now():ToIsoDate(),
			}},
		})
	end
	local function stopUtilityWebhook()
		if state.utilityWebhookConnections then for _, connection in ipairs(state.utilityWebhookConnections) do pcall(function() connection:Disconnect() end) end end
		state.utilityWebhookConnections = nil
	end
	local function startUtilityWebhook()
		stopUtilityWebhook()
		if not state.utilityWebhookEnabled then return end
		state.utilityWebhookConnections = {}
		local generation = autoPlantGeneration
		local function scheduleUtilityAlert()
			state.utilityWebhookDebounce += 1
			local debounce = state.utilityWebhookDebounce
			task.delay(1, function()
				if state.utilityWebhookEnabled and state.utilityWebhookDebounce == debounce and generation == runtime.YupisotesGeneration then sendUtilityWebhook(false) end
			end)
		end
		for _, folder in pairs(stockFolders) do table.insert(state.utilityWebhookConnections, folder.UnixLastRestock.Changed:Connect(scheduleUtilityAlert)) end
		task.spawn(sendUtilityWebhook, false)
	end

	local utilityHeader = Instance.new("TextButton")
	utilityHeader.Name = "UtilityWebhookHeader"
	utilityHeader.AutoButtonColor = false
	utilityHeader.Text = ""
	utilityHeader.BackgroundColor3 = palette.card
	utilityHeader.BorderSizePixel = 0
	utilityHeader.Size = UDim2.new(1, 0, 0, 31)
	utilityHeader.LayoutOrder = 14
	utilityHeader.Parent = list
	corner(utilityHeader, 4)
	local utilityHeaderText = label(utilityHeader, "Webhook Stock (Utility) Controller", 13, palette.text, true)
	utilityHeaderText.Position = UDim2.fromOffset(10, 0)
	utilityHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local utilityArrow = label(utilityHeader, "v", 14, rgb(210, 210, 216), true)
	utilityArrow.Position = UDim2.new(1, -28, 0, 0)
	utilityArrow.Size = UDim2.fromOffset(20, 31)
	utilityArrow.TextXAlignment = Enum.TextXAlignment.Center
	utilityArrow.Rotation = state.utilityWebhookCategoryOpen and 180 or 0
	local utilityAccent = Instance.new("Frame")
	utilityAccent.BackgroundColor3 = palette.accent
	utilityAccent.BorderSizePixel = 0
	utilityAccent.Position = UDim2.new(0, 0, 1, -2)
	utilityAccent.Size = UDim2.new(1, 0, 0, 2)
	utilityAccent.Parent = utilityHeader
	local utilityContent = Instance.new("Frame")
	utilityContent.Name = "UtilityWebhookContent"
	utilityContent.BackgroundTransparency = 1
	utilityContent.BorderSizePixel = 0
	utilityContent.ClipsDescendants = true
	utilityContent.Size = UDim2.new(1, 0, 0, state.utilityWebhookCategoryOpen and 524 or 0)
	utilityContent.LayoutOrder = 15
	utilityContent.Parent = list
	makeDropdown("UtilityTagType", 0, "Tag Type (Utility)", "Choose how the utility webhook should ping Discord.", {"None", "Everyone", "Here", "User", "Role"}, {
		get = function() return state.utilityTagType end,
		set = function(value) state.utilityTagType = value end,
	}, false, 310, utilityContent)

	local function makeUtilityInput(name, y, titleText, descriptionText, value)
		local row = makeRow(name .. "Row", y, 48, titleText, descriptionText, utilityContent)
		local input = Instance.new("TextBox")
		input.Name = name .. "Input"
		input.ClearTextOnFocus = false
		input.PlaceholderText = "Input value"
		input.Text = value
		input.Font = Enum.Font.GothamBold
		input.TextSize = 11
		input.TextColor3 = palette.text
		input.PlaceholderColor3 = palette.muted
		input.TextXAlignment = Enum.TextXAlignment.Left
		input.TextTruncate = Enum.TextTruncate.AtEnd
		input.BackgroundColor3 = rgb(31, 26, 43)
		input.BorderSizePixel = 0
		input.Position = UDim2.new(0.64, 0, 0, 9)
		input.Size = UDim2.new(0.36, -7, 0, 30)
		input.Parent = row
		corner(input, 4)
		stroke(input, rgb(72, 48, 96), 0.35, 1)
		padding(input, 8, 0, 8, 0)
		return input
	end
	local utilityTagIdInput = makeUtilityInput("UtilityTagId", 58, "Input ID (Utility)", "Paste the Discord user or role ID to ping.", state.utilityTagId)
	local utilityUrlInput = makeUtilityInput("UtilityWebhookURL", 112, "Webhook URL (Utility)", "Paste the Discord webhook link.", state.utilityWebhookUrl)
	local utilityNamesDropdown
	makeDropdown("UtilitySelectItem", 166, "Select Item (Utility)", "Choose one or more utility alert types.", {"Pet", "Seed", "Gear", "Crate"}, state.utilityItemTypes, true, 300, utilityContent, function()
		for selectedName in pairs(state.utilityItems) do
			local allowed = false
			for itemType in pairs(utilityTypesByName[selectedName] or {}) do
				if state.utilityItemTypes[itemType] then allowed = true; break end
			end
			if not allowed then state.utilityItems[selectedName] = nil end
		end
		if utilityNamesDropdown then
			utilityNamesDropdown.refreshOptions()
			utilityNamesDropdown.refreshSummary()
			utilityNamesDropdown.renderOptions()
		end
	end)
	utilityNamesDropdown = select(2, makeDropdown("UtilitySelectNames", 224, "Select Name(s) (Utility)", "Choose names for the selected utility alert.", utilityItemChoices, state.utilityItems, true, 300, utilityContent, nil, function(choice)
		for itemType in pairs(utilityTypesByName[choice] or {}) do
			if state.utilityItemTypes[itemType] then return true end
		end
		return false
	end))
	local function commitUtilityInputs()
		state.utilityTagId = utilityTagIdInput.Text:match("^%s*(.-)%s*$") or ""
		state.utilityWebhookUrl = utilityUrlInput.Text:match("^%s*(.-)%s*$") or ""
	end
	utilityTagIdInput.FocusLost:Connect(commitUtilityInputs)
	utilityUrlInput.FocusLost:Connect(commitUtilityInputs)
	local refreshUtility = Instance.new("TextButton")
	refreshUtility.Name = "RefreshUtilityNames"
	refreshUtility.AutoButtonColor = true
	refreshUtility.Text = "Refresh Select Name(s) (Utility)"
	refreshUtility.Font = Enum.Font.GothamBold
	refreshUtility.TextSize = 11
	refreshUtility.TextColor3 = palette.text
	refreshUtility.BackgroundColor3 = rgb(30, 35, 30)
	refreshUtility.BorderSizePixel = 0
	refreshUtility.Position = UDim2.fromOffset(0, 282)
	refreshUtility.Size = UDim2.new(1, 0, 0, 34)
	refreshUtility.Parent = utilityContent
	corner(refreshUtility, 4)
	refreshUtility.MouseButton1Click:Connect(function()
		commitUtilityInputs()
		for selectedName in pairs(state.utilityItems) do
			if not table.find(utilityItemChoices, selectedName) then state.utilityItems[selectedName] = nil end
		end
		utilityNamesDropdown.setChoices(utilityItemChoices)
	end)
	makeDropdown("UtilityRarity", 322, "Rarity (Override Select Item & Name)", "Send alerts for this rarity instead of selected names.", rarityOptions, state.utilityRarities, true, 290, utilityContent)
	local testUtility = Instance.new("TextButton")
	testUtility.Name = "SendUtilityWebhookTest"
	testUtility.AutoButtonColor = true
	testUtility.Text = "Send Webhook Test (Utility)"
	testUtility.Font = Enum.Font.GothamBold
	testUtility.TextSize = 11
	testUtility.TextColor3 = palette.text
	testUtility.BackgroundColor3 = rgb(30, 35, 30)
	testUtility.BorderSizePixel = 0
	testUtility.Position = UDim2.fromOffset(0, 380)
	testUtility.Size = UDim2.new(1, 0, 0, 34)
	testUtility.Parent = utilityContent
	corner(testUtility, 4)
	testUtility.MouseButton1Click:Connect(function() commitUtilityInputs(); task.spawn(sendUtilityWebhook, true) end)
	makeGiftToggle("StartWebhookUtility", 420, "Start Webhook Utility", "Sends utility alerts to Discord automatically.", function() return state.utilityWebhookEnabled end, function(value)
		commitUtilityInputs()
		if value and not validWebhookUrl(state.utilityWebhookUrl) then state.utilityWebhookEnabled = false; screenGui:SetAttribute("UtilityWebhookStatus", "Enter a valid Discord webhook URL"); return end
		if value and #utilityMatches(false) == 0 then state.utilityWebhookEnabled = false; screenGui:SetAttribute("UtilityWebhookStatus", "Select item names or rarities"); return end
		state.utilityWebhookEnabled = value
		screenGui:SetAttribute("UtilityWebhookEnabled", value)
		if value then startUtilityWebhook() else stopUtilityWebhook(); screenGui:SetAttribute("UtilityWebhookStatus", "Stopped") end
	end, utilityContent)
	utilityHeader.MouseButton1Click:Connect(function()
		state.utilityWebhookCategoryOpen = not state.utilityWebhookCategoryOpen
		if not state.utilityWebhookCategoryOpen then closeDropdown() end
		TweenService:Create(utilityContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.utilityWebhookCategoryOpen and 524 or 0)}):Play()
		TweenService:Create(utilityArrow, TweenInfo.new(0.18), {Rotation = state.utilityWebhookCategoryOpen and 180 or 0}):Play()
	end)
	if state.utilityWebhookEnabled and not state.utilityWebhookConnections then startUtilityWebhook() end
	screenGui:SetAttribute("UtilityWebhookEnabled", state.utilityWebhookEnabled)
	if not state.utilityWebhookEnabled then screenGui:SetAttribute("UtilityWebhookStatus", "Ready") end
end
runtime.YupisotesShowVisual = function()
	local state = runtime.YupisotesVisualState
	currentPage = "Visual"
	dropdownOpen = false
	disconnectSection()
	section.Visible = false
	setActiveTab("Visual")
	title.Text = "Visual"
	section.Parent = content
	clearList()
	accentLine.Visible = false
	farmSectionAccent.Visible = false
	list.Position = UDim2.fromOffset(0, 34)
	list.Size = UDim2.new(1, -2, 1, -35)
	list.CanvasPosition = Vector2.zero

	local fruitValueCalc = require(ReplicatedStorage.SharedModules:WaitForChild("FruitValueCalc"))
	local sellValueData = require(ReplicatedStorage.SharedModules:WaitForChild("SellValueData"))
	local function formatValue(value)
		value = math.max(0, math.floor(tonumber(value) or 0))
		if value >= 1000000000 then return string.format("%.2fB", value / 1000000000):gsub("%.?0+B$", "B") end
		if value >= 1000000 then return string.format("%.2fM", value / 1000000):gsub("%.?0+M$", "M") end
		if value >= 1000 then return string.format("%.1fK", value / 1000):gsub("%.0K$", "K") end
		return tostring(value)
	end
	local function baseWeight(fruitName)
		if state.baseWeights[fruitName] ~= nil then return state.baseWeights[fruitName] end
		local weight = 0
		local generationModules = ReplicatedStorage:FindFirstChild("PlantGenerationModules")
		for _, folderName in ipairs({"Fruits", "Plants"}) do
			local folder = generationModules and generationModules:FindFirstChild(folderName)
			local module = folder and folder:FindFirstChild(fruitName)
			if module and module:IsA("ModuleScript") then
				local ok, data = pcall(require, module)
				local found = ok and type(data) == "table" and data.GrowData and tonumber(data.GrowData.BaseWeight)
				if found then weight = found; break end
			end
		end
		state.baseWeights[fruitName] = weight
		return weight
	end
	local function fruitValue(instance, fruitName, sizeMultiplier, mutation, decay)
		local ok, value = pcall(fruitValueCalc, fruitName, math.max(tonumber(sizeMultiplier) or 1, 0.001), mutation, instance, decay)
		return ok and tonumber(value) or 0
	end
	local function clearInventoryLabels()
		for slot, valueLabel in pairs(state.inventoryLabels) do
			if valueLabel and valueLabel.Parent then valueLabel:Destroy() end
			state.inventoryLabels[slot] = nil
		end
	end
	local function closestFruitTool(fruitName, weight)
		local best, bestDistance
		for _, container in ipairs({player:FindFirstChildOfClass("Backpack"), player.Character}) do
			if container then
				for _, tool in ipairs(container:GetChildren()) do
					local toolName = tool:GetAttribute("FruitName") or tool:GetAttribute("Fruit")
					if tool:IsA("Tool") and toolName == fruitName then
						local distance = math.abs((tonumber(tool:GetAttribute("Weight")) or weight or 0) - (weight or 0))
						if not bestDistance or distance < bestDistance then best, bestDistance = tool, distance end
					end
				end
			end
		end
		return best
	end
	local function updateInventoryEsp()
		local backpackGui = playerGui:FindFirstChild("BackpackGui")
		local seen = {}
		if backpackGui then
			for _, slot in ipairs(backpackGui:GetDescendants()) do
				local toolNameLabel = slot:IsA("TextButton") and slot:FindFirstChild("ToolName")
				local countLabel = slot:IsA("TextButton") and slot:FindFirstChild("ToolCount")
				local fruitName = toolNameLabel and toolNameLabel:IsA("TextLabel") and toolNameLabel.Text or nil
				if fruitName and sellValueData[fruitName] then
					local weight = countLabel and tonumber((countLabel.Text or ""):match("([%d%.]+)%s*[Kk][Gg]")) or nil
					local tool = closestFruitTool(fruitName, weight)
					local sizeMultiplier = tool and tool:GetAttribute("SizeMultiplier")
					if not sizeMultiplier and weight then
						local base = baseWeight(fruitName)
						sizeMultiplier = base > 0 and weight / base or 1
					end
					local host = tool or slot
					local value = fruitValue(host, fruitName, sizeMultiplier, tool and tool:GetAttribute("Mutation"), tool and tool:GetAttribute("DecayAlpha"))
					local valueLabel = state.inventoryLabels[slot]
					if not valueLabel or not valueLabel.Parent then
						valueLabel = Instance.new("TextLabel")
						valueLabel.Name = "YupisotesFruitValue"
						valueLabel.BackgroundColor3 = rgb(12, 18, 14)
						valueLabel.BackgroundTransparency = 0.18
						valueLabel.BorderSizePixel = 0
						valueLabel.Position = UDim2.fromOffset(3, 3)
						valueLabel.Size = UDim2.new(1, -6, 0, 16)
						valueLabel.Font = Enum.Font.GothamBold
						valueLabel.TextColor3 = rgb(98, 231, 154)
						valueLabel.TextStrokeColor3 = rgb(4, 8, 5)
						valueLabel.TextStrokeTransparency = 0.45
						valueLabel.TextSize = 10
						valueLabel.ZIndex = 20
						valueLabel.Parent = slot
						corner(valueLabel, 3)
						state.inventoryLabels[slot] = valueLabel
					end
					valueLabel.Text = "¢" .. formatValue(value)
					seen[slot] = true
				end
			end
		end
		for slot, valueLabel in pairs(state.inventoryLabels) do
			if not seen[slot] then
				if valueLabel and valueLabel.Parent then valueLabel:Destroy() end
				state.inventoryLabels[slot] = nil
			end
		end
	end
	local function clearGardenLabels()
		for model, billboard in pairs(state.gardenLabels) do
			if billboard and billboard.Parent then billboard:Destroy() end
			state.gardenLabels[model] = nil
		end
	end
	local function destroyValuePanel()
		if state.valuePanel and state.valuePanel.Parent then
			state.valuePanelPosition = state.valuePanel.Position
			state.valuePanel:Destroy()
		end
		state.valuePanel = nil
		if state.valuePanelBeginConnection then state.valuePanelBeginConnection:Disconnect(); state.valuePanelBeginConnection = nil end
		if state.valuePanelMoveConnection then state.valuePanelMoveConnection:Disconnect(); state.valuePanelMoveConnection = nil end
	end
	local function setValuePanel(total, count)
		local panel = state.valuePanel
		if not panel or not panel.Parent then
			panel = Instance.new("Frame")
			panel.Name = "YupisotesGardenValuePanel"
			panel.Active = true
			panel.AnchorPoint = Vector2.zero
			panel.Position = state.valuePanelPosition
			panel.Size = UDim2.fromOffset(274, 104)
			panel.BackgroundColor3 = rgb(8, 10, 11)
			panel.BackgroundTransparency = 0.04
			panel.BorderSizePixel = 0
			panel.Parent = screenGui
			corner(panel, 8)
			stroke(panel, palette.accent, 0.05, 2)
			local cat = Instance.new("ImageLabel")
			cat.Name = "CatIcon"
			cat.Image = "rbxthumb://type=Asset&id=7111868109&w=150&h=150"
			cat.ScaleType = Enum.ScaleType.Crop
			cat.BackgroundColor3 = rgb(30, 18, 42)
			cat.BorderSizePixel = 0
			cat.Position = UDim2.fromOffset(10, 8)
			cat.Size = UDim2.fromOffset(38, 38)
			cat.Parent = panel
			corner(cat, 8)
			stroke(cat, palette.accent, 0.15, 1)
			local panelTitle = label(panel, "Yupisotes Garden Value", 13, palette.text, true)
			panelTitle.Name = "Title"
			panelTitle.Position = UDim2.fromOffset(56, 8)
			panelTitle.Size = UDim2.new(1, -104, 0, 19)
			local subtitle = label(panel, "Live garden scan", 9, palette.muted, false)
			subtitle.Position = UDim2.fromOffset(56, 27)
			subtitle.Size = UDim2.new(1, -104, 0, 15)
			local live = label(panel, "LIVE", 9, rgb(98, 231, 154), true)
			live.Name = "LiveBadge"
			live.TextXAlignment = Enum.TextXAlignment.Center
			live.BackgroundColor3 = rgb(18, 45, 31)
			live.BackgroundTransparency = 0.05
			live.Position = UDim2.new(1, -48, 0, 12)
			live.Size = UDim2.fromOffset(38, 20)
			corner(live, 10)
			local accent = Instance.new("Frame")
			accent.Name = "Accent"
			accent.BackgroundColor3 = palette.accent
			accent.BorderSizePixel = 0
			accent.Position = UDim2.fromOffset(10, 52)
			accent.Size = UDim2.new(1, -20, 0, 2)
			accent.Parent = panel
			local valueRow = Instance.new("Frame")
			valueRow.Name = "ValueRow"
			valueRow.BackgroundColor3 = rgb(15, 18, 19)
			valueRow.BorderSizePixel = 0
			valueRow.Position = UDim2.fromOffset(10, 62)
			valueRow.Size = UDim2.new(1, -20, 0, 32)
			valueRow.Parent = panel
			corner(valueRow, 5)
			local amount = label(valueRow, "", 12, rgb(98, 231, 154), true)
			amount.Name = "Amount"
			amount.Position = UDim2.fromOffset(9, 0)
			amount.Size = UDim2.new(0.64, -9, 1, 0)
			local fruitCount = label(valueRow, "", 11, palette.text, true)
			fruitCount.Name = "FruitCount"
			fruitCount.TextXAlignment = Enum.TextXAlignment.Right
			fruitCount.Position = UDim2.new(0.64, 0, 0, 0)
			fruitCount.Size = UDim2.new(0.36, -9, 1, 0)
			state.valuePanel = panel
			local dragging = false
			local dragStart
			local startPosition
			state.valuePanelBeginConnection = panel.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPosition = panel.AbsolutePosition
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then dragging = false end
					end)
				end
			end)
			state.valuePanelMoveConnection = UserInputService.InputChanged:Connect(function(input)
				if dragging and panel.Parent and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local delta = input.Position - dragStart
					local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
					local x = math.clamp(startPosition.X + delta.X, 0, math.max(0, viewport.X - panel.AbsoluteSize.X))
					local y = math.clamp(startPosition.Y + delta.Y, 0, math.max(0, viewport.Y - panel.AbsoluteSize.Y))
					panel.Position = UDim2.fromOffset(x, y)
					state.valuePanelPosition = panel.Position
				end
			end)
		end
		local amount = panel:FindFirstChild("Amount", true)
		local fruitCount = panel:FindFirstChild("FruitCount", true)
		if amount then amount.Text = "Total: ¢" .. formatValue(total) end
		if fruitCount then fruitCount.Text = "Fruits: " .. tostring(count) end
	end
	local function updateGardenBillboard(model, fruitName, value)
		local adornee = model:FindFirstChild("HarvestPart", true) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
		if not adornee or not adornee:IsA("BasePart") then return false end
		local billboard = state.gardenLabels[model]
		if not billboard or not billboard.Parent then
			billboard = Instance.new("BillboardGui")
			billboard.Name = "YupisotesGardenFruitESP"
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.MaxDistance = 350
			billboard.Size = UDim2.fromOffset(150, 42)
			billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
			billboard.Parent = screenGui
			local textLabel = label(billboard, "", 12, rgb(244, 244, 248), true)
			textLabel.Name = "Value"
			textLabel.Size = UDim2.fromScale(1, 1)
			textLabel.TextStrokeColor3 = rgb(5, 5, 7)
			textLabel.TextStrokeTransparency = 0.15
			state.gardenLabels[model] = billboard
		end
		billboard.Adornee = adornee
		billboard.Value.Text = fruitName .. "\n¢" .. formatValue(value)
		return true
	end
	local function updateGardenEsp()
		local plot = getPlayerPlot()
		local seen = {}
		local labeled = {}
		local highestSelected
		local total, count = 0, 0
		if plot then
			for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
				if prompt:IsDescendantOf(plot) then
					local model = prompt:FindFirstAncestorWhichIsA("Model")
					if model and not seen[model] then
						seen[model] = true
						local fruitName = model:GetAttribute("CorePartName") or getHarvestSeedName(model)
						if type(fruitName) == "string" and sellValueData[fruitName] then
							local sizeMultiplier = tonumber(model:GetAttribute("SizeMulti")) or 1
							local value = fruitValue(model, fruitName, sizeMultiplier, model:GetAttribute("Mutation"), model:GetAttribute("DecayAlpha"))
							total += value
							count += 1
							local showSelected = state.selectedFruitValueEnabled and state.selectedValueSeeds[fruitName] == true
							local showAll = not state.selectedFruitValueEnabled and state.gardenFruitEnabled
							if showSelected and state.highestFruitValueOnly then
								if not highestSelected or value > highestSelected.value then highestSelected = {model = model, name = fruitName, value = value} end
							elseif (showSelected or showAll) and updateGardenBillboard(model, fruitName, value) then
								labeled[model] = true
							end
						end
					end
				end
			end
		end
		if highestSelected and updateGardenBillboard(highestSelected.model, highestSelected.name, highestSelected.value) then
			labeled[highestSelected.model] = true
			screenGui:SetAttribute("HighestSelectedFruitName", highestSelected.name)
			screenGui:SetAttribute("HighestSelectedFruitValue", highestSelected.value)
		else
			screenGui:SetAttribute("HighestSelectedFruitName", nil)
			screenGui:SetAttribute("HighestSelectedFruitValue", nil)
		end
		for model, billboard in pairs(state.gardenLabels) do
			if not labeled[model] then
				if billboard and billboard.Parent then billboard:Destroy() end
				state.gardenLabels[model] = nil
			end
		end
		if state.gardenValueEnabled then
			setValuePanel(total, count)
		elseif state.valuePanel then
			destroyValuePanel()
		end
		screenGui:SetAttribute("GardenFruitTotalValue", total)
		screenGui:SetAttribute("GardenFruitVisibleCount", count)
	end
	local function ensureVisualLoop()
		state.runId += 1
		local runId = state.runId
		local generation = runtime.YupisotesGeneration
		if not state.inventoryFruitEnabled then clearInventoryLabels() end
		if not state.gardenFruitEnabled and not state.selectedFruitValueEnabled then clearGardenLabels() end
		if not state.gardenValueEnabled and state.valuePanel then destroyValuePanel() end
		if not state.inventoryFruitEnabled and not state.gardenFruitEnabled and not state.gardenValueEnabled and not state.selectedFruitValueEnabled then return end
		task.spawn(function()
			while state.runId == runId and generation == runtime.YupisotesGeneration and screenGui.Parent do
				if state.inventoryFruitEnabled then updateInventoryEsp() end
				if state.gardenFruitEnabled or state.gardenValueEnabled or state.selectedFruitValueEnabled then updateGardenEsp() end
				task.wait(0.6)
			end
		end)
	end
	local function visualRow(name, y, titleText, descriptionText)
		local row = Instance.new("Frame")
		row.Name = name
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, 48)
		row.Parent = nil
		corner(row, 4)
		local rowTitle = label(row, titleText, 12, palette.text, true)
		rowTitle.Position = UDim2.fromOffset(8, 4)
		rowTitle.Size = UDim2.new(1, -70, 0, 18)
		local description = label(row, descriptionText, 10, palette.muted, false)
		description.Position = UDim2.fromOffset(8, 21)
		description.Size = UDim2.new(1, -70, 0, 20)
		description.TextWrapped = true
		return row
	end
	local function visualToggle(parent, name, y, titleText, descriptionText, getter, setter)
		local row = visualRow(name .. "Row", y, titleText, descriptionText)
		row.Parent = parent
		local track = Instance.new("TextButton")
		track.Name = name .. "Toggle"
		track.AutoButtonColor = false
		track.Text = ""
		track.BackgroundColor3 = rgb(59, 57, 68)
		track.BorderSizePixel = 0
		track.Position = UDim2.new(1, -52, 0, 14)
		track.Size = UDim2.fromOffset(38, 20)
		track.Parent = row
		corner(track, 10)
		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.BackgroundColor3 = rgb(245, 245, 247)
		knob.BorderSizePixel = 0
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = track
		corner(knob, 8)
		local function render(animated)
			local enabled = getter()
			local targetPosition = enabled and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
			local targetColor = enabled and palette.accent or rgb(59, 57, 68)
			if animated then
				TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPosition}):Play()
				TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
			else
				knob.Position = targetPosition
				track.BackgroundColor3 = targetColor
			end
		end
		track.MouseButton1Click:Connect(function() setter(not getter()); render(true) end)
		render(false)
	end
	local function separator(parent, y, textValue)
		local row = Instance.new("Frame")
		row.BackgroundColor3 = rgb(27, 22, 35)
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, 32)
		row.Parent = parent
		corner(row, 3)
		local rowText = label(row, "- [ " .. textValue .. " ] -", 11, palette.text, true)
		rowText.Position = UDim2.fromOffset(8, 0)
		rowText.Size = UDim2.new(1, -16, 1, 0)
	end

	local header = Instance.new("TextButton")
	header.Name = "ESPHeader"
	header.AutoButtonColor = false
	header.Text = ""
	header.BackgroundColor3 = palette.card
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, 31)
	header.LayoutOrder = 0
	header.Parent = list
	corner(header, 4)
	local headerText = label(header, "ESP", 13, palette.text, true)
	headerText.Position = UDim2.fromOffset(8, 0)
	headerText.Size = UDim2.new(1, -40, 1, 0)
	local headerArrow = label(header, "v", 14, rgb(210, 210, 216), true)
	headerArrow.Position = UDim2.new(1, -28, 0, 0)
	headerArrow.Size = UDim2.fromOffset(20, 31)
	headerArrow.TextXAlignment = Enum.TextXAlignment.Center
	headerArrow.Rotation = state.categoryOpen and 180 or 0
	local headerAccent = Instance.new("Frame")
	headerAccent.BackgroundColor3 = palette.accent
	headerAccent.BorderSizePixel = 0
	headerAccent.Position = UDim2.new(0, 0, 1, -2)
	headerAccent.Size = UDim2.new(1, 0, 0, 2)
	headerAccent.Parent = header
	local visualContent = Instance.new("Frame")
	visualContent.Name = "ESPContent"
	visualContent.BackgroundTransparency = 1
	visualContent.BorderSizePixel = 0
	visualContent.ClipsDescendants = true
	visualContent.Size = UDim2.new(1, 0, 0, state.categoryOpen and 238 or 0)
	visualContent.LayoutOrder = 1
	visualContent.Parent = list
	visualToggle(visualContent, "EspInventoryFruit", 0, "Esp Inventory Fruit", "Add checkies value labels to fruit slots in your inventory.", function() return state.inventoryFruitEnabled end, function(value)
		state.inventoryFruitEnabled = value
		screenGui:SetAttribute("EspInventoryFruitEnabled", value)
		ensureVisualLoop()
	end)
	separator(visualContent, 54, "Garden Fruit")
	visualToggle(visualContent, "StartGardenFruitESP", 92, "Start Garden Fruit ESP", "Shows compact labels above visible garden fruits.", function() return state.gardenFruitEnabled end, function(value)
		state.gardenFruitEnabled = value
		screenGui:SetAttribute("GardenFruitESPEnabled", value)
		ensureVisualLoop()
	end)
	separator(visualContent, 146, "Value")
	visualToggle(visualContent, "EspGardenValue", 184, "Esp Garden Value", "Show total fruit value of your garden in a panel.", function() return state.gardenValueEnabled end, function(value)
		state.gardenValueEnabled = value
		screenGui:SetAttribute("EspGardenValueEnabled", value)
		ensureVisualLoop()
	end)
	header.MouseButton1Click:Connect(function()
		state.categoryOpen = not state.categoryOpen
		TweenService:Create(visualContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, state.categoryOpen and 238 or 0)}):Play()
		TweenService:Create(headerArrow, TweenInfo.new(0.18), {Rotation = state.categoryOpen and 180 or 0}):Play()
	end)

	local function collectOwnGardenFruitNames()
		local choices = {}
		local found = {}
		local plot = getPlayerPlot()
		local function addFruit(fruitName)
			if type(fruitName) == "string" and sellValueData[fruitName] and not found[fruitName] then
				found[fruitName] = true
				table.insert(choices, fruitName)
			end
		end
		local plants = plot and plot:FindFirstChild("Plants")
		if plants then
			for _, plant in ipairs(plants:GetChildren()) do addFruit(plant:GetAttribute("SeedName")) end
		end
		if plot then
			for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
				if prompt:IsDescendantOf(plot) then
					local model = prompt:FindFirstAncestorWhichIsA("Model")
					if model then addFruit(model:GetAttribute("CorePartName") or getHarvestSeedName(model)) end
				end
			end
		end
		table.sort(choices)
		return choices
	end
	local fruitValueChoices = collectOwnGardenFruitNames()
	for selectedName in pairs(state.selectedValueSeeds) do
		if not table.find(fruitValueChoices, selectedName) then state.selectedValueSeeds[selectedName] = nil end
	end
	local fruitValueHeader = Instance.new("TextButton")
	fruitValueHeader.Name = "FruitValueHeader"
	fruitValueHeader.AutoButtonColor = false
	fruitValueHeader.Text = ""
	fruitValueHeader.BackgroundColor3 = palette.card
	fruitValueHeader.BorderSizePixel = 0
	fruitValueHeader.Size = UDim2.new(1, 0, 0, 31)
	fruitValueHeader.LayoutOrder = 2
	fruitValueHeader.Parent = list
	corner(fruitValueHeader, 4)
	local fruitValueHeaderText = label(fruitValueHeader, "Fruit Value", 13, palette.text, true)
	fruitValueHeaderText.Position = UDim2.fromOffset(8, 0)
	fruitValueHeaderText.Size = UDim2.new(1, -40, 1, 0)
	local fruitValueArrow = label(fruitValueHeader, "v", 14, rgb(210, 210, 216), true)
	fruitValueArrow.Position = UDim2.new(1, -28, 0, 0)
	fruitValueArrow.Size = UDim2.fromOffset(20, 31)
	fruitValueArrow.TextXAlignment = Enum.TextXAlignment.Center
	fruitValueArrow.Rotation = state.fruitValueCategoryOpen and 180 or 0
	local fruitValueAccent = Instance.new("Frame")
	fruitValueAccent.BackgroundColor3 = palette.accent
	fruitValueAccent.BorderSizePixel = 0
	fruitValueAccent.Position = UDim2.new(0, 0, 1, -2)
	fruitValueAccent.Size = UDim2.new(1, 0, 0, 2)
	fruitValueAccent.Parent = fruitValueHeader
	local fruitValueHitbox = Instance.new("TextButton")
	fruitValueHitbox.Name = "FruitValueHeaderHitbox"
	fruitValueHitbox.AutoButtonColor = false
	fruitValueHitbox.Text = ""
	fruitValueHitbox.BackgroundTransparency = 1
	fruitValueHitbox.BorderSizePixel = 0
	fruitValueHitbox.Size = UDim2.fromScale(1, 1)
	fruitValueHitbox.ZIndex = 20
	fruitValueHitbox.Parent = fruitValueHeader
	local fruitValueContent = Instance.new("Frame")
	fruitValueContent.Name = "FruitValueContent"
	fruitValueContent.BackgroundTransparency = 1
	fruitValueContent.BorderSizePixel = 0
	fruitValueContent.ClipsDescendants = not state.fruitValueCategoryOpen
	fruitValueContent.Size = UDim2.new(1, 0, 0, state.fruitValueCategoryOpen and 206 or 0)
	fruitValueContent.Visible = state.fruitValueCategoryOpen
	fruitValueContent.LayoutOrder = 3
	fruitValueContent.Parent = list
	local selectRow = visualRow("FruitValueSeedSelectRow", 0, "Fruit Value Seed (Select)", "Choose which planted fruits should show their value.")
	selectRow.Parent = fruitValueContent
	for _, child in ipairs(selectRow:GetChildren()) do
		if child:IsA("TextLabel") then child.Size = UDim2.new(0.58, -8, 0, child.Size.Y.Offset) end
	end
	local selectButton = Instance.new("TextButton")
	selectButton.Name = "FruitValueSeedSelectButton"
	selectButton.AutoButtonColor = false
	selectButton.Font = Enum.Font.GothamBold
	selectButton.TextSize = 11
	selectButton.TextXAlignment = Enum.TextXAlignment.Left
	selectButton.TextTruncate = Enum.TextTruncate.AtEnd
	selectButton.TextColor3 = palette.muted
	selectButton.BackgroundColor3 = rgb(31, 26, 43)
	selectButton.BorderSizePixel = 0
	selectButton.Position = UDim2.new(0.62, 0, 0, 8)
	selectButton.Size = UDim2.new(0.38, -7, 0, 34)
	selectButton.Parent = selectRow
	corner(selectButton, 4)
	stroke(selectButton, rgb(72, 48, 96), 0.35, 1)
	padding(selectButton, 9, 0, 28, 0)
	local selectArrow = label(selectButton, "v", 13, rgb(210, 210, 216), true)
	selectArrow.Position = UDim2.new(1, -27, 0, 0)
	selectArrow.Size = UDim2.fromOffset(20, 34)
	selectArrow.TextXAlignment = Enum.TextXAlignment.Center
	local selectPanel = Instance.new("Frame")
	selectPanel.Name = "FruitValueSeedDropdown"
	selectPanel.BackgroundColor3 = rgb(18, 18, 25)
	selectPanel.BorderSizePixel = 0
	selectPanel.ClipsDescendants = true
	selectPanel.Position = UDim2.new(0.62, 0, 0, 46)
	selectPanel.Size = UDim2.new(0.38, -7, 0, 0)
	selectPanel.ZIndex = 500
	selectPanel.Parent = fruitValueContent
	corner(selectPanel, 4)
	stroke(selectPanel, rgb(91, 39, 124), 0.1, 1)
	local selectSearch = Instance.new("TextBox")
	selectSearch.Name = "Search"
	selectSearch.ClearTextOnFocus = false
	selectSearch.PlaceholderText = "Search"
	selectSearch.Text = ""
	selectSearch.Font = Enum.Font.GothamMedium
	selectSearch.TextSize = 11
	selectSearch.TextColor3 = palette.text
	selectSearch.PlaceholderColor3 = palette.muted
	selectSearch.BackgroundColor3 = rgb(35, 27, 48)
	selectSearch.BorderSizePixel = 0
	selectSearch.Position = UDim2.fromOffset(4, 4)
	selectSearch.Size = UDim2.new(1, -8, 0, 26)
	selectSearch.ZIndex = 501
	selectSearch.Parent = selectPanel
	corner(selectSearch, 3)
	local selectOptions = Instance.new("ScrollingFrame")
	selectOptions.BackgroundTransparency = 1
	selectOptions.BorderSizePixel = 0
	selectOptions.ScrollBarImageColor3 = palette.accent
	selectOptions.ScrollBarThickness = 3
	selectOptions.Position = UDim2.fromOffset(4, 34)
	selectOptions.Size = UDim2.new(1, -8, 1, -38)
	selectOptions.ZIndex = 501
	selectOptions.Parent = selectPanel
	local selectLayout = Instance.new("UIListLayout")
	selectLayout.Padding = UDim.new(0, 2)
	selectLayout.Parent = selectOptions
	local selectOptionButtons = {}
	local function refreshFruitValueSummary()
		local selectedNames = {}
		for _, fruitName in ipairs(fruitValueChoices) do
			if state.selectedValueSeeds[fruitName] then table.insert(selectedNames, fruitName) end
		end
		selectButton.Text = #selectedNames > 0 and table.concat(selectedNames, ", ") or "Select Options"
		selectButton.TextColor3 = #selectedNames > 0 and palette.text or palette.muted
	end
	local function rebuildFruitValueOptions(newChoices)
		if newChoices then fruitValueChoices = newChoices end
		for _, option in pairs(selectOptionButtons) do option:Destroy() end
		table.clear(selectOptionButtons)
		for index, fruitName in ipairs(fruitValueChoices) do
			local option = Instance.new("TextButton")
			option.AutoButtonColor = false
			option.Text = fruitName
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.BorderSizePixel = 0
			option.Size = UDim2.new(1, -3, 0, 27)
			option.LayoutOrder = index
			option.ZIndex = 502
			option.Parent = selectOptions
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			local function renderOption()
				local selected = state.selectedValueSeeds[fruitName] == true
				option.TextColor3 = selected and rgb(221, 154, 255) or palette.text
				option.BackgroundColor3 = selected and rgb(48, 28, 64) or rgb(17, 18, 24)
				option.BackgroundTransparency = selected and 0.1 or 0.35
			end
			option.MouseButton1Click:Connect(function()
				state.selectedValueSeeds[fruitName] = not state.selectedValueSeeds[fruitName] and true or nil
				renderOption()
				refreshFruitValueSummary()
				if state.selectedFruitValueEnabled then ensureVisualLoop() end
			end)
			renderOption()
			selectOptionButtons[fruitName] = option
		end
		refreshFruitValueSummary()
		selectOptions.CanvasSize = UDim2.fromOffset(0, selectLayout.AbsoluteContentSize.Y)
	end
	rebuildFruitValueOptions()
	local function updateSelectCanvas()
		selectOptions.CanvasSize = UDim2.fromOffset(0, selectLayout.AbsoluteContentSize.Y)
	end
	selectLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSelectCanvas)
	updateSelectCanvas()
	selectSearch:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(selectSearch.Text)
		for fruitName, option in pairs(selectOptionButtons) do
			option.Visible = query == "" or string.find(string.lower(fruitName), query, 1, true) ~= nil
		end
		selectOptions.CanvasPosition = Vector2.zero
	end)
	local fruitSelectOpen = false
	local function setFruitSelectOpen(open)
		fruitSelectOpen = open
		TweenService:Create(selectPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0.38, -7, 0, open and 150 or 0)}):Play()
		TweenService:Create(selectArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
	end
	selectButton.MouseButton1Click:Connect(function() setFruitSelectOpen(not fruitSelectOpen) end)
	local refreshFruitValue = Instance.new("TextButton")
	refreshFruitValue.Name = "RefreshGardenFruitValueList"
	refreshFruitValue.AutoButtonColor = true
	refreshFruitValue.Text = "Refresh Garden Fruit List"
	refreshFruitValue.Font = Enum.Font.GothamBold
	refreshFruitValue.TextSize = 11
	refreshFruitValue.TextColor3 = palette.text
	refreshFruitValue.BackgroundColor3 = rgb(30, 35, 30)
	refreshFruitValue.BorderSizePixel = 0
	refreshFruitValue.Position = UDim2.fromOffset(0, 58)
	refreshFruitValue.Size = UDim2.new(1, 0, 0, 34)
	refreshFruitValue.Parent = fruitValueContent
	corner(refreshFruitValue, 4)
	refreshFruitValue.MouseButton1Click:Connect(function()
		local refreshedChoices = collectOwnGardenFruitNames()
		for selectedName in pairs(state.selectedValueSeeds) do
			if not table.find(refreshedChoices, selectedName) then state.selectedValueSeeds[selectedName] = nil end
		end
		rebuildFruitValueOptions(refreshedChoices)
		screenGui:SetAttribute("GardenFruitValueChoiceCount", #refreshedChoices)
		if state.selectedFruitValueEnabled then ensureVisualLoop() end
	end)
	visualToggle(fruitValueContent, "StartSelectedFruitValue", 98, "Start Fruit Value", "Scan your garden and show values only for selected fruits.", function() return state.selectedFruitValueEnabled end, function(value)
		if value and next(state.selectedValueSeeds) == nil then
			screenGui:SetAttribute("SelectedFruitValueStatus", "Select at least one fruit")
			return
		end
		state.selectedFruitValueEnabled = value
		screenGui:SetAttribute("SelectedFruitValueEnabled", value)
		screenGui:SetAttribute("SelectedFruitValueStatus", value and "Scanning selected fruits" or "Stopped")
		ensureVisualLoop()
	end)
	visualToggle(fruitValueContent, "HighestFruitValueOnly", 152, "Highest Value Fruit Only", "From selected fruits, show only the one with the highest value.", function() return state.highestFruitValueOnly end, function(value)
		state.highestFruitValueOnly = value
		screenGui:SetAttribute("HighestFruitValueOnly", value)
		if state.selectedFruitValueEnabled then ensureVisualLoop() end
	end)
	fruitValueHitbox.MouseButton1Click:Connect(function()
		state.fruitValueCategoryOpen = not state.fruitValueCategoryOpen
		if state.fruitValueCategoryOpen then
			fruitValueContent.Visible = true
			fruitValueContent.ClipsDescendants = false
			fruitValueContent.Size = UDim2.new(1, 0, 0, 0)
			TweenService:Create(fruitValueContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 206)}):Play()
		else
			setFruitSelectOpen(false)
			fruitValueContent.ClipsDescendants = true
			fruitValueContent.Size = UDim2.new(1, 0, 0, 0)
			fruitValueContent.Visible = false
		end
		TweenService:Create(fruitValueArrow, TweenInfo.new(0.18), {Rotation = state.fruitValueCategoryOpen and 180 or 0}):Play()
	end)
	ensureVisualLoop()
end
runtime.YupisotesShowConfig = function()
	local state = runtime.YupisotesConfigState
	currentPage = "Config"
	dropdownOpen = false
	disconnectSection()
	section.Visible = false
	setActiveTab("Config")
	title.Text = "Config"
	section.Parent = content
	clearList()
	accentLine.Visible = false
	farmSectionAccent.Visible = false
	list.Position = UDim2.fromOffset(0, 34)
	list.Size = UDim2.new(1, -2, 1, -35)
	list.CanvasPosition = Vector2.zero

	local header = Instance.new("TextButton")
	header.Name = "ConfigConfigurationHeader"
	header.AutoButtonColor = false
	header.Text = ""
	header.BackgroundColor3 = palette.card
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, 31)
	header.LayoutOrder = 0
	header.Parent = list
	corner(header, 4)
	local headerText = label(header, "Config Configuration", 13, palette.text, true)
	headerText.Position = UDim2.fromOffset(8, 0)
	headerText.Size = UDim2.new(1, -40, 1, 0)
	local headerArrow = label(header, "v", 14, rgb(210, 210, 216), true)
	headerArrow.Position = UDim2.new(1, -28, 0, 0)
	headerArrow.Size = UDim2.fromOffset(20, 31)
	headerArrow.TextXAlignment = Enum.TextXAlignment.Center
	headerArrow.Rotation = state.categoryOpen and 180 or 0
	local headerAccent = Instance.new("Frame")
	headerAccent.BackgroundColor3 = palette.accent
	headerAccent.BorderSizePixel = 0
	headerAccent.Position = UDim2.new(0, 0, 1, -2)
	headerAccent.Size = UDim2.new(1, 0, 0, 2)
	headerAccent.Parent = header

	local configContent = Instance.new("Frame")
	configContent.Name = "ConfigConfigurationContent"
	configContent.BackgroundTransparency = 1
	configContent.BorderSizePixel = 0
	configContent.ClipsDescendants = not state.categoryOpen
	configContent.Size = UDim2.new(1, 0, 0, state.categoryOpen and 232 or 0)
	configContent.Visible = state.categoryOpen
	configContent.LayoutOrder = 1
	configContent.Parent = list

	local function configRow(name, y, rowTitle, description)
		local row = Instance.new("Frame")
		row.Name = name
		row.BackgroundColor3 = palette.card
		row.BorderSizePixel = 0
		row.Position = UDim2.fromOffset(0, y)
		row.Size = UDim2.new(1, 0, 0, description and 52 or 45)
		row.Parent = configContent
		corner(row, 4)
		local rowLabel = label(row, rowTitle, 12, palette.text, true)
		rowLabel.Position = UDim2.fromOffset(8, description and 7 or 0)
		rowLabel.Size = UDim2.new(0.58, -12, 0, description and 17 or 45)
		if description then
			local descriptionLabel = label(row, description, 10, palette.muted, false)
			descriptionLabel.Position = UDim2.fromOffset(8, 25)
			descriptionLabel.Size = UDim2.new(0.58, -12, 0, 15)
		end
		return row
	end

	local nameRow = configRow("ConfigNameRow", 0, "Config Name", "Input name save")
	local nameInput = Instance.new("TextBox")
	nameInput.Name = "ConfigNameInput"
	nameInput.ClearTextOnFocus = false
	nameInput.Text = state.name or "Default"
	nameInput.PlaceholderText = "Default"
	nameInput.Font = Enum.Font.GothamBold
	nameInput.TextSize = 12
	nameInput.TextXAlignment = Enum.TextXAlignment.Left
	nameInput.TextColor3 = palette.text
	nameInput.PlaceholderColor3 = palette.muted
	nameInput.BackgroundColor3 = rgb(31, 26, 43)
	nameInput.BorderSizePixel = 0
	nameInput.Position = UDim2.new(0.64, 0, 0, 8)
	nameInput.Size = UDim2.new(0.36, -7, 0, 34)
	nameInput.Parent = nameRow
	corner(nameInput, 4)
	stroke(nameInput, rgb(91, 39, 124), 0.25, 1)
	padding(nameInput, 9, 0, 8, 0)
	nameInput.FocusLost:Connect(function()
		state.name = runtime.YupisotesSanitizeConfigName(nameInput.Text)
		nameInput.Text = state.name
	end)

	local savedRow = configRow("SavedConfigsRow", 57, "Saved Configs", "List saved config")
	local savedButton = Instance.new("TextButton")
	savedButton.Name = "SavedConfigsButton"
	savedButton.AutoButtonColor = false
	savedButton.Text = state.selected or "Default"
	savedButton.Font = Enum.Font.GothamBold
	savedButton.TextSize = 12
	savedButton.TextXAlignment = Enum.TextXAlignment.Left
	savedButton.TextColor3 = palette.text
	savedButton.BackgroundColor3 = rgb(31, 26, 43)
	savedButton.BorderSizePixel = 0
	savedButton.Position = UDim2.new(0.63, 0, 0, 8)
	savedButton.Size = UDim2.new(0.37, -7, 0, 34)
	savedButton.Parent = savedRow
	corner(savedButton, 4)
	padding(savedButton, 9, 0, 28, 0)
	local savedArrow = label(savedButton, "v", 13, rgb(210, 210, 216), true)
	savedArrow.Position = UDim2.new(1, -27, 0, 0)
	savedArrow.Size = UDim2.fromOffset(20, 34)
	savedArrow.TextXAlignment = Enum.TextXAlignment.Center

	local savedPanel = Instance.new("Frame")
	savedPanel.Name = "SavedConfigsDropdown"
	savedPanel.BackgroundColor3 = rgb(18, 18, 25)
	savedPanel.BorderSizePixel = 0
	savedPanel.ClipsDescendants = true
	savedPanel.Position = UDim2.new(0.63, 0, 0, 99)
	savedPanel.Size = UDim2.new(0.37, -7, 0, 0)
	savedPanel.ZIndex = 500
	savedPanel.Parent = configContent
	corner(savedPanel, 4)
	stroke(savedPanel, rgb(91, 39, 124), 0.1, 1)
	local savedList = Instance.new("ScrollingFrame")
	savedList.BackgroundTransparency = 1
	savedList.BorderSizePixel = 0
	savedList.ScrollBarImageColor3 = palette.accent
	savedList.ScrollBarThickness = 3
	savedList.Position = UDim2.fromOffset(4, 4)
	savedList.Size = UDim2.new(1, -8, 1, -8)
	savedList.ZIndex = 501
	savedList.Parent = savedPanel
	local savedLayout = Instance.new("UIListLayout")
	savedLayout.Padding = UDim.new(0, 2)
	savedLayout.Parent = savedList
	local panelOpen = false
	local function setPanelOpen(open)
		panelOpen = open
		TweenService:Create(savedPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0.37, -7, 0, open and 110 or 0)}):Play()
		TweenService:Create(savedArrow, TweenInfo.new(0.18), {Rotation = open and 180 or 0}):Play()
	end
	local function refreshSavedConfigs()
		for _, child in ipairs(savedList:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
		for index, configName in ipairs(runtime.YupisotesListConfigs()) do
			local option = Instance.new("TextButton")
			option.Name = "ConfigOption_" .. configName
			option.AutoButtonColor = false
			option.Text = configName
			option.Font = Enum.Font.GothamMedium
			option.TextSize = 11
			option.TextXAlignment = Enum.TextXAlignment.Left
			option.TextColor3 = state.selected == configName and rgb(221, 154, 255) or palette.text
			option.BackgroundColor3 = state.selected == configName and rgb(48, 28, 64) or rgb(17, 18, 24)
			option.BorderSizePixel = 0
			option.Size = UDim2.new(1, -3, 0, 27)
			option.LayoutOrder = index
			option.ZIndex = 502
			option.Parent = savedList
			corner(option, 3)
			padding(option, 10, 0, 0, 0)
			option.MouseButton1Click:Connect(function()
				local loaded, message = runtime.YupisotesLoadConfig(configName)
				if loaded then
					state.name = configName
					nameInput.Text = configName
					savedButton.Text = configName
				end
				screenGui:SetAttribute("ConfigStatus", message)
				setPanelOpen(false)
				refreshSavedConfigs()
			end)
		end
		savedList.CanvasSize = UDim2.fromOffset(0, savedLayout.AbsoluteContentSize.Y)
	end
	savedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		savedList.CanvasSize = UDim2.fromOffset(0, savedLayout.AbsoluteContentSize.Y)
	end)
	refreshSavedConfigs()
	savedButton.MouseButton1Click:Connect(function() setPanelOpen(not panelOpen) end)

	local autoRow = configRow("AutoLoadRow", 114, "Auto Load", "Load config ini otomatis")
	local autoTrack = Instance.new("Frame")
	autoTrack.Name = "AutoLoadTrack"
	autoTrack.BackgroundColor3 = state.autoLoad and palette.accent or rgb(64, 64, 73)
	autoTrack.BorderSizePixel = 0
	autoTrack.Position = UDim2.new(1, -52, 0, 14)
	autoTrack.Size = UDim2.fromOffset(39, 22)
	autoTrack.Parent = autoRow
	corner(autoTrack, 12)
	local autoKnob = Instance.new("Frame")
	autoKnob.Name = "AutoLoadKnob"
	autoKnob.BackgroundColor3 = rgb(245, 245, 247)
	autoKnob.BorderSizePixel = 0
	autoKnob.Position = UDim2.fromOffset(state.autoLoad and 20 or 3, 3)
	autoKnob.Size = UDim2.fromOffset(16, 16)
	autoKnob.Parent = autoTrack
	corner(autoKnob, 9)
	local autoHitbox = Instance.new("TextButton")
	autoHitbox.Name = "AutoLoadToggle"
	autoHitbox.AutoButtonColor = false
	autoHitbox.Text = ""
	autoHitbox.BackgroundTransparency = 1
	autoHitbox.Size = UDim2.fromScale(1, 1)
	autoHitbox.Parent = autoTrack
	local function renderAutoLoad()
		TweenService:Create(autoTrack, TweenInfo.new(0.18), {BackgroundColor3 = state.autoLoad and palette.accent or rgb(64, 64, 73)}):Play()
		TweenService:Create(autoKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(state.autoLoad and 20 or 3, 3)}):Play()
	end
	autoHitbox.MouseButton1Click:Connect(function()
		state.autoLoad = not state.autoLoad
		runtime.YupisotesSetAutoLoad(state.selected or state.name, state.autoLoad)
		renderAutoLoad()
		screenGui:SetAttribute("ConfigStatus", state.autoLoad and "Auto Load enabled" or "Auto Load disabled")
	end)

	local function actionButton(name, y, buttonText, callback)
		local button = Instance.new("TextButton")
		button.Name = name
		button.AutoButtonColor = true
		button.Text = buttonText
		button.Font = Enum.Font.GothamBold
		button.TextSize = 11
		button.TextColor3 = palette.text
		button.BackgroundColor3 = rgb(30, 35, 30)
		button.BorderSizePixel = 0
		button.Position = UDim2.fromOffset(0, y)
		button.Size = UDim2.new(1, 0, 0, 33)
		button.Parent = configContent
		corner(button, 4)
		button.MouseButton1Click:Connect(callback)
		return button
	end
	local saveButton
	saveButton = actionButton("SaveConfigButton", 171, "Save", function()
		state.name = runtime.YupisotesSanitizeConfigName(nameInput.Text)
		nameInput.Text = state.name
		local saved, message = runtime.YupisotesSaveConfig(state.name)
		screenGui:SetAttribute("ConfigStatus", message)
		if saved then
			savedButton.Text = state.name
			refreshSavedConfigs()
			local original = "Save"
			saveButton.Text = "Saved"
			task.delay(0.8, function() if saveButton.Parent then saveButton.Text = original end end)
		end
	end)
	actionButton("SetAutoLoadButton", 208, "Set as Auto Load", function()
		state.name = runtime.YupisotesSanitizeConfigName(nameInput.Text)
		nameInput.Text = state.name
		local saved = runtime.YupisotesSaveConfig(state.name)
		if saved then
			state.selected = state.name
			savedButton.Text = state.name
			state.autoLoad = true
			runtime.YupisotesSetAutoLoad(state.name, true)
			renderAutoLoad()
			refreshSavedConfigs()
			screenGui:SetAttribute("ConfigStatus", "Auto Load set to " .. state.name)
		end
	end)
	header.MouseButton1Click:Connect(function()
		state.categoryOpen = not state.categoryOpen
		setPanelOpen(false)
		if state.categoryOpen then
			configContent.Visible = true
			configContent.ClipsDescendants = false
			configContent.Size = UDim2.new(1, 0, 0, 0)
			TweenService:Create(configContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 245)}):Play()
		else
			configContent.ClipsDescendants = true
			configContent.Size = UDim2.new(1, 0, 0, 0)
			configContent.Visible = false
		end
		TweenService:Create(headerArrow, TweenInfo.new(0.18), {Rotation = state.categoryOpen and 180 or 0}):Play()
	end)
	screenGui:SetAttribute("ConfigStatus", "Ready")
end
for tabName, ref in pairs(tabRefs) do
ref.button.MouseButton1Click:Connect(function()
if tabName == "Info" then
showInfo()
elseif tabName == "Farm" then
showFarm()
	elseif tabName == "Shop" then
		runtime.YupisotesShowShop()
	elseif tabName == "Pet" then
		runtime.YupisotesShowPet()
	elseif tabName == "Misc" then
		runtime.YupisotesShowMisc()
	elseif tabName == "Visual" then
		runtime.YupisotesShowVisual()
	elseif tabName == "Config" then
		runtime.YupisotesShowConfig()
end
end)
end
if runtime.YupisotesConfigState.autoLoad then
if autoPlantEnabled or autoHarvestEnabled or autoSellEnabled or advancedSellEnabled or doubleEnabled
or autoFavoriteEnabled or autoShovelEnabled or autoShovelFruitEnabled or autoTrowelEnabled
or autoCollectDroppedSeedEnabled or autoSellPetEnabled or autoLeaveWeatherEnabled then
pcall(showFarm)
end
if runtime.YupisotesShopState.limitedEnabled or runtime.YupisotesShopState.alwaysEnabled
or runtime.YupisotesShopState.gearLimitedEnabled or runtime.YupisotesShopState.gearAlwaysEnabled
or runtime.YupisotesShopState.propsLimitedEnabled or runtime.YupisotesShopState.propsAlwaysEnabled
or runtime.YupisotesShopState.auctionEnabled then
pcall(runtime.YupisotesShowShop)
end
if runtime.YupisotesPetState.enabled or runtime.YupisotesPetState.eggEnabled then
pcall(runtime.YupisotesShowPet)
end
if runtime.YupisotesMiscState.enabled or runtime.YupisotesMiscState.giftEnabled
or runtime.YupisotesMiscState.autoAcceptGift or runtime.YupisotesMiscState.mailSelectedEnabled
or runtime.YupisotesMiscState.mailAllEnabled or runtime.YupisotesMiscState.mailClaimEnabled
or runtime.YupisotesMiscState.autoReconnect or runtime.YupisotesMiscState.boostFps
or runtime.YupisotesMiscState.hidePlants or runtime.YupisotesMiscState.protectionEnabled
or runtime.YupisotesMiscState.webhookStockEnabled or runtime.YupisotesMiscState.utilityWebhookEnabled then
pcall(runtime.YupisotesShowMisc)
end
if runtime.YupisotesVisualState.inventoryFruitEnabled or runtime.YupisotesVisualState.gardenFruitEnabled
or runtime.YupisotesVisualState.gardenValueEnabled or runtime.YupisotesVisualState.selectedFruitValueEnabled then
pcall(runtime.YupisotesShowVisual)
end
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

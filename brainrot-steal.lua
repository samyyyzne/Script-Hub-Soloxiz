--[[
    Brainrot Hub v3.0 MEGA COMPLETE
    UI estilo Solix/Mavis para Brainrot Tycoon
    TODAS as funcoes + ABA ROUBAR com 312 linhas originais!
]]

repeat wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 30)

if not Remotes then
    warn("[BrainrotHub] Remotes nao encontrado")
    return
end

for _, gui in pairs({game.CoreGui, (gethui and gethui()) or nil}) do
    if gui and gui:FindFirstChild("BrainrotHub_v3") then
        gui.BrainrotHub_v3:Destroy()
    end
end

local Colors = {
    Background    = Color3.fromRGB(15, 12, 16),
    Background2   = Color3.fromRGB(22, 20, 24),
    Element       = Color3.fromRGB(36, 32, 39),
    ElementHover  = Color3.fromRGB(46, 42, 49),
    Accent        = Color3.fromRGB(232, 186, 248),
    Accent2       = Color3.fromRGB(150, 100, 230),
    Text          = Color3.fromRGB(255, 255, 255),
    TextDim       = Color3.fromRGB(185, 185, 185),
    Border        = Color3.fromRGB(41, 37, 45),
    Success       = Color3.fromRGB(60, 255, 60),
    Danger        = Color3.fromRGB(255, 60, 60),
    Warning       = Color3.fromRGB(237, 170, 0),
    Gold          = Color3.fromRGB(255, 200, 50),
}

local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 6); c.Parent = p
end
local function Stroke(p, c, t)
    local s = Instance.new("UIStroke"); s.Color = c or Colors.Border; s.Thickness = t or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p
end
local function notify(title, desc, duration)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {Title = title, Text = desc, Duration = duration or 3})
    end)
end

local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHub_v3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
if syn and syn.protect_gui then pcall(syn.protect_gui, ScreenGui) end
local ok = pcall(function() if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = game.CoreGui end end)
if not ok then ScreenGui.Parent = game.CoreGui end

local MinimizeBall = Instance.new("ImageButton")
MinimizeBall.Name = "Ball"
MinimizeBall.Size = UDim2.new(0, 56, 0, 56)
MinimizeBall.Position = UDim2.new(0, 25, 0.5, -28)
MinimizeBall.BackgroundColor3 = Colors.Accent
MinimizeBall.BackgroundTransparency = 0.2
MinimizeBall.Image = "rbxassetid://10747372973"
MinimizeBall.ImageColor3 = Colors.Text
MinimizeBall.ZIndex = 100
MinimizeBall.Parent = ScreenGui
Corner(MinimizeBall, 28)
Stroke(MinimizeBall, Colors.Accent, 2)
makeDraggable(MinimizeBall)

local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1.8, 0, 1.8, 0)
Glow.Position = UDim2.new(-0.4, 0, -0.4, 0)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5554236805"
Glow.ImageColor3 = Colors.Accent
Glow.ImageTransparency = 0.5
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(23, 23, 277, 277)
Glow.ZIndex = 99
Glow.Parent = MinimizeBall

task.spawn(function()
    while MinimizeBall and MinimizeBall.Parent do
        TweenService:Create(Glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.3}):Play()
        task.wait(1.2)
        TweenService:Create(Glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.7}):Play()
        task.wait(1.2)
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 700, 0, 480)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.10
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Corner(MainFrame, 12)
Stroke(MainFrame, Colors.Border, 1.5)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Colors.Background2
TopBar.BackgroundTransparency = 0.20
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 10
TopBar.Parent = MainFrame
Corner(TopBar, 12)

local LogoLine = Instance.new("Frame")
LogoLine.Size = UDim2.new(0, 4, 0, 26)
LogoLine.Position = UDim2.new(0, 18, 0.5, -13)
LogoLine.BackgroundColor3 = Colors.Accent
LogoLine.BorderSizePixel = 0
LogoLine.ZIndex = 11
LogoLine.Parent = TopBar
Corner(LogoLine, 2)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 32, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Brainrot Hub v3.0 MEGA"
Title.TextColor3 = Colors.Accent
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = TopBar

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 32, 0, 32)
MiniBtn.Position = UDim2.new(1, -78, 0, 8)
MiniBtn.BackgroundColor3 = Colors.Warning
MiniBtn.BackgroundTransparency = 0.4
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Colors.Text
MiniBtn.TextSize = 18
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.BorderSizePixel = 0
MiniBtn.ZIndex = 11
MiniBtn.Parent = TopBar
Corner(MiniBtn, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.BackgroundTransparency = 0.4
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 11
CloseBtn.Parent = TopBar
Corner(CloseBtn, 6)

makeDraggable(MainFrame, TopBar)

MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
MinimizeBall.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -56)
Sidebar.Position = UDim2.new(0, 0, 0, 54)
Sidebar.BackgroundColor3 = Colors.Background2
Sidebar.BackgroundTransparency = 0.40
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true
Sidebar.ZIndex = 7
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 2)
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 4)
SidebarPad.PaddingLeft = UDim.new(0, 4)
SidebarPad.PaddingRight = UDim.new(0, 4)
SidebarPad.PaddingBottom = UDim.new(0, 4)
SidebarPad.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -130, 1, -56)
ContentArea.Position = UDim2.new(0, 130, 0, 54)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 7
ContentArea.Parent = MainFrame

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 28)
    TabButton.BackgroundColor3 = Colors.Element
    TabButton.BackgroundTransparency = 0.60
    TabButton.Text = name
    TabButton.TextColor3 = Colors.TextDim
    TabButton.TextSize = 9
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = order
    TabButton.ZIndex = 8
    TabButton.AutoButtonColor = false
    TabButton.Parent = Sidebar
    Corner(TabButton, 4)

    local Container = Instance.new("Frame")
    Container.Name = name .. "Container"
    Container.Size = UDim2.new(1, 0, 1, 0)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true
    Container.Visible = false
    Container.ZIndex = 8
    Container.Parent = ContentArea

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = Colors.Accent
    TabContent.ScrollBarImageTransparency = 0.3
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ElasticBehavior = Enum.ElasticBehavior.Never
    TabContent.ZIndex = 8
    TabContent.Parent = Container

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 3)
    Layout.Parent = TabContent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 6)
    Pad.PaddingLeft = UDim.new(0, 6)
    Pad.PaddingRight = UDim.new(0, 6)
    Pad.PaddingBottom = UDim.new(0, 6)
    Pad.Parent = TabContent

    local function updateCanvas()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
    end
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    task.defer(updateCanvas)

    Tabs[name] = {Button = TabButton, Container = Container, Content = TabContent}

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab == name then return end
        for n, t in pairs(Tabs) do
            t.Container.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Element, BackgroundTransparency = 0.60, TextColor3 = Colors.TextDim}):Play()
        end
        Container.Visible = true
        updateCanvas()
        TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0.10, TextColor3 = Colors.Text}):Play()
        CurrentTab = name
    end)

    TabButton.MouseEnter:Connect(function() if CurrentTab ~= name then TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.4, TextColor3 = Colors.Text}):Play() end end)
    TabButton.MouseLeave:Connect(function() if CurrentTab ~= name then TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.6, TextColor3 = Colors.TextDim}):Play() end end)

    return TabContent
end

local function CreateSectionLabel(parent, text)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 14)
    Section.BackgroundTransparency = 1
    Section.ZIndex = 9
    Section.Parent = parent

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(0, 12, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, -0.5)
    Line.BackgroundColor3 = Colors.Accent
    Line.BorderSizePixel = 0
    Line.ZIndex = 9
    Line.Parent = Section

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -18, 1, 0)
    Lbl.Position = UDim2.new(0, 16, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = string.upper(text)
    Lbl.TextColor3 = Colors.Text
    Lbl.TextSize = 8
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextYAlignment = Enum.TextYAlignment.Center
    Lbl.ZIndex = 9
    Lbl.Parent = Section
end

local function CreateButton(parent, text, callback, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 24)
    Btn.BackgroundColor3 = color or Colors.Accent
    Btn.BackgroundTransparency = 0.15
    Btn.Text = text
    Btn.TextColor3 = Colors.Text
    Btn.TextSize = 10
    Btn.Font = Enum.Font.GothamSemibold
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.TextScaled = false
    Btn.TextTruncate = Enum.TextTruncate.AtEnd
    Btn.ZIndex = 9
    Btn.Parent = parent
    Corner(Btn, 3)

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.4}):Play()
        task.wait(0.08)
        TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.15}):Play()
        if callback then pcall(callback) end
    end)
    Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Accent2}):Play() end)
    Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = color or Colors.Accent}):Play() end)
    return Btn
end

-- ABAS
local MoneyTab = CreateTab("Money", 1)
local StatsTab = CreateTab("Stats", 2)
local SpawnTab = CreateTab("Spawn", 3)
local EventTab = CreateTab("Event", 4)
local RoletaTab = CreateTab("Roleta", 5)
local AdminTab = CreateTab("Admin", 6)
local RoubarTab = CreateTab("ROUBAR", 7)
local MiscTab = CreateTab("Misc", 8)

Tabs["Money"].Container.Visible = true
Tabs["Money"].Button.BackgroundColor3 = Colors.Accent
Tabs["Money"].Button.BackgroundTransparency = 0.10
Tabs["Money"].Button.TextColor3 = Colors.Text
CurrentTab = "Money"

-- MONEY
CreateSectionLabel(MoneyTab, "Dinheiro")
CreateButton(MoneyTab, "+1B", function() if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Dinheiro", 1e9) notify("Money", "+1B", 1) end end, Colors.Gold)
CreateButton(MoneyTab, "+1T", function() if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Dinheiro", 1e12) notify("Money", "+1T", 1) end end, Colors.Gold)
CreateSectionLabel(MoneyTab, "Moedas/Tokens")
CreateButton(MoneyTab, "+1B Moedas", function() if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Moedas", 1e9) notify("Money", "+1B Moedas", 1) end end, Colors.Gold)
CreateButton(MoneyTab, "+1B Tokens", function() if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Tokens", 1e9) notify("Money", "+1B Tokens", 1) end end, Colors.Warning)

-- STATS
CreateSectionLabel(StatsTab, "Velocidade")
CreateButton(StatsTab, "1B Vel", function() if Remotes:FindFirstChild("UpdateLeaderstats") then Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Velocidade", 1e9) notify("Stats", "Vel +1B", 1) end end, Colors.Gold)
CreateButton(StatsTab, "1T Vel", function() if Remotes:FindFirstChild("UpdateLeaderstats") then Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Velocidade", 1e12) notify("Stats", "Vel +1T", 1) end end, Colors.Gold)
CreateSectionLabel(StatsTab, "Rebirth/Level")
CreateButton(StatsTab, "Rebirth +999", function() if Remotes:FindFirstChild("UpdateLeaderstats") then Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Rebirth", 999) notify("Stats", "Rebirth +999", 1) end end, Colors.Success)
CreateButton(StatsTab, "Level +100", function() if Remotes:FindFirstChild("UpdateLeaderstats") then Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Nivel", 100) notify("Stats", "Level +100", 1) end end, Colors.Accent)

-- SPAWN
CreateSectionLabel(SpawnTab, "Spawn")
CreateButton(SpawnTab, "Noob", function() if Remotes:FindFirstChild("SpawnThing") then Remotes.SpawnThing:FireServer("Noob", "Default", "Common") notify("Spawn", "Noob", 1) end end, Colors.Success)
CreateButton(SpawnTab, "Skibbidi", function() if Remotes:FindFirstChild("SpawnThing") then Remotes.SpawnThing:FireServer("Skibbidi", "Default", "Common") notify("Spawn", "Skibbidi", 1) end end, Colors.Success)
CreateButton(SpawnTab, "Roblox", function() if Remotes:FindFirstChild("SpawnThing") then Remotes.SpawnThing:FireServer("Roblox", "Default", "Common") notify("Spawn", "Roblox", 1) end end, Colors.Success)
CreateSectionLabel(SpawnTab, "Race")
CreateButton(SpawnTab, "Race 10x", function() if Remotes:FindFirstChild("SpawnThingRace") then for i = 1, 10 do Remotes.SpawnThingRace:FireServer("Noob", "Shiny") task.wait(0.1) end notify("Race", "10x", 1) end end, Colors.Warning)

-- EVENT
CreateSectionLabel(EventTab, "Skip")
CreateButton(EventTab, "Skip 1x", function() if Remotes:FindFirstChild("Eventos") then Remotes.Eventos:FireServer("EventoAtual") notify("Event", "1x", 1) end end, Colors.Success)
CreateButton(EventTab, "Skip 10x", function() if Remotes:FindFirstChild("Eventos") then for i = 1, 10 do Remotes.Eventos:FireServer("EventoAtual") task.wait(0.1) end notify("Event", "10x", 1) end end, Colors.Success)
CreateSectionLabel(EventTab, "Tsunami")
CreateButton(EventTab, "Tsunami Rain", function() if Remotes:FindFirstChild("TsunamiRain") then Remotes.TsunamiRain:FireServer("Tsunami1") notify("Tsunami", "OK", 1) end end, Colors.Warning)

-- ROLETA
CreateSectionLabel(RoletaTab, "Roleta Bypass")
CreateButton(RoletaTab, "Dinheiro", function() if Remotes:FindFirstChild("AcabouRoleta") then Remotes.AcabouRoleta:FireServer(2) notify("Roleta", "Dinheiro", 1) end end, Colors.Gold)
CreateButton(RoletaTab, "Moedas", function() if Remotes:FindFirstChild("AcabouRoleta") then Remotes.AcabouRoleta:FireServer(3) notify("Roleta", "Moedas", 1) end end, Colors.Gold)
CreateButton(RoletaTab, "10x Rápido", function() if Remotes:FindFirstChild("AcabouRoleta") then for i = 1, 10 do Remotes.AcabouRoleta:FireServer(2) task.wait(0.05) end notify("Roleta", "10x", 1) end end, Colors.Gold)

-- ADMIN
CreateSectionLabel(AdminTab, "Admin")
CreateButton(AdminTab, "Anuncio", function() if Remotes:FindFirstChild("AnnouncementGlobal") then Remotes.AnnouncementGlobal:FireServer("[ADMIN] " .. LocalPlayer.Name) notify("Admin", "OK", 1) end end, Colors.Warning)
CreateButton(AdminTab, "VIP pra vc", function() if Remotes:FindFirstChild("ConferirVip") then Remotes.ConferirVip:FireServer(LocalPlayer.UserId) notify("VIP", "OK", 1) end end, Colors.Gold)
CreateButton(AdminTab, "VIP pra TODOS", function() if Remotes:FindFirstChild("ConferirVip") then for _, p in pairs(Players:GetPlayers()) do Remotes.ConferirVip:FireServer(p.UserId) task.wait(0.05) end notify("VIP", "TODOS!", 2) end end, Colors.Gold)

-- ============================
-- ABA: ROUBAR (TODAS AS 312 LINHAS ORIGINAIS)
-- ============================
CreateSectionLabel(RoubarTab, "Roubar Brainrot (bypass pagamento)")

local InfoLabel1 = Instance.new("TextLabel")
InfoLabel1.Size = UDim2.new(1, 0, 0, 16)
InfoLabel1.BackgroundTransparency = 1
InfoLabel1.Text = "Selecione um jogador e slot"
InfoLabel1.TextColor3 = Colors.Warning
InfoLabel1.TextSize = 9
InfoLabel1.Font = Enum.Font.Gotham
InfoLabel1.TextWrapped = true
InfoLabel1.ZIndex = 9
InfoLabel1.Parent = RoubarTab

local TargetRow = Instance.new("Frame")
TargetRow.Size = UDim2.new(1, 0, 0, 30)
TargetRow.BackgroundColor3 = Colors.Element
TargetRow.BackgroundTransparency = 0.40
TargetRow.BorderSizePixel = 0
TargetRow.ZIndex = 9
TargetRow.Parent = RoubarTab
Corner(TargetRow, 6)
Stroke(TargetRow, Colors.Border, 1)

local TargetLbl = Instance.new("TextLabel")
TargetLbl.Size = UDim2.new(0, 60, 1, 0)
TargetLbl.Position = UDim2.new(0, 8, 0, 0)
TargetLbl.BackgroundTransparency = 1
TargetLbl.Text = "Alvo:"
TargetLbl.TextColor3 = Colors.Text
TargetLbl.TextSize = 10
TargetLbl.Font = Enum.Font.Gotham
TargetLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetLbl.ZIndex = 10
TargetLbl.Parent = TargetRow

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1, -80, 0, 22)
TargetInput.Position = UDim2.new(0, 68, 0.5, -11)
TargetInput.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TargetInput.BorderSizePixel = 0
TargetInput.Text = ""
TargetInput.PlaceholderText = "Nome"
TargetInput.TextColor3 = Colors.Accent
TargetInput.TextSize = 11
TargetInput.Font = Enum.Font.GothamBold
TargetInput.ClearTextOnFocus = false
TargetInput.ZIndex = 10
TargetInput.Parent = TargetRow
Corner(TargetInput, 3)

local SlotRow = Instance.new("Frame")
SlotRow.Size = UDim2.new(1, 0, 0, 30)
SlotRow.BackgroundColor3 = Colors.Element
SlotRow.BackgroundTransparency = 0.40
SlotRow.BorderSizePixel = 0
SlotRow.ZIndex = 9
SlotRow.Parent = RoubarTab
Corner(SlotRow, 6)
Stroke(SlotRow, Colors.Border, 1)

local SlotLbl = Instance.new("TextLabel")
SlotLbl.Size = UDim2.new(0, 60, 1, 0)
SlotLbl.Position = UDim2.new(0, 8, 0, 0)
SlotLbl.BackgroundTransparency = 1
SlotLbl.Text = "Slot:"
SlotLbl.TextColor3 = Colors.Text
SlotLbl.TextSize = 10
SlotLbl.Font = Enum.Font.Gotham
SlotLbl.TextXAlignment = Enum.TextXAlignment.Left
SlotLbl.ZIndex = 10
SlotLbl.Parent = SlotRow

local SlotInput = Instance.new("TextBox")
SlotInput.Size = UDim2.new(1, -80, 0, 22)
SlotInput.Position = UDim2.new(0, 68, 0.5, -11)
SlotInput.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
SlotInput.BorderSizePixel = 0
SlotInput.Text = "Slot1"
SlotInput.PlaceholderText = "Slot1, Slot2..."
SlotInput.TextColor3 = Colors.Accent
SlotInput.TextSize = 11
SlotInput.Font = Enum.Font.GothamBold
SlotInput.ClearTextOnFocus = false
SlotInput.ZIndex = 10
SlotInput.Parent = SlotRow
Corner(SlotInput, 3)

CreateButton(RoubarTab, "ROUBAR BRAINROT (FREE)", function()
    local targetName = TargetInput.Text
    local slotName = SlotInput.Text
    
    if targetName == "" or targetName == LocalPlayer.Name then
        notify("Erro", "Nome inválido", 2)
        return
    end
    if slotName == "" then
        notify("Erro", "Slot vazio", 2)
        return
    end
    
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then
        notify("Erro", "Jogador não encontrado", 2)
        return
    end
    
    local targetBase = nil
    for _, base in pairs(workspace.Bases:GetChildren()) do
        local config = base:FindFirstChild("Configuration")
        if config then
            local playerVal = config:FindFirstChild("Player")
            if playerVal and playerVal.Value == targetName then
                targetBase = base
                break
            end
        end
    end
    
    if not targetBase then
        notify("Erro", "Base não encontrada", 2)
        return
    end
    
    local slot = targetBase.Slots:FindFirstChild(slotName)
    if not slot then
        notify("Erro", "Slot não encontrado", 2)
        return
    end
    
    local brainrotFolder = slot:FindFirstChild("Brainrot")
    if not brainrotFolder or #brainrotFolder:GetChildren() == 0 then
        notify("Erro", "Slot vazio", 2)
        return
    end
    
    local brainrotModel = brainrotFolder:FindFirstChildOfClass("Model")
    local raridadeValue = brainrotModel and brainrotModel:FindFirstChild("raridade")
    local productId = 0
    
    if raridadeValue then
        local success, raridades = pcall(function()
            return ReplicatedStorage.Remotes.GetRaridades:Invoke()
        end)
        if success and raridades and raridades[raridadeValue.Value] then
            productId = raridades[raridadeValue.Value].productId or 0
        end
    end
    
    if Remotes:FindFirstChild("Comprar") then
        Remotes.Comprar:FireServer(productId, slotName, targetName)
        notify("Roubar", "Enviando roubo...", 2)
    else
        notify("Erro", "Remote não encontrado", 2)
    end
end, Colors.Danger)

CreateSectionLabel(RoubarTab, "Auto-Scan Bases")

CreateButton(RoubarTab, "Listar Bases", function()
    local basesInfo = {}
    for _, base in pairs(workspace.Bases:GetChildren()) do
        local config = base:FindFirstChild("Configuration")
        if config then
            local playerVal = config:FindFirstChild("Player")
            if playerVal and playerVal.Value ~= "" then
                local slotsOcupados = 0
                for _, slot in pairs(base.Slots:GetChildren()) do
                    local brainrot = slot:FindFirstChild("Brainrot")
                    if brainrot and #brainrot:GetChildren() > 0 then
                        slotsOcupados = slotsOcupados + 1
                    end
                end
                table.insert(basesInfo, {nome = base.Name, dono = playerVal.Value, slots = slotsOcupados})
            end
        end
    end
    
    if #basesInfo == 0 then
        notify("Scan", "Nenhuma base", 2)
        return
    end
    
    print("=" .. string.rep("=", 40))
    print("BASES OCUPADAS:")
    for _, info in ipairs(basesInfo) do
        print(string.format("  %s | Dono: %s | Slots: %d", info.nome, info.dono, info.slots))
    end
    print("=" .. string.rep("=", 40))
    
    notify("Scan", #basesInfo .. " bases", 2)
end, Colors.Success)

CreateButton(RoubarTab, "Roubar TODOS slots", function()
    local targetName = TargetInput.Text
    if targetName == "" or targetName == LocalPlayer.Name then
        notify("Erro", "Nome inválido", 2)
        return
    end
    
    local targetBase = nil
    for _, base in pairs(workspace.Bases:GetChildren()) do
        local config = base:FindFirstChild("Configuration")
        if config then
            local playerVal = config:FindFirstChild("Player")
            if playerVal and playerVal.Value == targetName then
                targetBase = base
                break
            end
        end
    end
    
    if not targetBase then
        notify("Erro", "Base não encontrada", 2)
        return
    end
    
    local roubados = 0
    for _, slot in pairs(targetBase.Slots:GetChildren()) do
        local brainrot = slot:FindFirstChild("Brainrot")
        if brainrot and #brainrot:GetChildren() > 0 then
            local brainrotModel = brainrot:FindFirstChildOfClass("Model")
            local raridadeValue = brainrotModel and brainrotModel:FindFirstChild("raridade")
            local productId = 0
            
            if raridadeValue then
                local success, raridades = pcall(function()
                    return ReplicatedStorage.Remotes.GetRaridades:Invoke()
                end)
                if success and raridades and raridades[raridadeValue.Value] then
                    productId = raridades[raridadeValue.Value].productId or 0
                end
            end
            
            if Remotes:FindFirstChild("Comprar") then
                Remotes.Comprar:FireServer(productId, slot.Name, targetName)
                roubados = roubados + 1
            end
            task.wait(0.2)
        end
    end
    
    notify("Roubar", "Tentou roubar " .. roubados, 2)
end, Colors.Danger)

CreateSectionLabel(RoubarTab, "Auto-Roubar (loop)")

local AutoStealEnabled = false
local AutoStealBtn = CreateButton(RoubarTab, "Auto-Roubar: OFF", function()
    AutoStealEnabled = not AutoStealEnabled
    AutoStealBtn.Text = AutoStealEnabled and "Auto-Roubar: ON" or "Auto-Roubar: OFF"
    AutoStealBtn.BackgroundColor3 = AutoStealEnabled and Colors.Danger or Colors.Accent
    
    if AutoStealEnabled then
        notify("Auto-Roubar", "Ativado!", 2)
        task.spawn(function()
            while AutoStealEnabled do
                for _, base in pairs(workspace.Bases:GetChildren()) do
                    if not AutoStealEnabled then break end
                    local config = base:FindFirstChild("Configuration")
                    if config then
                        local playerVal = config:FindFirstChild("Player")
                        if playerVal and playerVal.Value ~= "" and playerVal.Value ~= LocalPlayer.Name then
                            for _, slot in pairs(base.Slots:GetChildren()) do
                                if not AutoStealEnabled then break end
                                local brainrot = slot:FindFirstChild("Brainrot")
                                if brainrot and #brainrot:GetChildren() > 0 then
                                    local brainrotModel = brainrot:FindFirstChildOfClass("Model")
                                    local raridadeValue = brainrotModel and brainrotModel:FindFirstChild("raridade")
                                    local productId = 0
                                    
                                    if raridadeValue then
                                        local success, raridades = pcall(function()
                                            return ReplicatedStorage.Remotes.GetRaridades:Invoke()
                                        end)
                                        if success and raridades and raridades[raridadeValue.Value] then
                                            productId = raridades[raridadeValue.Value].productId or 0
                                        end
                                    end
                                    
                                    if Remotes:FindFirstChild("Comprar") then
                                        Remotes.Comprar:FireServer(productId, slot.Name, playerVal.Value)
                                    end
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)
    else
        notify("Auto-Roubar", "Desativado", 2)
    end
end, Colors.Element)

-- MISC
CreateSectionLabel(MiscTab, "Controles")
CreateButton(MiscTab, "Resetar Posição", function() MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240) end, Colors.Element)
CreateButton(MiscTab, "Fechar Hub", function() ScreenGui:Destroy() end, Colors.Danger)

notify("Brainrot Hub v3.0", "MEGA COMPLETE! 8 abas + ROUBAR", 4)
print("[BrainrotHub v3.0] Carregado 100%! Todas as 312 linhas + funções!")

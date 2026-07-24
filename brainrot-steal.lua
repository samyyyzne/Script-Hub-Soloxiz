--[[
    Brainrot Hub v1.0
    UI estilo Solix/Mavis para Brainrot Tycoon
    Reutiliza os Remotes do jogo (expostos pelo server)
]]

repeat wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 30)

if not Remotes then
    warn("[BrainrotHub] Remotes nao encontrado - jogo nao suportado?")
    return
end

-- ============================
-- LIMPAR UI ANTIGA
-- ============================
for _, gui in pairs({game.CoreGui, (gethui and gethui()) or nil}) do
    if gui and gui:FindFirstChild("BrainrotHub_v1") then
        gui.BrainrotHub_v1:Destroy()
    end
end

-- ============================
-- CORES (estilo Solix)
-- ============================
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

-- ============================
-- UTILITARIOS
-- ============================
local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 6); c.Parent = p
end
local function Stroke(p, c, t)
    local s = Instance.new("UIStroke"); s.Color = c or Colors.Border; s.Thickness = t or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p
end
local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
local function notify(title, desc, duration)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {Title = title, Text = desc, Duration = duration or 3})
    end)
end

-- ============================
-- SCREENGUI
-- ============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHub_v1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

if syn and syn.protect_gui then pcall(syn.protect_gui, ScreenGui) end
local ok = pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    else ScreenGui.Parent = game.CoreGui end
end)
if not ok then ScreenGui.Parent = game.CoreGui end

-- ============================
-- BOLA MINIMIZAR
-- ============================
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

-- Glow
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

-- ============================
-- FRAME PRINCIPAL
-- ============================
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

-- ============================
-- TOP BAR
-- ============================
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
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 32, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Brainrot Hub"
Title.TextColor3 = Colors.Accent
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = TopBar

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 200, 1, 0)
Version.Position = UDim2.new(0, 165, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = "v1.0"
Version.TextColor3 = Colors.TextDim
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.ZIndex = 11
Version.Parent = TopBar

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

-- ============================
-- SIDEBAR
-- ============================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -56)
Sidebar.Position = UDim2.new(0, 0, 0, 54)
Sidebar.BackgroundColor3 = Colors.Background2
Sidebar.BackgroundTransparency = 0.40
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true
Sidebar.ZIndex = 7
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 8)
SidebarPad.PaddingLeft = UDim.new(0, 8)
SidebarPad.PaddingRight = UDim.new(0, 8)
SidebarPad.PaddingBottom = UDim.new(0, 8)
SidebarPad.Parent = Sidebar

-- ============================
-- CONTENT AREA
-- ============================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -56)
ContentArea.Position = UDim2.new(0, 150, 0, 54)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 7
ContentArea.Parent = MainFrame

-- ============================
-- SISTEMA DE ABAS
-- ============================
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.BackgroundColor3 = Colors.Element
    TabButton.BackgroundTransparency = 0.60
    TabButton.Text = name
    TabButton.TextColor3 = Colors.TextDim
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = order
    TabButton.ZIndex = 8
    TabButton.AutoButtonColor = false
    TabButton.Parent = Sidebar
    Corner(TabButton, 6)

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
    TabContent.ScrollBarThickness = 5
    TabContent.ScrollBarImageColor3 = Colors.Accent
    TabContent.ScrollBarImageTransparency = 0.2
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ElasticBehavior = Enum.ElasticBehavior.Never
    TabContent.ZIndex = 8
    TabContent.Parent = Container

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = TabContent

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 12)
    Pad.PaddingLeft = UDim.new(0, 14)
    Pad.PaddingRight = UDim.new(0, 14)
    Pad.PaddingBottom = UDim.new(0, 12)
    Pad.Parent = TabContent

    local function updateCanvas()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 24)
    end
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    task.defer(updateCanvas)

    Tabs[name] = {
        Button = TabButton,
        Container = Container,
        Content = TabContent,
        Layout = Layout,
    }

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab == name then return end
        for n, t in pairs(Tabs) do
            t.Container.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {
                BackgroundColor3 = Colors.Element,
                BackgroundTransparency = 0.60,
                TextColor3 = Colors.TextDim
            }):Play()
        end
        Container.Visible = true
        updateCanvas()
        TweenService:Create(TabButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Colors.Accent,
            BackgroundTransparency = 0.10,
            TextColor3 = Colors.Text
        }):Play()
        CurrentTab = name
    end)

    TabButton.MouseEnter:Connect(function()
        if CurrentTab ~= name then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.4, TextColor3 = Colors.Text
            }):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if CurrentTab ~= name then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.6, TextColor3 = Colors.TextDim
            }):Play()
        end
    end)

    return TabContent
end

-- ============================
-- COMPONENTES
-- ============================
local function CreateSectionLabel(parent, text)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 20)
    Section.BackgroundTransparency = 1
    Section.ZIndex = 9
    Section.Parent = parent

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(0, 22, 0, 2)
    Line.Position = UDim2.new(0, 0, 0.5, -1)
    Line.BackgroundColor3 = Colors.Accent
    Line.BorderSizePixel = 0
    Line.ZIndex = 9
    Line.Parent = Section

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -32, 1, 0)
    Lbl.Position = UDim2.new(0, 30, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = string.upper(text)
    Lbl.TextColor3 = Colors.Text
    Lbl.TextSize = 11
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextYAlignment = Enum.TextYAlignment.Center
    Lbl.ZIndex = 9
    Lbl.Parent = Section
end

local function CreateButton(parent, text, callback, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = color or Colors.Accent
    Btn.BackgroundTransparency = 0.10
    Btn.Text = text
    Btn.TextColor3 = Colors.Text
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamSemibold
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.ZIndex = 9
    Btn.Parent = parent
    Corner(Btn, 6)

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.4}):Play()
        task.wait(0.08)
        TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.1}):Play()
        if callback then pcall(callback) end
    end)
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Accent2}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = color or Colors.Accent}):Play()
    end)
    return Btn
end

-- ============================
-- ABAS
-- ============================
local MoneyTab   = CreateTab("Money",   1)
local StatsTab   = CreateTab("Stats",   2)
local SpawnTab   = CreateTab("Spawns",  3)
local EventsTab  = CreateTab("Events",  4)
local AdminTab   = CreateTab("Admin",   5)
local MiscTab    = CreateTab("Misc",    6)

Tabs["Money"].Container.Visible = true
Tabs["Money"].Button.BackgroundColor3 = Colors.Accent
Tabs["Money"].Button.BackgroundTransparency = 0.10
Tabs["Money"].Button.TextColor3 = Colors.Text
CurrentTab = "Money"

-- ============================
-- ABA: MONEY
-- ============================
CreateSectionLabel(MoneyTab, "Money Management")
CreateButton(MoneyTab, "+1B Dinheiro", function()
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Dinheiro", 1e9)
        notify("Money", "+1B Dinheiro!", 2)
    end
end, Colors.Gold)
CreateButton(MoneyTab, "+1B Moedas", function()
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Moedas", 1e9)
        notify("Money", "+1B Moedas!", 2)
    end
end, Colors.Gold)
CreateButton(MoneyTab, "+1B Tokens", function()
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Tokens", 1e9)
        notify("Money", "+1B Tokens!", 2)
    end
end, Colors.Gold)

-- ============================
-- ABA: STATS
-- ============================
CreateSectionLabel(StatsTab, "Aumentar Stats")
CreateButton(StatsTab, "Velocidade MAX (1B)", function()
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Velocidade", 1e9)
        notify("Stats", "Velocidade = 1B", 2)
    end
end, Colors.Gold)
CreateButton(StatsTab, "Rebirth MAX (999)", function()
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Rebirth", 999)
        notify("Stats", "Rebirth = 999", 2)
    end
end, Colors.Gold)

-- ============================
-- ABA: SPAWNS
-- ============================
CreateSectionLabel(SpawnTab, "Spawnar Brainrots")
CreateButton(SpawnTab, "Spawn Noob", function()
    if Remotes:FindFirstChild("SpawnThing") then
        Remotes.SpawnThing:FireServer("Noob", "Default", "Common")
        notify("Spawn", "Noob spawnado!", 2)
    end
end, Colors.Success)
CreateButton(SpawnTab, "Spawn Skibbidi", function()
    if Remotes:FindFirstChild("SpawnThing") then
        Remotes.SpawnThing:FireServer("Skibbidi", "Default", "Common")
        notify("Spawn", "Skibbidi spawnado!", 2)
    end
end, Colors.Success)
CreateButton(SpawnTab, "Spawn Roblox", function()
    if Remotes:FindFirstChild("SpawnThing") then
        Remotes.SpawnThing:FireServer("Roblox", "Default", "Common")
        notify("Spawn", "Roblox spawnado!", 2)
    end
end, Colors.Success)

-- ============================
-- ABA: EVENTS
-- ============================
CreateSectionLabel(EventsTab, "Eventos")
CreateButton(EventsTab, "Skip Evento Atual", function()
    if Remotes:FindFirstChild("Eventos") then
        Remotes.Eventos:FireServer("EventoAtual")
        notify("Eventos", "Evento skipado!", 2)
    end
end, Colors.Success)
CreateButton(EventsTab, "Skip 10x", function()
    if Remotes:FindFirstChild("Eventos") then
        for i = 1, 10 do
            Remotes.Eventos:FireServer("EventoAtual")
            task.wait(0.1)
        end
        notify("Eventos", "10x skip!", 2)
    end
end, Colors.Success)

-- ============================
-- ABA: ADMIN
-- ============================
CreateSectionLabel(AdminTab, "Admin Functions")
CreateButton(AdminTab, "Anuncio Global", function()
    if Remotes:FindFirstChild("AnnouncementGlobal") then
        Remotes.AnnouncementGlobal:FireServer("[ADMIN] " .. LocalPlayer.Name .. " toma conta!")
        notify("Admin", "Anuncio enviado!", 2)
    end
end, Colors.Warning)

-- ============================
-- ABA: MISC
-- ============================
CreateSectionLabel(MiscTab, "Sobre")
CreateButton(MiscTab, "Resetar Posicao", function()
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
end, Colors.Element)
CreateButton(MiscTab, "Fechar Hub", function()
    ScreenGui:Destroy()
end, Colors.Danger)

notify("Brainrot Hub v1.0", "Carregado! 6 abas com funcoes principais", 4)
print("[BrainrotHub v1.0] Carregado com sucesso!")

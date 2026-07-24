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
    Accent        = Color3.fromRGB(232, 186, 248),  -- roxo Solix
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
        if Remotes and Remotes:FindFirstChild("Notification") then
            Remotes.Notification:FireServer("[" .. title .. "] " .. desc, "140072726814802")
        else
            game.StarterGui:SetCore("SendNotification", {Title = title, Text = desc, Duration = duration or 3})
        end
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

-- Gradiente
local BgGrad = Instance.new("UIGradient")
BgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 22, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 12))
})
BgGrad.Rotation = 45
BgGrad.Parent = MainFrame

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

local TopBarFill = Instance.new("Frame")
TopBarFill.Size = UDim2.new(1, 0, 0, 12)
TopBarFill.Position = UDim2.new(0, 0, 1, -12)
TopBarFill.BackgroundColor3 = Colors.Background2
TopBarFill.BackgroundTransparency = 0.20
TopBarFill.BorderSizePixel = 0
TopBarFill.ZIndex = 9
TopBarFill.Parent = TopBar

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
Version.Text = "v1.0  -  by Mavis"
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
-- SISTEMA DE ABAS (com scroll custom)
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

    -- Container com scroll custom
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

    local function scrollBy(amt)
        local max = math.max(0, TabContent.AbsoluteCanvasSize.Y - TabContent.AbsoluteSize.Y)
        TabContent.CanvasPosition = Vector2.new(0, math.clamp(TabContent.CanvasPosition.Y.Offset + amt, 0, max))
    end

    Tabs[name] = {
        Button = TabButton,
        Container = Container,
        Content = TabContent,
        Layout = Layout,
        ScrollBy = scrollBy,
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

local function CreateInfoLabel(parent, text, color)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 20)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = color or Colors.TextDim
    Lbl.TextSize = 12
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 9
    Lbl.Parent = parent
    return Lbl
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

local function CreateSecondaryButton(parent, text, callback)
    return CreateButton(parent, text, callback, Colors.Element)
end

-- Input numerico + botao "DEFINIR"
local function CreateAmountInput(parent, label, defaultValue, onSet)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 40)
    Row.BackgroundColor3 = Colors.Element
    Row.BackgroundTransparency = 0.40
    Row.BorderSizePixel = 0
    Row.ZIndex = 9
    Row.Parent = parent
    Corner(Row, 6)
    Stroke(Row, Colors.Border, 1)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 130, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = label
    Lbl.TextColor3 = Colors.Text
    Lbl.TextSize = 12
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 10
    Lbl.Parent = Row

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 110, 0, 26)
    Input.Position = UDim2.new(0, 140, 0.5, -13)
    Input.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Input.BorderSizePixel = 0
    Input.Text = tostring(defaultValue)
    Input.PlaceholderText = "Numero"
    Input.TextColor3 = Colors.Accent
    Input.TextSize = 13
    Input.Font = Enum.Font.GothamBold
    Input.ClearTextOnFocus = false
    Input.ZIndex = 10
    Input.Parent = Row
    Corner(Input, 4)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 80, 0, 26)
    Btn.Position = UDim2.new(1, -90, 0.5, -13)
    Btn.BackgroundColor3 = Colors.Success
    Btn.BackgroundTransparency = 0.15
    Btn.Text = "DEFINIR"
    Btn.TextColor3 = Colors.Text
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Btn.ZIndex = 10
    Btn.Parent = Row
    Corner(Btn, 4)

    Btn.MouseButton1Click:Connect(function()
        local v = tonumber(Input.Text)
        if not v then
            notify("Erro", "Digite um numero valido", 2)
            return
        end
        v = math.floor(v)
        if v < -1e9 then v = -1e9 end
        if v > 1e9 then v = 1e9 end
        if onSet then pcall(onSet, v) end
    end)

    return Row
end

-- ============================
-- ABAS
-- ============================
local MoneyTab   = CreateTab("Money",   1)
local StatsTab   = CreateTab("Stats",   2)
local UpgradeTab = CreateTab("Upgrade", 3)
local SpawnTab   = CreateTab("Spawns",  4)
local EventsTab  = CreateTab("Events",  5)
local RoletaTab  = CreateTab("Roletas", 6)
local AdminTab   = CreateTab("Admin",   7)
local MiscTab    = CreateTab("Misc",    8)

Tabs["Money"].Container.Visible = true
Tabs["Money"].Button.BackgroundColor3 = Colors.Accent
Tabs["Money"].Button.BackgroundTransparency = 0.10
Tabs["Money"].Button.TextColor3 = Colors.Text
CurrentTab = "Money"

-- ============================
-- ABA: MONEY
-- ============================
CreateSectionLabel(MoneyTab, "Adicionar ao saldo (quantidade customizavel)")

CreateAmountInput(MoneyTab, "Dinheiro", 1000000, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Dinheiro", v)
        notify("Money", "+" .. tostring(v) .. " Dinheiro", 2)
    end
end)
CreateAmountInput(MoneyTab, "Moedas", 999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Moedas", v)
        notify("Money", "+" .. tostring(v) .. " Moedas", 2)
    end
end)
CreateAmountInput(MoneyTab, "Tokens", 999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Tokens", v)
        notify("Money", "+" .. tostring(v) .. " Tokens", 2)
    end
end)

CreateSectionLabel(MoneyTab, "Definir valor exato (set, nao soma)")
CreateAmountInput(MoneyTab, "Set Dinheiro", 999999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Dinheiro", v)
        notify("Set", "Dinheiro = " .. tostring(v), 2)
    end
end)
CreateAmountInput(MoneyTab, "Set Moedas", 999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Moedas", v)
        notify("Set", "Moedas = " .. tostring(v), 2)
    end
end)
CreateAmountInput(MoneyTab, "Set Tokens", 999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Tokens", v)
        notify("Set", "Tokens = " .. tostring(v), 2)
    end
end)

CreateSectionLabel(MoneyTab, "Max shortcuts (1 bilhao)")
CreateButton(MoneyTab, "+1B Dinheiro (instantaneo)", function()
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Dinheiro", 1e9)
        notify("Money", "+1B Dinheiro!", 2)
    end
end, Colors.Gold)
CreateButton(MoneyTab, "+1B Moedas (instantaneo)", function()
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Moedas", 1e9)
        notify("Money", "+1B Moedas!", 2)
    end
end, Colors.Gold)
CreateButton(MoneyTab, "+1B Tokens (instantaneo)", function()
    if Remotes:FindFirstChild("UpdateLeaderstatsAdicionar") then
        Remotes.UpdateLeaderstatsAdicionar:FireServer(LocalPlayer.Name, "Tokens", 1e9)
        notify("Money", "+1B Tokens!", 2)
    end
end, Colors.Gold)

-- ============================
-- ABA: STATS
-- ============================
CreateSectionLabel(StatsTab, "Stats do jogador (valor customizavel)")
CreateAmountInput(StatsTab, "Velocidade", 999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Velocidade", v)
        notify("Stats", "Velocidade = " .. tostring(v), 2)
    end
end)
CreateAmountInput(StatsTab, "Rebirth", 999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Rebirth", v)
        notify("Stats", "Rebirth = " .. tostring(v), 2)
    end
end)
CreateAmountInput(StatsTab, "Nivel", 999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Nivel", v)
        notify("Stats", "Nivel = " .. tostring(v), 2)
    end
end)
CreateAmountInput(StatsTab, "XP", 999999, function(v)
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "XP", v)
        notify("Stats", "XP = " .. tostring(v), 2)
    end
end)

CreateSectionLabel(StatsTab, "Max Stats")
CreateButton(StatsTab, "Set VELOCIDADE MAX (1B)", function()
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Velocidade", 1e9)
        notify("Stats", "Velocidade = 1B", 2)
    end
end, Colors.Gold)
CreateButton(StatsTab, "Set REBIRTH MAX (999)", function()
    if Remotes:FindFirstChild("UpdateLeaderstats") then
        Remotes.UpdateLeaderstats:FireServer(LocalPlayer.Name, "Rebirth", 999)
        notify("Stats", "Rebirth = 999", 2)
    end
end, Colors.Gold)

-- ============================
-- ABA: UPGRADE
-- ============================
CreateSectionLabel(UpgradeTab, "Upgrade gratis (config customizada)")
CreateInfoLabel(UpgradeTab, "Config completa: Velocidade, Custo, MultiplicadorCusto", Colors.TextDim)

CreateButton(UpgradeTab, "Upgrade GRATIS Max", function()
    if Remotes:FindFirstChild("UpgradeBuy") then
        Remotes.UpgradeBuy:FireServer({Velocidade = 999, Custo = 0, MultiplicadorCusto = 1})
        notify("Upgrade", "Upgrade gratis max aplicado!", 2)
    end
end, Colors.Success)
CreateButton(UpgradeTab, "Upgrade Velocidade 9999", function()
    if Remotes:FindFirstChild("UpgradeBuy") then
        Remotes.UpgradeBuy:FireServer({Velocidade = 9999, Custo = 0, MultiplicadorCusto = 1})
        notify("Upgrade", "+9999 velocidade", 2)
    end
end, Colors.Success)

CreateSectionLabel(UpgradeTab, "Rebirth gratis")
CreateButton(UpgradeTab, "Rebirth Gratis (2 tiers)", function()
    if Remotes:FindFirstChild("Rebirth") then
        local cfg = {[1] = {Custo = 0, DinheiroMulti = 999}, [2] = {Custo = 0, DinheiroMulti = 9999}}
        Remotes.Rebirth:FireServer(cfg, false)
        notify("Rebirth", "Rebirth gratis aplicado!", 2)
    end
end, Colors.Success)
CreateButton(UpgradeTab, "Rebirth Gratis (5 tiers max)", function()
    if Remotes:FindFirstChild("Rebirth") then
        local cfg = {}
        for i = 1, 5 do
            cfg[i] = {Custo = 0, DinheiroMulti = 99999}
        end
        Remotes.Rebirth:FireServer(cfg, false)
        notify("Rebirth", "Rebirth 5 tiers gratis!", 2)
    end
end, Colors.Success)

-- ============================
-- ABA: SPAWNS
-- ============================
CreateSectionLabel(SpawnTab, "Spawnar Brainrot (digite o nome)")

-- Input + botao Spawn
local SpawnRow = Instance.new("Frame")
SpawnRow.Size = UDim2.new(1, 0, 0, 40)
SpawnRow.BackgroundColor3 = Colors.Element
SpawnRow.BackgroundTransparency = 0.40
SpawnRow.BorderSizePixel = 0
SpawnRow.ZIndex = 9
SpawnRow.Parent = SpawnTab
Corner(SpawnRow, 6)
Stroke(SpawnRow, Colors.Border, 1)

local SpawnInput = Instance.new("TextBox")
SpawnInput.Size = UDim2.new(1, -100, 0, 26)
SpawnInput.Position = UDim2.new(0, 12, 0.5, -13)
SpawnInput.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
SpawnInput.BorderSizePixel = 0
SpawnInput.Text = "Noob"
SpawnInput.PlaceholderText = "Nome do brainrot (ex: Skibbidi)"
SpawnInput.TextColor3 = Colors.Accent
SpawnInput.TextSize = 13
SpawnInput.Font = Enum.Font.GothamBold
SpawnInput.ClearTextOnFocus = false
SpawnInput.ZIndex = 10
SpawnInput.Parent = SpawnRow
Corner(SpawnInput, 4)

local SpawnBtn = Instance.new("TextButton")
SpawnBtn.Size = UDim2.new(0, 80, 0, 26)
SpawnBtn.Position = UDim2.new(1, -90, 0.5, -13)
SpawnBtn.BackgroundColor3 = Colors.Success
SpawnBtn.BackgroundTransparency = 0.15
SpawnBtn.Text = "SPAWN"
SpawnBtn.TextColor3 = Colors.Text
SpawnBtn.TextSize = 11
SpawnBtn.Font = Enum.Font.GothamBold
SpawnBtn.BorderSizePixel = 0
SpawnBtn.ZIndex = 10
SpawnBtn.Parent = SpawnRow
Corner(SpawnBtn, 4)

SpawnBtn.MouseButton1Click:Connect(function()
    local name = SpawnInput.Text
    if name == "" then notify("Erro", "Digite um nome", 2) return end
    if Remotes:FindFirstChild("SpawnThing") then
        Remotes.SpawnThing:FireServer(name, "Default", "Common")
        notify("Spawn", name .. " spawnado!", 2)
    end
end)

CreateSectionLabel(SpawnTab, "Seletor de MUTACAO (clique pra mudar)")

-- Mutacoes (baseado nos prints)
local Mutations = {
    {name = "Default",    color = Color3.fromRGB(180, 180, 180)},
    {name = "Diamante",   color = Color3.fromRGB(100, 200, 255)},
    {name = "Esmeralda",  color = Color3.fromRGB(80, 230, 120)},
    {name = "Gold",       color = Color3.fromRGB(255, 200, 50)},
    {name = "Common",     color = Color3.fromRGB(120, 220, 100)},
    {name = "UnCommon",   color = Color3.fromRGB(80, 180, 220)},
    {name = "Rare",       color = Color3.fromRGB(80, 130, 255)},
    {name = "Epic",       color = Color3.fromRGB(180, 80, 255)},
    {name = "Legendary",  color = Color3.fromRGB(255, 180, 50)},
    {name = "Mythic",     color = Color3.fromRGB(255, 60, 80)},
    {name = "Secret",     color = Color3.fromRGB(255, 100, 200)},
    {name = "Celestial",  color = Color3.fromRGB(180, 130, 255)},
    {name = "Cosmic",     color = Color3.fromRGB(120, 80, 200)},
    {name = "Divine",     color = Color3.fromRGB(255, 220, 80)},
    {name = "Burger",     color = Color3.fromRGB(255, 140, 50)},
}

local SelectedMutation = "Default"

local MutRow1 = Instance.new("Frame")
MutRow1.Size = UDim2.new(1, 0, 0, 28)
MutRow1.BackgroundTransparency = 1
MutRow1.ZIndex = 9
MutRow1.Parent = SpawnTab
local MutRow1L = Instance.new("UIListLayout")
MutRow1L.FillDirection = Enum.FillDirection.Horizontal
MutRow1L.Padding = UDim.new(0, 3)
MutRow1L.Parent = MutRow1

local MutRow2 = Instance.new("Frame")
MutRow2.Size = UDim2.new(1, 0, 0, 28)
MutRow2.BackgroundTransparency = 1
MutRow2.ZIndex = 9
MutRow2.Parent = SpawnTab
local MutRow2L = Instance.new("UIListLayout")
MutRow2L.FillDirection = Enum.FillDirection.Horizontal
MutRow2L.Padding = UDim.new(0, 3)
MutRow2L.Parent = MutRow2

local mutButtons = {}
for i, m in ipairs(Mutations) do
    local row = i <= 8 and MutRow1 or MutRow2
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.125, -2, 1, 0)
    b.BackgroundColor3 = m.color
    b.BackgroundTransparency = m.name == SelectedMutation and 0 or 0.6
    b.Text = m.name
    b.TextColor3 = Colors.Text
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 10
    b.Parent = row
    Corner(b, 4)
    mutButtons[m.name] = b

    b.MouseButton1Click:Connect(function()
        SelectedMutation = m.name
        for n, btn in pairs(mutButtons) do
            local mt = Mutations[0]
            for _, mm in ipairs(Mutations) do
                if mm.name == n then mt = mm; break end
            end
            btn.BackgroundTransparency = n == SelectedMutation and 0 or 0.6
        end
        notify("Mutacao", m.name, 1)
    end)
end

CreateInfoLabel(SpawnTab, "Mutacao selecionada: " .. SelectedMutation, Colors.Accent)
local MutInfo = CreateInfoLabel(SpawnTab, "Clique num brainrot abaixo pra spawnar com a mutacao", Colors.TextDim)
-- Atualiza label quando muda
for i, m in ipairs(Mutations) do
    local b = mutButtons[m.name]
    b.MouseButton1Click:Connect(function()
        if MutInfo and MutInfo.Parent then
            local cm = Colors.Accent
            for _, mm in ipairs(Mutations) do
                if mm.name == SelectedMutation then cm = mm.color; break end
            end
            MutInfo.Text = "Mutacao: " .. SelectedMutation .. " | Clique num brainrot pra spawnar"
            MutInfo.TextColor3 = cm
        end
    end)
end

CreateSectionLabel(SpawnTab, "Lista de Brainrots (28 paginas do jogo)")

-- Brainrots baseados nos prints do jogo
local Brainrots = {
    "Noob", "Bacon", "BaconGirl", "Common Lucky Block",
    "DonateKingP", "UnCommon Lucky Block", "N1CO_2.0", "Rare Lucky Block",
    "DuduBetero", "Builderman", "Secret Lucky Block", "LuanClashWar",
    "mateusedgarDEV", "xMarcelo", "Celestial Lucky Block", "Los mateusedgarDEV",
    "NoobSapiens", "TwinPlayz", "Los Noob", "Mythic Lucky Block",
    "AlexKaboom", "Myster0y", "Cosmic Lucky Block", "ClashON_Lucas",
    "Steak", "Epic Lucky Block", "Roblox", "Legendary Lucky Block",
    -- Extras comuns
    "Sign", "Bat", "mateus", "edgar", "DEV",
    "TungTungTung", "Sahur", "BombardiroCrocodilo", "TrippiTroppi",
    "LiriliLarila", "BonecaAmbalabu", "ChimpanziniBananini", "FrulliFrulla",
    "GlorboFruttodrillo", "GangsterFootera", "CavalloVirtuoso", "PipiPoipoi",
    "BrrBrrPatapim", "TrulimeroTrulicina", "Tralaledon", "PandacciniBananini",
    "BobrittoBandito", "PenguinoCocoso", "TigrinhoTatata", "CocofantoElefanto",
    "GirafaCelestre", "RalcalaCacaus", "BombombiniGusini", "CappuccinoAssassino",
    "Matteo", "Spaghettini", "Lasagna", "Tortellino", "Macaroni",
    "Burger", "Pizza", "Taco", "HotDog", "Sushi",
    "Cat", "Dog", "Rat", "Frog", "Duck",
    "NoobClassic", "Guest1337", "Builderman", "Stickmasterluke", "Shedletsky",
    "Roblox", "ROBLOX", "Brick", "Stud", "Trowel",
    "Sigma", "Skibbidi", "Gyatt", "Rizz", "Fanum", "Ohio", "Mewing", "Looksmax",
    "Meme", "Gigachad", "Chad", "Soyjak", "Wojak", "NPC", "TouchGrass",
}

-- Organiza em botoes de 3 por linha
local currentRow = nil
for i, name in ipairs(Brainrots) do
    if (i - 1) % 3 == 0 then
        currentRow = Instance.new("Frame")
        currentRow.Size = UDim2.new(1, 0, 0, 30)
        currentRow.BackgroundTransparency = 1
        currentRow.ZIndex = 9
        currentRow.Parent = SpawnTab

        local rowLayout = Instance.new("UIListLayout")
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.Padding = UDim.new(0, 4)
        rowLayout.Parent = currentRow
    end

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.333, -3, 1, 0)
    b.BackgroundColor3 = Colors.Element
    b.BackgroundTransparency = 0.30
    b.Text = name
    b.TextColor3 = Colors.Text
    b.TextSize = 9
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 10
    b.TextTruncate = Enum.TextTruncate.AtEnd
    b.Parent = currentRow
    Corner(b, 4)

    b.MouseButton1Click:Connect(function()
        if Remotes:FindFirstChild("SpawnThing") then
            Remotes.SpawnThing:FireServer(name, SelectedMutation, "Common")
            notify("Spawn", name .. " (" .. SelectedMutation .. ")", 1)
        end
    end)
end

CreateSectionLabel(SpawnTab, "Spawn em RACE (Shiny)")
CreateButton(SpawnTab, "Spawn RACE (qualquer brainrot)", function()
    if Remotes:FindFirstChild("SpawnThingRace") then
        local name = SpawnInput.Text ~= "" and SpawnInput.Text or "Noob"
        Remotes.SpawnThingRace:FireServer(name, "Shiny")
        notify("Race", "Race com " .. name .. " (Shiny)!", 2)
    end
end, Colors.Warning)
CreateButton(SpawnTab, "Spawn RACE 10x em sequencia", function()
    if Remotes:FindFirstChild("SpawnThingRace") then
        local name = SpawnInput.Text ~= "" and SpawnInput.Text or "Noob"
        for i = 1, 10 do
            Remotes.SpawnThingRace:FireServer(name, "Shiny")
            task.wait(0.15)
        end
        notify("Race", "10 races " .. name .. " Shiny!", 2)
    end
end, Colors.Warning)

-- ============================
-- ABA: EVENTS
-- ============================
CreateSectionLabel(EventsTab, "Eventos do jogo")
CreateButton(EventsTab, "Skip Evento Atual", function()
    if Remotes:FindFirstChild("Eventos") then
        Remotes.Eventos:FireServer("EventoAtual")
        notify("Eventos", "Evento skipado!", 2)
    end
end, Colors.Success)
CreateButton(EventsTab, "Evento Global", function()
    if Remotes:FindFirstChild("EventosGlobal") then
        Remotes.EventosGlobal:FireServer("EventoAtual")
        notify("Eventos", "Evento global ativado!", 2)
    end
end, Colors.Success)
CreateButton(EventsTab, "Skip 10x em sequencia", function()
    if Remotes:FindFirstChild("Eventos") then
        for i = 1, 10 do
            Remotes.Eventos:FireServer("EventoAtual")
            task.wait(0.1)
        end
        notify("Eventos", "10x skip!", 2)
    end
end, Colors.Success)

CreateSectionLabel(EventsTab, "Tsunami")
CreateButton(EventsTab, "Tsunami Rain (Tsunami1)", function()
    if Remotes:FindFirstChild("TsunamiRain") then
        Remotes.TsunamiRain:FireServer("Tsunami1")
        notify("Tsunami", "Tsunami1 iniciado!", 2)
    end
end, Colors.Warning)
CreateButton(EventsTab, "Limpar Tsunami", function()
    if Remotes:FindFirstChild("TsunamiClear") then
        Remotes.TsunamiClear:FireServer()
        notify("Tsunami", "Tsunamis limpos!", 2)
    end
end, Colors.Success)

-- ============================
-- ABA: ROLETAS
-- ============================
CreateSectionLabel(RoletaTab, "Bypass de Roleta (resultado vem do client)")
CreateInfoLabel(RoletaTab, "O jogo confia no cliente pra dizer o resultado da roleta", Colors.Warning)

CreateAmountInput(RoletaTab, "Tipo (1=dinheiro, 2=xp, 3=moedas)", 2, function(v)
    if Remotes:FindFirstChild("AcabouRoleta") then
        Remotes.AcabouRoleta:FireServer(v)
        notify("Roleta", "Tipo " .. tostring(v) .. " aplicado!", 2)
    end
end)
CreateButton(RoletaTab, "Rolar dinheiro (tipo 2)", function()
    if Remotes:FindFirstChild("AcabouRoleta") then
        Remotes.AcabouRoleta:FireServer(2)
        notify("Roleta", "Roleta dinheiro!", 2)
    end
end, Colors.Gold)
CreateButton(RoletaTab, "Rolar moedas (tipo 3)", function()
    if Remotes:FindFirstChild("AcabouRoleta") then
        Remotes.AcabouRoleta:FireServer(3)
        notify("Roleta", "Roleta moedas!", 2)
    end
end, Colors.Gold)
CreateButton(RoletaTab, "Rolar 10x", function()
    if Remotes:FindFirstChild("AcabouRoleta") then
        for i = 1, 10 do
            Remotes.AcabouRoleta:FireServer(2)
            task.wait(0.1)
        end
        notify("Roleta", "10x roleta!", 2)
    end
end, Colors.Gold)

-- ============================
-- ABA: ADMIN
-- ============================
CreateSectionLabel(AdminTab, "Funcoes de Admin (server valida? nao kkk)")

CreateButton(AdminTab, "Anuncio Global", function()
    if Remotes:FindFirstChild("AnnouncementGlobal") then
        Remotes.AnnouncementGlobal:FireServer("[ADMIN] " .. LocalPlayer.Name .. " domina o server!")
        notify("Admin", "Anuncio global enviado!", 2)
    end
end, Colors.Warning)
CreateButton(AdminTab, "Poll Global (10s)", function()
    if Remotes:FindFirstChild("Polls") then
        Remotes.Polls:FireServer("Quem eh o melhor?", LocalPlayer.Name, "Outros", 10, "Global")
        notify("Admin", "Poll criado!", 2)
    end
end, Colors.Warning)

CreateSectionLabel(AdminTab, "Countdown")
CreateAmountInput(AdminTab, "Segundos do countdown", 60, function(v)
    if Remotes:FindFirstChild("Countdown") then
        Remotes.Countdown:FireServer("Countdown custom", v, true)
        notify("Countdown", tostring(v) .. " segundos", 2)
    end
end)
CreateButton(AdminTab, "Countdown 60s (urgente)", function()
    if Remotes:FindFirstChild("Countdown") then
        Remotes.Countdown:FireServer("Servidor fechando em...", 60, true)
        notify("Countdown", "60s", 2)
    end
end, Colors.Danger)
CreateButton(AdminTab, "Countdown 10s (critico)", function()
    if Remotes:FindFirstChild("Countdown") then
        Remotes.Countdown:FireServer("ALERTA CRITICO", 10, true)
        notify("Countdown", "10s critico", 2)
    end
end, Colors.Danger)

CreateSectionLabel(AdminTab, "DESTRUIDORES (use com cuidado)")
CreateButton(AdminTab, "SHUTDOWN SERVER", function()
    if Remotes:FindFirstChild("Shutdown") then
        Remotes.Shutdown:FireServer()
        notify("SHUTDOWN", "Comando enviado!", 2)
    end
end, Colors.Danger)
CreateInfoLabel(AdminTab, "AVISO: Shutdown pode derrubar o server inteiro", Colors.Danger)

-- ============================
-- ABA: MISC
-- ============================
CreateSectionLabel(MiscTab, "VIP / Premium")
CreateAmountInput(MiscTab, "User ID (VIP)", 1687267215, function(v)
    if Remotes:FindFirstChild("ConferirVip") then
        Remotes.ConferirVip:FireServer(v)
        notify("VIP", "User " .. tostring(v) .. " virou VIP!", 2)
    end
end)
CreateButton(MiscTab, "Dar VIP pra voce mesmo", function()
    if Remotes:FindFirstChild("ConferirVip") then
        Remotes.ConferirVip:FireServer(LocalPlayer.UserId)
        notify("VIP", "Voce virou VIP!", 2)
    end
end, Colors.Gold)
CreateButton(MiscTab, "Dar VIP pra todos online", function()
    if Remotes:FindFirstChild("ConferirVip") then
        for _, p in pairs(Players:GetPlayers()) do
            Remotes.ConferirVip:FireServer(p.UserId)
            task.wait(0.05)
        end
        notify("VIP", "Todos online viraram VIP!", 2)
    end
end, Colors.Gold)

CreateSectionLabel(MiscTab, "Lucky Block")
CreateButton(MiscTab, "Lucky Block (tool equipado)", function()
    if Remotes:FindFirstChild("LuckyBlock") then
        local t = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if t then
            Remotes.LuckyBlock:FireServer(t)
            notify("Lucky Block", "Tentou abrir " .. t.Name, 2)
        else
            notify("Erro", "Equipe um brainrot primeiro", 2)
        end
    end
end, Colors.Warning)
CreateButton(MiscTab, "Lucky Block 10x", function()
    if Remotes:FindFirstChild("LuckyBlock") then
        local t = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if t then
            for i = 1, 10 do
                Remotes.LuckyBlock:FireServer(t)
                task.wait(0.1)
            end
            notify("Lucky Block", "10x " .. t.Name, 2)
        end
    end
end, Colors.Warning)

CreateSectionLabel(MiscTab, "Sobre")
CreateInfoLabel(MiscTab, "Brainrot Hub v1.0", Colors.Accent)
CreateInfoLabel(MiscTab, "by Mavis  -  8 abas, scroll, inputs custom", Colors.TextDim)
CreateInfoLabel(MiscTab, "Bola minimizar ID: rbxassetid://10747372973", Colors.TextDim)

CreateSectionLabel(MiscTab, "UI")
CreateButton(MiscTab, "Mostrar/Ocultar Bola", function()
    MinimizeBall.Visible = not MinimizeBall.Visible
end)
CreateSecondaryButton(MiscTab, "Resetar Posicao Hub", function()
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
end)
CreateSecondaryButton(MiscTab, "Destruir Hub", function()
    ScreenGui:Destroy()
end)

-- ============================
-- SCROLL POR TECLADO
-- ============================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local keyName = input.KeyCode.Name

    if CurrentTab and Tabs[CurrentTab] then
        local tab = Tabs[CurrentTab]
        if keyName == "Up" then tab.ScrollBy(-40)
        elseif keyName == "Down" then tab.ScrollBy(40)
        elseif keyName == "PageUp" then tab.ScrollBy(-200)
        elseif keyName == "PageDown" then tab.ScrollBy(200)
        elseif keyName == "Home" then
            tab.Content.CanvasPosition = Vector2.new(0, 0)
        elseif keyName == "End" then
            local max = math.max(0, tab.Content.AbsoluteCanvasSize.Y - tab.Content.AbsoluteSize.Y)
            tab.Content.CanvasPosition = Vector2.new(0, max)
        end
    end
end)

notify("Brainrot Hub v1.0", "Carregado! 8 abas, scroll, inputs custom. by Mavis", 4)
print("[BrainrotHub v1.0] Carregado! Bola minimizar: rbxassetid://10747372973")
print("[BrainrotHub v1.0] Remotes usados: UpdateLeaderstatsAdicionar, UpdateLeaderstats, UpgradeBuy, Rebirth, SpawnThing, SpawnThingRace, AcabouRoleta, Eventos, etc")

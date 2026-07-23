-- ============================
-- ABA: ROUBAR (NOVA)
-- ============================
local StealTab = CreateTab("Roubar", 9)

CreateSectionLabel(StealTab, "Roubar Brainrot (bypass pagamento)")

CreateInfoLabel(StealTab, "Selecione um jogador e um slot para roubar o brainrot dele", Colors.Warning)
CreateInfoLabel(StealTab, "ATENÇÃO: Você precisa estar perto da base do alvo", Colors.Danger)

-- Input do jogador alvo
local TargetRow = Instance.new("Frame")
TargetRow.Size = UDim2.new(1, 0, 0, 40)
TargetRow.BackgroundColor3 = Colors.Element
TargetRow.BackgroundTransparency = 0.40
TargetRow.BorderSizePixel = 0
TargetRow.ZIndex = 9
TargetRow.Parent = StealTab
Corner(TargetRow, 6)
Stroke(TargetRow, Colors.Border, 1)

local TargetLbl = Instance.new("TextLabel")
TargetLbl.Size = UDim2.new(0, 80, 1, 0)
TargetLbl.Position = UDim2.new(0, 12, 0, 0)
TargetLbl.BackgroundTransparency = 1
TargetLbl.Text = "Alvo:"
TargetLbl.TextColor3 = Colors.Text
TargetLbl.TextSize = 12
TargetLbl.Font = Enum.Font.Gotham
TargetLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetLbl.ZIndex = 10
TargetLbl.Parent = TargetRow

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(0, 180, 0, 26)
TargetInput.Position = UDim2.new(0, 70, 0.5, -13)
TargetInput.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TargetInput.BorderSizePixel = 0
TargetInput.Text = ""
TargetInput.PlaceholderText = "Nome do jogador"
TargetInput.TextColor3 = Colors.Accent
TargetInput.TextSize = 13
TargetInput.Font = Enum.Font.GothamBold
TargetInput.ClearTextOnFocus = false
TargetInput.ZIndex = 10
TargetInput.Parent = TargetRow
Corner(TargetInput, 4)

-- Input do slot
local SlotRow = Instance.new("Frame")
SlotRow.Size = UDim2.new(1, 0, 0, 40)
SlotRow.BackgroundColor3 = Colors.Element
SlotRow.BackgroundTransparency = 0.40
SlotRow.BorderSizePixel = 0
SlotRow.ZIndex = 9
SlotRow.Parent = StealTab
Corner(SlotRow, 6)
Stroke(SlotRow, Colors.Border, 1)

local SlotLbl = Instance.new("TextLabel")
SlotLbl.Size = UDim2.new(0, 80, 1, 0)
SlotLbl.Position = UDim2.new(0, 12, 0, 0)
SlotLbl.BackgroundTransparency = 1
SlotLbl.Text = "Slot:"
SlotLbl.TextColor3 = Colors.Text
SlotLbl.TextSize = 12
SlotLbl.Font = Enum.Font.Gotham
SlotLbl.TextXAlignment = Enum.TextXAlignment.Left
SlotLbl.ZIndex = 10
SlotLbl.Parent = SlotRow

local SlotInput = Instance.new("TextBox")
SlotInput.Size = UDim2.new(0, 180, 0, 26)
SlotInput.Position = UDim2.new(0, 70, 0.5, -13)
SlotInput.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
SlotInput.BorderSizePixel = 0
SlotInput.Text = "Slot1"
SlotInput.PlaceholderText = "Ex: Slot1, Slot2..."
SlotInput.TextColor3 = Colors.Accent
SlotInput.TextSize = 13
SlotInput.Font = Enum.Font.GothamBold
SlotInput.ClearTextOnFocus = false
SlotInput.ZIndex = 10
SlotInput.Parent = SlotRow
Corner(SlotInput, 4)

-- Botão principal de roubar
CreateButton(StealTab, "ROUBAR BRAINROT (FREE)", function()
    local targetName = TargetInput.Text
    local slotName = SlotInput.Text
    
    if targetName == "" or targetName == LocalPlayer.Name then
        notify("Erro", "Digite um nome válido (não pode ser você)", 2)
        return
    end
    if slotName == "" then
        notify("Erro", "Digite o nome do slot", 2)
        return
    end
    
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then
        notify("Erro", "Jogador '" .. targetName .. "' não encontrado", 2)
        return
    end
    
    -- Encontra a base do alvo
    local targetBase = nil
    local targetPlayerValue = nil
    for _, base in pairs(workspace.Bases:GetChildren()) do
        local config = base:FindFirstChild("Configuration")
        if config then
            local playerVal = config:FindFirstChild("Player")
            if playerVal and playerVal.Value == targetName then
                targetBase = base
                targetPlayerValue = playerVal
                break
            end
        end
    end
    
    if not targetBase then
        notify("Erro", "Base do jogador não encontrada", 2)
        return
    end
    
    local slot = targetBase.Slots:FindFirstChild(slotName)
    if not slot then
        notify("Erro", "Slot '" .. slotName .. "' não encontrado na base", 2)
        return
    end
    
    -- Verifica se tem brainrot no slot
    local brainrotFolder = slot:FindFirstChild("Brainrot")
    if not brainrotFolder or #brainrotFolder:GetChildren() == 0 then
        notify("Erro", "Slot vazio (sem brainrot)", 2)
        return
    end
    
    -- Pega a raridade do brainrot para enviar productId fake
    local brainrotModel = brainrotFolder:FindFirstChildOfClass("Model")
    local raridadeValue = brainrotModel and brainrotModel:FindFirstChild("raridade")
    local productId = 0 -- default/fake
    
    if raridadeValue then
        -- Tenta pegar o productId real da tabela de raridades via Remote
        local success, raridades = pcall(function()
            return ReplicatedStorage.Remotes.GetRaridades:Invoke()
        end)
        if success and raridades and raridades[raridadeValue.Value] then
            productId = raridades[raridadeValue.Value].productId or 0
        end
    end
    
    -- BYPASS: O servidor espera que o cliente processe a compra Robux,
    -- mas não valida se o pagamento realmente aconteceu!
    -- Basta enviar o evento Comprar de volta com os dados corretos.
    
    if Remotes:FindFirstChild("Comprar") then
        Remotes.Comprar:FireServer(productId, slotName, targetName)
        notify("Roubar", "Enviando roubo de " .. brainrotModel.Name .. "...", 2)
    else
        notify("Erro", "Remote Comprar não encontrado", 2)
    end
end, Colors.Danger)

CreateInfoLabel(StealTab, "O servidor não valida pagamento Robux — bypass direto", Colors.Success)

CreateSectionLabel(StealTab, "Auto-Scan Bases")

CreateButton(StealTab, "Listar Bases Ocupadas", function()
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
                table.insert(basesInfo, {
                    nome = base.Name,
                    dono = playerVal.Value,
                    slots = slotsOcupados
                })
            end
        end
    end
    
    if #basesInfo == 0 then
        notify("Scan", "Nenhuma base ocupada encontrada", 2)
        return
    end
    
    -- Mostra no console
    print("=" .. string.rep("=", 40))
    print("BASES OCUPADAS:")
    for _, info in ipairs(basesInfo) do
        print(string.format("  %s | Dono: %s | Slots: %d", info.nome, info.dono, info.slots))
    end
    print("=" .. string.rep("=", 40))
    
    notify("Scan", #basesInfo .. " bases ocupadas (veja console F9)", 3)
end)

CreateButton(StealTab, "Roubar TODOS os slots de um alvo", function()
    local targetName = TargetInput.Text
    if targetName == "" or targetName == LocalPlayer.Name then
        notify("Erro", "Digite um nome válido", 2)
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
    
    notify("Roubar", "Tentou roubar " .. roubados .. " brainrots de " .. targetName, 3)
end, Colors.Danger)

CreateSectionLabel(StealTab, "Auto-Roubar (loop)")

local AutoStealEnabled = false
local AutoStealBtn = CreateButton(StealTab, "Auto-Roubar: OFF", function()
    AutoStealEnabled = not AutoStealEnabled
    AutoStealBtn.Text = AutoStealEnabled and "Auto-Roubar: ON" or "Auto-Roubar: OFF"
    AutoStealBtn.BackgroundColor3 = AutoStealEnabled and Colors.Danger or Colors.Accent
    
    if AutoStealEnabled then
        notify("Auto-Roubar", "Ativado! Roubando slots ocupados...", 2)
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

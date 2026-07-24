-- ============================
-- BRAINROT STEAL SCRIPT (STANDALONE)
-- Funciona sem dependências de GUI Framework
-- ============================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Função de notificação simples
local function notify(title, message, duration)
    print("[" .. title .. "] " .. message)
end

-- Encontra remotes
local function findRemotes()
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not Remotes then
        print("[ERRO] Remotes não encontrado!")
        return nil
    end
    return Remotes
end

-- ============================
-- FUNÇÃO: Roubar um slot específico
-- ============================
local function stealSlot(targetName, slotName)
    local Remotes = findRemotes()
    if not Remotes then return end
    
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
    
    -- Pega a raridade do brainrot
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
    
    -- Envia o roubo
    if Remotes:FindFirstChild("Comprar") then
        Remotes.Comprar:FireServer(productId, slotName, targetName)
        notify("Roubar", "Enviando roubo de " .. (brainrotModel and brainrotModel.Name or "Brainrot") .. "...", 2)
    else
        notify("Erro", "Remote Comprar não encontrado", 2)
    end
end

-- ============================
-- FUNÇÃO: Listar bases ocupadas
-- ============================
local function listOccupiedBases()
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
    
    print("=" .. string.rep("=", 50))
    print("BASES OCUPADAS:")
    for _, info in ipairs(basesInfo) do
        print(string.format("  [%s] Dono: %s | Slots: %d", info.nome, info.dono, info.slots))
    end
    print("=" .. string.rep("=", 50))
    
    notify("Scan", #basesInfo .. " bases ocupadas", 3)
end

-- ============================
-- FUNÇÃO: Roubar todos os slots de um alvo
-- ============================
local function stealAllSlots(targetName)
    local Remotes = findRemotes()
    if not Remotes then return end
    
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
end

-- ============================
-- FUNÇÃO: Auto-roubar (loop)
-- ============================
local AutoStealEnabled = false
local function toggleAutoSteal()
    AutoStealEnabled = not AutoStealEnabled
    
    if AutoStealEnabled then
        notify("Auto-Roubar", "ATIVADO!", 2)
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
                                    
                                    local Remotes = findRemotes()
                                    if Remotes and Remotes:FindFirstChild("Comprar") then
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
        notify("Auto-Roubar", "DESATIVADO", 2)
    end
end

-- ============================
-- HOTKEYS
-- ============================
print("\n[BRAINROT STEAL SCRIPT]")
print("Comandos disponíveis:")
print("  stealSlot('player', 'Slot1') - Roubar um slot específico")
print("  stealAllSlots('player') - Roubar todos os slots")
print("  listOccupiedBases() - Listar bases ocupadas")
print("  toggleAutoSteal() - Ativar/desativar auto-roubo")
print("\nExemplo: stealSlot('João', 'Slot1')\n")

-- Tornar funções globais
_G.stealSlot = stealSlot
_G.stealAllSlots = stealAllSlots
_G.listOccupiedBases = listOccupiedBases
_G.toggleAutoSteal = toggleAutoSteal

notify("Script", "Carregado com sucesso!", 3)

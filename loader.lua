-- ============================
-- BRAINROT STEAL SCRIPT
-- LOADSTRING LOADER
-- ============================

local scriptUrl = "https://raw.githubusercontent.com/samyyyzne/Script-Hub-Soloxiz/main/brainrot-steal.lua"

-- Função para carregar o script
local function loadScript()
    local success, result = pcall(function()
        return game:HttpGet(scriptUrl)
    end)
    
    if success then
        print("[✓] Script carregado com sucesso!")
        local executeSuccess, executeResult = pcall(function()
            loadstring(result)()
        end)
        
        if executeSuccess then
            print("[✓] Script executado com sucesso!")
        else
            print("[✗] Erro ao executar script: " .. tostring(executeResult))
        end
    else
        print("[✗] Erro ao carregar script: " .. tostring(result))
    end
end

-- Executar
loadScript()

print("[INFO] Use este comando para carregar o script:")
print('loadstring(game:HttpGet("https://raw.githubusercontent.com/samyyyzne/Script-Hub-Soloxiz/main/brainrot-steal.lua"))()')

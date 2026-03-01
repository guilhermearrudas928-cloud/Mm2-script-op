local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 SCRIPT OP",
   LoadingTitle = "CYDEX HUB",
   LoadingSubtitle = "by CYDEX_PLAYER01",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CYDEX_MM2_CONFIGS", -- Nome da pasta que vai criar no seu executor
      FileName = "MainConfig"
   },
   KeySystem = true,
   KeySettings = {
      Title = "Sistema de Chave",
      Subtitle = "A chave é: cydex123",
      Note = "CYDEX_PLAYER01 no YouTube!",
      FileName = "CydexKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"cydex123"}
   }
})

-- ABAS LATERAIS
local VisualsTab = Window:CreateTab("Visuais", 4483362458)
local CombatTab = Window:CreateTab("Combate", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)
local ConfigTab = Window:CreateTab("Configurações", 4483362458)

--- [[ TOGGLES COM SAVE ]] ---

-- ABA VISUAIS
VisualsTab:CreateToggle({
   Name = "ESP Lines (Linhas)",
   CurrentValue = false,
   Flag = "ESP_Save", -- A Flag é o que salva a configuração!
   Callback = function(Value)
       _G.ESP_Lines = Value
   end,
})

-- ABA COMBATE
CombatTab:CreateToggle({
   Name = "Silent Aim (Sheriff)",
   CurrentValue = false,
   Flag = "SilentAim_Save",
   Callback = function(Value) 
       _G.SilentAim = Value 
   end,
})

-- ABA FARM
FarmTab:CreateToggle({
   Name = "Auto-Farm (Moedas)",
   CurrentValue = false,
   Flag = "AutoFarm_Save",
   Callback = function(Value) 
       _G.AutoFarm = Value 
   end,
})

--- [[ SEÇÃO DE CONFIGURAÇÃO (SAVE/LOAD) ]] ---

ConfigTab:CreateSection("Gerenciar Configurações")

ConfigTab:CreateButton({
   Name = "Salvar Configurações Atuais",
   Callback = function()
       Rayfield:SaveConfiguration()
       Rayfield:Notify({
          Title = "Configuração Salva!",
          Content = "Suas escolhas foram salvas na pasta CYDEX_MM2_CONFIGS",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})

ConfigTab:CreateButton({
   Name = "Carregar Configurações",
   Callback = function()
       Rayfield:LoadConfiguration()
   end,
})

-- [[ ANTI-AFK AUTOMÁTICO SEMPRE ON ]] --
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:LoadConfiguration() -- Tenta carregar as configs assim que abre o script

